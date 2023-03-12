FROM debian:bullseye-slim

ARG username uid gid lang timezone
RUN test -n "${username}" || (echo 'username required: use e.g. --build-arg username=$(whoami)' && false)
RUN test -n "${uid}" || (echo 'uid required: use e.g. --build-arg uid=$(id -u)' && false)
RUN test -n "${gid}" || (echo 'gid required: use e.g. --build-arg gid=$(id -g)' && false)
RUN test -n "${lang}" || (echo 'lang required: use e.g. --build-arg lang=${LANG}' && false)
RUN test -n "${timezone}" || (echo 'timezone required: use e.g. --build-arg timezone=$(echo $(readlink -f /etc/localtime) | sed 's,/usr/share/zoneinfo/,,')' && false)

COPY libpng12-0_1.2.50-2+deb8u3_amd64.deb /tmp
COPY libpng12-0_1.2.50-2+deb8u3_i386.deb /tmp
ADD freetype-2.4.12.tar.gz /tmp
ADD Quartus-web-13.1.0.162-linux.tar /tmp
COPY QuartusSetup-13.1.4.182.run /tmp

RUN set -eux && \
  rm -f /etc/localtime && \
  ln -s /usr/share/zoneinfo/"${timezone}" /etc/localtime && \
  dpkg --add-architecture i386 && \
  apt update && \
  apt install -y apt-utils build-essential less locales procps psmisc tcl tk vim wget xauth xvfb \
    gcc-multilib g++-multilib lib32z1 lib32stdc++6 lib32gcc-s1 expat:i386 \
    fontconfig:i386 libfreetype6:i386 libexpat1:i386 libc6:i386 libgtk-3-0:i386 \
    libcanberra0:i386 libpng16-16:i386 libice6:i386 libsm6:i386 libncurses5:i386 \
    zlib1g:i386 libx11-6:i386 libxau6:i386 libxdmcp6:i386 libxext6:i386 libxft2:i386 \
    libxrender1:i386 && \
  sed -i -r "s,^#\s*(${lang}.*),\1," /etc/locale.gen &&\
  locale-gen && \
  cd /tmp && \
  dpkg-deb --fsys-tarfile libpng12-0_1.2.50-2+deb8u3_amd64.deb | tar -C /usr/local -xf - ./lib/x86_64-linux-gnu/libpng12.so.0.50.0 ./lib/x86_64-linux-gnu/libpng12.so.0 && \
  dpkg-deb --fsys-tarfile libpng12-0_1.2.50-2+deb8u3_i386.deb | tar -C /usr/local -xf - ./lib/i386-linux-gnu/libpng12.so.0.50.0 ./lib/i386-linux-gnu/libpng12.so.0 && \
  ldconfig && \
  rm -f libpng12-0_1.2.50-2+deb8u3_amd64.deb libpng12-0_1.2.50-2+deb8u3_i386.deb && \
  chown -R root:root setup.sh components && \
  sed -i 's,#!/bin/env,#!/usr/bin/env,' setup.sh && \
  chmod +x setup.sh && \
  ./setup.sh --mode unattended --installdir /opt/quartus && \
  rm -rf components setup.sh /opt/quartus/modelsim_ae && \
  chmod +x QuartusSetup-13.1.4.182.run && \
  ./QuartusSetup-13.1.4.182.run --mode unattended --installdir /opt/quartus && \
  rm -rf QuartusSetup-13.1.4.182.run bitrock_installer*.log /opt/quartus/uninstall && \
  cd freetype-2.4.12 && \
  ./configure --build=i686-pc-linux-gnu CFLAGS=-m32 CXXFLAGS=-m32 LDFLAGS=-m32 && \
  make -j $(nproc) && \
  modelsim_dir='/opt/quartus/modelsim_ase' && \
  mkdir -p "${modelsim_dir}"/lib32/ && \
  cp -a objs/.libs/libfreetype.so objs/.libs/libfreetype.so.6 objs/.libs/libfreetype.so.6.10.1 "${modelsim_dir}"/lib32/ && \
  cd .. && \
  rm -rf freetype-2.4.12.tar.gz freetype-2.4.12 && \
  sed -i -e '/^dir=`dirname $arg0`/a\export LD_LIBRARY_PATH=${dir}/lib32' -r -e 's/^(\s+\*\)\s+vco=)"linux_rh60"/\1"linux"/' ${modelsim_dir}/vco && \
  groupadd -g ${gid} "${username}" && \
  useradd -m -u ${uid} -g ${gid} "${username}" && \
  usermod -a -G plugdev "${username}"

USER "${username}"
WORKDIR /home/"${username}"
