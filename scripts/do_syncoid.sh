#!/bin/bash

start=$(/bin/date  +%Y-%m-%d-%H%M)
start_s=$(/bin/date +%s)

/bin/time -p /sbin/syncoid --recursive --no-privilege-elevation send/test recv/test >"/home/hbarta/logs/$start.syncoid.txt" 2>&1

finish_s=$(/bin/date +%s)
elapsed=$((finish_s-start_s))
zpool status send >>"/home/hbarta/logs/$start.syncoid.txt" 2>&1
mv "/home/hbarta/logs/$start.syncoid.txt" "/home/hbarta/logs/$start.syncoid.$elapsed.txt"
