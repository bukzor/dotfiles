# Test: Path Encoding

What it tests: paths with separators round-trip correctly through
`claude-path` and the store layout. The encoding rule is that every
character which is not ASCII alphanumeric becomes exactly one `-`.

```bash
claude-path "/home/user/projects/repo"
claude-path "/home/user/my-repo"
claude-path "/home/user/my--special--repo"
claude-path "/home/user/my.repo"

TEST_DIR=~/trash/test-with-hyphens
ENCODED=$(claude-path "$TEST_DIR")
STORE="${XDG_STATE_HOME:-$HOME/.local/state}/git-localhost-store/repos/$ENCODED"

rm -r "$TEST_DIR" "$STORE"
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"
git init && touch f && git add f
ls "${XDG_STATE_HOME:-$HOME/.local/state}/git-localhost-store/repos/"
```

## Expected

- `-home-user-projects-repo`, `-home-user-my-repo`,
  `-home-user-my--special--repo`, `-home-user-my-repo`.
- A run of separators is preserved one-for-one -- `my--special--repo`
  comes back unchanged.
- The last two cases are equal: the encoding is deterministic but **not**
  collision-free, since `-` is the image of `/`, of `.`, and of itself.
  Two workdirs can name one store; nothing prevents it, and the worktree
  a store belongs to is recovered from the `.git` symlink rather than by
  decoding the name.
- The store appears at `$ENCODED` under the repos root.
