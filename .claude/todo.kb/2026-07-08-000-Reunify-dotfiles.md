---
managed-by: Skill(llm-subtask)
status: open
related-effort: ~/.claude/sessions.kb/penguin.kb/reunify-dotfiles-lineages.md
---

# Reunify dotfiles lineages (supertask)

Fold wsl-buck-win10 into main, converge svelte-crostini ↔ main (disjoint
histories, no merge base) to identical content, merge with zero conflicts,
and live on main on every host.

Working agreements (topology, workspaces, sync rule):
[CLAUDE.md](2026-07-08-000-Reunify-dotfiles.kb/CLAUDE.md)

## Status (2026-11-10)

`git merge-tree` conflict counts: main + svelte 26, main + wsl-buck-win10 6.
The main ↔ svelte surface is task 004's four open themes plus the svelte-side
drift since 2026-07-13 that main never received (both listed in 004).

## Execution order

- [x] [2026-07-07-000-CI-and-testing-foundations.md](2026-07-08-000-Reunify-dotfiles.kb/2026-07-07-000-CI-and-testing-foundations.md) — done 2026-07-09; only remaining item (`fetch-depth: 0` for cross-ref checks) is deferred, lands with 006. Paired with the shell-function test harness task (done 2026-07-08; devlog `2026-07-08-000`)
- [x] [2026-07-06-000-Shell-config-unification-stutter-steps.md](2026-07-08-000-Reunify-dotfiles.kb/2026-07-06-000-Shell-config-unification-stutter-steps.md) — done 2026-07-12; deferred deletion of `.sh_env`/`.sh_rc`/`.sh_advanced_rc`/`.sh_plugins.d` landed via 005 (`.sh_lib` deliberately kept, follow-up tracked there)
- [x] [2026-07-06-001-Mechanical-file-fast-forwards.md](2026-07-08-000-Reunify-dotfiles.kb/2026-07-06-001-Mechanical-file-fast-forwards.md) — done 2026-07-11
- [x] [2026-07-06-002-Stale-seed-adjudication.md](2026-07-08-000-Reunify-dotfiles.kb/2026-07-06-002-Stale-seed-adjudication.md) — done 2026-07-11; only 2/9 files were actually stale-seed (took main's side); the other 7 turned out genuinely mixed and moved to 004 with findings attached
- [x] [2026-07-06-003-Main-only-path-triage.md](2026-07-08-000-Reunify-dotfiles.kb/2026-07-06-003-Main-only-path-triage.md) — done 2026-07-12; keep-by-default, 5 tooling/convention-breaking paths deleted, `bukzor.readline` ported into svelte's `lib/pythonpath/bukzor/`. Main-only paths are deliberately kept (304 as of 2026-11-10).
- [x] [2026-07-06-005-Port-zsh-config-into-config-sh-structure.md](2026-07-08-000-Reunify-dotfiles.kb/2026-07-06-005-Port-zsh-config-into-config-sh-structure.md) — done 2026-07-12; svelte `0881278`, main `8efa600`. `.sh_lib` kept — `bin/gcpenv` depends on it, follow-up filed in the task file
- [ ] on penguin: rename the main clone to `~/repo/github.com/bukzor/dotfiles--main` (the workspace name the agreements use)
- [ ] [2026-11-10-000-Fold-wsl-buck-win10-into-main.md](2026-07-08-000-Reunify-dotfiles.kb/2026-11-10-000-Fold-wsl-buck-win10-into-main.md) — before 004's claude-config theme, so that theme merges `.claude/` once
- [ ] [2026-07-06-004-Hand-merge-true-divergences.md](2026-07-08-000-Reunify-dotfiles.kb/2026-07-06-004-Hand-merge-true-divergences.md)
- [ ] [2026-07-06-006-Final-merge-and-home-switchover.md](2026-07-08-000-Reunify-dotfiles.kb/2026-07-06-006-Final-merge-and-home-switchover.md) — strictly last

## Operating loop

`claude --model fable` in the host's live `~`, `/session-start` (picks up
this file's goal block), work one group, `/session-end`. Edit other branches
in their `dotfiles--${branch}` workspaces (see the agreements).

## Completion

Delete this file and `2026-07-08-000-Reunify-dotfiles.kb/` when every item above is
checked and 006's switchover is done on every host.
