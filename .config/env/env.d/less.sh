# make less more friendly for non-text input files, see lesspipe(1)
export LESSOPEN="| /bin/lesspipe %s";
export LESSCLOSE="/bin/lesspipe %s %s";

