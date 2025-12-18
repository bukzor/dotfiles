<anthropic-skill-ownership llm-subtask />

# Decide ideas.d Naming Convention

**Priority:** Low
**Complexity:** Low
**Context:** Raised during naming refactor session; llm.d→llm.kb rename

## Problem Statement

Should `ideas.d/` become `ideas.kb/` for consistency with the `.kb` naming convention?

## Analysis

**Arguments for keeping `.d`:**
- `.kb` was introduced specifically for llm.kb-style knowledge bases (schema-validated, queryable)
- `ideas.d/` is task management (like `todo.d/`), not a knowledge base
- ADR 2025-12-03-000 targeted `.d` overloading for *knowledge bases*, not all directories
- `todo.d/` and `ideas.d/` are llm-subtask/llm-collab patterns, not llm.kb patterns

**Arguments for `.kb`:**
- Consistency: all skill-managed collections use same suffix
- Avoids confusion with systemd/cron `.d` directories
- Simpler mental model: "skill collections use .kb"

**Current state:**
- llm.kb skill: uses `.kb/` for knowledge bases
- llm-subtask: uses `todo.d/`
- llm-collab: uses `ideas.d/`, `references.d/`

## Recommendation

Keep `.d` for task management directories (`todo.d/`, `ideas.d/`).

Reserve `.kb` for llm.kb-style knowledge bases with schema validation.

Rationale: The patterns serve different purposes. Task directories are ephemeral work tracking; knowledge bases are persistent queryable information.

## Decision Needed

- [ ] Confirm: keep `.d` for llm-subtask/llm-collab directories
- [ ] Or: rename all to `.kb` for consistency

## Notes

If decision is to keep `.d`, no action needed — current state is correct.
If decision is `.kb`, need to rename: todo.d/, ideas.d/, references.d/ across skills.
