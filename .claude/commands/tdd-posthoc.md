--- # workaround: anthropics/claude-code#13003
requires:
  - Skill(llm.kb)
---

# Post-Hoc TDD

Test-driven development applied retroactively to existing code. Use when code exists but test coverage is uncertain.

## Procedure

1. **Read the implementation** - understand the code thoroughly before attempting to break it

2. **Plan mutations** - before reading tests, existing mutation plans, or running tests:
   a. List mutations verbally in the conversation (not just mentally)
   b. Assume existing tests are non-functional. The goal is independent reasoning about breakages.

3. **Verify/record mutations** - for each planned mutation:
   - If a file exists that appears to match, read it to verify alignment
   - If no matching file exists, create one with `status: todo`
   - Note which of yours overlap with existing, which are unique

4. **Pick a mutation** - select a `status: todo` item. If exhausted, ask the user. Stop when neither has more ideas.

5. **Inject the bug**

6. **Harden tests** (see below)

7. **Revert** the mutation

8. **Repeat** from step 4

## Harden Tests

Strengthen until tests reliably catch the injected bug:

1. Run tests - should fail
   - If pass: add or improve a test to catch this bug, repeat from 1
2. Try to create buggy-passing code
   - If you can: tighten the test to reject this variant, repeat from 1
3. Revert bug, run tests - should pass
   - If pass: `git add` test and implementation changes, mark `status: done`, return
   - If fail: revert test changes, mark `status: gap`, return

## Tracking

Record mutations in `docs/dev/mutation-testing.kb/`. If it doesn't exist, create it per Skill(llm.kb). Each mutation is one file with frontmatter per the schema in Appendix A.

File names describe the mutation - how to break the code, not the symptom.

## Principles

- **Don't read tests or existing plans first** - tests may give false confidence; existing plans short-circuit your reasoning. Read ONLY the implementation, then reason independently about what could break. Record your plan BEFORE looking at what others identified.
- **Equality over partial matching** - prefer `assert_eq!(actual, expected)` over `assert!(actual.contains(...))`
- **Tests should panic on exceptions** - use `unwrap()` freely in tests; treat it as "assert ok"
- **Minimal fixes expose more bugs** - a fix that passes one test but fails another reveals coverage gaps

## Appendix A: Schema

```yaml
$schema: "https://json-schema.org/draft/2020-12/schema"
title: Mutation Testing
description: Tracks planned code mutations for post-hoc TDD

type: object
required: [status]
additionalProperties: false

properties:
  status:
    type: string
    enum: [todo, done, gap]
    description: |
      todo - not yet attempted
      done - tests reliably catch this mutation
      gap - unable to harden tests (deferred to Opus)
```
