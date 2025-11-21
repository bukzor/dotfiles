# git-localhost-store

**Protect your local git repositories from accidental deletion.**

## Problem

A stray `rm -rf` can destroy weeks of work if you haven't pushed to a remote. Local git repositories are fragile and ephemeral.

## Solution

This system automatically stores all git objects in a protected central location, indexed by working directory path. Even if you delete your entire working directory, your commits are safe and recoverable.

## How It Works

### Automatic Setup

When you run `git init` or `git add` for the first time in a repo, hooks automatically run `git restore-repo` which:

1. Creates a worktree-based repository structure in `~/.local/state/git-localhost-store/repos/<encoded-path>/`
2. Converts your `.git` directory to a worktree link
3. Preserves all existing commits and index state

### Path Encoding

Working directory paths are encoded using Claude Code's scheme to create unique, deterministic storage locations:

```bash
/home/bukzor/projects/myrepo → -home-bukzor-projects-myrepo
```

### Recovery

After `rm -rf` of a working directory:

**Automatic (via hooks):**
```bash
mkdir ~/projects/myrepo && cd ~/projects/myrepo
git init  # Hook detects existing store and recovers everything
```

**Explicit (direct command):**
```bash
mkdir ~/projects/myrepo && cd ~/projects/myrepo
git init
git restore-repo  # Directly restore from store
```

## Commands

### `git restore-repo`

Converts an existing git repository to use the localhost store, or recovers a deleted repository if the store already exists.

**Usage:**
```bash
cd /path/to/your/repo
git restore-repo
```

**What it does:**
- Detects if a store exists for this path
- If no store: moves `.git` to the store location and sets up worktree
- If store exists: recovers all commits and tracked files from the store
- Preserves staged changes (index) and existing commits
- Safe to run multiple times (idempotent)

**When to use:**
- Convert an existing repo to use localhost store
- Recover after accidental `rm -rf`
- Fix a broken worktree configuration

**Note:** `git restore-repo` is automatically called by hooks on `git add` and `git commit`, so manual invocation is rarely needed.

## Structure

```
~/.local/share/git-localhost-store/
├── bin/
│   ├── git-restore-repo # Core restore logic (user-facing)
│   └── claude-path      # Symlink to ~/bin/claude-path
├── lib/
│   └── init             # Internal setup script
├── template-repo/       # Git template directory
│   └── hooks/
│       ├── post-index-change # Calls git-restore-repo on git add
│       └── pre-commit        # Calls git-restore-repo on git commit
└── README.md            # This file

~/.local/state/git-localhost-store/
└── repos/               # Per-repo object stores (not version-controlled)
    └── <encoded-path>/  # Worktree-structured repos
        └── worktrees/
            └── <name>/  # Per-worktree data
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

### Check if a repo is using localhost store

```bash
cat .git
# Should show: gitdir: ~/.local/state/git-localhost-store/repos/<encoded-path>/worktrees/<name>
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

- Only protects commits and staged changes, not unstaged modifications
- Recovery requires recreating directory at the exact original path
- Object stores in state directory can still be manually deleted
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
