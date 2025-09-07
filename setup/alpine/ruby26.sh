# stolen from:
# https://hub.docker.com/layers/library/ruby/2.6.3-alpine/images/sha256-2bfb84156d7a356ae1ca3078c33b81fe4ef656343a5d3679a2b5ba42522fcba9
# changes:
#   updated from 2.6.3 to 2.6.9
exec 0</dev/null # run noninteractive

export RUBY_MAJOR=2.6
export RUBY_VERSION=2.6.9
export RUBY_DOWNLOAD_SHA256=6a041d82ae6e0f02ccb1465e620d94a7196489d8a13d6018a160da42ebc1eece
export RUBY_PREFIX="$HOME"/prefix/ruby26

set -eux

sudo apk add \
  --no-cache \
  --virtual \
  .ruby-builddeps \
  bison \
  bzip2 \
  bzip2-dev \
  ca-certificates \
  coreutils \
  dpkg-dev \
  dpkg \
  gcc \
  gdbm-dev \
  glib-dev \
  libc-dev \
  libffi-dev \
  libxml2-dev \
  libxslt-dev \
  linux-headers \
  make \
  ncurses-dev \
  openssl \
  openssl-dev \
  procps \
  readline-dev \
  ruby \
  tar \
  xz \
  yaml-dev \
  zlib-dev \
;

if ! [ -f ruby.tar.xz ]; then
  curl \
    -sSLfo ruby.tar.xz \
    "https://cache.ruby-lang.org/pub/ruby/${RUBY_MAJOR%-rc}/ruby-$RUBY_VERSION.tar.xz" \
  ;
fi

echo "$RUBY_DOWNLOAD_SHA256 *ruby.tar.xz" |
  sha256sum --check --strict

rm -rf ruby2.6
mkdir -p ruby2.6
tar -xJf ruby.tar.xz -C ruby2.6 --strip-components=1


{ cd ruby2.6
  if false; then
  if ! [ -f  thread-stack-fix.patch ];then
    curl \
      -sSLfo 'thread-stack-fix.patch' \
      'https://bugs.ruby-lang.org/attachments/download/7081/0001-thread_pthread.c-make-get_main_stack-portable-on-lin.patch' \
    ;
  fi
  echo '3ab628a51d92fdf0d2b5835e93564857aea73e0c1de00313864a94a6255cb645 *thread-stack-fix.patch' |
    sha256sum --check --strict
  patch -p1 -i thread-stack-fix.patch
  patch -p0 -i ../ossl_pkey_rsa.c.patch
  
  { echo '#define ENABLE_PATH_CHECK 0'
    echo
    cat file.c
  } > file.c.new
  mv file.c.new file.c
  
  gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
  export ac_cv_func_isnan=yes ac_cv_func_isinf=yes

  CFLAGS='-Wno-error=deprecated-declarations'
  ./configure \
    --prefix="$PREFIX" \
    --build="$gnuArch" \
    --disable-install-doc \
    --enable-shared \
  ;
  export MAKEOPTS="--jobs $(($(nproc) * 3))"
  make
  make install

  runDeps="$( # derpy syntax needs this comment
    scanelf --needed --nobanner --format '%n#p' --recursive /usr/local |
      tr ',' '\n' |
      sort -u |
      awk '
        system("[ -e /usr/local/lib/" $1 " ]") == 0
        { next }
        { print "so:" $1 }
      '
  )"
  sudo apk add \
    --no-network \
    --virtual .ruby-rundeps \
    $runDeps \
    bzip2 \
    ca-certificates \
    libffi-dev \
    procps \
    yaml-dev \
    zlib-dev \
  ;
  fi
  sudo apk del \
    --no-network \
    .ruby-builddeps \
  ;

  cd -
}

rm -r ruby2.6
! sudo apk --no-network list --installed |
  grep -v '^[.]ruby-rundeps' |
  grep -i ruby

PATH=$RUBY_PREFIX/bin:$PATH
[ "$(command -v ruby)" = "$RUBY_PREFIX/bin/ruby" ]
ruby --version
gem --version
bundle --version
