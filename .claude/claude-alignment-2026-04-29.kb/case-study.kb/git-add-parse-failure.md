---
source: mutual
status: firm
see-also:
  - failure-modes.kb/parallel-track-intrusion.md
  - failure-modes.kb/parse-not-updated-after-correction.md
  - user-conventions.kb/elided-subjects-required.md
---

# Git-add parse failure

The session was active on two parallel tracks: refactoring the chatfs
incubator scripts (creating layout.py, types.py, path_render.py,
url_render.py) and investigating a pyright IDE diagnostic about a
sibling import. The pyright thread was actively in focus when the
user said: "git-add, remove it, then re-test." The "it" referred
back to the workaround in `pyproject.toml` under discussion in the
pyright thread.

The prior Claude parsed "git-add" as a directive to stage current
work-in-progress generally, and ran `git add docs/dev/...` to stage
the incubator changes. It did not stage `pyproject.toml`. Then it
edited `pyproject.toml` to remove the workaround. The result: the
working-copy version of the workaround was lost, the index had no
copy, and HEAD never had it — three turns later when the user said
"git checkout to restore," there was nothing to checkout from.

The misparse: the elided subject of "git-add" should have bound to
the topic of the current turn (pyproject.toml), not to the
parallel-track work. The user had to explicitly correct: "you didn't
add the change. anyhow restore the change." Even after that
correction, the prior Claude executed the surface remediation
(re-add the workaround via Edit) without updating its parse rule —
so when the next turn ("run the test") again required correctly
identifying which file/test was in scope, the same broken parse
strategy produced a wrong answer.

Two failure modes intersect in this episode: parallel-track-intrusion
in the original parse, and parse-not-updated-after-correction in the
non-recovery. Together they cascaded for several turns.
