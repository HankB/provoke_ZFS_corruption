# Results: Git bisect 0.8.6 to 2.0.0 - testing tenth bisect

* [Data](./data.md)
* [Setup](./setup.md)

## 2025-04-08 zpool status

```text
hbarta@orion:~/logs$ zpool status
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
errors: List of errors unavailable: permission denied

errors: 1 data errors, use '-v' for a list
hbarta@orion:~/logs$ sudo zpool status
[sudo] password for hbarta: 
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

errors: 1 data errors, use '-v' for a list
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

        send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-08:00:28:41-GMT-05:00:<0x0>
hbarta@orion:~/logs$ 
```

[last syncoid](./data.md#2025-04-08-last-syncoid)