#!/usr/bin/env bash
# Bash3 Boilerplate. Copyright (c) 2014, kvz.io

set -o errexit
set -o pipefail
set -o nounset
set -x
############### end of Boilerplate

# see https://github.com/HankB/provoke_ZFS_corruption

# tunables
skip_range=20                   # skip 0-20 files and modify 

# Modify files. There are many ways to do this
# but the first cut will just replace a random character in the file
# with another random character.
modify_file() {
    case $OSTYPE in
	linux*)
	    file_len=$(stat --printf="%s" "$1")
	    ;;
	freebsd*)
	    file_len=$(stat -f%z "$1")
	    ;;
	*)
	    pri"ntf stderr "unrecotnized OS $OSTYPE
	    exit
	    ;;
    esac
    offset=$((RANDOM % "$file_len"))
    LC_ALL=C tr -dc '[:print:]' < /dev/urandom | head -c 1  | \
        dd bs=1 count=1 seek=$offset conv=notrunc of="$1" || true
}

# following solution found at 
# https://stackoverflow.com/questions/23356779/how-can-i-store-the-find-command-results-as-an-array-in-bash

mapfile -d $'\0' file_list < <(find /mnt/send/test -type f -print0)
echo
echo ${#file_list[*]} files

list_count=${#file_list[*]}
file_index=0

while [ "$file_index" -lt "$list_count" ]
do
    skip=$((RANDOM % skip_range))
    file_index=$((file_index + skip))
    if [ "$file_index" -ge "$list_count" ]
    then
        break;
    fi
    modify_file "${file_list[$file_index]}"
done
