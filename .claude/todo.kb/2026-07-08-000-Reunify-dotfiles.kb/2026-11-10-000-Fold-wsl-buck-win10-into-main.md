---
managed-by: Skill(llm-subtask)
status: open
---

# Fold wsl-buck-win10 into main

**Priority:** High — before 004's claude-config theme
**Complexity:** Medium
**Branch:** main (merge commit, in `dotfiles--main` on buck-win10); `.claude/`
additions also land on svelte-crostini (authored once)
**Context:** buck-win10's live `~` is on `wsl-buck-win10`

## Problem Statement

`wsl-buck-win10` is main as of 2023-07 (`4b003ef`, the old wsl-svelte merge)
plus 9 commits: Windows Terminal / AppData integration, the buck-win10 ssh
key, and a 2026-06 content copy of svelte's `.claude/` (`3e298b5`) with local
additions on top. Live `~` on buck-win10 also holds ~24 uncommitted modified
files and several untracked WSL-specific paths.

It shares history with main, so it merges into main with an ordinary merge:
5 conflicts as of 2026-11-10 (against svelte: 95, no merge base). Once merged,
main ↔ svelte is a two-lineage problem again.

## Implementation Steps

- [ ] unit tests first (vague reminder): 006's merge-tree conflict check,
      parametrized by ref pair, covers this merge too
- [ ] commit or park the uncommitted state in buck-win10's `~`
    - [ ] WSL shell settings sit in files both lineages retired: `.sh_env`
          (`MAKEFLAGS`, npm-global + nix `PATH`, `BROWSER=wslbrowse` under
          `WSL_DISTRO_NAME`, `RBENV_ROOT`), `.sh_advanced_rc`,
          `.sh_plugins.d/{command-not-found,run-time}.sh`, plus the nix hook
          in `.profile` and `.zshrc` edits. Author them as WSL-guarded
          `.config/sh/**` pieces, land on svelte + main; nothing goes into the
          retired files.
    - [x] `.config/windows/**` AppData bind mount persisted as runit service
          `windows-appdata` in the new per-host tree `.config/runit/buck-win10/`
          (`/etc/service` now links there); drifted settings committed —
          `8a0b0b2`, `a624d07` (2026-11-10)
    - [ ] review the rest: `.gitconfig`, `.gitignore`, `.gitignore_global`,
          `.hgignore_global`, `bin/brew`, `bin/yesno`,
          `setup/alpine/homebrew.sh`, `TODO.md`, `.config/gh/config.yml`,
          `.config/kitty/kitty-gruvbox-theme` (submodule bump),
          `.claude/settings.json`, `.claude/reference.kb/python/style.md`
    - [ ] triage untracked: `bin/wsl-id-un`, `bin/wslbrowse`,
          `.config/{anthropic,fish/conf.d,nix,wslu}/`, `setup/wsl.help`,
          `.zkbd/xterm-256color-*`, `docs/games/`, `project/`,
          `router-debug/`, `claude/`, `.vscode-server/`,
          `.local/share/bukzor.deadlock-data/`
- [ ] in `dotfiles--main`: `git merge wsl-buck-win10`, resolving
    - [ ] `.claude/{.gitignore,CLAUDE.md,commands/curl.md,settings.json}`
          (add/add): take main's side; 004's claude-config theme does the real
          merge against svelte
    - [ ] `.sh_plugins.d/command-not-found.sh` (rename/delete): accept main's
          delete; the WSL hook (`bin/command-not-found-hook/`) gets a
          `.config/sh` hookup
- [ ] on main, reconcile the `.claude/` the merge brought in against svelte's
      (left alone, it resurfaces as 006 conflicts). Of the 95 wsl ↔ svelte
      conflicts, 65 are stale copies (wsl's blob appears in svelte's history)
      → svelte's version; 135 of the 216 wsl-only paths are files svelte has
      since deleted or renamed (e.g. `docs/default-context/tools.d/` →
      `tools.kb/`) → drop. Genuine additions, authored once and landed on both:
    - [ ] `reference.kb/data-format-selection.md` +
          `must-read.kb/before/choosing-a-data-file-format.md`
    - [ ] `reference.kb/python/style.md` (uncommitted edit)
    - [ ] `settings.json`: wsl's diff is mostly lag behind svelte; carry only
          real local intent (e.g. `model`)
    - [ ] `skills/llm-chat-librarian` symlink targets differ — pick one
    - [x] `sessions.kb/` is now the `bukzor.claude-sessions` submodule on wsl
          too (`4795ca9`), with this host's live entries under
          `buck-win10.kb/` (`f9c5c03`, `838f45d`); main gets it via the merge
          (2026-11-10)

          > [!@bukzor] 2026-11-10: a Steam ID in a public repo is fine —
          > linking github:bukzor to the Steam account is acceptable.
    - [ ] per-directory `.gitignore` opt-ins (`0d5ea82`): drop — svelte's
          allow-by-default ignore scheme won in 004
- [ ] push main

## Success Criteria

- [ ] `git rev-list main..wsl-buck-win10` is empty
- [ ] buck-win10's `~` has no uncommitted or unparked state

## Notes

buck-win10's `~` switches to main at 006 with penguin, not before: until 004
lands, main's `.claude/` is behind the live one.
