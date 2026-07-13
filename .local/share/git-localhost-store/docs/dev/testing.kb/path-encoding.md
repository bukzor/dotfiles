# Test: Path Encoding

What it tests: paths with hyphens round-trip correctly through
`claude-path` and the store layout. The encoding rule is `-` → `--` and
`/` → `-`.

```bash
claude-path "/home/user/projects/repo"
claude-path "/home/user/my-repo"
claude-path "/home/user/my--special--repo"

TEST_DIR=~/trash/test-with-hyphens
ENCODED=$(claude-path "$TEST_DIR")
STORE="${XDG_STATE_HOME:-$HOME/.local/state}/git-localhost-store/repos/$ENCODED"

rm -r "$TEST_DIR" "$STORE"
mkdir -p "$TEST_DIR" && cd "$TEST_DIR"
git init && touch f && git add f
ls "${XDG_STATE_HOME:-$HOME/.local/state}/git-localhost-store/repos/"
```

## Expected

- The encoded names are deterministic and collision-free.
- The store appears at `$ENCODED` under the repos root.
- `/` in the workdir path becomes `-` in the encoded name.
- A literal `-` in the workdir path becomes `--` in the encoded name.
