# SetResultsup: Commit 30af21b test with modified pool settings

* [Data](./data.md)
* [Results](./results.md)
* [home/index](./../../index.md)

# 2025-04-10 corruption detected

after 3 hours of thrashing.

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

errors: 4 data errors, use '-v' for a list
hbarta@orion:~/logs$ 
```

More detail in [Data](./data.md#2025-04-10-last-syncoid)
