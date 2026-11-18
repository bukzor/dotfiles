---
managed-by: Skill(llm-subtask)
status: open
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

## Decisions

## Open Questions

## Final report
