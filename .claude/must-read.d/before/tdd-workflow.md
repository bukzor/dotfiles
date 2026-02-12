# TDD Workflow

For Python in `github.com/bukzor/` repos, also read `bukzor-python-tdd.md`.

When writing new code with tests:

## Red-Green Cycle

1. Write failing tests (one or several)
2. Run, confirm failures have useful error messages
3. Fix one failure at a time with minimal code
4. Repeat

## Responding to Error Types

**Name resolution errors** (import, undefined) — Only make the name exist. Stub body.

**Assertion failures** — Implement minimal logic to pass.

## Test Quality

Each failing test should produce a *useful* error. If the message is incidental
(e.g., "division by zero" when the real issue is missing initialization),
the test is asserting too much at once—or tests are running out of dependency order.
