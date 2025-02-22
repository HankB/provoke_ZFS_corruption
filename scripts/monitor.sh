#!/usr/bin/env bash

# package several monitoring processes in one script suitabnle for cmdwatch

echo status
zpool status
echo
echo list
echo
zpool list
echo
echo send snapshot count
zfs list -t snap -r send|wc -l
echo
echo recv snapshot count
zfs list -t snap -r recv|wc -l

