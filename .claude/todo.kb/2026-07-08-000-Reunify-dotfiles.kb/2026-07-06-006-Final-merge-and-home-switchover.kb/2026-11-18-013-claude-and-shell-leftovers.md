---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ./2026-11-18-011-claude-on-path-ci-and-defects.md  # Decisions (.claude/local), Open Question 2
  - ./2026-11-18-010-buck-win10-post-merge-cleanup.md  # Open Question 4 (Windows prefs)
  - ../2026-07-06-005-Port-zsh-config-into-config-sh-structure.md  # Follow-up: bin/gcpenv
---

# Leftovers: `.claude/local`, the npm-global `claude`, Windows prefs, `gcpenv`

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (after the merge)

## Problem Statement

User, 2026-11-18: "please do known improvements, followup (the ones you can)
now". Commit on **main** in `dotfiles--main` and push; this handoff file
lives on svelte-crostini.

1. **`.claude/local`** is a tracked dangling link from the 2025 npm "local
   install" (`0acda47`). The native installer treats it as an old install
   and deletes it. Remove it from main. Grep the repo for anything else from
   that era (`.local/share/claude-code`) and remove that too if dead.
2. **`~/prefix/npm-global/bin/claude`:** no session runs it (live sessions
   run `~/.local/share/pnpm/claude`; check with `ps`/`/proc/*/exe`
   first). Move it, and its package, to `~/trash/merge-013/`. Leave the
   pnpm copy alone: running sessions use it.
3. **Windows prefs:** `/mnt/c/Users/worki/.claude/settings.json` carries
   `theme` and `tui: fullscreen` as uncommitted edits to a tracked file.
   Find, in Claude Code's docs, a host-local place for them that the repo
   doesn't track (for example `~/.claude.json` via `/config`, or a
   local settings file). Cite the docs. Move them there, so `git status`
   on the Windows home no longer shows `settings.json`. If no host-local
   home exists, record that under Open Questions and leave the file as is.
4. **`bin/gcpenv`:** check whether it works on main now that `.sh_lib/`
   came back with the merge. Fix it only if it is broken and the fix is
   small. Retiring `.sh_lib/` is out of scope.

Afterwards: `git -C ~ pull --ff-only` and `git -C /mnt/c/Users/worki pull
--ff-only` (WSL git, as unit 010 did).

**Scope (only these):** `.claude/local` and dead claude-code-era paths on
main; `~/prefix/npm-global/`; the Windows home's `.claude/settings.json`
and the host-local file the prefs move to; `bin/gcpenv`; the two pulls;
this handoff file. Not the root `.gitignore` (unit 015 owns it).

## Steps

## Decisions

## Open Questions

## Final report
