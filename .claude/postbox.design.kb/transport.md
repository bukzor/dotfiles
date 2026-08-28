---
why:
  - ./convention.md
---

# Decision point: message transport

**Resolution: files as messages, pull delivery** (2026-08-28, owner-ratified
direction; details in `convention.md`).

The deciding lens: the built-in tools' problems are all consequences of one
choice — *push-into-context* delivery. Inane sends are cheap because the
sender needs no consent to occupy the recipient's context; distraction is
guaranteed because delivery is an interrupt; rewind can't excise a message
because it was never a discrete skippable event. No permission setting gates
*receiving*, so the push tools cannot be configured into acceptability —
inverting to pull dissolves all three at once.

Candidates, one file each in `transport.kb/` — declined entries carry the
veto and grounds and are load-bearing.
