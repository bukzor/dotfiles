---
managed-by: Skill(llm-subtask)
status: open
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

## Decisions

## Open Questions

## Final report
