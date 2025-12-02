# Create category overview files for references.d/

**Priority:** Low
**Complexity:** Low
**Context:** references.d/ has three categories without overview/index files

## Problem Statement

references.d/ has three category directories without guidance on what they contain or when to read them:
- file-types.d/
- guidelines.d/
- workflows.d/

Users/LLMs may not know which category to load for their question.

## Proposed Solution

Add overview files at category level:

**Option A: README.md per category**
```
references.d/file-types.d/README.md
references.d/guidelines.d/README.md
references.d/workflows.d/README.md
```

**Option B: CLAUDE.md per category (LLM-specific guidance)**
```
references.d/file-types.d/CLAUDE.md
references.d/guidelines.d/CLAUDE.md
references.d/workflows.d/CLAUDE.md
```

**Option C: Both** (README for humans, CLAUDE.md for agents)

**Option D: Single references.d/README.md** (index all three categories)

## Implementation Steps

- [ ] Decide on pattern (A, B, C, or D)
- [ ] For each category, document:
  - Purpose (1-2 sentences)
  - When to read (use cases)
  - File listing with brief descriptions
- [ ] Consider: Do we need CLAUDE.md with maintenance guidance per category?

## Success Criteria

- [ ] Clear entry point for each category
- [ ] Users/LLMs can quickly find relevant file
- [ ] Pattern is consistent across all categories

## Notes

Current state: files exist but no category-level index. Users must `ls` to discover files.
