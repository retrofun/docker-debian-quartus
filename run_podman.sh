#!/bin/bash

repo='debian'
tag='quartus131'

image="${repo}:${tag}"

username=$(whoami)

hostname="${repo}-${tag}-${username}"

[[ ${#} -eq 0 ]] && set -- '/opt/quartus/quartus/bin/quartus' '--64bit'

podman run --rm \
  --security-opt seccomp=addr_no_randomize.json \
  -h "${hostname}" -l "${hostname}" --name "${hostname}" \
  -e "DISPLAY=${DISPLAY}" --ipc host \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --group-add keep-groups \
  -v /dev/bus/usb:/dev/bus/usb \
  -u "${username}" \
  --userns keep-id:uid=$(id -u),gid=$(id -g) \
  -v /home/"${username}":/home/"${username}" \
  -e "LANG=${LANG}" \
  ${podman_run_options} \
  "${image}" \
  "${@}"
