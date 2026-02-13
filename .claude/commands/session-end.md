--- # workaround: anthropics/claude-code#13003
depends:
  - ../must-read.d/before/git/ANY-git-command.md
  - ../must-read.d/before/git/commit.md
requires:
  - Skill(llm-collab)
  - Skill(llm-subtask)
  - Command(commit)
---

# Session End

Persist your work.

Key questions:

- Will the next claude have more than enough to excel at their followup tasks?
- Are all  unfinished work, inconsitencies, "loose ends" documented?
- Is there anything you know that future claude would want or need, but not have?
- Any cleanup we should do before we go, to reduce future claude/user confusion?
- If design.kb/ exists: do the docs still match reality after this session's changes?

Steps:

- Bash(date -Is)
- Review diff before committing (see `before/git/commit.md`)
- If confident, rectify. Otherwise, ask.
- After changes, re-check the key questions.
- When everything looks good:
    1. summarize the state of affairs for user
    2. Then answer the question: Are we good to go? If not, re-start, from the top.
