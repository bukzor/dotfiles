#!/bin/bash
set -euo pipefail

echo "==> Neovim version:"
nvim --version

echo "==> Running acceptance tests with plenary..."
nvim --headless -c "PlenaryBustedDirectory $HOME/tests/neovim/ {minimal_init='$HOME/.config/nvim/init.lua'}"

echo "✓ All Neovim tests passed"
