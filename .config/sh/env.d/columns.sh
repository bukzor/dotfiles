#!/not/executable/sh
# git (and others) fall back to 80 columns when stdout is piped, unless
# COLUMNS is exported -- 80 elides `git diff --stat` filenames.
# 132 is the 1970s update to 80.
# Interactive bash (checkwinsize) overwrites the value with real width.
export COLUMNS=132
