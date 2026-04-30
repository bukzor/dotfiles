# Switch from gitfile-pointer layout to symlink layout

**Date:** 2026-04-30
**Status:** Accepted

## Context

The original layout for git-localhost-store replaced a working
directory's `.git/` directory with two artifacts:

1. A *gitfile* `.git` (regular file) whose contents are
   `gitdir: <store>/worktrees/<name>`
2. A bare repo at `<store>/` plus a per-worktree subdir at
   `<store>/worktrees/<name>/` holding `HEAD`, `commondir`, `gitdir`,
   `index`, and a per-worktree `refs/` dir.

This works for git itself — git's discovery code follows the gitfile and
operates correctly. **It breaks naive consumers** that read `.git/<x>`
as a filesystem path, because path resolution through a regular file
fails:

```
$ cat .git/HEAD
cat: .git/HEAD: Not a directory
```

The triggering case was lazy.nvim, whose `Util.head` does
`io.open(repo .. "/.git/HEAD")` directly. When `:Lazy install` ran on a
plugin in this layout (`baleia.nvim`, in `~/.vim/pack/lazy/opt/`),
`Lock.update` iterated all installed plugins and hit
`assert(Git.info(plugin.dir))`, which returns nil for any gitfile-style
`.git` and aborted the entire install path:

```
.../lazy/manage/lock.lua:26: bad argument #1 to 'assert' (value expected)
```

Lazy isn't unique — any tooling (CI scripts, IDE plugins, custom shell
helpers) that assumes `.git/HEAD` is a readable file from a directory
has the same failure mode against the gitfile layout.

## Decision

Replace the gitfile-pointer layout with a **symlink layout**:

1. Move `<workdir>/.git/` to `<store>/` (as a regular, non-bare gitdir).
2. Replace `<workdir>/.git` with a symbolic link → `<store>`.

```
<workdir>/.git -> <store>          (was: gitfile containing "gitdir: <store>/worktrees/<name>")
<store>/                           (was: bare repo + worktrees/<name>/ subdir)
  HEAD, index, refs/, objects/, packed-refs, config, hooks/   (single tier; "bare = false")
```

`.git/HEAD`, `.git/refs/heads/...`, etc. now resolve through the symlink
as ordinary files. Naive readers work unchanged. Git itself follows the
symlink the same way it would follow a real `.git/` directory —
supported on Linux without ceremony. (The gitfile mechanism was
originally introduced for filesystems without symlink support,
principally Windows/FAT.)

## Alternatives Considered

### A. Keep the gitfile layout; patch lazy.nvim

Send a PR to lazy.nvim (and any other naive reader) to resolve gitfiles
before reading `.git/<x>`.

- **Pros:** Doesn't require changing our system.
- **Cons:** Open-ended whack-a-mole; we don't control every tool's read
  path. Patches take time to land. New tools we adopt later may have
  the same bug.

### B. Path-guard the gitfile layout to skip plugin directories

Add a check in `git-restore-repo` that bails when the working directory
is under `~/.vim/pack/lazy/`.

- **Pros:** Narrow-scope; the gitfile layout keeps working everywhere
  else.
- **Cons:** Doesn't address the underlying assumption mismatch — only
  hides it for one toolchain. Any future tool with the same bug needs
  another carve-out.

### C. Symlink layout (CHOSEN)

Replace the gitfile with a symlink to a regular gitdir.

- **Pros:** Naive `.git/<x>` readers work transparently. Single tier in
  the store (no `worktrees/<name>/` indirection). Smaller config.
- **Cons:** Loses the gitfile-layout's ability to host multiple working
  directories per object store via `worktrees/<a>/` and
  `worktrees/<b>/`. We don't use that capability today; users can still
  call `git worktree add` from the central gitdir for ad-hoc linked
  worktrees (git native behavior, unaffected).

## Consequences

**Positive:**
- Naive `.git/<x>` readers (lazy.nvim and similar) work unchanged.
- The store layout is simpler — one tier instead of bare-plus-worktree.
- New clones via the existing `init.templateDir` get the new layout
  automatically; no global config change.

**Negative:**
- One-shot migration needed for all existing gitfile-layout repos.
- Multi-worktree-per-store automation (latent in the gitfile layout) is
  not present.

**Neutral:**
- Existing gitfile-layout repos remain operationally functional — git
  itself still follows the gitfile. `migrate-from-gitfile` is the path
  to bring them into the new layout when convenient.

## Related Tooling Added

- `bin/git-restore-repo` — replaced; now does symlink relocation.
- `bin/migrate-from-gitfile` — bash wrapper →
  `python -m bukzor.git_localhost_store.migrate`.
- `bin/audit-gitfiles` — lists workdirs whose `.git` is still a
  gitfile pointing into this store.
- `~/lib/pythonpath/bukzor/xtrace.py` — shared xtrace + fork/exec helper
  (`run`, `query`, `PS4`); used by the migration module.
- `~/lib/pythonpath/bukzor/git_localhost_store/migrate.py` — the
  migration logic.

## Cutover

The install dir (`~/.local/share/git-localhost-store/`) and state dir
(`~/.local/state/git-localhost-store/repos/`) paths were preserved;
their *contents* were replaced in-place with the new logic and merged
with the already-migrated stores. See
`docs/dev/devlog/2026-04-30-000-symlink-layout-cutover.md`.

## Migration Status

`audit-gitfiles` reports remaining repos in the legacy layout. As of
cutover: ~19 outstanding, including `~/` itself, real work repos under
`~/repo/github.com/`, and various test fixtures. Batch migrate when
ready:

```bash
audit-gitfiles | xargs -rn1 migrate-from-gitfile
```

Investigate the audit oddity at `~/claude/amazon-searches` (gitfile
target contains `claude-empty/worktrees/empty` — appears to be a
misconfigured shared store) before batch migration.
