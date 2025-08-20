# Redo Build System Guide

This project uses the [redo build system](https://redo.readthedocs.io/) for managing data processing pipelines.

## Quick Start (for Claude)

**Basic .do file template:**
```bash
#!/bin/bash
set -eu                                    # Always use for safety

redo-ifchange input.json process_script.py # Declare dependencies first

# For files: write to stdout (redo redirects to target)
echo "result"

# For directories: write to $3, then redo handles mv
# mkdir -p "$3" && process-data input.json "$3"
```

**Environment variables:**
- `$1` - Target name being built
- `$2` - Target basename/stem (useful for pattern rules)
- `$3` - Temporary output file (use for directories only)

**Critical rules:**
1. **Files**: Write to stdout, **Directories**: Write to `$3` (temp)
2. **Dependencies**: Declare with `redo-ifchange` before using files
3. **Safety**: Always use `set -eu` in bash scripts
4. **One .do file per target type** (use pattern matching)

**Built-in commands:**
- `redo-ifchange targets...` - Declare dependencies, build if outdated
- `redo-ifcreate targets...` - Rebuild if nonexistent files are created
- `redo-always` - Mark target as always needing rebuild
- `redo-stamp` - Use content-based change detection
  ```bash
  # For stdout outputs that should use content-based change detection:
  if [[ "$REDO" ]]; then exec > >(tee >(redo-stamp)); fi
  ```

## Core Patterns

### Data Directories

Use `.d` directories for "fanning out" from fewer inputs to many outputs:

```bash
# reports.d.do - creates directory with multiple files
#!/bin/bash
set -eu
redo-ifchange input.json
mkdir -p "$3"
process-data input.json "$3"  # Creates multiple files in $3/
```

**Fan-in pattern** - depend on entire directory:
```bash
# summary.txt.do - rebuilds when any file in reports.d changes
#!/bin/bash
set -eu
redo-ifchange reports.d
summarize-reports reports.d  # Write to stdout
```

### Pattern Rules

Use `default.ext.en.sion.do` to build all `*.ext.en.sion` files:

```bash
# default.report.txt.do - builds all *.report.txt files
#!/bin/bash
set -eu
# $2 is the stem (e.g., "daily" for daily.report.txt)
redo-ifchange "data/$2.json"
generate-report "data/$2.json"
```

**Pattern rule behavior:**
- More specific `.do` files override `default.*.do`
- **CWD**: Directory of `.do` file, not target
- **Single-file constraint**: `[[ "$(basename "$1")" == "summary.report.txt" ]]`

### Project Structure Best Practices

**Good patterns:**
```
default.list.do          # builds *.list files
report.txt.do            # builds report.txt

# Or namespace .do files:
reports/
  default.list.do        # builds ../reports-*.list files  
```

**Anti-patterns (cause dependency/race issues):**
```
# DON'T: .do files inside .d directories
data.d/default.clean.do  # AVOID

# DON'T: directory and its members as separate targets
data.d.do             # builds data.d
default.report.do     # builds data.d/*.report
data.d/abc.report     # has two definitions! - AVOID

# Solution: use separate directories
reports.d.do          # builds reports.d/
```

## Usage & Debugging

### Running Builds
```bash
redo target-name                    # Build one target
redo target1 target2                # Build multiple
redo all                           # Build everything (if 'all' target exists)
```

### Debugging Commands
```bash
redo-whichdo target-name           # See which .do file builds target
redo-ood                          # List out-of-date targets  
redo-log target-name              # View build logs
redo -d target-name               # Debug dependency checks
redo -v target-name               # Verbose (show script lines)
redo -x target-name               # Trace (show executed commands)
redo -k target1 target2           # Keep going on failures
```

### Parallel Execution
```bash
redo -j2                          # 2 parallel jobs
redo -j$(($(nproc) * 2))         # CPU cores * 2 (for I/O bound)

# Debug parallel issues:
redo --shuffle target             # Test dependency problems
redo -j2 --debug-locks target     # Monitor lock contention
```

**This project sets default parallelism** via `bin/redo` (overrides system redo).

**Disable parallelism for sub-processes:**
```bash
unset MAKEFLAGS  # When calling make or similar tools
```

## Project Conventions

### Code Organization
- **Complex logic**: Move messy bash to Python scripts under `bin/`
- **Shared code**: Reusable Python modules under `lib/python/`
- **PATH/PYTHONPATH**: Automatically configured by `.envrc`

### Data Formats  
- **Structured data**: Default to JSONL (one JSON object per line)
  - Easy to process with `jq`, easy to extend
- **Simple lists**: Use `.list` files for single strings per line

### Dependencies on Generated Files
Use `redo-ifchange` on any file - redo automatically builds dependencies first.

---

**When in doubt**: Declare more dependencies rather than fewer. Redo's incremental builds make this efficient.