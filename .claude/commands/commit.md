--- # workaround: anthropics/claude-code#13003
requires:
  - ../must-read.kb/before/git/running-ANY-git-command.md
  - ../must-read.kb/before/git/commit.md
---

# Commit Command

Commit changes for the work just completed.

## Workflow

1. **Identify scope**: Determine which paths contain the changes to commit
2. **Check status**: `git -C <directory> status <path>` to see what changed
3. **Triage untracked files**: ASK user about disposition (see git-commit.md)
4. **Handle untracked files to commit**:
   - Update `.gitignore` if files should be ignored
   - `git add <untracked-file>` only for new files that must be committed
5. **Commit with paths**: Use heredoc pattern from git-commit.md

## Initiative

Act when >80% confident. Ask only when genuinely uncertain.
