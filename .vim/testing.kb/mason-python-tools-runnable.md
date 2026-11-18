---
last-tested: "2026-05-05"
result: pass
scope: mason
---

# Mason-installed Python tools are runnable

Verifies the Python-based mason packages (`black`, `isort`, `gitlint`) can
actually execute. Mason creates a venv per Python package; the venv's
`bin/python` is symlinked to whatever Python interpreter mason found at install
time. If that interpreter later disappears (system upgrade, brew uninstall,
custom alternative removed), every binary in the venv produces a
`bad interpreter` error and conform / nvim-lint fail with `ENOENT` even though
the binary symlink in `mason/bin/` still resolves.

This recipe surfaces that class of failure without involving conform.

## Procedure

```bash
for tool in black isort gitlint; do
  printf '%-12s ' "$tool"
  "$tool" --version 2>&1 | sed -n '1,3p'
done
```

## Expected

Each tool prints its version banner. A `bad interpreter: No such file or
directory` line indicates a broken venv; the fix is to delete the package
directory + bin symlink and let `mason-tool-installer`'s `run_on_start = true`
recreate the venv against whichever Python is on `$PATH` at install time:

```bash
rm -r ~/.local/share/nvim/mason/packages/<tool>
rm ~/.local/share/nvim/mason/bin/<tool>
# then start nvim — mason-tool-installer reinstalls.
```

## Last result (2026-05-05)

All three pass post-reinstall:

```
black        black, 26.3.1 (compiled: yes)
isort        VERSION 8.0.1
gitlint      gitlint, version 0.19.1
```

The venv `bin/python` symlinks now resolve to `python3.13` (system python at
`/usr/bin/python3.13`).

### Earlier this session: failure mode

Pre-fix, every tool produced
`bash: .../mason/packages/<tool>/venv/bin/python: bad interpreter: No such file
or directory`. The dangling Python symlinks were:

- `black/venv/bin/python3.11` → `/home/linuxbrew/.linuxbrew/opt/python@3.11/bin/python3.11`
  (linuxbrew's python@3.11 had been removed)
- `isort` and `gitlint` → `/home/bukzor/bin/alternatives/python3` (dead link)

Nuking the package dir + bin symlink and restarting nvim was sufficient — no
manual `MasonInstall` invocation needed, because `mason-tool-installer` runs on
every start and notices the missing packages.

## Note: non-Python tools verified separately

The non-Python tools we install (`prettierd`, `shellcheck`, `dotenv-linter`,
`tfsec`) are single binaries, not venvs, and don't fail this way. Spot-check:

```bash
for tool in prettierd shellcheck dotenv-linter tfsec; do
  printf '%-16s ' "$tool"; "$tool" --version 2>&1 | sed -n '1p'
done
```
