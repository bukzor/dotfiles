# Retire legacy gitfile migration tooling

**Date:** 2026-07-12
**Status:** Accepted

## Context

The 2026-04-30 switch from the gitfile-pointer layout to the symlink
layout (see `2026-04-30-000-switch-from-gitfile-to-symlink-layout.md`)
shipped with `bin/migrate-from-gitfile` (a bash wrapper around
`python -m bukzor.git_localhost_store.migrate`) to convert legacy repos,
and `bin/audit-gitfiles` to find them. By 2026-05-11 all 18 known legacy
repos were migrated and the audit was clean.

As of 2026-07-12, `audit-gitfiles` returns exactly one hit, and it's a
false positive: `~/claude/mccabe/.claude/worktrees/fix-hypothesmith-optional`,
a Claude Code linked worktree created 2026-06-23, well after migration
completed. The audit can't distinguish a legacy gitfile repo from a
git-native linked worktree of a *current-layout* store — both are
`.git` files containing `gitdir: <store>/...` — and Claude Code's
worktree isolation (`.claude/worktrees/`) mints new linked worktrees
routinely. This class of false positive only grows over time.

`migrate-from-gitfile` refuses these shapes rather than mangling them
(verified against the mccabe worktree: `CLAUDE_BASE` fails
`check_no_unexpected_worktree_files`; HEAD/index/logs fail
`check_no_promote_collisions`), so the risk isn't data loss — it's that
a tool whose entire remaining output is noise invites a future agent to
"fix" something healthy.

## Decision

Delete the migration tooling and its supporting artifacts:

- `bin/migrate-from-gitfile`, `bin/audit-gitfiles`
- `~/lib/pythonpath/bukzor/git_localhost_store/migrate.py` (kept
  `bukzor/xtrace.py` — shared, used by other tooling)
- `docs/dev/testing.kb/migrate-from-legacy-layout.md`,
  `docs/dev/testing.kb/migrate-in-place.md`
- Migration-specific sections of `CLAUDE.md`, `README.md`, `TESTING.md`,
  `docs/dev/testing.kb/CLAUDE.md`, and the two ideas.md entries that
  presupposed `migrate.py`/`audit-gitfiles` still existing

## Alternatives Considered

### A. Keep the tooling, accept the false positives

Leave `audit-gitfiles` in place and document that Claude Code worktree
hits are expected noise.

- **Pros:** No deletion, no risk of needing the tool later.
- **Cons:** A perpetually-noisy tool trains whoever runs it to ignore its
  output, which defeats its purpose the one time it might matter again.
  Every future agent encountering it has to re-derive "this is now dead
  weight" from scratch instead of finding that conclusion already
  recorded.

### B. Narrow the audit to exclude `.claude/worktrees/`

Teach `audit-gitfiles` to skip paths under any `.claude/worktrees/`
segment.

- **Pros:** Keeps the tool alive for a hypothetical future legacy repo.
- **Cons:** Solves a problem that no longer exists (0 real candidates
  since 2026-05-11) by adding more code to a tool with no remaining
  reason to run. The pattern this project's own "what NOT to do" section
  warns against: don't quietly accommodate — here, don't quietly keep
  maintaining something whose job is done.

### C. Delete the tooling (CHOSEN)

- **Pros:** Removes ~470 lines of code/tests with zero remaining
  legitimate use case. Eliminates a discoverability trap (a future agent
  finding a live `migrate-from-gitfile` would reasonably assume it's
  still needed).
- **Cons:** If a genuine legacy-layout repo surfaces later (e.g. a
  lagging host sharing these dotfiles that never ran the migration), the
  tooling has to be recovered from history rather than run directly.

## Consequences

**Positive:**
- `bin/` contains a single script (`git-localhost-store`) plus the
  `claude-path` symlink.
- No more perpetual false-positive audit output to triage.
- `CLAUDE.md`/`README.md` no longer document a python dependency that
  only existed for this one wrapper.

**Negative:**
- Recovery, should a genuine legacy repo surface, requires checking out
  the deleted tool from git history rather than running it directly:
  `git log --oneline -- bin/migrate-from-gitfile` (this repo) locates
  the last commit that had it; the same command against the home
  repo's history locates `~/lib/pythonpath/bukzor/git_localhost_store/migrate.py`.

**Neutral:**
- The underlying symlink-layout decision (2026-04-30 ADR) is unaffected;
  this ADR only retires the one-time conversion tooling, not the layout
  itself.

## Related

- Supersedes: none (this doesn't reverse the 2026-04-30 decision, it
  closes out its one-time migration tooling)
- Related to: `docs/adr/2026-04-30-000-switch-from-gitfile-to-symlink-layout.md`
- Follow-up work: `.claude/todo.kb/2026-07-12-001-hook-redesign-quiescent-point-triggers.md`
  (separate, not blocked by this)
