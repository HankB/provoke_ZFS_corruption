# Results: Git bisect 0.8.6 to 2.0.0 - testing eighth bisect

* [Data](./data.md)
* [Setup](./setup.md)

## 2025-04-07 no corruption, but ...

This test was problematic in that all ZFS commands required root. That required some ad-hoc script and commands to get it started and then one aspect (the custom snapshot management) was overlooked until morning. At that tome the pool was full and some snapshots were failing due to lack of space. Snapshot management was rerun with appropriate privileges and took quite a while to get things back to normal. Other processes were not paused so this loaded the storage system heavily. Following that the system was allowed to continue running for several hours longer just to confirm the "no corruption" detected.

Before stopping the test, an additional command `zpool trim send` was executed. Before starting the next iteration, the `set -x` flag will be removed from the scripts where it was left in in order to make it easier to look for errors. Searching for "No space" in the log files indicates that the pool became full about 0500.

[final pool status](./data.md#2024-04-07-final-pool-status)
