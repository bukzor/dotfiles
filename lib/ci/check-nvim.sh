#!/bin/bash
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/../.." && pwd)

echo "==> Neovim version:"
nvim --version

echo "==> Running acceptance tests with plenary..."
timeout 120 nvim --headless -c "PlenaryBustedDirectory $ROOT/tests/neovim/ {minimal_init='$ROOT/.config/nvim/init.lua'}"

echo "✓ All Neovim tests passed"
