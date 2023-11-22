#!/sourceme/bash

base::strict-mode() {
  set -eEuo pipefail
  trap 'banner FAIL' ERR
  if [[ "${DEBUG:-}" ]]; then
    set -x
  fi
}

# remove noisy bits from the xtrace log
base::quiet() {  # work around treesitter bug: }
  { set +x; } 2> /dev/null  # hide the retries, to cut out a bunch of noise
  "$@"
  if [[ "${DEBUG:-}" ]]; then
    set -x  # show the final try
  fi
}


### a few universally-valid variables:

# the directory containing the top-level script
NOW="$(date -Iseconds)"
USER="$(whoami)"

# debug exported vars:
: "$HERE" "$NOW"
