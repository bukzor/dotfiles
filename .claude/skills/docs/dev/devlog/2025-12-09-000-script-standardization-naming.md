# 2025-12-09: Script standardization and naming conventions

**Session:** 81ab4787-ec43-4a9f-9f0b-89936807573e

## Focus

Standardize error handling and naming conventions across all skill scripts.

## What Happened

### Error Handling Standardization

Applied template pattern to all 6 bash scripts:
- `set -euo pipefail`
- `trap onerror ERR` with handler
- DEBUG support
- Consistent directory-missing errors: `mkdir -p <dir> && !!`

Created ADR: `docs/adr/2025-12-09-000-consistent-directory-missing-error-pattern-across-skill-scripts.md`

### Naming Convention Discussion

Explored subcommand-style naming for scripts. Key decisions:

1. **Skill names need `llm-` prefix** for distinctiveness
   - `llm-collab-docs` → `llm-collab`
   - `subtask` → `llm-subtask`
   - `llm.d` → `llm.kb` (future, blocks other llm.d work)

2. **Script names follow subcommand form**: `supertool-noun[-verb]`
   - Drop `-new` suffix when no other verbs exist
   - Normalize `ensure` → `init`

3. **session-start → /session-start**: Convert to slash command for symmetry with /session-end

### Partial Implementation

Renamed scripts to intermediate names before final convention was settled:

| Skill | Old | Current (interim) | Final |
|-------|-----|-------------------|-------|
| llm-collab-docs | init-docs | docs-init | llm-collab-init |
| llm-collab-docs | new-adr | docs-adr-new | llm-collab-adr |
| llm-collab-docs | new-devlog | docs-devlog-new | llm-collab-devlog |
| llm-collab-docs | session-start | docs-session-start | /session-start |
| subtask | new-todo | task-todo-new | llm-subtask-todo |
| subtask | ensure-todo-md | task-todo-ensure | llm-subtask-init |
| llm.d | validate-frontmatter | llm.d-validate (symlink) | llm.kb-validate |

Also restructured llm.d Python: `lib/` → `lib/python/llmd/`

## Decisions

See ADR: `docs/adr/2025-12-09-001-skill-and-script-naming-conventions.md`

Key points:
- `llm-` prefix for skill names (distinctive family)
- Subcommand form for scripts: `{skill}-{noun}[-{verb}]`
- session-start → /session-start (slash command for symmetry)

## Blocked

- llm.d script finalization blocked on llm.d → llm.kb rename
- llm.kb rename is separate strategic effort

## Next Session

1. Rename skill directories: llm-collab-docs → llm-collab, subtask → llm-subtask
2. Rename scripts to final names
3. Convert docs-session-start → /session-start
4. Update internal references
5. Write 3 ADRs for script organization conventions
