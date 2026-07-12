# terminal-keymap detection: generates/reads ~/.zkbd/$TERM-$VENDOR-$OSTYPE,
# defining the $key[] array the keybindings below use. $VENDOR/$OSTYPE are
# zsh built-ins, no setup needed.
zkbd_dir="${ZDOTDIR:-$HOME}/.zkbd"
zkbd_file="$zkbd_dir/$TERM-$VENDOR-$OSTYPE"
mkdir -p "$zkbd_dir"
# zkbd's wizard needs a real controlling terminal to probe key sequences;
# without one (CI, this harness's non-tty checks) it stalls ~10s on the
# first key then fails the rest with "not interactive and can't open
# terminal" -- skip generating in that case. keybindings.sh guards every
# $key[...] reference, so an unresolved $key here just means those few
# bindings are absent, not an error.
if tty -s && ! [[ "$(grep -c '^key\[' "$zkbd_file" 2>/dev/null)" -eq 24 ]]; then
  autoload zkbd && zkbd
fi
if [[ -e "$zkbd_file" ]]; then
  source "$zkbd_file"
fi
unset zkbd_dir zkbd_file
