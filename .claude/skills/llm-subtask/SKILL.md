---
name: llm-subtask
description: "Agent MUST load when:\n\n1. user gives a terse command starting with \"subtask\" or \"todo\" OR\n2. working with multiple tasks OR\n3. user asks a question during a task"
---
--- # workaround: anthropics/claude-code#13005
setup: |
    All projects that depend on this skill should have as `CLAUDE.md` frontmatter:

    ```yaml
    --- # workaround: anthropics/claude-code#13003
    depends:
    - skills/llm-subtask
    ```

    And include a "Current Work" section pointing to the todo system:

    ```markdown
    ## Current Work

    Check `.claude/todo.md` and `.claude/todo.kb/` for active efforts. Load `Skill("llm-subtask")` for maintenance.
    ```

    This gives future sessions a clear entry point for ongoing/planned work.
default: subtask load
---

# Subtask Management

Four-tier task decomposition system for managing work at different granularities: conversational, ephemeral, tactical, and strategic. Use when breaking down complex work into manageable pieces, coordinating across sessions, or transitioning between persistence tiers.

## Overview

**Audience:** Both humans and LLMs during work sessions

**Purpose:** Track current tasks, priorities, and blockers across sessions

**Artifacts:**
- `$PWD/.claude/todo.md` - Quick checklist of active tasks (Tier 2: Tactical)
- `$PWD/.claude/todo.kb/YYYY-MM-DD-NNN-title.md` - Detailed task breakdowns (Tier 3: Strategic)
- Conversation context - Ephemeral subtasks (Tier 1)

**Integration:** Works alongside devlog documentation - tasks track "what's next" (forward-looking), devlogs document "what happened" (historical). See "Integration with Devlog" section below.

## Four Tiers

Support task decomposition at four granularities, from finest to coarsest:

0. Conversational -- Question preemption (pattern, not tool)
1. Ephemeral -- Session subtasks via marker commands (in-context)
2. Tactical -- Cross-session checkboxes in `.claude/todo.md`
3. Strategic -- Planning files in `.claude/todo.kb/YYYY-MM-DD-NNN-title.md`

## Marker Commands

### Ephemeral (Tier 1)

These mostly notional, only reified on demand.

- `subtask prepend` -- Signal priority shift, refocus on new work stream
- `subtask push` - Append a subtask to the queue
- `subtask pop` -- Mark current subtask complete
- `subtask list` -- Enumerate pending work from conversation context

### Persistent (Tier 2 & 3)

- `subtask load`
    1. read `.claude/todo.md`
    2. list `.claude/todo.kb/`
- `subtask save`
    1. review chat history for subtasks that are both incomplete and not yet persisted
    2. categorize as tactical/strategic/abandon
- `session end` -- Run `bin/session-end` script
- `todo push` - Append a task
- `todo pop` -- Mark the current task (should be first) as complete
- `todo list` -- Read and display `.claude/todo.md`
- `todo clear` -- Remove all completed items from the list

**File initialization:** `bin/llm-subtask-init` creates `.claude/todo.md` from skeleton if missing (idempotent).

### Strategic (Tier 3)

Create planning files via: `~/.claude/skills/llm-subtask/bin/llm-subtask-todo "Task title"`

## Integration: todo.md + todo.kb/

Tier 2 (tactical) and Tier 3 (strategic) work together: <https:todo.md> contains both inline tasks and references to planning files in <https:todo.kb/>.

**Example pattern:**
```markdown
- [ ] <https:todo.kb/2025-11-26-001-research-local-climbing-gyms.md>
- [ ] Buy climbing shoes
  - [ ] Measure foot size
  - [ ] Check REI sale section
- [ ] Schedule first climbing session
```

## Nesting Pattern: Goal-First

When tasks have dependencies, **nest prerequisites under goals**, not goals under prerequisites.

**Correct:** Goal is parent, blockers are children
```markdown
- [ ] Make a sandwich
  - [ ] Buy bread
  - [ ] Buy cheese
```

**Incorrect:** Blocker is parent, goal is child
```markdown
- [ ] Buy bread
  - [ ] Make a sandwich
```

**Rationale:** You check off children first (buy bread, buy cheese), then parent (make sandwich). This matches execution order—children complete before parent can complete.

**Multi-level chains:** Same principle applies recursively
```markdown
- [ ] Host dinner party
  - [ ] Make sandwiches
    - [ ] Buy bread
  - [ ] Set table
```

Work flows bottom-up: buy bread → make sandwiches → host dinner party.

## Example: subtask list

When user requests `subtask list`, enumerate pending work from conversation context using markdown list format with status indicators.

**Important:** Wrap task lists in a "code fence" to prevent the client from
stripping status indicators. Without a code fence, `- [x]` and `- [ ]` are
rendered as `-`.

````
Example output:

```
- [x] Completed item
- [~] In-flight item
  - [x] Completed sub-item
  - [ ] Pending sub-item
- [ ] Pending item
```

````

## Session Lifecycle

**Start:** `subtask load` reads tactical todos from `.claude/todo.md`

**During:** Work with ephemeral subtasks (`subtask push`/`pop`/`prepend`/`list`)

**End:** `subtask save` reviews incomplete work:
- Tactical → `todo push` to `.claude/todo.md`
- Strategic → `bin/llm-subtask-todo "title"` creates planning file
- Trivial → abandon

## Agent Initiative

Proactively suggest `subtask save` when detecting:
- User signals wrap-up: "gotta go", "that's all", "wrapping up"
- Long conversation with visible incomplete ephemeral work
- Abrupt topic shift leaving work dangling

Phrase as: "Before we move on, should I `subtask save` to review what's incomplete?"

## Integration with Devlog

Task tracking and devlog documentation are complementary systems:

**Tasks (forward-looking):** Track "what's next" - active work, priorities, blockers
**Devlogs (historical):** Document "what happened" - decisions, discoveries, outcomes

**At session end:**
1. `subtask save` reviews incomplete work → updates `.claude/todo.md`
2. Create/update devlog entry documenting session narrative

**For devlog structure and conventions**, load the llm-collab skill.

## References

Deep dives available in references/:
- [four-tier-system.md](references/four-tier-system.md) - Full explanation of all four tiers
- [marker-commands.md](references/marker-commands.md) - How marker commands work (unusual pattern)

## Architecture Decisions

See [docs/adr/](docs/adr/) for design rationale.
