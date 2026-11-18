---
label: BREW_READ
standing: open
why:
  - ../components.md
  - ../architecture.kb/explicit-require.md
---

# Is `HOMEBREW_PREFIX` read lazily, or is `homebrew` required?

`zsh-completion` reads it at load. A function or a literal removes the
last residual edge; `require homebrew` keeps it explicit. Trivial
either way; decide when writing the loader.
