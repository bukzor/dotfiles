# Quiescent-point hook redesign

**Date:** 2026-07-13
**Status:** Accepted

## Context

The `reference-transaction` hook fired mid-operation and was the root of
nearly all the system's incidental complexity: the fresh-init refs-empty
skip (2025-12-18 init race), the `committed` state gate, and the fork
bomb when the recovery merge wrote into the store (2026-07-11) -- which
forced a hooks-aside/trap/self-heal dance (~35 lines) plus a
fork-bomb-hazard test. Separately, the three hooks
(`post-index-change`/`pre-commit`/`reference-transaction`) were
near-identical copies installed per-repo at init time, so hook fixes
never propagated to existing repos. Full design rationale:
`.claude/todo.kb/2026-07-12-001-hook-redesign-quiescent-point-triggers.md`.

## Decision

Three parts, landed together:

1. **Quiescent-point triggers.** Kept `post-index-change` (`git add` on
   fresh repos); replaced `pre-commit` + `reference-transaction` with
   `post-commit` + `post-checkout`. `post-checkout` fires at the end of
   `git clone` (after all refs land) and on plain `git checkout`/`git
   switch`; `post-commit` fires after any commit, including
   `--allow-empty` and `--no-verify`.
2. **Env re-entrancy guard.** `bin/git-localhost-store` exports
   `GIT_LOCALHOST_STORE_ACTIVE=1` and exits immediately if already set.
   Hooks inherit the environment of the git process that runs them, so a
   nested invocation (fired by a stale, pre-redesign store's real
   `reference-transaction` hook, during the recovery merge's own
   fetch/update-ref calls into that store) sees the flag and no-ops.
   Replaces the hooks-aside/trap/self-heal machinery entirely.
3. **One hook body, symlinked.** `template-repo/hooks/{post-index-change,
   post-commit,post-checkout}` are now symlinks to one file,
   `template-repo/hooks/shared`, which execs `bin/git-localhost-store`
   with its own invoked name as `$1`. Future hook-body edits propagate to
   every post-redesign repo automatically. The per-hook `[ -L .git ] ||
   [ -f .git ]` fast-path check was dropped from the hook body -- the
   relocator already has an equivalent (more complete) check, and
   invocation frequency dropped enough (once per commit/checkout, not
   every ref write) that the duplicate check wasn't earning its keep.

**Discovered during implementation, not in the original plan:** `git
commit` internally fires `post-index-change` too (its index-refresh step
uses the same machinery `git add` does), and -- unlike `git clone`, whose
refs are already written before checkout/`post-index-change` fire -- it
fires *before* `git commit`'s own ref-transaction lands. Letting
`post-index-change` run the store-recovery branch there swapped `.git`
out from under the still-in-flight commit: `git commit` itself failed
with `fatal: cannot lock ref 'HEAD': reference already exists`, and the
user's just-made commit was silently demoted to a dangling, unreferenced
object (invisible to `git log --all`, recoverable only via `git fsck
--dangling`). Fix: `bin/git-localhost-store` never runs the
store-exists branch when invoked as `post-index-change`, regardless of
whether adoption would have been clean or divergent -- it always defers
to `post-commit`/`post-checkout`. See
`docs/dev/testing.kb/store-recovery-via-commit.md`.

**Also decided during implementation** (open questions from the
taskfile): a failing `post-checkout` now propagates to `git clone`'s own
exit code -- a deliberate change from `reference-transaction`'s old
behavior (stderr-only, `git clone` still exited 0). A refusal that's
silently swallowed except in stderr is exactly the "quietly wrong" shape
to avoid; a non-zero exit makes it impossible for an automated caller to
miss.

## Alternatives Considered

### A. Keep `reference-transaction`, patch around the fork-bomb and init-race cases

- **Pros:** No trigger-point change, smaller diff.
- **Cons:** Doesn't remove the root cause (firing mid-operation);
  every future ref-writing edge case is a new special-case gate on top
  of `committed`/refs-empty. The 2026-07-11 fork bomb and 2025-12-18 init
  race are both symptoms of the same structural problem, not independent
  bugs to patch separately.

### B. Quiescent-point triggers, but let `post-index-change` also run recovery-merge

- **Pros:** Simpler mental model before the commit-triggered-recovery
  bug was found -- no special-casing needed.
- **Cons:** Empirically unsafe for `git commit` (see Decision above) --
  crashes the enclosing commit and silently discards it as a dangling
  object. Discovered via the mandated full testing.kb pass, not by
  inspection; this alternative was live until that testing surfaced it.

### C. Quiescent-point triggers, one shared hook body, `post-index-change` always defers store-recovery (CHOSEN)

- **Pros:** No known unsafe firing order; one uniform rule regardless of
  which porcelain command triggered the hook, rather than a rule
  conditional on clone-vs-commit safety analysis.
- **Cons:** A bare `git add` (no subsequent commit/checkout) leaves an
  existing-store recovery pending rather than acting immediately -- a
  narrow, intentional gap, closed by the next commit/checkout.

## Consequences

**Positive:**
- Executable surface drops from ~815 lines / 9 scripts (with the
  migration-tooling retirement) to far less; two failure modes (init
  race, fork bomb) and one hazardous test procedure removed as
  structurally impossible rather than patched.
- Hook fixes now propagate automatically to every repo that already has
  the symlinked trio (no more copy-drift between repos cloned at
  different times).
- `git clone` failures on genuine divergence are now visible via exit
  code, not just stderr.

**Negative:**
- Existing stores created before this redesign keep whatever hooks were
  copied at their clone time (a real, possibly stale
  `reference-transaction` file) until they're re-init'd -- the env guard
  exists specifically to make that safe indefinitely, not just during a
  migration window.
- A bare `git add` no longer immediately adopts a pre-existing store
  found in the recovery branch; it waits for the next commit/checkout.

**Neutral:**
- The two-rule recovery merge itself (force-sync `refs/remotes/*`,
  ancestry-check `refs/heads/<default>`, refuse unknown shapes),
  settled 2026-07-11, is unchanged by this ADR.

## Related

- Supersedes: none (extends the 2026-07-11 recovery-merge redesign's
  trigger mechanism; doesn't reverse it)
- Related to: `docs/adr/2026-04-30-000-switch-from-gitfile-to-symlink-layout.md`,
  `.claude/todo.kb/2026-07-12-001-hook-redesign-quiescent-point-triggers.md`,
  `docs/dev/testing.kb/store-recovery-via-commit.md`,
  `docs/dev/testing.kb/merge-fetch-recurses-through-store-hooks.md`,
  `docs/dev/testing.kb/reclone-after-workdir-deletion.md`
