# Test: Empty Commit on Fresh Repo

What it tests: `git commit --allow-empty` on a freshly-init'd repo
triggers conversion via `reference-transaction` (the `HEAD` ref-write is
what the hook catches).

This case exists because there's no `git add` to fire post-index-change,
so `reference-transaction` is the only hook that can run.

```bash
TEST_DIR=~/tmp/test-empty-commit
ENCODED=$(claude-path "$TEST_DIR")
STORE="$HOME/.local/state/git-localhost-store/repos/$ENCODED"

rm -rf "$TEST_DIR" "$STORE"
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"
git init --template="$HOME/.local/share/git-localhost-store/template-repo"
git -c user.email=t@t -c user.name=t commit --allow-empty -m "test empty commit"
```

## Expected

- Commit succeeds.
- `.git` is a symlink → `$STORE`.
- `git log --oneline` shows the empty commit.
- `$STORE/objects/` contains the empty commit's tree.
