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
6 conflicts as of 2026-11-10 (against svelte: 95, no merge base). Once merged,
main ↔ svelte is a two-lineage problem again.

## Implementation Steps

- [ ] unit tests first (vague reminder): 006's merge-tree conflict check,
      parametrized by ref pair, covers this merge too
- [x] commit or park the uncommitted state in buck-win10's `~` — sub-agent
      units, wave 1 (parallel), in `2026-11-10-000-Fold-wsl-buck-win10-into-main.kb/`:
    - [x] [000 WSL shell settings](2026-11-10-000-Fold-wsl-buck-win10-into-main.kb/2026-11-10-000-wsl-shell-settings.md)
    - [x] [001 misc config review](2026-11-10-000-Fold-wsl-buck-win10-into-main.kb/2026-11-10-001-misc-config-review.md)
    - [x] [002 untracked triage](2026-11-10-000-Fold-wsl-buck-win10-into-main.kb/2026-11-10-002-untracked-triage.md)
    - [x] [003 `.claude/` uncommitted](2026-11-10-000-Fold-wsl-buck-win10-into-main.kb/2026-11-10-003-claude-dir-uncommitted.md)
    - [x] `.config/windows/**` AppData bind mount persisted as runit service
          `windows-appdata` in the new per-host tree `.config/runit/buck-win10/`
          (`/etc/service` now links there); drifted settings committed —
          `8a0b0b2`, `a624d07` (2026-11-10)
    - [x] user rulings on the units' Open Questions (2026-11-10)

          > [!@bukzor] 2026-11-10: the units' recommendations stand, except:
          > gh `git_protocol` is ssh on every host; `project/family-bug-tracker`
          > goes; the delta diff filter goes (a failed experiment);
          > `Bash(sudo:*)` belongs in `ask`, and wsl's other `settings.json`
          > drift is incidental.
    - [x] [004 apply the rulings](2026-11-10-000-Fold-wsl-buck-win10-into-main.kb/2026-11-10-004-apply-wave-1-rulings.md) (wave 2)
- [x] in `dotfiles--main`: `git merge wsl-buck-win10` — wave 3,
      [005 merge](2026-11-10-000-Fold-wsl-buck-win10-into-main.kb/2026-11-10-005-merge-into-main.md); resolving
    - [x] retired shell files (`.sh_env`, `.sh_advanced_rc`,
          `.sh_plugins.d/*`; wsl `a271b48`): take main's delete — their
          content lives in svelte `f74b93f`'s `.config/sh` pieces
    - [x] `.gitignore`, `.config/.gitignore` (wsl `80721c6`): take main's side
    - [x] `.claude/{.gitignore,CLAUDE.md,commands/curl.md,settings.json}`
          (add/add): take main's side; 004's claude-config theme does the real
          merge against svelte
    - [x] `.gitmodules`: main's entries plus wsl's `.claude/sessions.kb` one
          (byte-identical to svelte's, so 004's `.gitmodules` theme gets it for
          free); the gitlink itself merges clean
    - [x] `.sh_plugins.d/command-not-found.sh` (rename/delete): accept main's
          delete; the WSL hook (`bin/command-not-found-hook/`) gets a
          `.config/sh` hookup
- [ ] on main, reconcile the `.claude/` the merge brought in against svelte's
      (left alone, it resurfaces as 006 conflicts). Of the 95 wsl ↔ svelte
      conflicts, 65 are stale copies (wsl's blob appears in svelte's history)
      → svelte's version; 135 of the 216 wsl-only paths are files svelte has
      since deleted or renamed (e.g. `docs/default-context/tools.d/` →
      `tools.kb/`) → drop. Wave 4,
      [006 svelte additions](2026-11-10-000-Fold-wsl-buck-win10-into-main.kb/2026-11-10-006-claude-additions-to-svelte.md);
      wave 5, [007 main reconcile](2026-11-10-000-Fold-wsl-buck-win10-into-main.kb/2026-11-10-007-reconcile-main-claude-dir.md).
      Genuine additions, authored once and landed on both:
    - [ ] `reference.kb/data-format-selection.md` +
          `must-read.kb/before/choosing-a-data-file-format.md`
    - [ ] `reference.kb/python/style.md` (uncommitted edit)
    - [ ] `settings.json`: take svelte's. The only intent in wsl's diff was
          `Bash(sudo:*)` deny → ask, which unit 004 lands on svelte (ruling above);
          `model`, `effortLevel`, `autoCompactWindow` were incidental
    - [ ] `skills/llm-chat-librarian` symlink targets differ only by a
          trailing `/` → svelte's (no slash, like its siblings)
    - [ ] `design-rules.kb/mirror-the-sources-distinctions.md`,
          `skills/subagent-handoffs` (wsl `f559249`, `691ab61`); `sessions.kb`
          gitlink (svelte is behind wsl's)
    - [x] `sessions.kb/` is now the `bukzor.claude-sessions` submodule on wsl
          too (`4795ca9`), with this host's live entries under
          `buck-win10.kb/` (`f9c5c03`, `838f45d`); main gets it via the merge
          (2026-11-10)

          > [!@bukzor] 2026-11-10: a Steam ID in a public repo is fine —
          > linking github:bukzor to the Steam account is acceptable.
    - [ ] per-directory `.gitignore` opt-ins (`0d5ea82`): drop — svelte's
          allow-by-default ignore scheme won in 004
- [x] push main — merge `30895e0` (2026-11-10); the reconcile pushes its own commits

## Success Criteria

- [x] `git rev-list main..wsl-buck-win10` is empty
- [x] buck-win10's `~` has no uncommitted or unparked state (2026-11-10; the `sessions.kb` gitlink drifts by design)

## Notes

buck-win10's `~` switches to main at 006 with penguin, not before: until 004
lands, main's `.claude/` is behind the live one.
