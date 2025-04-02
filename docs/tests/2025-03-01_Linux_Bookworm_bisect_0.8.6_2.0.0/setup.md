# Git bisect 0.8.6 to 2.0.0

0.8.65 does not exhibit corruption and 2.0.0 does.

Setup will restore the recently backuped Bookworm install and pull the OpenZFS repo, building ZFS from that.

## 2025-03-01 Restore backup 

In another host to avoid the need to boot a live environment. Frst mount the storage partition using Gnome Disks and then as `root`:

```text
cd /media/hbarta/storage/image/bookworm
root@olive:/media/hbarta/storage/image/bookworm# ls -l
total 29297672
-rw-r----- 1 root root 30000807936 Feb 23 19:53 dev.sdd1
-rw-r--r-- 1 root root         512 Feb 23 19:48 MBR.img
root@olive:/media/hbarta/storage/image/bookworm# dd if=MBR.img of=/dev/sdb
1+0 records in
1+0 records out
512 bytes copied, 0.000581745 s, 880 kB/s
root@olive:/media/hbarta/storage/image/bookworm# dd if=dev.sdd1 of=/dev/sdb1 bs=4k
7324416+0 records in
7324416+0 records out
30000807936 bytes (30 GB, 28 GiB) copied, 457.003 s, 65.6 MB/s
root@olive:/media/hbarta/storage/image/bookworm# 
cd # and unmount 
```

Then back in test host and boot. No joy - no boot. No keyboard response at Grub menu. Time to reinstall.

## 2024-03-01 reinstall and add useful packages

Not adding `contrib` to `sources.list` since ZFS packages will not be installed. Second `apt` command from <https://openzfs.github.io/openzfs-docs/Developer%20Resources/Building%20ZFS.html#installing-dependencies>


```text
apt install -y vim git  lzop pv mbuffer tree smartmontools lm-sensors parted shellcheck tmux time mkdocs lshw dpkg-dev build-essential dh-autoreconf libghc-zlib-dev uuid-dev libblkid-dev libssl-dev rsync
sudo apt install alien autoconf automake build-essential debhelper-compat dh-autoreconf dh-dkms dh-python dkms fakeroot gawk git libaio-dev libattr1-dev libblkid-dev libcurl4-openssl-dev libelf-dev libffi-dev libpam0g-dev libssl-dev libtirpc-dev libtool libudev-dev linux-headers-generic parallel po-debconf python3 python3-all-dev python3-cffi python3-dev python3-packaging python3-setuptools python3-sphinx uuid-dev zlib1g-dev
```

Add mount for storage partition to `/etc/fstab`. Boot drive came up as `/dev/sdb` this time.

```text
root@orion:~# blkid /dev/sdb*
/dev/sdb: LABEL="Patriot_rpool" UUID="6735704553737540431" UUID_SUB="12470342922057127901" BLOCK_SIZE="4096" TYPE="zfs_member" PTUUID="aa3e6d34" PTTYPE="dos"
/dev/sdb1: UUID="43cb77d5-bd67-47e2-9219-b64ebb00fb30" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="aa3e6d34-01"
/dev/sdb2: PTTYPE="dos" PARTUUID="aa3e6d34-02"
/dev/sdb3: LABEL="storage" UUID="16c539ec-35b1-4189-ad43-da9857fce914" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="aa3e6d34-03"
/dev/sdb5: UUID="205b4ac2-2976-46b2-a6ef-0afec7a9628c" TYPE="swap" PARTUUID="aa3e6d34-05"
root@orion:~# vim /etc/fstab
root@orion:~# tail -1 /etc/fstab
UUID=16c539ec-35b1-4189-ad43-da9857fce914 /mnt/storage    ext4    errors=remount-ro 0       1
root@orion:~# mkdir -p /mnt/storage
root@orion:~# mount -a
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
root@orion:~# df /mnt/storage
Filesystem     1K-blocks     Used Available Use% Mounted on
/dev/sdb3      199817528 65214472 124380056  35% /mnt/storage
root@orion:~# sudo chmod a+rwx /mnt/storage
root@orion:~# 
```

## Backup install

Need to store the MBR, and /dev/sdb, this time in a different host rather than trying to backup the live root partition. And might as well store to something local on the other host. Destination dir is `/mnt/nvme_mirror/backup/orion/bookworm`. The `orion` SSD is at `/dev/sdb`

```text
dd if=/dev/sdb of=/mnt/nvme_mirror/backup/orion/bookworm/MBR.img bs=512 count=1
time -p rsync --copy-devices --partial --inplace \
        /dev/sdb1 /mnt/nvme_mirror/backup/orion/bookworm/dev.sdb1 
```

```text
root@olive:/mnt/nvme_mirror/backup/orion/bookworm# dd if=/dev/sdb of=/mnt/nvme_mirror/backup/orion/bookworm/MBR.img bs=512 count=1
1+0 records in
1+0 records out
512 bytes copied, 0.000666265 s, 768 kB/s
root@olive:/mnt/nvme_mirror/backup/orion/bookworm# time -p rsync --copy-devices --partial --inplace \
        /dev/sdb1 /mnt/nvme_mirror/backup/orion/bookworm/dev.sdb1 
real 60.41
user 6.17
sys 23.56
root@olive:/mnt/nvme_mirror/backup/orion/bookworm# 
```

Move SSD back to test host and start bisect and build.

## 2025-03-01 start bisect

* <https://github.com/openzfs/zfs/releases/tag/zfs-2.0.0> `dcbf847`
* <https://github.com/openzfs/zfs/releases/tag/zfs-0.8.6> `2bc6689`

```text
cd zfs
git bisect start
git bisect good 2bc6689
git bisect bad dcbf847
```

```text
hbarta@orion:~/zfs$ git bisect start
Already on 'master'
Your branch is up to date with 'origin/master'.
status: waiting for both good and bad commits
hbarta@orion:~/zfs$ git bisect good 2bc6689
status: waiting for bad commit, 1 good commit known
hbarta@orion:~/zfs$ git bisect bad dcbf847
Bisecting: a merge base must be tested
[78fac8d925fdd64584292fbda4ed9e3e2bbaae66] Fix kstat state update during pool transition
hbarta@orion:~/zfs$ 
```

And build.

```
cd zfs
sh autogen.sh
./configure
time -p make -s -j$(nproc)
sudo make install
sudo ldconfig
sudo modprobe zfs
```

Stuck on `./configure` with

```text
checking whether python3 version is >= 2.6... yes
checking for python3 version... 3.11
checking for python3 platform... linux
checking for GNU default python3 prefix... ${prefix}
checking for GNU default python3 exec_prefix... ${exec_prefix}
checking for python3 script directory (pythondir)... ${PYTHON_PREFIX}/lib/python3.11/site-packages
checking for python3 extension module directory (pyexecdir)... ${PYTHON_EXEC_PREFIX}/lib/python3.11/site-packages
configure: error: "Python >= 3.4.x is not available"
hbarta@orion:~/zfs$ find / -name site-packages 2>/dev/null
hbarta@orion:~/zfs$
```

Switching to Fedora 41 server to see if that helps. Adding `--skip-unavailable` to first `dnf` command as `epel-release` is missing. Removed `--enablerepo=epel --enablerepo=powertools` from the second.

```text
sudo dnf install --skip-broken --skip-unavailable  epel-release gcc make autoconf automake libtool rpm-build libtirpc-devel libblkid-devel libuuid-devel libudev-devel openssl-devel zlib-devel libaio-devel libattr-devel elfutils-libelf-devel kernel-devel-$(uname -r) python3 python3-devel python3-setuptools python3-cffi libffi-devel git ncompress libcurl-devel
sudo dnf install --skip-broken  python3-packaging dkms
```

No joy. Exact same error, perhaps because the kernel is not compatible with the older version of ZFS. :-/

Setting this one aside for now.
