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
  correctly, but plain `git clone` never leaves one — it writes refs and
  finishes before any hook fires.
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

## Open Questions

- `git-localhost-clone` is MVP scope: single default branch, no
  `--branch`/`--depth`/`--recurse-submodules`. Fine for now; revisit if
  a real case needs one of those.
