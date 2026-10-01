---
label: AXIS_CHOICE
standing: user
why:
  - ../goals.md
  - ../../../sh-config-loading.claims.md
authority: "session df89c432, 2026-09-19"
---

# Intents on directories, contexts on reserved filenames

The tree is intent-first. Directories carry the open, human-named set
(behaviors); reserved filenames carry the closed vocabulary (contexts).
The loader enforces the reserved names; `ls` discovers the open set.
Ground: AXIS in the flat ledger, and the observed drift of the
consumer-first tree (`history.sh` vs `020-history.sh`), which is the
failure of leaving the open set to convention.
