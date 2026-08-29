# Migrate nvim-treesitter to main branch

**Date:** 2026-08-29
**Status:** Accepted

## Context

Startup errored on every launch:

```
nvim-treesitter[latex]: Error during "tree-sitter generate"
error: unexpected argument '--no-bindings' found
```

Our `nvim-treesitter` spec had no explicit `branch`, so lazy.nvim resolved it
to whatever was the repo's default branch at the time we first installed:
`master`. `master`'s installer (`install.lua`) unconditionally passes
`--no-bindings` to `tree-sitter generate` when regenerating a parser from
grammar sources (only `latex` in our `ensure_installed` list needs this).
Homebrew's `tree-sitter-cli` had since updated past 0.25, where that flag was
removed outright (hard error, not just a deprecation warning).

Upstream flipped their repo's default branch to `main` — a full, incompatible
rewrite — and explicitly archived/locked `master` in May 2025
("docs(readme)!: announce archiving of master branch"). Five separate
upstream issues hit this exact symptom after that lock
(nvim-treesitter/nvim-treesitter#7781, #8151, #8366, #8374, #8475); every one
got the same maintainer answer: `master` won't be fixed, switch to `main`. A
2025 PR that tried to just drop the flag from `master` (#7810) was closed,
not merged, for the same reason.

## Decision

Pin `branch = "main"` explicitly in the lazy.nvim spec
(`lua/bukzor/plugins.lua`) and migrate `lua/bukzor/tree-sitter.lua` to
`main`'s API, since `main` is a declared incompatible rewrite, not a superset:

- `require('nvim-treesitter.configs').setup{...}` (legacy, `master`-only) →
  `require('nvim-treesitter').setup{ install_dir = ... }` +
  `require('nvim-treesitter').install{...}`.
- `highlight = { enable = true, disable = fn }` doesn't exist on `main`.
  Highlighting is Neovim core's `vim.treesitter.start()`, invoked ourselves
  from a `FileType` autocmd. Ported the old size-based disable guard
  (skip buffers over 100 KB) into that callback.
- `auto_install = true` doesn't exist on `main` either. Reimplemented: the
  same `FileType` callback installs a missing-but-available parser
  synchronously (`:wait()`) before calling `vim.treesitter.start()`.
- `parser_install_dir` → `install_dir` (same value, `M.treesitter_dir`,
  unchanged on disk).
- Local plugin checkout switched to `origin/main`; `lazy-lock.json` updated
  to match; stale `~/.local/share/nvim/tree-sitters` (built by the old
  installer, different manifest format) moved to `~/trash/` and reinstalled
  fresh — confirmed clean via `testing.kb/nvim-treesitter-parsers-install-and-highlight.md`.

Did not add fold/indent enabling (`main`'s README shows snippets for both) —
the old config never enabled those via treesitter either, so adding them now
would be new scope beyond restoring the pre-breakage behavior.

## Alternatives Considered

### Option A: patch `master`'s `install.lua` locally (and upstream the patch)
- **Pros:** Smallest possible diff; no API migration.
- **Cons:** Upstream has already refused this exact fix (PR #7810, closed)
  because `master` is archived — no maintainer will merge a patch to a locked
  branch. We'd be maintaining a permanent fork of a plugin that no longer
  receives fixes, for a branch upstream explicitly wants users off of.

### Option B: downgrade `tree-sitter-cli` via Homebrew to a pre-0.25 version
- **Pros:** No config changes at all.
- **Cons:** Pins the whole system's tree-sitter tooling to an old version
  indefinitely for one plugin's sake; doesn't fix the root cause (still on an
  archived branch); just defers the same breakage to the next CLI update.

## Consequences

**Positive:**
- Back on an actively maintained branch (upstream commits land same-day, per
  `origin/main` HEAD at time of migration: 2026-08-29).
- `checkhealth nvim-treesitter` clean; `latex` (the parser that needs
  grammar-generation) installs successfully for the first time.

**Negative:**
- `main`'s highlight/fold/indent model is per-buffer opt-in via core APIs
  rather than a single plugin-level table; any future feature toggle (e.g.
  folds) needs its own `FileType`-callback wiring, not a config flag.
- No `disable` list for e.g. malformed grammars — replaced by a generic
  `pcall` around `vim.treesitter.start()`.

**Neutral:**
- `M.ensure_installed` parser list unchanged; auto-install-on-open now also
  covers any parser outside that list (tested with `go`), which the old
  `auto_install = true` also did.

## Related

- Testing recipe: `testing.kb/nvim-treesitter-parsers-install-and-highlight.md`
- Upstream: nvim-treesitter/nvim-treesitter#8475 (most recent duplicate,
  closed "not planned" with the `main`-branch pointer)
