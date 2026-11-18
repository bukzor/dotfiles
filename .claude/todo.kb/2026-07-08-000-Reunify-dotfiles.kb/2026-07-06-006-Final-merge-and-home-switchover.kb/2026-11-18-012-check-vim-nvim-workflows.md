---
managed-by: Skill(llm-subtask)
status: open
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

## Decisions

## Open Questions

## Final report
