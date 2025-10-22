# the bare basics
export HOME USER PATH
USER=$(whoami)
HOME=$(eval "echo ~$USER")
PATH="${PATH:-"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games"}"
