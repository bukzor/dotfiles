---
cwd: /home/bukzor/repo/github.com/bukzor/prototype.chatfs/packages/har-browse
session:
  uuid: 61c5b383-df54-49b8-85aa-49da0d287c35
  started: 2026-05-21T10:23:09-05:00
  ended: 2026-05-21T10:37:28-05:00
prior-sessions:
  - started: 2026-05-20T13:39:09-05:00
    ended: 2026-05-21T09:15:25-05:00
  - uuid: 17b785ab-b3b2-4ca7-981a-49f989382c36
    started: 2026-05-19T18:09:15-05:00
    ended: 2026-05-19T18:42:00-05:00
  - uuid: f49e1777-d4e9-4282-8350-f0b9fdbbc4a2
    started: 2026-05-19T17:10:50-05:00
    ended: 2026-05-19T17:30:00-05:00
  - uuid: da61b871-fdc4-4c37-9171-77db57fa10d7
    started: 2026-05-19T15:17:25-05:00
    ended: 2026-05-19T15:52:04-05:00
---

# Har-Browse Mutation Testing

Post-hoc TDD on `packages/har-browse/` via Skill(mutation-testing).
Kb at `packages/har-browse/docs/dev/mutation-testing.kb/`.

## This session (2026-05-19 evening, 18:09–18:42)

Cold-enum'd mutations from `src/` (har_browse.mjs, capture.mjs,
cache.mjs, user-agent.mjs, inject.mjs, cdp_to_har.mjs) BEFORE looking
at the kb — methodology-correct this time. 14 new mutations surfaced
(none overlapping with existing entries); all recorded as `todo`.
Then drove 14 mutations through inject→test→revert (13 done + 1
gap), plus recovered one prior `gap` (`loading-failed-no-rr-flush`)
via a new mid-body-abort fixture in `tests/_common/server.mjs`.

### Done this session

CLI / cdp_to_har (har_browse.mjs + cdp_to_har.mjs):
- `cli-epipe-break-changed-to-continue` → tests/epipe.test.mjs
- `cli-epipe-handler-removed` → tests/epipe.test.mjs
- `cli-epipe-condition-inverted` → tests/epipe.test.mjs
- `cli-session-close-removed` → tests/epipe.test.mjs (timeout arm)
- `cli-jsonl-pretty-printed` → tests/epipe.test.mjs (JSON.parse)
- `cdp-to-har-bodies-not-included` → **new** tests/cdp_to_har.test.mjs
- `cdp-to-har-empty-line-crashes-parser` → tests/cdp_to_har.test.mjs

User-agent / cache:
- `ua-cache-existsSync-inverted` → src/user-agent.test.mjs (existing)
- `ua-cache-read-no-trim` → src/user-agent.test.mjs (new assertion)

Capture / barriers / network:
- `runtime-addBinding-name-mismatch` → tests/barrier_smoke.spec.mjs
- `barrier-payload-includes-vs-startsWith` → tests/barrier_smoke.spec.mjs
  ("non-anchored 'BARRIER:' substring isn't deferred")
- `loading-failed-event-not-emitted` → **new** tests/loading_failed.spec.mjs
- `loading-failed-no-rr-flush` (was **gap**) → tests/loading_failed.spec.mjs
  ("RR flushed for mid-body abort") — needed a new `/abort-after-headers`
  route in tests/_common/server.mjs (flushHeaders + socket.destroy)
- `emit-override-no-dot-filter` → tests/barrier_smoke.spec.mjs
  (added a `/^\\w+\\.\\w+/` assertion across every captured method)
- `context-on-page-listener-removed` → **new** tests/popup_page.spec.mjs

### Marked gap this session

- `barrier-payload-no-optional-chaining` → `gap`. Tried calling
  `window.harBrowseMark()` page-side; Playwright/CDP rejects with
  `Invalid arguments: should be exactly one string` BEFORE the
  binding fires, so `params.payload` is guaranteed string by the time
  `onBindingCalled` runs. The `?.` chains defend against an
  unreachable case — dead defense.

### Side-improvement

- `tests/epipe.test.mjs`: tightened `timeout 15s` → `timeout 5s` (and
  inner `25000` → `8000`). Green-case duration is ~1.8s; 5s is ~2.7x.
  Per user range ("2-10x of expected value"). Improves bug-detection
  latency 3x.

### Methodology note (this session — better)

Cold-enum'd `src/` first, listed mutations verbally, THEN cross-
checked against the kb. Found 14 unique additions (filed as `todo`)
plus 8 overlaps. The reverse approach (read kb first) would have
biased toward the kb's framing.

## This session (2026-05-20 → 2026-05-21)

Closed out the kb's two open analytical loose ends — turning todos
and shallow-attempt gaps into well-analyzed gaps backed by proof or
empirical probing. No code changes; both injections tested then
reverted.

### Promoted: 1 todo → gap (with analysis)

- `awaiting-body-shared-across-sessions` → gap (attempts: 1). Full
  e2e suite (17 tests) passes with awaitingBody hoisted to
  attachCapture scope. Bug is unobservable because CDP requestIds
  are `<targetId>.<counter>` and targetId is process-globally
  unique even across separate `launchPersistentContext` runs (probed:
  same-process 20305/20338; cross-process 20996/21056). Cross-
  session collisions are impossible without faking CDP transport.

### Strengthened: 1 gap (attempt 1 → 2)

- `barrier-promise-not-tracked` → gap (attempts: 2). Prior session
  said "test passes by luck, future barrier_fifo.spec would catch
  it" — wrong. Re-derived from first principles: order preservation
  is structural under `inFlight`'s monotonic-removal semantics
  (SA ⊆ {pending @ B} ∪ {settled in (A,B)}; pending items ⊆ SB ⇒
  max(SB) ≥ max(SA); microtask FIFO breaks ties via subscription
  order). Confirmed empirically: 5 × 2 = 10 runs of
  `barrier_consumed.spec.mjs` pass with `track(...)` removed.
  Recommended `barrier_fifo.spec.mjs` is impossible to construct.

### Methodology

Used `md-frontmatter | jq` for cheap KB-wide status grouping —
faster than per-file `head | grep` loops.

## This session (2026-05-21 morning, 10:23–10:37)

Re-ran the cold-enum methodology against `src/cache.mjs` and
`src/user-agent.mjs` (the two leaf modules with colocated unit tests).
Surfaced 12 mutations not in the kb; all driven to `done` in one
burndown pass.

### Done this session

cache.mjs (6):
- `cache-key-nul-assertion-removed` → src/cache.test.mjs (existing
  "rejects NUL in hive key" test caught it on first injection)
- `cache-hive-kv-order-swapped` → src/cache.test.mjs (path-shape
  equality across tests 2–4)
- `cache-segments-joined-with-ampersand` → src/cache.test.mjs test 2
  (multi-key fixture is the discriminator)
- `cache-segment-order-swapped` → src/cache.test.mjs tests 1–4
- `cache-mkdir-removed` → src/cache.test.mjs (existsSync check) plus
  src/user-agent.test.mjs (seed `writeFileSync` ENOENT)
- `cache-escape-no-string-coercion` → caught by `tsc --noEmit`: TS2339
  on `unknown.includes` / `unknown.replaceAll`. Type-system catch
  (no runtime test needed).

user-agent.mjs (6):
- `ua-suffix-missing-plus` → existing full-string equality
- `ua-suffix-missing-pkg-name` → existing full-string equality
- `ua-suffix-missing-homepage` → existing full-string equality
- `ua-concat-no-space` → existing full-string equality
- `ua-concat-order-reversed` → existing full-string equality
- `ua-fetch-headless-negated` → **new** test "fetchUserAgent passes
  headless mode through to launch" (`onLaunch` captures `opts.headless`,
  asserts both modes). The existing `executablePath` fixture inspected
  only `opts.executablePath`; this was a real gap.

### Methodology note

Cold-enum'd 29 verbal mutations BEFORE reading tests/kb. 12 overlapped
with existing `done` entries; 17 went into recording as unique. After
writing them up I culled 5 that were obviously caught by full-string
equality assertions, leaving 12 todo entries — every one closed in
this session. One predicted gap (`ua-fetch-headless-negated`) verified
empirically.

User-driven speedup: skipped the post-revert green-check step (verified
on the next iteration's test run instead).

## Overall status

Kb now has 65 entries: **57 done, 0 todo, 8 gap.** Burndown terminus
reached — every entry has analysis. The 8 gaps cluster into a
"dead defense / structurally unobservable" family:

- `awaiting-body-not-deleted` — Map.set overwrites, no LF-side diff.
- `awaiting-body-shared-across-sessions` — CDP targetIds unique.
- `barrier-payload-no-optional-chaining` — CDP enforces string before binding.
- `barrier-promise-not-tracked` — inFlight monotonic-removal preserves order.
- `barrier-snapshot-not-frozen` — Promise.allSettled snapshots at call time.
- `body-attached-after-loading-finished` — chrome-har tolerates either order.
- `context-close-no-stream-end` — `.catch(()=>{})` makes close arm redundant.
- `inject-overlay-not-awaited` — CDP commands serialize in receive order.

All 8 are "code retains the construct for clarity / future-proofing,
runtime correctness doesn't depend on it."

## Follow-up

None pending on this kb. Burndown is at its natural terminus.

If the codebase grows new mutation surface (new src files, new
features in capture.mjs), enumerate fresh mutations against those —
the kb welcomes new entries. The existing 8 gaps should not be
re-attempted blind; each one's `## Test Result` section documents
why the mutation is unobservable, so future sessions can decide
within seconds whether to skip.

## See also

- `packages/har-browse/docs/dev/mutation-testing.kb/CLAUDE.md` — kb
  overview & workflow.
- Skill(mutation-testing) — `~/.claude/skills/mutation-testing/SKILL.md`.
