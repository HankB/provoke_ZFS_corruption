# Setup: Git bisect 0.8.6 to 2.0.0 - testing seventh bisect

* [Data](./data.md)
* [Results](./results.md)

## 2025-04-05 remove ZFS

```text
cd ~/zfs
sudo make uninstall
find /lib|grep zfs
find /usr/lib | grep zfs
lsmod|grep zfs # shows ZFS modules still in kernel.
reboot
lsmod|grep zfs # no ZFS modules
```

Confirm kernel and modules

```text
hbarta@orion:~$ find /usr/lib | grep zfs
/usr/lib/systemd/system/zfs-import.service
/usr/lib/grub/i386-pc/zfscrypt.mod
/usr/lib/grub/i386-pc/zfs.mod
/usr/lib/grub/i386-pc/zfsinfo.mod
/usr/lib/dracut/modules.d/90zfs
/usr/lib/dracut/modules.d/02zfsexpandknowledge
/usr/lib/modules/4.19.0-27-amd64/extra/zfs
/usr/lib/modules/4.19.0-27-amd64/extra/zfs/zfs.ko
hbarta@orion:~$ ls -l /usr/lib/modules/4.19.0-27-amd64/extra/zfs/zfs.ko
-rw-r--r-- 1 root root 66330304 Apr  5 16:49 /usr/lib/modules/4.19.0-27-amd64/extra/zfs/zfs.ko
hbarta@orion:~$ lsmod|grep zfs # no ZFS modules
hbarta@orion:~$ uname -a
Linux orion 4.19.0-27-amd64 #1 SMP Debian 4.19.316-1 (2024-06-25) x86_64 GNU/Linux
hbarta@orion:~$ 
```

Bisect

```text
hbarta@orion:~/zfs$ git bisect good
Bisecting: 19 revisions left to test after this (roughly 4 steps)
[d9cd66e45f285356624d26eb92e10e2baf2738ee] Target ARC size can get reduced to arc_c_min
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
hbarta@orion:~/zfs$ find /usr/lib | grep zfs
\/usr/lib/systemd/system-preset/50-zfs.preset
/usr/lib/systemd/system/zfs-zed.service
/usr/lib/systemd/system/zfs-import.service
/usr/lib/systemd/system/zfs.target
/usr/lib/systemd/system/zfs-import.target
/usr/lib/systemd/system/zfs-mount.service
/usr/lib/systemd/system/zfs-import-scan.service
/usr/lib/systemd/system/zfs-share.service
/usr/lib/systemd/system/zfs-import-cache.service
/usr/lib/systemd/system-generators/zfs-mount-generator
/usr/lib/modules-load.d/zfs.conf
/usr/lib/grub/i386-pc/zfscrypt.mod
/usr/lib/grub/i386-pc/zfs.mod
/usr/lib/grub/i386-pc/zfsinfo.mod
/usr/lib/dracut/modules.d/90zfs
/usr/lib/dracut/modules.d/90zfs/zfs-env-bootfs.service
/usr/lib/dracut/modules.d/90zfs/zfs-lib.sh
/usr/lib/dracut/modules.d/90zfs/zfs-load-key.sh
/usr/lib/dracut/modules.d/90zfs/module-setup.sh
/usr/lib/dracut/modules.d/90zfs/export-zfs.sh
/usr/lib/dracut/modules.d/90zfs/zfs-generator.sh
/usr/lib/dracut/modules.d/90zfs/mount-zfs.sh
/usr/lib/dracut/modules.d/90zfs/zfs-needshutdown.sh
/usr/lib/dracut/modules.d/90zfs/parse-zfs.sh
/usr/lib/dracut/modules.d/02zfsexpandknowledge
/usr/lib/dracut/modules.d/02zfsexpandknowledge/module-setup.sh
/usr/lib/modules/4.19.0-27-amd64/extra/zfs
/usr/lib/modules/4.19.0-27-amd64/extra/zfs/zfs.ko
/usr/lib/udev/rules.d/90-zfs.rules
hbarta@orion:~/zfs$ ls -l /usr/lib/modules/4.19.0-27-amd64/extra/zfs/zfs.ko
-rw-r--r-- 1 root root 66347416 Apr  6 07:59 /usr/lib/modules/4.19.0-27-amd64/extra/zfs/zfs.ko
hbarta@orion:~/zfs$ 
hbarta@orion:~/zfs$ zfs --version
zfs-0.8.0-60_gd9cd66e45
zfs-kmod-0.8.0-60_gd9cd66e45
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
recv   464G  1.04M   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   684K   464G        -         -     0%     0%  1.00x    ONLINE  -
root@orion:~# 
```

### prepare for testing

```text
root@orion:~# time -p /home/hbarta/provoke_ZFS_corruption/scripts/populate_pool.sh
...
Capacity target 50 met
+ exit
real 2303.52
user 69.42
sys 2286.72
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   564K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   239G   225G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# 
```

[First syncoid (as root)](./data.md)

```text
time -p syncoid --recursive --no-privilege-elevation send/test recv/test
```

```text
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 1999.56
user 26.95
sys 1937.11
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   239G   225G        -         -     0%    51%  1.00x    ONLINE  -
send   464G   239G   225G        -         -     0%    51%  1.00x    ONLINE  -
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

Repeat `syncoid` as user.

```text
hbarta@orion:~/zfs$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 12.46
user 2.91
sys 7.72
hbarta@orion:~/zfs$ 
```

Prepare logs, confirm `sanoid.timer` is disabled.

```text
cd
mkdir /mnt/storage/logs.2025-04-06_Linux_Buster_4.19_bisect_7/
rm /home/hbarta/logs
ln -s /mnt/storage/logs.2025-04-06_Linux_Buster_4.19_bisect_7 /home/hbarta/logs
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

Testing starts about 0935 and was stopped at about 2105 with no corruption detected in 11 1/2 hours of testing.
