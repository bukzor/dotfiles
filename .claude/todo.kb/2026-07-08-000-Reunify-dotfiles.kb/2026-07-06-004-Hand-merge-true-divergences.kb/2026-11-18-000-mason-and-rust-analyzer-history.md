---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ./2026-11-11-003-vim-lua-and-plugins.md  # Open Questions 3 and 4 only: what this unit re-examines
---

# Mason `PATH = "append"` and main's rust_analyzer settings: still needed?

**Parent:** <../2026-07-06-004-Hand-merge-true-divergences.md> (wave 2, "vim")

## Problem Statement

Unit 003 recommended dropping both of these from main's
`.vim/lua/bukzor/lsp.lua`. The user remembers both as important and asks:
**has something changed to obviate those needs?** Answer that with evidence,
item by item, so the user can rule. This is research only: land nothing in
either workspace.

For each item, establish:

1. **The need it met.** When and why main added it: `git log -S`/`-G` on
   main (also `origin/merged/wsl-buck-win10` or `origin/wsl-buck-win10`,
   whichever exists), commit messages, neighbouring commits, and the
   projects that used it (`napi-derive` suggests a napi-rs project; look
   under `~/repo/` for Rust projects with those dependencies).
2. **What svelte does instead.** How svelte's `lsp.lua` (including
   `fdf02ca`, 2026-11-13, newer than unit 003's analysis) resolves the
   rust-analyzer binary and settings. Check whether svelte ever had and
   then dropped either item.
3. **Whether the need still holds.** Mason's default PATH mode versus
   rustup's `rust-analyzer` proxy (which needs `rustup component add
   rust-analyzer`; check what this host has installed). For each
   rust_analyzer setting main sets (`cargo.allFeatures`/`features`,
   `procMacro.ignored` for async-trait/napi-derive/async-recursion,
   `lruCapacity`, range formatting, `imports.*`), check whether it is still
   a valid key, whether it differs from today's default, and whether the
   bug it worked around (such as proc-macro expansion failures) is fixed
   upstream. Cite rust-analyzer's changelog or config docs.
4. **A recommendation**, with its reason: port as-is, port a named subset,
   or drop.

`nvim` is not on this host: say which conclusions rest on docs rather than a
run.

**Scope (only these files):** this handoff file; it is the findings' home.
Read-only everywhere else; scratch goes in `~/trash/`.

## Steps

- [x] history: `git log -S/-G` over every ref of all three clones
- [x] svelte's resolution, through `fdf02ca`; host state; upstream source and docs
- [x] item-by-item verdicts and recommendation (Open Questions 1-2)

## Decisions

- **Origin.** Absent from main's 2023 `lsp.lua` (`67696ea`/`c535ed2`, via `wsl-buck-win10`); svelte never had
  either. Both arrive 2025-08-20 in Claude-authored bulk commits from the Sentry laptop: `2ee5cfc` (rust
  block, inside "claude-code: comprehensive optimization") and `2cb991c` ("Fine-tune Mason PATH handling for
  dev tools"; comment "let dev-environment tools take precedence"). The rust block was copied, not tuned:
  its `cargo`+`procMacro` part is LazyVim's rust extra verbatim (since `5a441f89`, 2023-06-30); the rest
  uses rust-tools-era (2021-22) key names. Here only `~/repo/nx` (third-party, cloned 2025-09-10, after the
  commit) uses napi-derive; the user's own crate (`git-partial.prototyping`) uses no features or those macros.
- **PATH: the need still holds.** `prototype.deadlock-sim` and `bukzor-agent-skills` pin basedpyright in
  `.venv`, which their `.envrc` puts on PATH. lspconfig's basedpyright and conform's `black`/`isort`
  (`command = "black"` at `016802d`) resolve by bare name on PATH, so under svelte's default `prepend`
  mason's copies shadow the project's. Only prettierd (`from_node_modules`) and `fdf02ca`'s `tsc`/`oxfmt`
  look project-first on their own; nothing in svelte replaced `append` for the rest.
- **PATH: unit 003's objection is real but a host fix.** lspconfig's rust_analyzer has `cmd = {'rust-analyzer'}`
  and mason-lspconfig `40276c4` does not override it, so `append` finds `~/.cargo/bin/rust-analyzer` first.
  Here that proxy lacks its component: `error: Unknown binary 'rust-analyzer' in official toolchain
  'stable-x86_64-unknown-linux-musl'`. `rustup component add rust-analyzer` fixes it (the proxy then follows
  `rust-toolchain.toml`). Proc-macro ABI favors neither binary: r-a uses the toolchain's
  `libexec/rust-analyzer-proc-macro-srv`, present here.
- **Settings** (r-a master: `configuration_generated.md`, `config.rs`; `patch_old_style.rs` still migrates
  every legacy key main uses).
  - Equal to today's defaults (no-ops): `allTargets`, `loadOutDirsFromCheck`/`runBuildScripts`
    (→`buildScripts.enable`), `diagnostics.enable`, `completion.autoimport.enable`, `lens.enable`, `procMacro.enable`.
  - `cargo.allFeatures` → `features = "all"` (default `[]`): real; LazyVim still ships it, and svelte's
    `.config/nvim-lazy` imports `lang.rust`, so it is live there. Breaks crates with mutually exclusive features.
  - `lruCapacity = 1024` → `lru.capacity` (default 128): memory-for-speed tuning, no recorded need.
  - `rustfmt.enableRangeFormatting`: nightly-only rustfmt; this host is stable; conform formats whole buffers.
  - `assist.importGranularity = "module"`, `importPrefix = "by_self"` → `imports.granularity.group`,
    `imports.prefix` (alias kept): style choices against the defaults `crate`/`crate`.
  - `procMacro.ignored`: valid, but LazyVim dropped this same triple 2025-10-19 (LazyVim#6117, #6111) for its
    "proc-macro is explicitly disabled" diagnostics. async-trait#178 closed 2021; napi-rs#944 closed 2024-09,
    with 2025-26 comments still reporting trouble. Applies to no project of the user's here.
- **Evidence.** Run here: the failing proxy, installed components, proc-macro-srv present, no mason install.
  No nvim, so runtime behavior rests on source: mason.txt, lspconfig `lsp/rust_analyzer.lua` (master),
  mason-lspconfig `40276c4`, conform `016802d`. `claude-search` is absent here; the 2025-08 session (Sentry
  laptop) was not consulted.

## Open Questions

1. mason `PATH = "append"`, the user's call. **Port it, and run `rustup component add rust-analyzer` on each
   host** (a host step, not config; mason's rust-analyzer stays as the fallback where there is no rustup).
   This reverses unit 003's Q3: the need holds today, and 003's objection is about host state. The other
   option is to drop it (svelte verbatim) and accept that mason's basedpyright, black and isort override
   each project's pinned versions.
2. main's rust_analyzer block, the user's call. **Drop all of it** (keep svelte's `inactive-code`-only
   config). Nothing in it records a need, and `procMacro.ignored` now does harm. The other option is to port
   only `cargo.features = "all"`, if the user wants nvim's `lsp.lua` to match the LazyVim profile.

## Final report

- Research only: nothing landed in either workspace except this file. Findings are in Decisions, and the
  rulings needed are Open Questions 1-2. If both recommendations are accepted, `lsp.lua` is svelte's file
  plus one line, `PATH = "append",`, in `setup_mason`.
- Scratch, with the upstream sources fetched: `~/trash/mason-ra-research/`.
