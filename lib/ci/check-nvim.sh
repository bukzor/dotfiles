#!/bin/bash
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
# Git-bash /d/a/... paths are not valid to native nvim/plenary on Windows
if command -v cygpath >/dev/null; then ROOT=$(cygpath -m "$ROOT"); fi

echo "==> Neovim version:"
nvim --version

echo "==> Installing plenary if needed..."
PLENARY="${PLENARY:-${RUNNER_TEMP:-${TMPDIR:-/tmp}}/plenary.nvim}"
if [ ! -d "$PLENARY" ]; then
  git clone --depth=1 https://github.com/nvim-lua/plenary.nvim "$PLENARY"
fi

echo "==> Running acceptance tests with plenary..."
# the config locates itself via stdpath("config"): point it at the checkout
export XDG_CONFIG_HOME="$ROOT/.config"
timeout 240 nvim --headless --cmd "set rtp+=$PLENARY" \
  -c "PlenaryBustedDirectory $ROOT/tests/neovim/ {minimal_init='$ROOT/.config/nvim/init.lua'}"

echo "✓ All Neovim tests passed"
