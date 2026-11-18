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
- If source is already a symlink, error with suggestion

### Step 2: Filesystem Directory
Apply `merge_and_symlink(src, dst)`

### Step 3: Claude History
Apply `merge_and_symlink(src_claude, dst_claude)` where:
- `src_claude = ~/.claude/projects/$(claudepath src)`
- `dst_claude = ~/.claude/projects/$(claudepath dst)`

## Algorithm: merge_and_symlink

Goal: Make `src → dst` symlink, handling all src/dst existence combinations

1. **Already linked?** If src is symlink to dst, report and return
2. **Handle src:** If src exists:
   - If dst exists: merge src contents into dst, remove src
   - Else: move src to dst
3. **Ensure dst exists:** If neither existed, create dst
4. **Create symlink:** `ln -s dst src`

## Helpers

```bash
abspath() {
  # -L: follow symlinks, -m: allow non-existent paths
  realpath -Lm "$1"
}

claudepath() {
  # /home/user/path -> -home-user-path
  # Implementation: replace non-alphanumeric with dash
}

merge_and_symlink() {
  # Args: src dst
  # Makes src -> dst symlink, handling all existence cases
  # See algorithm above
}
```

## Error Handling & Safety

**Error Handling Philosophy:**
- Make a single code path - use conditionals to unify "exceptional" cases with main logic
- Never suppress errors - let `set -euo pipefail` catch them
- Only catch errors you can make into success

**Edge Cases:**
- Source is already a symlink: error with suggestion like `claude-workspace-merge $(readlink -f "$src") "$dst"`
- Dest is a symlink: works naturally (realpath resolves it)
- Circular symlinks: `realpath` will fail appropriately
- Source doesn't exist: handled naturally by merge_and_symlink (creates symlink to dst)

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
