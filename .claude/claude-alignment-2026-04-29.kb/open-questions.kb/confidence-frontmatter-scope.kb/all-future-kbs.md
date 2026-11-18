---
source: agent
status: exploratory
see-also:
  - this-kb-only.md
---

# Candidate: convention forward in all future kbs

Adopt the `source`/`status`/`see-also` frontmatter convention as
default for any kb created from this point forward, by adding the
guidance to the `llm-kb` skill itself. Existing kbs are not
retrofitted; they continue to work without the frontmatter.

The fit is broad: every new kb gets the differentiation built in
from creation, so future Claudes always know how to read confidence
in any kb's content. The cost of adoption is paid once (in the
skill description) rather than per kb.

The cost is two-fold. First, the convention may not fit every
domain — a project incubator's content (design decisions, tool
profiles, etc.) might have different natural categories of
"sourceness" than alignment content. Forcing the same vocabulary
risks awkward fits. Second, the convention's value is highest
when categories are honored consistently; if some kbs adopt and
others ignore (or invent variants), the differentiation is noisy.

A mitigation: scope the convention to "kbs whose content is
claim-shaped" (positions, observations, principles) and explicitly
exempt kbs whose content is reference-shaped (tool listings, API
docs, etc.).
