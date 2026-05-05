# Test: Recovery After Deletion

What it tests: `rm -rf workdir` followed by `mkdir workdir` and an
explicit `git-restore-repo` call recovers the symlink and restores
deleted tracked files automatically.

```bash
TEST_DIR=~/tmp/test-recovery
ENCODED=$(claude-path "$TEST_DIR")
STORE="$HOME/.local/state/git-localhost-store/repos/$ENCODED"

# Setup: create repo, commit, populate store
rm -rf "$TEST_DIR" "$STORE"
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"
git init -q
echo hello > file.txt
git add file.txt
git -c user.email=t@t -c user.name=t commit -q -m "before deletion"
git log --oneline > /tmp/before.log

# Destroy workdir
cd ~/tmp && rm -rf "$TEST_DIR"

# Verify store survived
ls "$STORE/objects/"
git --git-dir="$STORE" log --oneline

# Recover
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"
git init -q
git-restore-repo
```

## Expected

- `git-restore-repo` prints `✓ Recovered: .git -> $STORE`.
- `.git` is a symlink → `$STORE`.
- `git log --oneline` matches `/tmp/before.log`.
- `cat file.txt` prints `hello`.

## How recovery is triggered

The recovery branch fires when `git-restore-repo` runs against a workdir
whose store already exists *and* whose local `.git` has no refs in
`refs/heads/` or `refs/remotes/`. In practice that means:

- An explicit `git-restore-repo` invocation (as shown above), OR
- Any hook-firing operation on a fresh `.git` — `git add` (post-index-change),
  `git commit` (pre-commit), or a ref-changing op (reference-transaction).

Bare `git init` does not fire any of the three hooks.
