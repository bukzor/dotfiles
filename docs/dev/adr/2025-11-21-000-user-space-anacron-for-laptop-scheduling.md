# User-Space Anacron for Laptop Scheduling

**Date:** 2025-11-21
**Status:** Accepted
**Deciders:** bukzor, Claude

## Context

Laptop-based scheduled tasks face a fundamental problem: standard cron jobs only run when scheduled, missing execution windows when the system is asleep or powered off. A daily 3:30 AM `pnpm -g update` job was consistently missed because the laptop was typically sleeping at that time.

**Requirements:**
- Execute daily maintenance tasks even when laptop sleeps through scheduled time
- Maintain portability across embedded systems and containers (avoid systemd dependency)
- Respect XDG Base Directory specification
- Allow cron configuration to be version-controlled

**Constraints:**
- Laptop frequently asleep during traditional maintenance windows (1-6 AM)
- May run on battery power when waking
- Need to work in Debian/ChromeOS Crostini environment

## Decision

Implement user-space anacron triggered by cron, using XDG-compliant paths:

**Structure:**
- **Config:** `~/.config/anacron/anacrontab` - Job definitions
- **State:** `~/.local/state/anacron/` - Timestamp files tracking last execution
- **Crontab:** `~/.config/cron/crontab` - Version-controlled crontab source

**Mechanism:**
1. Cron runs anacron `@hourly` and `@reboot`
2. Anacron checks if ≥24 hours elapsed since last run
3. If overdue, waits 5 minutes (delay), then executes job
4. Timestamps persist in `~/.local/state/anacron/pnpm-update`

**Self-healing:**
- Crontab auto-reloads from VCS hourly via `crontab ~/.config/cron/crontab`

## Alternatives Considered

### 1. Systemd Timers with Persistent=true
**Pros:** Modern, better integration with system power management, built-in logging
**Cons:** Not portable to containers/embedded, systemd-specific, more complex setup
**Rejected because:** Violates portability requirement

### 2. fcron
**Pros:** Native catch-up capability, cron-like syntax
**Cons:** Less common, additional package, not standard on most systems
**Rejected because:** Adds dependency for functionality anacron already provides

### 3. Custom Catch-Up Script
**Pros:** Maximum flexibility, no additional dependencies
**Cons:** Reinventing existing solution, more code to maintain
**Rejected because:** Anacron is purpose-built for this problem

### 4. Keep System Anacron (/etc/anacrontab)
**Pros:** Already installed, well-integrated
**Cons:** Requires root, harder to version-control, doesn't respect XDG
**Rejected because:** Want user-space control and XDG compliance

## Consequences

### Positive
- **Reliable execution:** Jobs run within hours of waking, even after multi-day sleep
- **Portable:** Works anywhere with cron and anacron (containers, embedded, WSL)
- **Version-controlled:** All configuration in git-tracked files
- **XDG-compliant:** Clean separation of config vs state
- **Low complexity:** Standard tools, minimal moving parts

### Negative
- **Requires anacron package:** Must be installed (`apt install anacron`)
- **Loss of precise timing:** Daily job runs "sometime after wake," not at specific time
- **Hourly cron overhead:** Anacron checks every hour (minimal, but non-zero)
- **Manual path specification:** Must use `/usr/sbin/anacron` in crontab (not in PATH)

### Neutral
- **State directory needs .gitignore:** Added to ensure directory exists in VCS without tracking timestamps
- **Auto-reload adds complexity:** Crontab modifies itself hourly (could be surprising)

## Implementation Notes

Tested on 2025-11-21 13:57 - anacron successfully executed missed job and created timestamp file `~/.local/state/anacron/pnpm-update` containing `20251121`.

Full paths required in crontab due to minimal PATH in cron environment.

## References

- Anacron man pages: `anacron(8)`, `anacrontab(5)`
- XDG Base Directory Specification: https://specifications.freedesktop.org/basedir-spec/
- Initial discussion focused on systemd vs portability tradeoffs
