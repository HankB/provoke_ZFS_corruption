#!/usr/bin/env bash

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

    sanoid --cron --verbose
    
    sleep 60

done
