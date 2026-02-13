#!/bin/sh
set -x
brew install volta
volta install node
node --version
corepack enable pnpm
pnpm add -g pnpm
corepack disable pnpm
pnpm --version
