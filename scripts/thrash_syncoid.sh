#!/bin/bash

# Use a file '/home/hbarta/logs/halt_test.txt' to stop the test
# by writing the current time to that file.

while(:)
do
    # check for halt condition
    if [ -e /home/hbarta/logs/halt_test.txt ]
    then
        exit
    fi

    zfs snap -r send@$(date +%s).$(date +%Y-%m-%d-%H%M)
    do_syncoid.sh
    
    # And check for corruption
    # shellcheck disable=SC2012
    # shellcheck disable=SC2046
    if ( grep -q "use '-v' for a list" $(ls -t /home/hbarta/logs/*syncoid*|tail ) )
    then
        date +%Y-%m-%d-%H%M >>/home/hbarta/logs/halt_test.txt
        exit
    fi


done