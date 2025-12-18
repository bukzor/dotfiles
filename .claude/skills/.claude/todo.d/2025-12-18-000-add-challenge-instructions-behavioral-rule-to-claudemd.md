<anthropic-skill-ownership llm-subtask />

# Add challenge-instructions behavioral rule to CLAUDE.md

**Priority:** High
**Complexity:** Low
**Context:** [Devlog: docs/dev/devlog/2025-12-18-000-silent-conflict-resolution-failure-and-claudemd-behavioral-improvement.md](../../docs/dev/devlog/2025-12-18-000-silent-conflict-resolution-failure-and-claudemd-behavioral-improvement.md)

## Problem Statement

Claude exhibits silent conflict resolution: when user instructions conflict with observed reality (code, dependencies, requirements), Claude works around the conflict without stating it. This wastes turns and hides important information from the user.

**Incident:** User said "delete line 12" from init-docs.sh. Claude observed line 18 depended on directory created by line 12, but tried to replace instead of delete (silently resolving) rather than stating "this would break line 18."

## Current Situation

**~/.claude/CLAUDE.md Position Defense section** (lines 19-22) contains:
- Defend Claude's conclusions unless you cannot find a legitimate way to maintain them
- Treat disagreement and questioning as requests for deeper analysis, not grounds for immediate reversal
- Propagate corrections -- trace revised assumptions to their source and re-evaluate

These rules address defending Claude's positions when challenged, but don't address challenging user instructions when they conflict with observed reality.

**Current diff in working tree** (uncommitted):
- Line 15 added: "Am I reversing a position I just held? If so, can I articulate the specific flaw in my reasoning that made me wrong? If not, defend the position."
- This addresses flip-flopping, not the instruction-conflict problem

## Proposed Solution

Add new bullet to Position Defense section:
```markdown
- Challenge instructions that conflict with observed reality
```

Creates the dual/inverse of existing "Treat disagreement as requests for analysis":
- Existing: When YOU challenge ME → analyze deeper
- New: When I observe YOUR instruction conflicts with reality → speak up

**Expected effectiveness:** 50-60%
- Conflict recognition requires recognizing pattern during tool execution mode
- Indirect conflicts (line 12 affects line 18) harder to catch
- Better than 0%, foundation for iteration

## Implementation Steps

- [ ] Add "Challenge instructions that conflict with observed reality" as third bullet under Position Defense
- [ ] Commit with devlog reference
- [ ] Monitor effectiveness over next 5-10 sessions
- [ ] If <50% effective, consider strengthening to "Before tool calls: state unexpected consequences you observe"

## Open Questions

- Should this be positioned differently (e.g., under Response Structure or as its own section)?
- Is "conflict with observed reality" clear enough, or too abstract?
- Alternative phrasing: "State conflicts between instructions and code/dependencies before acting"?

## Success Criteria

- [ ] Rule added to CLAUDE.md under Position Defense
- [ ] Future incidents of instruction-reality conflicts result in Claude stating the conflict before acting
- [ ] No increase in false positives (challenging valid instructions)
- [ ] Effectiveness measured over 10+ sessions

## Notes

**Why not more aggressive rule:**
"Before tool calls: state unexpected consequences you observe" would be ~80% effective but:
- Too vague, risks false positives
- More workflow interruption
- Start with minimal viable improvement

**Measurement approach:**
- Track via devlog: how many times did Claude surface conflicts vs work around them?
- User feedback via tool rejections still needed (training signal)
