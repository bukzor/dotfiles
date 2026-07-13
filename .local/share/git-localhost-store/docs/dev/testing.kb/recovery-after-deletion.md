# Test: Recovery After Deletion

What it tests: `rm -rf workdir` followed by `mkdir workdir` and an
explicit `git-localhost-store` call recovers the symlink and restores
deleted tracked files automatically.

```bash
TEST_DIR=~/trash/test-recovery
ENCODED=$(claude-path "$TEST_DIR")
STORE="${XDG_STATE_HOME:-$HOME/.local/state}/git-localhost-store/repos/$ENCODED"

# Setup: create repo, commit, populate store
rm -r "$TEST_DIR" "$STORE"
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"
git init -q
echo hello > file.txt
git add file.txt
git -c user.email=t@t -c user.name=t commit -q -m "before deletion"
git log --oneline > /tmp/before.log

# Destroy workdir
cd ~/trash && rm -r "$TEST_DIR"

# Verify store survived
ls "$STORE/objects/"
git --git-dir="$STORE" log --oneline

# Recover
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"
git init -q
git-localhost-store
```

## Expected

- `git-localhost-store` prints `✓ Recovered: .git -> $STORE`.
- `.git` is a symlink → `$STORE`.
- `git log --oneline` matches `/tmp/before.log`.
- `cat file.txt` prints `hello`.

## How recovery is triggered

The recovery branch (the whole `[ -e "$STORE" ]` block in
`bin/git-localhost-store`) fires when `git-localhost-store` runs against
a workdir whose store already exists. In practice that means:

- An explicit `git-localhost-store` invocation (as shown above), OR
- `git commit` (via `post-commit`) or `git clone`/`git checkout` (via
  `post-checkout`) on a fresh `.git`.

`git add` also fires a hook (`post-index-change`), but that hook always
defers this branch to `post-commit`/`post-checkout` rather than acting --
see `store-recovery-via-commit.md` for why (`post-index-change` fires
mid-operation, before an enclosing `git commit`'s own ref-transaction
lands, and swapping `.git` out from under that is unsafe). So a bare
`git add`, with no subsequent commit/checkout, leaves `.git` as a real,
unconverted directory even when a matching store already exists -- a
narrow, intentional gap in protection until the next commit/checkout.

Bare `git init` does not fire any hook at all.
