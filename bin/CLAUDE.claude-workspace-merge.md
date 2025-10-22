# claude-workspace-merge

Merge workspaces with `mv` semantics: source becomes symlink pointing to dest, which holds all merged content and history.

## Usage

```bash
claude-workspace-merge <source> <dest>
# Result: source -> dest (symlink), dest holds all content/history
```

## Implementation

### Step 1: Path Resolution
- Resolve both arguments to absolute paths using `realpath -Lm`
- If source == dest, exit successfully (nothing to do)

### Step 2: Filesystem Directory
Make `src` → `dst` (symlink):
- Neither exist: create dst, symlink src to it
- Src only: move src to dst, symlink src to dst
- Dst only: symlink src to dst
- Already linked: skip
- Both exist: merge src into dst with `mv -i`, remove src, symlink

### Step 3: Claude History
Same pattern for `~/.claude/projects/$(claudepath PATH)`:
- Neither: done (no history yet)
- Src only: move to dst location, symlink
- Dst only: symlink src to dst
- Already linked: skip
- Both exist: merge src into dst with `mv -i`, remove src, symlink

## Helpers

```bash
abspath() {
  # -L: follow symlinks, -m: allow non-existent paths
  realpath -Lm "$1"
}

claudepath() {
  # /home/user/path -> -home-user-path
  sed 's|[^A-Za-z0-9]|-|g' <<< "$1"
}
```

## Error Handling & Safety

**Error Handling Philosophy:**
- Make a single code path - use conditionals to unify "exceptional" cases with main logic
- Never suppress errors - let `set -euo pipefail` catch them
- Only catch errors you can make into success

**Edge Cases:**
- If source doesn't exist: error and exit
- If source is already a symlink: error with suggestion like `claude-workspace-merge $(readlink -f "$src") "$dst"`
- If dest is a symlink: don't care, let it work naturally
- Circular symlinks: `realpath` will fail appropriately

**Quality:**
- Idempotent (safe to run multiple times)
- Use `mv -i` to prompt before overwrites (handles all merge conflicts)
- Use ✓/⚠ for clear status messages
- Exit 0 for success, 1 for errors
- Follow bash script template at ~/.claude/CLAUDE.d/bash-script-template.md

## Design Rationale

### Why Symlinks?
Claude follows symlinks naturally - no need to update transcript JSONL content. Both source and dest paths transparently access the same workspace and conversation history.

### Why `mv` Semantics?
Following `mv` conventions makes the tool intuitive: content "moves" from source to dest, but source remains accessible via symlink. This matches user expectations from filesystem operations.

### Why Merge Both Filesystem and History?
Claude tracks projects by their absolute filesystem path. When you access a project from different paths, Claude treats them as separate projects with separate histories. By symlinking both the directory and the Claude history folder, we ensure both paths share the same conversation context going forward.

### Easy to Undo
Just remove the symlinks to decouple the workspaces. The dest directory retains all merged content.
