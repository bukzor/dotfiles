# Destructure must-read-before.d/creating-documentation.md into references.d/ llm.d structure

**Priority:** Medium
**Complexity:** Medium
**Context:** Part of moving from monolithic docs to llm.d categorized structure

## Problem Statement

creating-documentation.md is a single 780-line file. Need to split into focused, categorized files following llm.d pattern for better LLM consumption.

## Current Situation

- Single large file in must-read-before.d/creating-documentation.md
- Some content missing (ADRs, ROADMAP, docs/milestones, docs/architecture)
- Some content incorrect (will be fixed in prior task)

## Proposed Solution

Split into references.d/ with llm.d-style categorization:
- Each category gets its own subdirectory
- Small focused files within each category
- Category-level README.md with reading guidance

## Implementation Steps

1. [ ] Finalize references.d/ categorization structure
   - [ ] Review existing content in creating-documentation.md
   - [ ] Review SKILL.md for missing pieces (ADRs, ROADMAP, etc.)
   - [ ] Define categories (e.g., file-purposes/, guidelines/, patterns/)
2. [ ] Split content into small focused files
   - [ ] Extract sections from creating-documentation.md
   - [ ] Add missing documentation for ADRs, ROADMAP, docs/milestones, docs/architecture
   - [ ] Create category README.md files with reading guidance
3. [ ] Update references to point to new structure

## Open Questions

- What categories make most sense for the content?
- Should we keep creating-documentation.md as a high-level overview that links to references.d/?

## Success Criteria

- [ ] All content from creating-documentation.md is in references.d/
- [ ] Missing pieces (ADRs, ROADMAP, etc.) are documented
- [ ] Each file is focused and < 200 lines
- [ ] Category READMEs provide clear reading guidance

## Notes

Depends on: "Fix errors in must-read-before.d/creating-documentation.md" task completing first
