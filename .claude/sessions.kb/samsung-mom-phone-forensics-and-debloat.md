---
cwd: /home/bukzor/claude/bukzor.samsung-debloat
session:
  uuid: 24ad6496-1df7-4921-a76d-7aecc7052c12
  started: 2026-05-26T17:40:00-05:00
  ended: 2026-05-27T19:56:00-05:00
---
# Samsung Mom-Phone Forensics and Debloat

Mother's Galaxy S24+ (SM-S926U, hardware #2) arrived overrun with
zero-interaction adware popups. This session did read-only forensics before a
planned factory wipe + de-Samsung. Established: active malware already removed
by her uninstall spree; the Downloads dropper is Tencent 应用宝 (a secondary
payload); logcat reaches 2026-05-21 (crash buffer only — no install events).
Install-source analysis shows all 48 surviving apps are store-installed, so
patient zero was uninstalled and is purged from the package db — the passive
capture is exhausted for naming it, though other device sources are not.
TeamViewer is the user's own (intentional) support tool, documented in the repo.
A reusable analyzer (`scripts/forensic_report.py`) and a sources/analyses task-kb
framework now drive the remaining work. Full live state, findings, and gotchas
are in the project task kb.

**2026-05-27 (session 2): account-side My Activity cracked it open.** Two
captures (live scrape + Takeout export, parsed by new
`scripts/myactivity_takeout.py`) show the adware was an **~80-package PPI bundle,
Play-Store-installed**, that **detonated 2026-05-18** as a single-day
store-deeplink burst (onset 07:09:27; gone from device by 05-25). The
seed/controller is **off-Play** — the 04:53→07:09:27 trigger window is silent in
every retained source — leading candidate **`com.open.web.ai.browser`** ("AI
Browser": sideloaded, Samsung-Device-Care-flagged, ties to a Chrome Yahoo
search-hijack), but **undated/unconfirmed**. The Tencent APK is downstream, not
the enabler. New: `timeline.kb/` (full chain) and a **data-preservation wipe
gate** in `mission.md`. README is current — read it first.

Task kb (read this first): /home/bukzor/claude/bukzor.samsung-debloat/.claude/current-task.kb/

## Open work

- [ ] **Reconnect ADB** (wireless; wake+unlock, mDNS auto-connects —
  `environment.kb/adb-reconnect-and-durable-endpoint.md`).
- [ ] **Date/confirm the seed** (`com.open.web.ai.browser`): DownloadManager db
  (its APK fetch time + source URL), Samsung Internet history (the silent-window
  browser action), residual overlay/install-unknown appop holders. Needs reconnect.
- [ ] **Account-side**: Play **Protect** history (named+dated removals — may
  name/date the seed), Play **Library** (install source).
- [ ] **Card-fraud thread** — Google Pay transactions/Orders/Subscriptions are
  **in hand** in the Takeout, **unanalyzed**; mine for fraud/rogue subscriptions,
  plus Google **Security Checkup** (`open-questions.kb/card-fraud-link.md`).
- [ ] **Data-preservation gate → wipe + de-Samsung**: back up ALL wanted content
  (photos, messages, contacts, app data…), user confirms nothing needed, THEN
  wipe; reuse `scripts/master-debloat.adb.sh` as a guide (verify pkg names vs
  Android 16 / One UI 8); reinstall TeamViewer Host.
- [ ] Prevention: Auto Blocker on, "install unknown apps" OFF for all apps, Play
  Protect on.

> **Heads-up:** a concurrent session left **uncommitted** work in this repo
> (`android-apps.kb/`, `scripts/{android_apps_kb,package_dump,myactivity_scrape}.py`,
> several `*.jq`) — not committed by session 2; reconcile before relying on it.

## Tooling follow-ups (llm-kb)

- `llm.kb-validate` has **no `$ref` support**: a nested sub-kb resolves its
  schema as `<parent>/<sub>.jsonschema.yaml`, so each sub-collection needs its
  own schema file. Convention adopted this session: **symlink** the sub schema to
  the parent's when they match exactly (all of `forensic-sources.kb/*` and
  `forensic-analyses.kb/*` do); on a *partial* match, copy-paste instead and
  leave a `#TODO` pointing at this entry. Add `$ref` support to retire the
  symlinks/copies.
