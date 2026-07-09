--- # workaround: anthropics/claude-code#13003
requires:
    - Skill(llm-subtask)
---

# Reunify dotfiles lineages — working agreements

Applies to every task file in this directory. Read before acting on any of them.

## Goal

Converge the two disjoint dotfiles lineages (no common ancestor) to identical
content, then `git merge --allow-unrelated-histories` and live on main.

## Topology (two repos, no worktrees)

- **`~` is the master working location** — the home repo, checked out on
  `svelte-crostini`, live config. Sessions start here. svelte-crostini commits
  happen here and ONLY here.
- **main operations** happen in the plain clone at
  `~/repo/github.com/bukzor/dotfiles` (main checked out). main commits happen
  there and ONLY there.
- Same remote (`github.com/bukzor/dotfiles`) — sync via push/fetch.
- zsh-support and other historical heads: no checkout; read via
  `git show origin/zsh-support:<path>` from either repo.

## Rules

- **Single-writer per branch** (see Topology). Two writable checkouts of one
  branch would fork silently.
- **File ownership:** `.profile`, `.bashrc`, `~/.config/sh/**` belong to
  tasks 000-unification and 005-zsh-port. Task 004 (hand-merges) must not
  touch them. Tasks 001/002 escalate surprises to 004 rather than deciding.
- **Hand-merged content is authored once**, then applied to each branch —
  never merged independently per branch.
- **Mechanical batches run as parallel subagents** where the task file says
  so (001's two directions; 003's per-directory sweeps after keep/delete
  decisions are made). Decisions themselves stay with the user.
- Every convergence commit names its counterpart branch in the message.
- Tests before work: each task file opens with a "unit tests" item. The
  harness is live (redo; `X_test.sh` shell-matrix + run-once `X_check.sh`):
  conventions and remaining foundations work in 2026-07-07-000; built by
  `../2026-07-07-001-shell-function-unit-testing-and-ci-regression-harness.md`
  (done).

## Execution order

Defined by [../2026-07-08-000-Reunify-dotfiles.md](../2026-07-08-000-Reunify-dotfiles.md)
(not by filename sort): CI foundations first, then 000 → (001, 002, 003
parallelizable) → 005 → 004 → 006 strictly last.
