# Results: Git bisect 0.8.6 to 2.0.0 - testing fifth bisect

* [Data](./data.md)
* [Setup](./setup.md)

[Output of the last `syncoid` run](./data.md#2025-04-05-last-syncoid)

Non-priviledged invocation reports 83 (now 84) permanent errors

```text
hbarta@orion:~/logs$ zpool status send
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
errors: List of errors unavailable: permission denied

errors: 84 data errors, use '-v' for a list
hbarta@orion:~/logs$ 
```

Priviledged reports only 5 and `-v` lists 7 files.

```text
hbarta@orion:~/logs$ sudo zpool status send
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

errors: 5 data errors, use '-v' for a list
hbarta@orion:~/logs$ 
hbarta@orion:~/logs$ sudo zpool status send -v
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

        send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-05:13:18:53-GMT-05:00:<0x0>
        send/test/l0_1/l1_1/l2_1@1743877119.2025-04-05-1318:<0x0>
        send/test/l0_1/l1_1@syncoid_orion_2025-04-05:13:18:51-GMT-05:00:<0x0>
        send/test/l0_1/l1_0/l2_0@1743877074.2025-04-05-1317:<0x0>
        send/test/l0_1/l1_0/l2_3@1743877074.2025-04-05-1317:<0x0>
hbarta@orion:~/logs$ 
```
