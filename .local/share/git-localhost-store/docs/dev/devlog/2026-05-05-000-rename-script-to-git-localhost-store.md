# Devlog: 2026-05-05 — rename `bin/git-restore-repo` to `bin/git-localhost-store`

## Focus

Rename the system's single user-facing script. The previous name,
`git-restore-repo`, named only one of the script's two branches (the
recovery path) and obscured what it does on first run (relocate `.git`
into the central store and replace it with a symlink).

## Decision

The script is renamed to `git-localhost-store`. Project name and store
paths are unchanged. Rationale:

- The script does relocate-or-recover, both ensuring the same invariant
  (the workdir's `.git` is a symlink to the central store). "Restore"
  named only the recovery branch.
- The system is `git-localhost-store`. Naming the user-facing entry
  point identically makes the relationship explicit; it also reads as
  a clear git subcommand (`git localhost-store`).
- This supersedes the deleted TODO `2025-11-21-000-rename-project.md`,
  which had proposed renaming the *project* to `git-restore-repo`. The
  user clarified that the script's name is the wrong indicator, not the
  project's.

## Scope of Changes

Active edits (paths and command references rewritten in place):

- `bin/git-restore-repo` → `bin/git-localhost-store` (`git mv`)
- 3 hooks in `template-repo/hooks/` (absolute path)
- `README.md`, `CLAUDE.md`, `TESTING.md`
- 4 files in `docs/dev/testing.kb/`

Append-only, untouched (historical record):

- `docs/adr/2025-11-21-000-extract-git-restore-repo-as-user-facing-command.md`
  (filename and body — accurate as of date)
- `docs/adr/2026-04-30-000-switch-from-gitfile-to-symlink-layout.md`
- `docs/dev/devlog/2025-11-21.md`
- `docs/dev/devlog/2026-04-30-000-symlink-layout-cutover.md`

TODOs:

- Deleted `2025-11-21-000-rename-project.md` (premise inverted).
- Created `2026-05-05-000-audit-and-sweep-stale-hooks.md` (the audit
  and sweep of already-migrated stores' per-store hooks, which still
  hardcode the old absolute path).
- Left `2025-11-21-001-guardrails-ambiguous-references.md` untouched —
  its mention of `bin/git-restore-repo` documents a specific past event
  and is accurate as of that event.

## Existing Stores' Hooks — Not Swept

Hooks in already-migrated stores under
`~/.local/state/git-localhost-store/repos/*/hooks/` still invoke the old
absolute path. They short-circuit when `.git` is a symlink, so they are
dormant in normal operation. Per user direction, the rename does not
include a proactive sweep:

> 1. they should be auto-fixed when their hook fires
> 2. we have a audit and sweep scheduled in the todo

Auto-fix interpretation: when a stale hook fires (recovery scenario)
and fails loudly, the user fixes it at that moment. The audit-and-sweep
TODO captures the proactive batch cleanup as a separate, optional pass.

## Verification

After edits, `grep -rln git-restore-repo --exclude-dir=.git` returns
only the historical (append-only) files plus the
`guardrails-ambiguous-references` TODO — no active code or doc still
references the old name.

## Open Questions / Loose Ends

- The leading comment in the renamed script
  (`# git-localhost-store: relocate .git to a central store, leave a symlink.`)
  describes only the relocate branch; the recovery branch was added back
  separately (`fa1af80`) and is not reflected in that one-liner. Could
  be tightened in a future polish pass — out of scope for this rename.
