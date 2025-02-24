# Setup

* [Data](./data.md)
* [Results](./results.md)


Purpose:

* Establish that bug exists in 2.0.0
* Verify that local build from repo (as opposed to Debian packages) demonstrates the problem.
* Establish the base for testing <https://github.com/openzfs/zfs/issues/12014#issuecomment-2668683109> <https://github.com/openzfs/zfs/pull/17069>
* Exercise the procedure of shipping the install and restoring the saved images.

## 2025-02-22 Restore previous image

1. Backup `/mnt/storage/logs.2025-02-12_Linux_Buster_4.19_0.8.6`
1. Copy `/mnt/storage/image/dev.sdc1` to `/dev/sdX1` (on a different PC)
1. Copy `/mnt/storage/image/MBR.img` to `/dev/sdX` (on a different PC)
1. Replace SSD in test host, boot and confirm that ZFS is not installed.

## 2025-02-23 Build ZFS 2.0.0

Following the same procedure used to previously [to build 2.0.0](../../first-efforts/x86_SATA_Buster.md#2025-01-06-move-to-200).

```text
sudo apt install linux-headers-4.19.0-27-amd64
wget https://github.com/openzfs/zfs/releases/download/zfs-2.0.0/zfs-2.0.0.tar.gz
tar xf zfs-2.0.0.tar.gz
cd zfs-2.0.0
git checkout master # fails - not a git repo
sh autogen.sh
./configure
make -s -j$(nproc)
sudo make install
sudo ldconfig
sudo modprobe zfs
```

```text
hbarta@orion:~/zfs-2.0.0$ zfs --version
zfs-2.0.0-1
zfs-kmod-2.0.0-1
hbarta@orion:~/zfs-2.0.0$ 
```

## 2025-02-23 secure erase SSDs and build test pools

Confirm that `/dev/sda` and `/dev/sdb` are Samsung SSDs (boot is a Patriot.)

```text
sudo hdparm --user-master u --security-set-pass Eins /dev/sda
sudo hdparm --security-erase Eins /dev/sda
sudo hdparm --user-master u --security-set-pass Eins /dev/sdb
sudo hdparm --security-erase Eins /dev/sdb
```

Create pools, swapping drives between `send` and `recv`

```text
sudo -s
dd if=/dev/urandom bs=32 count=1 of=/pool-key
zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O encryption=aes-256-gcm  -O keylocation=file:///pool-key -O keyformat=raw \
      -O mountpoint=/mnt/send \
      send wwn-0x5002538d41628a33
zfs load-key -a

zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O mountpoint=/mnt/recv \
      recv wwn-0x5002538d40878f8e
```

Result:

```text
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   420K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   564K   464G        -         -     0%     0%  1.00x    ONLINE  -
root@orion:~# 
```

## Test mod to `populate_pool.sh`

`populate_pool.sh` should exit when desired capoacity ius met (set to 5% for testing) but first link scripts to `~/bin`.

```text
cd
mkdir bin
ln /home/hbarta/provoke_ZFS_corruption/scripts/* bin/
sudo /home/hbarta/bin/populate_pool.sh
sudo zfs destroy -r send/test # repeat this and previous as needed
```

```text
hbarta@orion:~$ zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   128G   336G        -         -     0%    27%  1.00x    ONLINE  -
send   464G   237G   227G        -         -     0%    51%  1.00x    ONLINE  -
hbarta@orion:~$ zfs list -r send|wc -l
33
hbarta@orion:~$ find /mnt/send -type f|wc -l
48000
hbarta@orion:~$ 
```

[First syncoid](./data.md#2025-02-23-first-syncoid)

`zfs allow` and ownership

```text
user=hbarta
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    send
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    recv

sudo zfs mount -a
sudo chown -R $user:$user /mnt/send /mnt/recv
```

[Second syncoid](./data.md#2025-02-23-second-syncoid)


## 2025-02-23 kicking off tests

* `cd`
* `mkdir /mnt/storage/logs.2025-02-22_Linux_Buster_2.0.0_local_build`
* `ln -s /mnt/storage/logs.2025-02-22_Linux_Buster_2.0.0_local_build /home/hbarta/logs`
* `tmux new -s stir` and `thrash_stir.sh`
* `tmux new -s syncoid` and `thrash_syncoid.sh`
* `tmux new -s snaps` and `manage_snaps.sh` (After tweaking to manage both pools)

testing kicked off at 2025-02-23-1429.

## 2025-02-23 corruption

[See Results for details](./data.md)

