---
cwd: /home/bukzor/repo/github.com/bukzor/bukzor-agent-skills/llm-kb
session:
  started: null
  ended: null
---
# Reconcile seed case-study (May 13 har-browse rust-port)

Run `docs/dev/procedures.kb/reconcile-case-study.md` against the seed
case-study at
`docs/dev/case-studies.kb/2026-05-13-000-har-browse-rust-port-scope-refactor.md`.

The case-study names 7 failure-mode aliases (frontmatter) and ~7
principles (prose), and embeds a multi-step scope-refactor method
inline. None are yet promoted to canonical entries; `failure-modes.kb/`
and `principles.kb/` don't exist.

Full plan (every alias / principle / step):
`.claude/todo.kb/2026-05-15-000-reconcile-seed-case-study-may-13-har-browse-rust-port.md`.

## Run from a fresh context

Per the post-mortem / reconcile-case-study split (see May 13 devlog,
"Post-mortem split" decision): the capturing agent stops at `raw`; a
fresh-context agent does the editorial pass. Don't pick this up
in-session — start a clean window.
