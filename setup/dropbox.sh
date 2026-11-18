#!/bin/bash
set -euo pipefail
PS4='\033[94m$ \033[m'

has() {
  command -v "$1" >/dev/null
}
quiet() {
  { set +x; } 2>/dev/null
  local status
  "$@" && status="$?" || status="$?"
  set -x
  { return "$status"; } 2>/dev/null
}
dropbox-is-running() {
    ! dropbox status | grep --color -Fx 'Dropbox isn'\''t running!'
}

d_src="https://www.dropbox.com/download?plat=lnx.x86_64"
d_tar=~/package/dropbox.tgz
d=~/.dropbox-dist/dropboxd
d_dst="$(dirname "$d")"

cli_src="https://www.dropbox.com/download?dl=packages/dropbox.py"
cli=~/bin/alternatives/dropbox

set -x
if has dropbox; then
  while quiet dropbox-is-running; do
    dropbox stop
    sleep 2
  done
fi

if [[ -e "$d_dst" ]]; then
  rm -rvf "$d_dst"
fi
mkdir -p "$(dirname "$d_tar")"
curl -SL "$d_src" -o "$d_tar"
tar -xvf "$d_tar" -C "$(dirname "$d_dst")"

if ! [[ -x "$d" ]]; then
  echo fail >&2
  exit 1
fi

mkdir -p "$(dirname "$cli")"
curl -SL "$cli_src" -o "$cli"
chmod 755 "$cli"
"$cli" start
while ! quiet dropbox-is-running; do
  "$cli" status
done

: Success!
