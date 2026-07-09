# shellcheck shell=sh
# Shared by *_test.sh and *_check.sh -- must run under dash, busybox ash,
# bash, zsh --emulate sh.
# Runners export TEST_SH (the interpreter command) so tests can re-invoke it.
fails=0

assert_eq() { # assert_eq DESCRIPTION EXPECTED ACTUAL
  if [ "$2" = "$3" ]; then
    echo "ok - $1"
  else
    fails=$((fails + 1))
    printf 'not ok - %s\n  expected: %s\n  actual:   %s\n' "$1" "$2" "$3"
  fi
}

assert_done() {
  if [ "$fails" -gt 0 ]; then
    echo "FAILED: $fails assertion(s)"
    exit 1
  fi
}

skip_if_absent() { # skip_if_absent TOOL...
  for tool; do
    if ! command -v "$tool" >/dev/null; then
      echo "skip: $tool not installed" >&2
      exit 0
    fi
  done
}
