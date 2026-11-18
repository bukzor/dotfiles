---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-07-06-004-Hand-merge-true-divergences.md  # "claude config": the 2026-11-18 ruling
---

# `.claude/CLAUDE.md`: main takes svelte-crostini's

**Parent:** <../2026-07-06-004-Hand-merge-true-divergences.md> (wave 2, "claude config")

## Problem Statement

The user ruled that all four of main's extra rules are dropped. So main's
`.claude/CLAUDE.md` becomes `origin/svelte-crostini`'s blob, byte for byte,
in one commit on main that names svelte-crostini as its counterpart.
Svelte needs no commit.

The switch of this host's live `~` to main
(`../2026-07-06-006-Final-merge-and-home-switchover.kb/2026-11-18-000-switch-buck-win10-home-to-main.md`)
is waiting on this unit. Push promptly.

**Scope (only these files):** `.claude/CLAUDE.md` in the main workspace;
this handoff file.

## Steps

- [x] fetch both workspaces; main clean at `b1876c4` = origin/main
- [x] write `origin/svelte-crostini:.claude/CLAUDE.md` over main's; commit, push

## Decisions

None: the ruling left no judgment call.

## Open Questions

None.

## Final report

- main `6bfc6f4` (pushed): `.claude/CLAUDE.md` only, svelte's blob byte
  for byte; message names svelte-crostini as counterpart. Svelte: no commit.
- Proof: `git diff origin/main origin/svelte-crostini -- .claude/CLAUDE.md`
  is empty.
- No parse check applies (Markdown).
- The switch of buck-win10's `~` to main is unblocked by this unit.
