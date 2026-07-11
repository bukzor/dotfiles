#!/not/executable/sh
# ported from main's .sh_env (task 000, folding in main-only content).
# note: "MACHTYPE" is the compile-time CPU architecture
export CPUTYPE OSTYPE
CPUTYPE="$(uname -m)"
OSTYPE="$(uname -s | tr '[:upper:]' '[:lower:]')"
