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
- **Sweep loose ends** before persisting:
  1. `subtask list` — enumerate dangling threads from this session (code-fenced).
  2. Classify each item — see [Disposition](#disposition) below.
  3. Confirm choices with user if <90% certainty.
  4. Execute **now** items; then `subtask save` (handles todo.md + todo.kb) and stage any sessions.kb entries.
- Update `~/.claude/sessions.kb/` (see `sessions.kb/CLAUDE.md` for what belongs):
    0. If unsure whether an entry already corresponds to this session,
       try to find one. Search recipes:
       - `grep -Rl "uuid: $CLAUDE_CODE_SESSION_ID" ~/.claude/sessions.kb/`
       - `grep -Rl "^cwd: $PWD" ~/.claude/sessions.kb/`
    1. If an entry corresponds: update it with what was completed and
       the current state of its follow-ups.
    2. Propose new sibling entries for any follow-up work surfaced
       this session (one entry per distinct line of work). Follow
       `~/.claude/sessions.kb/.template.md` — substitute the
       `$(...)` placeholders.
- Review diff before committing (see `before/git/commit.md`)
- If confident, rectify. Otherwise, ask.
- After changes, re-check the key questions.
- Gate before declaring ready:
  - Enumerate every reason we are NOT good to go (e.g., known work not yet well-posed to be done eventually).
  - If anything surfaces, fix and restart from the top.
- Once nothing surfaces, summarize state of affairs for user.

## Disposition

For each loose-end item, choose by scope + effort:

In this project (under `$PWD`):

- under 60 seconds → **now** (do inline)
- under 10 minutes → **`todo.md`** entry
- under 1 hour → **`todo.kb/`** file (strategic, decomposed)

Elsewhere, or more than 1 hour:

- **`sessions.kb/`** entry (global follow-up)

Not worth doing:

- **drop** — with reason
