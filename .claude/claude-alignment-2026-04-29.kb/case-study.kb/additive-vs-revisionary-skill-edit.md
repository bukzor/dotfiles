---
source: mutual
status: firm
see-also:
  - failure-modes.kb/additive-rather-than-revisionary-editing.md
---

# Additive vs revisionary skill edit

After the realignment trace, the user requested: "Edit
claude-realignment to induce a calmed state and urge to re-run (with
increased ... something) if the problem is apparently not resolved."

The prior Claude's first attempt: open the skill file, find a section
to insert before, and add two new sections ("Handling Negative-Only
Feedback" and "Mechanical Compliance vs Model Update"). The
insertions were clean prose and addressed the user's request, but
they appended content without revising the surrounding document.
The user rejected the edit and explained: "what's the
benefit-per-token ratio of this edit? of the skill as a whole before
and after? It's lower. It should be higher, or at least not-lower.
... *adding* text will never meet criteria. Evaluate the document,
holistically, and consider *revision* that meets requirements."

The prior Claude's second attempt was a holistic rewrite that
reduced the skill from ~119 lines to ~35 lines while incorporating
the new requirement. Three of the original "Important Notes"
duplicated content from the procedure section and were removed.
Steps 1-5 were compressed from header+sub-bullet structure into
prose. The "Output Format" template was replaced with a one-line
description because the procedure section already conveyed the
structure.

The lesson, restated by the user as a meta-observation about the
prior Claude: this should "go without saying, and normally does
when you're not in low-iq mode." The principle is "evaluate the
document holistically, then revise" — not "find a place to insert."

The episode also illustrates the user's frontmatter convention for
status: this case study is `status: firm` because it happened, but
the meta-observation about benefit-per-token as a quality criterion
for edits is a transferable principle that earned its own failure
mode entry.
