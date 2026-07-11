---
managed-by: Skill(llm-subtask)
status: open
related-effort: ~/.claude/sessions.kb/reunify-dotfiles-lineages.md
---

# Reunify dotfiles lineages (supertask)

Converge svelte-crostini ↔ main (disjoint histories, no merge base; 58
shared paths differ) to identical content, merge with zero conflicts, and
live on main.

Working agreements (topology, single-writer-per-branch, file ownership):
[reunify-dotfiles.kb/CLAUDE.md](reunify-dotfiles.kb/CLAUDE.md)

## Execution order

- [x] [reunify-dotfiles.kb/2026-07-07-000-CI-and-testing-foundations.md](reunify-dotfiles.kb/2026-07-07-000-CI-and-testing-foundations.md) — done 2026-07-09; only remaining item (`fetch-depth: 0` for cross-ref checks) is deferred, lands with 001 or 006. Paired with [2026-07-07-001-shell-function-unit-testing-and-ci-regression-harness.md](2026-07-07-001-shell-function-unit-testing-and-ci-regression-harness.md) (done 2026-07-08; one harness decision serves both)
- [ ] [reunify-dotfiles.kb/2026-07-06-000-Shell-config-unification-stutter-steps.md](reunify-dotfiles.kb/2026-07-06-000-Shell-config-unification-stutter-steps.md) — all success criteria met 2026-07-11; only remaining item is deleting superseded `.sh_env`/etc., deliberately deferred until 005 (zsh port) lands
- [ ] [reunify-dotfiles.kb/2026-07-06-001-Mechanical-file-fast-forwards.md](reunify-dotfiles.kb/2026-07-06-001-Mechanical-file-fast-forwards.md) — 001/002/003 mutually independent
- [ ] [reunify-dotfiles.kb/2026-07-06-002-Stale-seed-adjudication.md](reunify-dotfiles.kb/2026-07-06-002-Stale-seed-adjudication.md)
- [ ] [reunify-dotfiles.kb/2026-07-06-003-Main-only-path-triage.md](reunify-dotfiles.kb/2026-07-06-003-Main-only-path-triage.md)
- [ ] [reunify-dotfiles.kb/2026-07-06-005-Port-zsh-config-into-config-sh-structure.md](reunify-dotfiles.kb/2026-07-06-005-Port-zsh-config-into-config-sh-structure.md) — needs 000 landed
- [ ] [reunify-dotfiles.kb/2026-07-06-004-Hand-merge-true-divergences.md](reunify-dotfiles.kb/2026-07-06-004-Hand-merge-true-divergences.md)
- [ ] [reunify-dotfiles.kb/2026-07-06-006-Final-merge-and-home-switchover.md](reunify-dotfiles.kb/2026-07-06-006-Final-merge-and-home-switchover.md) — strictly last

## Operating loop

`cd ~ && claude --model fable`, `/session-start` (picks up this file's goal
block), work one group, `/session-end`. Main-branch commits happen only in
the clone at `~/repo/github.com/bukzor/dotfiles--main-reunify`; svelte commits
only in `~`.
No worktrees.

## Completion

Delete this file and `reunify-dotfiles.kb/` when every item above is
checked and 006's switchover is done.
