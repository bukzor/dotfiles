# Deterministic by construction

Output is a pure function of durable input. No hysteresis (memory of prior
runs), no oracles (an authority consulted at decision time).

Diagnostic: the design needs state carried between runs, or "ask X" appears in
the data flow. Redesign the identifier or algorithm instead.

Determinism is not stability: emit-order numbering is deterministic yet
renumbers everything when input grows. Where references must survive growth,
pick append-stable handles — new items sort strictly after all existing ones
(e.g. chronological rank), so existing handles never shift.
