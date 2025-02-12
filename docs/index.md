# Blog version of provoke_ZFS_corruption

* Github: <https://github.com/HankB/provoke_ZFS_corruption/tree/main>
* Blog: <https://HankB.github.io/provoke_ZFS_corruption/>
* [Update on methodology](./methodology.md)

Directory of tests starting with preliminary exploration.

|started|completed|results|ZFS ver|OS|kernel ver|notes|
|---|---|---|---|---|---|---|
|2025-02-03|2025-02-04|[corruption](./tests/2025-02-03_methodology/results.md)|zfs-2.1.11-1+deb12u1|Debian 12|6.1.0-30-amd64|methodology exploration|
|2025-02-05||[corruption in 15 minutes](./tests/2025-02-05_methodology/results.md)|zfs-2.1.11-1+deb12u1|Debian 12|6.1.0-30-amd64|methodology exploration|


## 2025-02-04 process improvements

These have worked, producing corruption in less than a day. This should shorten testing time and also proves that the H/W in use will produce corruption using current Debian kernel and ZFS. [More details](./tests/2025-02-03_methodology/results.md)

## 2025-02-11 Test instructions

Configure a host and two pools `send` and `recv`. Review the scripts that will be used as my user name `hbarta` has been hard coded in too many places. (PRs to corract that gratefully accepted.)

0. Run the `populate_pool.sh` script as `root` to populate the send pool. It does not terminate when there is sufficient data and will need to be killed when the `send` pool reaches about 50% capacity. The easiest way to kill it is to find the PID of the script and `kill <PID>` as root.
1. Run `syncoid` as `root` manually once to mirror `send` to `recv`. Set permissions or ownership on the resulting files in `send` to allow user modification.
1. Execute `zfs allow` as `root` to provide appropriate permissions so that `syncoid` can run as your user.
1. Create a directory `~/logs` where the scripts will write logs.
1. Start the following three scripts. (I hard link them to the user `~/bin` directory for convenience but it is left to the user to make them available in the PATH.)

* `thrash_stir.sh` - This script will modify random files in the pool continuously and also capture recursive snapshots.
* `thrash_syncoid.sh` - This script will invoke `syncoid` continuously.
* `manage_snaps.sh` - This script will manage snapshots every minute to limit retained snapshots to 100 for each dataset.

All three scripts will check for and exit when corruption is detected. In addition I add a cron job as `root` to `zpool scrub` both pools several times/day.

For details on the exact commands used to prepare the test, please see [the methodology exploration](./tests/2025-02-05_methodology/setup.md).
