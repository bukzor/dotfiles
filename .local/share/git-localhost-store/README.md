# git-localhost-store

**Protect your local git repositories from accidental deletion.**

## Problem

A stray `rm -rf` can destroy weeks of work if you haven't pushed to a
remote. Local git repositories are fragile and ephemeral.

## Solution

This system automatically stores all git objects in a protected central
location, indexed by working directory path. Even if you delete your
entire working directory, your commits are safe and recoverable.

## How It Works

When you `git init` or `git clone` (or `git add` in a fresh repo), hooks
automatically run `git-restore-repo` which:

1. Moves `.git/` into a per-repo store under
   `~/.local/state/git-localhost-store/repos/<encoded-path>/`.
2. Replaces `.git` with a **symbolic link** to that store.

After the swap, `.git` is a symlink rather than a directory. Git itself
follows the symlink transparently. Naive readers (lazy.nvim, ad-hoc
shell scripts, IDE plugins) that do `open(repo + "/.git/HEAD")` work
unchanged because the symlink resolves through the filesystem.

### Path encoding

Working directory paths are encoded by `~/bin/claude-path`:
```
/home/bukzor/projects/myrepo → -home-bukzor-projects-myrepo
```

### Recovery

After `rm -rf` of a working directory:

**Automatic (via hooks):**
```bash
mkdir ~/projects/myrepo && cd ~/projects/myrepo
git init
# Hook detects existing store and recreates the symlink
git checkout -- .  # Restore tracked files
```

**Explicit:**
```bash
mkdir ~/projects/myrepo && cd ~/projects/myrepo
git init
git-restore-repo  # equivalent to the hook path
git checkout -- .
```

## Commands

### `git-restore-repo`

Converts an existing git repository to use the localhost store, or
recovers a deleted repository if the store already exists.

**Usage:**
```bash
cd /path/to/your/repo
git-restore-repo
```

**What it does:**
- Detects the store path from the working directory.
- If `.git` is a directory: moves it to the store, replaces it with a
  symlink. Idempotent.
- If `.git` is already a symlink: no-op (`✓ Already a symlink`).
- If `.git` is anything else (gitfile, missing, broken): asserts and
  exits non-zero, leaving you to investigate.

**When to use:** Convert an existing repo, recover after `rm -rf`,
or after changing the global hook config.

**Note:** `git-restore-repo` is automatically called by hooks; manual
invocation is rarely needed.

### `migrate-from-gitfile`

Brings a repo from the legacy gitfile-pointer layout (where `.git` is a
regular file containing `gitdir: ...`) to the current symlink layout.
See `docs/adr/2026-04-30-000-switch-from-gitfile-to-symlink-layout.md`
for context.

```bash
migrate-from-gitfile /path/to/legacy/repo
```

Refuses to operate unless preconditions hold (single-worktree-per-store,
no in-progress git ops, etc.).

### `audit-gitfiles`

Lists workdirs whose `.git` is still a gitfile pointing into this
system's store — i.e., candidates for `migrate-from-gitfile`.

```bash
audit-gitfiles [root]   # default root: $HOME
```

Pipe straight into the migrator when ready:
```bash
audit-gitfiles | xargs -rn1 migrate-from-gitfile
```

## Structure

```
~/.local/share/git-localhost-store/   (version controlled in $HOME)
├── bin/
│   ├── git-restore-repo       # the relocator
│   ├── migrate-from-gitfile   # legacy → symlink layout migrator
│   └── audit-gitfiles         # find unmigrated legacy repos
├── template-repo/             # git init template
│   └── hooks/
│       ├── post-index-change
│       ├── pre-commit
│       └── reference-transaction
├── lib/init                   # one-time setup helper
├── CLAUDE.md                  # maintenance guide for AI agents
├── README.md                  # this file
└── TESTING.md                 # manual testing procedures

~/.local/state/git-localhost-store/   (NOT version controlled)
└── repos/
    └── <encoded-path>/        # gitdir for one workdir
        ├── HEAD
        ├── index
        ├── refs/, objects/, packed-refs
        ├── config             # core.bare = false
        └── hooks/             # copied from template at clone time
```

## Installation

Check your current setting:
```bash
git config --global init.templateDir
```

**Note:** if you already have a template configured, merge its hooks
into `template-repo/hooks/` first.

Configure git to use the template:
```bash
git config --global init.templateDir "$HOME/.local/share/git-localhost-store/template-repo"
```

The state directory is created automatically on first use.

## Dependencies

- `~/bin/claude-path` — path encoding utility
- A python interpreter on `PATH` (for `migrate-from-gitfile`)
- `~/lib/pythonpath/bukzor/` on PYTHONPATH (the migration wrapper sets this
  inline; see `bukzor.xtrace` and `bukzor.git_localhost_store.migrate`)

## Maintenance

### Check if a repo is using localhost store

```bash
ls -la .git
# Expected: a symlink → ~/.local/state/git-localhost-store/repos/<encoded-path>
```

If `.git` is a regular file containing `gitdir: ...` → legacy gitfile
layout, run `migrate-from-gitfile` on the workdir.

### List all backed-up repos

```bash
ls ~/.local/state/git-localhost-store/repos/
```

### Manually inspect a store

```bash
ENCODED=$(claude-path /path/to/workdir)
ls -la ~/.local/state/git-localhost-store/repos/$ENCODED
```

## Limitations

- Protects commits and staged changes, not unstaged modifications.
- Recovery requires recreating the directory at the exact original path.
- Object stores in the state directory can still be manually deleted.
- Does not replace proper remote backups (GitHub, etc.).
- Multi-worktree-per-store is not supported by this system's automation
  (you can still use `git worktree add` from the central gitdir for
  ad-hoc linked worktrees — that's just git native behavior).

## Design Principles

- **Automatic** — works without user intervention.
- **Transparent to naive readers** — `.git/HEAD` resolves through the
  symlink as an ordinary file.
- **Deterministic** — recovery path is predictable from the workdir
  path alone.
- **Explicit errors** — failures are visible. No `|| true`.
- **Idempotent** — hooks and `git-restore-repo` are safe to re-run.

## Future Work

### Hook composition (.d/ pattern)

Currently, git only supports one `init.templateDir`, making it hard to
compose multiple hook systems. A future enhancement: hooks-of-hooks via
a `.d/` directory pattern.

```
template-repo/hooks/
├── post-commit
├── post-commit.d/
│   ├── 10-localhost-store
│   ├── 20-user-hook
│   └── 30-another-hook
```

Each hook iterates its `.d/` and dispatches in numeric order.
