# ~/.profile: executed for all login shells.
# shellcheck disable=SC2006  # allow backticks for hecka-ancient shells
home=`sh -c 'unset HOME; echo ~'`
if [ -d "$home" ]; then
  export HOME="$home"
fi

# If not running interactively, don't do anything
case $- in
*i*) ;;
*)
  . "$HOME"/.sh_plugins.d/basics.sh
  return
  ;;
esac

# for preferred_shell in /usr/bin/zsh /bin/zsh; do
#   if [ ! "$SHELL" -ef "$preferred_shell" -a -x "$preferred_shell" ]; then
#     SHELL="$preferred_shell" exec "$preferred_shell" -xil
#   fi
# done

# General shell environment, shared by zsh
. "$HOME"/.sh_env

# if running bash
if [ -n "${BASH_VERSION:-}" ]; then
  . "$HOME"/.bashrc
elif [ "$ZSH_VERSION" ]; then
  : zsh will source .zshrc
else
  . "$HOME"/.sh_rc
fi
