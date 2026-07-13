--- # workaround: anthropics/claude-code#13003
requires:
    - Skill(llm-kb)
depends:
    - Skill(llm-collab)
git-caution: personal
---

# Maintenance Guide for git-localhost-store

Instructions for AI agents maintaining and modifying this system.

## Knowledge Bases

- `docs/dev/testing.kb/` — manual test cases, one scenario per file.
  Maintenance conventions in `docs/dev/testing.kb/CLAUDE.md`.

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
analysis and decision to switch, and
`docs/adr/2026-07-12-000-retire-legacy-gitfile-migration-tooling.md` for
why the tooling that migrated repos into the new layout was later retired
(migration completed 18/18) and how to recover it if a legacy repo ever
resurfaces.

## Path Encoding

Working directory paths are encoded by `~/bin/claude-path`:
```
/home/user/projects/repo → -home-user-projects-repo
```
`-` becomes `--`, `/` becomes `-`. Deterministic and collision-free.

## Hook Logic Flow

`template-repo/hooks/{post-index-change,post-commit,post-checkout}` are
symlinks to one file, `template-repo/hooks/shared`, copied (as symlinks)
into every newly-init'd or cloned repo via `init.templateDir`. `shared`
just execs `bin/git-localhost-store`, passing its own invoked name
(`$(basename "$0")`) as `$1` -- all guarding/state logic lives in the
relocator, not the hook body.

Trigger points, all quiescent (fire after the triggering operation's own
ref-transaction has landed, never mid-operation):

- **post-index-change** -- `git add` on a fresh repo (also fires during
  `git commit`, see below).
- **post-commit** -- any commit, including `--allow-empty` and
  `--no-verify` (post-commit isn't skipped by `--no-verify`).
- **post-checkout** -- end of `git clone` (after checkout), or a plain
  `git checkout`/`git switch`.

`bin/git-localhost-store` itself short-circuits when `.git` is already a
symlink or a gitfile -- the hooks no longer duplicate that check (removed
as redundant once invocation frequency dropped from every ref write to
once per commit/checkout).

**The `post-index-change` exception:** `git commit` fires
`post-index-change` too (its internal index-refresh touches the same
mechanism `git add` uses), and -- unlike `git clone`, whose refs are
already written before checkout/`post-index-change` fire -- it fires
*before* `git commit`'s own ref-transaction lands. Adopting an
existing store at that point would swap `.git` out from under the
still-in-flight commit. So `bin/git-localhost-store` never runs the
"store already exists" branch when invoked as `post-index-change`,
regardless of whether adoption would have been clean or divergent -- it
always defers to `post-commit`/`post-checkout`. See
`docs/dev/testing.kb/store-recovery-via-commit.md`.

### bin/git-localhost-store

The actual relocation: `mv .git <store>` then `ln -s <store> .git` (or,
recovering an existing store, `rm -r .git` then `ln -s`). Refuses to
operate if `.git` isn't a directory, symlink, or gitfile (asserts
cleanly on unexpected states). Exports `GIT_LOCALHOST_STORE_ACTIVE=1` and
exits immediately if already set -- hooks inherit this from the invoking
git process, so the recovery merge's own fetch/update-ref calls into the
store can't recurse through a stale, pre-2026-07-13 store's real
`reference-transaction` hook (new stores never get one).

## Making Changes

### Hook idempotency

All hooks must be safe to re-run. The current pattern: `if [ -L .git ]; then
exit 0; fi`. If you hit a weird state in production, do **not** silently
accommodate it — let the assertion in `git-localhost-store` fire so we learn
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

### Error handling

- Use `set -euo pipefail`.
- Print errors to stderr with `>&2`.
- Exit non-zero with a message that explains what's wrong.
- Never `|| true` to hide failures.

## Testing

- For hooks: `git -c init.templateDir=$HOME/trash/empty-template clone ...`
  bypasses our template, useful for testing the manual conversion path.

See `TESTING.md` for the manual test suite.

## Common Maintenance Tasks

### Updating Hook Logic

1. Edit a hook in `template-repo/hooks/`.
2. Test against a fresh clone (the global `init.templateDir` makes new
   clones pick up the change immediately).
3. Existing repos retain the hooks copied at clone time — they pick up
   changes only on re-init.

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
- ❌ **Don't resolve a "store already exists" refusal solo** — that
  refusal *is* the human-decision point, not an obstacle to route
  around. As of the 2026-07-11 recovery-merge redesign, plain `git
  clone` only reaches this refusal on genuine local-branch divergence
  (unpushed store commits that aren't a fast-forward of the fresh
  clone) — the common re-clone case now self-heals via
  `bin/git-localhost-store`'s hooks, no separate command needed.
- ❌ **Don't enumerate directory contents in docs** — goes stale.
- ❌ **Don't hide errors** — `set -euo pipefail` and let things fail
  visibly.

## Documentation Conventions

- ADRs in `docs/adr/`, date-prefixed. Append-only — historical decisions
  are not edited.
- Devlogs in `docs/dev/devlog/`, date-prefixed. Append-only.
- TODOs in `.claude/todo.kb/`. Ideas (speculative; may never happen) in `.claude/ideas.md`.

When working on this project, load the `llm-collab-docs` skill for helper
scripts and pattern details.

## Related Files

- **README.md** — User-facing documentation
- **TESTING.md** — Manual testing procedures
- **bin/git-localhost-store** — the relocator
- **template-repo/hooks/*** — git hooks
- **lib/init** — one-time setup script

## Questions?

- Examine a working store:
  `ls -la ~/.local/state/git-localhost-store/repos/<encoded>/`
- Test manually before committing.
- Keep it simple — less code is better code.
