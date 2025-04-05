# Setup: Git bisect 0.8.6 to 2.0.0 - testing third bisect

* [Data](./data.md)
* [Results](./results.md)

## 2025-04-03 remove ZFS

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
Bisecting: 314 revisions left to test after this (roughly 8 steps)
[eedb3a62b9f16b989aa02d00db63de5dff200572] Make `zil_async_to_sync` visible to platform code
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
real 106.08
user 704.77
sys 78.49
hbarta@orion:~/zfs$ 
```

```text
hbarta@orion:~/zfs$ zfs --version
zfs-0.8.0-317_geedb3a62b
zfs-kmod-0.8.0-317_geedb3a62b
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
recv   464G   432K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   552K   464G        -         -     0%     0%  1.00x    ONLINE  -
root@orion:~# 
```

### prepare for testing

```text
root@orion:~# time -p /home/hbarta/provoke_ZFS_corruption/scripts/populate_pool.sh
...
Capacity target 50 met
+ exit
real 2290.77
user 68.50
sys 2274.74
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   636K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   240G   224G        -         -     0%    51%  1.00x    ONLINE  -
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
hbarta@orion:~/zfs$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 13.26
user 3.13
sys 4.77
hbarta@orion:~/zfs$ 
```

Prepare logs, confirm `sanoid.timer` is disabled.

```text
cd
mkdir /mnt/storage/logs.2025-04-04_Linux_Buster_4.19_bisect_3/
rm /home/hbarta/logs
ln -s /mnt/storage/logs.2025-04-04_Linux_Buster_4.19_bisect_3 /home/hbarta/logs
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

Testing started at about 1610. Corruption detected at 1900 - 2:50.
