# Devlog: 2026-07-08 — cross-shell test harness: redo as the test runner

## Focus

Stand up the regression harness specified in
`.claude/todo.kb/2026-07-07-001-shell-function-unit-testing-and-ci-regression-harness.md`:
unit tests for `.config/sh/functions.d/*.sh` and `.profile`, run identically
under dash, busybox ash, bash, and zsh, with an automatic trigger. Writing the
tests immediately found and fixed two live production bugs (below) beyond the
two historical regressions the taskfile mandated drills for.

## Decisions

### redo is the test runner; no framework

Each (test, shell) pair is a redo target: `redo .config/sh/functions.d/path.dash.tested`
runs one cell, `redo test` fans out the whole matrix. `default.tested.do` at
the repo root is the single generic rule (redo's parent-directory default-rule
search makes it apply anywhere in the tree); `test.do` enumerates
`*_test.sh × installed shells`, skipping absent shells.

**Rationale:** incremental re-runs (a no-change `redo test` is ~0.2s; touching
one test re-runs only its four shell cells), `-j` parallelism, and per-target
failure isolation — all for free, with zero framework dependency.

**Alternatives considered:**
- **Single TAP runner script** — built as a competing prototype, worked fine
  (identical shared test bodies), deleted: it re-implements scheduling and
  reporting that redo already does, and re-runs everything every time.
- **bats-core** — not installed, bash-only at the harness layer, and its only
  contribution (per-test reporting) duplicates redo's per-target reporting.

### Tests co-locate with the code under test

`X_test.sh` sits beside `X.sh` (so `.profile`'s test is `.profile_test.sh`).
Both sourcing paths (`functions.sh`'s loop and `source_dir`) skip `*_test.sh`
— without that, every login shell would *execute* the test suite; the
`.profile` smoke test itself guards this exclusion, since a leaked test file
aborts the hermetic login it performs. Shared assertion helpers live in
`lib/sh/assert.sh` (POSIX; runs under all four shells).

### Hermetic-HOME smoke test for .profile

`.profile_test.sh` builds a throwaway `$HOME` of symlinks (`.profile`,
`.bashrc`, `.config`, `bin`) and sources the real `.profile` under `env -i`
with the shell under test. This keeps `.profile`'s `env > ~/profile.env` side
effect out of the live home and makes the test checkout-relative — the same
trick the reunification CI plan needs to test the main-branch tree before
switchover.

### `path append` is first-wins (bug fix)

The `# NOTE: ... first wins` comment dates to the original Oct 2025
`_path_append` and is the acceptance criterion; the implementation
(remove-then-append) *moved* an existing entry to the end, demoting its PATH
priority. Rewrote as a single awk pass: pass through unchanged when the entry
exists, append otherwise. `prepend` remains last-wins (that asymmetry is the
point: prepend is "make this win now", append is "make this available").

### hardquote's escape replacement was one backslash short

`s/'/'\\''/g` inside the double-quoted sed program reached sed as `'\''`,
whose `\'` collapses to `'` in replacement text — every embedded quote became
`'''` and eval choked on the unterminated result, in all four shells. Now
`'\\\\''`. Found by the first-ever run of `hardquote_test.sh`; the function had
no live callers to notice.

### `redo` parallel by default via shell function

`functions.d/redo.sh` defines `redo() { command redo -j"$(nproc)" "$@"; }`.
apenwarr redo has no config file or env var for a default `-j`, a `bin/shim/`
wrapper loses to homebrew's PATH position, and a `~/bin/` wrapper would
hardcode the real binary's path. A function costs one file, rides the
already-tested functions.d subsystem, and uses the existing `nproc` fallback.
Limitation: only shells that sourced `.profile` get it; bare scripts calling
`redo` stay serial.

### Target suffix `.tested`, not `.pass`

Names the attestation, not the verdict-of-the-moment. (Also: apenwarr redo
never materializes the file when the .do writes nothing, so the targets are
pure bookkeeping in `.redo/` — gitignored.)

## Conventions Established

- **`X_test.sh` beside `X.sh`** is the shape of a shell test; POSIX body,
  sources `lib/sh/assert.sh`, locates its subject via `dirname "$0"`, exits
  nonzero on any failed assertion. Runners export `TEST_SH` so a test can
  re-invoke its own interpreter (the .profile test needs this).
- **`redo test`** is the one-command regression gate, locally and in CI
  (`.github/workflows/check-sh.yml`: ubuntu + apt's dash/busybox/zsh/redo).
- **Regression drills**: all three historical failure modes were reintroduced
  and observed red with their exact historical signatures (`path_stdin: not
  found` + lost prepends; stdin-branch silent no-op; piped-loop mutation
  loss), then restored green. Red-first was also observed for the append fix.

## Open Questions

- [ ] CI first run unverified until this push lands — check Actions.
- Landing this on `main` is reunification work
  (`.claude/todo.kb/reunify-dotfiles/2026-07-07-000-CI-and-testing-foundations.md`);
  authored here on svelte-crostini, same-tree convergence applies.
- `bin/dotfiles-test` wrapper skipped: `redo test` is already one command
  (inline-trivial-wrappers).

## References

- `.claude/todo.kb/2026-07-07-001-shell-function-unit-testing-and-ci-regression-harness.md`
- `docs/dev/devlog/2026-07-07-000-shell-PATH-prepend--eliminate-eval-array-emulation-with-a-heredoc-fed-line-iterator.md`
- `~/.claude/reference.kb/redo-do-scripts.md` (house `.do` conventions)
