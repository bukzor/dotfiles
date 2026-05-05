# Test: Commit and Verify Storage

What it tests: commits land in the central store, not in the working
directory's `.git`.

```bash
TEST_DIR=~/tmp/test-storage
ENCODED=$(claude-path "$TEST_DIR")
STORE="$HOME/.local/state/git-localhost-store/repos/$ENCODED"

rm -rf "$TEST_DIR" "$STORE"
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"

git init -q
echo "first" > file.txt
git add file.txt
git commit -m "first commit"
echo "second line" >> file.txt
git commit -am "second commit"
```

## Expected

- `git log --oneline` shows two commits.
- `$STORE/objects/` contains loose or pack objects.
- `$STORE/refs/heads/main` exists with the head SHA.
- `git --git-dir="$STORE" log --oneline` shows the commits independently
  of the working directory.
