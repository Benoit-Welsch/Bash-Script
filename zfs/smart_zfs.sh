#!/bin/bash

if !  [[ $1 = "short" || $1 = "long" ]]; then
  echo "[Error] : Please provide the type of the smart test (short, long)"
  exit 1
fi

for disk in $(ls /dev/disk/by-vdev/ | grep -E -o '(?<=\s+|^)[a-zA-Z0-9]+(?=\s+|$)'); do
  smartctl -t $1 /dev/disk/by-vdev/$disk
done