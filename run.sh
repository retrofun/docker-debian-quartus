#!/bin/bash

repo='debian'
tag='quartus131'

image="${repo}:${tag}"

username=$(whoami)

hostname="${repo}-${tag}-${username}"

[[ ${#} -eq 0 ]] && set -- '/opt/quartus/quartus/bin/quartus' '--64bit'

docker run --rm -it \
  --security-opt seccomp=addr_no_randomize.json \
  -h "${hostname}" -l "${hostname}" --name "${hostname}" \
  -e "DISPLAY=${DISPLAY}" --ipc host \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --device-cgroup-rule 'c 189:* rmw' \
  -v /dev/bus/usb:/dev/bus/usb \
  -u "${username}" \
  -v /home/"${username}":/home/"${username}" \
  -e "LANG=${LANG}" \
  "${image}" \
  "${@}"
