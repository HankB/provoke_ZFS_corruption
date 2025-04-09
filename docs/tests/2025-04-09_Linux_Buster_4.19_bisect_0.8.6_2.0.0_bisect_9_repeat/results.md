# Results: Git bisect 0.8.6 to 2.0.0 - testing tenth bisect - repeat

* [Data](./data.md)
* [Setup](./setup.md)
* [home/index](./../../index.md)

## 2025-04-09 corruption detected

After 3 hours. [Last syncoid run](./data.md#2025-04-09-last-syncoid)

```text
hbarta@orion:~/logs$ sudo zpool status -v
  pool: recv
 state: ONLINE
  scan: none requested
config:

        NAME                      STATE     READ WRITE CKSUM
        recv                      ONLINE       0     0     0
          wwn-0x5002538d40878f8e  ONLINE       0     0     0

errors: No known data errors

  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: http://zfsonlinux.org/msg/ZFS-8000-8A
  scan: none requested
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: Permanent errors have been detected in the following files:

        send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-09:12:42:26-GMT-05:00:<0x0>
        send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-09:12:43:10-GMT-05:00:<0x0>
        send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-09:12:43:27-GMT-05:00:<0x0>
hbarta@orion:~/logs$ 
```

## All logs reporting errors

```text
hbarta@orion:~/logs$ grep -i err *.txt|grep -v "No known"
2025-04-09-124137.syncoid.111.txt:internal error: Invalid argument
2025-04-09-124137.syncoid.111.txt:CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_1'@'syncoid_orion_2025-04-09:12:40:37-GMT-05:00' 'send/test/l0_0/l1_2/l2_1'@'syncoid_orion_2025-04-09:12:42:26-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 72004328 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_1' 2>&1 failed: 256
2025-04-09-124137.syncoid.111.txt:internal error: Invalid argument
2025-04-09-124137.syncoid.111.txt:CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_1'@'syncoid_orion_2025-04-09:12:41:16-GMT-05:00' 'send/test/l0_1/l1_0/l2_1'@'syncoid_orion_2025-04-09:12:43:10-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 70354904 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_1' 2>&1 failed: 256
2025-04-09-124137.syncoid.111.txt:internal error: Invalid argument
2025-04-09-124137.syncoid.111.txt:CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_1'@'syncoid_orion_2025-04-09:12:41:34-GMT-05:00' 'send/test/l0_1/l1_1/l2_1'@'syncoid_orion_2025-04-09:12:43:27-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 47064624 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_1' 2>&1 failed: 256
2025-04-09-124137.syncoid.111.txt:errors: List of errors unavailable: permission denied
2025-04-09-124137.syncoid.111.txt:status: One or more devices has experienced an error resulting in data
2025-04-09-124137.syncoid.111.txt:errors: 3 data errors, use '-v' for a list
2025-04-09-124212.stir_pools.44.txt:errors: List of errors unavailable: permission denied
2025-04-09-124212.stir_pools.44.txt:status: One or more devices has experienced an error resulting in data
2025-04-09-124212.stir_pools.44.txt:errors: 1 data errors, use '-v' for a list
2025-04-09-124231.trim_snaps.17.txt:errors: List of errors unavailable: permission denied
2025-04-09-124231.trim_snaps.17.txt:status: One or more devices has experienced an error resulting in data
2025-04-09-124231.trim_snaps.17.txt:errors: 1 data errors, use '-v' for a list
hbarta@orion:~/logs$ 
```
