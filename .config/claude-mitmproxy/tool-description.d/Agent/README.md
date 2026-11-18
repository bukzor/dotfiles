Three live wordings: a ~6.7k long form (usage notes, prompt-writing guide,
three worked examples) and two ~1.6k short forms differing on fork support
and the background-default note. The long form's prompt-writing guidance
("brief like a smart colleague", "never delegate understanding",
lookups-vs-investigations, trust-but-verify) moved to
must-read.kb/when/spawning-a-sub-agent--delegating-a-task.md, which the
stub requires before spawning; the examples are dropped. The stub keeps
the mechanics all variants share plus the don't-fabricate-results rule,
and mentions fork with a "where supported" hedge since one live wording
lacks it.

2.1.257 reworded the no-fork long form's "When not to use" bullet: `grep`
via the Bash tool became "the Grep tool" (long-form-no-fork-2.1.257) --
a dedicated Grep tool now exists upstream where before there wasn't one;
nothing in the stub or must-read.kb names the old wording, so nothing to
fold in.

2.1.309-2.1.323 (2026-11-13 triage): every wording now carries a "When to
use" essay leaning against spawning ("when in doubt, don't spawn"; a fresh
agent's costs; don't delegate a check you could run inline). Not folded: the
stub and `must-read.kb/when/spawning-a-sub-agent--delegating-a-task.md` are
the operator's delegation policy, and this text pulls the other way -- a
ruling for the operator, not a drift fix. The mechanics all three wordings
share (fork, SendMessage, isolation) are unchanged. Opus 2.1.323 says agent
types are listed "in messages from the system" where the stub says
`<system-reminder>`; same list, same place.
