#!/sourceme/bash
if [[ "${DEBUG:-}" ]]; then
  set -x
fi

base::strict-mode() {
  set -eEuo pipefail
}


### set some broadly-valid variables:

# the directory containing the top-level script
NOW="$(date -Iseconds)"
USER="$(whoami)"

# debug exported vars:
: "$HERE" "$NOW"