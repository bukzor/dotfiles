Three upstream families: `interactive`/`print-mode` (v2.1.203, pre
cross-session support) and `cross-session` (v2.1.224 on), which has kept
growing -- `notify_when_idle` (v2.1.237), the subagent-address note
(v2.1.248), and now the delivery-vs-processed distinction (v2.1.273).

v2.1.273 added: "A successful send means the message reached that session,
not that its Claude acted on it" -- a differing permission mode may hold a
message for approval or refuse it outright, a delivery notice says which on
this machine, and a Remote Control/cloud/Desktop session reports nothing
back at all. Folded into `description.md`: this changes what a caller
should conclude from a successful send, which the stub didn't previously
cover and nothing in must-read.kb states either.
