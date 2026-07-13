# Test: Fresh Repository Setup

What it tests: a brand-new repo at a fresh path is converted to the
symlink layout on the first index-modifying operation.

```bash
TEST_DIR=~/trash/test-fresh
ENCODED=$(claude-path "$TEST_DIR")
STORE="${XDG_STATE_HOME:-$HOME/.local/state}/git-localhost-store/repos/$ENCODED"

rm -r "$TEST_DIR" "$STORE"
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"

git init
echo "test content" > file.txt
git add file.txt
```

## Expected

- `.git` is a symlink → `$STORE`.
- `$STORE` is a regular directory containing `HEAD`, `objects/`, `refs/`,
  `config`, `hooks/`.
- `cat .git/HEAD` reads cleanly through the symlink and prints
  `ref: refs/heads/main`.
- `git status` shows `file.txt` staged.
