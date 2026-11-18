---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ./2026-11-18-004-ignores-and-gitmodules.md  # the allow-by-default scheme; Decisions on deadlock-builds-recovery
  - ./2026-11-18-010-buck-win10-post-merge-cleanup.md  # Final report: the Windows home's strays
---

# Untracked strays in `~` and the Windows home

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (success
criterion: `git -C ~ status` clean)

## Problem Statement

User, 2026-11-18: "please do known improvements, followup (the ones you can)
now". Commit on **main** in `dotfiles--main` and push; this handoff file
lives on svelte-crostini.

Untracked in `~`: `.boon/`, `deadlock-builds-recovery/`,
`willy-practice.txt`. Untracked in `/mnt/c/Users/worki`: `*.ps1`
diagnostics, `deadlock-levels.tsv`, `path-backup-before-python-fix.txt`,
`projects/`. (`.claude/sessions.kb` and Windows `.claude/settings.json`
are not yours.)

Sort each into one of three, by looking at its content and dates:
- **machine or tool state:** ignore it in the root `.gitignore`, keeping
  the allow-by-default scheme;
- **agent scratch from a past session** (diagnostic scripts, backups):
  move it to that home's `trash/merge-015/`;
- **user data or hand-written work:** leave it in place and list it under
  Open Questions with a suggested home. Never delete it, and never ignore
  it just to clean the status.

Afterwards: `git -C ~ pull --ff-only` and `git -C /mnt/c/Users/worki pull
--ff-only` (WSL git). Report both homes' `git status --short`.

**Scope (only these):** the root `.gitignore` on main; moves into each
home's `trash/`; the two pulls; this handoff file.

## Steps

- [x] classify each stray by content and mtime
- [x] ignore `.boon/`; move Windows scratch; pull both homes; record

## Decisions

- `.boon/`: tool state (boon, a Deadlock tool: `.install.json` plus ~21MB of
  downloaded game-data JSON, all written 2026-11-18). Ignored as `/.boon/`.
- Windows `01-03*.ps1`, `py-diag.ps1` (June-July diagnostics) and
  `path-backup-before-python-fix.txt` (a PATH dump): agent scratch, moved to
  `/mnt/c/Users/worki/trash/merge-015/`.

## Open Questions

User data left in place, none ignored:
1. `~/willy-practice.txt` (2025-01-05, hand-written practice log). Suggest a
   private notes home (e.g. `private-dotfiles/` or `docs/private`).
2. `~/deadlock-builds-recovery/` (recovered build snapshots, plus a root-owned
   `snapshotter.log`, already covered by `*.log`). Suggest a private repo or
   `private-dotfiles/`.
3. Windows `deadlock-levels.tsv` (2026-06-25, level/souls table): data, not
   scratch. Suggest alongside OQ 2.
4. Windows `projects/godot/` (two Godot projects, `empty` and
   `my-first-godot-project`, with `.godot/` caches): user work. Suggest its
   own repo under `~/repo/`.

## Final report

- main `2588950` (`.gitignore`: `/.boon/`), pushed after rebasing over
  peers' 013/014 commits (their dirty `lsp.lua` delayed the rebase ~2 min).
  `check-ignore -v` confirms the pattern.
- Both homes pulled ff-only to `0fe71d2`.
- `git -C ~ status --short`: ` M .claude/sessions.kb`, `?? deadlock-builds-recovery/`,
  `?? willy-practice.txt`. Windows: `?? deadlock-levels.tsv`, `?? projects/`
  (`.claude/settings.json` no longer modified).
- Deviation: `.gitignore` not mirrored to svelte-crostini (brief names main only).
