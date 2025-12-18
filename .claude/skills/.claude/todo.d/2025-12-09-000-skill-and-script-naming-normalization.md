<anthropic-skill-ownership llm-subtask />

# Skill and script naming normalization

**Priority:** Medium
**Complexity:** Medium
**Context:** 2025-12-09 session (81ab4787-ec43-4a9f-9f0b-89936807573e)
- Devlog: `docs/devlog/2025-12-09-000-script-standardization-naming.md`
- ADR: `docs/adr/2025-12-09-001-skill-and-script-naming-conventions.md`
- Separate: `docs/adr/2025-12-09-000-...-error-pattern...md` (completed, unrelated)

## Current State (Complete)

All renames executed:

| Skill | Script | Status |
|-------|--------|--------|
| llm-collab | llm-collab-init | done |
| llm-collab | llm-collab-adr | done |
| llm-collab | llm-collab-devlog | done |
| llm-collab | llm-collab-session-start | done (was docs-session-start) |
| llm-subtask | llm-subtask-todo | done |
| llm-subtask | llm-subtask-init | done |
| llm.kb | llm.kb-validate | done |

## Skill Renames

| Old | New | Status |
|-----|-----|--------|
| llm-collab-docs | llm-collab | done |
| subtask | llm-subtask | done |
| llm.d | llm.kb | done |

## Implementation Steps

- [x] Rename skill directories (llm-collab-docs → llm-collab, subtask → llm-subtask)
- [x] Rename scripts to final names
- [ ] Convert llm-collab-session-start → /session-start slash command
- [x] Update internal references (SKILL.md, CLAUDE.md, references/)
- [ ] Write ADRs (see todo.md)

## Unblocked (2025-12-09)

- llm.d → llm.kb: decision made (`llm.kb`)
- llm.d script finalization can proceed
