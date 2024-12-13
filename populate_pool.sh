#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset
set -x
############### end of Boilerplate

# some tuning parameters
max_timeout_seconds=10
files_per_dir=20

add_files() {
    cd "$1"
    for fn in $(seq 1 $files_per_dir)
    do
        tmo=$((1 + RANDOM % "$max_timeout_seconds"))
        timeout "$tmo" yes 0123456789 > "f_$fn" || :
        xz -0 < "f_$fn"  > "f_$fn.xz"
    done
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
        add_files "/mnt/$pool/$test_fs/l0_$l0/l1_$l1"
        for l2 in $(seq 0 3)    # 3 subs in each main 
        do
            zfs create "$pool/$test_fs/l0_$l0/l1_$l1/l2_$l2"
            add_files "/mnt/$pool/$test_fs/l0_$l0/l1_$l1/l2_$l2"
        done
    done
done
