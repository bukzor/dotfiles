---
managed-by: Skill(llm-subtask)
---

Scope: Claude configuration (`~/.claude` itself).

- [ ] [todo.kb/2026-07-07-000-lazy-load-system-for-capabilities-disabled-in-context-slimming-pass.md](todo.kb/2026-07-07-000-lazy-load-system-for-capabilities-disabled-in-context-slimming-pass.md)
- [ ] Write the no-inline-code policy into the docs as *default* policy: code
      goes in `{prefix}.py` beside the thing it serves, or `{prefix}.d/` once
      it's more than a file or two — never inline in `python3 -c`, a heredoc,
      or a markdown `verify:`/example block. Rationale to state: inline code
      is unmaintainable, unreviewable, un-runnable by the user, and invisible
      to pyright/black/pytest.
  - [ ] Decide the home: `CLAUDE.md` "Values" (it's a how-to-work rule) vs
        `must-read.kb/before/running-ANY-Bash-commands.md` (inline code
        arrives through Bash) vs both — a one-line Values entry pointing at
        the must-read is probably right
  - Prompted 2026-08-10 by the bukzor-packaging ledger, where three claim
    files had grown `verify:` blocks holding a 15-line python one-liner each;
    they collapsed into one `seams.py` with flags.
- [ ] `sessions.kb`'s per-host layout hides its entries from validation:
      `llm.kb-validate ~/.claude/sessions.kb/` reports **1 file, 0 errors**
      because the walker only descends into `*.kb/` directories and
      `penguin/` is not one. Pointed at `penguin/` explicitly it finds 44.
      A green check on the collection therefore means nothing. Fix is
      either renaming the per-host dirs to `penguin.kb/` or teaching the
      walker to recurse plain subdirectories of a `.kb/` — decide which,
      then do it. Found 2026-08-10; the latent bug it was hiding
      (`sessions.jsonschema.yaml` declaring the stock dialect while using
      `type: instant`) had been unnoticed since 2026-07-10.
- [x] [todo.kb/2026-06-03-000-migrate-topic-reference-docs-from-must-readkb-to-referencekb.md](todo.kb/2026-06-03-000-migrate-topic-reference-docs-from-must-readkb-to-referencekb.md)

## Later

We haven't (yet) decided where to place these in the task queue.
Please read and consider slotting them.

- (none)
