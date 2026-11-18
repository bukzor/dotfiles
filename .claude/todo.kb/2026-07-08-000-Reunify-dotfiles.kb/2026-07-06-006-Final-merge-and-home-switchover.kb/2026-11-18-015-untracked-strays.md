---
managed-by: Skill(llm-subtask)
status: open
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

## Decisions

## Open Questions

## Final report
