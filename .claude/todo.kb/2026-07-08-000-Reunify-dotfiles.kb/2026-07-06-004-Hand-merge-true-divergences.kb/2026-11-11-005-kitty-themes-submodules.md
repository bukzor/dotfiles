---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-07-06-004-Hand-merge-true-divergences.md  # "kitty.conf + .gitmodules"; ".themes/"
  - ../2026-07-06-002-Stale-seed-adjudication.md  # its kitty.conf/.gitmodules findings
  - ../2026-11-10-000-Fold-wsl-buck-win10-into-main.md  # merge step: `.gitmodules` gained `.claude/sessions.kb`
---

# Kitty config, `.themes/`, and the merged submodule set

**Parent:** <../2026-07-06-004-Hand-merge-true-divergences.md> (wave 1, escalated from 002)

## Problem Statement

Linked: main's `.config/kitty/kitty.conf` `include`s a theme from main-only
submodule `kitty-gruvbox-theme`, so the conf and `.gitmodules` merge
together. The parent gives the shape: union of main's kitty customization
and svelte's `linux_display_server x11`; a merged submodule set (svelte's
plus main's, checking `scratch`'s two remotes for which is current).

Decided (user, 2026-11-10): `.themes/` is svelte's `Gruvbox-GTK`; main's
`gruvbox-dark-gtk` submodule goes, entry and gitlink.

Every submodule in the merged `.gitmodules` must exist as a gitlink on both
branches at the same commit, and each recorded commit must be on its
remote (`git ls-remote`). Adding a gitlink on a branch that lacks it is
`git update-index --add --cacheinfo 160000,<sha>,<path>` plus the
`.gitmodules` entry; no checkout needed.

No kitty here: check `kitty.conf` statically (every `include` resolves to a
tracked file on both branches).

**Scope (only these files):** `.config/kitty/` (conf and theme submodule),
`.themes/`, `.gitmodules`, and the gitlinks it names, in both workspaces;
this handoff file.

## Steps

## Decisions

## Open Questions

## Final report
