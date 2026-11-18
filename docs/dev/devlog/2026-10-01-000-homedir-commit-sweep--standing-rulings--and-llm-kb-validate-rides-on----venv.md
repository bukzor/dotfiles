# Devlog: 2026-10-01 — homedir commit sweep: standing rulings, and llm.kb-validate rides on ~/.venv

## Focus

Commit and push everything uncommitted in `~` (`sessions.kb`, `must-read.kb`,
`docs/dev`, then the rest of the tree), sorting the residue into commit,
gitignore, or leave. About 35 commits across the dotfiles repo
(`svelte-crostini`) and the `sessions.kb` submodule.

## Decisions

Rulings below were made by the owner this session; agent-authored calls are
marked as such.

### `settings.json`: the `model` key stays uncommitted

`[!@bukzor]` 2026-10-01: commit everything in `.claude/settings.json` except
`"model"`. `/model` writes that key per session, so committing it would bake in
a transient pick. The file therefore carries a permanent one-line unstaged diff;
it is intended, not a loose end. Stage around it
(`../../.claude/must-read.kb/before/git/staging-part-of-a-file--git-add-p.md`;
at `-U0` the line is its own hunk, but `git apply --cached` reordered a nearby
key, so the exact blob went in via `update-index --cacheinfo`).

### `.gitconfig` `templateDir` stays `~`-relative

`[!@bukzor]` 2026-10-01: revert the absolute-path rewrite. A tool rewrites it;
expect the diff to reappear.

### `feedback/`, `daemon.lock`, `daemon.status.json` are ignored

`[!@bukzor]` 2026-10-01 (feedback): the unsent `SendFeedback` drafts are mostly
over-eager reports the owner does not want kept. `[!DRAFT]` agent-authored
(daemon files): runtime state, same class as the already-ignored `daemon/`.

### `llm-kb` and `llm-claims-kb` do not belong in the home workspace

`[!@bukzor]` 2026-10-01: `llm-kb` as a home workspace member and dependency
"is a bug; undo it". `355cdbe` had committed it (an agent finished a diff
someone else left staged without checking what it did); `2e57761` removes
`llm-kb` and `llm-claims-kb` (`[!DRAFT]` extension: `llm-claims-kb` resolves
`llm-kb` through the agent-skills workspace, so one cannot stay without the
other). `chatfs-cli` stays; the owner did not rule on it, and it has the same
shape (a package from another repo as a home workspace member).

**Consequence found after the ruling.** `~/.venv/bin` leads `PATH` everywhere,
and `llm.kb-validate` and `llm-claims-kb-{dot,flatten,grounding,mentions,
ownership}` resolve from it. That venv was synced while the two were home
dependencies. Nothing is broken yet (`uv lock` does not touch the venv); the
next `uv sync` in `~` uninstalls them. See the todo in `.claude/todo.md`.

### `sessions.kb` is its own environment

`[!@bukzor]` 2026-10-01: commit `sessions.kb/{.envrc,pyproject.toml,uv.lock}` in
that repo (`6634499`). The home workspace never covered it; it is a separate repo
with its own `.venv` that depends on `llm-kb` by relative path.

## Conventions Established

- `git commit-files` refuses a path whose staged content differs from the working
  tree. Where the working tree is a strict superset of the staged version, a
  path-scoped `git add <path>` first is the fix.
- `claude/.gitignore` now ignores everything but itself (symlinks and loose files
  included, not just directories). A new file dropped in `claude/` will not show
  in `git status`; check those directories individually.
- The `sessions.kb` gitlink pointer is meant to be bumped lazily
  (`sessions.kb/CLAUDE.md`); this session bumped it twice. Harmless, not a
  precedent.

## Open Questions

- How should the `llm-kb` and `llm-claims-kb` console scripts reach `PATH` now
  that they are out of the home workspace? Candidate: `uv tool install
  --editable` for each, from `bukzor-agent-skills`. Needs the owner's ruling
  before any `uv sync` in `~`.
- Should `chatfs-cli` be a home workspace member? Same shape as the bug above.

## References

- Commits: `355cdbe` (added), `2e57761` (undone), `6634499` (sessions.kb env)
- `~/.claude/skills/llm-kb/SKILL.md` (`setup:`) on how `llm.kb-validate` lands on `PATH`
- `~/.claude/must-read.kb/before/git/staging-part-of-a-file--git-add-p.md`
