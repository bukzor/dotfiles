---
label: PATH_OWNER
standing: open
why:
  - ../components.md
  - ../architecture.kb/remove-edges-first.md
---

# Who assembles PATH?

Two candidates. Single owner: `path/env.sh` holds the ordered list
(what `900-path.sh` already is) and `require`s the tool intents whose
variables it reads. Priority-as-data: each tool intent prepends with a
priority number and one finalizer sorts. An answer settles whether
`path` carries ~4 `require` lines or ~8 intents carry a number.
Recommendation: single owner.
