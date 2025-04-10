# Setup: Commit 30af21b test with modified pool settings

* [Data](./data.md)
* [Results](./results.md)
* [home/index](./../../index.md)

Suggestion at <https://github.com/openzfs/zfs/discussions/17203#discussioncomment-12778088> to disable the following:

```text
bookmark_written
redaction_bookmarks
redacted_datasets
```

## 2025-04-09 remove ZFS

```text
cd ~/zfs
sudo make uninstall
ls -l $(find /usr/lib -name zfs.ko)
lsmod|grep zfs # shows ZFS modules still in kernel.
reboot
lsmod|grep zfs # no ZFS modules
```

Confirm kernel and modules

```text
hbarta@orion:~$ lsmod|grep zfs # no ZFS modules
hbarta@orion:~$ uname -a
Linux orion 4.19.0-27-amd64 #1 SMP Debian 4.19.316-1 (2024-06-25) x86_64 GNU/Linux
hbarta@orion:~$ 
```

Checkout

```text
hbarta@orion:~/zfs$ git checkout 30af21b
HEAD is now at 30af21b02 Implement Redacted Send/Receive
hbarta@orion:~/zfs$ 
```

Build

```text
make distclean
sh autogen.sh
./configure
time -p make -s -j$(nproc)
sudo make install
sudo ldconfig
sudo modprobe zfs
zfs --version
ls -l $(find /usr/lib -name zfs.ko)
```

```text
hbarta@orion:~/zfs$ zfs --version
zfs-0.8.0-72_g30af21b02
zfs-kmod-0.8.0-72_g30af21b02
hbarta@orion:~/zfs$ ls -l $(find /usr/lib -name zfs.ko)
-rw-r--r-- 1 root root 67454008 Apr 10 09:37 /usr/lib/modules/4.19.0-27-amd64/extra/zfs/zfs.ko
hbarta@orion:~/zfs$ 
```

Secure erase targets (after confirming that `/dev/sdc` is still the boot drive.)

```text
sudo -s
hdparm --user-master u --security-set-pass Eins /dev/sda
hdparm --security-erase Eins /dev/sda
hdparm --user-master u --security-set-pass Eins /dev/sdb
hdparm --security-erase Eins /dev/sdb
```

```text
dd if=/dev/urandom bs=32 count=1 of=/pool-key 
sudo zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O encryption=aes-256-gcm  -O keylocation=file:///pool-key -O keyformat=raw \
      -O mountpoint=/mnt/send \
      -o feature@bookmark_written=disabled \
      -o feature@redaction_bookmarks=disabled \
      -o feature@redacted_datasets=disabled \
      send wwn-0x5002538d41628a33
sudo zfs load-key -a

sudo zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O mountpoint=/mnt/recv \
      recv wwn-0x5002538d40878f8e
```

```text
root@orion:~# zpool get feature@bookmark_written,feature@redaction_bookmarks,feature@redacted_datasets send
NAME  PROPERTY                     VALUE                        SOURCE
send  feature@bookmark_written     disabled                     local
send  feature@redaction_bookmarks  disabled                     local
send  feature@redacted_datasets    disabled                     local
root@orion:~# 
```

[All pool settings](./data.md#2025-04-10-all-pool-send-settings)

### prepare for testing

```text
root@orion:~# time -p /home/hbarta/provoke_ZFS_corruption/scripts/populate_pool.sh
...
Capacity target 50 met
real 2308.08
user 68.72
sys 2291.17
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   564K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   239G   225G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# 
```

First syncoid as root:

```text
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 2021.14
user 28.73
sys 1952.83
root@orion:~# 
```

[first syncoid log](./data.md#2025-04-10-first-syncoid)

Perms and related:

```text
user=hbarta
chown -R $user:$user /mnt/send/ /mnt/recv/
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    send
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    recv
```

Repeat `syncoid` as user.

```text
hbarta@orion:~/zfs$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 13.50
user 3.12
sys 4.73
hbarta@orion:~/zfs$ 
```

Prepare logs, confirm `sanoid.timer` is disabled.

```text
cd
mkdir /mnt/storage/logs.2025-04-10_Linux_Buster_4.19_30af21b_pool_settings_1/
rm /home/hbarta/logs
ln -s /mnt/storage/logs.2025-04-10_Linux_Buster_4.19_30af21b_pool_settings_1 /home/hbarta/logs
systemctl status sanoid.timer
```

### start thrashing

```text
tmux new -D -s "stir" thrash_stir.sh
tmux new -D -s syncoid thrash_syncoid.sh
tmux new -D -s snaps manage_snaps.sh
tmux new -D -s sanoid sudo /home/hbarta/bin/thrash_sanoid.sh
watch -n 30 /home/hbarta/bin/monitor.sh
```

Testing started about 1217 and corruption detected at 1518.
