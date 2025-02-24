#!/usr/bin/env bash
# set -x
start=$(/bin/date  +%Y-%m-%d-%H%M%S)
start_s=$(/bin/date +%s)

time -p syncoid --recursive --no-privilege-elevation send/test recv/test >"/home/hbarta/logs/$start.syncoid.txt" 2>&1

finish_s=$(date +%s)
elapsed=$((finish_s-start_s))
zpool status send >>"/home/hbarta/logs/$start.syncoid.txt" 2>&1
mv "/home/hbarta/logs/$start.syncoid.txt" "/home/hbarta/logs/$start.syncoid.$elapsed.txt"
