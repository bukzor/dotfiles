# for the web!
export EMSCRIPTEN EMSCRIPTEN_TOOLS
EMSCRIPTEN=/usr/share/emscripten
EMSCRIPTEN_TOOLS="$EMSCRIPTEN/tools"

export PATH CC CXX AR NM LDSHARED RANLIB HOSTRUNNER
PATH="$EMSCRIPTEN:$EMSCRIPTEN/system/bin:/usr/lib/llvm-11/bin:$orig_path"
CC="$(which emcc.py)"
CXX="$(which em++.py)"
AR="$(which emar.py)"
LD="$CC"
NM="$(which llvm-nm)"
LDSHARED="$CC"
RANLIB="$(which emranlib.py)"
HOSTRUNNER="$(which emrun.py)"

export HOST_CC HOST_CXX HOST_CFLAGS HOST_CXXFLAGS
HOST_CC="$(which clang)"
HOST_CXX="$(which clang++)"
HOST_CFLAGS="-W"
HOST_CXXFLAGS="-W"

export PKG_CONFIG_LIBDIR PKG_CONFIG_PATH CROSS_COMPILE
PKG_CONFIG_LIBDIR="$EMSCRIPTEN/system/local/lib/pkgconfig:$EMSCRIPTEN/system/lib/pkgconfig"
PKG_CONFIG_PATH=""
CROSS_COMPILE="$EMSCRIPTEN/em"

version="$version-browser"
dst="$HOME/prefix/python$version"
configure_opts=(
  "${configure_opts[@]}"
  --host=wasm32-none-wasi
  --build=x86_64-pc-linux-gnu
  --with-build-python="$(which python3)"
  #--enable-wasm-dynamic-linking
  #--enable-wasm-pthreads
)
export EM_BUILD_VERBOSE=3
./configure --prefix="$dst" "${configure_opts[@]}"
make install
