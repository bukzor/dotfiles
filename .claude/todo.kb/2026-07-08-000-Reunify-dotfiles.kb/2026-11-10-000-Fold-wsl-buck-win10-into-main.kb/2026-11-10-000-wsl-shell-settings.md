---
managed-by: Skill(llm-subtask)
status: done
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

- [x] svelte: author `.config/sh` pieces (nix, BROWSER, command-not-found)
- [x] svelte: commit helpers (`bin/wslbrowse`, `bin/wsl-id-un`,
      `.config/nix/nix.conf`, `.config/wslu/.gitignore`)
- [x] svelte: run shell checks, plus a live WSL-env smoke test
- [x] `~`: commit retired-file edits as they stand, plus the same helpers
- [x] report; `status: done`; commit this file

## Decisions

- Nix (`env.d/400-nix.sh`) is guarded on nix.sh existing, not on WSL: Nix
  isn't WSL-specific, and the file test is still inert on penguin. It skips
  once `NIX_PROFILES` is inherited, since nix.sh isn't idempotent.
- `command-not-found` (`rc.d/`) is guarded on WSL and `has
  command-not-found-hook`. The `has` is required: svelte has no hook yet, and
  without one bash re-enters the handler and forks forever (seen in testing).
- No piece needed for `MAKEFLAGS` (already in `env.d/060-basics.sh`,
  unguarded) or the `.sh_advanced_rc` direnv edit (`rc.d/direnv.sh` already
  uses `command -v`; direnv comes from nix's PATH).
- Not authored: `PNPM_HOME`, the npm-global `PATH` entry, `RBENV_ROOT`
  (see Open Questions). They stay in `~`'s commit, so nothing is lost.
- `.config/wslu/` holds wslu's runtime cache, so it gets a `*` `.gitignore`.

## Open Questions

1. `PNPM_HOME` (`.zshrc`) and `~/prefix/npm-global/bin` (`.sh_env`, via
   the tracked `.npmrc`) go against svelte's ADRs `2026-02-13-000` and
   `2026-08-27-000`: `pnpm add -g` is the only installer, configured in
   `.config/pnpm/config.yaml`, and `PNPM_HOME` was considered and rejected.
   Live claude comes from `~/.local/share/pnpm`. **Recommend:** drop both,
   plus `.npmrc`, and at 006 reinstall buck-win10's globals the svelte way.
2. `RBENV_ROOT=~/prefix/rbenv` does nothing: there is no `rbenv` on this
   host, and `~/prefix/rbenv` holds only ruby 2.6.10 from 2023.
   **Recommend:** drop.
3. `run-time.sh` (threshold 50ms→500ms): 005 retired the whole plugin, and
   `.config/sh` has no command-duration feature. **Recommend:** drop. If
   it's wanted, port it as its own unit, since it needs preexec in bash.
4. `setup/wsl.help` is captured `wsl.exe --help` output, Microsoft
   copyright text. It's left untracked. **Recommend:** `mv` it to `~/trash/`.
5. `bin/command-not-found-hook` (outside this unit's scope) calls `has`.
   `bin/has` sources `~/.sh_lib/…` (dangling symlink on svelte). Once
   `.sh_lib` is gone, every unknown command runs `sudo apk add
   command-not-found`. **Recommend:** the hook tests `[ -x
   /usr/libexec/command-not-found ]`. Its `$"…"` is a bashism under
   `#!/bin/sh`. Belongs with 005's `.sh_lib`/gcpenv follow-up.
6. On WSL, `rc.d/upstream-replies.sh` now sends each shell start through
   the hook, because the tool is missing here. Cosmetic.

## Final report

- svelte-crostini `f74b93f` (pushed): `.config/sh/env.d/{400-nix,wsl-browser}.sh`,
  `.config/sh/rc.d/command-not-found.sh`, `bin/{wslbrowse,wsl-id-un}`,
  `.config/nix/nix.conf`, `.config/wslu/.gitignore`.
- wsl-buck-win10 (pushed): `a271b48` commits the retired-file edits as they
  stand. `30910fb` commits the helpers, byte-identical to svelte's. Main gets
  both through the fold merge.
- Checks: `redo -k test` is green except two failures that exist without this
  unit: `mechanical-fast-forwards` (`bin/tmux-cd` differs main↔svelte) and
  `stale-seed-adjudication` "pnpm starts" (this host lacks svelte's pnpm). A
  hermetic WSL smoke test passed: BROWSER is set only under WSL; nix is on
  PATH once, idempotently, and direnv resolves from it; the handler fires in
  bash and zsh only when the hook exists, and never off WSL.
- Deviations: the nix and `has` guards, and OQ 1–2 left unauthored.
  Leftover in `~`: `setup/wsl.help` (OQ 4).
