#!/bin/sh
make \
  CMAKE_INSTALL_PREFIX=$HOME/prefix/neovim \
  CMAKE_BUILD_TYPE=RelWithDebInfo \
  CC=clang \
  TARGET_AR='llvm-ar r' \
  TARGET_STRIP=llvm-strip \
  install \
;
