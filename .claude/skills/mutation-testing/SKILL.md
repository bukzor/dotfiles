---
name: mutation-testing
description: "Post-hoc TDD via mutation testing — inject bugs, harden tests"
---

```yaml # workaround: anthropics/claude-code#13003
requires:
  - Skill(llm.kb)
```

# Post-Hoc TDD

Test-driven development applied retroactively to existing code. Use when code exists but test coverage is uncertain.

## Prework: Planning

IMPORTANT: reading the preexisting tests or mutation.kb (before step 3) **will** cause you to entirely fail this task

1. Read the implementation -- understand the code thoroughly before attempting to break it
2. Plan mutations -- before reading tests, existing mutation plans, or running tests: a. List mutations verbally in the
   conversation (not just mentally) b. Assume existing tests are non-functional. The goal is independent reasoning about breakages.
3. **Now** that you've committed to a plan, you may now read preexisting plans -- existing tests and mutation-testing.kb
4. Verify/record mutations -- for each planned mutation:
   - If a file exists that appears to match, read it to verify alignment
   - If no matching file exists, create one with `status: todo`
   - Note which of yours overlap with existing, which are unique

## Principles

- Inject the bug first -- never write tests without a bug injected. The procedure exists to prevent writing tests that pass by
  accident.
- Equality over partial matching -- prefer `assert_eq!(actual, expected)` over `assert!(actual.contains(...))`
- Tests should panic on exceptions -- use `unwrap()` freely in tests; treat it as "assert ok"

## Burn-Down Procedure

1. Pick a mutation -- select a `status: todo` item. If exhausted, ask the user. Stop when neither has more ideas.
2. Inject the bug
3. Harden tests (see below)
4. Repeat

## Harden Tests

Strengthen until tests reliably catch the injected bug:

0. Add or improve a test to catch the bug, then run tests
   - If tests pass:
     - try again, but after 2-5 attempts: revert test changes, mark `status: gap`
       - document what was tried in `## Test Result`
1. Try to create buggy-passing code
   - If you can: repeat from 0
2. Revert bug, run tests -- should pass
   - If pass: `git add` test and implementation changes, mark `status: done`
     - document which tests catch it in `## Test Coverage`
   - If fail: revert test changes, mark `status: gap`
     - document the over-constraint in `## Test Result`

## Tracking

Record mutations in `docs/dev/mutation-testing.kb/`. If it doesn't exist, create it per Skill(llm.kb). Each mutation is one file
with frontmatter per the schema in Appendix A.

- File names describe the mutation -- how to break the code, not the symptom
- Body sections:
  - Description paragraph: what the bug would cause
  - `## Injection`: specific code change to make
  - `## Test Coverage` (done): which tests catch it
  - `## Test Result` (gap): why tests couldn't catch it

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
      todo -- not yet attempted
      done -- tests reliably catch this mutation
      gap -- unable to harden tests (deferred to Opus)
  attempts:
    type: integer
    description: Number of strengthening attempts (required for gap)
```
