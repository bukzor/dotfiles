# Global npm tooling management

**Date:** 2026-02-13
**Status:** Accepted

## Context

Global (home-directory scoped) CLI tools installed from npm — claude-code, codex,
etc. — need a single authority for installation and upgrades.

Without one, multiple pnpm entry points accumulate on PATH:

| # | Path | Source | Version |
|---|------|--------|---------|
| 1 | `~/prefix/pnpm/bin/pnpm` | `pnpm add -g pnpm` (self-hosted) | 10.29.3 |
| 2 | `~/.volta/bin/pnpm` | `volta install pnpm` (shim) | 10.28.2 |
| 3 | `~/.volta/tools/image/node/…/bin/pnpm` | corepack bundled with volta's node | 10.26.0 |

Whichever pnpm wins the PATH race runs upgrades. Different versions generate
different bin stubs, and upgrades under the wrong pnpm silently leave stubs
pointing at removed package versions → `MODULE_NOT_FOUND` at runtime.

## Decision

**`pnpm add -g` is the sole authority for global npm-sourced tooling.**

- `packageManager` in `~/package.json` pins the pnpm version.
- corepack bootstraps pnpm from any available node (volta-bundled, brew, etc.).
- `pnpm add -g pnpm` self-hosts: once installed, `~/prefix/pnpm/bin/pnpm`
  takes precedence over the corepack shim on PATH.
- After self-hosting, `corepack disable pnpm` removes the corepack shim so it
  cannot shadow the self-hosted binary.
- volta exists only to manage the node version. Its pnpm shim is tolerated
  (lower PATH priority) but not authoritative; removable via `volta uninstall pnpm`.

### Bootstrap chain (default, from bare machine)

```
system packaging / bare OS
  → git clone dotfiles (see README.md)
    → bin/brew (curl brew.sh|bash fallback)
      → brew install volta
        → volta install node
          → node bundles corepack
            → corepack enable pnpm → pnpm (bootstrap)
              → pnpm add -g pnpm (self-hosts)
                → corepack disable pnpm (remove shim)
                  → pnpm add -g <tools>
```

Any other corepack source (brew, nvm, system node) is equally acceptable;
the above is the default path from the dotfiles.

### Possible pnpm entry points (reference)

Per node installation (volta, brew), pnpm can come from:
- Bundled corepack (volta only — brew strips it)
- Separate corepack install (`brew install corepack`)
- `npm install -g pnpm`

Node-independent:
- `volta install pnpm`
- `brew install pnpm` (conflicts with `brew install corepack`)
- `pnpm add -g pnpm` (self-hosted, requires bootstrap)

## Alternatives Considered

### Volta for globals
- **Pros:** Manages node, pnpm, and global packages. Single tool.
- **Cons:** Creates a second authority alongside `pnpm add -g`, causing version
  conflicts and stale bin stubs. GHA runners already have node, so volta adds
  overhead to manage what's already there.

### Brew node + brew pnpm
- **Pros:** Simple.
- **Cons:** No version pinning. Extra moving parts with no clear benefit.

## Consequences

**Positive:**
- Single authority for global npm tooling (`pnpm add -g`)
- volta reduced to node management only — clear, minimal role
- Same pattern (corepack + `packageManager`) as per-project tooling

**Negative:**
- Corepack is technically experimental (but stable in practice)
- Bootstrap requires enable/disable dance: corepack shim must exist for initial
  `pnpm add -g pnpm`, then must be removed so it doesn't shadow the result

## Related

- Extends: `bukzor.garden: docs/dev/adr/2026-02-05-000-corepack-over-volta-for-pnpm-management.md`
- See also: `setup/volta.sh` — implements the bootstrap chain
