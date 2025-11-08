#!/bin/bash
set -e
set -o pipefail

apt update -qq

apt-get install -y -qq lsb-release \
                       gnupg \
                       git \
                       wget \
                       build-essential \
                       cmake \
                       gcc \
                       make \
                       apt-utils \
                       zip \
                       unzip \
                       tzdata \
                       libtool \
                       automake \
                       m4 \
                       re2c \
                       curl \
                       supervisor \
                       libssl-dev \
                       zlib1g-dev \
                       libcurl4-gnutls-dev \
                       libprotobuf-dev \
                       python3 \
                       lcov \
                       doxygen \
                       graphviz \
                       rsync \
                       clang-format \
                       gcovr

ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
dpkg-reconfigure -f noninteractive tzdata
apt-get clean
apt-get autoclean
apt-get autoremove

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
ldconfig
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
ldconfig
cd ../..
rm bcrypt -Rf
