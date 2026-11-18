---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ~/.claude/todo.kb/2026-11-18-000-alert-and-window-name-followups.kb/CLAUDE.md
  - ~/.tmux.conf (the automatic-rename-format block and its comments)
  - ~/docs/dev/devlog/2026-09-10-001-tmux-window-naming--a-precedence-ladder--not-a-program-list.md
  - ~/.claude/sessions.kb/penguin.kb/tmux-window-naming-and-alert-identity.md (Open follow-ups, the two about truncation; Notes for whoever picks this up)
---

# Window name: pin the claude mark, test the budget narrow

**Parent:** <https:../2026-11-18-000-alert-and-window-name-followups.md> (wave 1)

## Problem Statement

Two follow-ups on `.tmux.conf`'s `automatic-rename-format`:

1. The claude mark (U+EC82, substituted for claude-code's `✳ ` title prefix)
   sits at the head of the name, but names are trimmed from the left to a
   24-column budget, so any claude title over 24 columns loses the mark.
   Pin the mark and truncate only the body after it (the sessions entry
   suggests a three-branch format; any equivalent works). Non-claude names
   must behave exactly as now. The user's request to address this is the
   ruling it was waiting on.
2. The 24-column budget was picked against one terminal's width and never
   tested narrow. Exercise it on an isolated tmux server at a narrow client
   width (e.g. 80 columns and below, with several windows) and decide
   whether 24 stays. Record the finding where the next reader of the format
   will see it (the `.tmux.conf` comment), briefly.

Verify on an isolated server (`tmux -L <name> -f ~/.tmux.conf`): set pane
titles with OSC 2 (or `select-pane -T`) to a short claude title, a long
claude title, a long non-claude title, empty, and the hostname; check the
resolved `#{window_name}` for each. `bin/alert` reads `#{window_name}`, so
whatever the format resolves is also the alert title; nothing to change
there.

**Scope (only these files):** `.tmux.conf`, this handoff file.

## Steps

## Decisions

## Open Questions

## Final report
