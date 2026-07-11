#!/not/executable/sh
# ported from main's .sh_env (task 000): identify the real terminal emulator
# (walking up the process tree past tmux/shell layers) and fix TERM when
# it's missing or wrong for that emulator.
#
# Adapted: guarded behind `tty` (existing house idiom, see main's own
# "unmap CTRL-S/CTRL-Q" block) so this only runs when actually attached to
# a real terminal. main's original ran unconditionally in .sh_env, which
# only worked because .sh_env was interactive-session-scoped; here env.d is
# resourced by every shell including hermetic/noninteractive test
# invocations (.profile_test.sh), where the process-tree walk finds no
# known terminal and would otherwise warn on stderr every time --
# regressing the "sourcing emits no errors" invariant. Gating on a real tty
# is also just correct: fixing TERM only matters when there's a terminal
# to fix it for.
if tty >/dev/null 2>&1; then
  psget() {
    column="$1"
    pid="$2"
    if ! [ "$pid" ]; then
      return 1
    fi
    ps -o "$column"= "$pid" |
      tr -d ' '
  }

  # get the session-leader's parent
  if ! {
    pgid="$(psget pgid "$$")" &&
      terminal="$(psget ppid "$pgid")" &&
      [ "$terminal" ] &&
      true
  }; then
    # refuse the temptation to guess what went wrong
    warn "could not find terminal: $$ -> $pgid -> $terminal"
  elif [ "$terminal" -gt 0 ]; then
    # use the basename of its arg[0]
    terminal="$(basename "$(psget ucomm "$terminal")")"
  elif [ "$terminal" -eq 0 ]; then
    # if our session-leader doesn't have a real parent (pid:0) then we're running as init
    terminal=init
  else
    warn "terminal < 0 ?!: $$ -> $pgid -> $terminal"
  fi

  case "$terminal" in
    lxterminal | gnome-terminal | xfce4-terminal)
      export TERM=xterm-256color
      ;;
    tmux | "tmux: server")
      export TERM=xterm-256color
      ;;
    init)
      if [ "$TERM" != "linux" ]; then
        warn 'unknown terminal: "'"$terminal"'" (TERM='"$TERM)"
      fi
      ;;
    "")
      if ! [ "$TERM" ]; then
        export TERM=xterm-256color
        # shellcheck disable=SC2016  # single-quoted portion is the literal '$TERM unset...' text
        warn '$TERM unset. Guessing: TERM='"$TERM"
      fi
      ;;
    *)
      # shellcheck disable=SC3028  # OSTYPE is ours: exported by 010-ostype.sh
      if ! echo "$OSTYPE" | grep -q '^darwin' &&
        ! echo "$TERM" | grep -Eq '^(xterm|screen)-256color$'; then
        warn 'unknown terminal: "'"$terminal"'" (TERM='"$TERM)"
      fi
      ;;
  esac

  unset column terminal pgid
  unset -f psget
fi
