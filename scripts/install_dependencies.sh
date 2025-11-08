#!/bin/bash
set -e
set -o pipefail

apk update

apk add --no-cache \
    alpine-sdk \
    cmake \
    git \
    wget \
    curl \
    bash \
    zip \
    unzip \
    tzdata \
    libtool \
    automake \
    m4 \
    re2c \
    supervisor \
    openssl-dev \
    zlib-dev \
    libcurl \
    curl-dev \
    protobuf-dev \
    python3 \
    doxygen \
    graphviz \
    rsync \
    gcovr \
    lcov \
    autoconf \
    gnupg \
    binutils \
    clang-extra-tools

if [ "$LINK" == "static" ]; then
  apk add --no-cache \
      zlib-static \
      zstd-static \
      curl-static \
      openssl-libs-static \
      nghttp2-dev \
      nghttp2-static \
      brotli-static \
      libidn2-static \
      libpsl-static \
      libunistring-static
fi

#
# Dotenv
#

if [ "$BOOST_VARIANT" == "release" ]; then
  DOTENV_BUILD_ARGS="-DCMAKE_BUILD_TYPE=Release"
else
  DOTENV_BUILD_ARGS="-DCMAKE_BUILD_TYPE=Debug"
fi

git clone https://github.com/laserpants/dotenv-cpp.git dotenv
cd dotenv/build
cmake .. -DBUILD_DOCS=Off $DOTENV_BUILD_ARGS
make install
cd ../..
rm dotenv -Rf

#
# Bcrypt
#

if [ "$LINK" == "static" ]; then
  BCRYPT_BUILD_ARGS="-DBUILD_SHARED_LIBS=Off"
else
  BCRYPT_BUILD_ARGS="-DBUILD_SHARED_LIBS=On"
fi

git clone https://github.com/trusch/libbcrypt.git bcrypt
cd bcrypt
mkdir build
cd build
cmake .. $BCRYPT_BUILD_ARGS
make -j4
make install
cd ../..
rm bcrypt -Rf
