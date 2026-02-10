---
name: llm-subtask
description: "Agent MUST load for 'subtask'/'todo' commands, multi-task work, or mid-task questions"
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

Four-tier task decomposition (finest to coarsest):

0. Conversational -- Question preemption (pattern, not tool)
1. Ephemeral -- In-context subtasks via marker commands
2. Tactical -- Cross-session checkboxes in `.claude/todo.md`
3. Strategic -- Planning files in `.claude/todo.kb/`

Use when breaking down complex work, coordinating across sessions, or transitioning between tiers.

## Overview

**Audience:** Both humans and LLMs during work sessions

**Purpose:** Track current tasks, priorities, and blockers across sessions

**Artifacts:**
- `$PWD/.claude/todo.md` - Quick checklist of active tasks (Tier 2: Tactical)
- `$PWD/.claude/todo.kb/YYYY-MM-DD-NNN-title.md` - Detailed task breakdowns (Tier 3: Strategic)
- `$PWD/.claude/ideas.kb/YYYY-MM-DD-NNN-title.md` - Unprioritized ideas (may become todos)
- Conversation context - Ephemeral subtasks (Tier 1)

## Marker Commands

### Ephemeral (Tier 1)

Mostly notional, only reified on demand.

- `subtask prepend` -- Signal priority shift, refocus on new work stream
- `subtask push` -- Append a subtask to the queue
- `subtask pop` -- Mark current subtask complete
- `subtask list` -- Enumerate pending work from conversation context

### Persistent (Tier 2 & 3)

- `subtask load`
    1. read `.claude/todo.md`
    2. list `.claude/todo.kb/`
- `subtask save`
    1. review chat history for incomplete, unpersisted subtasks
    2. items with subtasks → `todo.kb/` (strategic); all others → `todo.md` (tactical)
    3. confirm with user before abandoning anything
- `session end` -- Run `bin/session-end` script
- `todo push` -- Append a task
- `todo pop` -- Mark the current task (should be first) as complete
- `todo list` -- Read and display `.claude/todo.md`
- `todo clear`
    1. for each `[x]` item, grep devlog for its key phrase
    2. if no match, ask user before removing
    3. also delete completed `todo.kb/` files

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

## Nesting: Goal-First

Nest prerequisites under goals. Children complete before parent.

```markdown
- [ ] Make a sandwich
  - [ ] Buy bread
  - [ ] Buy cheese
```

**Granularity:** Items >60 minutes are hiding scope. Decompose until each subtask is a single focused effort.

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

**Uncommitted [x] markers are unverified claims.** Check `git status` — if todo.md has uncommitted changes, verify completed items before trusting them.

**During:** Work with ephemeral subtasks (`subtask push`/`pop`/`prepend`/`list`)

**End:** `subtask save` + update devlog (load llm-collab skill for devlog conventions)

## Agent Initiative

Suggest `subtask save` when user says "done", "wrap up", "gotta go", or "that's all".

Suggest `todo clear` when `[x]` items outnumber `[ ]` items in todo.md.

## Ideas Pattern

`.claude/ideas.kb/` captures unprioritized ideas without disrupting focused work.

**When to use:** Mid-task inspiration that deserves capture but not immediate pursuit.

**Lifecycle:**
1. **Exploring** — Initial capture, may be refined over time
2. **Promoted** → Becomes `todo.kb/` entry when ready for action
3. **Rejected** → Document reasoning (optionally as ADR), delete file
4. **Forgotten** — Acceptable; important ideas resurface naturally

**Key distinction:**
- `todo.kb/` = committed work, will be done
- `ideas.kb/` = speculative, might never happen

**Create ideas via:** `~/.claude/skills/llm-subtask/bin/llm-subtask-idea "Idea title"`

## References

Deep dives available in references/:
- [four-tier-system.md](references/four-tier-system.md) - Full explanation of all four tiers
- [marker-commands.md](references/marker-commands.md) - How marker commands work (unusual pattern)

## Architecture Decisions

See [docs/adr/](docs/adr/) for design rationale.
