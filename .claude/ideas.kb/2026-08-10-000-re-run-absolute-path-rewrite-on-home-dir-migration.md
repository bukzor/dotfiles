---
managed-by: Skill(llm-subtask)
status: deferred
cost-benefit-sweh:
  timebox:
    "@value": 0.5 # SWEh worth exploring before promoting or abandoning
  benefit-2w:
    "@value": 0.0 # nothing until the trigger fires; then it unblocks every repo
---

# Re-run absolute-path rewrite on home-dir migration

## The Idea

Every relocated repo's `.git` is an absolute symlink into
`~/.local/state/git-localhost-store/repos/`, and the store name encodes
the absolute workdir path. Move the home directory, change the username,
or hand these dotfiles to another user, and all of it dangles at once.

**Trigger:** the symptom is every home submodule failing with
`cannot chdir`. **Recipe:** the `realpath --no-symlinks` loop from devlog
`2026-05-08-000-migrate-home-to-symlink-layout.md`, now in
`bukzor-tools/packages/git-localhost-store/docs/dev/devlog/`, run with the
new prefix. Scriptable on demand; not worth pre-writing.

## Open Questions / Unknowns

Whether the rewrite belongs in the tool itself as a `--rehome` subcommand
rather than a devlog recipe. Against: it runs once per lifetime of a
machine, and a wrong one moves every repository on it.

## Lifecycle

**Status:** Exploring. Carried over 2026-08-10 from the tool's own
`ideas.md` when it was packaged into `bukzor-tools`; the work is
dotfiles-shaped, not package-shaped, so it lives here.
