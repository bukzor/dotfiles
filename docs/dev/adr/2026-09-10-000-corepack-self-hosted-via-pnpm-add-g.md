# Corepack self-hosted via `pnpm add -g`

**Date:** 2026-09-10
**Status:** Accepted

## Context

`pnpm-upgrade-g` failed every night from 2026-09-07 on: `corepack use pnpm@latest`
had moved the `packageManager` pin to pnpm 12.3.4 on 09-06, and every `pnpm`
invocation since threw `MODULE_NOT_FOUND` for
`~/.cache/node/corepack/v1/pnpm/12.3.4/bin/pnpm.cjs`.

pnpm 12 replaced its JS bundle with a native (Rust) binary. The real entry
point is written by a `postinstall` script, but corepack never runs lifecycle
scripts — and separately, corepack itself didn't know how to invoke pnpm 12's
layout at all until its own 0.35.0 release. This machine's corepack came from
`~/bin/corepack`, which shells out to whatever `volta which node` resolves to
— pinned at node 22.21.1, bundling corepack **0.34.0**. This is upstream, not
local misconfiguration: [nodejs/corepack#775][775] (open) and
[nodejs/corepack#873][873] (closed, cross-filed [pnpm/pnpm#13018][13018])
are this exact failure; pnpm's side landed at 12.0.0-rc.6, verified against
corepack 0.35.0.

**Bundled-node was a dead end.** Checked every locally-available node build
without changing the machine's default (`volta fetch`, not `volta install` —
`install` always repins the default, learned the hard way mid-investigation
by pointing it at node@latest and taking corepack away entirely, see below):

| node       | bundled corepack |
|------------|-------------------|
| 22.21.1    | 0.34.0 |
| 22.23.2    | 0.34.6 (newest 22.x LTS patch) |
| 24.13.1    | 0.34.6 |
| 26.8.2     | none — node dropped bundling corepack |

No node release ships corepack ≥0.35.0. "Auto-upgrade node to get a current
corepack" (the first shape this fix took) cannot work: the newest LTS still
under-ships it, and the newest major removed it outright.

**Aside, costly:** `volta install node@latest`, run to inspect corepack
0.36.0's `engines` field, repinned the live default to 26.8.2 (no corepack)
without confirmation first — `volta install` always sets its target as the
new default, install semantics I hadn't checked before running it live.
Reverted via `volta install node@22.21.1` before any further work; no other
state was touched while the default was wrong. `volta fetch` (used for every
check after) downloads without touching the default.

**Second, independent bug found in the same pass:** even once corepack could
run pnpm 12.3.4, `pnpm-upgrade-g`'s `smoke_test` failed —
`pnpm ls -g --depth=0 --json` puts `[WARN] Using --global skips the package
manager check for this project` on *stdout* ahead of the JSON, regardless of
`--loglevel`. pnpm 11 didn't do this. `installed()` now filters `^\[WARN\]`
lines before handing the stream to `jq`.

## Decision

**Corepack is now a `pnpm add -g`-managed package**, added to
`~/.config/pnpm/global/package.json` alongside the other global tools. This
extends [2026-02-13-000]'s "`pnpm add -g` is the sole authority for global
npm tooling" to corepack itself, and decouples corepack's version from
node's slow, now-discontinued bundling.

No new job or script wiring was needed: `pnpm-upgrade-g`'s existing two-step
shape already sequences it correctly — step 1 (`pnpm add -g ... corepack@latest
...`) upgrades corepack *before* step 2 (`corepack use pnpm@latest`) uses it
to move pnpm itself. Nothing about "prior" had to be engineered; it fell out
of the declared-set model already in place.

`pnpm add -g`'s bin stubs land in `~/prefix/pnpm/bin`, which already precedes
`~/bin` on `PATH` — so the self-hosted `corepack` binary shadows
`~/bin/corepack` (the volta-shim-following wrapper) automatically, with no
edits to that wrapper or to `PATH`. `~/bin/corepack` is left in place
unmodified as a fallback bootstrap path: if the pnpm-hosted copy is ever
missing (fresh machine, wiped global store), it's still there to bootstrap
from, exactly as it did for this repair.

**Recovery sequence used** (for the next time a corepack/pnpm version bump
breaks this way): pin pnpm back to a known-good version with the *existing*
corepack (`corepack use pnpm@<good>`) to get a working `pnpm` back, use that
to self-host a current corepack (`pnpm add -g corepack@latest`), clear the
poisoned cache entry (`~/.cache/node/corepack/v1/pnpm/<version>/`, moved to
`~/trash/`, not deleted — `rm -rf` is denied by policy here), then retry
`corepack use pnpm@latest`.

**No self-healing was added to `pnpm-upgrade-g` for a poisoned cache entry.**
Considered and declined: investment goes into the failure-alerting side
instead (see `docs/dev/adr/2026-08-27-001-scheduled-job-health.md` and its
follow-on work), on the reasoning that a script silently working around its
own upstream's breakage hides the next incident rather than surfacing it.

## Alternatives Considered

### Chase a newer bundled node
- **Pros:** No new install path; corepack stays "whatever node ships."
- **Cons:** Doesn't work — no current node release bundles corepack ≥0.35,
  and the newest major (26.x) removed it. Also couples an unrelated tool's
  version to node upgrades, which are already a strand-the-shims hazard per
  the existing todo item on this.

### `npm install -g corepack`
- **Pros:** Simple, standard.
- **Cons:** A second global-install authority alongside `pnpm add -g`,
  reopening exactly the multi-entry-point problem [2026-02-13-000] closed.

## Consequences

**Positive:**
- `pnpm-upgrade-g` runs clean end-to-end again (verified 2026-09-10, both the
  package-set upgrade and the pnpm self-upgrade, under corepack 0.36.0 →
  pnpm 12.3.4).
- Corepack's version now tracks npm's registry directly, not node's release
  cadence — closes the gap that caused this incident.
- Fixes a real bug in `smoke_test`'s JSON parsing, independent of the
  corepack question, that would have kept failing even after corepack was
  fixed.

**Negative:**
- A future corepack release that itself can't run could strand its own
  upgrade path the same way pnpm 12 did — mitigated by `~/bin/corepack`
  remaining as an unmanaged fallback, and by the recovery sequence above now
  being written down.
- One more package.json entry to keep the mental model straight: corepack
  is simultaneously "the entry point for pnpm" and "just another
  `pnpm add -g` package," which reads as circular until you trace the
  two-step ordering above.

## Correction, 2026-09-17

The Decision section's claim that `~/prefix/pnpm/bin` "already precedes
`~/bin` on `PATH`... automatically, with no edits to that wrapper or to
`PATH`" is **wrong for the environment that actually matters**: a plain,
non-direnv shell (anacron's, cron's). A parallel investigation
(`pnpm-corepack-cjs-mjs-2026-09-12/`, incident-forensics kb, not
committed to this repo) hit the same failure class a third time
(pnpm 12.3.4 → 12.4.1) and found the real order is direnv-gated:
`~/.config/sh/env.d/900-path.sh` does put `~/bin` ahead of
`~/prefix/pnpm/bin` as stated, but `~/.envrc`'s `path_add` unconditionally
re-prepends `~/prefix/pnpm/bin` ahead of that on every direnv-hooked
interactive prompt — inverting the order and masking a stale
`~/bin/corepack` interactively, while cron's plain `/bin/sh` (no direnv)
sees `~/bin/corepack` first and hits the stale volta-bundled copy
directly. So "left in place... as a fallback bootstrap path" (Decision,
and the Negative consequence above) was true only by accident, not by
the PATH-order reasoning given — that investigation's remediation
(`git rm bin/corepack`, clearing the poisoned cache entry) removes the
fallback outright rather than relying on it, on the reasoning that an
unmanaged wrapper nobody upgrades is a liability, not a safety net, once
a real PATH ambiguity exists. That removal was staged but not yet
committed as of this note; this ADR's fallback framing should be read
as superseded once it lands, not repeated in future recovery attempts.

## Related

- Extends: `docs/dev/adr/2026-02-13-000-global-npm-tooling-management.md`
- Extends: `docs/dev/adr/2026-08-27-000-pnpm-11-global-tooling-mechanism.md`
- Motivated by: `~/.local/state/cron/pnpm-upgrade-g.log` (failures starting
  2026-09-07) and its investigation, recorded in `~/.claude/todo.md`
- Upstream: [nodejs/corepack#775][775], [nodejs/corepack#873][873],
  [pnpm/pnpm#13018][13018]
- Motivates: alerting fixes in
  `docs/dev/adr/2026-08-27-001-scheduled-job-health.md`'s lineage, since the
  status-file mechanism worked but only reaches shells at the moment they
  start, and this user's shells run for days (see that ADR's follow-on for
  the fix)

[2026-02-13-000]: 2026-02-13-000-global-npm-tooling-management.md
[775]: https://github.com/nodejs/corepack/issues/775
[873]: https://github.com/nodejs/corepack/issues/873
[13018]: https://github.com/pnpm/pnpm/issues/13018
