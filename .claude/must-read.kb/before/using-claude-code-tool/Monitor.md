# Monitor: writing watch scripts that actually notify

The tool schema is slimmed at the proxy (`~/.claude/tool-description-patches.d/`);
this file carries the guidance that was stripped. Read fully before arming a
monitor.

## Picking the mechanism

Count the notifications you need:

- **One** ("tell me when the build finishes") -- NOT Monitor: use Bash
  `run_in_background` with a command that exits when the condition is true,
  e.g. `until grep -q "Ready in" dev.log; do sleep 0.5; done`. One completion
  notification when it exits.
- **One per occurrence, indefinitely** ("every ERROR line") -- Monitor with an
  unbounded command (`tail -f`, `inotifywait -m`, `while true`).
- **One per occurrence, until a known end** ("each CI step, stop at run end")
  -- Monitor with a command that emits lines then exits.

Never use an unbounded command for a single notification: `tail -f` /
`inotifywait -m` / `while true` never exit on their own, so the monitor stays
armed until timeout even after the event fired. `tail -f log | grep -m 1 ...`
does NOT fix this -- if the log goes quiet after the match, tail never gets
SIGPIPE and the pipeline hangs anyway.

## Script quality

- Every pipe stage must flush per line or matches sit in a buffer unseen:
  `grep --line-buffered`, `awk` with `fflush()`. `head` cannot flush at all --
  `| head -N` delivers nothing until N matches accumulate, then ends the stream.
- In poll loops, tolerate transient failures (`curl ... || true`) -- one failed
  request shouldn't kill the monitor.
- Poll intervals: 30s+ for remote APIs (rate limits), 0.5-1s for local checks.
- Write a specific `description` -- it appears in every notification ("errors
  in deploy.log", not "watching logs").
- Only stdout is the event stream; stderr goes to the output file without
  notifying. For a command you run directly, merge with `2>&1` so its failures
  reach your filter.

## Coverage -- silence is not success

The filter must match every terminal state, not just the happy path. A monitor
that greps only the success marker stays silent through a crashloop, a hang, or
an unexpected exit -- and silence looks identical to "still running". Before
arming, ask: if this process crashed right now, would my filter emit anything?

    # Wrong -- silent on crash, hang, or any non-success exit
    tail -f run.log | grep --line-buffered "elapsed_steps="

    # Right -- one alternation covering progress + failure signatures
    tail -f run.log | grep -E --line-buffered "elapsed_steps=|Traceback|Error|FAILED|assert|Killed|OOM"

For poll loops on job state, emit on every terminal status
(`succeeded|failed|cancelled|timeout`). If you can't enumerate the failure
signatures, broaden the alternation -- extra noise beats missing a crashloop.

## Output volume

Every stdout line is a conversation message. Filter to exactly the success and
failure signals you'd act on -- never pipe raw logs. Over-producing monitors
are auto-stopped; restart with a tighter filter. Lines within 200ms batch into
one notification, so multiline output from one event groups naturally.

## Lifecycle

Runs in the same shell environment as Bash. Exit ends the watch (exit code
reported); timeout kills it (default 300s, max 1h). `persistent: true` runs
until TaskStop or session end -- session-length watches only (PR monitoring,
log tails). NB: TaskStop is denied in user settings; without it a persistent
monitor cannot be cancelled early.

## ws source

`ws: {url: ...}` opens a WebSocket; each incoming text frame is one event (no
shell, no polling). Binary frames surface as placeholders; close ends the
watch. Prefer this over `command: 'websocat ...'` unless frames need shell
transformation. Same rate limiting as bash -- subscribe to a filtered feed
where one exists.
