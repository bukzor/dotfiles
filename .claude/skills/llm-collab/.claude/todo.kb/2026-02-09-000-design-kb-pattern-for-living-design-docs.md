# Design .kb pattern for living design documentation

**Priority:** Medium
**Complexity:** Medium
**Context:** Replace static design-rationale.md etc with llm.kb-style progressive docs

## Problem Statement

The skeleton included static design doc templates (`design-rationale.md`, `technical-design.md`, `development-plan.md`) that weren't used in practice. They became stale because they lack:
1. Integration with llm.kb's context-aware loading
2. Policy triggers to keep them fresh

## Solution (Designed 2026-02-09)

Numbered abstraction levels with why[] traceability, plus cross-cutting technical policy:

```
docs/dev/
├── design.md                    # Summary
├── design/
│   ├── CLAUDE.md                # Points to pattern doc
│   ├── 000-background.kb/       # Context outsiders need
│   ├── 010-mission.kb/          # Why this exists
│   ├── 020-goals.kb/            # Objectives
│   ├── 030-requirements.kb/     # Key results (traces to goals)
│   ├── 040-design.kb/           # Structures/architecture
│   ├── 050-components.kb/       # System pieces
│   └── 060-deliverables.kb/     # Maps to source code
├── technical-policy.md          # Summary
└── technical-policy.kb/         # Cross-cutting normative guidance
```

Key properties:
- Levels form five-whys stack: "why?" up, "how?" down
- why[] frontmatter enables upward traversal
- All levels optional -- projects grow into structure
- Pattern doc at references/how-to-document-design-knowledge.md

## Implementation Steps

1. [x] Design the structure and traceability model
2. [x] Document the pattern (references/how-to-document-design-knowledge.md)
3. [x] Create skeleton/docs/dev/design/CLAUDE.md (breadcrumb only)
4. [x] Update llm-collab-init to create design/CLAUDE.md
5. [x] Add freshness hooks (session-end reminder, ADR script output)
6. [x] Remove stale file references from SKILL.md
7. [x] Update SKILL.md quick reference to mention design knowledge pattern

## Removed Files (for reference)

These were in `skeleton/docs/dev/` before removal:
- `design-rationale.md` - placeholder for design rationale
- `technical-design.md` - placeholder for technical design
- `development-plan.md` - placeholder for development plan

Also removed:
- `skeleton/docs/architecture/` - redundant with CLAUDE.md
- `skeleton/docs/milestones/` - superseded by llm-subtask
- `skeleton/docs/examples/` - unused

## Success Criteria

- [x] Pattern documented
- [x] Skeleton updated
- [x] Init script creates breadcrumb
- [x] Freshness hooks installed
- [x] SKILL.md references cleaned up
