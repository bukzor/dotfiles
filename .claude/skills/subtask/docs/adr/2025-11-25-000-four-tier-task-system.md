# ADR: Four-Tier Task Decomposition System

**Date:** 2025-11-25
**Status:** Accepted
**Context:** Designing task management system for Claude Code sessions

## Decision

Implement four-tier task decomposition system:

**Tier 0:** Conversational preemption (control flow pattern)
**Tier 1:** Ephemeral subtasks (in-context via markers)
**Tier 2:** Tactical todos (`.claude/todo.md` checkboxes)
**Tier 3:** Strategic todos (`.claude/todo.d/` planning files)

## Context

Working with Claude Code involves work at different granularities:
- Within single conversation: "fix this bug"
- Across conversations, same session: "refactor auth module"
- Across sessions: "design new authentication system"

Existing systems inadequate:
- TodoWrite tool: ephemeral, not git-controlled, user can't edit
- Manual files: no structure, hard to discover, no promotion flow

Need system that:
1. Supports natural work decomposition
2. Minimal overhead at each tier
3. Clear promotion/demotion between tiers
4. Git-visible for user awareness
5. Dual-access (user in vim, assistant via tools)

## Alternatives Considered

### Alternative 1: Two-Tier (Ephemeral + Persistent)

Collapse tactical and strategic into single persistent tier.

**Rejected because:**
- One-line checkboxes vs full planning docs have different use cases
- Quick scanning requires different format than deep planning
- Mixed in one location creates noise

### Alternative 2: Unified Command Namespace

Use only `todo` commands for all tiers (no `subtask` namespace).

**Rejected because:**
- User saying "todo" implies persistence intention
- "subtask" better conveys decomposition/ephemeral nature
- Disambiguation valuable for user intent

**Counter-argument considered:**
- Everything IS subtask decomposition at different durability
- Unified namespace reduces mental translation overhead
- Operations encode tier (push/pop/list vs new)

**Final decision:** Use both namespaces:
- `subtask` commands: ephemeral operations
- `todo` commands: persistent operations
- `subtask save:` bridges the gap

### Alternative 3: Filesystem for Ephemeral

Store ephemeral subtasks in `.claude/session.md`.

**Rejected because:**
- Read/Edit overhead on every operation
- Need discipline to clear session file
- Conversation restart already preserves context
- User can't easily distinguish ephemeral from tactical

## Consequences

### Positive

- Natural work decomposition at appropriate granularity
- Zero overhead for ephemeral work (no filesystem I/O)
- Git-visible todos (user sees changes in diff)
- Dual-access (vim + Claude tools)
- Clear promotion flow guides persistence decisions
- Temporal ordering built into strategic todos (date-based)

### Negative

- Learning curve: four tiers to understand
- Agent must recognize when to suggest promotion
- Marker command pattern unusual (not standard tools)
- User must remember two command namespaces

### Mitigations

- SKILL.md provides tier selection guide
- Agent proactively suggests `subtask save:` at session end
- References document marker pattern clearly
- Unified verbs across namespaces (push/pop/list)

## Implementation Notes

Marker commands processed when file already in context (zero-token overhead).

TodoWrite tool disabled in favor of marker pattern for:
1. Git visibility
2. User direct editing
3. Single source of truth
4. Natural language syntax

Date-based naming (`YYYY-MM-DD-NNN-title.md`) provides temporal ordering for conflict resolution when parallel explorations occur.

## Success Criteria

System working when:
- Agent naturally uses appropriate tier for work granularity
- User can quickly see what's pending at each tier
- Promotion between tiers feels natural, not burdensome
- Git diffs clearly show task additions/completions
- Both user and agent can recover state after interruption
