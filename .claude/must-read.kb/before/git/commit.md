---
triggers:
  - read:
      - ~/.claude/reference.kb/git/commit.md
      - ./running-ANY-git-command.md
---

# Before committing

Tooling, message format, history-rewriting policy, and recovery are authoritative
in the required reference. Always commit via `git commit-staged` / `git commit-files`
with explicit paths — never bare `git commit`.

## Commit eagerly — always

Commit each coherent, verified change as soon as it is verified. Don't batch it,
don't hold it for a session-end sweep, and don't ask permission first. This
overrides any default reticence about committing unbidden.

Uncommitted verified work is the expensive state: it puts `git` out of reach for
the questions it exists to answer ("how did this behave at HEAD?"), so recovery
and A/B get done with file copies instead — version control by `cp`. It also
strands work behind one rejected tool call.

Symptom to catch early: reaching for a backup copy of a tracked file. That means
the commit should already have happened.

## Untracked files

**Prefer asking** when disposition is unclear. Use judgment for obvious cases.

- **Unrelated work**: Leave as-is
- **Scratch files**: `mv trash/` (prefer over `rm`)
- **Build artifacts**: Gitignore
- **Legitimate new files**: Commit

## Pre-commit checklist

- Review the full diff
  - Verify it matches intent
  - Catch your own mistakes
  - Notice if other agents' changes got mixed in
- Double-check docs still accurate after code changes
- If (CLAUDE.md depends on) `Skill(llm-subtask)`: update todo files
- If `Skill(llm-collab)`: update devlog if session-notable

Include doc/todo updates in the commit.
