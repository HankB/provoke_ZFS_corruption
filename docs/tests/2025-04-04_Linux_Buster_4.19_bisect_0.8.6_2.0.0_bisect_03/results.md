# rRsults: Git bisect 0.8.6 to 2.0.0 - testing second bisect

* [Setup](./setup.md)
* [Data](./data.md)

Corruption detected in just shy of 3 hours. Monitor and `zpool status -v` output:

```text
hbarta@orion:~/logs$ monitor.sh
status
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

errors: 3 data errors, use '-v' for a list

list

NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   281G   183G        -         -    14%    60%  1.00x    ONLINE  -
send   464G   298G   166G        -         -    22%    64%  1.00x    ONLINE  -

send snapshot count
3148

recv snapshot count
3118
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

        send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-04:19:02:08-GMT-05:00:<0x0>
        send/test/l0_1/l1_0/l2_2@1743811299.2025-04-04-1901:<0x0>
        send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-04:19:02:28-GMT-05:00:<0x0>
hbarta@orion:~/logs$ 
```