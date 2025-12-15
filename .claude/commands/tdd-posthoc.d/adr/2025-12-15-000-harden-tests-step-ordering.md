# Harden Tests step ordering

**Date:** 2025-12-15
**Status:** Accepted

## Context

Harden Tests needs to: (1) ensure tests catch the bug, (2) verify tests are specific enough, (3) confirm tests pass with correct code. The ordering of these checks matters.

## Decision

Order: 0 → 1 → 2
- Step 0: Add/improve test, run tests (should fail)
- Step 1: Try buggy-passing code (verify specificity)
- Step 2: Revert bug, run tests (should pass)

## Alternatives Considered

### Run specificity check first (1 → 0 → 2)
- **Pros:** Catches weak tests early
- **Cons:** Can't check specificity without a failing test first - nothing to verify against

### Skip step 2 (0 → 1 only)
- **Pros:** Simpler, fewer steps
- **Cons:** Misses over-constrained tests that reject correct code (false positives)

## Consequences

**Positive:**
- Step 0 before 1 ensures we have a failing test to verify
- Step 2 catches false positives before marking done

**Negative:**
- Three steps instead of two (more complex)

**Neutral:**
- Order is now fixed; changing it would break the logic

## Related

- Related to: docs/dev/scenarios.kb/gap-over-constrained.md (step 2 catches this)
