# Gap - Can't Strengthen

Unable to write test that catches the bug.

## Starting conditions

- Mutation selected
- No existing test catches it
- Multiple attempts to write test fail

## Trace

```
Procedure 5: Inject bug
Procedure 6 → Harden Tests:
  Step 0: Add test, run → PASS (attempt 1)
  Step 0: Improve test, run → PASS (attempt 2)
  Step 0: Try different approach, run → PASS (attempt 3)
         → 2-5 attempts exceeded
         revert test changes, mark status: gap
         document ## Test Result
Procedure 7: Repeat
```

## Outcome

status: gap, attempts: 3

## Notes

Bug may require integration test infrastructure, complex setup, or domain knowledge beyond current scope. Deferred to Opus.
