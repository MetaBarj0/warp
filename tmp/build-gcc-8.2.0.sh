#!/bin/sh

cd /tmp

wget http://ftp.gnu.org/gnu/gcc/gcc-8.2.0/gcc-8.2.0.tar.xz
wget http://ftp.gnu.org/gnu/binutils/binutils-2.31.1.tar.xz
wget http://ftp.gnu.org/gnu/linux-libre/4.x/4.17.10-gnu/linux-libre-4.17.10-gnu\
.tar.lz
wget https://www.musl-libc.org/releases/musl-1.1.20.tar.gz

TARGET=amd64-linux-musl

mkdir -p /tmp/$TARGET

cd -
cd /tmp/$TARGET

lzip -d /tmp/linux-libre-4.17.10-gnu.tar.lz
find /tmp -maxdepth 1 -type f ! -name '*.sh' ! -exec tar --directory . -xf {} \;
rm -f /tmp/*.tar*

cd -
cd /tmp/$TARGET/gcc-8.2.0

./contrib/download_prerequisites

mkdir -p /tmp/$TARGET/build-musl-1.1.20

cd -
cd /tmp/$TARGET/build-musl-1.1.20

ARCH=x86_64

mkdir -p /warp

CROSS_COMPILE=' ' \
  CFLAGS='-O3 -s -fPIC -mtune=native -march=native' \
  ../musl-1.1.20/configure \
  --prefix='/warp' \
  --target=$ARCH \
  --syslibdir=/warp/lib

getThreadCount() {
  echo $(cat /proc/cpuinfo | grep processor | wc -l)
}

make -j$(getThreadCount) install

mkdir -p /tmp/$TARGET/build-binutils-2.31.1

cd -
cd /tmp/$TARGET/build-binutils-2.31.1

CFLAGS='-O3 -s -fPIC -mtune=native -march=native' \
  CXXFLAGS='-O3 -s -fPIC -mtune=native -march=native' \
  ../binutils-2.31.1/configure \
  --prefix='/warp/binutils-2.31.1' \
  --target=$TARGET \
  --enable-gold=yes \
  --disable-bootstrap

PATH=$PATH:/warp/binutils-2.31.1/bin

make -j$(getThreadCount)
make install

mkdir -p /tmp/$TARGET/build-gcc-8.2.0

cd -
cd /tmp/$TARGET/build-gcc-8.2.0

ln -s /warp/ /warp/usr

CFLAGS='-O3 -s -fPIC -mtune=native -march=native' \
  CXXFLAGS='-O3 -s -fPIC -mtune=native -march=native' \
  ../gcc-8.2.0/configure \
  --prefix=/warp/gcc-8.2.0 \
  --target=$TARGET \
  --enable-gold=yes \
  --enable-lto \
  --with-sysroot=/warp \
  --disable-multilib \
  --disable-libsanitizer \
  --enable-languages=c,c++ \
  --with-build-time-tools=/warp/binutils-2.31.1/bin

make -j$(getThreadCount)
make install

PATH=$PATH:/warp/gcc-8.2.0/bin

cd -
cd /tmp/$TARGET/linux-4.17.10

make ARCH=$ARCH INSTALL_HDR_PATH=/warp headers_install

cd -
cd /tmp/$TARGET/build-binutils-2.31.1

find . -maxdepth 1 ! -name . ! -name .. -exec rm -rf {} \;

CROSS_COMPILE="$TARGET-" \
  CC=amd64-linux-musl-gcc \
  CFLAGS='-O3 -s -fPIC -mtune=native -march=native' \
  ../musl-1.1.20/configure \
  --prefix='/warp' \
  --target=$ARCH \
  --syslibdir=/warp/lib

make -j$(getThreadCount) install

cd -
cd /tmp/$TARGET/build-binutils-2.31.1

find . -maxdepth 1 ! -name . ! -name .. -exec rm -rf {} \;

CC=amd64-linux-musl-gcc \
CXX=amd64-linux-musl-g++ \
  CFLAGS='-O3 -s -fPIC -mtune=native -march=native' \
  CXXFLAGS='-O3 -s -fPIC -mtune=native -march=native' \
  ../binutils-2.31.1/configure \
  --prefix='/warp/binutils-2.31.1' \
  --target=$TARGET \
  --enable-gold=yes \
  --disable-bootstrap

make -j$(getThreadCount)
make install

cd -
cd /warp/binutils-2.31.1/bin

for f in *; do ln -s $f $(echo $f | sed 's/amd64-linux-musl-//'); done

cd -
cd /tmp/$TARGET/build-gcc-8.2.0

find . -maxdepth 1 ! -name . ! -name .. -exec rm -rf {} \;

CC=amd64-linux-musl-gcc \
  CXX=amd64-linux-musl-g++ \
  CFLAGS='-O3 -s -fPIC -mtune=native -march=native --sysroot=/warp' \
  CXXFLAGS='-O3 -s -fPIC -mtune=native -march=native --sysroot=/warp' \
  ../gcc-8.2.0/configure \
  --prefix=/warp/gcc-8.2.0 \
  --target=$TARGET \
  --enable-gold=yes \
  --enable-lto \
  --with-sysroot=/warp \
  --disable-multilib \
  --disable-libsanitizer \
  --enable-languages=c,c++ \
  --with-build-time-tools=/warp/binutils-2.31.1/bin

make -j$(getThreadCount)
make install

cd -
cd /warp/gcc-8.2.0/bin

for f in *; do ln -s $f $(echo $f | sed 's/amd64-linux-musl-//'); done
