# Blog version of provoke_ZFS_corruption

* Original bug: <https://github.com/openzfs/zfs/issues/12014>
* Github: <https://github.com/HankB/provoke_ZFS_corruption/tree/main>
* Blog: <https://HankB.github.io/provoke_ZFS_corruption/>
* [Update on methodology](./methodology.md)

Preliminary results of the bisect are [below](#2025-04-08-bisect-conclusion). There has been discussion during the testing at <https://github.com/openzfs/zfs/discussions/17203> and per suggestion, I will be repeating the test on 30af21b02569ac192f52ce6e6511015f8a8d5729. I have also add some further verification to the results for the final "good" test.

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
|2025-04-06|2025-04-07|[no corruption during flawed test](./tests/2025-04-06_Linux_Buster_4.19_bisect_0.8.6_2.0.0_bisect_08/results.md)|b1b4ac27082aede8522e479c87897026519f1dd7|Debian 10|4.19.0-27-amd64|8th bisect|
|2025-04-07|2025-04-07|[corruption after 3 hours](./tests/2025-04-07_Linux_Buster_4.19_bisect_0.8.6_2.0.0_bisect_09/results.md)|0b755ec3d5ba531d2662da54fb9ac62627ce2c66|Debian 10|4.19.0-27-amd64|9th bisect|
|2025-04-07|2025-04-08|[corruption after about 2 1/2 hours](./tests/2025-04-07_Linux_Buster_4.19_bisect_0.8.6_2.0.0_bisect_10/results.md)|30af21b02569ac192f52ce6e6511015f8a8d5729|Debian 10|4.19.0-27-amd64|10th bisect|
|2025-04-07|2025-04-08|[no corruption after 12 hours](./tests/2025-04-08_Linux_Buster_4.19_bisect_0.8.6_2.0.0_bisect_11/results.md)|c1b5801bb5af0055e5f3d263beaa07026103e212|Debian 10|4.19.0-27-amd64|11th bisect|

## 2025-04-08 bisect conclusion

Assuming the tests have successfully identified corruption, the result of the bisect is:

```text
hbarta@orion:~/zfs$ git bisect good
30af21b02569ac192f52ce6e6511015f8a8d5729 is the first bad commit
commit 30af21b02569ac192f52ce6e6511015f8a8d5729
Author: Paul Dagnelie <pcd@delphix.com>
Date:   Wed Jun 19 09:48:13 2019 -0700

    Implement Redacted Send/Receive
    
    Redacted send/receive allows users to send subsets of their data to
    a target system. One possible use case for this feature is to not
    transmit sensitive information to a data warehousing, test/dev, or
    analytics environment. Another is to save space by not replicating
    unimportant data within a given dataset, for example in backup tools
    like zrepl.
    
    Redacted send/receive is a three-stage process. First, a clone (or
    clones) is made of the snapshot to be sent to the target. In this
    clone (or clones), all unnecessary or unwanted data is removed or
    modified. This clone is then snapshotted to create the "redaction
    snapshot" (or snapshots). Second, the new zfs redact command is used
    to create a redaction bookmark. The redaction bookmark stores the
    list of blocks in a snapshot that were modified by the redaction
    snapshot(s). Finally, the redaction bookmark is passed as a parameter
    to zfs send. When sending to the snapshot that was redacted, the
    redaction bookmark is used to filter out blocks that contain sensitive
    or unwanted information, and those blocks are not included in the send
    stream.  When sending from the redaction bookmark, the blocks it
    contains are considered as candidate blocks in addition to those
    blocks in the destination snapshot that were modified since the
    creation_txg of the redaction bookmark.  This step is necessary to
    allow the target to rehydrate data in the case where some blocks are
    accidentally or unnecessarily modified in the redaction snapshot.
    
    The changes to bookmarks to enable fast space estimation involve
    adding deadlists to bookmarks. There is also logic to manage the
    life cycles of these deadlists.
    
    The new size estimation process operates in cases where previously
    an accurate estimate could not be provided. In those cases, a send
    is performed where no data blocks are read, reducing the runtime
    significantly and providing a byte-accurate size estimate.
    
    Reviewed-by: Dan Kimmel <dan.kimmel@delphix.com>
    Reviewed-by: Matt Ahrens <mahrens@delphix.com>
    Reviewed-by: Prashanth Sreenivasa <pks@delphix.com>
    Reviewed-by: John Kennedy <john.kennedy@delphix.com>
    Reviewed-by: George Wilson <george.wilson@delphix.com>
    Reviewed-by: Chris Williamson <chris.williamson@delphix.com>
    Reviewed-by: Pavel Zhakarov <pavel.zakharov@delphix.com>
    Reviewed-by: Sebastien Roy <sebastien.roy@delphix.com>
    Reviewed-by: Prakash Surya <prakash.surya@delphix.com>
    Reviewed-by: Brian Behlendorf <behlendorf1@llnl.gov>
    Signed-off-by: Paul Dagnelie <pcd@delphix.com>
    Closes #7958

:040000 040000 22bddd232c24007744e929e18259e69cc01be8da 603ec1aaef6c1a7fab80168a9b5309f89fe13c5d M      cmd
:100644 100644 db614084e37e3edbeef28f0430e85f41a0b46ac8 e0349a18219a5d12b0f1fdcb9b13ad079083d741 M      configure.ac
:040000 040000 13ca95901c67684f0cdc178dc08e4e2c4f8a0f21 a31bf2b7324d52a429c7accfd2d482edbc9f742d M      include
:040000 040000 f82837df7ff2132fcc3bb39c6ef925776cce2dcc a90467d84951a2c93f5bf0c02c12108855d995e6 M      lib
:040000 040000 45d76cb23df175339c0624121e17b4a30f85ad41 3e3a905736d37756b766573b876c75b66084923b M      man
:040000 040000 6ab2cf3acb56bf25c7b5762d8e7d205b1d9d47f7 ce8fe30aac453c96dc5875839b67d49a4ea63f0f M      module
:040000 040000 9c3cc75a332d4b006ceb5a7b282a298ac8ecd704 937acde4124386561528a96e2869a98d9dea0aaa M      tests
hbarta@orion:~/zfs$
```

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
