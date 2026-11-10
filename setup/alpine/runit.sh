#!/bin/bash
# Install runit and point /etc/service at this host's service tree,
# ~/.config/runit/<hostname>/. Run inside the distro once dotfiles are checked
# out. runsvdir itself is started by /etc/wsl.conf's [boot] command.
set -euo pipefail
shopt -s failglob
export DEBUG="${DEBUG:-0}"

onerror() {
  error="$?"
  echo >&2 "ERROR($error)"
  exit "$error"
}
trap onerror ERR

if (( DEBUG > 0 )); then
  set -x
fi

sudo apk add runit
"$HOME/.config/runit/install"
