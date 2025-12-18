# Devlog: 2025-12-18

## Focus

Fix broken worktree creation bug from Nov 24 - repos missing `objects/`, had `HEAD.lock`.

## What Happened

### Completed

- Root cause identified: `reference-transaction` hook firing during `git init`
- Fixed hook to skip fresh inits (no branches yet)
- Fixed `claude-path` encoding bug (was using `tr` for multi-char replacement)
- Created `test-reference-transaction` automated test
- Updated TESTING.md with quick test section

### Discovered

- `reference-transaction` fires during ANY ref update, including `git init` creating HEAD
- Even "committed" state fires before `git init` completes
- All repos after Nov 24 12:33 were broken; all before were fine (exact timestamp of hook addition)
- Path encoding was producing newlines instead of doubled hyphens

## Decisions Made

### Skip fresh inits in reference-transaction

**Rationale:** Can't move `.git` while `git init` is still running. Let `post-index-change` handle setup on first `git add` instead.
**Alternatives:** Could have removed `reference-transaction` entirely, but it catches branch/tag/fetch operations.
**Impact:** Setup now deferred to first `git add`, not during `git init`.

## Open Questions

- Should broken repos in `~/.local/state/git-localhost-store/repos/` be cleaned up?

## Next Session

- Re-enable `templateDir` in `~/.gitconfig`
- Test in real usage
