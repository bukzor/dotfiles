# Devlog: 2026-07-08 — run-once check class: git ls-files over find

## Focus

Close the "run-once check class" item in
`.claude/todo.kb/reunify-dotfiles.kb/2026-07-07-000-CI-and-testing-foundations.md`
(reunify-dotfiles supertask, CI-foundations task): a `default.checked.do`
sibling to `default.tested.do`, wired into `redo test`, so a future task
group can drop an `X_check.sh` beside its code for zero harness work — same
promise already made for `X_test.sh`.

## Decisions

### Enumerate `*_check.sh` via `git ls-files`, not `find`

**Rationale:** `test.do` runs with CWD at the repo root, which is also `$HOME`
(svelte-crostini's topology: the home directory *is* the checkout). A first
draft used `find . -path ./.git -prune -o -path ./.local -prune -o -name
'*_check.sh' -print`. Toy-tested against the live tree before committing:
5s wall time, permission-denied errors under `.solargraph/*/overlay/*/work`,
and false-positive matches from vendored trash (`trash/cargo/.../jemalloc/.../safety_check.sh`)
and an unrelated nested vault
(`claude/.../egui/scripts/wasm_bindgen_check.sh`) — `.cache` and other large
non-repo trees weren't even pruned yet. `git ls-files --cached --others
--exclude-standard -- '*_check.sh'` instead: 11ms, repo-scoped,
gitignore-aware by construction, and (unlike a plain `--cached`) still picks
up a brand-new untracked-but-not-ignored `X_check.sh` before it's staged —
required for the "drop the file, zero harness work" flow to work pre-commit.

**Alternatives considered:** `find` with a longer prune list (rejected —
fragile, has to enumerate every large tree in `$HOME` by hand and stays
wrong for any tree added later); `find` scoped to known subdirectories only
(rejected — check scripts are heterogeneous per-group, no single subtree
covers them, unlike `X_test.sh` which is scoped to shell-startup code).

## Conventions Established

- `test.do` now fans out two independent target classes from one command:
  `*_test.sh` → `<name>.<shell>.tested` (shell matrix, existing), and
  `*_check.sh` → `<name>.checked` (run-once, no shell fan-out, new). A task
  group adds either file beside its code; no changes to the harness needed.
- When a `.do` script needs to enumerate repo files by pattern, prefer `git
  ls-files --cached --others --exclude-standard` over `find` whenever CWD
  might not be a "clean" project root — verify with a toy example against
  the real tree before trusting either approach.

## Verification

Toy-tested both the pass and fail paths by hand (not committed): a
`toy_check.sh` sourcing `lib/sh/assert.sh` produced `toy.checked` (a
timestamp certificate, gitignored) on success via `redo test`, and a
deliberately-failing assertion made `redo test` exit nonzero with the
assertion's `not ok` output — confirming `default.checked.do`'s contract
(stdout-as-target, `set -eu`) and `test.do`'s wiring both work before
committing either file.

## Open Questions

- Remaining CI-foundations work is still open: skip-if-absent helper in
  `lib/sh/assert.sh`, pty allowance for interactive (`-i`) startup tests, CI
  `fetch-depth: 0` for cross-ref checks, and landing the harness identically
  on `main` (separate clone at `~/repo/github.com/bukzor/dotfiles`).
- A second, concurrent Claude Code session (working
  `todo.kb/2026-05-15-000-rename-outmoded-d-dirs-to-kb-case-by-case-eval.md`)
  renamed `.claude/todo.kb/reunify-dotfiles/` →
  `.claude/todo.kb/reunify-dotfiles.kb/` mid-session, while this session had
  an in-flight edit open on a file inside it. The first edit survived
  (content carried through the rename); a second edit transiently failed
  ("no such file") until re-applied at the new path. No data was lost, but
  it's a live collision hazard: the working agreements' "single-writer per
  branch" rule covers svelte-crostini vs. main, not two sessions both
  writing inside `~` at once.

## References

- `.claude/todo.kb/reunify-dotfiles.kb/2026-07-07-000-CI-and-testing-foundations.md`
- `.claude/todo.kb/reunify-dotfiles.kb/CLAUDE.md` (working agreements)
- `docs/dev/devlog/2026-07-08-000-cross-shell-test-harness--redo-as-the-test-runner.md`
- `~/.claude/reference.kb/redo-do-scripts.md` (house `.do` conventions)
