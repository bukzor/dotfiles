#!/bin/sh
set -x
brew install volta
volta install node pnpm
node --version
pnpm --version
