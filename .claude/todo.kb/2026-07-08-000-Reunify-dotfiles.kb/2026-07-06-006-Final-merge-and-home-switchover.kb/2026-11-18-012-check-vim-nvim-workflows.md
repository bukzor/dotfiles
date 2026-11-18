---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ./2026-11-18-011-claude-on-path-ci-and-defects.md  # Open Question 1; item 2's guards
---

# Check Vim and Check Neovim: make them finish, and pass

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (after the merge)

## Problem Statement

Tentative ruling (user, 2026-11-18: "infer intent, tentative judgments").
Commit on **main** in `dotfiles--main` and push; this handoff file lives on
svelte-crostini.

Check Vim (`check-vim.yaml`) and Check Neovim (`check-nvim.yml`) never
finish on main (unit 011, Open Question 1): `macos-12` jobs queue forever,
and the other jobs exit 127 calling `~/lib/ci/check-*.sh`.

1. Point the run steps at the checkout (`./lib/ci/...` or
   `$GITHUB_WORKSPACE`), and replace retired runner labels with current
   ones (`macos-latest`, and check the others: `ubuntu-22.04`,
   `windows-2022`).
2. Then make each job pass. Where a failure is a real defect in the vim or
   nvim config and the fix is clear, fix it. Where it needs a judgment, or
   a platform can't reasonably be made to pass, record it under Open
   Questions and leave that matrix entry out (or `continue-on-error`), so
   the workflow ends green. Keep unit 011's `timeout-minutes`.
3. Cancel this workflow pair's stale queued runs (`gh run cancel`).
4. Report the first run where both workflows finish green on main.

Afterwards: `git -C ~ pull --ff-only`.

**Scope (only these):** the two workflow files, `lib/ci/check-vim*.sh` and
`lib/ci/check-nvim*.sh`, config fixes that a failing check points at (list
each), `gh run cancel`, the pull, this handoff file.

## Steps

- [x] 1 run steps at the checkout (`shell: bash`, `./lib/ci/...`); scripts derive `ROOT`
- [x] 2 jobs pass (Vim: ubuntu, windows; Neovim: ubuntu)
- [x] 3 stale queued runs cancelled
- [x] 4 first green pair; pull

## Decisions

- Labels: `ubuntu-22.04`, `windows-2022` still exist; `macos-12` -> `macos-latest`
  was tried, but macOS jobs sat queued 10+ min (whole run held open), so macOS
  is out of both matrices.
- `check-nvim.sh`: plenary was never installed and the config was never
  loaded ("E492 Not an editor command"). Now clones plenary to
  `$RUNNER_TEMP`, `set rtp+=`, and `XDG_CONFIG_HOME=$ROOT/.config` so the
  config finds itself. Real `init.lua` loads and tests pass on ubuntu.
- Neovim on Windows dropped: lazy/mason installs (black, isort, tfsec, ...)
  run past a 240s bound, exit 124. Vim on Windows passes.
- `timeout 240` around nvim; `timeout-minutes: 5` kept (briefly 8, reverted).

## Open Questions

1. Neovim on Windows: needs the mason tool installs skipped under CI (an
   env guard in `lsp.lua`/`plugins.lua`), a config judgment. Recommend a
   `CI` guard that skips mason-tool-installer, then re-add windows-2022.
2. macOS in both matrices: queues forever on this account's runners;
   re-add `macos-latest` when it schedules.

## Final report

- Main commits: `50f0601` (checkout paths, labels), `6f2a3d4` (drop macOS,
  bound nvim), `e19d3b5` (plenary, XDG_CONFIG_HOME), `700228b` (nvim ubuntu
  only). No config files changed.
- First run where both finish green: Check Vim 44363129739 and Check
  Neovim 44363129610 on `700228b` (Check sh and Lint Lua green too).
  Check Vim was also green on `e19d3b5`.
- Stale queued Check Vim/Neovim runs cancelled. `git -C ~ pull --ff-only`
  done (at `700228b`).
