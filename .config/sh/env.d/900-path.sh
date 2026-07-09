#!/not/executable/sh
# migrated verbatim from inline .profile 2026-07-09 (task 000). Loads last
# (900-) so PREFIX/GOPREFIX/VOLTA_HOME from earlier env.d files are set;
# /opt/homebrew/{bin,sbin} duplicate 300-homebrew.sh's own prepend -- left
# as-is rather than deduped, to keep this migration behavior-preserving.

# NOTE: in `path prepend`, last wins
# enabling meta-tools: rustup, volta, etc.
path prepend PATH <<EOF
  $HOME/.local/share/nvim/mason/bin
  $HOME/bin/shim
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /usr/sbin
  /sbin

  $GOPREFIX/bin

  $HOME/.bun/bin
  $VOLTA_HOME/bin
  $PREFIX/pnpm/bin

  $PREFIX/cargo/bin
  $HOME/.cargo/bin

  # enable ~/bin/ unconditionally, so we can create it after login
  $HOME/.local/bin  # similar, but XDG style
  $HOME/bin
EOF
