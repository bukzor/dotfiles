# Inject Bug First

Never write tests without a bug injected.

## Rationale

Tests written without a bug to catch tend to pass by accident. The test author imagines what "should" fail, but without concrete wrong behavior to detect, tests often:
- Assert properties that hold for both correct and buggy code
- Check happy paths while missing edge cases
- Pass because the assertion is too weak

## Violation symptoms

Haiku writes a test, runs it, it passes. Marks done. But the test doesn't actually catch the bug - it would pass with buggy code too.

## Discovery

Observed repeatedly: Haiku would jump straight to writing tests when asked to do post-hoc TDD. Tests passed, but mutation testing later revealed they caught nothing.

## Enforcement

Principles section leads the procedure. "Inject bug first" is first principle - read before reaching step 1.
