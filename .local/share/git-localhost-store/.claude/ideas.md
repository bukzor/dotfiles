# Speculative Ideas

Possible future improvements whose trigger conditions may never fire.
Each has a documented recipe so it's quick to execute *if* needed.
Don't pre-do them.

Analogue of `~/.claude/ideas.kb/` but kept as a flat file — these are
small and few.

## Ideas

- **Inline the path encoding; drop the `claude-path` dependency.**
  The encoding is frozen forever regardless — changing it would orphan
  every existing store — so depending on an external, mutable script
  for it is a liability, not flexibility. Counterweight: `claude-path`
  is the canonical slug tool across the toolchain; user's call
  (2026-07-12 review, undecided). Trigger: next substantive edit to
  `bin/git-localhost-store`, or any claude-path/claude-slug behavior
  change. Recipe: `p="${p//-/--}"; p="${p//\//-}"` on the
  `rev-parse --show-toplevel` output; drop the README dependency
  section and TESTING.md's claude-path troubleshooting.

- **Re-run absolute-path rewrite on home-dir migration.**
  Trigger: moving home directory, changing username, or shipping
  these dotfiles to a different user/host (symptom: every home
  submodule fails with `cannot chdir`). Recipe: devlog
  `2026-05-08-000` — same `realpath --no-symlinks` loop with the
  new prefix. Scriptable on demand.
