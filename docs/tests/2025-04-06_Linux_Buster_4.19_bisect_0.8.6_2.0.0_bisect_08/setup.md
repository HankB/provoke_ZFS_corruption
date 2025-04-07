# Setup: Git bisect 0.8.6 to 2.0.0 - testing eighth bisect

* [Data](./data.md)
* [Results](./results.md)

## 2025-04-05 remove ZFS

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
hbarta@orion:~/zfs$ git bisect good
Bisecting: 9 revisions left to test after this (roughly 3 steps)
[b1b4ac27082aede8522e479c87897026519f1dd7] Python config cleanup
hbarta@orion:~/zfs$ 
```

Build and install

```text
make distclean
sh autogen.sh
./configure
time -p make -s -j$(nproc)
sudo make install
sudo ldconfig
sudo modprobe zfs
```

```text
hbarta@orion:~$ zfs --version
zfs-0.8.0-70_gb1b4ac270
zfs-kmod-0.8.0-60_gd9cd66e45
hbarta@orion:~$ 
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
recv   464G  1.05M   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   684K   464G        -         -     0%     0%  1.00x    ONLINE  -
root@orion:~# 
```

### prepare for testing

```text
root@orion:~# time -p /home/hbarta/provoke_ZFS_corruption/scripts/populate_pool.sh
...
Capacity target 50 met
+ exit
real 2293.37
user 69.54
sys 2276.31
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   576K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   238G   226G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# 
```

[First syncoid (as root)](./data.md)

```text
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 1992.24
user 27.12
sys 1924.31
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   238G   226G        -         -     0%    51%  1.00x    ONLINE  -
send   464G   238G   226G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# 
```

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

Repeat `syncoid` as user. Or not.

```text
hbarta@orion:~$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
WARNING: ZFS resume feature not available on source and target machine - sync will continue without resume support.
Permission denied the ZFS utilities must be run as root.
CRITICAL ERROR: no datasets found
real 0.15
user 0.13
sys 0.02
hbarta@orion:~$ 
```

Prepare logs, confirm `sanoid.timer` is disabled.

```text
cd
mkdir /mnt/storage/logs.2025-04-06_Linux_Buster_4.19_bisect_8/
rm /home/hbarta/logs
ln -s /mnt/storage/logs.2025-04-06_Linux_Buster_4.19_bisect_8 /home/hbarta/logs
systemctl status sanoid.timer
```

### start thrashing

```text
tmux new -D -s "stir" thrash_stir.sh
tmux new -D -s syncoid thrash_syncoid.sh
tmux new -D -s snaps manage_snaps.sh
tmux new -D -s sanoid sudo /home/hbarta/bin/thrash_sanoid.sh
watch -n 30 sudo /home/hbarta/bin/monitor.sh
```

Much ad-hoc tweaking of the scripts and commands to satisfy the requirement that all ZFS commands be run as root. GRRR. Testing rolling about 2315.

## 2025-04-07 checking operation

```text
hbarta@orion:~/logs$ sudo zpool list
[sudo] password for hbarta: 
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   413G  51.4G        -         -    23%    88%  1.00x    ONLINE  -
send   464G   446G  18.1G        -         -    65%    96%  1.00x    ONLINE  -
hbarta@orion:~/logs$ 
```

```text
send snapshot count
14457

recv snapshot count
14792
```

Due to the "root only for ZFS" issue the scripted snapshots were not being trimmed. The 'stir' process complained about not being able to create snapshots. Fixed this morning and slowly unwinding, likely due to the number of snapshots and how busy the other tasks are keeping the pools. Once that settles, I need to let it run a couple more hours to insure this mis-operation did not nullify test results.

Stopping the test at 1200 with no corruption reported.
