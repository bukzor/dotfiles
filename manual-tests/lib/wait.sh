#!/sourceme/bash
WAIT_LIMIT="${WAIT_LIMIT:-30}"
WAIT_SLEEP="${WAIT_SLEEP:-3}"

wait::for() {
  : retrying for "$WAIT_LIMIT" seconds...
  set +x  # hide the retries, to cut out a bunch of noise
  assertion=( "$@" )
  wait_limit="$WAIT_LIMIT"
  while ! "${assertion[@]}" && ((wait_limit > WAIT_SLEEP)); do
    sleep "$WAIT_SLEEP"
    ((wait_limit -= WAIT_SLEEP))
  done
  if [[ "${DEBUG:-}" ]]; then
    set -x  # show the final try
  fi
  "${assertion[@]}"
}
