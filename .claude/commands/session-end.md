--- # workaround: anthropics/claude-code#13003
depends:
  - ../must-read-before.d/git.md
  - ../must-read-before.d/git-commit.md
---

# Session End

Wrap up the current session by handling loose ends and reviewing changes.

## Workflow

1. **Check for loose ends**: Run `subtask list:` to enumerate incomplete ephemeral work
2. **Triage each item** with user:
   - Complete now (if quick)
   - Persist as tactical todo (`todo push:`)
   - Persist as strategic todo (`new-todo`)
   - Abandon (if trivial/no longer relevant)
3. **Review session changes**: Check git status in relevant directories
   - Current repo: `git status`
   - Skills directory: `git -C ~/.claude/skills status`
   - Other modified repos as needed
4. **Commit changes**: Use `/commit` for each repo with uncommitted work
