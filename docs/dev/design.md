---
label: DESIGN
standing: agent
ontology:
  - design record
non-claim-tokens:
  - DAG
stale-when: a sub-ledger here that no longer describes what the dotfiles do, and carries no `todo:` saying so
---

# ~ (dotfiles) -- design records, as ledgers

One theory per designed subsystem, each a claim ledger
(`Skill(llm-claims-kb)`, stratified per `Skill(llm-design-kb)`):
`design.kb/<subsystem>.md` beside `design.kb/<subsystem>.kb/`. The
formal bases they rest on live beside this file as flat ledgers
(`*.claims.md`); a design record cites those, and restates nothing.

Subsystems: `intent-d` -- how `~/.config/sh` is organized and loaded.

## Scans

```bash
grep -rH '^standing:' docs/dev/design.kb/                # who signed what
grep -rHE '^standing: (open|agent)' docs/dev/design.kb/  # awaiting the owner
grep -rl '^todo: true' docs/dev/design.kb/               # decided, not yet built
```
