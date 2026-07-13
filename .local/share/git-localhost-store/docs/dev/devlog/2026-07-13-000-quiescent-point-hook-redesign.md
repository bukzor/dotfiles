# Devlog: 2026-07-13 -- Quiescent-point hook redesign

## Focus

Implement `.claude/todo.kb/2026-07-12-001-hook-redesign-quiescent-point-triggers.md`:
replace `reference-transaction` with `post-commit`/`post-checkout`, add
an env re-entrancy guard, collapse the three hooks to symlinks against
one shared body. Two open questions from the taskfile needed resolving
before/during implementation.

## Decisions

### Resolve open question 1: let `post-checkout` failure propagate to `git clone`'s exit code

**Rationale:** Today's `reference-transaction`-based refusal is
stderr-only -- `git clone` still exits 0 on genuine divergence (Scenario
B in `reclone-after-workdir-deletion.md`). That's exactly the "quietly
wrong" shape to avoid: a caller that only checks exit status sails past
a refusal that needs a human. `post-checkout` firing at true end-of-clone
naturally propagates hook failure to clone's own exit code -- accept the
change rather than trying to suppress it.
**Alternatives considered:** Keep clone always exiting 0 to match old
behavior -- rejected, it's strictly worse visibility for no benefit.

### Resolve open question 2: drop the hook-level `[ -L .git ]` fast path

**Rationale:** The relocator (`bin/git-localhost-store`) already has an
equivalent, more complete guard (`-L`, `-f`, `! -d`). Duplicating it in
the hook body was only ever justified by `reference-transaction`'s
every-ref-write invocation frequency; post-commit/post-checkout fire far
less often, so the extra `exec` into the relocator is cheap. Subtraction
of duplicate logic, one place to maintain the guard instead of two.
**Alternatives considered:** Keep the duplicate check in the shared hook
body -- rejected per "subtract, don't accrete."

### Unplanned: gate `post-index-change` out of the store-recovery branch entirely

**Rationale:** Found via the mandated full testing.kb pass, not
anticipated in the taskfile. `git commit` fires `post-index-change`
internally (same index-refresh machinery `git add` uses) -- confirmed via
`GIT_TRACE=1`. Unlike `git clone` (refs land before checkout/
`post-index-change` fire), `git commit`'s own ref-transaction is still
pending when `post-index-change` fires. Letting the store-recovery
branch run there swapped `.git` mid-transaction: `git commit` itself
failed (`fatal: cannot lock ref 'HEAD': reference already exists`), and
the user's commit was silently demoted to a dangling object -- invisible
to `git log --all`, gone as far as normal inspection is concerned, only
recoverable via `git fsck --dangling`. Verified the identical setup is
safe via direct invocation (no hook) and via `git clone`
(post-checkout) -- only `git commit`'s in-flight transaction races the
swap. Fix: `bin/git-localhost-store` takes the invoking hook's name as
`$1` (the shared hook body passes `$(basename "$0")`) and never enters
the `[ -e "$STORE" ]` branch when `$1 = post-index-change`, unconditionally
(not just for the divergent sub-case) -- always defers to
`post-commit`/`post-checkout`. Re-tested: `git commit` now succeeds
normally, the deferred hook prints a note, `post-commit` fires
afterward at a true quiescent point and either adopts the store cleanly
or refuses cleanly (no crash, no data loss either way) -- see
`docs/dev/testing.kb/store-recovery-via-commit.md`.
**Alternatives considered:** Try to detect "is there an in-flight
ref-transaction" some other way (e.g. checking for `.git/*.lock` files)
-- more fragile and unnecessary; a flat rule keyed on hook name is simpler
and covers the one case (`git commit`) that's actually unsafe, at the
cost of also deferring the one case (`git add` alone, or `git clone`)
that would have been safe -- narrow, acceptable tradeoff.

## Conventions Established

- **Test state isolation is mandatory, not optional.** Testing this
  session initially ran destructive `rm -rf`/legacy-hook-planting
  operations directly against the real `~/.local/state/git-localhost-store`
  -- the user flagged this mid-session as unacceptable for a system whose
  whole purpose is protecting durable state. Fix: every testing.kb doc's
  `STORE=` line now derives from `${XDG_STATE_HOME:-$HOME/.local/state}`,
  and `testing.kb/CLAUDE.md`/`TESTING.md`'s prerequisites now mandate
  `export XDG_STATE_HOME=~/trash/test-state-home` before running any
  test. `XDG_DATA_HOME` is deliberately left at its default (points at
  the real code being tested, not a copy).
- **`rm -r`, never `rm -rf`; test fixtures under `~/trash/`, never
  `~/tmp/`.** A follow-up correction to the isolation fix above: the
  first pass moved test state out of the real store but still used
  `rm -rf` and `~/tmp` throughout testing.kb, TESTING.md, and this
  session's own ad hoc verification commands. `-f` bypasses the
  write-protected-file prompt that is the user's main defense against a
  bad `rm` command, and this project's git root is the whole home
  directory, so `~/trash/` (already gitignored, already used by other
  scratch work) is the repo-root `trash/` the user's global conventions
  call for -- not `~/tmp/`. Fixed across every testing.kb doc, TESTING.md,
  and `bin/git-localhost-store`'s own `|| true` idioms (replaced with
  `|| : "reason"`, per this project's documented bash conventions).
- Hooks fire more often, and at different moments, than their names
  suggest -- verify with `GIT_TRACE=1`, don't assume from githooks(5)
  alone which porcelain commands trigger which hook.

## Open Questions

- Taskfile's optional follow-up (sweep existing stores' hooks, replacing
  real `reference-transaction`/`pre-commit` files with the new symlinked
  trio) remains genuinely optional -- the env guard makes stale hooks
  permanently safe, not just tolerable during a migration window.

## References

- `.claude/todo.kb/2026-07-12-001-hook-redesign-quiescent-point-triggers.md`
- `docs/adr/2026-07-13-000-quiescent-point-hook-redesign.md`
- `docs/dev/testing.kb/store-recovery-via-commit.md`
- `docs/dev/testing.kb/merge-fetch-recurses-through-store-hooks.md`
- `docs/dev/testing.kb/reclone-after-workdir-deletion.md`
