---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-11-10-000-Fold-wsl-buck-win10-into-main.md  # "commit or park", "review the rest"
---

# Misc config in `~`: review, commit on wsl-buck-win10, carry real intent to svelte

**Parent:** <../2026-11-10-000-Fold-wsl-buck-win10-into-main.md> (wave 1, "commit or park")

## Problem Statement

`~` holds uncommitted edits to general config files and two dirty
submodules. For each: read the diff, commit it on `wsl-buck-win10` (one
commit per coherent change, so the merge into main carries it), and decide
whether it is host-local (stop there) or cross-host intent that svelte lacks
(author it once on `svelte-crostini` too). Check svelte's current version
first; much of `~` lags svelte, and a lagging hunk is not intent.

Dirty submodules (`.config/kitty/kitty-gruvbox-theme` is bumped *and* dirty,
`.themes/gruvbox-dark-gtk` is dirty): report what the inner changes are.
Commit the kitty pointer bump if the target commit is pushed upstream; don't
commit inside a submodule.

Untracked: `.zkbd/xterm-256color-*` (zsh key maps per terminal; check how
svelte's `.config/sh/zshrc.d/030-zkbd.sh` and `.gitignore` treat `.zkbd/`),
`.config/fish/conf.d/`.

Settle and report: the svelte commit ids; anything you judge stale and
did not commit (Open Questions, with a recommendation).

**Scope (only these files):**
- in `~`: `.gitconfig`, `.gitignore_global`, `.hgignore_global`, `bin/brew`,
  `bin/yesno`, `setup/alpine/homebrew.sh`, `TODO.md`, `.config/gh/config.yml`,
  `.config/kitty/kitty-gruvbox-theme`, `.themes/gruvbox-dark-gtk`,
  `.zkbd/xterm-256color-*`, `.config/fish/conf.d/`
- in the svelte workspace: the same paths
- this handoff file

(Root `.gitignore` belongs to unit 002.)

## Steps

## Decisions

## Open Questions

## Final report
