#!/bin/bash

/bin/time -p /sbin/syncoid --recursive --no-privilege-elevation send/test recv/test >/home/hbarta/logs/$(/bin/date  +%Y-%m-%d-%H%M).syncoid.txt 2>&1
