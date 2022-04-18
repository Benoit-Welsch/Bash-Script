#!/bin/bash

for pool in $(zpool list -o name -H); do
  zpool scrub $pool
done