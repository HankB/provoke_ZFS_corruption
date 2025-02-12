# Setup Buster 5.10 kernel and ZFS 2.0.3

* [Results](./results.md)
* [Data](./data)

The versions for which the bug was reported. repeating with the current testing strategy (e.g. hit it as hard as possible.)

## 2025-02-11 initial setup

* install using `netinst` media
* remao MAC 

```text
root@orcus:/etc/systemd/network# cat 00-enp7s0.link
[Match]
Driver=macb bcmgenet r8152 r8169 e1000e

[Link]
MACAddress=00:25:90:06:df:be
root@orcus:/etc/systemd/network# 
```

* Tweak sources (add contrib) and upgrade.
* `apt install -y vim git  lzop pv mbuffer tree smartmontools lm-sensors parted shellcheck tmux time mkdocs lshw`
* upgrade kernel `apt install -y linux-image-5.10.0-0.deb10.24-amd64 linux-headers-5.10.0-0.deb10.24-amd64`
* reboot
* Add backports, `buster-backports` NLA. Use `archive`

```text
root@orcus:~# cat /etc/apt/sources.list.d/buster-backports.list
deb http://archive.debian.org/debian buster-backports main contrib
deb-src http://archive.debian.org/debian buster-backports main contrib

root@orcus:~# apt search -t buster-backports zfs-dkms
Sorting... Done
Full Text Search... Done
spl-dkms/buster-backports 2.0.3-9~bpo10+1 all
  Solaris Porting Layer kernel modules for Linux (dummy)

zfs-dkms/buster-backports 2.0.3-9~bpo10+1 all
  OpenZFS filesystem kernel modules for Linux

root@orcus:~# 
```

```text
apt install dpkg-dev
apt install -t buster-backports zfs-dkms zfsutils-linux
```

Result is now

```text
hbarta@orcus:~$ zfs --version
zfs-2.0.3-9~bpo10+1
zfs-kmod-2.0.3-9~bpo10+1
hbarta@orcus:~$ uname -a
Linux orcus 5.10.0-0.deb10.24-amd64 #1 SMP Debian 5.10.179-5~deb10u1 (2023-08-08) x86_64 GNU/Linux
hbarta@orcus:~$ 
```

Produce key for Github, clone repo.

```text
ssh-keygen -t rsa -b 4096 -C "hbarta@gmail.com"
cat /home/hbarta/.ssh/id_rsa.pub
git clone git@github.com:HankB/provoke_ZFS_corruption.git
```

Secure erase the SSDs which will hold the pools. (`/dev/sda` and `/dev/sdb`)

```text
hdparm --user-master u --security-set-pass Eins /dev/sda
hdparm --security-erase Eins /dev/sda
hdparm --user-master u --security-set-pass Eins /dev/sdb
hdparm --security-erase Eins /dev/sdb
```

Create the `send` and recv pools.

```text
dd if=/dev/urandom bs=32 count=1 of=/pool-key
zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O encryption=aes-256-gcm  -O keylocation=file:///pool-key -O keyformat=raw \
      -O mountpoint=/mnt/send \
      send wwn-0x5002538d40878f8e
zfs load-key -a

zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O mountpoint=/mnt/recv \
      recv wwn-0x5002538d41628a33
```

Result:

```text
root@orcus:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   528K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   576K   464G        -         -     0%     0%  1.00x    ONLINE  -
root@orcus:~# 
```

Kick off the populate script.

```text
root@orcus:/home/hbarta/Downloads# time -p /home/hbarta/provoke_ZFS_corruption/scripts/populate_pool.sh 
...
Terminated
real 3211.75
user 99.68
sys 3215.42
root@orcus:~#
```

Killed from another session. It ran over what was desired. This will require management snapshots in the `recv` pool as well.

```text
root@orcus:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   327G   137G        -         -     0%    70%  1.00x    ONLINE  -
send   464G   327G   137G        -         -     0%    70%  1.00x    ONLINE  -
root@orcus:~# 
```

## 2025-02-12 start thrashing

Running in seperate (`tmux`) windows.

* `cd`
* `ln provoke_ZFS_corruption/scripts/*.sh bin/`
* `mkdir logs`
* `tmux new -s stir` and `thrash_stir.sh`
* `tmux new -s syncoid` and `thrash_syncoid.sh`
* `tmux new -s snaps` and `manage_snaps.sh` (After tweaking to manage both pools)

At 1513 after the test was running for hours I was surprised that there was no fragmentation. I checked and found that I had apparently forgotten to check perms/ownership and no files were being modified. That's now fixed and the test is *really* running.
