--- # workaround: anthropics/claude-code#13003
depends:
  - ../must-read.d/before/git/all-operations.md
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

Steps:

- first, run Bash(date -Is) to check the date -- it may have been many days since the last turn
    - if so you may need to look around to ensure you're up-to-date on current status
- If confident, rectify. Otherwise, ask.
- After changes, re-check the key questions.
- When everything looks good:
    1. summarize the state of affairs for user
    2. Then answer the question: Are we good to go? If not, re-start, from the top.
