# Guardrails: Ambiguous Reference Resolution

**Priority:** Low
**Complexity:** Medium
**Context:** Struggle-bus analysis from 2025-11-21 session

## Problem Statement

During commit creation, communication broke down when user said "the two mentioned files". Claude interpreted this as "the two files we've been discussing" (bin/git-restore-repo, lib/init) rather than "the two files mentioned in the commit message" (CLAUDE.md, TESTING.md).

Even after correctly identifying the files, Claude submitted commands with wrong file counts (3 files, 4 files, 7 files, 2 wrong files) despite user saying "two files" five times.

## Root Cause Analysis

**Primary issue:** Ambiguous reference ("mentioned") not resolved. Claude should have asked "mentioned where?" or immediately checked the commit message.

**Secondary issue:** Not verifying command arguments match explicit constraints. User said "two files" - Claude should count arguments before submitting.

## Proposed Approaches

### Option A: Add "Ambiguous References" Section to must-read-before.d/

Create or update `must-read-before.d/communication-patterns.md`:

```markdown
## Resolving Ambiguous References

When user says "the X mentioned files/items/things", determine WHERE they're referenced:
- In a commit message? Read it first
- In previous conversation? State your interpretation
- In documentation? Link to it
- Unclear? Ask explicitly: "Mentioned where?"

**Don't assume.** Clarify the reference source before acting.
```

**Pros:** General pattern, applies to many situations
**Cons:** May be too abstract, unclear when to apply

### Option B: Add "Command Verification" to Bash Guidelines

Update `must-read-before.d/using-claude-code-tool/Bash.md`:

```markdown
## Command Argument Verification

When user provides an explicit constraint ("just N files", "these M items"):
1. Count your command arguments
2. Verify count matches constraint
3. If mismatch, state your interpretation and ask

Example: User says "commit these two files"
❌ Bad: `git commit file1 file2 file3` (silently wrong)
✅ Good: "I see three files in my command but you said two. Which two: [file1, file2] or [file2, file3]?"
```

**Pros:** Concrete, actionable, ties to tool use
**Cons:** Specific to counting, may not generalize

### Option C: No Guardrails (Current Assessment)

The struggle-bus analysis noted this rail would be "overly-prescriptive and overfit".

**Arguments against adding rails:**
- One-off occurrence (first time this specific pattern)
- Counting is basic competence, not a systemic gap
- Adding rules for every mistake creates noise
- Trust Claude to learn from the correction

**Arguments for adding rails:**
- Pattern may recur (ambiguous references common)
- Explicit constraints are important (count mismatches costly)
- Documentation helps future agent instances
- Low cost to document the pattern

## Recommendation

**Wait and watch.** Don't add guardrails yet.

**Rationale:**
- This was a one-off breakdown under specific conditions
- User corrected it directly and effectively
- Adding premature rails creates documentation debt
- If pattern recurs 2-3 more times, then codify

**Alternative:**
- Note the pattern in session devlog (already done)
- Create this TODO as a reminder
- Re-evaluate after a few more sessions

## If We Do Add Guardrails

**Where:** `must-read-before.d/communication-patterns.md` (new file)

**What:**
```markdown
# Communication Patterns

## Ambiguous References

When the user references something using "the", "those", "these", "mentioned":
- Identify WHERE they're referring to (commit message, prior conversation, docs)
- If unclear, state your interpretation or ask explicitly
- Don't assume based on recent context

## Explicit Constraints

When the user provides a numeric constraint ("two files", "three items"):
- Verify your action matches the constraint before submitting
- Count arguments in commands
- If mismatch detected, clarify before proceeding
```

## Open Questions

- Is this worth the documentation overhead?
- Should we wait for pattern recurrence?
- Is there a lighter-weight way to capture this?
- Does llm-collab-docs skill need a "patterns" doc type?

## Decision

**DEFERRED** - Wait for pattern recurrence before adding guardrails.

Mark this TODO complete if decision stands after review.
