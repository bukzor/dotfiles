# Dotfiles Maintenance Context

**Role**: Help maintain Buck's dotfiles repository with security-first approach and specific workflow requirements.

## Critical Requirements

### Security (Never Compromise)
- **Always run before push**: `git diff origin/master..HEAD | grep -iE "(api_key|secret|password|token|sk-|pk-|xoxb-|ghp-)"`
- **Private/public split**: Secrets only in unversioned `private-dotfiles/`, public configs reference `$ENV_VARS`

### Workflow Requirements (Buck's Preferences)
- **Co-located trash**: `mkdir -p bin/trash && mv -it bin/trash/ file` (never flatten to root trash/)
- **Commit prefixes**: Use `"REVIEW NEEDED:"` for uncertain files committed for safety
- **File moves**: Always `git mv` to preserve history
- **Command flags**: Always use `-i` flags (`mv -it`, `cp -i`) to prevent accidents

### Machine-Specific vs Generic
- **Machine-specific configs**: Should be ignored or genericized (absolute paths, user-specific IDs, local network settings)
- **Generic configs**: Template patterns, relative paths, environment variables
- **Example**: Replace `/Users/buck/` with `$HOME`, hardcoded IPs with hostnames

### Opt-in Gitignore Strategy
Many directories use `*` (ignore all) then `!pattern` (selectively include). Check existing `.gitignore` files before adding global patterns.

### File Categories
- **Always commit**: configs without secrets/machine-specifics, reusable scripts/libs, documentation  
- **Never commit**: `*.log`, `*.bak`, caches, `.env` files, tool state (`.doit.db`, `.mypy_cache/`)
- **Uncertain**: Use `"REVIEW NEEDED:"` prefix, can be cleaned up later

## Secret Detection Patterns
```bash
git diff HEAD~5..HEAD | grep -iE "(sk-|pk-|-----BEGIN|xoxb-|xoxp-|ghp-|gho-|ghu-|ghs_)"
git diff HEAD~5..HEAD | grep -E "=[A-Za-z0-9+/]{20,}={0,2}$"  # base64
```

## Error Recovery Context
- **Broken configs**: Check for `path/trash/` directories, restore with `mv -it path/ path/trash/*`
- **Committed secrets**: Don't push! Use `git reset HEAD~1`, remove secrets, recommit
- **Large cleanup**: Use `/lets-commit` command for systematic organization

## Key Principle
**Never suppress error messages** - they're exactly what you need when debugging.