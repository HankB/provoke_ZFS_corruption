# results 

Test started at about 2025-04-02-134319 and finished 2025-04-02-155133 with corruption detected - a bit over 2 hours. Output from `monitor.sh`:

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
errors: List of errors unavailable: permission denied

errors: 2 data errors, use '-v' for a list

list

NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   279G   185G        -         -    15%    60%  1.00x    ONLINE  -
send   464G   286G   178G        -         -    21%    61%  1.00x    ONLINE  -

send snapshot count
3234

recv snapshot count
3176
hbarta@orion:~$ 
```

The [last syncoid](./data.md#2025-04-02-1551-last-syncoid) run reports errors which correspond to these errors:

```text
root@orion:~# zpool status -v send
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

        send/test/l0_1/l1_0@syncoid_orion_2025-04-02:15:53:05-GMT-05:00:<0x0>
        send/test/l0_0/l1_2/l2_0@1743627129.2025-04-02-1552:<0x0>
root@orion:~# 
```
