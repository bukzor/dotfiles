# Devlog: 2026-07-11 — recovery-merge redesign: two rules, fork-bomb fix, git-localhost-clone retired

## Focus

Follow-up to `2026-07-11-000`. That entry's fix (`git-localhost-clone`)
sidestepped the refusal by never letting plain `git clone` hit the
recovery path at all. This session went the other direction: made the
recovery path itself correct, which turned out to remove the need for
the wrapper entirely — plus surfaced and fixed a live fork bomb along
the way.

## What Happened

- Read `builtin/clone.c` in a local git checkout to find the exact
  mechanism behind the `BUG: refs/files-backend.c:3072` crash from the
  prior session: `write_remote_refs()` uses
  `REF_TRANSACTION_FLAG_INITIAL`, which hard-requires an empty ref store
  and is enforced with a `BUG()`, not a soft check. Also found that
  `ref_transaction_commit()` skips the `"committed"` hook entirely for
  `INITIAL` transactions (`refs.c:2473`) — the devlog-000 experiment's
  crash came from using `"prepared"` to route around that.
- That same reading established clone's ref-writing is bipartite:
  `write_remote_refs()` writes only `refs/remotes/origin/*`;
  `update_head()` writes exactly one local branch (whatever `HEAD` ends
  up pointing at), unconditionally, regardless of `--bare`/`--no-checkout`.
  No other local ref is ever touched by a real clone.
- Redesigned the recovery merge in `bin/git-localhost-store` around that
  split instead of one blanket `git fetch --atomic 'refs/*:refs/*'`.
- Empirically found the blanket fetch over-refused: re-cloning an
  *unchanged* repo (no divergence at all) still hit the refusal, because
  `git fetch`'s non-force ref-update check only tests one direction (is
  new a descendant of old) — it can't distinguish "store is ahead,
  harmless" from "genuinely diverged," both come back as an identical
  `non-fast-forward` rejection.
- Fixed by not asking `git fetch` to adjudicate the one ref that
  matters. `refs/heads/<default>` is now compared directly via
  `merge-base --is-ancestor` in both directions; only true divergence
  (neither side is an ancestor of the other) refuses.
- Added a guard: if the fresh `.git`'s `refs/heads/*` contains anything
  besides the recognized default branch, refuse outright rather than
  guessing how to merge a shape a real clone never produces.
- **Found a live fork bomb** while testing the merge fetch against a
  real store: writing into the store (via `git fetch`/`update-ref`) fires
  the store's *own* `reference-transaction` hook, which calls
  `git-localhost-store` again — and that nested call inherits `GIT_DIR`
  pointed at the store, so it recurses into itself with no base case.
  Produced thousands of growing `git-localhost-store` → `git fetch` →
  `git-upload-pack` → hook → `git-localhost-store` chains. Confirmed
  `core.hooksPath` does **not** suppress `reference-transaction` during
  `fetch` (tried both transient `-c` and persisted config) — only
  removing the `hooks/` dir does. Fixed by moving the store's `hooks/`
  aside for the merge's duration, restored via `trap ... EXIT`.
- Follow-on bug in that fix: if a prior run crashed mid-fetch, the next
  run would find `hooks/` already absent, never set `hooks_moved=1`, and
  the `EXIT` trap would then do nothing — leaving the store permanently
  hookless. Fixed with a self-heal check at the top: if the stash dir
  exists but `hooks/` doesn't, recover it before proceeding.
- With the recovery path now correct and self-healing, `git-localhost-clone`
  no longer has a reason to exist — its entire purpose was avoiding a
  refusal that plain `git clone` + the hooks now avoid on their own.
  Deleted `bin/git-localhost-clone`; updated `CLAUDE.md`, `README.md`,
  `TESTING.md` to match.
- Rewrote `docs/dev/testing.kb/reclone-after-workdir-deletion.md` with
  three scenarios (compatible re-clone, store-ahead/unpushed-work,
  genuine divergence) plus a "why not just `git fetch`" section
  documenting the conflation bug directly. Added
  `docs/dev/testing.kb/merge-fetch-recurses-through-store-hooks.md` as a
  dedicated, safety-noted test for the fork bomb. Updated
  `docs/dev/testing.kb/edge-cases.md`'s conflicting-state test to match
  the new refusal message.
- Follow-up audit (this pass): found and fixed the hooks-self-heal bug
  above (it existed in the committed fix but hadn't been tested against
  an interrupted-prior-run scenario); confirmed no dangling references to
  the deleted `git-localhost-clone` remain outside the (correctly
  append-only, unedited) `-000` devlog.

## Decisions

### Two-rule recovery merge instead of one blanket fetch

**Rationale:** the two ref categories a real clone produces have opposite
correctness requirements. `refs/remotes/*` is a cache of "what does the
remote say right now" — always safe to force-overwrite, ahead, behind, or
diverged. `refs/heads/<default>` is the only ref that can hold
unpushed local work — it needs a real ancestry check, not a blind
merge. Treating both uniformly under one fetch either loses the
distinction (force everything: risks silently discarding unpushed work)
or over-restricts it (fetch's default fast-forward check: refuses even
on harmless cases, as found empirically).
**Alternatives considered:** keep the wrapper (`git-localhost-clone`) as
the primary interface and treat the refusal as correct-by-design for
plain `git clone`. Rejected because the refusal was firing far more
often than actual divergence — it was catching "store is merely ahead"
and "no divergence at all," not just the genuine conflict case it exists
to protect.

### Retire `git-localhost-clone`

**Rationale:** its sole job was avoiding a refusal that the recovery
path now avoids on its own, for the same class of case (and more
precisely — real divergence still refuses, correctly). No remaining
justification for a second command with a narrower flag surface
(`--branch`/`--depth`/`--recurse-submodules`/`--bare` were all
unsupported in the wrapper).
**Alternatives considered:** keep both, document the wrapper as
"unnecessary but harmless." Rejected — a live command with no remaining
use case is a maintenance liability and a discoverability trap (an agent
finding it later would reasonably assume it's still needed).

## Conventions Established

- When merging refs into the store from outside, categorize by what a
  real `git clone` actually writes (bipartite: `refs/remotes/*` always
  forced, `refs/heads/<default>` ancestor-checked, everything else is an
  unrecognized shape — refuse) rather than treating `refs/*` uniformly.
- Any write into the store's own ref database (`git fetch`, `update-ref`,
  etc.) from within `git-localhost-store` itself must run with the
  store's `hooks/` moved aside first — otherwise the store's own
  `reference-transaction` hook recurses into `git-localhost-store` with
  no base case. `core.hooksPath` does not suppress this; only removing
  `hooks/` does.
- Hook-disabling code that stashes/restores via a marker directory must
  self-heal on the *next* invocation if a prior run crashed mid-way —
  don't rely solely on a same-run flag to decide whether to restore.

## Open Questions

- `CLAUDE.md`'s "Related Files" section is itself a content enumeration
  (`**bin/x** — description`, one line per file) — the exact pattern the
  project's own "Don't enumerate directory contents in docs" rule (and
  the llm-kb skill's `claudemd-enumeration` self-audit) warns against.
  Pre-existing, not introduced this session, and today's edit kept it in
  sync rather than letting it drift — but it's a standing drift risk
  every time a top-level file is added or removed. Not fixed this
  session; flagging for a deliberate call on whether to keep it,
  restructure it, or drop it.
- `docs/dev/testing.kb/recovery-after-deletion.md` has a name close
  enough to `reclone-after-workdir-deletion.md` to invite confusion.
  Untouched this session (didn't check whether it now overlaps/conflicts
  with the rewritten scenarios) — worth a look next time either file is
  touched.

## References

- `2026-07-11-000-git-localhost-clone-avoids-restale-refusal.md` — prior
  session this one follows up on.
- `docs/dev/testing.kb/reclone-after-workdir-deletion.md` — full
  before/after scenario writeups and the "why not just `git fetch`"
  rationale.
- `docs/dev/testing.kb/merge-fetch-recurses-through-store-hooks.md` —
  fork-bomb details and the safe way to re-test it.
- `docs/dev/testing.kb/edge-cases.md` — direct test of the
  unrecognized-local-branch refusal.
- Local git source checkout (`~/repo/git`): `builtin/clone.c`,
  `refs.c`, `refs/files-backend.c`, `refs.h` — grounded the whole
  redesign in what clone actually does, not assumption.
