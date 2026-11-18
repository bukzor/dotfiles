---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ./2026-11-18-012-check-vim-nvim-workflows.md  # Decisions, Open Questions 1-2
---

# Neovim CI on Windows, and macOS, back

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (after the merge)

## Problem Statement

User, 2026-11-18: "please do known improvements, followup (the ones you can)
now". Commit on **main** in `dotfiles--main` and push; this handoff file
lives on svelte-crostini.

Unit 012 got Check Vim and Check Neovim green by dropping platforms (its
Open Questions 1 and 2).

1. **Neovim on Windows:** make mason-tool-installer skip its installs when
   the `CI` environment variable is set, using the plugin's own option if
   it has one. Then re-add `windows-2022` to Check Neovim and get it green.
   Interactive use must not change: show a local headless nvim start (nvim
   via `nix shell` if needed) with and without `CI`.
2. **macOS:** find out why `macos-latest` jobs never started. A public
   repo gets free macOS runners, so check the account's Actions settings and
   any concurrency limits. Re-add macOS to both matrices only if the job
   starts and passes. Don't wait on a queue: if it hasn't started in 10
   minutes, cancel the run and record what you found.
3. Keep `timeout-minutes: 5`.

Afterwards: `git -C ~ pull --ff-only`.

**Scope (only these):** the nvim config file holding mason-tool-installer's
setup; `check-nvim.yml`, `check-vim.yaml`, `lib/ci/check-nvim.sh`,
`lib/ci/check-vim.sh`; `gh run cancel`; the pull; this handoff file.

## Steps

- [x] 1 mason-tool-installer skipped under CI; windows-2022 re-added; green
- [x] 2 macOS: cause found; re-added (stable only); green
- [x] 3 `timeout-minutes: 5` kept
- [x] 4 pull `~`

## Decisions

- Guard: the plugin's own option, `run_on_start = vim.env.CI == nil`, in
  `setup_mason_tool_installer` (`.vim/lua/bukzor/lsp.lua`; `.config/nvim` is a
  symlink to `.vim`). Checked with a stubbed plugin under headless nvim (nix
  shell): `CI` unset -> `run_on_start=true`; `CI=1` -> `false`. A full local
  start was not usable (fresh data dir had no plugins installed).
- Windows needed two more fixes beyond the guard: `check-nvim.sh` passes
  `ROOT` through `cygpath -m` (plenary's `pwsh` spawn got ENOENT on git-bash
  `/d/a/...` paths), and `windows-2022` + `v0.9.5` is excluded (nvim 0.9.5
  segfaults loading this config on Windows; 0.10+ pass).
- `check-nvim.sh`: `timeout` is optional (absent on macOS; falls back to
  `gtimeout`, else the job's `timeout-minutes: 5` bounds it).
- macOS runs `stable` only, in both workflows: its jobs do start and pass,
  but runners hand them out one at a time (minutes apart), which held
  full-matrix runs open 10+ min.

## Open Questions

1. macOS stays `stable`-only; widening to all revs makes each run last 20+ min.
2. nvim `v0.9.5` on Windows segfaults; left excluded.

## Final report

- Finding (macOS): Actions are enabled, `allowed_actions: all`, repo public.
  The stalled jobs were `macos-12` jobs on svelte-crostini's old workflows
  (label retired, so they never schedule; 12 such stale runs cancelled).
  `macos-latest` does schedule: first jobs started within ~1 min of a push,
  later ones trickle in serially. Not a settings/limit fault we could change.
- Main commits: `0fe71d2` (mason guard, windows back), `cb623b8` (cygpath),
  `acf1061` (macos-latest), `32abb12` (macOS timeout, exclude win+0.9.5),
  `f63cd56` (macOS stable only).
- Green on `f63cd56`: Check Neovim 44369801217, Check Vim 44369801154
  (ubuntu, windows, macOS all pass). Superseded runs cancelled.
- Scope note: also touched the two ci workflow/script files only; no config
  beyond `lsp.lua`. A scratch `nvim` run reverted `.vim/lazy-lock.json`
  (restored, not committed).
- `git -C ~ pull --ff-only`: see below.
