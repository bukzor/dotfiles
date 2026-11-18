---
managed-by: Skill(llm-subtask)
status: open
blocked-by:
  - ./2026-11-18-006-claude-tokens-prices-and-breakdown.md
  - ./2026-11-18-007-pre-merge-followups.md
required-reading:
  - ./CLAUDE.md
  - ../2026-07-06-006-Final-merge-and-home-switchover.md  # Implementation Steps: tests first, preflight, merge, review
  - ./2026-11-18-004-ignores-and-gitmodules.md  # Open Question 2: what the merge will collide with in ~
  - ../2026-07-07-000-CI-and-testing-foundations.md  # the X_check.sh shape
---

# The 006 merge, and buck-win10's `~` taking it

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md>

## Problem Statement

Main and svelte-crostini now merge with zero conflicts (2026-11-18). Do the
parent's steps up to and including "push main", then bring this host's `~`
onto the merged main. Penguin's switch is the user's, on penguin, and is
out of scope.

1. **Tests first:** a run-once `X_check.sh` asserting the merge-tree
   conflict count is 0 (the parent's first step). Then run the merged-tree
   suite in a scratch checkout, as the parent says. Show the suite failing
   on a deliberately conflicting scratch pair, so you know it can fail.
2. **Merge** svelte-crostini into main in `dotfiles--main` with
   `--allow-unrelated-histories`, using a message that names both
   lineages. Review: `git diff main svelte-crostini` should show only the
   paths that exist only on main. Spot-check that they survived. Push main.
3. **Pull into `~`.** The fast-forward will refuse over the four
   untracked-but-incoming paths that the ignores unit listed (`.aws/`,
   `.azure/`, `package.json`, and `.ssh/id_ed25519.pub` is resolved by unit
   007). For each:
   - **`.aws` and `.azure`** are symlinks into Windows here, and svelte
     tracks a `.gitignore` inside each. Pick a layout where `git status` is
     clean and the AWS and Azure CLIs still read the Windows-side files.
     For example, a real directory with the tracked `.gitignore`, plus
     per-file symlinks into `/mnt/c`. Prove it: `aws configure list`, or
     whatever exists, still works.
   - **`package.json`:** diff it against svelte's. Move the local copy to
     `~/trash/` and record what differed.
   Then pull, and rerun the parent's smoke test on this host.

   Also (unit 007's Open Question; tentative judgment, user 2026-11-18): this
   host's `~/.ssh/id_rsa.pub` (`worki@buck-win10`) is a real file that the
   new `/id_*.pub` rule hides. Track it on main as
   `.ssh/id_rsa.pub.worki.buck-win10`, and make the plain name a link to it.

Record the merge commit and the pre-pull commit in your Final report, and
the rollback for each.

**Scope (only these):** the merge commit and the check script in
`dotfiles--main`; moves and symlinks in `~` for the paths above; `git pull`
in `~`; this handoff file.

## Steps

## Decisions

## Open Questions

## Final report
