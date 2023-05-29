#!/bin/sh
set -x
curl https://get.volta.sh | bash -x
source ~/.profile
volta install node pnpm
node --version
pnpm --version
