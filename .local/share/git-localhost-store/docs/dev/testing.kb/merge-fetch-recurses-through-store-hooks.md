# Test: Merge-Fetch Recurses Through Store Hooks

What it tests: that the recovery merge in `bin/git-localhost-store` (see
`reclone-after-workdir-deletion.md`) — a `git fetch` for
`refs/remotes/*`, plus `git update-ref` calls for the one local branch
that can collide — does not trigger the *store's own* hooks, which would
call `bin/git-localhost-store` again, recursively, without a base case.

## Background

Before the 2026-07-13 quiescent-point hook redesign, every store was
created with a live `hooks/reference-transaction` installed (copied at
`init.templateDir` time). The recovery merge writes refs *into* the
store to reconcile state: `git fetch` for `refs/remotes/*`, and `git
update-ref` for `refs/heads/<default>` when it fast-forwards or is newly
created. Either kind of write fired `reference-transaction` -- on the
store, not the fresh clone. That hook called `bin/git-localhost-store`
again; the nested call inherited `GIT_DIR` pointed at the store from the
hook's environment, so it could resolve back to the *same* store and
recurse into itself.

**This actually happened** (2026-07-11): a `git fetch` issued from
`bin/git-localhost-store` directly into a real store, before any
suppression was in place, produced thousands of recursively-spawned
`bin/git-localhost-store` → `git fetch` → `git-upload-pack` → store's
`reference-transaction` → `bin/git-localhost-store` chains, still
growing well after the triggering command had already returned control.
Not a theoretical risk — treat this test as load-bearing whenever the
recovery-merge code path changes (the fetch call, or the `update-ref`
calls added alongside it).

New stores (created after the 2026-07-13 redesign) never install
`reference-transaction` at all -- the trio is `post-index-change`,
`post-commit`, `post-checkout`, none of which fire on a `fetch`/
`update-ref` targeting a *different* gitdir. But existing repos retain
whatever hooks were copied at their clone time (per this project's own
CLAUDE.md: hooks only update on re-init) -- a store created before the
redesign still carries a real `reference-transaction` file, and will for
as long as that store exists. The test below plants one by hand to
simulate that vintage; that's not contrived, it's the actual shape of
every pre-2026-07-13 store still on disk.

## Dead end — don't retry it

`core.hooksPath` does **not** suppress `reference-transaction` during
`fetch` in git 2.49.0 — verified both as a transient `-c
core.hooksPath=` override and as a persisted `git config
core.hooksPath` value, against a real bare repo with a logging
`reference-transaction` hook, with the log correctly cleared *after* any
setup ref-writes so leftover firings aren't misattributed. (The same
override *does* suppress `pre-commit` during `git commit` — this is
specific to `reference-transaction` + `fetch`, not a broken mechanism in
general, so it's tempting to reach for again. Don't; it's been checked.)

## The fix

`bin/git-localhost-store` exports `GIT_LOCALHOST_STORE_ACTIVE=1` before
doing anything else, and exits immediately if it's already set. Hooks
inherit the environment of the git process that runs them, and the
recovery merge's fetch/update-ref calls are direct children of
`bin/git-localhost-store` -- so the nested invocation (fired by the
store's stale `reference-transaction`) inherits the flag and no-ops.
Recursion is capped at 1 by construction, for any store regardless of
hook vintage. This replaced an earlier fix (move the store's `hooks/`
directory aside, restore via `trap ... EXIT`) that worked but added a
crash-mid-fetch failure mode (hooks left permanently disabled) and ~35
lines this test no longer needs to cover.

## How to test this safely

This is a fork-bomb hazard if the fix regresses. Take real precautions —
isolate the store tree via `XDG_STATE_HOME` (see
`testing.kb/CLAUDE.md` -- never let this touch the real
`~/.local/state`), bound the clone with `timeout`, and check process
counts immediately after before doing anything else:

```bash
export XDG_STATE_HOME=~/trash/test-state-home
ORIGIN=~/trash/test-hookrecurse-origin
TEST_DIR=~/trash/test-hookrecurse
STORE="${XDG_STATE_HOME:-$HOME/.local/state}/git-localhost-store/repos/$(claude-path "$TEST_DIR")"
rm -r "$ORIGIN" "$TEST_DIR" "$STORE"

mkdir -p "$ORIGIN" && cd "$ORIGIN"
git init -q
git -c user.email=t@t -c user.name=t commit -q --allow-empty -m v1
git clone -q "$ORIGIN" "$TEST_DIR"        # store created, with the current (safe) hook trio

# Simulate a pre-redesign store: plant a real reference-transaction hook,
# the shape every store created before 2026-07-13 still carries.
cat > "$STORE/hooks/reference-transaction" <<'HOOK'
#!/bin/bash
set -euo pipefail
[ "${1:-}" = committed ] || exit 0
{ [ -L .git ] || [ -f .git ]; } && exit 0
exec "${XDG_DATA_HOME:-$HOME/.local/share}/git-localhost-store/bin/git-localhost-store"
HOOK
chmod +x "$STORE/hooks/reference-transaction"

rm -r "$TEST_DIR"
cd "$ORIGIN" && git commit -q --allow-empty -m v2   # clean ff, so the merge path actually fires

timeout 20 git clone -q "$ORIGIN" "$TEST_DIR"
echo "clone exit=$?"
```

Immediately after:

```bash
ps -eo pid,ppid,etimes,cmd | grep -c '[g]it-localhost-store\|[g]it fetch --atomic'
```

Expect `0`. Re-run the check a few seconds later — a real recursion keeps
growing, so a stable `0` (not just a momentary low number) is the actual
signal.

### If it's not 0 and climbing

Don't use `pkill -f <pattern>` to clean up — if the pattern text appears
in the literal command you're typing to kill it (it usually does, since
you just typed the same string), `pkill -f` matches and kills *that
invocation too*, so you can't tell what actually got cleaned up.  Exclude
your own PID explicitly instead:

```bash
mine=$$
pgrep -f 'git-localhost-store/bin/git-localhost-store' | grep -vx "$mine" | xargs -r kill -9
```

Re-check the count; repeat with any other matching pattern (`git fetch
--atomic`, the specific `$TEST_DIR` path) until it's genuinely,
stably zero.

## Expected (fix working)

- `timeout 20 git clone` exits well before the timeout, exit 0.
- Process count check comes back `0` and stays `0` on re-check.
- `$TEST_DIR/.git` is a symlink to `$STORE`; `git -C "$TEST_DIR" log
  --oneline -1` shows v2.
- `$STORE/hooks/reference-transaction` is untouched throughout -- it was
  never moved aside (there's nothing to move now), it just fired once
  (on the nested invocation) and no-op'd via the env guard.
