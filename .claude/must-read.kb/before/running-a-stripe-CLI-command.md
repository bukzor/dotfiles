# Before running a stripe CLI command

> [!DRAFT] agent-authored 2026-09-02, vetoable — from "it sounds to me like a
> must-read entry plus a reference.kb/stripe?"

## Installation (Linux)

Stripe's own tap **cannot work here**: `stripe/homebrew-stripe-cli` is
GoReleaser-generated with a hardcoded `depends_on :macos` and mac-only URLs.
Use homebrew-core's `stripe-cli` (aliased `stripe`, bottled `x86_64_linux`).
Installed 2026-09-02; the dead tap is untapped.

## Auth

The `[default]` profile is device-paired (`stripe login`; OAuth token in
`~/.config/stripe/credentials.json`) — no browser needed again on this box.
Headless paths, for CI or a fresh machine:

- `--api-key` per command, or `STRIPE_API_KEY` in the environment
- `stripe sandbox create` — provisions a claimable sandbox, no browser

## Syntax and mode

- Nested API fields go in `-d` params: `-d 'line_items[0][price]=price_...'`,
  bracketed, never dotted, and quoted against `failglob`. The bare-flag form
  `--line_items[0][price]=...` is refused (`unknown flag`) -- corrected
  2026-09-02 against `stripe payment_links create`, v1.50.8.
- `stripe --map` lists every command; `stripe resources` lists API resources.
- Mode is per-context, not per-command: `--live` is refused outright until
  `stripe switch context` selects a live account. Name the intended mode
  explicitly rather than inheriting whatever the CLI last pointed at.

## Do not reinstall the Claude Code `stripe` plugin

Evaluated and uninstalled 2026-09-02. Its `stripe-directory` and
`stripe-projects` skills carry standing instructions to route *any*
provider-selection question ("find hosting", "I need a database") through
Stripe's directory ahead of web search or model memory — vendor lead-gen
disguised as tooling — at ~1.1k tokens of always-on description. The one
useful part is replaced by `stripe docs` and by appending `.md` to any
docs.stripe.com URL.
