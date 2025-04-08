# Setup: Git bisect 0.8.6 to 2.0.0 - testing eleventh bisect

* [Data](./data.md)
* [Results](./results.md)

## 2025-04-08 remove ZFS

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

Bisect

```text
hbarta@orion:~/zfs$ git bisect bad
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[c1b5801bb5af0055e5f3d263beaa07026103e212] Minimize aggsum_compare(&arc_size, arc_c) calls.
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
zfs-0.8.0-71_gc1b5801bb
zfs-kmod-0.8.0-71_gc1b5801bb
hbarta@orion:~/zfs$ ls -l $(find /usr/lib -name zfs.ko)
-rw-r--r-- 1 root root 66355120 Apr  8 07:54 /usr/lib/modules/4.19.0-27-amd64/extra/zfs/zfs.ko
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

### Create pools

```text
dd if=/dev/urandom bs=32 count=1 of=/pool-key 
sudo zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O encryption=aes-256-gcm  -O keylocation=file:///pool-key -O keyformat=raw \
      -O mountpoint=/mnt/send \
      send wwn-0x5002538d41628a33
sudo zfs load-key -a

sudo zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O mountpoint=/mnt/recv \
      recv wwn-0x5002538d40878f8e
```

```text
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   516K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   696K   464G        -         -     0%     0%  1.00x    ONLINE  -
root@orion:~# 
```

### prepare for testing

```text
root@orion:~# time -p /home/hbarta/provoke_ZFS_corruption/scripts/populate_pool.sh
...
Capacity target 50 met
real 2284.89
user 68.56
sys 2266.59
root@orion:~# 
```

First syncoid as root:

```text
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
```


[first syncoid log](./data.md#2025-04-08-first-syncoid)

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
real 12.59
user 3.01
sys 7.88
hbarta@orion:~/zfs$ 
```

Prepare logs, confirm `sanoid.timer` is disabled.

```text
cd
mkdir /mnt/storage/logs.2025-04-08_Linux_Buster_4.19_bisect_11/
rm /home/hbarta/logs
ln -s /mnt/storage/logs.2025-04-08_Linux_Buster_4.19_bisect_11 /home/hbarta/logs
ls -l logs/*
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

Thrashing began at 1003

