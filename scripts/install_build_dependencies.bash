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
                       iputils-ping \
                       netcat-traditional \
                       default-mysql-client \
                       lcov \
                       doxygen \
                       graphviz \
                       rsync

ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
dpkg-reconfigure -f noninteractive tzdata
apt-get clean
apt-get autoclean
apt-get autoremove

git clone https://github.com/trusch/libbcrypt bcrypt
cd bcrypt
mkdir build
cd build
cmake ..
make -j4
make install
ldconfig
cd ../..
rm bcrypt -Rf

git clone https://github.com/getsentry/sentry-native sentry
cd sentry
git checkout tags/0.7.20
git submodule update --init --recursive
cmake -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo
cmake --build build --parallel
cmake --install build --config RelWithDebInfo
ldconfig
cd ..
rm sentry -Rf

git clone https://github.com/gabime/spdlog.git spdlog
cd spdlog
git checkout tags/v1.15.1
cmake .
make -j4
make install
ldconfig
cd ..
rm spdlog -Rf