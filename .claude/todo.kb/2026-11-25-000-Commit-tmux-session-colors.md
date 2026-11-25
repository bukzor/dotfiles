---
managed-by: Skill(llm-subtask)
status: done
required-reading:
  - ~/.tmux.conf # lines 3-9: the hooks and why they're shaped so
  - ~/bin/tmux-color-auto
  - ~/bin/tmux-color # usage comment at top
---

# Commit the per-session tmux colors

From the tmux-recovery session (`05284fd8`, tmux `claude:5`), to whichever
session owns git in `~` -- the user ruled 2026-11-25: "let that session be
in charge of git. your jurisdiction is tmux."

## Problem Statement

Three files under `~` carry finished, tested work that is uncommitted. The
author doesn't run git here, so the commit is yours. The files contain no
work by other sessions. Nothing else is asked; don't rework the contents.

- `bin/tmux-color` -- colors the current session, `-t SESSION`, or `-g`
  global; it used to set only the global value (`set -s`).
- `bin/tmux-color-auto` -- rewritten from python+`bukzor.sh`+`roll` to bash:
  hashes host and session name to a starting slot in a 12-color palette,
  takes the first color no other session shows. The old version also set a
  global color, which would have recolored every session at once.
- `.tmux.conf` -- `session-created`/`session-renamed` hooks run it. They
  replace the TODO that was at line 4.

Tested on throwaway servers (`tmux -L`) with the real `~/.tmux.conf`:
- six sessions got six distinct colors, including a name with a space;
- a rename recolored the session;
- 15 sessions over 12 colors shared exactly 3;
- `run-shell -b` raced and produced duplicates, so the hooks don't use it.

The hooks are installed on the live server too, so they're already in effect.
`shellcheck` is clean on both scripts.

Push according to the push-vs-hold ruling that `99a8bf8` left for the user.

**Scope (only these files):** `.tmux.conf`, `bin/tmux-color`,
`bin/tmux-color-auto`, and this file.

## Steps

- [x] verify: diffs match the brief; `shellcheck` clean; `tmux -L -f ~/.tmux.conf`
      loads and installs both hooks; `bin/tmux-color` is byte-identical to the
      copy backed up before the 2026-11-25 switch to main (no other edits mixed in)
- [x] commit and push on main

## Decisions

- Pushed. The push-vs-hold question is unruled, but both standing texts
  agree for finished work: `git/conventions.md` says push once stable, and
  `dotfiles-repo/committing.md` holds commits only while you're iterating.

## Open Questions

1. `bin/tmux_color_auto_config.py` (main) now has no callers that
   `git grep` can find. Was it only the old `tmux-color-auto`'s?
   Delete it if so.

## Final report

Committed as described, on main, in one commit with this file.
