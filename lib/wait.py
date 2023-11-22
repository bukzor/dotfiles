#!/sourceme/bash
WAIT_LIMIT="${WAIT_LIMIT:-30}"
WAIT_SLEEP="${WAIT_SLEEP:-3}"

_wait_loop() {
  assertion=( "$@" )
  wait_limit="$WAIT_LIMIT"
  while ! "${assertion[@]}" && ((wait_limit > WAIT_SLEEP)); do
    sleep "$WAIT_SLEEP"
    ((wait_limit -= WAIT_SLEEP))
  done
}

wait::for() {
  assertion=( "$@" )
  : retrying for "$WAIT_LIMIT" seconds...
  base::quiet _wait_loop "$@"
  : show the final try:
  "${assertion[@]}"
}
