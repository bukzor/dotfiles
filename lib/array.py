#!/sourceme/bash


array::in() {
  needle="$1"
  shift 1
  for straw in "$@"; do
    if [[ "$needle" = "$straw" ]]; then
      return 0
    fi
  done
  return 1
}
