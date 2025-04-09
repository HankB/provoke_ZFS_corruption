# Results: Git bisect 0.8.6 to 2.0.0 - testing tenth bisect

* [Setup](./setup.md)
* [Data](./data.md)

## 2025-04-08 no corruption produced

No curruption was detected during 12 hours of testing. Final check (which should probably be added to the process)

```text
hbarta@orion:~/logs$ grep -i err *.txt |grep -v "No known"
2025-04-08-215439.syncoid.txt:CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_1'@'syncoid_orion_2025-04-08:21:52:34-GMT-05:00' 'send/test/l0_0/l1_2/l2_1'@'syncoid_orion_2025-04-08:21:56:25-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 116587376 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_1' 2>&1 failed: 2
2025-04-08-215439.syncoid.txt:CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_3'@'syncoid_orion_2025-04-08:21:52:50-GMT-05:00' 'send/test/l0_0/l1_2/l2_3'@'syncoid_orion_2025-04-08:21:56:36-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 115775264 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_3' 2>&1 failed: 2
hbarta@orion:~/logs$ 
```

These "ERROR" reports resulted from killing the last `syncoid` process using `<ctrl>c` at the console. A subsequent scrub of both pools detected no corruption.

```text
hbarta@orion:~/logs$ sudo zpool scrub recv send
hbarta@orion:~/logs$ watch -n 10 zpool status
hbarta@orion:~/logs$ zpool status
  pool: recv
 state: ONLINE
  scan: scrub repaired 0B in 0 days 00:15:12 with 0 errors on Wed Apr  9 06:42:08 2025
config:

        NAME                      STATE     READ WRITE CKSUM
        recv                      ONLINE       0     0     0
          wwn-0x5002538d40878f8e  ONLINE       0     0     0

errors: No known data errors

  pool: send
 state: ONLINE
  scan: scrub repaired 0B in 0 days 00:18:06 with 0 errors on Wed Apr  9 06:45:03 2025
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: No known data errors
hbarta@orion:~/logs$ 
```
