---
managed-by: Skill(llm-subtask)
status: done
required-reading:
  - ~/bin/tmux-color-auto # docstring: the behavior and the config's home
  - ~/.config/tmux-color-auto.tsv
---

# Commit sticky tmux session colors

From the tmux session (`05284fd8`, tmux `claude:5`), to the session that
owns git in `~` (user's ruling 2026-11-25). Follows `966e249`, which came
from `2026-11-25-000-Commit-tmux-session-colors.md`.

## Problem Statement

A session's color now sticks to its name, on every host. The user asked
for it: "A session named "xxyyzz" manually set to green today will cause a
new session named "xxyyzz" to be green, even after reboot", with the
config "under .config, persist it across hosts".

- `bin/tmux-color-auto` -- rewritten in python (stdlib only). It applies a
  session's saved color, else picks one from the name and the config alone.
  So a name's color no longer depends on which other sessions exist or what
  order they were created in. `--save` records a session's current color.
- `bin/tmux-color` -- after it colors a session, it runs `--save` for it.
- `.tmux.conf` -- only the comment above the hooks changed.
- `.config/tmux-color-auto.tsv` -- new and must be tracked, since it carries
  colors across hosts. It's seeded with the six sessions' current colors.

Tested on a throwaway server, with `XDG_CONFIG_HOME` pointed at scratch:
- the same names in reverse order got the same colors;
- a saved color survived a server restart;
- renames take the new name's color;
- `--save` without a color of its own exits 1, and a bad flag exits 2;
- with all 12 colors saved, a new name shares its hashed one.

`black` and `shellcheck` are clean. basedpyright reports 0 errors, plus
3 strict warnings about unused return values.

This answers your Open Question 1 in `-000`: `bin/tmux_color_auto_config.py`
is an abandoned draft of allow/deny rules for which colors are allowed (it
references a `Color` that is never defined). Nothing uses it, and the
palette in `tmux-color-auto` covers its purpose. The tmux session
recommends deleting it. That's the user's ruling to make, so delete it only
if they rule so.

**Scope (only these files):** `bin/tmux-color-auto`, `bin/tmux-color`,
`.tmux.conf`, `.config/tmux-color-auto.tsv`, and this file.

## Steps

- [x] verify: diffs match the brief; `shellcheck` and `black --check` clean;
      re-ran on scratch servers (scratch `XDG_CONFIG_HOME`): the same colors
      in reverse creation order, `vim` got its saved `colour28`, `--save`
      recorded a manual color, and it survived a new server
- [x] commit and push on main, with `.config/tmux-color-auto.tsv` tracked

## Decisions

- Left `bin/tmux_color_auto_config.py` in place: deleting it waits on the
  user's ruling. Recommendation: delete it.

## Open Questions

1. (for the tmux session) The hook colors a session asynchronously, after
   `new-session` returns. My first test read too early and saw only the
   global color. A manual `set`, or `tmux-color`, right after a session is
   created was overwritten by the hook, and then `--save` stored the hook's
   pick. That's harmless for people typing commands, but a script that
   creates a session and then colors it will lose the race.

## Final report

Committed as described, on main, in one commit with this file.
