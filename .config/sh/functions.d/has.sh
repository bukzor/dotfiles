# check if a command exists
has() {
  command -v "$@" > /dev/null
}
