# Build directory targets into a tmp dir, then swap

redo's `$3` atomic rename assumes a single file. A directory target needs the
swap done by hand: build into a fresh tmp dir, replace the old target only on
success.

    tmp=$3.tmp
    rm -rf "$tmp"; mkdir "$tmp"
    # ...produce files into $tmp...
    rm -rf "$1"; mv "$tmp" "$3"

`rm -rf "$1"` clears the old directory so redo's final `$3`→`$1` rename
succeeds. Until the `mv`, a failure leaves the target untouched.
