# TDD Workflow

For Python in `github.com/bukzor/` repos, also read `~/.claude/reference.kb/python/tdd.md`.

## Is the test worth it?

Weigh this before writing a test, and when deciding to keep or delete one.

> [!@bukzor] 2026-11-22: "some benefit" is not the bar -- a test needs a good
> ratio of benefit to cost.
>
> - Benefits: it catches a break early, between prototype acceptance and
>   commit (we move fast, so without it breaks land before anyone notices);
>   and its failure pinpoints the broken unit, where a break noticed in use
>   leaves the whole codebase suspect.
> - Costs: initial implementation (zero for an existing test); maintenance,
>   very roughly 1 per LOC; CI time; local pre-commit time, rated 2-10x CI
>   time.

When changing tests or tested code:

## Red-Green Cycle

1. Write failing tests (one or several)
2. Run, confirm failures have useful error messages
3. Fix one failure at a time with minimal code
4. Repeat

If a test passes on first run, it has not been observed failing.
Revert the production change to recover red before re-applying.

## Responding to Error Types

**Name resolution errors** (import, undefined) — Only make the name exist. Stub body.

**Assertion failures** — Implement minimal logic to pass.

## Test Quality

Each failing test should produce a *useful* error. If the message is incidental
(e.g., "division by zero" when the real issue is missing initialization),
the test is asserting too much at once—or tests are running out of dependency order.

Observe each new assertion fail at least once. If a preceding
assertion short-circuits the test before yours runs, that doesn't
count — drive each one in turn to red and observe its distinctive
failure. For post-hoc retrofit where natural red is unrecoverable,
see the mutation-testing skill.
