# Cleanup stale path references

**Priority:** Medium
**Complexity:** Low
**Context:** Old design doc patterns removed, references remain

## Problem

Commit a121f5e removed static design templates (design-rationale.md, technical-design.md, development-plan.md) and directories (docs/architecture/, docs/milestones/, docs/examples/). References to these paths remain throughout llm-collab.

## Affected Files

### Critical (skeleton — copied to new projects)

- `skeleton/CLAUDE.md` — references technical-design.md
- `skeleton/HACKING.md` — references docs/architecture/
- `skeleton/README.md` — references docs/examples/

### Documentation (references.kb/)

Entire files about removed patterns:
- `references.kb/file-types.kb/design-rationale.md`
- `references.kb/file-types.kb/technical-design.md`
- `references.kb/file-types.kb/development-plan.md`
- `references.kb/file-types.kb/architecture.md`
- `references.kb/file-types.kb/milestones.md`

Files with stale references:
- `references.kb/workflows.kb/documentation-maintenance-procedures.md`
- `references.kb/workflows.kb/llm-document-consumption-patterns.md`
- `references.kb/workflows.kb/new-project-setup-checklist.md`
- `references.kb/guidelines.kb/documentation-anti-patterns.md`
- `references.kb/guidelines.kb/entry-points-for-common-questions.md`
- `references.kb/guidelines.kb/linking-conventions.md`
- `references.kb/guidelines.kb/keeping-docs-dry.md`

### Testing

- `TESTING.md` — tests for removed skeleton files

## Implementation

1. [ ] Update skeleton files to reference design/ and technical-policy.kb/
2. [ ] Remove or update file-types.kb entries for removed types
3. [ ] Update workflows.kb/ and guidelines.kb/ to reflect new patterns
4. [ ] Update TESTING.md to test new skeleton structure

## Related

- todo.kb/2026-02-09-000 (design.kb pattern) — created the replacement
- todo.kb/2025-12-11-000 — earlier tracking of this same migration
