--- # workaround: anthropics/claude-code#13003
depends:
  - ../must-read.kb/before/git/running-ANY-git-command.md
  - ../must-read.kb/before/git/commit.md
requires:
  - Skill(llm-collab)
  - Skill(llm-subtask)
  - Command(commit)
---

# Session End

ARGUMENTS: $ARGUMENTS

Default arguments (if none provided): commit; push

Persist your work.

Key questions:

- Will the next claude have more than enough to excel at their followup tasks?
- Are all unfinished work, inconsitencies, "loose ends" documented?
- Is there anything you know that future claude would want or need, but not have?
- Any cleanup we should do before we go, to reduce future claude/user confusion?
- If `Skill(llm-design-kb)`: run the maintenance checklist from that skill

Steps:

- Bash(date -Is)
- Update `~/.claude/sessions.kb/` (see `sessions.kb/CLAUDE.md` for what belongs):
    0. If unsure whether an entry already corresponds to this session,
       try to find one. Search recipes:
       - `grep -rl "uuid: $CLAUDE_CODE_SESSION_ID" ~/.claude/sessions.kb/`
       - `grep -rl "^cwd: $PWD" ~/.claude/sessions.kb/`
    1. If an entry corresponds: update it with what was completed and
       the current state of its follow-ups.
    2. Propose new sibling entries for any follow-up work surfaced
       this session (one entry per distinct line of work). Follow
       `~/.claude/sessions.kb/.template.md` — substitute the
       `$(...)` placeholders.
- Review diff before committing (see `before/git/commit.md`)
- If confident, rectify. Otherwise, ask.
- After changes, re-check the key questions.
- When everything looks good:
  1. summarize the state of affairs for user
  2. Then answer the question: Are we good to go? If not, re-start, from the top.
