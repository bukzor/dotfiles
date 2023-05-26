#!/sourceme/dash
# add standard XDG support to systems that don't already have it configured
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
# supported: bash dash zsh busybox macos

umask 022

# NB: macos mkdir doesn't support long option --mode, nor appended options
export XDG_DATA_HOME
if ! [ "$XDG_DATA_HOME" ]; then
  XDG_DATA_HOME="$HOME/.local/share"
  if ! [ -d "$XDG_DATA_HOME" ]; then
    mkdir -p "$XDG_DATA_HOME"
    chmod 700 "$XDG_DATA_HOME"
  fi
fi

export XDG_CONFIG_HOME
if ! [ "$XDG_CONFIG_HOME" ]; then
  XDG_CONFIG_HOME="$HOME/.config"
  if ! [ -d "$XDG_CONFIG_HOME" ]; then
    mkdir -p "$XDG_CONFIG_HOME"
    chmod 700 "$XDG_CONFIG_HOME"
  fi
fi

export XDG_DATA_DIRS
XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"

export XDG_CONFIG_DIRS
XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-/etc/xdg}"

export XDG_CACHE_HOME
if ! [ "$XDG_CACHE_HOME" ]; then
  XDG_CACHE_HOME="$HOME/.cache"
  if ! [ -d "$XDG_CACHE_HOME" ]; then
    mkdir -p "$XDG_CACHE_HOME"
    chmod 700 "$XDG_CACHE_HOME"
  fi
fi

export XDG_RUNTIME_DIR
if ! [ "$XDG_RUNTIME_DIR" ]; then
  XDG_RUNTIME_DIR="$TMPDIR/runtime-$USER-$BOOT"

  mkdir -p "$XDG_RUNTIME_DIR"
  chmod 700 "$XDG_RUNTIME_DIR"
  if has setsid && has flock; then
    # prevent tmpwatch (or similar) from cleaning up our XDG_RUNTIME_DIR, till
    # we're done with it:
    # 9 is an arbitrarily chosen (presumably) unused file descriptor
    # bash can do better, but I want to support busybox and dash
    exec 9< "$XDG_RUNTIME_DIR"
    if flock --nonblock 9; then
      ( sh -euc 'while :; do touch -ham "$XDG_RUNTIME_DIR"; sleep 3600; done' & ) &
    fi
  else
    cat <<EOF >&2
please install util-linux:

  brew install util-linux && brew link -f util-linux

EOF
  fi
fi
