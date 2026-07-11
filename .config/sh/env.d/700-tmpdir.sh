#!/not/executable/sh
# ported from main's .sh_env (task 000): pick a private, writable TMPDIR,
# namespaced by boot instant + date so stale runs don't collide across
# reboots. Adapted from main's original candidate list: dropped the
# "$PREFIX/tmp/..." candidate -- main's $PREFIX there means "filesystem
# root" (grandparent of $HOME), which reduces to the same path as the
# literal /tmp candidate below on this layout, AND collides with this
# tree's own $PREFIX (~/prefix, a local install prefix -- see
# 050-prefix.sh); reusing the name here would shadow that.
export BOOT
BOOT="$(bootstamp)"

export TMPDIR
# NB: macos date(1) doesn't support -I nor -Id
date="$(date -Idate)"
for TMPDIR in \
  "$TMPDIR" \
  "/tmp/$USER/$BOOT/$date" \
  "/tmp" \
  "$HOME/tmp/$BOOT/$date" \
  "$HOME/tmp"; do
  if [ "$TMPDIR" ]; then
    mkdir -p "$TMPDIR" 2>/dev/null
    chmod -f 700 "$TMPDIR"
    if [ -d "$TMPDIR" ] && [ -w "$TMPDIR" ]; then
      break
    fi
  fi
done
unset date

if [ "$TMPDIR" ] && [ -d "$TMPDIR" ] && [ -w "$TMPDIR" ]; then
  TMPDIR="$(abspath "$TMPDIR")"
else
  unset TMPDIR
  warn 'No writable TMPDIR!'
fi
