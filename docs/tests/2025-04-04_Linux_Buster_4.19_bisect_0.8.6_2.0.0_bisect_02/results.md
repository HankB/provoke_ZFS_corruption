# Results: Git bisect 0.8.6 to 2.0.0 - testing second bisect

* [Data](./data.md)
* [Setup](./setup.md)

Corruption in about half an hour. Monitor output

```text
hbarta@orion:~$ monitor.sh 
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
   see: https://zfsonlinux.org/msg/ZFS-8000-8A
  scan: none requested
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0
errors: List of errors unavailable: permission denied

errors: 6 data errors, use '-v' for a list

list

NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   283G   181G        -         -    11%    60%  1.00x    ONLINE  -
send   464G   298G   166G        -         -    17%    64%  1.00x    ONLINE  -

send snapshot count
3172

recv snapshot count
3094
hbarta@orion:~$
```

[`syncoid` run](./data.md#2025-04-04-last-syncoid) that reported errors.
