#!/sourceme/zsh
# ~/.zshenv: read by every zsh invocation (interactive, login, or a plain
# `zsh -c` script) -- the same reason .bashrc re-sources env.d (a shell
# that never goes through .profile still needs these exports); .zshenv is
# zsh's native always-run equivalent.

# get source_dir, path, has, nproc, ... (functions.d)
. ~/.config/sh/functions.sh
source_dir ~/.config/sh/env.d

. "$HOME/.cargo/env"
