# Create category overview files for references.kb/

**Priority:** Low
**Complexity:** Low
**Context:** references.kb/ has three categories without overview/index files

## Problem Statement

references.kb/ has three category directories without guidance on what they contain or when to read them:
- file-types.kb/
- guidelines.kb/
- workflows.kb/

Users/LLMs may not know which category to load for their question.

## Proposed Solution

Add overview files at category level:

**Option A: README.md per category**
```
references.kb/file-types.kb/README.md
references.kb/guidelines.kb/README.md
references.kb/workflows.kb/README.md
```

**Option B: CLAUDE.md per category (LLM-specific guidance)**
```
references.kb/file-types.kb/CLAUDE.md
references.kb/guidelines.kb/CLAUDE.md
references.kb/workflows.kb/CLAUDE.md
```

**Option C: Both** (README for humans, CLAUDE.md for agents)

**Option D: Single references.kb/README.md** (index all three categories)

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
