# Setup: Git bisect 0.8.6 to 2.0.0 - testing first bisect

## 2025-04-03 remove ZFS

```text
cd ~/zfx
sudo make uninstall
find /lib|grep zfs
lsmod|grep zfs # shows ZFS modules still in kernel.
reboot
lsmod|grep zfs # no ZFS modules
```

Confirm kernel

```text
hbarta@orion:~$ uname -a
Linux orion 4.19.0-27-amd64 #1 SMP Debian 4.19.316-1 (2024-06-25) x86_64 GNU/Linux
hbarta@orion:~$ 
```

## 2025-04-03 cleanup and start bisect

* 2.0.0 hash: dcbf847
* 0.8.6 hash: 2bc6689

```text
cd ~/zfs
make distclean
git bisect reset
git bisect start
git bisect good 0.8.6 # fatal: Needed a single revision / Bad rev input: 0.8.6
git bisect good 2bc6689
git bisect bad dcbf847
```

```text
hbarta@orion:~/zfs$ git bisect reset
We are not bisecting.
hbarta@orion:~/zfs$ git bisect start
hbarta@orion:~/zfs$ git bisect good 0.8.6
fatal: Needed a single revision
Bad rev input: 0.8.6
hbarta@orion:~/zfs$ git bisect good 2bc6689
hbarta@orion:~/zfs$ git bisect bad dcbf847
Bisecting: a merge base must be tested
[78fac8d925fdd64584292fbda4ed9e3e2bbaae66] Fix kstat state update during pool transition
hbarta@orion:~/zfs$ 
```

```text
sh autogen.sh
./configure
time -p make -s -j$(nproc)
sudo make install
sudo ldconfig
sudo modprobe zfs
```

* `autogen.sh` completes w/out error.
* `configure` completes w/out error.
* `time -p make -s -j$(nproc)` completes w/out error.


```text
hbarta@orion:~/zfs$ time -p make -s -j$(nproc)
...
real 98.11
user 668.88
sys 74.18
hbarta@orion:~/zfs$
hbarta@orion:~/zfs$ zfs --version
zfs-0.8.0-2_g78fac8d92
zfs-kmod-0.8.0-2_g78fac8d92
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
recv   464G  1.05M   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G  1.20M   464G        -         -     0%     0%  1.00x    ONLINE  -
root@orion:~# 
```

### prepare for testing

```text
root@orion:~# time -p /home/hbarta/provoke_ZFS_corruption/scripts/populate_pool.sh
...
Capacity target 50 met
+ exit
real 2299.26
user 70.48
sys 2282.26
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   576K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   239G   225G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# 
```
```text
time -p syncoid --recursive --no-privilege-elevation send/test recv/test
```

Sanoid configuration

```text
[send/test]
        use_template = production
        frequently = 10
        recursive = zfs

[recv/test]
        use_template = production
        recursive = zfs
        autosnap = no
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

Repeat the syncoid command as a user.

```text
hbarta@orion:~/zfs$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 12.66
user 3.07
sys 7.66
hbarta@orion:~/zfs$ 
```

```text
cd
mkdir /mnt/storage/logs.2025-04-02_Linux_Buster_4.19_bisect_1/
rm /home/hbarta/logs
ln -s /mnt/storage/logs.2025-04-02_Linux_Buster_4.19_bisect_1 /home/hbarta/logs
sudo vim /etc/sanoid/sanoid.conf # confirm configuration as described below
sudo systemctl disable sanoid.timer
```

### start thrashing

```text
tmux new -D -s "stir" thrash_stir.sh
tmux new -D -s syncoid thrash_syncoid.sh
tmux new -D -s snaps manage_snaps.sh
tmux new -D -s sanoid sudo /home/hbarta/bin/thrash_sanoid.sh
watch -n 30 monitor.sh
```

(These commands get their own SSH login.) Testing started at about 1030.

Test halted at 0750 the next day with no corruption produced.
