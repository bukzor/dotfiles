# the bare basics -- only fill in what's unset; this now runs on every
# login shell (wired into .profile by task 000), not just as a bootstrap,
# so it must not clobber an already-correct $HOME (e.g. hermetic test HOME)
export HOME USER PATH
: "${USER:=$(whoami)}"
: "${HOME:=$(eval "echo ~$USER")}"
: "${PATH:="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games"}"
