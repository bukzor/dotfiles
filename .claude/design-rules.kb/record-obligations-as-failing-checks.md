# Record obligations as failing checks

Work you have decided to do, and are not doing now, goes into something that
fails until it is done -- a check exiting nonzero, a skipped test, a lint. Not a
comment, not a doc sentence, not a note in the record.

Diagnostic: a `TODO`, or a document stating that X should happen, with nothing
that gets louder while X hasn't happened.

Why prose fails: maintenance pressure is paid per *encounter*, and prose is
encountered only by someone already reading that file for another reason. A
failing check is encountered by everyone, every run. Verdicts are cheap to
produce and actions are expensive, so a system that records obligations in prose
accumulates verdicts and performs none of them.

Corollary for checks that measure state: key the verdict on the recorded
decision, and measure the current state anyway. A check that trusts the record
will report that a decision was carried out because the record says it was.
