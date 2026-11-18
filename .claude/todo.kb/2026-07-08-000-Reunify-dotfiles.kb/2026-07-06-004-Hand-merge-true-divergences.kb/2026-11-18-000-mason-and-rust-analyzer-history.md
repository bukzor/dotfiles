---
managed-by: Skill(llm-subtask)
status: open
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

## Decisions

## Open Questions

## Final report
