# setup

* [Results](./results.md)
* [Data](./data.md)


Perform bookworm Netinst (no DE) and pull 2.3.0 and build for tests. 

## 2025-02-23 Initial setup

1. Add `contrib` to `/etc/apt/sources.list`
1. `apt install -y vim git  lzop pv mbuffer tree smartmontools lm-sensors parted shellcheck tmux time mkdocs lshw dpkg-dev build-essential dh-autoreconf libghc-zlib-dev uuid-dev libblkid-dev libssl-dev rsync`
1. `sudo apt install alien autoconf automake build-essential debhelper-compat dh-autoreconf dh-dkms dh-python dkms fakeroot gawk git libaio-dev libattr1-dev libblkid-dev libcurl4-openssl-dev libelf-dev libffi-dev libpam0g-dev libssl-dev libtirpc-dev libtool libudev-dev linux-headers-generic parallel po-debconf python3 python3-all-dev python3-cffi python3-dev python3-packaging python3-setuptools python3-sphinx uuid-dev zlib1g-dev` (per <https://openzfs.github.io/openzfs-docs/Developer%20Resources/Building%20ZFS.html#installing-dependencies>)

## 2025-02-23 backup install

```text
root@orion:~# df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            7.8G     0  7.8G   0% /dev
tmpfs           1.6G  1.2M  1.6G   1% /run
/dev/sdd1        28G  3.3G   23G  13% /
tmpfs           7.9G     0  7.9G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs           1.6G     0  1.6G   0% /run/user/1000
/dev/sdd3       191G   34G  148G  19% /mnt/storage
root@orion:~# 
```

Need to store the MBR, and /dev/sdc1.

```text
dd if=/dev/sdd of=/mnt/storage/image/bookworm/MBR.img bs=512 count=1
time -p rsync --copy-devices --partial --inplace \
        /dev/sdd1 /mnt/storage/image/bookworm/dev.sdd1 
```

(Boot drive came up as `/dev/sdd` because the install USB was still plugged in.)

```
root@orion:~# dd if=/dev/sdd of=/mnt/storage/image/bookworm/MBR.img bs=512 count=1
1+0 records in
1+0 records out
512 bytes copied, 0.000164546 s, 3.1 MB/s
root@orion:~# ls -l /mnt/storage/image/bookworm/
total 4
-rw-r--r-- 1 root root 512 Feb 23 19:48 MBR.img
root@orion:~# time -p rsync --copy-devices --partial --inplace \
        /dev/sdd1 /mnt/storage/image/bookworm/dev.sdd1 
real 279.50
user 35.91
sys 120.60
root@orion:~# 
```

## build ZFS

```text
wget https://github.com/openzfs/zfs/releases/download/zfs-2.3.0/zfs-2.3.0.tar.gz
tar xf zfs-2.3.0.tar.gz
cd zfs-2.3.0
sh autogen.sh
time -p make -s -j$(nproc)
sudo make install
sudo ldconfig
sudo modprobe zfs
```

```text
hbarta@orion:~/zfs-2.3.0$ time -p make -s -j$(nproc)
...
real 133.59
user 1490.28
sys 119.02
hbarta@orion:~/zfs-2.3.0$ 
```

## 2025-02-24 2.3.0 not working on bookworm

Discussion at <https://zfsonlinux.topicbox.com/groups/zfs-discuss/Tf3aa320b5d3f11ef>.

2.3.0 is packaged for Debian Trixie (Testing) so I will upgrade to that and install from the repo. Upgraded following brief instructions at <https://gist.github.com/yorickdowne/3cecc7b424ce241b173510e36754af47> (tweak `/etc/apt/sources.list` and perform `apt dist-upgrade`.) Then install

```text
apt install dpkg-dev linux-headers-generic linux-image-generic
apt install zfs-dkms zfsutils-linux
```

```text
root@orion:/home/hbarta# zfs --version
zfs-2.3.0-1
zfs-kmod-2.3.0-1
root@orion:/home/hbarta# 
```

## 2025-02-24 secure erase and create pools

Confirm that `/dev/sda` and `/dev/sdb` are Samsung SSDs (boot is a Patriot.)

```text
sudo apt install hdparm
sudo hdparm --user-master u --security-set-pass Eins /dev/sda
sudo hdparm --security-erase Eins /dev/sda
sudo hdparm --user-master u --security-set-pass Eins /dev/sdb
sudo hdparm --security-erase Eins /dev/sdb
```

Create pools.

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

```text
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   552K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   588K   464G        -         -     0%     0%  1.00x    ONLINE  -
root@orion:~# 
```

Populate `send` pool.

```text
cd
mkdir bin
ln /home/hbarta/provoke_ZFS_corruption/scripts/* bin/
sudo /home/hbarta/bin/populate_pool.sh
```

Results:

```text
hbarta@orion:~$ zfs list -r send|wc -l
33
hbarta@orion:~$ find /mnt/send/test -type f | wc -l
48000
hbarta@orion:~$ 
```

### First `syncoid`

```text
sudo apt install -y sanoid
time -p syncoid --recursive --no-privilege-elevation send/test recv/test
```

```text
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 2367.12
user 39.88
sys 2118.01
root@orion:~# 
```

[full output](./data.md#2025-02-24-first-syncoid)

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

### Second symcoid

```text
hbarta@orion:~$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 11.86
user 2.71
sys 6.00
hbarta@orion:~$ 
```

[full output](./data.md#2025-02-24-second-syncoid)

## 2025-02-24 start thrashing

```text
cd
mkdir /mnt/storage/logs.2025.02.23_Linux_Bookworm_Trixie_2.3.0/
ln -s /mnt/storage/logs.2025.02.23_Linux_Bookworm_Trixie_2.3.0/ /home/hbarta/logs
tmux new -D -s "stir" thrash_stir.sh
tmux new -D -s syncoid thrash_syncoid.sh
tmux new -D -s snaps manage_snaps.sh
```

Kicked off at 1218. First corruption at 1416. Once again the process did not terminate when the first error was detected. There were several stir operations that reported  before 
