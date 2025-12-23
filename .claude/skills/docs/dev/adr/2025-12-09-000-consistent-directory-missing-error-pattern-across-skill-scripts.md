# Consistent directory-missing error pattern across skill scripts

**Date:** 2025-12-09
**Status:** Accepted

## Context

Skill scripts that require certain directories to exist had inconsistent error handling:
- Some silently created directories (`mkdir -p`)
- Some gave unhelpful error messages
- Some gave helpful messages with recovery commands

When a required directory is missing, it often signals the user is in the wrong working directory. Silent auto-creation masks this problem.

## Decision

All scripts that require a directory check for its existence and emit a consistent error:

```bash
if [ ! -d "<required-dir>" ]; then
  echo >&2 "Error: <required-dir>/ not found in $PWD"
  echo >&2 "If this is the right location, run: mkdir -p <required-dir> && !!"
  exit 1
fi
```

Key elements:
1. Error message includes `$PWD` for context
2. Recovery command uses `&& !!` to retry after fix
3. Output to stderr (`>&2`)

Scripts may still auto-create subdirectories after the check passes (e.g., `new-todo` creates `.claude/todo.d/` after confirming `.claude/` exists).

## Consequences

**Positive:**
- Users get clear feedback when in wrong directory
- Recovery path is obvious and copy-pasteable
- Consistent UX across all skill scripts

**Negative:**
- Requires `.claude/` to exist before using subtask scripts (minor friction)

## Related

- Affected scripts: `new-adr`, `new-devlog`, `new-todo`, `ensure-todo-md`
