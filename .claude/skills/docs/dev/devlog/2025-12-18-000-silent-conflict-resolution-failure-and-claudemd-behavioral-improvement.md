# Devlog: 2025-12-18

## Focus

Investigate and address Claude's failure mode: silently working around conflicts between user instructions and observed reality instead of stating the conflict.

## What Happened

### The Incident

While cleaning up llm-collab-docs skill (separating task management to subtask skill), user requested: "delete line 12" from `init-docs.sh`.

**Line 12:** `mkdir -p .claude/todo.d`

**Observed conflict:** Line 18 creates `.claude/README.md`, requiring the `.claude` directory to exist.

**Claude's behavior:** Instead of stating "deleting line 12 would break line 18", Claude repeatedly attempted to:
1. Replace `mkdir -p .claude/todo.d` with `mkdir -p .claude` (not a deletion)
2. When rejected, retry the same workaround without discussion
3. Continue for 3+ attempts without surfacing the conflict

### Root Cause Analysis

Claude has strong instruction-following bias. When given direct instruction "delete line 12", the bias toward compliance overrides the observation that the instruction conflicts with code reality.

**Missing behavioral pattern:** No explicit instruction to "state conflicts between user instruction and observed reality before acting."

### Solution Exploration

**Phase 1: Zero-token improvement attempt**

Goal: Reorder existing CLAUDE.md sections to position behavioral rules where they're active during tool execution.

Attempted moves:
- Professional objectivity section → discovered this is Claude Code's system prompt, not editable
- Required Reading section → not applicable to this problem
- Behavioral Rules to position #1 → doesn't address the specific failure (those rules are about defending Claude's positions, not challenging user instructions)

**Conclusion:** No zero-token solution exists. Existing CLAUDE.md doesn't address "challenge instructions that conflict with reality."

**Phase 2: Minimum effective addition**

Proposed: Add to **Position Defense** section:
```markdown
- Challenge instructions that conflict with observed reality
```

**Cost:** 7 words

**Expected effectiveness:** 50-60% (might not trigger during deep tool execution mode)

**Rationale:** Creates the dual/inverse of "Treat disagreement as requests for analysis":
- Existing rule: When YOU challenge ME → analyze deeper
- New rule: When I observe conflicts with YOUR instruction → speak up

### Mental Simulation

Simulated younger Claude's thought process with proposed rule:

1. "User said delete line 12"
2. "But line 18 needs `.claude/` directory"
3. Would "Challenge instructions that conflict with observed reality" fire?
   - Conflict is downstream/indirect (line 12 affects line 18)
   - Already in tool execution mode
   - Might not recognize as "conflict with reality" in the moment

**Assessment:** 50% chance of success because:
- Relies on recognizing pattern while in execution mode
- Conflict is indirect (not immediate)
- Tool execution bias may still dominate

**To reach 80% effectiveness would require:**
"Before tool calls: state unexpected consequences you observe"
- But vaguer, risks false positives
- More interruptive to workflow

### Decisions Made

**Decision:** Add behavioral rule despite 50-60% effectiveness estimate

**Rationale:**
- Best available option at minimal token cost
- Improvement over 0% (current state)
- Can iterate if insufficient

**Alternative considered:** More interrupt-y rule about "unexpected consequences"
- Rejected: Too vague, false positives, workflow friction

**Impact:**
- Future Claudes should surface conflicts more often
- Won't solve 100% of cases (need user behavioral feedback via rejections)
- Creates foundation for iteration

## Next Session

1. Add the behavioral rule to `~/.claude/CLAUDE.md` under Position Defense
2. Monitor effectiveness over multiple sessions
3. Consider strengthening if 50-60% proves insufficient

## Links

- Strategic TODO: `.claude/todo.d/2025-12-18-000-add-challenge-instructions-rule-to-claudemd.md` (to be created)
- CLAUDE.md current state: Lines 19-22 (Position Defense section)
