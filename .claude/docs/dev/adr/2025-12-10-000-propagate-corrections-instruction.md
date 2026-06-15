# Propagate corrections instruction

**Date:** 2025-12-10
**Status:** Accepted

## Context

During a conversation, Claude misinterpreted "the agent" as self-reference when user meant a different Claude instance. User corrections followed:

1. "no, this is not 'I'" → Claude patched identity but kept wrong instruction reference
2. "the instructions you and I added to must-read/bash" → Claude patched reference but kept wrong temporal assumption
3. "my question was in the past tense" → Claude patched temporal framing but assumed wrong chronology
4. "this has no factual basis" → Claude acknowledged error but didn't investigate

**5 correction turns** before Claude checked timestamps and answered correctly.

**Root cause:** Claude treated each correction as "patch this one element" rather than "your entire interpretation is suspect." This is the **minimal patching antipattern** -- corrections don't propagate through the web of related assumptions.

The existing Position Defense instruction ("Defend established reasoning...") was being applied to interpretations of user intent, not just Claude's conclusions.

## Decision

Add to Position Defense in CLAUDE.md:

```markdown
- Propagate corrections -- trace revised assumptions to their source and re-evaluate
```

Also changed "established reasoning" to "Claude's conclusions" to clarify what should be defended.

## Rationale

### Why "propagate"
Interpretations are webs of interdependent assumptions. When one assumption proves wrong, it's evidence the original reading was flawed. Related assumptions from the same reading are suspect.

### Why "trace to source"
Re-reading/re-evaluating from source naturally surfaces related assumptions. More reliable than trying to enumerate "adjacent" assumptions.

### Why "revised" (not "abandoned" or "forced to cede")
- "abandoned" has emotional charge -- Claude might not pattern-match
- "forced" has loophole -- "I chose to update, wasn't forced"
- "revised" is neutral -- if you're revising, the rule applies

### Alternatives considered
- "When corrected about intent: rebuild" -- too narrow, problem is generic
- "Corrections about intent: re-read original" -- noun phrase not imperative
- Adding shorthand `!` for user to signal corrections -- puts burden on user

## Consequences

**Positive:**
- Corrections should propagate rather than patch minimally
- Clear mandate with mechanism

**Negative:**
- Adds 12 tokens to CLAUDE.md (premium space)
- Untested -- no regression harness exists

## Related

- Struggle-bus skill: forensic analysis of communication breakdowns
- Test-variations pattern: could be adapted to test instruction effectiveness
