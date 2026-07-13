# Testing git-localhost-store

## Quick Test (Automated)

```bash
./test-reference-transaction
```

Runs a full cycle: init → add → commit → verify. Uses `--template=` for
isolation (does not require global config).

## Manual Test Cases

One file per scenario, in `docs/dev/testing.kb/`. Each is standalone —
read one, run it, no chasing dependencies.

```bash
ls docs/dev/testing.kb/
```

Browse the directory or open `docs/dev/testing.kb/CLAUDE.md` for
maintenance conventions.

## Prerequisites (any test)

```bash
# claude-path must be on PATH
which claude-path

# git-localhost-store must be on PATH
export PATH="$HOME/.local/share/git-localhost-store/bin:$PATH"

# Isolate the store tree -- never point this at the real ~/.local/state
export XDG_STATE_HOME=~/trash/test-state-home

# Either: global config so all tests get our hooks
git config --global init.templateDir "$HOME/.local/share/git-localhost-store/template-repo"

# Or: each test that wants the hooks passes --template= explicitly
```

## Common Issues

### Hook doesn't run

- `git config --global init.templateDir` should point at
  `$HOME/.local/share/git-localhost-store/template-repo`.

### `claude-path` not found

- `~/bin` should be on `$PATH`; `which claude-path` confirms.

### Object store not created

- Hook must be executable:
  `ls -la ~/.local/share/git-localhost-store/template-repo/hooks/post-index-change`
- Parent of state directory must exist: `ls -la "${XDG_STATE_HOME:-$HOME/.local/state}"`

### Recovery doesn't work

- Object store must exist:
  `ls "${XDG_STATE_HOME:-$HOME/.local/state}/git-localhost-store/repos/"`
- Encoded name must match: `claude-path <workdir>` and look for the
  matching directory under `repos/`.

## Cleanup

```bash
rm -r ~/trash/test-* "$XDG_STATE_HOME"
```
