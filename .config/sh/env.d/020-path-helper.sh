#!/not/executable/sh
# macOS: seed PATH from /etc/paths(.d) via path_helper (ported from main's
# .sh_env, task 000). Routed through our idempotent `path` function
# (functions.d/path.sh) instead of path_helper's own `eval` output --
# path_helper itself is NOT idempotent (repeat invocations duplicate
# entries), which matters here since env.d is re-sourced by .bashrc for
# interactive-only shells. Entries are reversed before feeding `path
# prepend` (last-wins) so the resulting order still matches path_helper's
# own front-to-back priority. MANPATH/INFOPATH lines from path_helper are
# not handled here -- out of scope, homebrew's env.d file owns those.
# Untestable on this machine (no macOS) -- verify live if this ever lands
# on a Mac checkout.
if [ -x /usr/libexec/path_helper ]; then
  # shellcheck disable=SC2046  # word-splitting into separate PATH entries is the point
  path prepend PATH $(
    /usr/libexec/path_helper -s |
      sed -n 's/^PATH="\(.*\)"; export PATH;$/\1/p' |
      tr ':' '\n' |
      sed '1!G;h;$!d'
  )
fi
