# Cargo install root via config.toml for brew bundle compatibility

**Date:** 2026-02-05
**Status:** Accepted

## Context

Cargo binaries are installed to `~/prefix/cargo/` (not the default `~/.cargo/`).
This was configured via `export CARGO_INSTALL_ROOT="$PREFIX/cargo"` in `.profile`.

`brew bundle` sanitizes the environment before running, stripping env vars like
`CARGO_INSTALL_ROOT`. This caused `cargo install --list` (used internally by brew
bundle's `CargoDumper`) to return an empty list — it looked in `~/.cargo/` instead
of `~/prefix/cargo/`. Brew bundle then treated all `cargo` Brewfile entries as
uninstalled and rebuilt them from source on every run.

## Decision

Declare the install root in `~/.cargo/config.toml` instead of an env var:

```toml
[install]
root = "/home/bukzor/prefix/cargo"
```

Cargo's precedence for install root is:
`--root` → `CARGO_INSTALL_ROOT` env → `install.root` config → `CARGO_HOME` env → `$HOME/.cargo`

When brew strips the env var, cargo falls back to the config file and still finds
the right install metadata. The env var (`CARGO_INSTALL_ROOT`) is removed from
`.profile`; the PATH entry is changed from `$CARGO_INSTALL_ROOT/bin` to
`$PREFIX/cargo/bin` (same effective path, no indirection through a now-absent var).

## Files Changed

- `~/.cargo/config.toml` — new, git-tracked (un-ignored via `!.cargo/config.toml`)
- `~/.profile` — removed `CARGO_INSTALL_ROOT` export, updated PATH entry
- `~/.gitignore` — added negation pattern for `.cargo/config.toml`

## Alternatives Considered

### Patch brew bundle to propagate CARGO_HOME/CARGO_INSTALL_ROOT
- **Pros:** Fixes the root cause for everyone
- **Cons:** Upstream PR cycle; doesn't fix it today

### Conditional Brewfile entry (`cargo "trunk" unless system(...)`)
- **Pros:** Quick workaround
- **Cons:** Skips brew bundle's version tracking; per-package, doesn't scale

### Keep env var, accept slow brew bundle
- **Pros:** No changes
- **Cons:** Full `cargo install` rebuild on every `brew bundle` run

## Consequences

**Positive:**
- `brew bundle` correctly detects installed cargo packages
- Config is file-based and git-tracked — survives env sanitization
- No upstream dependency

**Negative:**
- Hardcoded absolute path in config.toml (not parameterized via `$HOME`)

## Related

- Related to: `bukzor.garden` deploy work (Brewfile with `cargo "trunk"`)
