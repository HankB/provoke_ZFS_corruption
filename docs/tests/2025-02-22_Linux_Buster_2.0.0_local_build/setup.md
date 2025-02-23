# Setup

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

## 2025-02-22 Build ZFS 2.0.0

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
