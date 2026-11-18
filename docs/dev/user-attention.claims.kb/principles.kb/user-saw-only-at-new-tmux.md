---
label: USER_SAW_NEW_TMUX_ONLY
standing: user
authority: user correction, 2026-09-10, cron-alerting investigation
---

# The User Saw the Warning Only at a Brand-New tmux Session

> [!@bukzor] 17b60946-a452-4069-838b-2b35bf98cebb#L264
> cron-status.sh should have been warning at every shell start
>
> I only saw it when starting a brand-new tmux session, not at any
> other "shell start".

This corrected an agent claim stated as fact without checking it
(`GROUND_TRUTH_OVER_CODE_READING` in this same theory is the
methodological lesson that failure names). The correction is the
starting fact this whole ledger is built from: not "the trigger fires
too rarely" as an inference from reading the code, but the user's own
report of what they actually saw, which the subsequent measurement
(`LONG_LIVED_PANES`) then explained rather than discovered.
