# Test: Existing Repo Conversion

What it tests: applying `git-restore-repo` to an already-existing repo
(with history but a real `.git/` directory) converts it without losing
any commits or tracked files.

```bash
TEST_DIR=~/tmp/test-existing
ENCODED=$(claude-path "$TEST_DIR")
STORE="$HOME/.local/state/git-localhost-store/repos/$ENCODED"

rm -rf "$TEST_DIR" "$STORE"
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"

# Build a normal repo without our hooks
git init --template=
echo existing > existing.txt
git add existing.txt
git -c user.email=t@t -c user.name=t commit -m "existing commit"

# Convert
git-restore-repo
```

## Expected

- `.git` becomes a symlink → `$STORE`.
- `git log --oneline` shows the existing commit.
- `existing.txt` is still present and unchanged.
- `git status` is clean.
