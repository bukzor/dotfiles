---
description: Wrap up the session -- sweep loose ends, persist state, commit
argument-hint: "[actions -- default: commit; push]"
---

--- # workaround: anthropics/claude-code#13003
triggers:
  - read:
      - ../must-read.kb/before/git/running-ANY-git-command.md
      - ../must-read.kb/before/git/commit.md
      - Skill(llm-collab)
      - Skill(llm-subtask)
      - Command(commit)

---

# Session End

ARGUMENTS:

> $ARGUMENTS

Default arguments (if none provided):

> commit; push

Persist your work.

Key questions:

- Will the next claude have more than enough to excel at their followup tasks?
- Are all unfinished work, inconsitencies, "loose ends" documented?
- Is there anything you know that future claude would want or need, but not have?
- Any cleanup we should do before we go, to reduce future claude/user confusion?
- Judgment calls awaiting the owner's ruling (agent-standing content,
  chosen defaults): swept explicitly? Finished work doesn't dangle, so
  the loose-ends sweep misses it. The batch belongs in the
  brief/register its ruling sitting reads
  (`Skill(review-open-questions)`), not only in a devlog or breadcrumb.
- If `Skill(llm-design-kb)`: run the maintenance checklist from that skill
- If `Skill(subagent-handoffs)`: is each handoff collection this session
  touched closeable? Closeable means its plan's success criteria pass and
  the user has said they're satisfied on review; passing tests aren't
  enough, and neither is your own judgment. If so, close it per that
  skill's Procedure, Close. If the plan lives in a `todo.kb/`, run
  `todo clear` (`Skill(llm-subtask)`) next to remove the plan file
  itself. If it isn't closeable, keep it: open files are the resume
  state and done files are waiting for review. The sessions.kb entry
  should point at it either way.

  > [!@bukzor] ruled 2026-11-18: session-end includes appropriate
  > handoff cleanup. The gate wording is the agent's.

Steps:

- Bash(date -Is)
- **Sweep loose ends** before persisting:
  1. `subtask list` — enumerate dangling threads from this session (code-fenced).
  2. Classify each item — see [Disposition](#disposition) below.
  3. Confirm choices with user if <90% certainty.
  4. Execute **now** items; then `subtask save` (handles todo.md + todo.kb) and stage any sessions.kb entries.
- Update `~/.claude/sessions.kb/` (see `sessions.kb/CLAUDE.md` for what belongs):
  1. If unsure whether an entry already corresponds to this session,
     try to find one. Search recipes:
     - `grep -Rl "$CLAUDE_CODE_SESSION_ID" ~/.claude/sessions.kb/`
     - `grep -Rl "^cwd: $PWD" ~/.claude/sessions.kb/`
  2. If an entry corresponds: update it with what was completed and
     the current state of its follow-ups.
  3. Propose new sibling entries for any follow-up work surfaced
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
