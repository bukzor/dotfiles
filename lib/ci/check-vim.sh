#!/bin/bash
set -euo pipefail

echo "==> Vim version:"
vim --version | head -n 2

echo "==> Installing themis if needed..."
if [ ! -d "$HOME/.vim/plugged/vim-themis" ]; then
  git clone --depth=1 https://github.com/thinca/vim-themis.git "$HOME/.vim/plugged/vim-themis"
fi

echo "==> Running acceptance tests with themis..."
"$HOME/.vim/plugged/vim-themis/bin/themis" "$HOME/tests/vim/"

echo "✓ All Vim tests passed"
