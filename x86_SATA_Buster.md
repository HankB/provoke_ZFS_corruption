# X86 SATA testing with Buster

The purpose is to be able to test with older ZFS versi0ons (back to 0.8) The expectation is this test will not produce corruption for these test conditions (send from encrypted pool to non-encrypted pool.)

## 2024-12-26 install Buster

Prerequisite was to reproduce the error with a current Debian install. The previous (J1900) host was wonky and seems no longer useful. The "new" system is a proper server (X8DTL) with ECC RAM and an HBA to connect the SSDs but is not bootable. The Bookworm install took days to reproduce the error.

Install Buster usintg the Netinst ISO. NB, this board is too old to support EFI.

Add `contrib` to `/etc/apt/sources.list` and install dependencies

* `apt install -y build-essential libghc-zlib-dev uuid-dev libblkid-dev libssl-dev libnvpair1linux vim git`

Pull/extract the tarball and inside the project directory

```text
apt search linux-headers-$(uname -r)
sudo apt install linux-headers-4.19.0-27-amd64
wget https://github.com/openzfs/zfs/releases/download/zfs-0.8.6/zfs-0.8.6.tar.gz
tar xf zfs-0.8.6.tar.gz
cd zfs-0.8.6
./configure
make -j16
sudo make -j16 install
```

Seems to be working! Now to destroy the old pool (secure erase) and create the new pool. Repeating [commands from Bookworm](./x86_trial_3.md)

```text
dd if=/dev/urandom bs=32 count=1 of=/pool-key
zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O encryption=aes-256-gcm  -O keylocation=file:///pool-key -O keyformat=raw \
      -O mountpoint=/mnt/send \
      send wwn-0x5002538d40878f8e
zfs load-key -a
chmod a+rwx /mnt/send/
```

```text
zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O mountpoint=/mnt/recv \
      recv wwn-0x5002538d41628a33
chmod a+rwx /mnt/recv/
```

## 2024-12-27 re-install and restart

### Pull provoke_ZFS_corruption

```text
git clone https://github.com/HankB/provoke_ZFS_corruption.git
cd provoke_ZFS_corruption
vim populate_pool.sh # change pool name "pool=send"
sudo ./populate_pool.sh
```

No `sanoid` in repos so install following suggestions at <https://github.com/jimsalterjrs/sanoid/issues/975> ... But this won't configure the timer, setup config files etc. Instead, fork sanoid and remove the ZFS dependency, <https://github.com/HankB/sanoid> Build and install as instructed and have working `sanoid`. And also install `lzop`, `pv` and `mbuffer`.

```text
sudo apt install lzop pv mbuffer
...
```

First backup

```text
user=hbarta
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    send
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    recv
time -p syncoid --recursive --no-privilege-elevation send/test recv/test
```

First pool stir

```text
vim stir_pool.sh # Fix start directory for find command
sudo chown -R $user:$user /mnt/test 
./stir_pool.sh
```

## 2024-12-28 start loops

Off site so using `tmux` and directing output to a disk file and adding time stamps.

```text
while(:)
do
    date +%Y-%m-%d-%H%M
    time -p syncoid --recursive --no-privilege-elevation send/test recv/test
    zpool status send
    echo
    sleep 750
done >>syncoid.txt 2>&1
```

```text
while(:)
do
    date +%Y-%m-%d-%H%M
    /home/$user/provoke_ZFS_corruption/stir_pool.sh 2>/dev/null
    sleep 750
done >>stir.txt
```

After over a week and over 900 loops there are no errors reported and this test is concluded: bug does not exist in the 0.8.6 release.

## 2025-01-06 move to 2.0.0

`tar` up home directory and begin nuke and pave. Takes about 10 minutes to install Buster. Finish install and start customizing. (Note: look where the untarred files are going.) Install was a bit different this time.

```text
sudo vim /etc/apt/sources.list # add `contrib`
sudo apt update 
apt install -y build-essential libghc-zlib-dev uuid-dev libblkid-dev libssl-dev libnvpair1linux vim git lzop pv mbuffer linux-headers-$(uname -r)
# Copy the source tar to ~/Downloads
cd Downloads
tar xf zfs-2.0.0.tar.gz
cd zfs-2.0.0
git checkout master
sh autogen.sh
./configure
make -s -j$(nproc)
sudo make install # ? yes!
```

Create pools and kick off stress loops (stir, syncoid) and configure `sanoid` snapshots, adding to `/etc/sanoid/sanoid.conf`

```text
[send/test]
        use_template = production
        frequently = 10
        recursive = zfs
```

## 2025-01-08 no errors in AM

```text
errors: No known data errors
```

162 iterations.

## 2025-01-09 no errors in AM

Kicked off scrub on both pools. 284 iterations.

## 2025-01-12 no errors in AM

Daily (morning) scrubs, 622 loops. Maybe 2.0.0 does not have the corruption bug.

## 2025-01-15 still no errors

Calling it on 2.0.0. Next try will be 2.0.3 using kernel 4.19. Before doing this, the entire $HOME directory on the test host was tarred and copied to `~/Downloads/provoke_ZFS_corruption/4.19_2.0.0.tar`.

With the root filesystem only 2% occupied, I'm considering a modification of the install strategy:

1. Install and add desired programs (without ZFS.)
1. Repartition the boot drive to allow an additional storage partition.
1. Copy the MBR and root partition to the storage partition, allowing it to easily be copied back to reproduce starting conditions. (System is too old to support EFI so there is no EFI partition.)
1. Install desired ZFS version.


1. Install (choosing "standard system utilities" and "SSH server" at `tasksel` step.)
1. Spoof MAC address for `enp7s0` to `00:25:90:06:df:be` (using `systemd` link file.)
1. Tweak `sources.list`
1. Install desired programs.
1. Reboot

```text
vi /etc/systemd/network/00-enp7s0.link      # use 00:25:90:06:df:be
vi /etc/apt/sources.list                    # add contrib
apt update
apt install -y build-essential libghc-zlib-dev uuid-dev libblkid-dev libssl-dev libnvpair1linux vim git linux-headers-$(uname -r) lzop pv mbuffer
reboot
```

Live env is horribly slow and there is a problem with the USB keyboard and mouse. It will be easier to swap the dive to another host to manipulate the partitions and backup. Unfortunately `gparted` doesn;t understand MBR partition tables. Further, I chose a separate $HOME partition and the Buster installer created an extended partition for swap and $HOME complicating partition manipulation. I will repeat the install and put everything in one partition. Installer still creates an extended partition for 1GB swap at the end of the device but that will not present a problem.

```text
cat >/etc/systemd/network/00-enp7s0.link <<EOF
[Match]
Driver=macb bcmgenet r8152 r8169 e1000e

[Link]
MACAddress=00:25:90:06:df:be
EOF
```

In other host, the device is `/dev/sdc`. Resizing `/dev/sdc` to 10GB using Gnome Disks. Creating a new 229GB partition `/dev/sdc3` formatted EXT4. This partition will not be added to `/etec/fstab` and will not be mounted during the tests. It will be mounted in the other host (using Gnome Disks) in order to backup the fresh install. (`/media/hbarta/storage`)

```text
mkdir /media/hbarta/storage/4.19_2.0.3
sudo dd if=/dev/sdc of=/media/hbarta/storage/4.19_2.0.3/MBR.img bs=512 count=1
sudo rsync --copy-devices --partial --inplace -B 4096 /dev/sdc1 /media/hbarta/storage/4.19_2.0.3/dev.sdc1
sudo tar -tf /media/hbarta/storage/4.19_2.0.3/dev.sdc1 &> /dev/null; echo $?
```

Place drive back in target and boot. Build ZFS 2.0.3.

```text
mkdir ZFS
cd ZFS
wget https://github.com/openzfs/zfs/releases/download/zfs-2.0.3/zfs-2.0.3.tar.gz
tar xf zfs-2.0.3.tar.gz
cd zfs-2.0.3/ # Note: Not a git repo.
sudo apt install dh-autoreconf
sh autogen.sh
./configure
make -s -j$(nproc)
sudo ldconfig
# add `/usr/local/sbin/` to user PATH variable.
sudo reboot
```

Result

```text
root@orcus:~# zfs --version
zfs-2.0.3-1
zfs-kmod-2.0.3-1
root@orcus:~# 
```

Prepare `/dev/sda` and create the `send` pool. (Was previously the `recv` pool.)

```text
hdparm --user-master u --security-set-pass Eins /dev/sda
hdparm --security-erase Eins /dev/sda
dd if=/dev/urandom bs=32 count=1 of=/pool-key
zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O encryption=aes-256-gcm  -O keylocation=file:///pool-key -O keyformat=raw \
      -O mountpoint=/mnt/send \
      send wwn-0x5002538d41628a33
zfs load-key -a
chmod a+rwx /mnt/send/
```

Pull in repo for scripts.

```text
git clone https://github.com/HankB/provoke_ZFS_corruption.git
cd provoke_ZFS_corruption
vim populate_pool.sh # change pool name "pool=send"
sudo ./populate_pool.sh # and killed when the pool hit 60%
```

```text
hdparm --user-master u --security-set-pass Eins /dev/sdb
hdparm --security-erase Eins /dev/sdb
zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O mountpoint=/mnt/recv \
      recv wwn-0x5002538d40878f8e
chmod a+rwx /mnt/recv/
```

```text
user=hbarta
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    send
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    recv
time -p syncoid --recursive --no-privilege-elevation send/test recv/test
```

`syncoid` unintentionally run as `root`. Hopefully that will not be an issue for further testing.

```text
root@orcus:/etc/sanoid# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 12795.53
user 426.10
sys 33351.88
root@orcus:/etc/sanoid#
```

```text
hbarta@orcus:~$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 9.23
user 2.62
sys 4.92
hbarta@orcus:~$ 
```

Ran as normal user w/ no issue. Kick off first stir

```text
vim stir_pool.sh # Fix start directory for find command
sudo chown -R $USER:$USER /mnt/send 
./stir_pool.sh
```

Now loop

```text
while(:)
do
    date +%Y-%m-%d-%H%M
    /home/$user/provoke_ZFS_corruption/stir_pool.sh 2>/dev/null
    sleep 750
done >>stir.txt
```

```text
while(:)
do
    date +%Y-%m-%d-%H%M
    time -p syncoid --recursive --no-privilege-elevation send/test recv/test
    zpool status send
    echo
    sleep 750
done >>syncoid.txt 2>&1
```

Testing under way at 2025-01-15-2014. And interrupting briefly to resume testing in a `tmux` session should it be necessary to restart the remote host at some point.

```text
sudo apt install tmux
tmux new -s syncoid
tmux new -s stir
tmux new -s dmesg
```

## 2025-01-24 kernel 4.18 ZFS 2.0.3 no errors

972 passes through the loop. 

```text
hbarta@orcus:~$ zfs --version
zfs-2.0.3-1
zfs-kmod-2.0.3-1
hbarta@orcus:~$ uname -a
Linux orcus 4.19.0-27-amd64 #1 SMP Debian 4.19.316-1 (2024-06-25) x86_64 GNU/Linux
hbarta@orcus:~$ 
hbarta@orcus:~$ grep errors: provoke_ZFS_corruption/syncoid.txt|wc -l
972
hbarta@orcus:~$ 
```

Time to try kernel 5.10 which was the combo in the original report. 5.10 is already in the Buster repo. It apppears that this is the oldest version:

```text
root@orcus:/etc/apt/sources.list.d# cd
root@orcus:~# apt search linux-image-5.10.0-0.deb10.24-amd64
Sorting... Done
Full Text Search... Done
linux-headers-5.10.0-0.deb10.24-amd64/oldoldstable 5.10.179-5~deb10u1 amd64
  Header files for Linux 5.10.0-0.deb10.24-amd64

linux-image-5.10.0-0.deb10.24-amd64/oldoldstable 5.10.179-5~deb10u1 amd64
  Linux 5.10 for 64-bit PCs (signed)

linux-image-5.10.0-0.deb10.24-amd64-dbg/oldoldstable 5.10.179-5~deb10u1 amd64
  Debug symbols for linux-image-5.10.0-0.deb10.24-amd64

linux-image-5.10.0-0.deb10.24-amd64-unsigned/oldoldstable 5.10.179-5~deb10u1 amd64
  Linux 5.10 for 64-bit PCs

root@orcus:~# 
```

Installing `linux-image-5.10.0-0.deb10.24-amd64` and `linux-headers-5.10.0-0.deb10.24-amd64`

Minor issues:

* Ethernet interfaces renamed to `eth0` and `eth1` - needed to tweak `/etc/network/interfaces` to get Ethernet working. `systemctl restart networking` did not work but `ifup eth1` brought it on line.
* Modules not built. Repeating following reboot.

```text
hdparm --user-master u --security-set-pass Eins /dev/sda
hdparm --security-erase Eins /dev/sda
zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O mountpoint=/mnt/recv \
      recv wwn-0x5002538d40878f8e
chmod a+rwx /mnt/recv/
```

## 2025-02-02 kernel 5.10 ZFS 2.1.3 no errors

Testing about 10 days and over 1100 `syncoid` loops. Time to evaluate this approach with the hope of getting faster and more reliable results.
