#!/bin/bash

set -e

function onePool() {
  zpool list $1
  for disk in $(zdb -C $1 | grep -Po '(?<=[ *]path: ).+'); do
    smartctl -t $1 $disk
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
  onePool $2
else
  allDrive $1
fi
