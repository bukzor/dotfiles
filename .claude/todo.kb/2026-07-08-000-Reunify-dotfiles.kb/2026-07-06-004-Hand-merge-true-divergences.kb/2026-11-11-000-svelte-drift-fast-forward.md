---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-07-06-004-Hand-merge-true-divergences.md  # "svelte-side drift since 2026-07-13"
  - ../2026-07-06-001-Mechanical-file-fast-forwards.md  # how the earlier fast-forward batch was done
---

# Svelte-side drift: fast-forward main to svelte's

**Parent:** <../2026-07-06-004-Hand-merge-true-divergences.md> (wave 1, "svelte-side drift")

## Problem Statement

The parent lists files where main holds an older svelte version: `.bashrc`,
`.gitignore`, `.profile_test.sh`, `.tmux.conf`, `bin/.gitignore`,
`bin/tmux-cd`, `.config/sh/env.d/{300-homebrew,700-tmpdir}.sh`,
`.config/sh/functions.d/{path,path_test,source_dir}.sh`.

For each, verify the premise first: main's blob at that path appears in
svelte's history (`git log --format=%H --find-object=<blob>` or
equivalent). Where it holds, set main's file to svelte's (mode included).
Where it doesn't (main has its own edit since, e.g. from the wsl fold, as
for `.gitignore`), the file is a real merge: author the union, land it on
both, or raise it as an Open Question if the union needs a judgment call.

One commit on main for the true fast-forwards, naming `svelte-crostini` and
its commit id as counterpart. Run `redo -k test` in both workspaces after
(main's suite exists too; see `../2026-07-07-000-CI-and-testing-foundations.md`).

**Scope (only these files):** the eleven paths above, in both workspaces;
this handoff file.

## Steps

- [x] premise: main's blob for all eleven is in svelte's history at that path
      (`.gitignore` too: main's blob is svelte's `9cb75f1`, edited since in
      `00c9c99`). `.bashrc`: same blob, mode only (main 755, svelte 644).
- [x] main: `git checkout origin/svelte-crostini -- <eleven>`, check, commit, push
- [x] checks: `sh -n`, `tmux -f`, `redo -k test` in both workspaces
- [x] prove: `git diff origin/main origin/svelte-crostini -- <eleven>` empty
- [x] svelte: nothing to land but this file; `status: done`, commit, push

## Decisions

- `.bashrc` takes svelte's 644: content was already identical, it is sourced
  never executed, and the brief says "mode included". Main's 755 dates to 2015.

## Open Questions

## Final report

- main `c354b55` (pushed): all eleven paths now carry svelte's blob and mode.
  Counterpart: svelte `13cf6c0`. No svelte content commit was needed.
- Proof: `git diff origin/main origin/svelte-crostini -- <eleven>` is empty.
- Checks: `sh -n` on the seven sh files and `bash -n bin/tmux-cd` pass;
  `tmux -f /dev/null new-session \; source-file .tmux.conf` exits 0 with no errors.
- `redo -k test` on main: everything passes, including `mechanical-fast-forwards`,
  whose `bin/tmux-cd` check this commit fixed, except `zsh -i sets a prompt`.
  That one fails on a pre-change baseline clone too. It passes on svelte, so the
  gap is main-only zsh startup content, outside this scope.
- `redo -k test` on svelte: everything passes except `pnpm starts` in
  `stale-seed-adjudication`. Svelte's `package.json` pins `pnpm@12.8.1`, and
  this host's pnpm 10.14.0 fails to switch to it (ENOEXEC). This unit changed
  no svelte content.
- Deviation: the brief expected `.gitignore` to be a real merge, but it is
  not. Main's blob is svelte's `9cb75f1`, and svelte edited it later in `00c9c99`.
- Until 006 merges, main's `.tmux.conf` calls `bin/cron-status` and
  `bin/tmux-rename-window`, which exist only on svelte. No host runs main
  live, so nothing breaks.
- Logs: `~/trash/reunify-000-{main,svelte}-redo.log`.
