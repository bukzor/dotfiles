# Test: Merge-Fetch Recurses Through Store Hooks

What it tests: that the recovery merge in `bin/git-localhost-store` (see
`reclone-after-workdir-deletion.md`) — a `git fetch` for
`refs/remotes/*`, plus `git update-ref` calls for the one local branch
that can collide — does not trigger the *store's own* hooks, which would
call `bin/git-localhost-store` again, recursively, without a base case.

## Background

Every store was itself created by a real `git clone`/`git init` through
`init.templateDir`, so it has a live `hooks/reference-transaction`
installed. The recovery merge writes refs *into* the store to reconcile
state: `git fetch` for `refs/remotes/*`, and `git update-ref` for
`refs/heads/<default>` when it fast-forwards or is newly created. Either
kind of write fires `reference-transaction` — on the store, not the
fresh clone. That hook calls `bin/git-localhost-store` again; the nested
call inherits `GIT_DIR` pointed at the store from the hook's environment,
so it can resolve back to the *same* store and recurse into itself.

**This actually happened** (2026-07-11, this session): a `git fetch`
issued from `bin/git-localhost-store` directly into a real store, before
any suppression was in place, produced thousands of recursively-spawned
`bin/git-localhost-store` → `git fetch` → `git-upload-pack` → store's
`reference-transaction` → `bin/git-localhost-store` chains, still
growing well after the triggering command had already returned control.
Not a theoretical risk — treat this test as load-bearing whenever the
recovery-merge code path changes (the fetch call, or the `update-ref`
calls added alongside it).

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

`bin/git-localhost-store` moves the store's `hooks/` directory aside
before the merge fetch and restores it via `trap ... EXIT` immediately
after — no hooks directory means no hook to find, regardless of git's
internal lookup path. The trap guards against the process being
interrupted mid-fetch, which would otherwise leave the store's hooks
permanently disabled.

## How to test this safely

This is a fork-bomb hazard if the fix regresses. Take real precautions —
bound it with `timeout`, and check process counts immediately after
before doing anything else:

```bash
ORIGIN=~/tmp/test-hookrecurse-origin
TEST_DIR=~/tmp/test-hookrecurse
STORE="$HOME/.local/state/git-localhost-store/repos/$(claude-path "$TEST_DIR")"
rm -rf "$ORIGIN" "$TEST_DIR" "$STORE"

mkdir -p "$ORIGIN" && cd "$ORIGIN"
git init -q
git -c user.email=t@t -c user.name=t commit -q --allow-empty -m v1
git clone -q "$ORIGIN" "$TEST_DIR"        # store created, WITH real hooks installed

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

- `timeout 20 git clone` exits well before the timeout.
- Process count check comes back `0` and stays `0` on re-check.
- `$TEST_DIR/.git` is a symlink to `$STORE`; `git -C "$TEST_DIR" log
  --oneline -1` shows v2.
- `$STORE/hooks/` exists and is intact afterward (the trap restored it) —
  no leftover `$STORE/.git-localhost-store-hooks-disabled`.
