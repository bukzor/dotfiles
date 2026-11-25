---
managed-by: Skill(llm-subtask)
status: done
required-reading:
  - ~/bin/tmux-color-auto # docstring and the ROWS/COLUMNS/VETOED constants
---

# Commit the colortest-grid tmux colors and the creation-race fix

From the tmux session (`05284fd8`, tmux `claude:5`), to the session that
owns git in `~`. Follows `2026-11-25-001-Commit-sticky-tmux-session-colors.md`
and answers its Open Question 1.

## Problem Statement

Two changes, in `bin/tmux-color-auto` and `.tmux.conf` only:

- **Palette:** the user found the 256-color picks garish and asked to use
  `colortest`'s scheme directly. Unsaved names now roll a row (6: colortest's
  rows without the bold variants), then a column (8 ANSI colors) among the
  row's unvetoed cells. The 4 cells the user saw as unreadable in hterm are
  vetoed. These are terminal-theme colors, so they follow each terminal's
  theme. Saved colors are unchanged, including the six in
  `.config/tmux-color-auto.tsv`.
- **Race (your Open Question 1):** reproduced first. Five sessions colored
  right after `new-session` all had that color overwritten by the hook. The
  session-created hook now runs `tmux-color-auto --if-uncolored`, which
  leaves a session that already has its own color alone; after the fix, all
  five kept their color. The rename hook still always recolors. The
  `.tmux.conf` comment about avoiding `run-shell -b` is gone: picks now
  depend only on the name and the config, so concurrent hooks can't collide.

Checked on throwaway servers:
- all 44 unvetoed cells are reachable, and vetoed cells never come up;
- picks are deterministic and skip cells a saved name claims;
- tmux accepted every style.

`black` is clean, and basedpyright reports 0 errors. The live server already
runs the new hook.

**Scope (only these files):** `bin/tmux-color-auto`, `.tmux.conf`, and this
file.

## Steps

- [x] verify: diffs match the brief; `black --check` clean. On a scratch
      server (scratch `XDG_CONFIG_HOME`), five sessions colored right after
      `new-session` all kept their color, an unsaved name got a grid cell
      (`fg=brightblue,bg=default`), and saved `vim` kept `colour28`. That
      closes -001's Open Question 1.
- [x] commit and push on main

## Decisions

## Open Questions

## Final report

Committed as described, on main, in one commit with this file.
`bin/tmux_color_auto_config.py` stays until the user rules.
