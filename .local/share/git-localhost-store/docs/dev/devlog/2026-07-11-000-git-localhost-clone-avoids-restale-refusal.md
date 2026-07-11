# Devlog: 2026-07-11

## Focus

An agent hit the "store already exists" refusal during unrelated work
(2026-07-09, re-cloning a scratch dotfiles checkout), resolved it by
deleting the stale store on its own judgment, and only told the user
afterward. Follow-up: harden the refusal so agents don't do that again,
and see if the trigger itself is avoidable.

## What Happened

### Completed

- Reproduced the real trigger: `rm -r` a workdir (store survives by
  design), `git clone` the same URL back to the same path — refuses,
  because the fresh clone's own refs conflict with the surviving store's.
  Confirmed via `git-localhost-store`'s existing recovery branch that the
  *only* problem is timing: recovery already handles a ref-less `.git`
  correctly, but plain `git clone` never leaves one long enough to be
  usable — see follow-up below for why.
- Added `bin/git-localhost-clone`: `git init` + attach to any existing
  store (via the existing recovery path, which fires clean on a fresh
  ref-less `.git`) + `remote add` + `fetch` + checkout. Verified against
  the realistic trigger, including a hard-diverged case (amended/rewritten
  origin) — fetch always updates `refs/remotes/origin/*` safely; local
  branches are never auto-reset, even on a plain fast-forward.
- Tightened the refusal message: "Resolve manually." → "Needs a human
  decision." ("manually" read, in the moment, as "by me" rather than
  "by escalating.")
- New test: `docs/dev/testing.kb/reclone-after-workdir-deletion.md`.
- `CLAUDE.md`: added `git-localhost-clone` to Related Files; sharpened
  the "don't quietly accommodate" bullet to name the refusal itself as
  the human-decision point.

## Decisions Made

### Fix timing, not just wording

**Rationale:** the refusal is correct given what plain `git clone` hands
it — two independent, already-committed ref sets with no principled way
to pick a winner. Message-hardening alone leaves the trigger intact for
the next agent in a hurry.
**Alternatives:** `git clone --separate-git-dir=` reintroduces the
gitfile layout this project deliberately moved away from (naive `.git/`
readers break). Pre-placing the symlink and calling plain `git clone`
doesn't work — clone refuses on a non-empty target dir.
**Impact:** re-clones of a `rm -r`'d path now go through
`git-localhost-clone`, or hit an unambiguous, sharper refusal if they
don't.

## Follow-up: is there an earlier hook point after all?

Challenged the "finishes before any hook fires" claim above — it was
asserted, not measured. Built a template dir stubbing all 27 hook names
`git help -m hooks` lists, each logging its own invocation (name, args,
stdin, on-disk ref state) to a shared file; pointed `-c
init.templateDir=` at it for a real `git clone`. Result: during clone,
only 3 hooks ever fire — `reference-transaction` (repeatedly),
`post-index-change`, `post-checkout` — exactly the 3 this project already
installs. Nothing was missed.

More importantly: `reference-transaction`'s `prepared` state *does* fire
before any ref lands on disk — including the very first ref of the whole
clone (`refs/remotes/origin/<branch>`, stdin shows `old=000...0`). So a
hook point earlier than "after clone finishes" genuinely exists — the
original framing was wrong on timing.

Tested using it anyway: made that first `prepared` call perform the live
`.git` → store-symlink swap. Result: `git clone` itself hits an internal
assertion and aborts —
`BUG: refs/files-backend.c:3072: initial ref transaction called with
existing refs`, `Aborted (core dumped)`. Worse than a crash: the crash
happens *after* the swap (store adoption succeeds) but *before* fetch
writes anything, so the workdir is left attached to the store, `git
status` reports "up to date with origin/main" — and it isn't. Silent
staleness dressed as success, discoverable only by noticing a scrolled-by
core-dump line.

**Conclusion:** the hook exists; using it doesn't work. `git clone`'s
internal state machine isn't reentrant against its own gitdir changing
underneath it mid-transaction — it assumes exclusive, uninterrupted
ownership from `git init` through fetch completion. `git-localhost-clone`
isn't working around a missing hook point; it's working around clone
being a single non-interruptible unit that cannot safely be interposed
on at all, hook or no hook. Confirmed empirically, not just argued.

## Open Questions

- `git-localhost-clone` is MVP scope: single default branch, no
  `--branch`/`--depth`/`--recurse-submodules`. Fine for now; revisit if
  a real case needs one of those.
