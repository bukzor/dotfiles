---
managed-by: Skill(llm-subtask)
status: open
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

## Decisions

## Open Questions

## Final report
