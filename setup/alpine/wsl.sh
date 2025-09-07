#!/bin/bash
set -euo pipefail

export USER
USER="${USER:-$(id -un)}"

USERLAND_TAR=https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/x86_64/alpine-minirootfs-3.17.2-x86_64.tar.gz
USERLAND_SHA=b10fc6a33e462b9ccf704436071771051728d30f5d8b48adcddb9523c4c45328
DISTRO="$(basename $USERLAND_TAR | sed -r 's@\.[^/-_]+$@@g')"
WSL_CONF=$'
[user]
default=$USER
'

wsl-run() {
  show wsl.exe --cd / --distribution "$DISTRO" "$@"
}

wincmd() {
  show env --chdir $(wslpath C:\\) cmd.exe /C "$@" |
    tr -d '\r'
}

show() {
  ( set -x;
    "$@"  # the wrapped command
    {
      status=$?
      set +x
    } 2>/dev/null
    return $status
  )
}

pre-add-user() {
  # Alpine tar.gz image has wrong permissions on the "/" aka. root folder, this prevents su from working, so only "install --root" is working.
  wsl-run chmod 755 /

  # Provides /usr/sbin/usermod
  wsl-run apk --no-cache add shadow

  # Make sure files like /etc/alpine-release are properly updated and common
  # tools like lbu are present
  wsl-run apk --no-cache add alpine-base

  # sudo is necessary for root operations
  wsl-run apk --no-cache add sudo

  # Remove the explicitly exported path variable, as wsl is preinitializing path
  # for us, so that windows applications can also be called from within wsl.
  wsl-run sed -i 's/^export PATH/#export PATH/' /etc/profile
}

checksum-verify() {
  sha="$1"
  file="$2"
  show echo "$sha  $file" |
    show sha256sum -c
}

install-image() {
  winhome="$(wincmd echo %USERPROFILE%)"
  tar="$(basename "$USERLAND_TAR")"

  show curl -sSL --fail-with-body "$USERLAND_TAR" -o "$tar"
  checksum-verify "$USERLAND_SHA" "$tar"

  dst="$winhome\\wsl\\$DISTRO"  # that's a windows path
  show mkdir -p "$(wslpath "$dst")"
  show wsl.exe --import "$DISTRO" "$dst" "$tar"
}

main() {
  install-image

  wsl-run rm /etc/resolv.conf
  pre-add-user

  wsl-run adduser -g '' -D "$USER"
  wsl-run usermod -aG adm,floppy,cdrom,tape,wheel,ping "$USER"

  wsl-run sudo sh -c 'echo "'"$WSL_CONF"'" > /etc/wsl.conf'
  echo DONE
}


main
