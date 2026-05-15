---
requires:
  - writing-bash-scripts.md
---

# Writing redo (`.do`) scripts

**Trigger:** before creating or modifying any `*.do` file.

## Contract

- `$1` — final target path.
- `$2` — target basename with the matching `.do` stem stripped (the pattern stem for `default.*.do` rules).
- `$3` — temp path to write. Redo moves `$3` → `$1` on clean exit.
- For single-file targets, **write to stdout**, not `$3`.
- stderr is for progress/summaries, never data.
- Declare deps with `redo-ifchange` *before* reading them.
- CWD is the directory of the `.do` file, not the target.

## Helpers

- `redo-ifchange <paths>` — rebuild when any listed path changes. The common case.
- `redo-ifcreate <paths>` — rebuild when a currently-nonexistent file comes into being (negative dependency).
- `redo-always` — mark the target as always out of date.
- `redo-stamp` — content-based change detection: if the output bytes haven't changed, downstream targets skip rebuild. For stdout-writing scripts:
  ```bash
  if [[ "${REDO:-}" ]]; then exec > >(tee >(redo-stamp)); fi
  ```

## Pattern rules

`default.<ext>.do` builds all `*.<ext>` targets. `$2` holds the stem.

```bash
# default.report.txt.do — builds e.g. daily.report.txt from data/daily.json
redo-ifchange "data/$2.json"
generate-report "data/$2.json"
```

More specific `.do` files override `default.*.do`.

## Directory targets

Redo's `$3 → $1` move assumes `$1` is a file. For a directory target, a rebuild would nest the new dir inside the stale one. Name such targets `foo.d` and the script `foo.d.do`.

### Recipe

```bash
#!/bin/bash
set -euo pipefail

redo-ifchange <deps>

mkdir -p "$3.tmp"
# ... populate "$3.tmp/" ...

if [ -e "$1" ]; then
  mv "$1" "$1.old"
fi
mv "$3.tmp" "$3"
if [ -e "$1.old" ]; then
  rm -r "$1.old"   # no -f: surface unexpected state loudly
fi
```

The `$1.old` dance pre-clears the stale directory so redo's file-oriented move into `$1` doesn't nest, and keeps the prior good build intact until the new one is installed.

### Fan-in

A downstream target can `redo-ifchange foo.d` to rebuild when *any* file inside the directory changes.

### Anti-patterns

- Don't put `.do` files inside a `.d/` target directory — they get rebuilt/clobbered with the directory.
- Don't define both a `foo.d.do` (building the whole dir) and a `default.<ext>.do` that matches files inside `foo.d/`. That's a double definition; files inside get two conflicting rules. Use a separate sibling directory instead.

## Multiple outputs

Prefer a single `.d.do` directory target over N sibling `.do` scripts or one script that writes siblings as side effects (redo can't track side-effect writes).

## Debugging

- `redo-whichdo <target>` — which `.do` file builds this target.
- `redo-ood` — list out-of-date targets.
- `redo-log <target>` — prior build output.
- `redo -x <target>` — trace executed commands (bash `set -x`).
- `redo -v <target>` — verbose script lines.
- `redo --shuffle <target>` — randomize build order to surface missing deps.
- `redo -k <targets>` — keep going past failures.
