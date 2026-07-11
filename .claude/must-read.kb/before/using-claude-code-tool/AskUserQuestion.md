# AskUserQuestion vs. worksheet files

AskUserQuestion forces a single-select/multi-select from 2-4 fixed
options, one screen at a time, with no persistent, re-editable record.
That's the right shape for one quick, context-free fork with no prose
needed ("pick a library") -- don't manufacture a worksheet for that.

It's the wrong shape when any of these hold:

- there are 2+ related decisions to make in one pass
- an answer wants prose, not a label (a number, a rationale, a
  fill-in-the-blank) -- options force-fit prose into a menu
- the user may want to revise an earlier answer after reading a later
  question -- AskUserQuestion answers aren't editable once given
- the questions have real interdependencies worth seeing side-by-side
  rather than one modal screen at a time

In those cases, write a markdown worksheet instead: one file, one section
per decision with the relevant context and candidate positions inline, a
place to answer (checkbox list, blank line, or both). Hand it to the user
to copy into their editor, fill out, and hand back. Cheaper for the user
to mutate, diff, and partially answer than a modal question flow, and it
survives being revisited across a session boundary.
