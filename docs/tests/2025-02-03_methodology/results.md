# 2025-02-03 Results

[Setup](./setup.md)

## First `syncoid` pass

```text
root@orcus:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 3638.23
user 50.31
sys 2515.21
root@orcus:~# 
```

[Full log of syncoid first pass](./data.md#2025-02-04-first-syncoid)

### second pass

Without stirring and as a user:

```text
hbarta@orcus:~$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 22.10
user 4.05
sys 10.04
hbarta@orcus:~$ 
```

```text
hbarta@orcus:~$ time -p stir_pool.sh
...
real 89.62
user 36.15
sys 34.96
hbarta@orcus:~$ 
```

### post stir passes

```text
hbarta@orcus:~$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 50.18
user 4.37
sys 13.40
hbarta@orcus:~$ 
```

Stir twice, 2nd time with `stdout` and later, `stderr` redirected to a log file. (Note: dd puts a lot of stuff out to `stderr`)

```text
time -p stir_pool.sh >log/$(date +%Y-%m-%d-%H%M)_stir.txt
...
real 89.62
user 36.15
sys 34.96
hbarta@orcus:~$ 

hbarta@orcus:~$ time -p stir_pool.sh >log/$(date +%Y-%m-%d-%H%M)_stir.txt 2>&1
real 89.30
user 36.89
sys 41.47
hbarta@orcus:~$
```

Repeat `syncoid`

```text
hbarta@orcus:~$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 81.88
user 4.38
sys 18.49
hbarta@orcus:~$ 
```

Observations:

* It takes about 90s to stir the pool.
* `syncoid` takes about 50s following a single stir and 82s following two stir passes.

## 2025-02-04 errors produced

The first log to report errors is `2025-02-04-1618.syncoid.59.txt` and it also reports

```text
ending incremental send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-04:16:12:41-GMT-06:00 ... syncoid_orcus_2025-02-04:16:18:43-GMT-06:00 (~ 20.8 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_22:15:50_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_1/l2_1 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_1'@'syncoid_orcus_2025-02-04:16:12:41-GMT-06:00' 'send/test/l0_1/l1_1/l2_1'@'syncoid_orcus_2025-02-04:16:18:43-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 21847088 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_orcus_2025-02-04:16:12:43-GMT-06:00 ... syncoid_orcus_2025-02-04:16:18:43-GMT-06:00 (~ 21.8 MB):
```

And full status was 

```text
eal 59.00
user 4.86
sys 19.78
errors: List of errors unavailable: permission denied
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
  scan: scrub repaired 0B in 00:16:15 with 0 errors on Tue Feb  4 12:19:17 2025
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d40878f8e  ONLINE       0     0     0

errors: 1 data errors, use '-v' for a list
```

[Full flie list](./data.md#2025-02-04-full-log-file-list)

[List of all syncoid logs](./data.md#2025-02-04-list-of-all-syncoid-logs)

There were a total of 197 syncoid runs and corruption was first noted on the 175th pass. The number cascaded on subsequent passes.

```text
hbarta@orcus:~/logs$ grep "use '-v'" *syncoid*
2025-02-04-1618.syncoid.59.txt:errors: 1 data errors, use '-v' for a list
2025-02-04-1624.syncoid.53.txt:errors: 34 data errors, use '-v' for a list
2025-02-04-1630.syncoid.25.txt:errors: 74 data errors, use '-v' for a list
2025-02-04-1636.syncoid.28.txt:errors: 452 data errors, use '-v' for a list
2025-02-04-1642.syncoid.22.txt:errors: 974 data errors, use '-v' for a list
2025-02-04-1648.syncoid.25.txt:errors: 1130 data errors, use '-v' for a list
2025-02-04-1654.syncoid.25.txt:errors: 1215 data errors, use '-v' for a list
2025-02-04-1700.syncoid.26.txt:errors: 1227 data errors, use '-v' for a list
2025-02-04-1706.syncoid.24.txt:errors: 1229 data errors, use '-v' for a list
2025-02-04-1712.syncoid.25.txt:errors: 1231 data errors, use '-v' for a list
2025-02-04-1718.syncoid.24.txt:errors: 1232 data errors, use '-v' for a list
2025-02-04-1724.syncoid.24.txt:errors: 1233 data errors, use '-v' for a list
2025-02-04-1730.syncoid.23.txt:errors: 1264 data errors, use '-v' for a list
2025-02-04-1736.syncoid.25.txt:errors: 1295 data errors, use '-v' for a list
2025-02-04-1742.syncoid.24.txt:errors: 1295 data errors, use '-v' for a list
2025-02-04-1748.syncoid.25.txt:errors: 1296 data errors, use '-v' for a list
2025-02-04-1754.syncoid.25.txt:errors: 1296 data errors, use '-v' for a list
2025-02-04-1800.syncoid.26.txt:errors: 1297 data errors, use '-v' for a list
hbarta@orcus:~/logs$ 
```

Log files around the time of the first detected corruption were:

```text
-rw-r--r-- 1 hbarta hbarta 499171 Feb  4 16:07 2025-02-04-1607.stir_pools.57.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 16:12 2025-02-04-1612.syncoid.58.txt
-rw-r--r-- 1 hbarta hbarta 491105 Feb  4 16:14 2025-02-04-1614.stir_pools.58.txt
-rw-r--r-- 1 hbarta hbarta   7762 Feb  4 16:19 2025-02-04-1618.syncoid.59.txt               <<< first corruption
-rw-r--r-- 1 hbarta hbarta 495515 Feb  4 16:22 2025-02-04-1621.stir_pools.59.txt
-rw-r--r-- 1 hbarta hbarta  10028 Feb  4 16:24 2025-02-04-1624.syncoid.53.txt
-rw-r--r-- 1 hbarta hbarta 493205 Feb  4 16:29 2025-02-04-1628.stir_pools.59.txt
```

Observations:

* Previous stir started at 1614 and lasted about a minute.
* Problem `syncoid` started at 1618, 4 minutes past the stir.
* Previous scrub completed at 12:19:17 and was the last scrub performed. These were scheduled 4x daily.
* `sanoid` runs on fifteen minute schedule and would have completed well before these operations (including the previous `syncoid`) completed. The closest timing overlay was the stir at 1614 completing 2 seconds before sanoid ran. It seems likely that caches might still be in flight to the HDD.
* Testing began at 2140 the previous day and the first corruption was noted at 1614. This is a vast improvement over "a couple days."


All operations including `syncoid`, `sanoid`, stir and scrub were halted as soon as corruption was noticed.
