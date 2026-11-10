# Reunify dotfiles lineages — working agreements

Applies to every task file in this directory. Read before acting on any of them.

## Goal

One lineage, living on main. Three branches carry live config:

- `svelte-crostini` and `main` — disjoint histories (no common ancestor).
  Converge to identical content, then `git merge --allow-unrelated-histories`.
- `wsl-buck-win10` — forked from main's history (2023, `4b003ef`). Folds into
  main with an ordinary merge, before main and svelte converge.

## Topology

> [!@bukzor] 2026-11-10: each branch gets a workspace at
> `~/repo/github.com/bukzor/dotfiles--${branch}/`, created only when edits
> need it. A host's live `~` is the workspace for its own branch; no second
> checkout of it.

Hosts (situational — rewrite when a host is added or retired):

| Host | live `~` | workspaces for other branches |
|---|---|---|
| penguin (Chromebook, crostini) | `svelte-crostini` | `dotfiles--main` |
| buck-win10 (WSL) | `wsl-buck-win10` | `dotfiles--main`, `dotfiles--svelte-crostini` |

- One remote (`github.com/bukzor/dotfiles`); sync via push/fetch. No worktrees.
- The general-purpose `~/repo/github.com/bukzor/dotfiles` clone floats between
  branches for ad hoc use and never carries reunify commits.
- Retired heads are deleted once fully contained elsewhere; read them by
  commit id (e.g. the 2017 zsh setup: `git show 381ee8a:<path>`).

## Rules

> [!DRAFT] 2026-11-10: a branch can now be writable on two hosts, so one
> writer at a time: fetch and fast-forward before editing, push right after
> each commit, never leave a workspace holding unpushed commits.

- **Hand-merged content is authored once**, then applied to each branch —
  never merged independently per branch.
- **Mechanical batches run as parallel subagents** where the task file says
  so. Decisions themselves stay with the user.
- Every convergence commit names its counterpart branch in the message.
- Tests before work: each task file opens with a "unit tests" item. The
  harness is live (redo; `X_test.sh` shell-matrix + run-once `X_check.sh`);
  conventions in 2026-07-07-000.

## Execution order

Defined by [../2026-07-08-000-Reunify-dotfiles.md](../2026-07-08-000-Reunify-dotfiles.md),
not by filename sort.
