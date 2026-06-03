---
requires:
  - ~/.claude/reference.kb/git/commit.md
  - ./ANY-git-command.md
---

# Before committing

Tooling, message format, history-rewriting policy, and recovery are authoritative
in the required reference. Always commit via `git commit-staged` / `git commit-files`
with explicit paths — never bare `git commit`.

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
