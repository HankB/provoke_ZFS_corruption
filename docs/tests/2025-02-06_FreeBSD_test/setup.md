# 2025-02-06 Setup

* [Results](./results.md)
* [Data](./data.md)

The purpose of this test is to see if FreeBSD (which uses the same ZFS code base as Linux) is also subject to this corruption.

## Plan

This work is being recorded in a separate `git` branch `FreeBSD` because it is not know if it is going to produce useful results.

Install FreeBSD on a Pi 4B and repeat tests using the scripts employed on Linux. The scripts required some tweaking and an additional script was added `manage_snaps.sh` to loop the snapshot script.

* Pi 4B with 4GB RAM
* Powered hub
* 120GB Kingston SSD for system disk.
* 1TB Samsung 850 EVO for pools.
* reeBSD 15.0-CURRENT (hostname `vulcan`)

In order to boot it was necessary to apply a fix described in <https://forums.freebsd.org/threads/bug-freebsd-14-2-raspberry-pi-4-with-4gb-wont-boot.96643>. The pools that existed on the 1TB SSD could not easily be mounted so the drive was repartitioned and new pools created.

```text
root@vulcan:~ # gpart show da1
=>        40  1953525088  da1  GPT  (932G)
          40   977272832    1  freebsd-zfs  (466G)
   977272872   976252256    2  freebsd-zfs  (466G)

root@vulcan:~ # 
```

ZFS version is:

```text
root@vulcan:~ # zfs --version
zfs-2.3.99-170-FreeBSD_g34205715e
zfs_version_kernel() failed: No such file or directory
root@vulcan:~ # 
```

```text
dd if=/dev/urandom bs=32 count=1 of=/pool-key
dev=da1p1
zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O encryption=aes-256-gcm  -O keylocation=file:///pool-key -O keyformat=raw \
      -O mountpoint=/mnt/send \
      send $dev
zfs load-key -a
chmod a+rwx /mnt/send/
```

```text
dev=da1p2
zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O mountpoint=/mnt/recv \
      recv $dev
chmod a+rwx /mnt/recv/

user=hbarta
zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    send
zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    recv

time -p syncoid --recursive --no-privilege-elevation send/test recv/test
```

First `syncoid` [produced an error](./data.md#2025-02-05-first-syncoid). Second syncoid (run as user) completed the mirroring of `send` to `recv` and the third completed w/out any reported issues.

## 2025-02-10 tweaking and testing proceeded.

Existing scripts were tweaked to run on FreeBSD (still using `bash`.) After the run was complete (and corruption was detected) a script was added `manage_snaps.sh` to terminate the snapshot processing after corruption was detected.

See [Results](./results.md) for more detail on the results.
