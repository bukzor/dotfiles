# Maintenance Guide for git-localhost-store

Instructions for AI agents maintaining and modifying this system.

## Overview

git-localhost-store protects local git repositories from accidental deletion by storing all objects in a central, path-encoded location. When you `rm -rf` a working directory, the commits survive and can be recovered.

## Architecture

**Core concept:** Use git worktrees to share objects between working directory and protected store.

```
~/.local/share/git-localhost-store/          (version controlled)
├── bin/
│   ├── init           # Setup script
│   └── claude-path -> ~/bin/claude-path
├── template-repo/     # Git init template
│   └── hooks/
│       ├── post-index-change  # Triggers setup on first git add
│       ├── post-init          # Core worktree setup logic
│       └── pre-commit         # Triggers setup before commit
├── CLAUDE.md          # This file
├── README.md          # User documentation
└── TESTING.md         # Manual testing guide

~/.local/state/git-localhost-store/          (not version controlled)
└── repos/
    └── <encoded-path>/        # Bare git repo (object store)
        ├── objects/           # Shared objects
        ├── refs/              # Shared refs
        └── worktrees/
            └── <basename>/    # Worktree metadata
                ├── HEAD
                ├── gitdir     # Points to working dir .git file
                ├── commondir  # Points to ../.. (bare repo)
                ├── index
                └── refs/      # Worktree-specific refs
```

## Key Design Decisions

### Why Worktrees?

Initially tried:
1. **Alternates + symlinked refs** - Git doesn't like symlinked refs
2. **Alternates + push-based sync** - Required 3 sync hooks, complex

Worktrees are git's native solution:
- Objects automatically shared
- Refs automatically shared
- No sync hooks needed
- Multiple worktrees supported naturally

### Why Not Symlink Entire .git?

Bare repos require `core.worktree` config which only supports one worktree. Modern worktrees use `$GIT_DIR/worktrees/` structure which supports multiple worktrees.

### Path Encoding

Uses Claude Code's encoding scheme via `~/bin/claude-path`:
```
/home/user/projects/repo → -home-user-projects-repo
```

Hyphens in paths: `-` becomes `--`, `/` becomes `-`.

This creates deterministic, collision-free storage paths.

## Hook Logic Flow

### post-index-change (triggered by `git add`)

```bash
if [ -d .git ]; then  # Not yet converted?
    post-init         # Run setup
fi
```

### post-init (core setup logic)

1. **Check if object store exists**
   - No: Move `.git` → object store, mark as bare
   - Yes: Verify `.git` is empty, error if conflicts

2. **Create worktree structure**
   - `worktrees/<basename>/gitdir` → points to working dir `.git` file
   - `worktrees/<basename>/commondir` → points to `../..` (bare repo root)
   - `worktrees/<basename>/HEAD` → copy from bare repo
   - `worktrees/<basename>/refs/` → empty directory
   - Preserve index if exists (staged changes)

3. **Convert working dir**
   - Replace `.git/` directory with `.git` file
   - Content: `gitdir: <path-to-worktree-dir>`

4. **Recovery (if object store has commits)**
   - Restore deleted tracked files: `git ls-files --deleted | ... | git restore`
   - Does NOT restore modifications or delete untracked files

### pre-commit (fallback)

Same logic as post-index-change, catches cases where user commits without adding.

## Making Changes

### Adding New Hook Logic

Hooks should be **idempotent** - safe to run multiple times. Check state before modifying.

Good pattern:
```bash
if [ ! -f "$MARKER" ]; then
    # Do setup
    touch "$MARKER"
fi
```

### Modifying Worktree Setup

The worktree structure must match git's expectations:
- `gitdir` file: absolute path to working dir `.git` file
- `commondir` file: relative path `../..` to bare repo root
- `HEAD` file: copy from bare repo or `ref: refs/heads/main`
- `refs/` directory: must exist (even if empty)
- `index` file: worktree-specific index (staged changes)

Test changes thoroughly - see TESTING.md.

### Trace Output

Use subshells for targeted tracing:
```bash
(set -x
    command1
    command2
)
```

PS4 is set to teal `$` for readability: `export PS4=$'\e[36m$\e[0m '`

Only trace the most relevant commands. Avoid:
- Conditionals (`if`, `[ ]`)
- Variable assignments
- Echo statements

### Error Handling

Always fail loudly on errors:
- Use `set -euo pipefail`
- Print errors to stderr: `>&2`
- Exit with non-zero status
- Explain what went wrong and what user should do

Never hide errors with `|| true` unless specifically intended.

## Testing

Before committing changes:

1. **Run manual tests** - See TESTING.md for complete test suite
2. **Test fresh setup** - New repo from scratch
3. **Test recovery** - Delete and restore
4. **Test edge cases** - Empty repos, existing repos, conflicts

Minimum test sequence:
```bash
# Fresh setup
cd ~/tmp/test && git init && echo "test" > f && git add f && git commit -m "test"

# Recovery
cd ~/tmp && rm -rf test && mkdir test && cd test && git init && touch t && git add t

# Verify
git log  # Should show original commit
ls -la   # Should have 'f' restored, 't' present
```

## Common Maintenance Tasks

### Updating Hook Logic

1. Edit hook in `template-repo/hooks/`
2. Test manually (see TESTING.md)
3. Commit to dotfiles repo
4. No need to update existing repos - hooks are copied at `git init` time

### Adding New Features

1. Check if it fits the "automatic protection" model
2. Avoid requiring user interaction in hooks
3. Document in README.md
4. Add tests to TESTING.md
5. Update this CLAUDE.md if architecture changes

### Debugging Issues

Check in order:
1. Is `init.templateDir` configured? `git config --global init.templateDir`
2. Are hooks executable? `ls -la template-repo/hooks/`
3. Is `claude-path` in PATH? `which claude-path`
4. Check hook output: Hooks write to stderr, visible during `git add`
5. Examine object store: `ls -la ~/.local/state/git-localhost-store/repos/`

Enable more tracing by adding `set -x` to more commands in hooks.

## What NOT to Do

❌ **Don't use `git config core.worktree`** - Only supports one worktree
❌ **Don't symlink refs or HEAD** - Git doesn't handle this correctly
❌ **Don't use `reset --hard`** - Too destructive during recovery
❌ **Don't hide errors** - Let hooks fail visibly
❌ **Don't enumerate directory contents in docs** - Goes stale quickly

## Related Files

- **README.md** - User-facing documentation
- **TESTING.md** - Manual testing procedures
- **bin/init** - One-time setup script
- **template-repo/hooks/*** - Git hooks (the actual implementation)

## Documentation System

This project uses llm-collab-docs patterns for coordination:
- ADRs in docs/adr/ (date-based)
- Devlogs in docs/devlog/
- Persistent TODOs in .claude/todo.d/

When working on this project, load the llm-collab-docs skill for helper scripts and pattern details.

## Questions?

When in doubt:
- Read the git-worktree documentation: `man git-worktree`
- Examine working system: `ls -la ~/.local/state/git-localhost-store/repos/*/worktrees/*/`
- Test manually before committing
- Keep it simple - less code is better code
