# Results: Git bisect 0.8.6 to 2.0.0 - testing fourth bisect

* [Data](./data.md)
* [Setup](./setup.md)

Corruption detected in about 2 1/2 hours.

```text
hbarta@orion:~/logs$ sudo zpool status -v send
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

errors: Permanent errors have been detected in the following files:

        send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-05:01:14:58-GMT-05:00:<0x0>
        send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-05:01:15:11-GMT-05:00:<0x0>
        send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-05:01:14:24-GMT-05:00:<0x0>
hbarta@orion:~/logs$ 
```
