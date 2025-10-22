More than one NVim
==================

It's actually pretty easy to get nvim to keep several separate configurations.
The main trick is to set NVIM_APPNAME:


`~/bin/nvim-lazy`:
```sh
#!/usr/bin/env bash
export NVIM_APPNAME="${NVIM_APPNAME:-"$(basename "$0")"}"

exec -a "$NVIM_APPNAME" nvim "$@"
```

When run this way, nvim will now use `nvim-lazy` instead of `nvim` in all its
configuration directory paths. So, for example, its main config file can be
placed at `~/.config/nvim-lazy/init.lua`. Then any files that you want to re-use
from your "normal" nvim configuration can be symlinked from `~/.config/nvim/`.

This idea was stolen from the lunarvim wrapper:
https://github.com/LunarVim/LunarVim/blob/420817e/utils/bin/lvim.template#L3
