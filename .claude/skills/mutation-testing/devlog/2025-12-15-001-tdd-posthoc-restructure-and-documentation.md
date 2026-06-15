# Devlog: 2025-12-15 - tdd-posthoc restructure

## Focus

Restructure tdd-posthoc.md for clarity and Haiku compatibility. Capture session knowledge in docs/dev/.

## What Happened

### Completed

- Restructured Harden Tests as subroutine (steps 0→1→2)
- Added step 2: verify tests pass with correct code
- Added attempt limits (2-5) replacing vague "repeatedly"
- Moved Principles before Procedure
- Created docs/dev/ structure:
  - constraints.kb/ (3 items)
  - instruction-patterns.kb/ (5 items)
  - scenarios.kb/ (5 items)
  - adr/ (4 decisions)
- Added -n/--dry-run to llm-collab-adr
- Fixed llm-collab-devlog skeleton path

### Discovered

- "gap" in working copy removed test writing entirely (wrong)
- Correct approach: defer as fallback after 2-5 attempts
- Step 2 needed to catch over-constrained tests
- Successive subtraction technique for factoring knowledge into .kb categories

## Decisions Made

See docs/dev/adr/:
- 000: Harden Tests step ordering
- 001: Haiku/Opus role split
- 002: Mutation file format
- 003: Revert handling

## Open Questions

- How will Haiku actually perform with restructured procedure?

## Links

- docs/dev/constraints.kb/
- docs/dev/instruction-patterns.kb/
- docs/dev/scenarios.kb/
