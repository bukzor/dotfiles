#!/sourceme/bash

wait::for() {
  assertion=( "$@" )
  time_limit=30
  while ! "${assertion[@]}" && ((time_limit > 0)); do
    sleep 1
    ((time_limit -= 1))
  done
}
