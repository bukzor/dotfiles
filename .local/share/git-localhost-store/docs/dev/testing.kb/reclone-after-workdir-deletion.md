# Test: Reclone After Workdir Deletion

What it tests: the realistic trigger for the "store already exists"
conflict path — `rm -r` a workdir (store survives, that's the whole
point), then `git clone` the same URL back to the same path. As of
2026-07-11, plain `git clone` no longer refuses unconditionally. A real
`git clone` only ever writes two things: `refs/remotes/*` (an
unconditional mirror of the remote) and exactly one local branch —
whatever `HEAD` points at (see `builtin/clone.c`: `write_remote_refs()`
writes only `refs/remotes/origin/*`; `update_head()` writes only
`refs/heads/<default>`, unconditionally, to match). Nothing else in a
fresh `.git` from a real clone ever collides with pre-existing store
content, so the recovery path applies two different rules:

- `refs/remotes/*` (and any symrefs under it): force-synced from the
  fresh clone into the store, always, no divergence check — same as any
  ordinary `git fetch` with a `+` refspec. Ahead, behind, or diverged
  from the store's prior value, it doesn't matter.
- `refs/heads/<default>`: the one ref that can actually collide. Compared
  directly against the store's value via `merge-base --is-ancestor` in
  both directions (not via `git fetch`'s fast-forward check — see "Why
  not just `git fetch`" below for why that's insufficient) — fast-forward
  if the store is behind, leave untouched if the store is ahead
  (unpushed local work), refuse only on genuine divergence.
- Anything else under `refs/heads/*` (any name besides the recognized
  default branch) is a shape a real clone never produces. Rather than
  silently ignoring it, `git-localhost-store` refuses — see `edge-cases.md`
  for the direct test of this.

Unlike `edge-cases.md`'s "Conflicting state" test (a hand-planted fake
ref), the conflicting/compatible refs here come from an ordinary `git
clone` — the actual incident this guards against (2026-07-09: an agent
hit the old blanket refusal on a real re-clone and resolved it by
deleting the stale store solo, without asking).

## Scenario A: compatible re-clone (auto-merges, no human needed)

```bash
ORIGIN=~/trash/test-reclone-origin
TEST_DIR=~/trash/test-reclone-compat
STORE="${XDG_STATE_HOME:-$HOME/.local/state}/git-localhost-store/repos/$(claude-path "$TEST_DIR")"
rm -r "$ORIGIN" "$TEST_DIR" "$STORE"

mkdir -p "$ORIGIN" && cd "$ORIGIN"
git init -q
git -c user.email=t@t -c user.name=t commit -q --allow-empty -m v1
git clone -q "$ORIGIN" "$TEST_DIR"       # store gets created

rm -r "$TEST_DIR"                        # store survives
cd "$ORIGIN" && git commit -q --allow-empty -m v2   # origin moves forward; no local-only work sits in the store

git clone -q "$ORIGIN" "$TEST_DIR"       # re-clone: origin is a clean fast-forward of what the store has
```

### Expected

- Exits 0, stderr shows `git-localhost-store: ✓ Recovered: .git -> $STORE`
  — no refusal.
- `$TEST_DIR/.git` is a symlink to `$STORE`.
- `git -C "$TEST_DIR" log --oneline -1` shows v2 (the store's
  `refs/heads/main` fast-forwarded to match origin).
- `git -C "$TEST_DIR" status -s .` is clean.

## Scenario A2: store ahead of the fresh clone (unpushed local work, origin unchanged)

The case Scenario A doesn't cover: the store has commits the remote
never saw, and the remote hasn't moved. This is the one this recovery
design exists to protect — and the one a naive `git fetch`-based merge
gets wrong (see "Why not just `git fetch`" below).

```bash
ORIGIN=~/trash/test-reclone-origin
TEST_DIR=~/trash/test-reclone-behind
STORE="${XDG_STATE_HOME:-$HOME/.local/state}/git-localhost-store/repos/$(claude-path "$TEST_DIR")"
rm -r "$ORIGIN" "$TEST_DIR" "$STORE"

mkdir -p "$ORIGIN" && cd "$ORIGIN"
git init -q
git -c user.email=t@t -c user.name=t commit -q --allow-empty -m v1
git clone -q "$ORIGIN" "$TEST_DIR"

# Advance the store's local branch beyond origin (unpushed work);
# origin stays at v1.
git -C "$TEST_DIR" -c user.email=t@t -c user.name=t commit -q --allow-empty -m unpushed
rm -r "$TEST_DIR"

git clone -q "$ORIGIN" "$TEST_DIR"       # fresh clone brings back only v1 -- behind the store
```

### Expected

- Exits 0, stderr shows `git-localhost-store: ✓ Recovered: .git -> $STORE`
  — no refusal, even though the fresh clone's `refs/heads/main` is
  strictly behind the store's.
- `$TEST_DIR/.git` is a symlink to `$STORE`.
- `git -C "$TEST_DIR" log --oneline -1` still shows `unpushed` — the
  store's local branch is left untouched, nothing lost.
- `git -C "$STORE" log --oneline -1 refs/remotes/origin/main` shows v1 —
  the remote-tracking ref still force-updates independently, even though
  the local branch didn't move.

## Scenario B: genuine divergence (still refuses, local branch left untouched)

```bash
ORIGIN=~/trash/test-reclone-origin
TEST_DIR=~/trash/test-reclone-diverge
STORE="${XDG_STATE_HOME:-$HOME/.local/state}/git-localhost-store/repos/$(claude-path "$TEST_DIR")"
rm -r "$ORIGIN" "$TEST_DIR" "$STORE"

mkdir -p "$ORIGIN" && cd "$ORIGIN"
git init -q
git -c user.email=t@t -c user.name=t commit -q --allow-empty -m v1
git clone -q "$ORIGIN" "$TEST_DIR"

# Simulate forgotten local WIP: commit directly in the workdir, then delete
# the workdir without pushing -- the store keeps the only copy.
git -C "$TEST_DIR" -c user.email=t@t -c user.name=t commit -q --allow-empty -m store-only-wip
rm -r "$TEST_DIR"

# Origin advances independently -- a sibling of the WIP commit, not a
# descendant of it, so there's no way to fast-forward one onto the other.
cd "$ORIGIN" && git commit -q --allow-empty -m v2-independent

git clone -q "$ORIGIN" "$TEST_DIR"
```

### Expected

- Exits non-zero. Unlike the old `reference-transaction` trigger (whose
  failure never reached `git clone`'s own exit code -- the hook's stderr
  was the only signal), `post-checkout`'s failure *does* propagate to
  `git clone`'s exit status (verified 2026-07-13, part of the
  quiescent-point hook redesign). This is a deliberate improvement: a
  script or CI step that only checks `git clone`'s exit code can no
  longer sail past a "needs a human" refusal.
- Stderr shows `git-localhost-store: ❌ .git has local branches that
  diverge from existing store: ...` / `refs/heads/main: store=<sha>
  fresh=<sha>` / `Needs a human decision.`
- `$TEST_DIR/.git` is a real directory (not a symlink) — unrelocated.
- `$STORE`'s `refs/heads/main` is **unchanged**, still at `store-only-wip`.
- `$STORE`'s `refs/remotes/origin/main` **does** update to
  `v2-independent` — rule 1 (remote-tracking refs) is unconditional and
  independent of rule 2 (local branch); a refusal on the local branch
  doesn't roll back the remote-tracking update. There's no data-loss risk
  in letting it through: it's a cache of "what does the remote say," and
  what the remote says just changed.

## Why not just `git fetch --atomic 'refs/*:refs/*'`

An earlier version of this fix used one `git fetch --atomic` matching
every ref at once. Two problems, found by actually running the "store
ahead" case (Scenario A2) against it:

- `git fetch`'s non-force ref-update check only asks "is the new value a
  descendant of the old value" (a genuine fast-forward). It can't tell
  "old value is a descendant of new value" (store is ahead — harmless,
  nothing to do) apart from real divergence (neither is a descendant of
  the other) — both come back as an identical `non-fast-forward`
  rejection. A blanket fetch-based merge treats Scenario A2 exactly like
  Scenario B: refuses on unpushed local work that was never actually at
  risk.
- `--atomic` across a wildcard `refs/*:refs/*` means one incidental
  rejection anywhere (even something as harmless as a symref) blocks
  every ref in the batch, including remote-tracking refs that have no
  business being gated behind a local branch's fast-forward status.

The fix: don't ask `git fetch` to adjudicate. Force-sync
`refs/remotes/*` unconditionally (rule 1, no ambiguity possible), and
compare the one ref that can actually collide (`refs/heads/<default>`)
directly with `merge-base --is-ancestor` in both directions (rule 2),
so "store is ahead" and "genuinely diverged" are distinguished instead
of conflated. See `bin/git-localhost-store`'s recovery branch.

This fetch (and the direct `rev-parse`/`merge-base`/`update-ref` calls in
rule 2) target the store directly via an explicit `GIT_DIR` override —
hooks otherwise run with `GIT_DIR` already pointed at the *fresh* `.git`,
which silently defeats a naive `git -C "$STORE"`. A store created before
the 2026-07-13 hook redesign may still carry its own real
`reference-transaction` hook, which this fetch/update-ref traffic would
otherwise fire recursively -- `bin/git-localhost-store`'s
`GIT_LOCALHOST_STORE_ACTIVE` env guard caps that at one no-op level; see
`merge-fetch-recurses-through-store-hooks.md` for why that's
load-bearing, not defensive programming, and how to test *that* safely.

## Why plain `git clone` can't be made to *never* refuse

Not for lack of an early-enough hook -- `reference-transaction` (retired
2026-07-13) used to fire before clone's first ref lands. Confirmed
(2026-07-11 devlog) that using it to swap `.git` for the store
mid-transaction crashes `git clone` itself (`BUG:
refs/files-backend.c:3072: initial ref transaction called with existing
refs`, aborts) -- its internal state machine assumes uninterrupted
ownership of the gitdir from `init` through fetch. Clone can't be
interposed on mid-transaction, hook or no hook.

The current trigger is `post-checkout`, which fires at the very end of
`git clone` -- by then, clone has already written both `refs/remotes/*`
and `refs/heads/<default>` (its ref-transaction is long since committed),
so there's no in-flight state left to disrupt. This is *not* symmetric
with `git commit`: `post-index-change` also fires during clone's
internal checkout (as it does during commit), but since clone's own
refs already landed before checkout begins, letting `post-index-change`
do the real merge work here would be safe too -- the relocator instead
defers uniformly (any hook named `post-index-change` skips the
store-exists branch entirely, see `bin/git-localhost-store`), because
the *same* deferral is unconditionally required for `git commit` (see
`recovery-after-deletion.md`'s "How recovery is triggered" and the note
below it) and one uniform rule beats one that's conditionally safe
depending on which porcelain command triggered it. The visible effect:
during a recovering `git clone`, `post-index-change` fires first, prints
a "deferring" note, and does nothing; `post-checkout` fires moments
later and does the actual merge (Scenario A/A2/B above).

Genuine divergence (Scenario B) still needs a human — there's no
principled way to pick a winner between two histories that both moved.
