---
managed-by: Skill(llm-subtask)
status: open
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-11-10-000-Fold-wsl-buck-win10-into-main.md  # "commit or park", first sub-item
  - ../2026-07-06-005-Port-zsh-config-into-config-sh-structure.md  # how .config/sh is organized
  - ~/repo/github.com/bukzor/dotfiles--svelte-crostini/.config/sh/  # the target structure
---

# WSL shell settings: retired files → WSL-guarded `.config/sh` pieces

**Parent:** <../2026-11-10-000-Fold-wsl-buck-win10-into-main.md> (wave 1, "commit or park")

## Problem Statement

`~`'s uncommitted edits to `.sh_env`, `.sh_advanced_rc`,
`.sh_plugins.d/{command-not-found,run-time}.sh`, `.profile` and `.zshrc`
carry this host's WSL shell settings, in files both other lineages have
retired. Author each live setting once, as a WSL-guarded piece in svelte's
`.config/sh/` structure, and land it on `svelte-crostini`. The merge unit
later carries your svelte commits to main.

The WSL helpers those settings use (`bin/wslbrowse` for `BROWSER`,
`bin/wsl-id-un`, `.config/nix/`, `.config/wslu/`, `setup/wsl.help`) are
untracked in `~`; commit what is real config on svelte alongside the
pieces that use it.

Decided:
- Guard on WSL (`WSL_DISTRO_NAME` or equivalent), so the pieces are inert on
  penguin. Follow `.config/sh`'s existing naming and ordering conventions.
- The `.sh_plugins.d/command-not-found.sh` edit points at
  `bin/command-not-found-hook/`; give it a `.config/sh` hookup (main's side
  deletes the retired file at merge).
- In `~`, commit the retired-file edits on `wsl-buck-win10` as they stand:
  they are this host's live shell until the 006 switchover, and the merge
  into main resolves them by taking main's delete. Commit the same helper
  files on `wsl-buck-win10` too, so `~` ends clean.

Settle and report: anything in the diffs that is stale or no longer wanted
(Open Questions, with a recommendation — don't drop it yourself); any
setting that is not WSL-specific and belongs unguarded.

**Scope (only these files):**
- in `~`: `.sh_env`, `.sh_advanced_rc`, `.sh_plugins.d/command-not-found.sh`,
  `.sh_plugins.d/run-time.sh`, `.profile`, `.zshrc`, `bin/wslbrowse`,
  `bin/wsl-id-un`, `.config/nix/`, `.config/wslu/`, `setup/wsl.help`
- in the svelte workspace: new files under `.config/sh/`, the same helper
  paths, and `.profile`/`.zshrc` only if a hookup requires it
- this handoff file

## Steps

## Decisions

## Open Questions

## Final report
