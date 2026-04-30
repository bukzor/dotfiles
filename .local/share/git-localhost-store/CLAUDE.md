# Maintenance Guide for git-localhost-store

Instructions for AI agents maintaining and modifying this system.

## Overview

git-localhost-store protects local git repositories from accidental deletion by
storing all objects in a central, path-encoded location. When you `rm -rf` a
working directory, the commits survive in the store and can be recovered.

## Architecture

**Core concept:** the working directory's `.git` is a symlink to a regular
gitdir kept in a central, path-encoded location.

```
<workdir>/.git -> ~/.local/state/git-localhost-store/repos/<encoded-path>/

~/.local/state/git-localhost-store/repos/<encoded-path>/
├── HEAD
├── index
├── refs/
├── objects/
├── packed-refs
├── config            # core.bare = false
└── hooks/
```

`.git/HEAD`, `.git/refs/heads/...`, etc. resolve through the symlink as
ordinary files. Naive readers (lazy.nvim, custom shell helpers, IDE plugins)
that do `io.open("$repo/.git/HEAD")` work without modification. Git itself
follows the symlink the same way it would follow a real `.git/` directory.

## Legacy gitfile layout

A previous incarnation of this system used a different layout, where `.git`
was a regular file containing `gitdir: <store>/worktrees/<name>` (a "gitfile"
in git terminology), and the store was a bare repo with a per-worktree
subdir holding HEAD/index/refs. That layout is correct for git itself but
broke naive `.git/<x>` readers; see
`docs/adr/2026-04-30-000-switch-from-gitfile-to-symlink-layout.md` for the
analysis and decision to switch.

The migration tool `bin/migrate-from-gitfile` brings such repos into the
current symlink layout. `bin/audit-gitfiles` lists candidates.

## Path Encoding

Working directory paths are encoded by `~/bin/claude-path`:
```
/home/user/projects/repo → -home-user-projects-repo
```
`-` becomes `--`, `/` becomes `-`. Deterministic and collision-free.

## Hook Logic Flow

Hooks live in `template-repo/hooks/` and are copied into every newly-init'd
or cloned repo via `init.templateDir`. They each call
`bin/git-restore-repo`.

### post-index-change (triggered by `git add`)

Catches fresh `git init` repos that haven't yet hit `reference-transaction`.

### pre-commit (fallback)

Catches the case where the user commits without running `git add`.

### reference-transaction (triggered on ref changes)

Fires during `git clone` (after refs land) and during normal commits. Skips
the "fresh init, no refs yet" case so the conversion happens at the right
moment.

All three hooks short-circuit when `.git` is already a symlink (idempotent).

### bin/git-restore-repo

The actual relocation: `mv .git <store>` then `ln -s <store> .git`. Refuses
to operate if `.git` isn't a directory (asserts cleanly on unexpected
states).

## Making Changes

### Hook idempotency

All hooks must be safe to re-run. The current pattern: `if [ -L .git ]; then
exit 0; fi`. If you hit a weird state in production, do **not** silently
accommodate it — let the assertion in `git-restore-repo` fire so we learn
what's actually out there.

### Trace output

Use subshells for targeted tracing:
```bash
(set -x
    command1
    command2
)
```
PS4 is `export PS4=$'\e[36m$\e[0m '` (teal `$`). Trace only the actual
operations — not conditionals, assignments, echo statements.

The Python migration code uses the same convention via `bukzor.xtrace.run`,
which prints the command in PS4 style before fork/exec.

### Error handling

- Use `set -euo pipefail`.
- Print errors to stderr with `>&2`.
- Exit non-zero with a message that explains what's wrong.
- Never `|| true` to hide failures.

## Migration tooling

`bin/migrate-from-gitfile <workdir>` (a bash wrapper around
`python -m bukzor.git_localhost_store.migrate`) implements deterministic
conversion from the legacy gitfile layout to the symlink layout:

1. Discover layout from the workdir's gitfile.
2. Run preconditions:
   - `.git` is a regular file with `gitdir: ...` content
   - `<store>/worktrees/` contains exactly one entry (multi-worktree-per-store
     not supported)
   - No in-progress ops (`MERGE_HEAD`, `rebase-merge/`, etc.)
   - Per-worktree refs/ is empty
   - No unexpected files in worktree dir
   - Target store path doesn't already exist
3. Execute steps:
   - Install symlink-layout hooks into the store
   - Promote worktree HEAD/index up one level
   - Remove the worktrees subdir
   - Set `core.bare = false`, drop `submodule.active` if present
   - Move store from worktree-pointer style to single-tier
   - Atomic gitfile→symlink swap (`ln -s` + `mv -Tf`)

If preconditions fail, the script reports all of them and exits with code 1
without touching anything.

## Testing

- `bin/audit-gitfiles` lists outstanding repos in the legacy layout.
- For migration: synthesize a gitfile-layout repo in `~/trash/`, run
  `migrate-from-gitfile`, verify `.git/HEAD` reads, `git status` works,
  new commits land.
- For hooks: `git -c init.templateDir=$HOME/trash/empty-template clone ...`
  bypasses our template, useful for testing the manual conversion path.

See `TESTING.md` for the manual test suite.

## Common Maintenance Tasks

### Updating Hook Logic

1. Edit a hook in `template-repo/hooks/`.
2. Test against a fresh clone (the global `init.templateDir` makes new
   clones pick up the change immediately).
3. Existing repos retain the hooks copied at clone time — they pick up
   changes only on re-init or via explicit re-install. The migration
   tool re-installs hooks as part of its work.

### Debugging Issues

Check in order:
1. Is `init.templateDir` configured? `git config --global init.templateDir`
2. Are hooks executable? `ls -la template-repo/hooks/`
3. Is `claude-path` in PATH? `which claude-path`
4. Hook output: hooks write to stderr, visible during `git add` / `git
   commit`.
5. Inspect a store: `ls -la ~/.local/state/git-localhost-store/repos/<encoded>/`
6. Check the workdir's `.git`: `ls -la .git` (should be a symlink) and
   `cat .git/HEAD` (should produce `ref: ...` or a SHA).

Enable verbose tracing by setting `DEBUG=1` in the hook env, or by adding
`set -x` to specific spots.

## What NOT to Do

- ❌ **Don't symlink refs or HEAD individually** — symlink the whole
  `.git`, not its contents.
- ❌ **Don't quietly accommodate unknown `.git` shapes** — assert and
  let the user (or future agent) elaborate proper handling once we
  see a real case.
- ❌ **Don't enumerate directory contents in docs** — goes stale.
- ❌ **Don't hide errors** — `set -euo pipefail` and let things fail
  visibly.

## Documentation Conventions

- ADRs in `docs/adr/`, date-prefixed. Append-only — historical decisions
  are not edited.
- Devlogs in `docs/dev/devlog/`, date-prefixed. Append-only.
- TODOs in `.claude/todo.d/`.

When working on this project, load the `llm-collab-docs` skill for helper
scripts and pattern details.

## Related Files

- **README.md** — User-facing documentation
- **TESTING.md** — Manual testing procedures
- **bin/git-restore-repo** — the relocator
- **bin/migrate-from-gitfile** — converts legacy gitfile layout to symlink layout
- **bin/audit-gitfiles** — lists repos still in the legacy layout
- **template-repo/hooks/*** — git hooks
- **lib/init** — one-time setup script

## Questions?

- Examine a working store:
  `ls -la ~/.local/state/git-localhost-store/repos/<encoded>/`
- Test manually before committing.
- Keep it simple — less code is better code.
