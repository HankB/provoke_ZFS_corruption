#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset
set -x
############### end of Boilerplate

# see https://github.com/HankB/provoke_ZFS_corruption

# tunables
skip_range=20 # skip 0-20 files and modify 
# following solution found at 
# https://stackoverflow.com/questions/23356779/how-can-i-store-the-find-command-results-as-an-array-in-bash

mapfile -d $'\0' file_list < <(find /mnt/io_tank/test -type f -print0)
echo
echo ${#file_list[*]} files
echo "${file_list[0]}"
echo "${file_list[1]}"