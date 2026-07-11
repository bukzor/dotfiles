#!/not/executable/sh
# ported from main's .sh_env (task 000). Safe no-op today: confirmed
# neither the commands nor ~/private-dotfiles exist on this machine yet --
# ports as inert/future-proofing.
if has private-dotfiles-check && ! private-dotfiles-check; then
  private-dotfiles-mount
fi
trysource "$HOME/private-dotfiles/.sh_env"
