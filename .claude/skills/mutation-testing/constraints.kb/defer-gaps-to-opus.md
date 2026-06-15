# Defer Gaps to Opus

Haiku executes the procedure. Gaps are deferred to Opus.

## Rationale

Haiku excels at:
- Following structured procedures
- Mechanical test writing
- Iterating within defined bounds

Opus excels at:
- Complex test design
- Architectural understanding
- Handling ambiguous cases

When strengthening repeatedly fails, the problem likely requires Opus-level reasoning.

## Violation symptoms

Haiku spins on a gap, trying increasingly convoluted approaches. Time wasted, no progress.

## Discovery

Observed: Haiku could handle straightforward mutations but got stuck on ones requiring deeper understanding. Marking gap and deferring was more efficient.

## Enforcement

2-5 attempt limit in Harden Tests step 0. Explicit "deferred to Opus" in schema description.
