# 2025-02-05 Setup

* [Results](./results.md)

Continue exploration of methodology. Results from 2025-02-03 tests prove that this H/W setup can reproduce the issue and can do more in less time with increased activity.

## 2025-02-05 Plan

The previous test identified a possible scenario whereby creating snapshots immediately following a stir resulted in corruption in the following send. Suggestions at <https://github.com/openzfs/zfs/issues/12014#issuecomment-2636245924> indicated that it may not be necessary to use `sanoid` and `syncoid` to provoke the issue. This test will explore that option. Scripts and operation will be modified to:

* Run continuously. Initially the stir -> snapshot -> send actions will be executed serially but a further refinement could be to run some in parallel.
* Detect the first sign of corruption and halt testing operations.
* ZFS send and snapshot operations will be executed directly.
* The existing setup including 6.1 kernel and 2.1.11 will be reused as it has proven to produce corruption. The pools will be destroyed and recreated.

Recording versions

```text
root@orcus:~# zfs --version
zfs-2.1.11-1+deb12u1
zfs-kmod-2.1.11-1+deb12u1
root@orcus:~# uname -a
Linux orcus 6.1.0-30-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.124-1 (2025-01-12) x86_64 GNU/Linux
root@orcus:~# 
```

## 2025-02-05 recreate pools

```text
zpool destroy send

zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O encryption=aes-256-gcm  -O keylocation=file:///pool-key -O keyformat=raw \
      -O mountpoint=/mnt/send \
      send wwn-0x5002538d40878f8e
zfs load-key -a
chmod a+rwx /mnt/send/
```

`zpool destroy send` has been running about 10 minutes and with `top` reporting ~19% IO wait. Time to reboot, requiring a power cycle to complete. And then no LAN bnecause `enp0s7` (or whatever) was now `eth1`. Following reboot `send` and `recv` pools were destroyed in <1s.

Kick off populate operation.

```text
time -p /home/hbarta/provoke_ZFS_corruption/scripts/populate_pool.sh
```

And killed when `send` hit 60% in `zpool list`.

```
root@orcus:/home/hbarta# time -p /home/hbarta/provoke_ZFS_corruption/scripts/populate_pool.sh
...
real 2861.59
user 77.86
sys 2752.91
root@orcus:/home/hbarta# 

root@orcus:~# find /mnt/send -type f | wc -l
57170
root@orcus:~# find /mnt/send -type d | wc -l
38
root@orcus:~# 
root@orcus:~# chown hbarta:hbarta -R /mnt/send
```

Create the `recv` pool and kick off the first send as root.

```text
zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O mountpoint=/mnt/recv \
      recv wwn-0x5002538d41628a33
chmod a+rwx /mnt/recv/

user=hbarta
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    send
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    recv

time -p syncoid --recursive --no-privilege-elevation send/test recv/test
```


Create new script `thrash_zfs.sh` to drive ZFS activity. For now it will

* perform the stir
* check for corruption
* take a (ZFS) recursive snapshot
* send recursively to `recv` using `syncoid` (*)
* check for corruption

Sending incrementally to `/dev/null` is a bit trickier because the previous snapshot needs to be identified. That's left to a future enhancement if desired.

Tests kicked off on 2025-02-05 aboutr 1815.

## 2025-02-06 no corruption yet

Serial "thrashing" with 655 passes. Now working on scripts to decouple and run some operations in parallel. Will recreate the pools, clear the logs and restart using the same OS install. `stir` and `snapshot` will go in one script and `syncoid` in another. The `send` pool now has nearly 12K snapshots so a third script will be provided to trim snapshots as this might also be a part of the pattern. Also seeing that pools are now at 90% capacity. Reducing snapshots to 100 for each filesystem brings pool capacity on `recv` down to 70% - 10% higher than the fresh pool. That seems reasonable.

Recreate pools as above. Killed populate at 63%. Kicking off the first syncoid now (1130).

```text
root@orcus:/home/hbarta# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 4221.88
user 44.40
sys 2279.22
root@orcus:/home/hbarta# 
```

And as a user

```text
hbarta@orcus:~$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 12.41
user 3.51
sys 6.12
hbarta@orcus:~$ 
```

Enabling scrub in root `cron`.

```text
3 */3 * * * /sbin/zpool scrub send recv
```

Starting 3 tmux sessions to run the following commands

```text
thrash_stir.sh
thrash_syncoid.sh
do_trim_snaps.sh # (looping every 60s)
```

Thrashing kicked off about 1330. Ran wrong commands and had to reboot. To get things back up

```text
zfs load-key -a
zfs mount -a
```
