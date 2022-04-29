#!/bin/bash

set -e

function onePool() {
  zpool list $2 >/dev/null
  for disk in $(zdb -C $2 | grep -Po '(?<=[ *]path: ).+'); do
    path=$(echo $disk | cut -d "'" -f 2)
    smartctl -t $1 $path
  done
}

function allDrive() {
  for disk in $(ls /dev/disk/by-vdev/ | grep -E -o '(?<=\s+|^)[a-zA-Z0-9]+(?=\s+|$)'); do
    smartctl -t $1 /dev/disk/by-vdev/$disk
  done
}

if ! [[ $1 = "short" || $1 = "long" ]]; then
  echo "[Error] : Please provide the type of the smart test (short, long)"
  exit 1
fi

if [[ -n $2 ]]; then
  onePool $1 $2
else
  allDrive $1
fi
