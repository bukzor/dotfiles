---
managed-by: Skill(llm-subtask)
status: done
blocked-by: []
required-reading:
  - ./CLAUDE.md
  - ./2026-11-18-001-config-references-missing-on-main.md  # its method and its Decisions; this unit covers what its sweep missed
---

# Svelte-only commands that `.claude/` text tells agents to run

**Parent:** <../2026-07-06-006-Final-merge-and-home-switchover.md> (a
correction to unit 2026-11-18-001)

## Problem Statement

Unit 001 swept the config that machines run. It missed commands that
instruction text tells an agent to run. A peer session found one: the static
trigger in `~/.claude/CLAUDE.md` (`must-read://DIR` →
`Bash(llm-must-read-ls DIR)`) calls `bin/llm-must-read-ls`. Only svelte has
that file (`e2981ab`), so every session on this host fails its first
required step.

These svelte-only `bin/` commands are named in `~/.claude/**/*.md`, outside
`projects/` and `todo.kb/` (coordinator's grep; `sample` is probably just
the English word):

- `llm-must-read-ls`
- `claude-open-tasks-list`
- `claude-open-tasks`
- `claude-jsonl-display`
- `md-frontmatter`
- `rustdoc-json`
- `glyphs`
- `pnpm-upgrade-g`

For each name, read the mention:

- **An instruction to run it** (a trigger, a skill or reference step, a
  recipe): port the command to main with unit 001's method, svelte's file
  unchanged, plus whatever it calls that main lacks.
- **Anything else** (a passing mention, an example): leave it, and list it
  under Decisions.

Do `llm-must-read-ls` first, and push it alone, so sessions stop failing
sooner. Then repeat the sweep more widely: skills
(`~/.claude/skills/*/SKILL.md` and their kbs), `reference.kb/`,
`must-read.kb/`, `sessions.kb/CLAUDE.md`. Look for commands without the
`bin/` prefix, such as `git` subcommands that resolve to `bin/git-*`. Push
main, then `git -C ~ pull --ff-only`, then prove each ported command runs
live (`llm-must-read-ls ~` lists entries; others with `--help` or a
harmless call).

Same ssh workaround as unit 001.

**Scope (only these):** the svelte-only paths you port, added on main in
`dotfiles--main`; `git pull` in `~`; this handoff file.

## Steps

- [x] port `bin/llm-must-read-ls` alone; push; pull `~`; prove live
- [x] classify the named commands; sweep skills (+ kbs, scripts),
  `commands/`, `reference.kb/`, `must-read.kb/`, `sessions.kb/CLAUDE.md`
- [x] port the rest; push; pull `~`; prove each live

## Decisions

- Ported what an agent-facing recipe runs, or a script it runs calls:
  `md-frontmatter{,-set,-diff.jq}` (`must-read.kb/before/lazy-loading/commands.md`,
  llm-kb `migrations.kb/`), `rustdoc-json` (`reference.kb/rust/tooling.md`),
  `claude-jsonl-{cwd,path,display,to-log}` and
  `claude-tokens{,-cost,-wire,-histogram,-params}` (claude-code-archeology),
  `claude-open-tasks-list` (migrations' `validate.sh`/`migrate.sh`).
- Left alone: `claude-open-tasks` (never named), `pnpm-upgrade-g`
  (history, `todo.md`), `logrotate-cron` (an llm-kb todo), `glyphs` and
  `sample` (English). No agent text names `git submodule-add` (svelte's
  only main-missing `bin/git-*`) or `bin/{shim,toolchain,...}/`.

## Open Questions

buck-win10 is Alpine. Host gaps no port can fix (neither branch tracks them):

1. No `claude-path` (bukzor-tools' `claude-code-slug`, per `922d325`):
   `claude-jsonl-path` prints an empty slug and exits 0. Also absent:
   `claude-{search,inventory,branch-list,branch-extract}`. Recommend
   installing bukzor-tools here.
2. `find` is BusyBox, without `-false`: `claude-open-tasks-list`, and the
   migration scripts piping it, exit 1. Recommend `apk add findutils`.
   Two more failures then remain. `~/repo/AlpineWSL/src_x64/rootfs/root`
   is unreadable (llm-kb todo `2026-08-27-001`). Seven
   `~/.claude/{sessions,todo}.kb` links dangle into the uncloned
   `private.meta-reasoning-corpus`. Recommend cloning it.
3. No `zstd`: `rustdoc-json CRATE` and `claude-tokens-wire` on `.zst`
   shards fail. Recommend `apk add zstd`.
4. Both branches: `claude-tokens-cost` has no `PRICES` entry for
   `claude-opus-5-5`, so it fails on today's corpus.
5. Main-only `.claude/commands/breakdown.md` has invalid YAML frontmatter,
   so `md-frontmatter ~/.claude/commands/*.md` exits 1 on main.
   Svelte deleted the file. 004/006 decides.

## Final report

- main `db1d306`: `bin/llm-must-read-ls` (755), pushed alone.
- main `cfca080`: the other 14 paths, with svelte's blobs and modes.
  `git diff origin/main origin/svelte-crostini -- <15 paths>` is empty.
  `~` fast-forwarded to `cfca080`.
- Live (scratch `~/trash/unit-002/`):
  - `llm-must-read-ls ~` lists the must-read entries.
  - `md-frontmatter`: 8 of 9 `commands/*.md` (OQ5), all of `migrations.kb/`.
  - `-set`: an unchanged record is a no-op; a changed one rewrites.
  - `rustdoc-json --help` works (OQ3).
  - `claude-jsonl-{cwd,display,to-log}` work on a real transcript (`-path`: OQ1).
  - `claude-tokens`, `-histogram`, `-params --rates`, `-wire` (on an empty
    dir) all run. `-cost` works on rows other than opus-5-5 (OQ4).
  - `claude-open-tasks-list`: OQ2. With a scratch `find` shim it gets
    past `find`.
