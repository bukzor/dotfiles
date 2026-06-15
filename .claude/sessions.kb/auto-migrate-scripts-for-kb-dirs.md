---
cwd: /home/bukzor/repo/github.com/bukzor/bukzor-agent-skills/llm-kb
session:
  started: null
  ended: null
---
# Auto-migrate step for scripts touching .kb/ directories

Last open item in the `.d/ -> .kb/` rename todo. Scripts that read
or write `.kb/` directories should auto-migrate `.d/ -> .kb/` on
encounter, similar to how llm-collab-devlog migrates
`docs/devlog -> docs/dev/devlog`.

## Why It Is Its Own Session

Infrastructure change distinct from the doc-level rename rollup:
touches scripts under `lib/python/llmd/` and possibly the parallel
helpers in `llm-collab/`. Different blast radius and different
testing burden.

## Tracker

`.claude/todo.kb/2026-01-02-000-complete-d-to-kb-rename.md`
(last bullet under Implementation Steps)
