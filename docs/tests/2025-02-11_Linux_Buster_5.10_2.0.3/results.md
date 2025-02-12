# Linux Buster kernel 5.10.0 with ZFS 2.0.3

* [Data](./data.md)
* [Setup](./setup.md)

Repeating previous test which did not provoke corruption after over a week. This one got off to a missed start due to ownership for files in the `send` pool. Once that was fixed, corruption was produced almost immediately. Among the log files, the issue was fixed during the run that produced `2025-02-12-1510.stir_pools.38.txt` which started at 1510 and corruptio0n was identified at 1511. Woof! One wonders if this pattern (delaying permissions for a while) has anything to do with that.

## 2025-02-12 corruption produced.

```text
root@orcus:~# zpool status -v send
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
          wwn-0x5002538d40878f8e  ONLINE       0     0     0

errors: Permanent errors have been detected in the following files:

        send/test/l0_1/l1_0/l2_1@syncoid_orcus_2025-02-12:15:11:30-GMT-06:00:<0x0>
        send/test/l0_1/l1_1/l2_3@syncoid_orcus_2025-02-12:15:11:41-GMT-06:00:<0x0>
        send/test/l0_1/l1_1@1739392002.2025-02-12-1426:<0x0>
        send/test/l0_1/l1_1/l2_1@1739392002.2025-02-12-1426:<0x0>
        send/test/l0_1/l1_0/l2_3@1739391975.2025-02-12-1426:<0x0>
        send/test/l0_1/l1_1@1739391975.2025-02-12-1426:<0x0>
        send/test/l0_1/l1_1/l2_0@1739391975.2025-02-12-1426:<0x0>
        send/test/l0_1/l1_1/l2_3@1739391975.2025-02-12-1426:<0x0>
        send/test/l0_1/l1_2/l2_3@syncoid_orcus_2025-02-12:15:11:48-GMT-06:00:<0x0>
        send/test/l0_1/l1_1/l2_1@1739391975.2025-02-12-1426:<0x0>
        send/test/l0_1/l1_1/l2_2@1739391975.2025-02-12-1426:<0x0>
        send/test/l0_0/l1_3/l2_3@syncoid_orcus_2025-02-12:15:11:23-GMT-06:00:<0x0>
        send/test/l0_1/l1_1/l2_2@syncoid_orcus_2025-02-12:15:11:40-GMT-06:00:<0x0>
root@orcus:~# 
```

`monitor.sh` output

```text
hbarta@orcus:~/logs$ monitor.sh 
status
  pool: recv
 state: ONLINE
config:

        NAME                      STATE     READ WRITE CKSUM
        recv                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

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
          wwn-0x5002538d40878f8e  ONLINE       0     0     0
errors: List of errors unavailable: permission denied

errors: 13 data errors, use '-v' for a list

list

NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   327G   137G        -         -     1%    70%  1.00x    ONLINE  -
send   464G   328G   136G        -         -     1%    70%  1.00x    ONLINE  -

send snapshoput count
4361

recv snapshoput count
4258
hbarta@orcus:~/logs$
```
