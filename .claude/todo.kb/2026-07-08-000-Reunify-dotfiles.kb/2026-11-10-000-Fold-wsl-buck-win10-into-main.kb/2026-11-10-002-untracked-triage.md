---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-11-10-000-Fold-wsl-buck-win10-into-main.md  # "commit or park", "triage untracked"
---

# Untracked non-config paths in `~`: ignore, or propose a home

**Parent:** <../2026-11-10-000-Fold-wsl-buck-win10-into-main.md> (wave 1, "commit or park")

## Problem Statement

Success for the parent is "`~` has no uncommitted or unparked state". These
untracked paths are mostly not dotfiles. For each, find out what it is
(size, file types, whether it is its own git repo, last mtime, what
references it) and classify:

- **machine-local state** (caches, editor servers, credentials): ignore it.
  Add the entry to root `.gitignore` on `wsl-buck-win10`; also on svelte if
  the path can occur on penguin.
- **content that belongs elsewhere** (a project, notes, data): don't move or
  delete. Record a proposed home in Open Questions; the user decides.

Known context: `claude/` holds live working dirs of other sessions (e.g.
`claude/deadlock/`, where a peer session may be working now);
`.local/share/bukzor.deadlock-data/` relates to the repo
`~/repo/github.com/bukzor/bukzor.deadlock-data`. Read only; touch nothing
inside either. `.config/anthropic/` likely holds a credential: list
filenames only.

Root `.gitignore` already has an uncommitted 1-line edit in `~`; review and
commit it with yours.

**Scope (only these files):**
- read-only: `.config/anthropic/`, `.vscode-server/`,
  `.local/share/bukzor.deadlock-data/`, `docs/games/`, `project/`,
  `router-debug/`, `claude/`
- write: root `.gitignore` in `~` and in the svelte workspace
- this handoff file

## Steps

- [x] survey each path (size, nested repo/remote, last mtime, references)
- [x] `~/.gitignore` on `wsl-buck-win10`: machine-local entries + the
      pending `!.envrc` line; commit, push
- [x] svelte `.gitignore`: entries that the unified ignore needs; commit, push
- [x] handoff record; `status: done`; commit, push

## Decisions

- Machine-local, ignored: `.vscode-server/` (VS Code remote server),
  `.local/share/bukzor.deadlock-data/` (clean clone of
  `bukzor/bukzor.deadlock-data`, data dir of a runit service),
  `.config/anthropic/` (credentials: `active_config`,
  `configs/default.json`, empty `credentials/`), and `claude/` as a holder
  of per-session repos, the same thing svelte's `claude/.gitignore` does.
- `.config/anthropic/` went into `~/.config/.gitignore`, not root: that
  file's `![!.]*` opt-in outranks the root `.gitignore`. Out of the brief's
  write scope; no sibling's scope names it.
- Svelte: added only `.vscode-server/` and `/.config/anthropic/`; its
  `claude/.gitignore` and `.local/share/.gitignore` already cover the rest.
  It gets both because it becomes buck-win10's ignore at 006, not only
  because penguin could have them.
- Pending `!.envrc`: committed as is. It belonged with `ed08323`, which
  added `~/.envrc`; main's ignore supersedes it at the merge.

## Open Questions

Content, left untracked in `~`; the user decides:

- `docs/games/deadlock/{deadlock.txt,melee.txt}`: 752 B of Deadlock
  ability-order and melee-damage notes (Mar to Apr 2026), plus a stale
  `.deadlock.txt.swp`. Recommend the `bukzor/deadlock` repo's `docs/`
  (clone at `~/claude/deadlock`). Committing it under `~/docs/` would be
  wsl-only (svelte's `docs/` has none of the old notes).
- `project/family-bug-tracker/`: 216K, its own repo, no remote, a single
  empty commit (2021-12-27), `README.md` staged, `colortest` and `plan.md`
  untracked, 3 stale vim swaps; untouched since 2021-12-28. Recommend:
  keep or drop is yours; if kept, move it to `~/claude/family-bug-tracker`.
- `router-debug/`: 21M, a repo with no commits and no remote; 3 scripts
  staged, `CLAUDE.md` + `.claude/`, 17 debug logs (2026-04-11 to 05-13).
  Recommend moving it to `~/claude/router-debug` (it is a session work dir).
- `claude/`: ignoring it backs nothing up. 4 of its 6 repos have no remote
  (`empty`, `steam-problems`, `windows-forensics`, `windows-ssh-access`),
  and `deadlock` (2 ahead of origin) and `windows-forensics` hold live
  uncommitted work. Penguin does the same; no action proposed.

## Final report

- `wsl-buck-win10` `80721c6` (pushed): root `.gitignore` (+`!.envrc`,
  deadlock-data, `.vscode-server/`, `/claude/`) and `.config/.gitignore`
  (+`anthropic/`). After it, only `docs/games/`, `project/` and
  `router-debug/` are untracked in scope.
- `svelte-crostini` `1ae26af` (pushed): `.gitignore` +`.vscode-server/`,
  +`/.config/anthropic/`. Main gets it when main and svelte converge (004/006).
- For the merge unit: `80721c6` adds 2 conflicts to `main` ←
  `wsl-buck-win10` (8 total, per `git merge-tree`): `.gitignore` and
  `.config/.gitignore`. Take main's side for both.
- Deviation: one early plain `git status` refreshed the stat cache in
  `project/family-bug-tracker/.git/index`; no content changed. Every later
  read of a nested repo used `--no-optional-locks`.
