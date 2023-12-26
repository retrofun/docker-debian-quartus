#!/bin/bash

repo='debian'
tag='quartus131'

image="${repo}:${tag}"

podman build -t "${image}" \
  --build-arg username=$(whoami) \
  --build-arg uid=$(id -u) \
  --build-arg gid=$(id -g) \
  --build-arg lang="${LANG}" \
  --build-arg timezone=$(echo $(readlink -f /etc/localtime) | sed 's,/usr/share/zoneinfo/,,') \
  .
