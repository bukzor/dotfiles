#!/bin/sh
set -x
brew install volta
volta install node
node --version
# pnpm 11 forbids `pnpm add -g pnpm`, so corepack stays enabled as the entry
# point; the packageManager pin in ~/package.json chooses the version, and
# `corepack use pnpm@latest` moves it. See docs/dev/adr/2026-08-27-000-*.md
corepack enable pnpm
pnpm --version
