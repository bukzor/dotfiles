# Test: Empty Commit on Fresh Repo

What it tests: `git commit --allow-empty` on a freshly-init'd repo, with
no prior `git add`, still converts `.git` to the symlink layout.

This case exists to prove conversion doesn't depend on `git add` having
run first. It's not testing the hook you'd guess: `git commit` fires
`post-index-change` too (its internal index-refresh touches the same
machinery `git add` uses; this isn't documented behavior to rely on
elsewhere, see `store-recovery-via-commit.md` for the caveat that
follows from it), so `post-index-change` converts `.git` *during* the
commit (a plain relocate to a brand-new store -- safe, no pre-existing
store to collide with); `post-commit` fires moments later, finds `.git`
already a symlink, and no-ops.

```bash
TEST_DIR=~/trash/test-empty-commit
ENCODED=$(claude-path "$TEST_DIR")
STORE="${XDG_STATE_HOME:-$HOME/.local/state}/git-localhost-store/repos/$ENCODED"

rm -r "$TEST_DIR" "$STORE"
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"
git init --template="$HOME/.local/share/git-localhost-store/template-repo"
git -c user.email=t@t -c user.name=t commit --allow-empty -m "test empty commit"
```

## Expected

- Commit succeeds.
- `.git` is a symlink → `$STORE`.
- `git log --oneline` shows the empty commit.
- `$STORE/objects/` contains the empty commit's tree.
