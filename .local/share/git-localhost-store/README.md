# git-localhost-store

**Protect your local git repositories from accidental deletion.**

## Problem

A stray `rm -rf` can destroy weeks of work if you haven't pushed to a remote. Local git repositories are fragile and ephemeral.

## Solution

This system automatically stores all git objects in a protected central location, indexed by working directory path. Even if you delete your entire working directory, your commits are safe and recoverable.

## How It Works

### Automatic Setup

When you run `git init` or `git add` for the first time in a repo, hooks automatically:

1. Create a bare repository in `~/.local/state/git-localhost-store/repos/<encoded-path>/`
2. Link it via git alternates so objects are stored there
3. Sync refs on every commit, checkout, and merge

### Path Encoding

Working directory paths are encoded using Claude Code's scheme to create unique, deterministic storage locations:

```bash
/home/bukzor/projects/myrepo → -home-bukzor-projects-myrepo
```

### Recovery

After `rm -rf` of a working directory:

```bash
mkdir ~/projects/myrepo && cd ~/projects/myrepo
git init  # Automatically detects existing store and recovers everything
```

## Structure

```
~/.local/share/git-localhost-store/
├── bin/
│   ├── init           # Setup script (run once)
│   └── claude-path    # Symlink to ~/bin/claude-path
├── template-repo/     # Git template directory
│   └── hooks/
│       ├── post-init        # Core setup logic
│       ├── post-index-change # Trigger on git add
│       ├── pre-commit       # Trigger on git commit
│       ├── post-checkout    # Trigger on git checkout/clone
│       ├── post-commit      # Sync refs after commit
│       └── post-merge       # Sync refs after merge
└── README.md          # This file

~/.local/state/git-localhost-store/
└── repos/             # Per-repo object stores (not version-controlled)
    └── <encoded-path>/ # Bare git repos
```

## Installation

Check your current setting:
```bash
git config --global init.templateDir
```

**Note**: If you already have a `init.templateDir` set, you'll need to merge your existing hooks into `template-repo/hooks/` before proceeding.

Configure git to use the template:
```bash
git config --global init.templateDir "$HOME/.local/share/git-localhost-store/template-repo"
```

The state directory (`~/.local/state/git-localhost-store/repos/`) will be created automatically on first use.

## Dependencies

- `~/bin/claude-path` - Path encoding utility
- Standard git hooks support

## Maintenance

### Check if a repo has backup

```bash
cat .git/objects/info/alternates
# Should show: ~/.local/state/git-localhost-store/repos/<encoded-path>/objects
```

### List all backed-up repos

```bash
ls ~/.local/state/git-localhost-store/repos/
```

### Manually verify backup

```bash
# From within a git repo
ENCODED=$(claude-path .)
git --git-dir="$HOME/.local/state/git-localhost-store/repos/$ENCODED" log
```

## Limitations

- Only protects commits, not uncommitted changes
- Recovery requires `git init` in the exact original path
- Bare repos in state directory can still be manually deleted
- Does not replace proper remote backups (GitHub, etc.)

## Design Principles

- **Automatic**: Works without user intervention
- **Transparent**: Normal git operations unchanged
- **Deterministic**: Recovery path is predictable
- **Explicit errors**: Failures are visible, not hidden
- **No force operations**: Never uses git --force or destructive flags

## Future Work

### Hook Composition (.d/ pattern)

Currently, git only supports one `init.templateDir`, making it difficult to merge multiple hook systems. A future enhancement could refactor hooks to use a `.d/` directory pattern:

```
template-repo/hooks/
├── post-commit
├── post-commit.d/
│   ├── 10-localhost-store
│   ├── 20-user-hook
│   └── 30-another-hook
```

Each main hook would iterate through its `.d/` directory, executing scripts in order. This would make composing multiple hook systems trivial - just copy scripts into the appropriate `.d/` directory with numeric prefixes for ordering.
