# llm.kb Test Scenarios

Manual test scenarios for validating llm.kb skill behavior.

## Running a Test

1. `cd` into a scenario directory
2. Start a fresh Claude session
3. Let Claude read the CLAUDE.md and execute the task
4. Evaluate against the criteria in the scenario's CLAUDE.md

## Adding Scenarios

Each scenario is a directory containing:
- `CLAUDE.md` — Task prompt + evaluation criteria
- `.claude/` — Optional scenario-specific configuration

Scenarios should test specific failure modes or edge cases of the llm.kb pattern.
