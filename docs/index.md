# Blog version of provoke_ZFS_corruption

* Original bug: <https://github.com/openzfs/zfs/issues/12014>
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
|2025-02-24||[corruption in 2 hours](./tests/2025-02-23_Linux_Bookworm_Trixie_2.3.0/results.md)|2.3.0-1|Debian Trixie|6.12.12-amd64
|2025-02-24||[corruption in 2 hours](./tests/2025-02-24_Linux_Trixie_2.3.0_patched/results.md)|2.3.0-1+patch|Debian Trixie|6.12.12-amd64	||
|2025-02-25||[set aside](./tests/2025-02-26_Linux_Trixie_2.3.0_bzfs/setup.md#2025-02-26-results)|2.3.0-1|Debian Trixie|6.12.12-amd64|
|2025-04-02|2025-04-02|[corruption in 2 hours](./tests/2025-04-02_Linux_Buster_4.19_bisect_0.8.6_2.0.0_bad/results.md)|2.0.0-1|Debian 10|4.19.0-27-amd64|Confirm that 4.19 + 2.0.0 results in corruption|
|2025-04-02|2025-04-03|[no corruption after 12 hours](./tests/2025-04-02_Linux_Buster_4.19_bisect_0.8.6_2.0.0_good/results.md)|0.8.6|Debian 10|4.19.0-27-amd64|Confirm that 4.19 + 0.8.6 does not cause corruption|
|2025-04-03|2025-04-04|[no corruption after 20 hours](./tests/2025-04-02_Linux_Buster_4.19_bisect_0.8.6_2.0.0_bisect_01/results.md)|78fac8d925fdd64584292fbda4ed9e3e2bbaae66|Debian 10|4.19.0-27-amd64|first bisect between 2.0.0 and 0.8.6, |
|2025-04-03|2025-04-04|[corruption after 2 1/2 hours](./tests/2025-04-04_Linux_Buster_4.19_bisect_0.8.6_2.0.0_bisect_02/results.md)|327000ce04b4243f140a38647dca59683d39b8e7|Debian 10|4.19.0-27-amd64|2nd bisect |
|2025-04-04|2025-04-04|[corruption after 2:50](./tests/2025-04-04_Linux_Buster_4.19_bisect_0.8.6_2.0.0_bisect_03/results.md)|eedb3a62b9f16b989aa02d00db63de5dff200572|Debian 10|4.19.0-27-amd64|3rd bisect |
|2025-04-04|2025-04-05|[corruption after 2 1/2 hours](./tests/2025-04-04_Linux_Buster_4.19_bisect_0.8.6_2.0.0_bisect_04/results.md)|1e620c98727a5a5cff1af70fef9bc25626b4e9d8|Debian 10|4.19.0-27-amd64|4th bisect |
|2025-04-05|2025-04-05|[corruption after 3+ hours](./tests/2025-04-05_Linux_Buster_4.19_bisect_0.8.6_2.0.0_bisect_05/results.md)|a64f8276c7c2e121f438866d2f91ddff22031e7f|Debian 10|4.19.0-27-amd64|5th bisect |
|2025-04-05|2025-04-06|[no corruption after 12+ hours](./tests/2025-04-05_Linux_Buster_4.19_bisect_0.8.6_2.0.0_bisect_06/results.md)|8e91c5ba6a1b2c607a1ed4a0a42b2d07eca13091|Debian 10|4.19.0-27-amd64|6th bisect|
|2025-04-06|2025-04-06|[no corruption after 11:30 hours](./tests/2025-04-06_Linux_Buster_4.19_bisect_0.8.6_2.0.0_bisect_07/results.md)|d9cd66e45f285356624d26eb92e10e2baf2738ee|Debian 10|4.19.0-27-amd64|7th bisect |
|2025-04-06||[in progress](./tests/2025-04-06_Linux_Buster_4.19_bisect_0.8.6_2.0.0_bisect_08/setup.md)|b1b4ac27082aede8522e479c87897026519f1dd7|Debian 10|4.19.0-27-amd64|7th bisect|

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
