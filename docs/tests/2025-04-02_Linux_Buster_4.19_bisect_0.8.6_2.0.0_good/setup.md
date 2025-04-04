# Setup: Git bisect 0.8.6 to 2.0.0 - testing 0.8.6

* [Results](./results.md)
* [Data](./data.md)

## 2025-04-02 remove ZFS

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

## 2025-04-02 Build ZFS 0.8.6 

```text
cd ~/zfs
make distclean
git checkout 2bc6689
```

```text
hbarta@orion:~/zfs$ git checkout 2bc6689
Previous HEAD position was dcbf84749 Tag 2.0.0
HEAD is now at 2bc66898b Tag zfs-0.8.6
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

```text
hbarta@orion:~/zfs$ time -p make -s -j$(nproc)
real 103.56
user 679.76
sys 74.62
hbarta@orion:~/zfs$ 
```

```text
hbarta@orion:~/zfs$ zfs --version
zfs-0.8.6-1
zfs-kmod-0.8.6-1
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
recv   464G   552K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   684K   464G        -         -     0%     0%  1.00x    ONLINE  -
root@orion:~# 
```

### Prepare for testing

```text
time -p /home/hbarta/provoke_ZFS_corruption/scripts/populate_pool.sh
```

```text
Capacity target 50 met
+ exit
real 2283.06
user 69.76
sys 2268.02
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   576K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   238G   226G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# 
```



### start thrashing

```text
cd
mkdir /mnt/storage/logs.2025-04-02_Linux_Buster_4.19_0.8.6/
rm /home/hbarta/logs
ln -s /mnt/storage/logs.2025-04-02_Linux_Buster_4.19_0.8.6 /home/hbarta/logs
mkdir -p bin
export PATH=/home/hbarta/bin:$PATH
tmux new -D -s "stir" thrash_stir.sh
tmux new -D -s syncoid thrash_syncoid.sh
tmux new -D -s snaps manage_snaps.sh
watch -n 30 monitor.sh
```

(Last 4 commands get their own SSH login.) Also running `sanoid` in a tight loop with the following configuration:

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

Disabling the timer and looping manually using `thrash_sanoid.sh` 

