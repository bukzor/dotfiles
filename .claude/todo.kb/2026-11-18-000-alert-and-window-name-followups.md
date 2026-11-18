---
managed-by: Skill(llm-subtask)
status: open
---

# Alert and Window-Name Follow-ups

**Context:** the open follow-ups in
`~/.claude/sessions.kb/penguin.kb/tmux-window-naming-and-alert-identity.md`;
design rationale in
`~/docs/dev/devlog/2026-09-10-001-tmux-window-naming--a-precedence-ladder--not-a-program-list.md`;
`alert` claims in `~/docs/dev/user-attention.claims.kb/channels.kb/`.

## Problem Statement

Four follow-ups to the shipped `alert` / window-naming work, which the user
asked (2026-11-18) to have addressed by sub-agents. Two concern `bin/alert`'s
log, two concern `.tmux.conf`'s `automatic-rename-format`. The user's
request to address them is the ruling the claude-mark fix was waiting on.

## Success criteria

- A logging failure in `alert` cannot turn a delivered alert into a non-zero
  exit; `~/.local/state/alert.jsonl` has a bounded size.
- The claude mark survives truncation of any long claude title; the
  truncation budget has been exercised at a narrow width.
- Both branches (`main`, `svelte-crostini`) carry the result identically.

## Steps

Wave 1 (parallel, disjoint files):

- [x] [alert log: warn on failure, bounded size](2026-11-18-000-alert-and-window-name-followups.kb/2026-11-18-000-alert-log.md)
- [x] [window name: pin the claude mark, test narrow](2026-11-18-000-alert-and-window-name-followups.kb/2026-11-18-001-window-name-truncation.md)

Coordinator, after wave 1:

- [x] review both units' commits; cherry-pick to `svelte-crostini`; push both
- [ ] update the sessions.kb entry's follow-ups
- [ ] `tmux source ~/.tmux.conf` on the live server once the user approves
