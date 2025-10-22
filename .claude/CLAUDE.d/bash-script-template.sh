#!/bin/bash
set -euo pipefail

onerror() {
  error="$?"
  echo >&2 "ERROR($error)"
  exit "$error"
}
trap onerror ERR

# Constants and functions here

if (( ${DEBUG:-0} > 0 )); then
  set -x
fi

# Main logic here
