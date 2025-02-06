#!/bin/bash

# Trim the snapshots created by thrash_zfs.sh and thrash_stir.sh
# e.g. not touching those created by syncoid.
#


retain_count=100
pool=send

start=$(/bin/date  +%Y-%m-%d-%H%M)
start_s=$(/bin/date +%s)

for fs in $(zfs list -r -H -o name "$pool")
do  
    # count snaps
    count=$(zfs list -t snap "$fs"|wc -l)

    delete_count=$(( count-retain_count))

    if [ "$delete_count" -gt 0 ]
    then
        echo "deleting $delete_count from $fs" 
        for snap in $(zfs list -t snap -H -o name "$fs" | sort | head -"$delete_count")
        do
            echo "deleting $snap"
            zfs destroy "$snap"
        done
    else
        echo "deleting none from $fs"
    fi

done 

finish_s=$(/bin/date +%s)
elapsed=$((finish_s-start_s))
zpool status send 
mv "/home/hbarta/logs/$start.trim_snaps.txt" \
    "/home/hbarta/logs/$start.trim_snaps.$elapsed.txt"
