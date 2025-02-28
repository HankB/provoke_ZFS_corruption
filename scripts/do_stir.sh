#!/usr/bin/env bash

start=$(/bin/date  +%Y-%m-%d-%H%M%S)
start_s=$(/bin/date +%s)

time -p /home/hbarta/bin/stir_pool.sh >"/home/hbarta/logs/$start.stir_pools.txt" 2>&1

finish_s=$(/bin/date +%s)
elapsed=$((finish_s-start_s))
zpool status send >>"/home/hbarta/logs/$start.stir_pools.txt" 2>&1
mv "/home/hbarta/logs/$start.stir_pools.txt" \
    "/home/hbarta/logs/$start.stir_pools.$elapsed.txt"
