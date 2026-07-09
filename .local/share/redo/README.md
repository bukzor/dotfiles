# Vendored: apenwarr minimal/do

`do` is a dependency-free POSIX-sh redo implementation, vendored so any
fresh checkout (CI especially) can run `redo`-based tests with nothing
installed. It rebuilds everything, serially; for incremental parallel
builds install real redo (`brew install redo`) and use that instead.

- Upstream: <https://github.com/apenwarr/redo> `minimal/do`
- Pinned commit: `b08b5efcef8ab9cf9d532fdd50994e1092144924` (2019-07-24)
- License: public domain (per the file's own header)
- Invoke by path (`~/.local/share/redo/do test` from the repo root) —
  `do` is a shell reserved word, so PATH placement would buy nothing.
- Don't mix implementations in one tree: each treats a target file it
  didn't build as a *source* and silently skips it. After running this
  `do`, run `git clean -fX` (targets are gitignored) before going back
  to real redo, and vice versa.
