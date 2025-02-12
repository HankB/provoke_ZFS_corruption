# FreeBSD test results

* [Data](./data.md)
* [Setup](./setup.md)

This test was performed similarly to the Linux tests after the scripts had been trweaked. Unfortunately the time a d date on the host was not correct and this was not noticed until well after the tests had run. The results are being analyzed on Tuesday 2025-02-11 and the tests were performed over the previous weekend.

## 2025-02-11 corruption confirmed

The processes that stirred the pool and invoked `syncoid` terminated as desired but the loop that managed snapshots continued (with no effect other than to query snapshots.) The test was under way at 2025-02-04-1027 (local time on the host) and corruption was detected at 2025-02-04-2003. In other words it took about ten hours to produce corruption. Full pool status was:

```text
root@vulcan:~ # zpool status send -v
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
  scan: scrub repaired 0B in 01:32:28 with 0 errors on Tue Feb  4 16:46:00 2025
config:

        NAME        STATE     READ WRITE CKSUM
        send        ONLINE       0     0     0
          da1p1     ONLINE       0     0     0

errors: Permanent errors have been detected in the following files:

root@vulcan:~ # 
```

There was a warning in the `syncoid` record that seems not to provide much information.

```text
...
Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_vulcan_2025-02-04:20:00:32-GMT00:00 ... syncoid_vulcan_2025-02-04:20:02:12-GMT00:00 (~ 24.5 M
B):
warning: cannot send 'send/test/l0_1/l1_0/l2_3@syncoid_vulcan_2025-02-04:20:02:12-GMT00:00': Invalid argument
Sending incremental send/test/l0_1/l1_1@syncoid_vulcan_2025-02-04:20:00:34-GMT00:00 ... syncoid_vulcan_2025-02-04:20:02:15-GMT00:00 (~ 22.5 MB):
...
```

Due to the time required to produce desired results, further testing on FreeBSD (at least hosting on a Pi 4B) is not a high priority.
