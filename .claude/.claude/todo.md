---
managed-by: Skill(llm-subtask)
---

Scope: Claude configuration (`~/.claude` itself).

- [ ] [todo.kb/2026-07-07-000-lazy-load-system-for-capabilities-disabled-in-context-slimming-pass.md](todo.kb/2026-07-07-000-lazy-load-system-for-capabilities-disabled-in-context-slimming-pass.md)
- [ ] Adjudicate 14 sessions.kb entries the schema rejects, uncovered by
      the `penguin/` -> `penguin.kb/` rename (2026-08-10). The collection
      had been invisible to `llm.kb-validate` since the per-host layout
      landed, so a month of drift accumulated unseen. Three groups, and
      in most of them **the corpus looks right and the schema looks
      wrong**:
  - [ ] `cost-benefit-sweh` on 8 entries. Eight independent sessions
        added SWEh ratings to session entries; the schema never learned
        the field and `additionalProperties: false` rejects them. Almost
        certainly bless it — `$ref` llm-subtask's `$defs/sweh-value` so
        `wsjf-rank` can read sessions the same way it reads todos.
  - [ ] Relationship fields, organically grown, three spellings for
        arguably two ideas: `parent` (2), `prior-sessions` (2),
        `spawned` (1). Pick a vocabulary, migrate, then schematize.
  - [ ] Two `session.started` values are bare dates, not instants, and
        one entry (`move-skill-triggers-to-must-read-kb.md`) has no
        `session` block at all. Decide whether `started` should accept
        `date` for entries that only ever knew the day.
- [~] "No inline code in docs" as default policy — code goes in
      `{prefix}.py`, or `{prefix}.d/` past a file or two. It was folk
      knowledge re-derived per kb; `llm-claims-kb`'s maintenance guide
      argued it well ("a `verify:` is a command, never a program") but only
      for itself. Raised 2026-08-10 by three bukzor-packaging claim files
      whose `verify:` blocks each held a 15-line python one-liner; they
      collapsed into one `seams.py` with flags.
  - [x] `must-read.kb/before/editing-documentation.md` — stated as default
        policy, with the reason and the boundary (fragments and transcripts
        stay welcome, implementations don't)
  - [x] `before/writing-python-code.md` — one sentence, pointing at the above
  - [ ] the claims-kb skill's `verify:` guidance — left for whoever owns the
        `llm-claim-ledger` → `llm-claims` rename, so an outside edit doesn't
        collide with it
- [x] [todo.kb/2026-06-03-000-migrate-topic-reference-docs-from-must-readkb-to-referencekb.md](todo.kb/2026-06-03-000-migrate-topic-reference-docs-from-must-readkb-to-referencekb.md)

## Later

We haven't (yet) decided where to place these in the task queue.
Please read and consider slotting them.

- (none)
