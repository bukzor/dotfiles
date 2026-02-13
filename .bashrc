#!/sourceme/bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# all new functionality should be added in ~/.config/sh/*.d/ directories

# return early for noninteractive shells
. ~/.config/sh/interactive_only.sh
# get the source_dir function
. ~/.config/sh/functions.sh

# the rest of my functions
source_dir ~/.config/sh/functions.d
# environment variables
source_dir ~/.config/sh/env.d
# bash-specific shell settings
source_dir ~/.config/sh/bashrc.d
# generic shell startup, shared with zsh
source_dir ~/.config/sh/rc.d
export TZ="America/Chicago"
