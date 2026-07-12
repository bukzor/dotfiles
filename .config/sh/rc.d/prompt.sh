# Cross-shell PS1 (bash/zsh/dash-compatible), ported from main's .sh_rc --
# supersedes the old bashrc.d/prompt.sh Debian-default prompt; bash and zsh
# now share this one prompt.
if [ -n "${COLORTERM:-}" ]; then
  # terminfo decides whether TERM is actually color-capable
  ansi_color() { tput setaf "$@"; }
  RESET="$(tput sgr0)"
else
  ansi_color() { :; }
  RESET=""
fi
  RED="$(ansi_color 1)"
GREEN="$(ansi_color 2)"
YELLOW="$(ansi_color 3)"
  BLUE="$(ansi_color 4)"
PURPLE="$(ansi_color 5)"
  TEAL="$(ansi_color 6)"

# repurposed as the prompt's clock format, not just `history`'s (bash still
# gets real per-entry history timestamps as a side effect)
HISTTIMEFORMAT='[%F %a %p %I:%M%z]'
PROMPT_DIRTRIM=3

if [ -n "${BASH_VERSION:-}" ]; then
  PSLESC='\['
  PSRESC='\]'
  PSUSER='\u'
  PSHOST='\h'
  PS1PWD='\w'
  PSDATE='\D{'"$HISTTIMEFORMAT"'}'
elif [ -n "${ZSH_VERSION:-}" ]; then
  PSLESC='%{'
  PSRESC='%}'
  PSUSER='%n'
  PSHOST='%M'
  PS1PWD='%3~' # zsh has no PROMPT_DIRTRIM; %3~ is its own last-3-components escape
  PSDATE='%D{'"$HISTTIMEFORMAT"'}'
else # dash, busybox, or similar
  PSLESC=''
  PSRESC=''
  PSUSER='$USER'
  PSHOST='$(hostname -s)'
  PS1PWD='$PWD'
  PSDATE='$(date +"$HISTTIMEFORMAT")'
fi

if [ "$(id -u)" -eq 0 ]; then
  PS1END='#'
else
  PS1END='$'
fi

esc() { echo -n "$PSLESC$1$PSRESC"; }

PS1=\
'${PS1_PREFIX:-}'\
"$(esc "$YELLOW")$PS1PWD
"\
"$(esc "$PURPLE")$PSDATE "\
"$(esc "$BLUE")$PSUSER"\
"$(esc "$RESET")@"\
"$(esc "$GREEN")$PSHOST "\
"$(esc "$RED")$PS1END"\
"$(esc "$RESET") "
unset esc

export PS1
