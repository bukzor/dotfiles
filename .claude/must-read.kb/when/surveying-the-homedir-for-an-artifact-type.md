# When Surveying the Homedir for an Artifact Type

Trigger: about to write a `find`/grep-based script (or ad hoc Python) to
scan the whole homedir (or a large slice of it -- all repos, all
CLAUDE.md files, all files of some content shape) for instances of some
artifact type.

**Don't write a new script.** `bukzor-homedir-archeology`
(`~/claude/homedir-archeology/`, package `bukzor_homedir_archeology`) is a
real Python package + CLI: `bukzor_homedir_archeology.survey.find()` owns
the noise-pruning logic (`trash/`, `node_modules/`, venvs, build caches,
`.claude/{file-history,plugins,shell-snapshots,paste-cache,cache,
projects}`, etc.) in exactly one place, and takes your match test as
`find` primaries:

```sh
cd ~/claude/homedir-archeology
uv run bukzor-homedir-archeology find -iname '*.jsonschema.*' -or -iname '*.schema.json'
uv run bukzor-homedir-archeology survey --days 20
uv run bukzor-homedir-archeology jsonschemas
uv run bukzor-homedir-archeology claudefiles
```

For a one-off scan, call `find` (or an existing preset) directly -- no new
file needed. For real parsing (not filename/content grep -- e.g.
comparing parsed subtrees), `import bukzor_homedir_archeology.survey` from
a Python one-liner or a throwaway script; the package already has its own
`pyproject.toml`/`.venv`.

**Only add a new named function/subcommand if the survey is going to be
rerun** -- and if so, add it to `bukzor_homedir_archeology/survey.py` (+ a
subcommand in `cli.py`) calling `find()`, not a copy of the prune list.

If you need pruning that differs from `find()`'s (e.g. excluding
`.claude/` entirely, as `survey()` does), filter the *result* in Python
rather than forking the engine.
