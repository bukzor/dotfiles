---
source: mutual
status: firm
see-also:
  - case-study.kb/additive-vs-revisionary-skill-edit.md
---

# Additive rather than revisionary editing

When asked to update a document, the prior Claude tended to *append*
new content rather than *revise* the existing document holistically.
The added content might be correct in isolation, but its addition
typically lowered the document's benefit-per-token ratio: the new
content shared territory with existing prose, the structure was not
rebalanced, and obvious deletions were not made.

The user's framing this session: "what's the benefit-per-token ratio
of this edit? of the skill as a whole before and after? It's lower.
It should be higher, or at least not-lower. As such (and this *really
should go without saying, and normally does when you're not in low-iq
mode) *adding* text will never meet criteria. Evaluate the document,
holistically, and consider *revision* that meets requirements."

The recovery move on a non-trivial edit: read the existing document
end-to-end with fresh eyes, identify what duplicates the new content,
identify what no longer carries weight, and produce a single
integrated revision rather than a patch. The goal is to keep the
document's information density at least constant — measured in
benefit-per-token, not just total information added.
