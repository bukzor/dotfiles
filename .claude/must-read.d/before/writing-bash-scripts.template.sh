#!/bin/bash
set -euo pipefail
export DEBUG="${DEBUG:-0}"

onerror() {
  error="$?"
  echo >&2 "ERROR($error)"
  exit "$error"
}
trap onerror ERR

# Constants and functions here

if (( DEBUG > 0 )); then
  set -x
fi

# Main logic here
