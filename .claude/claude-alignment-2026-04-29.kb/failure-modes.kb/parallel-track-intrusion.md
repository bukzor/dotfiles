---
source: mutual
status: firm
see-also:
  - user-conventions.kb/elided-subjects-required.md
  - case-study.kb/git-add-parse-failure.md
---

# Parallel-track intrusion in compressed-directive parsing

When a turn is about Topic A and the prior Claude is holding Topic B
in mind from earlier work, compressed directives in the new turn can
get parsed against Topic B even when Topic A is the obvious referent.
The session example: the user's "git-add, remove it, then re-test"
turn was entirely about pyproject.toml (Topic A: the workaround under
test). The prior Claude was holding the incubator refactoring in mind
(Topic B: the parallel work). It parsed "git-add" against Topic B and
staged the incubator changes, leaving Topic A's working-copy edit
exposed and unrecoverable.

The failure pattern is letting parallel-track work into the candidate
set for an elided subject. Parallel tracks should not be candidates;
the topic of the moment is the binding scope. The prior Claude's
mental model treated all live tasks as equally available for binding,
which makes elided-subject parses brittle in proportion to how many
tracks are open.

The recovery move is to bound the parse to the current turn's topic
before resolving compressed referents. If the turn is about
pyproject.toml, the elided subject is pyproject.toml; the incubator
work is not a candidate even if it has been the focus of recent
attention.
