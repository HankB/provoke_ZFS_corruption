#!/bin/bash

/bin/time -p /home/hbarta/bin/stir_pool.sh >/home/hbarta/logs/$(/bin/date  +%Y-%m-%d-%H%M).stir_pools.txt 2>&1
