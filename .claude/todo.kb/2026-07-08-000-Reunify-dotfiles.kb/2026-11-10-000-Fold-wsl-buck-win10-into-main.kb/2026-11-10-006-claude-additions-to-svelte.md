---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ../2026-11-10-000-Fold-wsl-buck-win10-into-main.md  # the `.claude/` reconcile step's list of genuine additions
  - ./2026-11-10-003-claude-dir-uncommitted.md  # Final report: per-path svelte status
---

# Land wsl-buck-win10's genuine `.claude/` additions on svelte-crostini

**Parent:** <../2026-11-10-000-Fold-wsl-buck-win10-into-main.md> (wave 4, `.claude/` reconcile)

## Problem Statement

The parent's reconcile step names the `.claude/` content that is new on
`wsl-buck-win10` and missing from svelte. Author each one on
`svelte-crostini`, so that unit 007 can then make main's `.claude/` match
svelte's path for path. Port *only the new content*. Where svelte's copy of
a file has moved on since wsl's (e.g. `reference.kb/python/style.md`: svelte
is newer except for wsl's TypeGuard bullet), apply wsl's delta onto svelte's
version.

- `reference.kb/data-format-selection.md` +
  `must-read.kb/before/choosing-a-data-file-format.md`: check svelte has no
  renamed or absorbed equivalent first (`--no-renames`, and grep for the
  topic). If it does, report it instead of adding a duplicate.
- `reference.kb/python/style.md`: the TypeGuard bullet.
- `design-rules.kb/mirror-the-sources-distinctions.md`,
  `skills/subagent-handoffs` (symlink, svelte's form: absolute, no
  trailing `/`).
- `sessions.kb` gitlink: bump to wsl's (`88129c2` or later pushed
  `bukzor.claude-sessions` main).

Not here: `settings.json` (svelte already has the only intent, `de216c6`),
`skills/llm-chat-librarian` (svelte's form wins; unit 007 applies it on
main).

Report the svelte commit ids per item.

**Scope (only these files):** in the svelte workspace, the `.claude/` paths
above; this handoff file.

## Steps

- [x] Survey: each path on wsl vs. svelte (`--no-renames`), topic grep
- [x] svelte commit: data-format-selection + its must-read trigger
- [x] svelte commit: style.md TypeGuard bullet
- [x] svelte commit: mirror-the-sources-distinctions
- [x] svelte commit: skills/subagent-handoffs symlink
- [x] svelte commit: sessions.kb gitlink bump
- [x] push; final report; `status: done`; commit this file

## Decisions

- data-format-selection: no svelte equivalent, renamed or absorbed. Neither
  path is in svelte's history (`--no-renames`); a grep for format terms
  (Parquet, TSV, JSONL, data format) finds only passing mentions.
  `toon-format.md` covers TOON syntax, a different topic. Svelte's must-read
  files use the same `triggers: - read:` form, so both files went over verbatim.
- New files were ported verbatim, em dashes included (svelte's
  `double-dash-not-emdash.md`: leave existing ones alone). This keeps the blobs
  identical to wsl's, so unit 007 sees them as matches.
- style.md: applied `d31ef1a`'s hunk with `git apply`. Its context lines still
  match svelte, so it applied cleanly with no hand edits.
- sessions.kb: bumped to `8e94206` (`bukzor.claude-sessions` `origin/main`,
  pushed). It is two commits past wsl's `88129c2`, and `a3bae3f` is an ancestor
  of it. The submodule isn't checked out in the svelte workspace, so the gitlink
  was set with `update-index --cacheinfo`.

## Open Questions

None.

## Final report

Commits on `svelte-crostini`, all pushed (`41abff2..2abde04`):

| item | svelte | wsl counterpart |
|---|---|---|
| `reference.kb/data-format-selection.md` + `must-read.kb/before/choosing-a-data-file-format.md` | `7e0e75c` | `b50b1c5` |
| `reference.kb/python/style.md` TypeGuard bullet | `550061a` | `d31ef1a` |
| `design-rules.kb/mirror-the-sources-distinctions.md` | `96ab93d` | `f559249` |
| `skills/subagent-handoffs` (blob `d091d46`, same as wsl's) | `c189b63` | `691ab61` |
| `sessions.kb` gitlink `a3bae3f -> 8e94206` | `2abde04` | `0dda91e` (`88129c2`) |

Checks:
- The new files' blobs are identical on wsl and svelte.
- svelte's style.md now differs from wsl's only in svelte's newer sections
  (explicit-else, Docstrings). No TypeGuard lines remain in the diff.

No deviations from the brief.
