# Design .kb pattern for living design documentation

**Priority:** Low (Later)
**Complexity:** Medium
**Context:** Replace static design-rationale.md etc with llm.kb-style progressive docs

## Problem Statement

The skeleton included static design doc templates (`design-rationale.md`, `technical-design.md`, `development-plan.md`) that weren't used in practice. They became stale because they lack:
1. Integration with llm.kb's context-aware loading
2. Policy triggers to keep them fresh

## Current Situation

These files were removed from skeleton (2026-02-09) as unused cruft. But the underlying need remains: projects benefit from living design documentation that's:
- Deeper than CLAUDE.md's architecture overview
- More distilled than reading through all ADRs
- Kept fresh through policy, not discipline

## Proposed Solution

Replace static templates with llm.kb pattern:

```
docs/dev/design.kb/
├── CLAUDE.md          # Load triggers + freshness policy
├── rationale.md       # Living distillation of why
└── technical.md       # How it works at depth
```

**Freshness mechanisms:**
- CLAUDE.md triggers: "Load when making architectural changes"
- Helper script output: "Consider updating docs/dev/design.kb/"
- Possibly: ADR template reminder to check design docs

## Removed Files (for reference)

These were in `skeleton/docs/dev/` before removal:
- `design-rationale.md` - placeholder for design rationale
- `technical-design.md` - placeholder for technical design
- `development-plan.md` - placeholder for development plan

Also removed:
- `skeleton/docs/architecture/` - redundant with CLAUDE.md
- `skeleton/docs/milestones/` - superseded by llm-subtask
- `skeleton/docs/examples/` - unused

## Implementation Steps

1. [ ] Design the design.kb structure and CLAUDE.md triggers
2. [ ] Create skeleton files for docs/dev/design.kb/
3. [ ] Update init script to create design.kb/ structure
4. [ ] Add freshness reminders to llm-collab-adr output
5. [ ] Document the pattern in SKILL.md

## Open Questions

- How aggressive should freshness reminders be?
- Should design.kb be optional (created on demand) or always created?
- What's the right granularity? One big doc vs many small ones?

## Success Criteria

- [ ] design.kb pattern documented
- [ ] Skeleton files exist
- [ ] Init script creates them
- [ ] Freshness policy prevents staleness
