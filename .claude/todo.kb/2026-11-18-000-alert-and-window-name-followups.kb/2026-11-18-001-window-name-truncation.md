---
managed-by: Skill(llm-subtask)
status: done
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

- [x] Three-branch format: undeclared -> command; `✳ ` title -> mark + body
      trimmed to 23; else trimmed to 24 as before.
- [x] Verify on isolated server (`-L wn`), titles set by OSC 2.
- [x] Narrow-width test; comment in `.tmux.conf`.

## Decisions

- Body budget 23 after the mark, so a claude name is still 24 columns total.
- Third branch keeps the old `s/✳ /MARK/` substitution unchanged, so non-claude
  names resolve exactly as before.
- Keep 24: see Final report.

## Open Questions

- Below ~70 columns the status-right (~40 cols) squeezes the window list
  regardless of name budget. A shorter status-right is out of scope here.

## Final report

Results (80 cols): short claude -> `MARKshort`; long claude ->
`MARK…conversation title here`; 24-char body -> `MARK…` trimmed; long
non-claude -> `…le /home/bukzor/some/dir`; empty and hostname -> command
(`sleep`). Narrow: at 80 cols the current window fits and the list scrolls; at
60 the current name is clipped by status-right. Result lives in the
`.tmux.conf` comment above `automatic-rename-format`. `bin/alert` untouched.
Caveat: `select-pane -T` does not trigger a rename; only real OSC 2 does.
