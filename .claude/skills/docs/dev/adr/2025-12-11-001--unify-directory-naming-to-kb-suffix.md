# Unify directory naming to .kb suffix

**Date:** 2025-12-11 (raised), 2025-12-23 (decided)
**Status:** Accepted

## Context

After renaming `llm.d` → `llm.kb`, a question arose: should other skill-managed directories follow?

- `todo.d/` (llm-subtask)
- `ideas.d/` (llm-collab)
- `references.d/` (llm-collab)

Initial analysis recommended keeping `.d` for "task management" vs `.kb` for "knowledge bases with schema validation." This distinction was invented post-hoc to justify the status quo — when everything was `.d`, there was no distinction.

On review (2025-12-23), the distinction doesn't hold:
- `ideas.d/` has YAML frontmatter schema (`cost-benefit-sweh`, `@value:` annotations)
- `todo.d/` has structured sections (Priority, Complexity, Steps, Criteria)
- Both are queryable LLM-optimized stores

## Decision

Rename all skill-managed directories to `.kb`:

- `todo.d/` → `todo.kb/`
- `ideas.d/` → `ideas.kb/`
- `references.d/` → `references.kb/`

Rationale: `.kb` = LLM-optimized knowledge base. All these directories qualify.

## Consequences

**Positive:**
- Consistent naming across all skill-managed collections
- Clear signal: `.kb` suffix means "structured store for LLM querying"
- Avoids confusion with systemd/cron `.d` convention

**Negative:**
- Migration work across skills and skeletons
- Existing projects need updates

**Implementation:**
- Update skeleton templates in llm-collab, llm-subtask
- Update bin scripts that reference these directories
- Update SKILL.md documentation
- Update existing projects (or document migration path)
