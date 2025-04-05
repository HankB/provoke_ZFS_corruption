# Setup: Git bisect 0.8.6 to 2.0.0 - testing fourth bisect

* [Data](./data.md)
* [Results](./results.md)

## 2025-04-04 remove ZFS

```text
cd ~/zfs
sudo make uninstall
find /lib|grep zfs
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
Bisecting: 157 revisions left to test after this (roughly 7 steps)
[1e620c98727a5a5cff1af70fef9bc25626b4e9d8] Revert "Develop tests for issues #5866 and #8858"
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
hbarta@orion:~/zfs$ time -p make -s -j$(nproc)
...
real 99.35
user 692.29
sys 76.18
hbarta@orion:~/zfs$ 
```

```text
hbarta@orion:~/zfs$ zfs --version
zfs-0.8.0-159_g1e620c987
zfs-kmod-0.8.0-159_g1e620c987
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
recv   464G   420K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   576K   464G        -         -     0%     0%  1.00x    ONLINE  -
root@orion:~# 
```

### prepare for testing

```text
root@orion:~# time -p /home/hbarta/provoke_ZFS_corruption/scripts/populate_pool.sh
...
Capacity target 50 met
+ exit
real 2336.87
user 69.89
sys 2318.43
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   624K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   238G   226G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# 
```

[First syncoid (as root)](./data.md)

```text
time -p syncoid --recursive --no-privilege-elevation send/test recv/test
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

Repeat `syncoid` as user.

```text
```

Prepare logs, confirm `sanoid.timer` is disabled.

```text
cd
mkdir /mnt/storage/logs.2025-04-04_Linux_Buster_4.19_bisect_4/
rm /home/hbarta/logs
ln -s /mnt/storage/logs.2025-04-04_Linux_Buster_4.19_bisect_4 /home/hbarta/logs
systemctl status sanoid.timer
```

### start thrashing

```text
tmux new -D -s "stir" thrash_stir.sh
tmux new -D -s syncoid thrash_syncoid.sh
tmux new -D -s snaps manage_snaps.sh
tmux new -D -s sanoid sudo /home/hbarta/bin/thrash_sanoid.sh
watch -n 30 monitor.sh
```

(These commands get their own SSH login.) 

Testing started at about 2240, corruption identified at 0114 the following morning. About 2 1/2 hours.
