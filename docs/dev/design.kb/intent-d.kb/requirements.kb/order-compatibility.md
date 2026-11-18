---
label: COMPAT
standing: agent
why:
  - ../requirements.md
  - ../../../sh-config-loading.claims.md
---

# Today's numbered files load in the same order under the new loader

A file that sorts after `900-path.sh` by ASCII today (`claude.sh`)
sorts after it under rank-then-name too. The migration may move files
without reordering anything it did not mean to.
