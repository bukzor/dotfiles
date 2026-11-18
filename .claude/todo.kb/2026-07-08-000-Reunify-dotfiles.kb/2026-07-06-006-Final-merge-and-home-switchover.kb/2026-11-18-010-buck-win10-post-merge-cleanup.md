---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ./2026-11-18-008-merge-and-buck-win10-pull.md  # Open Questions 1, 3, 4, 5
  - ./2026-11-18-000-switch-buck-win10-home-to-main.md  # the preflight to reuse for the Windows home
---

# buck-win10 after the merge: the Windows home checkout, pnpm 10, orphans, CI

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (after the merge)

## Problem Statement

Tentative rulings (user, 2026-11-18: "infer intent, tentative judgments"):

1. **`/mnt/c/Users/worki`** is a third checkout of this repo, on
   `svelte-crostini`, and isn't in the topology table. Penguin's unit 009
   will rename `svelte-crostini` to `merged/` on origin, possibly while
   this unit runs.
   - Find out what that checkout serves: which tracked files Windows
     programs actually read there, its uncommitted state, and any unpushed
     commits.
   - Then move it to `main` with unit 000's preflight: back up the ignored
     files that main would overwrite, and list what the checkout deletes.
     Mind Windows filesystem semantics: case-insensitivity, symlinks, file
     modes, CRLF. If moving it would break something a Windows program
     relies on, don't switch. Record that under Open Questions with
     options.
   - Add the checkout to the topology table in `../CLAUDE.md` (the
     coordinator allows that one edit).
2. **pnpm 10** in `~/prefix/npm-global/bin`: remove it and keep `claude`.
   Show that a shell started afterwards resolves pnpm 12.
3. **Orphans:** move `~/node_modules/` and `~/pnpm-lock.yaml` (from
   2025-09) into `~/trash/merge-008/`.
4. **CI on main:** report each workflow's result on the merge commit
   (`gh run list`). For `lint-lua.yml`, which was already broken, give the
   cause. If the fix is a one-line config change, make it, using the
   normal two-branch rule. Otherwise put it under Open Questions.

**Scope (only these):** the Windows-home checkout; the `../CLAUDE.md`
topology table; `~/prefix/npm-global/`; the two orphans; CI workflow files
for item 4 only; this handoff file.

## Steps

- [x] 1a survey `/mnt/c/Users/worki`: consumers, dirty state, unpushed (none)
- [x] 1b preflight: collisions, deletions, case clashes; main rehearsed on a scratch Windows `HOME`
- [x] 1c switch to main; topology table
- [x] 2 pnpm 10 out of `~/prefix/npm-global`
- [x] 3 orphans to `~/trash/merge-008/`
- [x] 4 CI on the merge commit; `lint-lua.yml` removed on both branches

## Decisions

- Windows consumers of the checkout: Claude Code (winget) reads `.claude/`
  and runs its hooks under Git Bash; Git for Windows reads `.gitconfig`,
  `.gitconfig.d/`, `.config/git/ignore`; Git Bash sources `.bashrc`,
  `.profile`, `.config/sh/`. Rehearsed main on a scratch `HOME` under Git
  Bash before switching (`win-smoke.sh`): no regression, and the svelte
  `ulimit` startup error is gone. So: switched.
- Switched with WSL git, which wrote this index; `git.exe` sees its LX
  symlinks as `T` and would refuse to delete them.
- Dirty files: `.gitconfig` (lfs filter) and `.config/git/ignore`
  (forward-slash rule) are already in main, so they were dropped.
  `.claude/settings.json`: hook-disable (`"/*pending fix of python3*/"`,
  written 07-02 16:40, six minutes before the python fix) dropped. Python
  3.14 now runs both hooks under Git Bash. Re-applied `theme` and `tui:
  fullscreen` as uncommitted edits, as before.
- Local `svelte-crostini` renamed `merged/svelte-crostini`, upstream unset.
- `~/pnpm-lock.yaml` is not a 2025-09 orphan: pnpm 12 regenerates it on
  every run in `~` to record the pin, and main ignores it. Old copy trashed,
  regenerated one left alone. `node_modules/` (2025-09) trashed.
- `lint-lua.yml` held only a TODO comment (no `on:`/`jobs:`), so it errored
  as a workflow file issue on every push. Deleted on both branches.

## Open Questions

1. **CI is starved by Check sh hanging.** Every Check sh run since 11-11
   was `cancelled` at the 6h default timeout. The hung "Run shell test
   matrix" steps fill all 20 concurrent-job slots; 141 runs queued. Recommend
   `timeout-minutes: 5`, then find the hanging test. Cancelling the queue is
   the user's call.
2. **Fresh shells can't find `claude`.** Main's PATH has neither
   `~/.local/share/pnpm` (what live sessions run) nor `~/prefix/npm-global/bin`
   (kept per brief), and claude is not in `.config/pnpm/global/package.json`.
   Pre-existing since the merge, not caused here. Options: native installer
   into `~/.local/bin`, or add it to the pnpm global manifest.
3. Main defects seen from Windows (also hit WSL): `init.templateDir` names
   `.local/share/git-localhost-store/template-repo`, which main deletes
   (`git init` warns); `.config/sh/rc.d/upstream-replies.sh` prints
   "command not found" when the tool is absent, contrary to its comment;
   `docs/ideas/never?` can't exist on NTFS (`git.exe` shows it deleted).
4. Windows `settings.json` keeps `theme`/`tui` as uncommitted edits. Commit a
   host-local mechanism, or accept the dirty file?

## Final report

- Windows checkout: pre-switch **`c05739c`** (svelte-crostini, 0 unpushed),
  now `main` at `e7994a5` tracking `origin/main`. WSL `git status`: the
  `settings.json` prefs plus 7 untracked strays (`*.ps1`, `deadlock-levels.tsv`,
  `path-backup-before-python-fix.txt`, `projects/`). Rollback:
  `git -C /mnt/c/Users/worki checkout -B svelte-crostini c05739c`, then copy
  back `trash/merge-010/dirty/`.
- Preflight (`/mnt/c/Users/worki/trash/merge-010/`): 1144 incoming paths,
  none on disk; 157 deleted (`deleted.paths`); no case clashes; dirty files
  in `dirty/`. Smoke: `{baseline-svelte,rehearsal-main,after-main}.txt`.
  100 symlinks Windows can't read, none Windows-relevant (`symlinks-unreadable-on-windows.txt`).
- pnpm 10.14.0 moved to `~/trash/merge-008/npm-global-pnpm10/`; `claude`
  kept. Fresh `bash -l` and `zsh -l` resolve `~/prefix/pnpm/bin/pnpm` 12.8.1.
- CI on `ff853dc`: lint-lua `failure` (workflow file issue); Check sh,
  Vim, Neovim `queued` (OQ 1). Stub removed: main **`208ca09`**,
  svelte-crostini **`9b06feb`**.
