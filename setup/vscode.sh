#!/bin/bash
set -euo pipefail
PS4=$'\033[0;36m$ \033[0m'
set -x

onerror() {
  error="$?"
  echo >&2 "ERROR($error)"
  exit "$error"
}
trap onerror ERR

# Microsoft's GPG key and apt repo for VS Code
# Match the path and format that VS Code auto-manages in vscode.sources
KEYRING=/usr/share/keyrings/microsoft.gpg
REPO_SOURCES=/etc/apt/sources.list.d/vscode.sources

# Add Microsoft's signing key
wget -qO- https://packages.microsoft.com/keys/microsoft.asc |
  gpg --dearmor |
  sudo tee "$KEYRING" >/dev/null
sudo chmod 644 "$KEYRING"

# Add the VS Code apt repository (deb822 format)
printf '%s\n' \
  'Types: deb' \
  'URIs: https://packages.microsoft.com/repos/code' \
  'Suites: stable' \
  'Components: main' \
  'Architectures: amd64' \
  "Signed-By: $KEYRING" |
  sudo tee "$REPO_SOURCES" >/dev/null

# Install
sudo apt-get update
sudo apt-get install -y code

# Install vscode-neovim extension
code --install-extension asvetliakov.vscode-neovim
