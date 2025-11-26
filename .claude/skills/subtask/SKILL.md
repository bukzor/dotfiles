---
name: subtask
description: "Load when:\n\n1. user gives a terse command starting with \"subtask\" or \"todo\" OR\n2. working with multiple tasks OR\n3. user asks a question during a task"
---

# Subtask Management

Four-tier task decomposition system for managing work at different granularities: conversational, ephemeral, tactical, and strategic. Use when breaking down complex work into manageable pieces, coordinating across sessions, or transitioning between persistence tiers.

## Four Tiers

Support task decomposition at four granularities, from finest to coarsest:

**Tier 0: Conversational** - Question preemption (pattern, not tool)
**Tier 1: Ephemeral** - Session subtasks via marker commands (in-context)
**Tier 2: Tactical** - Cross-session checkboxes in `.claude/todo.md`
**Tier 3: Strategic** - Planning files in `.claude/todo.d/YYYY-MM-DD-NNN-title.md`

## Marker Commands

### Ephemeral (Tier 1)

- `subtask list:` - Enumerate pending work from conversation context
- `subtask prepend:` - Signal priority shift, refocus on new work stream
- `subtask push: DESC` - Add ephemeral subtask to working memory
- `subtask pop:` - Mark current ephemeral subtask complete

### Persistent (Tier 2 & 3)

- `subtask load:` - Session start: read `.claude/todo.md` and enumerate tactical todos
- `subtask save:` - Session end: review incomplete ephemeral subtasks, categorize as tactical/strategic/abandon
- `todo push: DESC` - Append `- [ ] DESC` to `.claude/todo.md` (tactical)
- `todo pop:` - Mark the current task (should be first) as complete
- `todo list:` - Read and display `.claude/todo.md`
- `todo clear:` - Remove all completed items from the list

### Strategic (Tier 3)

Create planning files via: `~/.claude/skills/subtask/bin/new-todo "Task title"`

## Integration: todo.md + todo.d/

Tier 2 (tactical) and Tier 3 (strategic) work together: <https:todo.md> contains both inline tasks and references to planning files in <https:todo.d/>.

**Example pattern:**
```markdown
- [ ] <https:todo.d/2025-11-26-001-research-local-climbing-gyms.md>
- [ ] Buy climbing shoes
  - [ ] Measure foot size
  - [ ] Check REI sale section
- [ ] Schedule first climbing session
```

## Example: subtask list

When user requests `subtask list`, enumerate pending work from conversation context using markdown list format with status indicators:

```
- [x] Completed item
- [~] In-flight item
  - [x] Completed sub-item
  - [ ] Pending sub-item
- [ ] Pending item
```

## Session Lifecycle

**Start:** `subtask load:` reads tactical todos from `.claude/todo.md`

**During:** Work with ephemeral subtasks (`subtask push:`/`pop:`/`prepend:`/`list:`)

**End:** `subtask save:` reviews incomplete work:
- Tactical → `todo push:` to `.claude/todo.md`
- Strategic → `bin/new-todo "title"` creates planning file
- Trivial → abandon

## Agent Initiative

Proactively suggest `subtask save:` when detecting:
- User signals wrap-up: "gotta go", "that's all", "wrapping up"
- Long conversation with visible incomplete ephemeral work
- Abrupt topic shift leaving work dangling

Phrase as: "Before we move on, should I `subtask save:` to review what's incomplete?"

## References

Deep dives available in references/:
- [four-tier-system.md](references/four-tier-system.md) - Full explanation of all four tiers
- [marker-commands.md](references/marker-commands.md) - How marker commands work (unusual pattern)

## Architecture Decisions

See [docs/adr/](docs/adr/) for design rationale.
