# Marker Commands

Marker commands are an unusual pattern for Claude Code: commands embedded in files or conversation context that trigger actions when encountered.

## How They Work

**Standard tool pattern:**
```
User: "Add a todo"
Assistant: [uses TodoWrite tool]
```

**Marker pattern:**
```
File contains: "todo push: Fix the bug"
Assistant reads file → recognizes marker → takes action (appends to .claude/todo.md)
```

## Why Markers?

**Zero-token overhead:** Markers are processed when file already in context. No separate tool invocation needed.

**Dual access:** User can edit `.claude/todo.md` directly in vim, assistant edits via Read/Edit. Single source of truth.

**Git-visible:** Changes appear in `git diff`, user gets automatic notification.

**Natural language:** Markers read like English ("todo push: Fix bug") rather than tool syntax.

## Marker Types

### In-Context Markers (Ephemeral)

When assistant encounters these in conversation history or working memory:

- `subtask list:` - Enumerate pending ephemeral subtasks
- `subtask prepend: DESC` - Shift priority to DESC
- `subtask push: DESC` - Add DESC to ephemeral working memory
- `subtask pop:` - Complete current ephemeral subtask

**Processing:** Assistant recognizes marker in conversation context, updates internal working memory.

**Persistence:** None. Lost when conversation ends unless promoted.

### File Markers (Persistent)

When assistant reads `.claude/todo.md`:

- `todo push: DESC` - Append `- [ ] DESC` to end of file
- `todo pop:` - Find first `- [ ]`, change to `- [x]`
- `todo list:` - Display entire file contents
- `todo clear:` - Remove all `- [x]` lines

**Processing:** Assistant reads file, sees marker, performs Edit operation.

**Persistence:** Changes written to `.claude/todo.md`, committed via git.

**File creation:** If `.claude/todo.md` doesn't exist, `todo push:` creates it using `skeleton/.claude/todo.md` template via `bin/ensure-todo-md`.

**Ownership:** All files include header `<anthropic-skill-ownership subtask />` for clear ownership signaling.

### todo push: Implementation

When agent encounters `todo push: DESC`:

1. **Ensure file exists:** Run `~/.claude/skills/subtask/bin/ensure-todo-md` (idempotent, prints path)
2. **Append task:** Edit the file to append `- [ ] DESC` before "## Later" section (or at end if no Later section)
3. **Verify:** Read file to confirm task added

## Implementation Details

### TodoWrite Tool Disabled

The standard Claude Code TodoWrite tool is disabled in this environment. All task management happens via marker commands instead.

**Rationale:**
- TodoWrite state not git-controlled
- User can't directly view/edit todos
- Creates parallel task tracking systems
- Token overhead on every operation

Markers solve all these issues.

### Marker Recognition

Assistant should recognize markers in:

1. **User messages:** `"Please subtask push: Refactor auth"`
2. **File contents:** `.claude/todo.md` contains marker
3. **Conversation history:** Previous marker references
4. **Session scripts:** `session-start.sh` outputs `subtask load:`

### Marker vs Direct Statement

**Marker form (triggers action):**
```
todo push: Fix the bug
```

**Statement form (just talking about it):**
```
You could use "todo push: Fix the bug" to add it
```

Context determines interpretation. When user says marker phrase directly, treat as command. When discussing the system, treat as example.

## Session Lifecycle Markers

### subtask load:

**When:** Session start (often from `session-start.sh` script)

**Action:**
1. Read `.claude/todo.md`
2. Enumerate tactical todos for user
3. Ask if context needed on strategic items

**Example output:**
```
Pending tactical todos:
- [ ] Refactor session-start.sh
- [ ] Update SKILL.md references

Strategic items available in .claude/todo.d/:
- 2025-11-25-000-create-subtask-skill.md

Want context on any of these?
```

### subtask save:

**When:** Session end (agent initiative or user request)

**Action:**
1. Review ephemeral subtasks from conversation
2. Categorize each with user:
   - Tactical → `todo push:` to `.claude/todo.md`
   - Strategic → `bin/new-todo` creates planning file
   - Trivial → abandon
3. Execute appropriate persistence operation

**Example dialog:**
```
Assistant: "We have 3 incomplete ephemeral subtasks:
1. Extract authentication logic
2. Create auth service class
3. Run tests

Should I categorize these for persistence?"

User: "Yes"