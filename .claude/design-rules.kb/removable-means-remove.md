# Removable means remove

If a subsystem, format, flag, or abstraction can be removed without harming
any use case, removing it is mandatory, not optional.

Diagnostic: a component justified by "might help later" or "already written" —
neither is a use case.

Two refinements, both learned by getting them wrong:

**The win scales with encounters, not with bytes.** Maintenance is charged when
code is scanned or amended, so removing what nothing sweeps saves nothing. Order
removals by namespace heat: a dead one-liner in the directory that answers tab
completion costs more than a thousand dead files under keys nobody lists.

**"Harms no use case" means no *existing* thing does it better.** The benefit of
keeping is marginal -- value over the best available alternative -- so a subsumed
component goes free at any usage count. But "this should be a flag" claims
subsumption by something nobody built, and removing on that argument removes
capability. The replacement must exist, and must win on every axis some caller
uses, not on net.

**Corollary:** record the removal as a failing check, not as a note. A verdict you
reached and did not carry out is the normal outcome otherwise.
