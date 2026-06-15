---
cwd: /home/bukzor/repo/github.com/bukzor/prototype.chatfs/packages/har-browse
session:
  uuid: e31c1049-58fa-4b42-ba9d-a0b1dde7862c
  started: 2026-05-19T19:00:00-05:00
  ended: 2026-05-20T12:56:00-05:00
cost-benefit-sweh:
  timebox:
    "@value": 0.5
    rationale: |
      Main work landed (commit 041b31e). Residual: tighten
      tsconfig.json (stub playwright-core registry, eval
      noImplicitAny). ~0.5h. The .mjs → .ts rename is tracked in
      packages/har-browse/.claude/todo.md, not here.
    confidence: tentative
  benefit-2w:
    "@value": 0.2
    rationale: |
      Quality follow-ups on already-landed work. Modest.
    confidence: tentative
  cost-of-delay-2w:
    "@value": 0.0
    rationale: |
      No bleed — typecheck wiring works as-is. Tightening is
      polish, not blocking.
    confidence: tentative
---

# Har-Browse Typecheck Wiring

Wired `tsc --noEmit` as a single project-wide `node --test` test in
`packages/har-browse/`. Lands the "build-time typecheck" item from
todo.md. Took the project-wide `checkJs: true` path (over per-file
`// @ts-check`), so the planned `@ts-check` sweep is subsumed.

Committed: `041b31e har-browse: add tsc --noEmit test as project-wide typecheck`.

## What's in the commit

- `tsconfig.json` — permissive: allowJs+checkJs, nodenext, `strict: false`, skipLibCheck, `lib: ["es2023", "dom"]`
- `tests/typecheck.test.mjs` — spawns `tsc --noEmit -p <pkg>`; picked up by the existing `test:unit` glob, no script change
- `tests/globals.d.ts` — `Window.harBrowseMark` augmentation (CDP-bound page-side function)
- `tests/fixtures.mjs` — `Fixtures` cast so `startCapture` / `toyServer` show up on PlaywrightTestArgs
- `src/inject.mjs` — type page/opts; cast `e.target` → HTMLElement
- `src/har_browse.mjs` — stdout error typed as `NodeJS.ErrnoException`
- `tests/_common/server.mjs` — callback-form listen/close; narrow `server.address()` to `AddressInfo`
- `src/cache.test.mjs`, `src/user-agent.test.mjs` — static imports of `node:test` and `node:assert/strict` (resolves TS2775 typed-assert-callee); cast `fakeChromium` to `BrowserType`
- `package.json` — devDeps: `typescript@^6`, `@types/node@^25`

## Coordination with parallel agent

A separate agent was working in the same tree (mutation-testing work).
Two files overlapped: `src/user-agent.test.mjs` and
`tests/_common/server.mjs`. Handled with copy-away / commit /
move-back so that 041b31e contains only my changes vs HEAD; the other
agent's pending content was restored to the working tree (now with my
typing annotations layered onto their new additions, which is needed
for `tsc --noEmit` to stay green when they commit).

## Open follow-ups

- [ ] Tighten `tsconfig.json` later: declare stub for
  `playwright-core/lib/server/registry/index` (TS7016 hint),
  consider `noImplicitAny` once fixture callbacks are typed.
- [ ] Larger: rename `.mjs` → `.ts` for native TS syntax (still in
  todo.md, independent).
