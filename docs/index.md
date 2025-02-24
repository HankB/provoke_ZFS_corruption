# Blog version of provoke_ZFS_corruption

* Github: <https://github.com/HankB/provoke_ZFS_corruption/tree/main>
* Blog: <https://HankB.github.io/provoke_ZFS_corruption/>
* [Update on methodology](./methodology.md)

Directory of tests starting with preliminary exploration.

|started|completed|results|ZFS ver|OS|kernel ver|notes|
|---|---|---|---|---|---|---|
|2025-02-03|2025-02-04|[corruption](./tests/2025-02-03_methodology/results.md)|zfs-2.1.11-1+deb12u1|Debian 12|6.1.0-30-amd64|methodology exploration|
|2025-02-05|2025-02-05|[corruption in 15 minutes](./tests/2025-02-05_methodology/results.md)|zfs-2.1.11-1+deb12u1|Debian 12|6.1.0-30-amd64|methodology exploration|
|2025-02-07|2025-02-07|[corruption in 10 hours](./tests/2025-02-06_FreeBSD_test/results.md)|zfs-2.3.99-170-FreeBSD_g34205715e|15.0-CURRENT FreeBSD|main-n275087-cdacb12065e4|FreeBSD on Pi 4B|
|2025-02-11|2025-02-11|[corruption in 2 hours](./tests/2025-02-11_Linux_Repeat/results.md)|zfs-2.1.11-1+deb12u1|Debian 12|6.1.0-30-amd64|repeat methodology exploration, test FreeBSD tweaks|
|2025-02-12|2025-02-12|[corruption instantly [1]](./tests/2025-02-11_Linux_Buster_5.10_2.0.3/results.md)|zfs-2.0.3-9~bpo10+1|Debian 10|5.10.0-0.deb10.24-amd64|repeat previous tests using new methodology|
|2025-02-11|2025-02-22|[no corruption](./tests/2025-02-12_Linux_Buster_4.19_0.8.6/results.md)|zfs-0.8.6-1|Debian 10|4.19.0-27-amd64|demonstrate no corruption with 0.8.6|
|2025-02-22|2025-02-23|[corruption in 2 hours](./tests/2025-02-22_Linux_Buster_2.0.0_local_build/results.md)|zfs-2.0.0-1|Debian 10|4.19.0-27-amd64|first image restore test|
|2025-02-22||[deferred](./tests/2025-02-23_Linux_Buster_2.0.0_patched/setup.md)|zfs-2.0.0-1|Debian 10|4.19.0-27-amd64|unable to resolve symbol issue|
|2025-02-24||[in progress](./tests/2025.02.23_Linux_Bookworm_Trixie_2.3.0/setup.md)|2.3.0-1|Debian Trixie|6.12.12-amd64

* `[1]` Test ran for hours w/ wrong ownership and the stir process changed nothing. When file ownership was fixed, corruption was nearly instant.

## 2025-02-04 process improvements

These have worked, producing corruption in less than a day. This should shorten testing time and also proves that the H/W in use will produce corruption using current Debian kernel and ZFS. [More details](./tests/2025-02-03_methodology/results.md) In addition, the scripts have been tweaked to work on FreeBSD (with `bash`) and corruption was produced on a FreeBSD host.

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
