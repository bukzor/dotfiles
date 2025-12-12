# ADR: Marker Commands Over Tool Invocations

**Date:** 2025-11-25
**Status:** Accepted
**Context:** Choosing interface pattern for task management commands

## Decision

Use marker commands (text strings that trigger actions) instead of standard Claude Code tool invocations for task management operations.

## Context

Task management requires frequent operations:
- Adding items to todo list
- Marking items complete
- Listing pending work
- Loading todos at session start

Standard approach: dedicated tool (TodoWrite) for each operation.

Alternative approach: marker strings in files/context that trigger actions when encountered.

## Alternatives Considered

### Alternative 1: TodoWrite Tool (Standard)

Use Claude Code's built-in TodoWrite tool.

**Rejected because:**
- State not git-controlled (user unaware of changes)
- User can't directly view/edit todos in vim
- Parallel system to file-based todos creates confusion
- Tool invocation overhead on every operation
- Not single source of truth

### Alternative 2: Direct File Editing

Always use Read/Edit tools explicitly.

**Rejected because:**
- Verbose: every operation requires explicit Edit call
- Breaks flow: "please add todo" → Read → Edit → verify
- Pattern doesn't match natural language intent

### Alternative 3: Marker Commands

Embed commands in files/context: `todo push: Description`

**Accepted because:**
- Zero-token overhead (processed during file read)
- Natural language syntax matches user intent
- Git-visible changes
- User can edit `.claude/todo.md` directly in vim
- Single source of truth
- Dual-access pattern (user vim, assistant markers)

## Marker Command Design

### Syntax

Format: `<namespace> <verb>: [argument]`

Examples:
- `subtask list:` (no argument)
- `subtask push: Fix the bug` (with argument)
- `todo pop:` (no argument)
- `todo push: Update docs` (with argument)

### Processing

**In-context markers** (ephemeral):
- Processed from conversation history
- No file operations
- Lost when conversation ends

**File markers** (persistent):
- Found in `.claude/todo.md` during Read operation
- Trigger Edit operations
- Changes committed to git

### Recognition Rules

Assistant recognizes markers in:
1. Direct user messages: `"todo push: Fix bug"`
2. File contents during Read
3. Script output (e.g., `session-start.sh` outputs `subtask load:`)

Distinguish command vs discussion by context:
- Command: `todo push: Fix bug` (imperative)
- Discussion: `You could use "todo push: Fix bug"` (descriptive)

## Consequences

### Positive

- **Zero-token overhead:** Markers processed when file already in context
- **Git visibility:** User sees all changes in `git diff`
- **Dual access:** User edits in vim, assistant uses markers
- **Natural syntax:** Reads like English, not tool invocation
- **Single source of truth:** `.claude/todo.md` is authoritative
- **Inspection:** User can `cat .claude/todo.md` anytime

### Negative

- **Unusual pattern:** Not standard Claude Code tool usage
- **Learning curve:** Users must understand marker syntax
- **Parsing ambiguity:** "todo" in natural text vs command
- **Tool unavailable:** Can't use standard TodoWrite features

### Mitigations

- Document pattern clearly in references/marker-commands.md
- Provide examples in SKILL.md
- Use context to disambiguate commands vs discussion
- Keep marker syntax simple and English-like

## Implementation

### Commands Implemented

**Ephemeral (in-context):**
- `subtask list:` - enumerate from conversation
- `subtask prepend:` - priority shift
- `subtask push: DESC` - add to working memory
- `subtask pop:` - complete current

**Persistent (file-based):**
- `todo push: DESC` - append `- [ ] DESC` to `.claude/todo.md`
- `todo pop:` - mark first `[ ]` as `[x]`
- `todo list:` - display entire file
- `todo clear:` - remove all `[x]` lines

**Lifecycle:**
- `subtask load:` - session start, read tactical todos
- `subtask save:` - session end, categorize ephemeral items

### File Format

`.claude/todo.md` uses standard markdown checkboxes:
```markdown
- [ ] Pending item
- [x] Completed item
```

Standard format enables:
- User editing in any markdown editor
- Rendering in GitHub/GitLab
- Grep/search with standard tools

## Validation

Pattern validated through:
- User has used marker pattern in personal CLAUDE.md
- Subtask management requires frequent operations
- Git visibility critical for user awareness
- Vim editing essential for user workflow

## Success Criteria

Pattern working when:
- Assistant reliably recognizes markers in context
- User understands when to use markers vs discussion
- Git diffs clearly show task changes
- Users naturally edit `.claude/todo.md` in vim
- No confusion between ephemeral and persistent operations
