<anthropic-skill-ownership llm-subtask />

---
required-reading:
  - ~/.claude/skills/llm-collab/SKILL.md
  - ~/.claude/skills/llm-collab/skeleton/
suggested-reading:
  - ~/.claude/skills/llm.kb/SKILL.md
related-effort: ~/repo/github.com/bukzor/prototype.chatfs/.claude/todo.kb/2026-01-02-000-harmonize-with-llm-skills.md
---

# Update skeleton to match docs/dev/ pattern from git-partial

**Priority:** High
**Complexity:** Medium
**Context:** Modern pattern established in ~/repo/github.com/bukzor/git-partial.prototyping

## Problem Statement

The llm-collab skeleton has inconsistent documentation structure:
- Some developer docs at docs/ level (adr/, devlog/, architecture/)
- Some in docs/dev/ (old monolithic files: design-rationale.md, technical-design.md, development-plan.md)
- Doesn't match modern pattern where docs/dev/ contains ALL developer-facing docs

Modern pattern reserves docs/ for user-facing documentation.

## Current Situation

**Skeleton structure (old):**
```
docs/
  adr/
    README.md  (removed devlog/README.md already)
    CLAUDE.md ✓
    YYYY-MM-DD-000-example-decision.md
  architecture/
    overview.md
  dev/
    design-rationale.md
    technical-design.md
    development-plan.md
    devlog/  (empty)
  devlog/
    CLAUDE.md ✓
    YYYY-MM-DD-000-example-entry.md
  examples/
  milestones/
```

**Modern pattern (from git-partial):**
```
docs/
  examples/  (user-facing)
  dev/
    adr/
      CLAUDE.md
      YYYY-MM-DD-000-example-decision.md
    devlog/
      CLAUDE.md
      YYYY-MM-DD-000-example-entry.md
    design.kb/
      CLAUDE.md (to be created)
    milestones.kb/
      CLAUDE.md (pattern exists, not in skeleton)
```

## Proposed Solution

1. Move developer docs under docs/dev/
2. Remove old monolithic files (replaced by design.kb/ pattern)
3. Remove docs/architecture/ (replaced by design.kb/)
4. Update llm-collab-init script
5. Update references.kb/ documentation

## Implementation Steps

- [ ] Move skeleton templates to docs/dev/
  - [ ] mv docs/adr docs/dev/ (if not already done)
  - [ ] mv docs/devlog docs/dev/ (if not already done)
  - [ ] rm docs/dev/design-rationale.md
  - [ ] rm docs/dev/technical-design.md
  - [ ] rm docs/dev/development-plan.md
  - [ ] rm -r docs/architecture
  - [ ] rm -r docs/milestones
- [ ] Create design.kb/ skeleton template
  - [ ] Create skeleton/docs/dev/design.kb/CLAUDE.md explaining pattern
  - [ ] Don't create subdirectories - let projects create what they need
- [ ] Update llm-collab-init script
  - [ ] Change mkdir to create docs/dev/{adr,devlog,design.kb}
  - [ ] Update file copy paths to docs/dev/
  - [ ] Remove docs/architecture/overview.md creation
- [ ] Update references.kb/ documentation
  - [ ] Update file-types.kb/ to document design.kb/ pattern
  - [ ] Remove/update design-rationale.md, technical-design.md, development-plan.md references
  - [ ] Update new-project-setup-checklist.md
- [ ] Update skeleton/ROADMAP.md template to point to docs/dev/milestones.kb/

## Open Questions

- Should design.kb/ CLAUDE.md provide example category names, or be completely generic?
- Keep architecture.md file type reference for legacy projects, or remove entirely?

## Success Criteria

- [ ] All developer-facing docs are under docs/dev/
- [ ] docs/ reserved for user-facing docs (examples/, future guides/)
- [ ] llm-collab-init creates correct structure
- [ ] references.kb/ accurately documents modern pattern
- [ ] No references to removed files (architecture/, old dev/ monoliths)

## Notes

**⚠️ IMPORTANT:** Implementation steps above are tentative and unreviewed by user.
Must confirm with user before executing any changes to the skeleton structure.

Related work:
- Already updated devlog/README.md → devlog/CLAUDE.md with workaround frontmatter
- Already removed static "Recent Entries" sections (ls as source of truth)
- git-partial repo now uses this pattern successfully
