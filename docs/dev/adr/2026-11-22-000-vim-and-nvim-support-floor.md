# Vim and nvim support floor

**Date:** 2026-11-22
**Status:** Proposed (Windows and old-nvim drops agreed; Vim floor pending)

## Context

Until 2026-11-22 the Check Vim / Check Neovim workflows never loaded the real
config (`.vimrc` sourced `$HOME/.vimrc.d`, which on a runner is not the
checkout), so their 8+5 jobs passed regardless. Once the config really
loaded (`bin/vim-config-test`), these failed:

- nvim 0.9.5, 0.10.0: locked plugins require nvim >= 0.12 (aerial:
  "deprecated for Neovim <0.12"; nvim-treesitter `main` fails to load).
- Vim 8.2.3995 (ubuntu-22.04 apt): `wildoptions=pum` needs 8.2.4325.
- Windows (native): Vim exits 1 with no message (no `/dev/stderr`); nvim
  hangs to the 5-minute job timeout.

The goal is that the config "just works" where it lands: workstations, WSL,
docker images, GKE nodes.

## Decision

- **No Windows.** Windows use is WSL, which is Linux; the ubuntu jobs cover it.
- **nvim: latest stable only** (CI: stable + nightly). The official release
  tarball runs unpacked in `$HOME` -- no root, no compiling -- on any glibc >=
  2.34 (measured: `objdump -T` of the v0.12.6 binary). That is Ubuntu 22.04+,
  Debian 12+, RHEL 9+. Where it won't run (musl/Alpine, RHEL 8, air-gapped
  hosts), the fallback is Vim with this vimrc, not an old nvim.
- **Vim: >= 8.2.3995**, the version in the oldest Ubuntu LTS still in standard
  support (22.04, until 2027-04). CI's `stable` job on `ubuntu-22.04` installs
  exactly that. A feature newer than the floor is used behind a capability
  check (try the setting, catch its error), not a version check.

## Alternatives Considered

### Keep the old-nvim jobs and pin plugins per nvim version
- **Pros:** supports distro-packaged nvim (22.04 apt: 0.6).
- **Cons:** a second plugin lockfile to maintain for an editor the release
  tarball already makes free to upgrade.

### Vim floor at RHEL 8's 8.0.1763
- **Pros:** covers RHEL 8 / Rocky 8 hosts (supported to 2029).
- **Cons:** guards on far more of the config; no current use lands there.
  Revisit if one appears.

## Consequences

**Positive:**
- 13 test jobs become 6, each testing a version the config claims to support.

**Negative:**
- When GitHub retires the `ubuntu-22.04` runner, the floor job needs a
  replacement that still installs 8.2.3995 (e.g. an `ubuntu:22.04` container).

**Neutral:**
- Distro versions above (Vim and glibc per release) are from package records,
  not re-verified here -- except ubuntu-22.04's Vim, confirmed 8.2.3995 (plus
  security backports) by the CI job's `Included patches` line.

## Related

- Related to: `bin/vim-config-test`, `lib/vim-config-test.vim`,
  `.github/workflows/check-{nvim,vim}.y*ml`
