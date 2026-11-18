--- # workaround: anthropics/claude-code#13003
requires:
- Skill(llm-kb)
---

# Testing notebook

Reusable manual-test recipes plus their last-known-good results. Survives
sessions; lets future agents (and humans) confirm a surface still works without
re-deriving the procedure.

## What belongs here

Each file is **one reusable test recipe**: a procedure that can be re-run
mechanically, plus the date and outcome of its most recent run. Use these to:

- Establish a regression baseline before touching adjacent code.
- Re-verify after a config / plugin / system upgrade.
- Hand off to another agent: "this surface is verified as of YYYY-MM-DD".

## What does NOT belong

- One-off scratch checks with no future re-run value (use chat / scratch dirs).
- Automated test suites — those go in code, not this kb.
- Devlog narrative ("here's what I did this session") — that's an llm-collab
  devlog, not a test recipe.
- Configuration documentation — that goes in code comments or root CLAUDE.md.

## When to add / update

- **Add** when you've manually verified something that future agents will want
  to re-confirm later (post-upgrade, post-config-change, after a fix).
- **Update** the existing file's `last-tested` and `result` when re-running an
  existing recipe — never create a new file per run.
- **Remove** when the surface no longer exists.

## File conventions

- One test per file, kebab-case filename describing what it verifies.
- Frontmatter required (see `testing.jsonschema.yaml`):
  - `last-tested:` ISO date
  - `result:` `pass` | `partial` | `fail`
  - `scope:` short identifier of the area exercised
- Body sections, in order:
  1. One-paragraph description of what the test verifies and why.
  2. **Procedure** — copy-pasteable shell / nvim commands.
  3. **Expected** — what a passing run looks like.
  4. **Last result (YYYY-MM-DD)** — what actually happened on the date in
     frontmatter, plus any caveats.

For partial results, document precisely which step failed and the suspected
cause, so the next runner can target only the broken part.
