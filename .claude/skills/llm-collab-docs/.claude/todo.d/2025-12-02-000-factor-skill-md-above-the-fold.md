# Factor SKILL.md "above the fold"

**Priority:** Medium
**Complexity:** Medium
**Context:** SKILL.md is 330 lines; some content duplicates references.d/ or is too detailed for skill overview

## Problem Statement

SKILL.md mixes high-level skill overview with detailed reference content that belongs in references.d/. This makes the skill harder to scan and creates duplication.

## Current Situation

SKILL.md sections (330 lines total):
- When to Use (~12 lines) ✓ keep
- Core Principles (~88 lines) ✓ keep
- **Common Patterns (~80 lines)** - duplicates/overlaps references.d/
- **Available Helpers (~35 lines)** - script documentation
- **Reference Material (~18 lines)** - just pointers, keep
- **Integration Patterns (~25 lines)** - how-to content
- Adaptation Guidelines (~15 lines) ✓ keep
- Quick Reference (~24 lines) ✓ keep
- Success Indicators (~13 lines) ✓ keep

## Proposed Solution

Keep "above fold" (~150 lines):
- When to Use
- Core Principles (the "why", mental model)
- Reference Material (pointers to references.d/)
- Adaptation Guidelines
- Quick Reference
- Success Indicators

Factor to references.d/:
1. Common Patterns → references.d/workflows.d/ (or new patterns.d/?)
   - "When to Document What" overlaps file-types.d/
   - "ADRs" section → references.d/file-types.d/ADRs.md
   - "Session Coordination" → references.d/workflows.d/
2. Available Helpers → references.d/helpers.d/ or scripts/README.md
3. Integration Patterns → references.d/workflows.d/

## Implementation Steps

- [ ] Review Common Patterns section
  - [ ] Identify what's unique vs duplicated
  - [ ] Decide destination (extend existing files vs new category)
- [ ] Move "When to Document What" content
- [ ] Move ADR details (keep brief mention in SKILL.md)
- [ ] Move Session Coordination content
- [ ] Create scripts/README.md or helpers.d/ for Available Helpers
- [ ] Move Integration Patterns to workflows.d/
- [ ] Update SKILL.md with breadcrumbs to factored content
- [ ] Verify SKILL.md reads well at ~150 lines

## Success Criteria

- [ ] SKILL.md is ~150 lines, scannable
- [ ] No content duplication between SKILL.md and references.d/
- [ ] Clear breadcrumbs guide readers to detailed content
- [ ] All factored content accessible from references.d/
