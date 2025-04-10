# Results: Git bisect 0.8.6 to 2.0.0 - testing tenth bisect - repeat

* [Data](./data.md)
* [Setup](./setup.md)
* [home/index](./../../index.md)

Corruption was detected after 3 hours of testing. 

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

        send/test/l0_0/l1_3/l2_0@autosnap_2025-04-09_21:30:57_frequently:<0x0>
        send/test/l0_0/l1_0/l2_0@autosnap_2025-04-09_21:30:57_frequently:<0x0>
        send/test/l0_0/l1_0/l2_2@autosnap_2025-04-09_21:30:57_frequently:<0x0>
        send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-09:21:31:26-GMT-05:00:<0x0>
        send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-09:21:32:20-GMT-05:00:<0x0>
        send/test/l0_0/l1_3/l2_0@1744252255.2025-04-09-2130:<0x0>
        send/test/l0_0/l1_0/l2_2@1744252255.2025-04-09-2130:<0x0>
        send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-09:21:32:23-GMT-05:00:<0x0>
        send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-09:21:32:28-GMT-05:00:<0x0>
hbarta@orion:~/logs$ 
```

```text
hbarta@orion:~/logs$ grep -i err *.txt|grep -v "No known"
2025-04-09-213055.stir_pools.43.txt:errors: List of errors unavailable: permission denied
2025-04-09-213055.stir_pools.43.txt:status: One or more devices has experienced an error resulting in data
2025-04-09-213055.stir_pools.43.txt:errors: 4 data errors, use '-v' for a list
2025-04-09-213057.syncoid.93.txt:internal error: Invalid argument
2025-04-09-213057.syncoid.93.txt:CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_2'@'syncoid_orion_2025-04-09:21:29:13-GMT-05:00' 'send/test/l0_0/l1_0/l2_2'@'syncoid_orion_2025-04-09:21:31:15-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 61328160 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_2' 2>&1 failed: 256
2025-04-09-213057.syncoid.93.txt:internal error: Invalid argument
2025-04-09-213057.syncoid.93.txt:CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_0'@'syncoid_orion_2025-04-09:21:29:25-GMT-05:00' 'send/test/l0_0/l1_1/l2_0'@'syncoid_orion_2025-04-09:21:31:26-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 69892568 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_0' 2>&1 failed: 256
2025-04-09-213057.syncoid.93.txt:internal error: Invalid argument
2025-04-09-213057.syncoid.93.txt:CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_0'@'syncoid_orion_2025-04-09:21:30:04-GMT-05:00' 'send/test/l0_0/l1_3/l2_0'@'syncoid_orion_2025-04-09:21:31:59-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 48899176 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_0' 2>&1 failed: 256
2025-04-09-213057.syncoid.93.txt:warning: cannot send 'send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-09:21:32:20-GMT-05:00': Input/output error
2025-04-09-213057.syncoid.93.txt:CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_2'@'syncoid_orion_2025-04-09:21:30:38-GMT-05:00' 'send/test/l0_1/l1_0/l2_2'@'syncoid_orion_2025-04-09:21:32:20-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 47487688 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_2' 2>&1 failed: 256
2025-04-09-213057.syncoid.93.txt:internal error: Invalid argument
2025-04-09-213057.syncoid.93.txt:CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_3'@'syncoid_orion_2025-04-09:21:30:42-GMT-05:00' 'send/test/l0_1/l1_0/l2_3'@'syncoid_orion_2025-04-09:21:32:23-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 47340048 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_3' 2>&1 failed: 256
2025-04-09-213057.syncoid.93.txt:warning: cannot send 'send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-09:21:32:28-GMT-05:00': Input/output error
2025-04-09-213057.syncoid.93.txt:CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_0'@'syncoid_orion_2025-04-09:21:30:50-GMT-05:00' 'send/test/l0_1/l1_1/l2_0'@'syncoid_orion_2025-04-09:21:32:28-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 23750832 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_0' 2>&1 failed: 256
2025-04-09-213057.syncoid.93.txt:errors: List of errors unavailable: permission denied
2025-04-09-213057.syncoid.93.txt:status: One or more devices has experienced an error resulting in data
2025-04-09-213057.syncoid.93.txt:errors: 9 data errors, use '-v' for a list
hbarta@orion:~/logs$ 
```

[Last symcoid](./data.md#2025-04-09-last-syncoid)
