#!/bin/bash

# Use a file '/home/hbarta/logs/halt_test.txt' to stop the test
# by writing the current time to that file.

while(:)
do
    # check for halt condition
    if [ -e /home/hbarta/logs/halt_test.txt ]
    then
        echo "halting on corruption detected"
        exit
    fi

    do_syncoid.sh
    
    # And check for corruption
    for log in $(find /home/hbarta/logs -type f|sort|tail)
    do
        if ( grep -q "use '-v' for a list" "$log" )
        then
            echo "corruption detected in $log"
            date +%Y-%m-%d-%H%M >>/home/hbarta/logs/halt_test.txt
            exit
        fi
    done

done