# No Test Catches Bug

No existing test fails - must write from scratch.

## Starting conditions

- Mutation selected
- No existing test catches the injected bug
- Tests pass with buggy code

## Trace

```
Procedure 5: Inject bug
Procedure 6 → Harden Tests:
  Step 0: Run tests → PASS (no test catches bug)
         → add new test
  Step 0: Run tests → FAIL ✓
  Step 1: Try buggy-passing → can't create
  Step 2: Revert, run tests → PASS ✓
         git add, mark status: done
Procedure 7: Repeat
```

## Outcome

status: done (after writing new test)

## Notes

Common case for under-tested code. Step 0 loops once to add the test, then proceeds normally.
