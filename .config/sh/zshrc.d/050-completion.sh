# enable advanced command completion; fpath must be set before compinit
fpath+=(
  ~/.zsh_completion
  "$HOMEBREW_PREFIX/completions/zsh"
  "$HOMEBREW_PREFIX/share/zsh/site-functions"
)
zmodload -i zsh/parameter
if ! (( $+functions[compdef] )); then
  autoload -U +X compinit && compinit
fi
zstyle ':completion:*' insert-unambiguous yes
zstyle ':completion:*' verbose yes
zstyle ':completion:*' select yes

autoload -U +X bashcompinit && bashcompinit
