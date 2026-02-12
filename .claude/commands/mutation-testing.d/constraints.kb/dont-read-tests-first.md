# Don't Read Tests First

Read implementation only. Plan mutations before seeing tests or existing plans.

## Rationale

Reading tests creates anchoring bias:
- You see what's tested, assume it's sufficient
- You miss what's NOT tested (can't see absence)
- Existing mutation plans short-circuit independent reasoning

Independent analysis surfaces different bugs than "what did someone else think to test?"

## Violation symptoms

Agent reads tests, says "coverage looks good," misses obvious mutations that existing tests don't catch.

## Discovery

When agents read tests first, they proposed fewer mutations and had higher overlap with existing (inadequate) coverage. Independent reasoning found more gaps.

## Enforcement

Step 2 explicitly says "before reading tests, existing mutation plans, or running tests." Principle section reinforces.
