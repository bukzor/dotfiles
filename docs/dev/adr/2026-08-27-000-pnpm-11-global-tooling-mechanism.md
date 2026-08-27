# pnpm 11 global tooling mechanism

**Date:** 2026-08-27
**Status:** Accepted

## Context

[2026-02-13-000] decided that `pnpm add -g` is the sole authority for global npm
tooling, and named the pieces that had to agree: a global bin directory on PATH,
a `packageManager` pin, and a self-hosted pnpm. It did not name the file that
configured any of it.

That file was `~/.config/pnpm/rc`, an ini file holding `prefix=~/prefix/pnpm`,
from which pnpm 10 derived the global root (`<prefix>/5`), the global bin
directory (`<prefix>/bin`), and the store (`<prefix>/store/v10`).

pnpm 11 reads only `~/.config/pnpm/config.yaml`, and `prefix` is gone from both
formats. Nothing errored: pnpm silently fell back to its defaults under
`~/.local/share/pnpm`, whose bin directory is not on PATH.

The upgrade that broke this was performed by the thing it broke. `pnpm-upgrade-g`
ran nightly under pnpm 10, installed pnpm 11 as a global package, and every run
after that failed with `The configured global bin directory … is not in PATH`.
The failures went to a log nobody reads for 35 consecutive runs, and then stopped
appearing at all when an unrelated errexit bug in `.profile` killed the anacron
job before it reached its logging wrapper. Elapsed time to discovery: three and a
half months, by way of an unrelated `pnpm add` at a shell prompt.

## Decision

The decision of [2026-02-13-000] stands. Its mechanism is replaced.

**Locations are declared in `~/.config/pnpm/config.yaml`,** tracked in git:

```yaml
globalBinDir: ${HOME}/prefix/pnpm/bin
globalDir: ${HOME}/prefix/pnpm/global
```

- Keys are camelCase. The kebab-case spellings (`global-bin-dir`) and `prefix`
  are accepted by the parser and silently ignored.
- `${HOME}` is expanded. `~` and `$HOME` are not, and produce a literal path.
- pnpm appends its own layout version to `globalDir`.
- `storeDir` is deliberately unset, leaving the store at its
  `~/.local/share/pnpm/store` default.

**pnpm is no longer a global package, and does not update itself.**
`pnpm add -g pnpm` fails with `ERR_PNPM_GLOBAL_PNPM_INSTALL`, and under corepack
`pnpm self-update` fails with `ERR_PNPM_CANT_SELF_UPDATE_IN_COREPACK`. The
remaining path is `corepack use pnpm@latest`, which rewrites the
`packageManager` pin of the surrounding project -- so the pin in
`~/package.json` is not a bookkeeping detail beside the mechanism, it *is* the
mechanism. corepack appends a `+sha512...` integrity hash to the pin; anything
comparing it to `pnpm -v` must strip that.

**corepack is the entry point,** as [2026-02-13-000]'s bootstrap chain always
said -- what changed is that it now stays enabled instead of being disabled
after self-hosting:

```sh
corepack enable pnpm --install-directory ~/prefix/pnpm/bin
```

`bin/corepack` reaches corepack through `volta which node`, so it follows node
upgrades. The shims corepack writes do not: they are symlinks into the
*versioned* node image, and a node upgrade strands them. That is left to the
scheduled-job health check to catch rather than pre-engineered around.

**Install scripts are approved on the command line.** `allowBuilds` is rejected
in the global config file, and `pnpm approve-builds` refuses to act on global
packages, so the allow-list lives in `bin/pnpm-upgrade-g` as
`--allow-build=<pkg>`. The whole global set must be installed by a single
`pnpm add -g` carrying that same flag list: pnpm keys the global install
directory on the effective settings, and a run with a different flag list can
land in a fresh empty directory and unlink every bin it didn't install itself.

**The declared set is `~/.config/pnpm/global/package.json`,** tracked in git.
pnpm 11 keeps no aggregate manifest of its own -- each global package gets its
own directory under a hashed name that pnpm renames at will -- so this file is
the only restorable record of what is supposed to be installed. Only the names
are read; upgrades always take `@latest`. Path-installed packages
(`pnpm add -g ../foo`) do not belong in it.

**Every upgrade run ends in a smoke test.** `bin/pnpm-upgrade-g` checks that the
global bin directory is on PATH, that everything declared is installed, and that
the `packageManager` pin matches the running pnpm. A tool that upgrades itself
must prove afterwards that it still works.

## Alternatives Considered

### `PNPM_HOME` in the environment

pnpm's own `pnpm setup` writes this, and it is the documented mechanism. One
line in `.config/sh/env.d/` restores all three locations, and unlike the config
file it expands `~`.

Rejected in favor of a tracked config file: the setting is configuration, not
environment, and putting it in a file keeps it reviewable as a diff. The
env-var form also silently disagrees with the config file rather than layering
over it.

### Leaving `storeDir` under `~/prefix/pnpm`

Symmetric with the other two, and matches what pnpm 10 derived from `prefix`.
Rejected: it was never a deliberate choice, only a consequence of `prefix`, and
the default store was already populated. One less path to migrate at the next
major.

## Consequences

**Positive:**
- The mechanism is now written down beside the policy, in two tracked files.
- Nightly upgrades fail loudly instead of accumulating silent errors.
- The store consolidates at the XDG default.

**Negative:**
- corepack's shims are symlinks into a versioned node image, so a node upgrade
  breaks `pnpm` until `corepack enable` is re-run.
- `config.yaml` accepts and ignores settings that belong in
  `pnpm-workspace.yaml`, so a misplaced key is a silent no-op. It does warn.
- `pn` and `pnx`, which pnpm 10 installed as bin stubs, are gone: corepack
  provides only `pnpm` and `pnpx`. Nothing referenced them.

**Neutral:**
- Retiring `~/prefix/pnpm/{5,v3,store}` reclaimed 6.7G. `~/prefix/pnpm` now
  holds exactly `bin/` and `global/`.

## Related

- Extends: `docs/dev/adr/2026-02-13-000-global-npm-tooling-management.md`
  (decision intact, mechanism superseded)
- Implements: `bin/pnpm-upgrade-g`, `.config/pnpm/config.yaml`,
  `.config/pnpm/global/package.json`
- Detection of the failure window it caused:
  `docs/dev/adr/2026-08-27-001-scheduled-job-health.md`
- Cause of the silent failure window: `.config/sh/functions.d/path.sh`
  (a `grep` with no matches aborted `.profile` under `set -e`)

[2026-02-13-000]: 2026-02-13-000-global-npm-tooling-management.md
