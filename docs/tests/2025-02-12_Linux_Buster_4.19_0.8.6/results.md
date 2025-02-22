# Linux Buster 4.19 and 0.8.6 results

This test is terminated as unable to reproduce corruption. There were over 3200 `syncoid` runs during the test

```text
hbarta@orion:~/logs$ ls *syncoid* | wc -l
3243
hbarta@orion:~/logs$ 
```

* [Setup](./setup.md)
* [Data](./data)

```text
hbarta@orion:~$ uname -a
Linux orion 4.19.0-27-amd64 #1 SMP Debian 4.19.316-1 (2024-06-25) x86_64 GNU/Linux
hbarta@orion:~$ zfs --version
zfs-0.8.6-1
zfs-kmod-0.8.6-1
hbarta@orion:~$ uptime
 16:46:57 up 9 days, 17:43,  5 users,  load average: 9.58, 9.81, 9.99
hbarta@orion:~$ monitor.sh 
status
  pool: recv
 state: ONLINE
  scan: scrub repaired 0B in 0 days 00:21:06 with 0 errors on Sat Feb 22 16:32:07 2025
config:

        NAME                      STATE     READ WRITE CKSUM
        recv                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: No known data errors

  pool: send
 state: ONLINE
  scan: scrub repaired 0B in 0 days 00:34:19 with 0 errors on Sat Feb 22 16:45:22 2025
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d40878f8e  ONLINE       0     0     0

errors: No known data errors

list

NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   416G  48.1G        -         -    62%    89%  1.00x    ONLINE  -
send   464G   420G  43.6G        -         -    64%    90%  1.00x    ONLINE  -

send snapshoput count
4793

recv snapshoput count
5270
hbarta@orion:~$ 
```

No corruption. Pools started about 70% and snapshots pushed that to about 90%. At the end of the test the processes were taking a lot longer to complete. The last number in the log file name is the number of seconds that the process took to complete.

* stir 70-80s to 110

```text
hbarta@orion:~/logs$ ls -l *stir*|head -20
-rw-r--r-- 1 hbarta hbarta 512930 Feb 13 12:17 2025-02-13-1216.stir_pools.83.txt
-rw-r--r-- 1 hbarta hbarta 509944 Feb 13 12:18 2025-02-13-1217.stir_pools.78.txt
-rw-r--r-- 1 hbarta hbarta 515453 Feb 13 12:20 2025-02-13-1218.stir_pools.73.txt
-rw-r--r-- 1 hbarta hbarta 514144 Feb 13 12:21 2025-02-13-1220.stir_pools.72.txt
-rw-r--r-- 1 hbarta hbarta 510970 Feb 13 12:22 2025-02-13-1221.stir_pools.71.txt
-rw-r--r-- 1 hbarta hbarta 515071 Feb 13 12:23 2025-02-13-1222.stir_pools.71.txt
-rw-r--r-- 1 hbarta hbarta 516809 Feb 13 12:24 2025-02-13-1223.stir_pools.68.txt
-rw-r--r-- 1 hbarta hbarta 517039 Feb 13 12:25 2025-02-13-1224.stir_pools.68.txt
-rw-r--r-- 1 hbarta hbarta 511562 Feb 13 12:27 2025-02-13-1225.stir_pools.68.txt
-rw-r--r-- 1 hbarta hbarta 514566 Feb 13 12:28 2025-02-13-1227.stir_pools.67.txt
-rw-r--r-- 1 hbarta hbarta 514695 Feb 13 12:29 2025-02-13-1228.stir_pools.66.txt
-rw-r--r-- 1 hbarta hbarta 514625 Feb 13 12:30 2025-02-13-1229.stir_pools.65.txt
-rw-r--r-- 1 hbarta hbarta 520061 Feb 13 12:31 2025-02-13-1230.stir_pools.66.txt
-rw-r--r-- 1 hbarta hbarta 512031 Feb 13 12:32 2025-02-13-1231.stir_pools.63.txt
-rw-r--r-- 1 hbarta hbarta 520577 Feb 13 12:33 2025-02-13-1232.stir_pools.64.txt
-rw-r--r-- 1 hbarta hbarta 516852 Feb 13 12:34 2025-02-13-1233.stir_pools.63.txt
-rw-r--r-- 1 hbarta hbarta 528422 Feb 13 12:35 2025-02-13-1234.stir_pools.64.txt
-rw-r--r-- 1 hbarta hbarta 517758 Feb 13 12:36 2025-02-13-1235.stir_pools.62.txt
-rw-r--r-- 1 hbarta hbarta 518327 Feb 13 12:37 2025-02-13-1236.stir_pools.62.txt
-rw-r--r-- 1 hbarta hbarta 520463 Feb 13 12:38 2025-02-13-1237.stir_pools.62.txt
hbarta@orion:~/logs$ ls -l *stir*|tail -20
-rw-r--r-- 1 hbarta hbarta 514673 Feb 22 16:15 2025-02-22-1613.stir_pools.94.txt
-rw-r--r-- 1 hbarta hbarta 509461 Feb 22 16:17 2025-02-22-1615.stir_pools.99.txt
-rw-r--r-- 1 hbarta hbarta 517003 Feb 22 16:18 2025-02-22-1617.stir_pools.100.txt
-rw-r--r-- 1 hbarta hbarta 519387 Feb 22 16:20 2025-02-22-1618.stir_pools.103.txt
-rw-r--r-- 1 hbarta hbarta 514881 Feb 22 16:22 2025-02-22-1620.stir_pools.103.txt
-rw-r--r-- 1 hbarta hbarta 518175 Feb 22 16:24 2025-02-22-1622.stir_pools.104.txt
-rw-r--r-- 1 hbarta hbarta 512403 Feb 22 16:25 2025-02-22-1624.stir_pools.104.txt
-rw-r--r-- 1 hbarta hbarta 509928 Feb 22 16:27 2025-02-22-1625.stir_pools.102.txt
-rw-r--r-- 1 hbarta hbarta 514810 Feb 22 16:29 2025-02-22-1627.stir_pools.108.txt
-rw-r--r-- 1 hbarta hbarta 517100 Feb 22 16:31 2025-02-22-1629.stir_pools.105.txt
-rw-r--r-- 1 hbarta hbarta 516738 Feb 22 16:33 2025-02-22-1631.stir_pools.104.txt
-rw-r--r-- 1 hbarta hbarta 515468 Feb 22 16:35 2025-02-22-1633.stir_pools.108.txt
-rw-r--r-- 1 hbarta hbarta 508971 Feb 22 16:36 2025-02-22-1635.stir_pools.109.txt
-rw-r--r-- 1 hbarta hbarta 511838 Feb 22 16:38 2025-02-22-1636.stir_pools.105.txt
-rw-r--r-- 1 hbarta hbarta 517076 Feb 22 16:40 2025-02-22-1638.stir_pools.106.txt
-rw-r--r-- 1 hbarta hbarta 515480 Feb 22 16:42 2025-02-22-1640.stir_pools.99.txt
-rw-r--r-- 1 hbarta hbarta 513686 Feb 22 16:44 2025-02-22-1642.stir_pools.105.txt
-rw-r--r-- 1 hbarta hbarta 515413 Feb 22 16:45 2025-02-22-1644.stir_pools.110.txt
-rw-r--r-- 1 hbarta hbarta 515908 Feb 22 16:47 2025-02-22-1645.stir_pools.116.txt
-rw-r--r-- 1 hbarta hbarta 349264 Feb 22 16:48 2025-02-22-1647.stir_pools.txt
hbarta@orion:~/logs$ 
```

* syncoid ~25 to ~250s

Extremely long durations were while the pools were being scrubbed.

```text
hbarta@orion:~/logs$ ls -l *syncoid*|head -20
-rw-r--r-- 1 hbarta hbarta 8519 Feb 13 12:17 2025-02-13-1216.syncoid.35.txt
-rw-r--r-- 1 hbarta hbarta 8428 Feb 13 12:17 2025-02-13-1217.syncoid.22.txt
-rw-r--r-- 1 hbarta hbarta 8452 Feb 13 12:18 2025-02-13-1217.syncoid.26.txt
-rw-r--r-- 1 hbarta hbarta 8424 Feb 13 12:19 2025-02-13-1218.syncoid.22.txt
-rw-r--r-- 1 hbarta hbarta 8459 Feb 13 12:18 2025-02-13-1218.syncoid.27.txt
-rw-r--r-- 1 hbarta hbarta 8461 Feb 13 12:20 2025-02-13-1219.syncoid.27.txt
-rw-r--r-- 1 hbarta hbarta 8428 Feb 13 12:20 2025-02-13-1220.syncoid.22.txt
-rw-r--r-- 1 hbarta hbarta 8461 Feb 13 12:21 2025-02-13-1220.syncoid.26.txt
-rw-r--r-- 1 hbarta hbarta 8461 Feb 13 12:20 2025-02-13-1220.syncoid.29.txt
-rw-r--r-- 1 hbarta hbarta 8434 Feb 13 12:21 2025-02-13-1221.syncoid.25.txt
-rw-r--r-- 1 hbarta hbarta 8474 Feb 13 12:22 2025-02-13-1221.syncoid.30.txt
-rw-r--r-- 1 hbarta hbarta 8460 Feb 13 12:22 2025-02-13-1222.syncoid.28.txt
-rw-r--r-- 1 hbarta hbarta 8459 Feb 13 12:23 2025-02-13-1222.syncoid.32.txt
-rw-r--r-- 1 hbarta hbarta 8432 Feb 13 12:24 2025-02-13-1223.syncoid.28.txt
-rw-r--r-- 1 hbarta hbarta 8470 Feb 13 12:23 2025-02-13-1223.syncoid.29.txt
-rw-r--r-- 1 hbarta hbarta 8439 Feb 13 12:25 2025-02-13-1224.syncoid.28.txt
-rw-r--r-- 1 hbarta hbarta 8497 Feb 13 12:24 2025-02-13-1224.syncoid.36.txt
-rw-r--r-- 1 hbarta hbarta 8442 Feb 13 12:26 2025-02-13-1225.syncoid.27.txt
-rw-r--r-- 1 hbarta hbarta 8495 Feb 13 12:25 2025-02-13-1225.syncoid.37.txt
-rw-r--r-- 1 hbarta hbarta 8468 Feb 13 12:27 2025-02-13-1226.syncoid.31.txt
hbarta@orion:~/logs$ ls -l *syncoid*|tail -20
-rw-r--r-- 1 hbarta hbarta 8597 Feb 22 15:00 2025-02-22-1455.syncoid.255.txt
-rw-r--r-- 1 hbarta hbarta 8597 Feb 22 15:04 2025-02-22-1500.syncoid.255.txt
-rw-r--r-- 1 hbarta hbarta 8597 Feb 22 15:08 2025-02-22-1504.syncoid.257.txt
-rw-r--r-- 1 hbarta hbarta 8597 Feb 22 15:13 2025-02-22-1508.syncoid.278.txt
-rw-r--r-- 1 hbarta hbarta 8597 Feb 22 15:17 2025-02-22-1513.syncoid.263.txt
-rw-r--r-- 1 hbarta hbarta 8597 Feb 22 15:21 2025-02-22-1517.syncoid.247.txt
-rw-r--r-- 1 hbarta hbarta 8597 Feb 22 15:26 2025-02-22-1521.syncoid.265.txt
-rw-r--r-- 1 hbarta hbarta 8597 Feb 22 15:30 2025-02-22-1526.syncoid.254.txt
-rw-r--r-- 1 hbarta hbarta 8597 Feb 22 15:34 2025-02-22-1530.syncoid.266.txt
-rw-r--r-- 1 hbarta hbarta 8597 Feb 22 15:39 2025-02-22-1534.syncoid.264.txt
-rw-r--r-- 1 hbarta hbarta 8597 Feb 22 15:43 2025-02-22-1539.syncoid.255.txt
-rw-r--r-- 1 hbarta hbarta 8597 Feb 22 15:47 2025-02-22-1543.syncoid.250.txt
-rw-r--r-- 1 hbarta hbarta 8597 Feb 22 15:51 2025-02-22-1547.syncoid.258.txt
-rw-r--r-- 1 hbarta hbarta 8597 Feb 22 15:56 2025-02-22-1551.syncoid.257.txt
-rw-r--r-- 1 hbarta hbarta 8597 Feb 22 16:00 2025-02-22-1556.syncoid.262.txt
-rw-r--r-- 1 hbarta hbarta 8597 Feb 22 16:05 2025-02-22-1600.syncoid.271.txt
-rw-r--r-- 1 hbarta hbarta 8597 Feb 22 16:09 2025-02-22-1605.syncoid.264.txt
-rw-r--r-- 1 hbarta hbarta 8699 Feb 22 16:33 2025-02-22-1609.syncoid.1433.txt
-rw-r--r-- 1 hbarta hbarta 8641 Feb 22 16:46 2025-02-22-1633.syncoid.796.txt
-rw-r--r-- 1 hbarta hbarta 4870 Feb 22 16:49 2025-02-22-1646.syncoid.txt
hbarta@orion:~/logs$ 
```

* trim ~2s to ~60s

```text
hbarta@orion:~/logs$ ls -l *trim*|head -20
-rw-r--r-- 1 hbarta hbarta  4190 Feb 13 12:17 2025-02-13-1217.trim_snaps.1.txt
-rw-r--r-- 1 hbarta hbarta  4190 Feb 13 12:18 2025-02-13-1218.trim_snaps.1.txt
-rw-r--r-- 1 hbarta hbarta  4190 Feb 13 12:19 2025-02-13-1219.trim_snaps.1.txt
-rw-r--r-- 1 hbarta hbarta  4190 Feb 13 12:20 2025-02-13-1220.trim_snaps.1.txt
-rw-r--r-- 1 hbarta hbarta  4190 Feb 13 12:21 2025-02-13-1221.trim_snaps.1.txt
-rw-r--r-- 1 hbarta hbarta  4190 Feb 13 12:22 2025-02-13-1222.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta  4190 Feb 13 12:23 2025-02-13-1223.trim_snaps.1.txt
-rw-r--r-- 1 hbarta hbarta  4190 Feb 13 12:24 2025-02-13-1224.trim_snaps.1.txt
-rw-r--r-- 1 hbarta hbarta  4190 Feb 13 12:25 2025-02-13-1225.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta  4190 Feb 13 12:26 2025-02-13-1226.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta  4190 Feb 13 12:27 2025-02-13-1227.trim_snaps.1.txt
-rw-r--r-- 1 hbarta hbarta  4190 Feb 13 12:28 2025-02-13-1228.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta  4190 Feb 13 12:29 2025-02-13-1229.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta  4190 Feb 13 12:30 2025-02-13-1230.trim_snaps.1.txt
-rw-r--r-- 1 hbarta hbarta  4190 Feb 13 12:31 2025-02-13-1231.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta  4190 Feb 13 12:33 2025-02-13-1232.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta  4190 Feb 13 12:34 2025-02-13-1234.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta  4190 Feb 13 12:35 2025-02-13-1235.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta  4190 Feb 13 12:36 2025-02-13-1236.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta  4190 Feb 13 12:37 2025-02-13-1237.trim_snaps.3.txt
hbarta@orion:~/logs$ ls -l *trim*|tail -20
-rw-r--r-- 1 hbarta hbarta 10800 Feb 22 15:38 2025-02-22-1537.trim_snaps.53.txt
-rw-r--r-- 1 hbarta hbarta 13476 Feb 22 15:40 2025-02-22-1539.trim_snaps.65.txt
-rw-r--r-- 1 hbarta hbarta 10982 Feb 22 15:42 2025-02-22-1541.trim_snaps.53.txt
-rw-r--r-- 1 hbarta hbarta 13410 Feb 22 15:44 2025-02-22-1543.trim_snaps.63.txt
-rw-r--r-- 1 hbarta hbarta 11101 Feb 22 15:46 2025-02-22-1545.trim_snaps.53.txt
-rw-r--r-- 1 hbarta hbarta 13205 Feb 22 15:48 2025-02-22-1547.trim_snaps.62.txt
-rw-r--r-- 1 hbarta hbarta 10870 Feb 22 15:50 2025-02-22-1549.trim_snaps.57.txt
-rw-r--r-- 1 hbarta hbarta 12622 Feb 22 15:52 2025-02-22-1551.trim_snaps.60.txt
-rw-r--r-- 1 hbarta hbarta 11762 Feb 22 15:54 2025-02-22-1553.trim_snaps.57.txt
-rw-r--r-- 1 hbarta hbarta 10031 Feb 22 15:56 2025-02-22-1555.trim_snaps.39.txt
-rw-r--r-- 1 hbarta hbarta 13752 Feb 22 15:58 2025-02-22-1557.trim_snaps.63.txt
-rw-r--r-- 1 hbarta hbarta 10866 Feb 22 16:00 2025-02-22-1559.trim_snaps.54.txt
-rw-r--r-- 1 hbarta hbarta 13420 Feb 22 16:02 2025-02-22-1601.trim_snaps.66.txt
-rw-r--r-- 1 hbarta hbarta 10850 Feb 22 16:04 2025-02-22-1603.trim_snaps.57.txt
-rw-r--r-- 1 hbarta hbarta 12266 Feb 22 16:06 2025-02-22-1605.trim_snaps.66.txt
-rw-r--r-- 1 hbarta hbarta 11943 Feb 22 16:08 2025-02-22-1607.trim_snaps.59.txt
-rw-r--r-- 1 hbarta hbarta 11267 Feb 22 16:10 2025-02-22-1609.trim_snaps.55.txt
-rw-r--r-- 1 hbarta hbarta 28521 Feb 22 16:31 2025-02-22-1611.trim_snaps.1218.txt
-rw-r--r-- 1 hbarta hbarta 92892 Feb 22 16:49 2025-02-22-1632.trim_snaps.1034.txt
-rw-r--r-- 1 hbarta hbarta 13994 Feb 22 16:51 2025-02-22-1650.trim_snaps.txt
hbarta@orion:~/logs$ 
```

