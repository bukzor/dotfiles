---
requires:
  - Skill(llm.kb)
---

# Post-Hoc TDD

Test-driven development applied retroactively to existing code. Use when code exists but test coverage is uncertain.

## Procedure

1. **Read the implementation** - understand the code thoroughly before attempting to break it

2. **Plan breakages** - before reading or running tests, list ways to break the code. Assume existing tests are non-functional. Record the plan (see "Tracking" below).

3. **Pick a breakage** - select one not yet addressed from the plan. Consider adding any new ideas that come to mind.

4. **Inject the bug** - modify the implementation to be subtly wrong

5. **Run tests**
   - If tests pass: coverage is deficient, continue to step 6
   - If tests fail: tests already catch this bug - mark as "done", revert, repeat from step 3

6. **Strengthen tests**
   - First, find an existing test whose name suggests it should catch this bug
   - If found, strengthen it to actually catch the bug
   - If not found, add a new test with a clear name describing what it tests (following surrounding style)

7. **Verify test fails** - the injected bug should now cause test failure

8. **Minimally fix** - change the implementation just enough to pass the test. Mark the breakage as "done". Consider adding any new breakage ideas to the plan.

9. **Repeat** - continue from step 3. If plan exhausted, consider new ideas or ask the user. Stop when neither has more ideas.

## Tracking

Record breakage plans in `docs/dev/functional-testing.kb/`. If it doesn't exist, create it per Skill(llm.kb). Each breakage is one file with frontmatter:

```yaml
---
status: todo | done
---
```

- `todo` - not yet attempted
- `done` - verified that an appropriately-named test fails when this is broken

File names describe the breakage (e.g., `mode-changes-ignored.md`, `deletions-not-detected.md`).

## Principles

- **Don't read tests first** - tests may give false confidence; read implementation and reason about what could break
- **Equality over partial matching** - prefer `assert_eq!(actual, expected)` over `assert!(actual.contains(...))`
- **Tests should panic on exceptions** - use `unwrap()` freely in tests; treat it as "assert ok"
- **Minimal fixes expose more bugs** - a fix that passes one test but fails another reveals coverage gaps

## Example Bug Categories

- Missing comparisons (checking A but not B)
- Off-by-one in loops or indices
- Wrong operator (< vs <=, && vs ||)
- Missing null/empty checks
- Type coercion issues
- Boundary conditions
- State mutations in wrong order
- Missing cleanup/rollback on error paths
