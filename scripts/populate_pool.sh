#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset
set -x
############### end of Boilerplate

# see https://github.com/HankB/provoke_ZFS_corruption

# some tuning parameters
files_per_dir=800               # max file creation loops (2 files/loop)
max_random_count=200            # block count for random files
random_blk_size=100K            # max block size for random
user=hbarta
pool=send
test_fs="test"


add_files() {
    cd "$1"
    for fn in $(seq 1 $files_per_dir)
    do
        blocks=$((1 + RANDOM % "$max_random_count"))
        yes 0123456789 | dd bs=$random_blk_size count=$blocks of="txt_$fn" iflag=fullblock || :
        blocks=$((1 + RANDOM % "$max_random_count"))
        dd if=/dev/urandom bs=$random_blk_size count=$blocks of="rnd_$fn" 
    done
}

# Create nested filesystems 3 layers deep.

zfs create "$pool/$test_fs"
for l0 in $(seq 0 3)             # 3 main (test) filesystems)
do
    zfs create "$pool/$test_fs/l0_$l0"
    add_files "/mnt/$pool/$test_fs/l0_$l0"
    for l1 in $(seq 0 3)    # 3 subs in each main 
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

chown -R $user:$user "/mnt/$pool/"
