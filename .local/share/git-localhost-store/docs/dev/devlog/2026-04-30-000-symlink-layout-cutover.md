# Devlog: 2026-04-30 — symlink-layout cutover

## Focus

Resolve a `:Lazy install` assertion failure caused by lazy.nvim reading
`.git/HEAD` directly on a v1-converted plugin, then design and ship a new
layout that's transparent to naive readers, then migrate one offender,
build migration tooling, and cut the system over in-place.

## What Happened

### Root cause

lazy.nvim's `Util.head(file)` does `io.open(file)` and lazy's
`Git.info` calls it as `Util.head(repo .. "/.git/HEAD")`. For any
v1-converted plugin (`.git` is a regular file with `gitdir: ...`),
`io.open` returns nil → `Git.info` returns nil → `assert(Git.info(...))`
in `Lock.update` fails. The error fires only during install_missing
(Lock.update is not called when nothing's missing), so it manifests
the moment the user installs a new plugin and silences itself between
runs.

`baleia.nvim` was the v1-converted plugin under
`~/.vim/pack/lazy/opt/`. The user's home directory has
`reference-transaction` / `pre-commit` / `post-index-change` hooks
configured via `init.templateDir` in `~/.gitconfig`, and those hooks
auto-relocate any new clone to v1 layout.

### Designed and validated v2 (symlink) layout

- Tested `.git` as a symlink-to-gitdir at git 2.49.0 on Linux —
  works fully (`git status`, `git log`, `git commit`).
- Tested via the worktree-style target dir (`commondir`/`gitdir`/`HEAD`/
  `index`/`refs`) — also works.
- Built a parallel "v2" install at `~/.local/share/git-localhost-store2/`
  with hooks + `git-restore-repo`. Verified `git clone` end-to-end
  produces a symlinked `.git` and a correct working tree.

### Built migration tooling

- `bukzor.xtrace` (in `~/lib/pythonpath/bukzor/xtrace.py`) — shared
  fork/exec helper with PS4-style trace output (`PS4 = teal $`). Mirrors
  the convention from v1's `bin/git-restore-repo`.
- `bukzor.git_localhost_store.migrate` — discovers v1 layout, runs
  preconditions, executes deterministic v1→v2 migration in seven steps:
  install hooks, promote worktree HEAD/index, remove worktrees subdir,
  rewrite config (bare=false), relocate store, atomic gitfile→symlink
  swap.
- `bin/migrate-from-v1` — bash wrapper following the `bin/to-toon`
  pattern (`PYTHONPATH=$HOME/lib/pythonpath python3 -m ...`).
- `bin/audit-v1` — finds workdirs whose `.git` is a v1 gitfile pointing
  into the v1 store.

### Validated migration

Ran on synthetic v1 repos and on the real `baleia.nvim`. After
migration, lazy.nvim's `Git.info` returns ok across all 18 installed
plugins (was: 17 ok / 1 fail). Original assertion path is dead.

### Cutover (in place)

User directed an in-place upgrade rather than coexistence. Steps:

1. Moved 5 v2-relocated stores from
   `~/.local/state/git-localhost-store2/repos/` →
   `~/.local/state/git-localhost-store/repos/`.
2. Repointed 5 `.git` symlinks (find by readlink target).
3. Copied v2 install files over v1 install at unchanged paths
   (`bin/git-restore-repo`, hooks, plus new `bin/migrate-from-v1` and
   `bin/audit-v1`); rewrote `git-localhost-store2` → `git-localhost-store`
   in the contents.
4. Updated Python module `REPOS_ROOT` / `HOOKS_TEMPLATE_DIR` constants
   to drop the `2`.
5. Removed the now-empty `~/.local/share/git-localhost-store2/` and
   `~/.local/state/git-localhost-store2/` trees.

`~/.gitconfig` `init.templateDir` was unchanged — the path it points at
still exists, now hosting the new logic.

### Smoke-tested post-cutover

- `nvim -l` script iterating `Git.info` over all 18 lazy plugins:
  ok=18 fail=0.
- `cat .git/HEAD` on all 5 previously-v2-migrated repos: works.
- Fresh `git clone` (using global template) → symlink-style `.git`
  produced directly.
- `migrate-from-v1` on a freshly-synthesized v1 repo: works.

### Cleanup of "v2" cruft (and "v1" framing)

Initial pass renamed v2-specific identifiers:
- `V2_REPOS_ROOT` → `REPOS_ROOT`
- `V2_TEMPLATE_HOOKS` → `HOOKS_TEMPLATE_DIR`
- `install_v2_hooks` → `install_hooks`
- `check_v2_store_does_not_exist` → `check_target_store_does_not_exist`
- failure code `v2-store-already-exists` → `target-store-already-exists`

User then clarified that "v1 as a distinct version concept" is also
cruft — there's only "the implementation" and "the legacy gitfile
format we sometimes encounter". Second pass renamed v1-flavored
identifiers to descriptive ones:

- `bin/migrate-from-v1` → `bin/migrate-from-gitfile`
- `bin/audit-v1` → `bin/audit-gitfiles`
- `V1Layout` (Python class) → `GitfileLayout`
- `discover_v1_layout` → `discover_gitfile_layout`
- `check_layout_is_v1` → `check_layout_shape`
- precondition codes `not-v1-*` → `expected-gitfile-found-*` /
  `unexpected-gitdir-shape` / `store-or-worktree-missing`

Per user direction, this devlog keeps v1/v2 framing as the historical
record of how the work unfolded; user-facing commands, code symbols,
and reference docs use only descriptive terms.

## Decisions Made

### Symlink layout, not gitfile layout

See ADR `2026-04-30-000-switch-from-gitfile-to-symlink-layout.md`.

### Hard fail on unknown `.git` shape, not silent accommodation

Earlier draft: have hooks and `git-restore-repo` short-circuit on a v1
gitfile (recognize legacy format and exit 0). User pushed back: prefer
an assertion that fires when reality exceeds the design, then elaborate
proper handling once we have a real case. Reverted to symlink-only
short-circuit. Existing assertion (`if [ ! -d .git ]; then exit 1`) is
the gate.

### Shared `xtrace` module instead of inlining `run()`

User requested. Located it in the pre-existing `~/lib/pythonpath/`
namespace package layout (`bukzor.xtrace`). The wrapper-script-sets-
PYTHONPATH-and-runs-`python -m` pattern (per `~/bin/to-toon`) is the
established convention; followed it.

### In-place cutover, no v2 system left behind

User directed it. Committed.

## Open Questions / Loose Ends

- **Audit oddity**: `~/claude/amazon-searches/.git` points at
  `…claude-empty/worktrees/empty` (gitfile target contains
  `empty/worktrees/empty` — name mismatch with the workdir basename).
  Looks like a misconfigured shared store from when it was set up.
  Investigate before batch-migrating.
- **Batch migration of remaining ~19 legacy repos**: not done.
  Includes `~/` itself. User to drive when ready:
  `audit-gitfiles | xargs -rn1 migrate-from-gitfile`.
- **Old ADRs and 2025-* devlogs**: historical, left untouched (they
  describe the gitfile layout's design at the time it was current —
  accurate as of their date).
- **TESTING.md** rewritten to match the symlink layout end-to-end;
  added Test 8 covering `migrate-from-gitfile`.

## Files Touched

- `bin/git-restore-repo` — replaced (symlink relocator)
- `bin/migrate-from-gitfile` — new (bash wrapper)
- `bin/audit-gitfiles` — new
- `template-repo/hooks/{pre-commit,post-index-change,reference-transaction}` — replaced
- `CLAUDE.md` — rewritten for symlink layout
- `README.md` — rewritten for symlink layout
- `TESTING.md` — rewritten end-to-end for symlink layout
- `docs/adr/2026-04-30-000-switch-from-gitfile-to-symlink-layout.md` — new
- `docs/dev/devlog/2026-04-30-000-symlink-layout-cutover.md` — this file
- `~/lib/pythonpath/bukzor/xtrace.py` — new
- `~/lib/pythonpath/bukzor/git_localhost_store/migrate.py` — new

## Next Session

**Start here:** Investigate the `~/claude/amazon-searches` audit oddity.
Once explained, decide on batch migration of the remaining v1 repos.

**Blockers:** None.
