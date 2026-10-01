---
label: COMPONENTS
standing: agent
why:
  - architecture.md
ontology:
  - loader
  - entry point
  - loaded-set
---

# Components

How the architecture is implemented. The **loader** is the `require`
function; an **entry point** is `.profile`, `.zshenv`, `.bashrc`, or
`.zshrc`; the **loaded-set** is the per-process record of intents
already sourced.
