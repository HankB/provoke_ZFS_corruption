# Linux Trixie 2.3.0 patched results

* [Setup](./setup.md)
* [Data](./data.md)

Corruption in about 2 hours.

```text
hbarta@orion:~$ monitor.sh 
status
  pool: recv
 state: ONLINE
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
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: 3 data errors, use '-v' for a list

list

NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   277G   187G        -         -    16%    59%  1.00x    ONLINE  -
send   464G   284G   180G        -         -    23%    61%  1.00x    ONLINE  -

send snapshot count
3203

recv snapshot count
3146
hbarta@orion:~$ sudo zpool status -v send
[sudo] password for hbarta: 
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: Permanent errors have been detected in the following files:

hbarta@orion:~$ 
```

It appears that corruption was recognized by the stir process while syncoid was running. Looking at the time stamps it appears that the sequence was:

|time|process milestone|
|---|---|
|214148|syncoid start|
|214319|syncoid finish|
|214319|stir start|
|214319|syncoid start|
|214350|stir finish|
|214433|syncoid finish|

[longer log file list](./data.md#2025-02-24-last-several-log-files-before-termination)

Two timestamps in the `halt_test.txt` correspond to the stir and syncoid finish times respectively.

```text
hbarta@orion:~/logs$ cat halt_test.txt 
2025-02-24-214350
2025-02-24-214433
hbarta@orion:~/logs$ 
```'

Error messages from the syncoid log are:

```text
Sending incremental send/test/l0_0/l1_1@syncoid_orion_2025-02-24:21:42:08-GMT-06:00 ... syncoid_orion_2025-02-24:21:43:39-GMT-06:00 (~ 68.0 MB):
warning: cannot send 'send/test/l0_0/l1_1@1740454999.2025-02-24-2143': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_1 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1'@'syncoid_orion_2025-02-24:21:42:08-GMT-06:00' 'send/test/l0_0/l1_1'@'syncoid_orion_2025-02-24:21:43:39-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 71339856 |  zfs receive  -s -F 'recv/test/l0_0/l1_1' 2>&1 failed: 256 at /usr/sbin/syncoid line 889.

...
Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-02-24:21:42:17-GMT-06:00 ... syncoid_orion_2025-02-24:21:43:46-GMT-06:00 (~ 67.4 MB):
warning: cannot send 'send/test/l0_0/l1_1/l2_2@1740454999.2025-02-24-2143': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_1/l2_2 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_2'@'syncoid_orion_2025-02-24:21:42:17-GMT-06:00' 'send/test/l0_0/l1_1/l2_2'@'syncoid_orion_2025-02-24:21:43:46-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 70724720 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_2' 2>&1 failed: 256 at /usr/sbin/syncoid line 889.
```

[full log](./data.md#2025-02-24-syncoid-with-errors-reported)
