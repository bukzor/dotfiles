<anthropic-skill-ownership llm-subtask />

# Document cost-saving techniques for bulk operations

**Priority:** Medium
**Complexity:** Low
**Context:** Emerged from #13003/#13005 workaround application - user asked about cost savings when doing 47+ file edits

## Problem Statement

Claude Code agents should know when to use cost-effective techniques for bulk operations rather than expensive direct tool calls. This session demonstrated the cost difference:

- **Direct Edit calls**: ~40-50 tokens each × 47 files = ~2350 tokens (using sonnet)
- **Haiku Task**: ~100-200 spawn overhead + haiku work (cheaper per token)
- **sed via Bash**: ~100 tokens total for all 47 files (most cost-effective)

## Current Situation

User caught me using expensive direct edits for mechanical bulk operations and suggested sed instead. This pattern recognition should be documented for future sessions.

## Proposed Solution

Create `~/.claude/must-read.d/before/making-code-changes.md` or similar entry documenting:

1. **Decision matrix** for bulk operations:
   - 1-3 files: Direct Edit calls (fastest, overhead acceptable)
   - 4-10 files: Consider haiku Task if mechanical/templated
   - 10+ mechanical edits: Use sed/awk/other shell tools via Bash

2. **When sed is appropriate**:
   - Mechanical find/replace across many files
   - Pattern-based edits (line numbers, regex)
   - No contextual analysis needed

3. **When haiku Task is appropriate**:
   - Requires some logic but is straightforward
   - Template-based generation across files
   - Middle ground between Edit and sed

4. **When direct Edit is appropriate**:
   - Few files (1-3)
   - Complex contextual changes
   - Requires reading file content to decide

## Implementation Steps

- [x] Review existing `must-read.d/before/making-code-changes.md` structure
- [x] Add "Bulk Operations Cost Optimization" section
- [x] Include concrete examples from this session (sed for frontmatter workarounds)
- [x] Document the decision matrix clearly
- [ ] Reference from main CLAUDE.md if needed (skipped - file is in must-read.d/before, auto-discovered)

## Success Criteria

- [x] Clear guidance on when to use each approach
- [x] Concrete token cost comparisons
- [x] Examples from real usage (this session)
- [x] Easy to find when planning bulk edits

## Notes

**Session context:**
- Applied workaround to 47 CLAUDE.md files for issue #13003
- Used sed: `sed -i '1s/^---$/--- # workaround: anthropics\/claude-code#13003/'`
- User explicitly guided toward sed after seeing expensive Edit calls
- Proved out on one file first, then xargs over all (good pattern)
