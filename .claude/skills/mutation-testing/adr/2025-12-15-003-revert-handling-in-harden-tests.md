# Revert handling in Harden Tests

**Date:** 2025-12-15
**Status:** Accepted

## Context

Bug must be reverted after testing. Question: should main procedure or Harden Tests handle the revert?

## Decision

Harden Tests step 2 reverts the bug as part of verifying correct code passes. Main procedure does not have a separate "Revert" step.

## Alternatives Considered

### Main procedure reverts (step 7)
- **Pros:** Clear separation - Harden Tests only hardens, main procedure cleans up
- **Cons:** Redundant - Harden Tests step 2 already reverts to test correct code

### Both revert
- **Pros:** Defense in depth
- **Cons:** Confusing, redundant, suggests something might not be reverted

## Consequences

**Positive:**
- No redundant step in main procedure
- Revert naturally integrated with "verify correct code passes" check
- Cleaner main procedure (7 steps not 8)

**Negative:**
- Revert is implicit in step 2's description ("Revert bug, run tests")

**Neutral:**
- Must read Harden Tests to know where revert happens

## Related

- Related to: docs/dev/adr/2025-12-15-000-harden-tests-step-ordering.md
