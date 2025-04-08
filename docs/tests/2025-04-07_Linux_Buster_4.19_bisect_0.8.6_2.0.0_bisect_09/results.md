# Setup: Git bisect 0.8.6 to 2.0.0 - testing ninth bisect

* [Setup](./setup.md)
* [Data](./data.md)

## post sanoid zpool ststus

```text
hbarta@orion:~$ zpool status send
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

errors: 2 data errors, use '-v' for a list
hbarta@orion:~$ sudo zpool status send
[sudo] password for hbarta: 
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

errors: 2 data errors, use '-v' for a list
hbarta@orion:~$ sudo zpool status send -v
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

        send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-07:17:35:34-GMT-05:00:<0x0>
        send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-07:17:35:54-GMT-05:00:<0x0>
hbarta@orion:~$ 
```

[last syncoid log](./data.md#2025-04-07-last-syncoid)