#!/sourceme/zsh
# ~/.zshrc: executed by zsh(1) for interactive shells.
# all new functionality should be added in ~/.config/sh/*.d/ directories

# return early for noninteractive shells (see .bashrc for why this guard
# must be inlined, not delegated to a sourced file)
case $- in
  *i*) ;;
  *) return ;;
esac

# get source_dir, path, has, nproc, ... (functions.d)
. ~/.config/sh/functions.sh

# environment variables (idempotent; .zshenv already ran this too, but a
# config-sh consumer shouldn't have to reason about invocation order --
# same rationale as .bashrc's redundant env.d re-source)
source_dir ~/.config/sh/env.d
# zsh-specific shell settings
source_dir ~/.config/sh/zshrc.d
# generic shell startup, shared with bash
source_dir ~/.config/sh/rc.d

export TZ="America/Chicago"

if [ -e "$HOME/private-dotfiles/.zshrc" ]; then
  source "$HOME/private-dotfiles/.zshrc"
fi
