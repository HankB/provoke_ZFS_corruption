#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset
############### end of Boilerplate

add_files() {
    cd "$1"
    timeout 3 yes 123456789 > f || :
}

# Create nested filesystems 3 layers deep.

pool=io_tank
test_fs="test"

zfs create "$pool/$test_fs"
for l0 in $(seq 0 3)             # 3 main (test) filesystems)
do
    zfs create "$pool/$test_fs/l0_$l0"
    add_files "/mnt/$pool/$test_fs/l0_$l0"
    for l1 in $(seq 0 3)    # 5 subs in each main 
    do
        zfs create "$pool/$test_fs/l0_$l0/l1_$l1"
        for l2 in $(seq 0 3)    # 3 subs in each main 
        do
            zfs create "$pool/$test_fs/l0_$l0/l1_$l1/l2_$l2"
        done
    done
done
