---
label: DEV_CLAIMS
standing: agent
ontology:
  - ledger
stale-when: a claim here that binds a single project rather than this operator's practice across projects
---

# Claims about working here

`claims.kb/` is the ledger for commitments that outlive one session and
one project — what is true about how work gets done under `~/.claude`,
kept in `Skill(llm-claims-kb)` form so each commitment carries its own
standing and its own reasons.

A theory belongs here when its claims would otherwise be re-derived from
scratch every few weeks, and when getting them wrong costs real money or
real time. A commitment that binds one repository belongs in that
repository.

Read the theory's defining claim first; it carries the ontology, the
priors, and the roll-up. The claims under it are one file apiece.

Scans, from this directory:

```sh
grep -rH '^standing:' claims.kb/          # every claim and its judge
grep -rl 'standing: agent' claims.kb/     # the review queue
grep -rl 'standing: open' claims.kb/      # what wants an answer
grep -rl 'verdict:' claims.kb/            # what is out of force
```
