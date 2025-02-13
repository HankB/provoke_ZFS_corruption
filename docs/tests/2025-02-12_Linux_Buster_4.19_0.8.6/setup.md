# Setup Linux Buster 4.19 kernel with ZFS 0.8.6

Testing with default kernel and ZFS version.

## 2025-02-12-1710 install

Installing using Netinst media 10.13. Using full disk, no home partition and will adjust partition for extra storage to preserve the install (before installing ZFS) for later repeated installation.

Not bothering with the MAC remap and will change the host name to `orion` locally and on the DNS assignment.

* Tweak sources (add contrib) and upgrade.
* `apt install -y vim git  lzop pv mbuffer tree smartmontools lm-sensors parted shellcheck tmux time mkdocs lshw dpkg-dev build-essential dh-autoreconf libghc-zlib-dev uuid-dev libblkid-dev libssl-dev libnvpair1linux rsync`

```text
ssh-keygen -t rsa -b 4096 -C "hbarta@gmail.com"
cat /home/hbarta/.ssh/id_rsa.pub
git clone git@github.com:HankB/provoke_ZFS_corruption.git
```

Copy and install custom `sanoid` package (remove ZFS dependencies - https://github.com/jimsalterjrs/sanoid/issues/975)

Backup image to `/mnt/storage/image/` (as root) First the partition table (for the system drive - `/dev/sdc`)

```text
hbarta@orion:~$ sudo fdisk /dev/sdc

Welcome to fdisk (util-linux 2.33.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): p
Disk /dev/sdc: 223.6 GiB, 240057409536 bytes, 468862128 sectors
Disk model: Patriot Burst El
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xaa3e6d34

Device     Boot     Start       End   Sectors   Size Id Type
/dev/sdc1  *         2048  58597375  58595328    28G 83 Linux
/dev/sdc2       466864126 468860927   1996802   975M  5 Extended
/dev/sdc3        58597376 466862079 408264704 194.7G 83 Linux
/dev/sdc5       466864128 468860927   1996800   975M 82 Linux swap / Solaris

Partition table entries are not in disk order.

Command (m for help): q

hbarta@orion:~$ 
```

The extra partition is mounted at `/mnt/storage`

```text
hbarta@orion:~$ cat /etc/fstab
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/sdd1 during installation
UUID=6a5513df-bbd0-4b28-9cd6-e0de908be639 /               ext4    errors=remount-ro 0       1
# swap was on /dev/sdd5 during installation

UUID=acafc71d-e96a-4ad6-bcc8-156f6643bc26 none            swap    sw              0       0

# /dev/sdc3: LABEL="storage" UUID="16c539ec-35b1-4189-ad43-da9857fce914" TYPE="ext4" PARTUUID="aa3e6d34-03"
UUID="16c539ec-35b1-4189-ad43-da9857fce914" /mnt/storage ext4    errors=remount-ro 0       1
hbarta@orion:~$ df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            7.9G     0  7.9G   0% /dev
tmpfs           1.6G  8.9M  1.6G   1% /run
/dev/sdc1        27G  2.7G   23G  11% /
tmpfs           7.9G     0  7.9G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs           7.9G     0  7.9G   0% /sys/fs/cgroup
/dev/sdc3       191G   28G  153G  16% /mnt/storage
tmpfs           1.6G     0  1.6G   0% /run/user/1000
hbarta@orion:~$
```
Need to store the MBR, and /dev/sdc1.

```text
dd if=/dev/sdc of=/mnt/storage/image/MBR.img bs=512 count=1
time -p rsync --copy-devices --partial --inplace \
        /dev/sdc1 /mnt/storage/image/dev.sdc1 
```

Log directory is also placed in the storage mount.

```text
ln -s /mnt/storage/logs.2025-02-12_Linux_Buster_4.19_0.8.6 /home/hbarta/logs
```

## 2025-02-13 build ZFS 0.8.6

```text
cd
git clone https://github.com/openzfs/zfs.git
cd zfs
git reset --hard 2bc6689
```

```text
hbarta@orion:~$ git clone https://github.com/openzfs/zfs.git
Cloning into 'zfs'...
remote: Enumerating objects: 199584, done.
remote: Counting objects: 100% (905/905), done.
remote: Compressing objects: 100% (520/520), done.
remote: Total 199584 (delta 650), reused 385 (delta 385), pack-reused 198679 (from 3)
Receiving objects: 100% (199584/199584), 132.55 MiB | 10.95 MiB/s, done.
Resolving deltas: 100% (146103/146103), done.
hbarta@orion:~$ cd zfs
hbarta@orion:~/zfs$ git reset --hard 2bc6689
HEAD is now at 2bc66898b Tag zfs-0.8.6
hbarta@orion:~/zfs$ 
```

Build instructions at <https://openzfs.github.io/openzfs-docs/Developer%20Resources/Building%20ZFS.html> and 0.8.6 will be built "in tree" (and the Debian packages may not be available anyway.) Following <https://openzfs.github.io/openzfs-docs/Developer%20Resources/Building%20ZFS.html#configure-and-build>

```text
sh autogen.sh
./configure
make -s -j$(nproc)
```

Need to install kernel source package and rerun `./configure`.

```text
sudo apt install linux-source-4.19
```

And perhaps running the suggested install for requirements.

```text
sudo apt install alien autoconf automake build-essential debhelper-compat dh-autoreconf dh-dkms dh-python dkms fakeroot gawk git libaio-dev libattr1-dev libblkid-dev libcurl4-openssl-dev libelf-dev libffi-dev libpam0g-dev libssl-dev libtirpc-dev libtool libudev-dev linux-headers-generic parallel po-debconf python3 python3-all-dev python3-cffi python3-dev python3-packaging python3-setuptools python3-sphinx uuid-dev zlib1g-dev
```

```text
hbarta@orion:~/zfs$ sudo apt install alien autoconf automake build-essential debhelper-compat dh-autoreconf dh-dkms dh-python dkms fakeroot gawk git libaio-dev libattr1-dev libblkid-dev libcurl4-openssl-dev libelf-dev libffi-dev libpam0g-dev libssl-dev libtirpc-dev libtool libudev-dev linux-headers-generic parallel po-debconf python3 python3-all-dev python3-cffi python3-dev python3-packaging python3-setuptools python3-sphinx uuid-dev zlib1g-dev
Reading package lists... Done
Building dependency tree       
Reading state information... Done
Note, selecting 'debhelper' instead of 'debhelper-compat'
Package linux-headers-generic is not available, but is referred to by another package.
This may mean that the package is missing, has been obsoleted, or
is only available from another source

E: Unable to locate package dh-dkms
E: Package 'linux-headers-generic' has no installation candidate
hbarta@orion:~/zfs$ 
```

Try again, removing `dh-dkms` and substituting `linux-headers-amd64`.

```text
sudo apt install alien autoconf automake build-essential debhelper-compat dh-autoreconf dh-python dkms fakeroot gawk git libaio-dev libattr1-dev libblkid-dev libcurl4-openssl-dev libelf-dev libffi-dev libpam0g-dev libssl-dev libtirpc-dev libtool libudev-dev linux-headers-amd64 parallel po-debconf python3 python3-all-dev python3-cffi python3-dev python3-packaging python3-setuptools python3-sphinx uuid-dev zlib1g-dev
```

Seems to have worked.

```test
sudo make install
sudo ldconfig
zfs --version
```

```text
hbarta@orion:~/zfs$ zfs --version
zfs-0.8.6-1
zfs-kmod-0.8.6-1
hbarta@orion:~/zfs$ 
```

Great success!

## 2025-02-13 destroy and recreate pools

```text
root@orion:/home/hbarta# zpool import -f send
This pool uses the following feature(s) not supported by this system:
        com.delphix:log_spacemap (Log metaslab changes on a single spacemap and flush them periodically.)
All unsupported features are only required for writing to the pool.
The pool can be imported using '-o readonly=on'.
cannot import 'send': unsupported version or feature
root@orion:/home/hbarta# zpool import -f -o readonly=on send
root@orion:/home/hbarta# zpool import -f -o readonly=on recv
root@orion:/home/hbarta# zpool destroy send
root@orion:/home/hbarta# zpool destroy recv
root@orion:/home/hbarta# 
```

Referring to `Debian Buster root on ZFS" instructions for pool creation for pool options.

```text
dd if=/dev/urandom bs=32 count=1 of=/pool-key
zpool create -f \
        -o ashift=12 \
        -O encryption=on \
        -O keylocation=file:///pool-key -O keyformat=raw \
        -O acltype=posixacl -O canmount=on -O compression=lz4 \
        -O dnodesize=auto -O normalization=formD -O relatime=on \
        -O xattr=sa  \
        -O mountpoint=/mnt/send \
        send wwn-0x5002538d40878f8e
zfs load-key -a

zpool create -f \
        -o ashift=12 \
        -O acltype=posixacl -O canmount=on -O compression=lz4 \
        -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
        -O mountpoint=/mnt/recv \
        recv wwn-0x5002538d41628a33
```

```text
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   552K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   684K   464G        -         -     0%     0%  1.00x    ONLINE  -
root@orion:~# 
```

And populate `send`.

```text
time -p /home/hbarta/provoke_ZFS_corruption/scripts/populate_pool.sh
...
Terminated
real 3386.57
user 101.69
sys 3363.83
```

Missed the threshold:

```text
hbarta@orion:~$ zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   576K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   351G   113G        -         -     0%    75%  1.00x    ONLINE  -
hbarta@orion:~$ 
```

Will roll with this and can remove some data sets or reduce retained snapshots if needed.

Set up `zfs allow`, perform first `syncoid` transfer and set ownership.

```text
user=hbarta
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    send
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    recv

time -p syncoid --recursive --no-privilege-elevation send/test recv/test
chown -R $user:$user /mnt/send /mnt/recv
```

Link scripts to ~/bin for convenience.

```text
hbarta@orion:~$ mkdir -p ~/bin
hbarta@orion:~$ ln provoke_ZFS_corruption/scripts/*.sh bin/
```

## 2025-02-13 start thrashing

Running in seperate (`tmux`) windows.

* `cd`
* `ln provoke_ZFS_corruption/scripts/*.sh bin/`
* `mkdir logs`
* `tmux new -s stir` and `thrash_stir.sh`
* `tmux new -s syncoid` and `thrash_syncoid.sh`
* `tmux new -s snaps` and `manage_snaps.sh` (After tweaking to manage both pools)

Kicking off at 1216. At 1532

```text
hbarta@orion:~/logs$ zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   406G  58.2G        -         -    37%    87%  1.00x    ONLINE  -
send   464G   417G  46.6G        -         -    53%    89%  1.00x    ONLINE  -
hbarta@orion:~/logs$ 
```
