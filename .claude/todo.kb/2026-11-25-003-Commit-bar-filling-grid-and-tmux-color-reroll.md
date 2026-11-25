---
managed-by: Skill(llm-subtask)
status: done
required-reading:
  - ~/bin/tmux-color-auto # docstring usage; ROWS and VETOED
---

# Commit the bar-filling color grid and `tmux-color-auto --seed`

From the tmux session (`05284fd8`, tmux `claude:5`), to the session that
owns git in `~`. Follows `2026-11-25-002-Commit-colortest-grid-tmux-colors.md`.

## Problem Statement

Two changes, both in `bin/tmux-color-auto`, both from the user's review of
live demos:

- **Grid:** the user ruled out cells that leave the bar the terminal's
  background ("it looks too much like the bottom bar is missing"). So the two
  text-color rows are gone, and the two remaining cells that leave the bar
  black are vetoed: background black, and reverse black. 27 cells remain.
  The user's verdict on the re-demo was "seems pretty durn good".
- **`--seed TEXT [SESSION]`:** the user asked for back the re-roll the old
  script allowed, where its only argument was the seed. The new option
  re-rolls with TEXT mixed into the name, then applies and saves the result.
  A session's own saved color doesn't block its re-roll; other names' saved
  colors still do. Calls without a seed pick exactly as before.

Checked:
- logic: no picked cell leaves the bar black, all 27 cells are reachable,
  and seeds are deterministic;
- on a throwaway server (scratch `XDG_CONFIG_HOME`): seed 2 repeats, seed 3
  saves, the saved color survives a restart, and bad usage exits 2.

`black` is clean, and basedpyright reports 0 errors.

**Scope (only these files):** `bin/tmux-color-auto` and this file.

## Steps

- [x] verify: diff matches the brief (4 rows x 8 columns minus 5 vetoed is
      27); `black --check` clean. On a scratch server (scratch
      `XDG_CONFIG_HOME`): `--seed 2` gave the same color both times, with
      `--seed 3` run in between; it was saved; it survived a new server;
      bare `--seed` exits 2.
- [x] commit and push on main

## Decisions

## Open Questions

## Final report

Committed as described, on main, in one commit with this file.
