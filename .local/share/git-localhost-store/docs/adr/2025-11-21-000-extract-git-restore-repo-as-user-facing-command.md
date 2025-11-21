# Extract git-restore-repo as user-facing command

**Date:** 2025-11-21
**Status:** Accepted

## Context

The git-localhost-store system originally had all its core logic embedded in `template-repo/hooks/post-init`, which was only triggered automatically by git hooks. This created several issues:

1. **Hidden functionality**: Users had no way to manually trigger the restore logic without workarounds like `touch foo && git add foo`
2. **Poor discoverability**: The command wasn't named or exposed, making it hard to find
3. **Code duplication risk**: Hooks were calling each other rather than shared logic
4. **Installation complexity**: Unclear whether hooks should use PATH, relative paths, or absolute paths to find implementation

## Decision

Extract the core worktree setup logic into a standalone `bin/git-restore-repo` command that serves as both:
- A user-facing command for manual repo conversion and recovery
- The implementation called by git hooks

**Structural changes:**
- Move `template-repo/hooks/post-init` → `bin/git-restore-repo` (user-facing)
- Move `bin/init` → `lib/init` (internal setup helper)
- Update hooks to call: `${XDG_DATA_HOME:-$HOME/.local/share}/git-localhost-store/bin/git-restore-repo`

## Alternatives Considered

### Option A: Everything in template-repo/
Put `git-restore-repo` inside `template-repo/bin/` so hooks can use relative paths.

- **Pros:** Hooks find implementation easily via `../bin/git-restore-repo`
- **Cons:** Every repo gets a stale copy of implementation; updates require re-initialization

### Option B: Hooks use PATH
Keep `bin/git-restore-repo` separate, require users to add to PATH or symlink to `~/bin/`.

- **Pros:** Central updates work; clean separation
- **Cons:** Two-step installation; hooks fail if PATH not configured

### Option C: Hooks use XDG standard path (CHOSEN)
Hooks call `${XDG_DATA_HOME:-$HOME/.local/share}/git-localhost-store/bin/git-restore-repo`

- **Pros:** Single-step installation; central updates work; follows XDG standard
- **Cons:** "Hardcoded" path (though it's actually a standard location)

## Consequences

**Positive:**
- Users can explicitly run `git restore-repo` to convert or recover repos
- Better discoverability - named as a git command
- Cleaner code organization with proper separation of user-facing vs internal
- Central updates propagate immediately to all repos (no stale copies)
- Simple installation (single git config line)

**Negative:**
- Hooks depend on absolute XDG path rather than relative paths
- If user has non-standard XDG_DATA_HOME, must ensure system is installed there

**Neutral:**
- Installation remains single-step but now the command is also available manually
- Hooks are now thin wrappers (~10 lines) that check and call the main implementation

## Related

- See devlog/2025-11-21.md for implementation details
- This enables future work: renaming project to match the CLI command
