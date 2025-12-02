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

1. [x] Finalize references.d/ categorization structure
   - [x] Review existing content in creating-documentation.md
   - [x] Review SKILL.md for missing pieces (ADRs, ROADMAP, etc.)
   - [x] Define categories using successive subtraction (file-types.d/ first)
2. [~] Split content into small focused files (using successive subtraction)
   - [x] Extract file-types.d/ content
     - [x] README.md, HACKING.md, CLAUDE.md
     - [x] design-rationale.md, technical-design.md, development-plan.md
     - [x] devlog.md
     - [x] Move templates to skeleton/
     - [x] design-incubators.md
     - [x] Add ADRs.md documentation
     - [x] Add ROADMAP.md documentation
     - [x] Add milestones documentation
     - [x] Add architecture documentation
   - [x] Identify and extract next category from remainder
     - [x] guidelines.d/ (linking, DRY, subdirs, entry-points, anti-patterns)
     - [x] workflows.d/ (LLM consumption, maintenance, checklist, when to deviate)
   - [x] Repeat until doc fully factored
   - [ ] Create category CLAUDE.md files with maintenance guidance
   - [ ] Create category overview files (file-types.md, etc.)
   - [ ] Create schemas (if needed for frontmatter)
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
