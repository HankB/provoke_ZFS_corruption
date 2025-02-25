# Linux Trixie 2.3.0 patched

Corruption was previously [produiced with 2.3.0 on Debian Trixie](../2025-02-23_Linux_Bookworm_Trixie_2.3.0/results.md) (with 2.3.0 installed via the Debian package.) The purpose of this test is to apply the [patch provided by Ivan Volosyuk](https://github.com/openzfs/zfs/pull/17069)

The plan here is to continue with the same installation after editing the indicated file `dbuf.c` and updating the ZFS modules.

```text
sudo vim /usr/src/zfs-2.3.0/module/zfs/dbuf.c
sudo dpkg-reconfigure zfs-dkms
```

```text
hbarta@orion:/usr/src/zfs-2.3.0$ sudo dpkg-reconfigure zfs-dkms
Module zfs/2.3.0 for kernel 6.1.0-31-amd64 (x86_64):
Before uninstall, this module version was ACTIVE on this kernel.
Deleting /lib/modules/6.1.0-31-amd64/updates/dkms/zfs.ko
Deleting /lib/modules/6.1.0-31-amd64/updates/dkms/spl.ko
Running depmod.... done.

Module zfs/2.3.0 for kernel 6.12.12-amd64 (x86_64):
Before uninstall, this module version was ACTIVE on this kernel.
Deleting /lib/modules/6.12.12-amd64/updates/dkms/zfs.ko.xz
Deleting /lib/modules/6.12.12-amd64/updates/dkms/spl.ko.xz
Running depmod...... done.

Deleting module zfs/2.3.0 completely from the DKMS tree.
Loading new zfs/2.3.0 DKMS files...
Building for 6.1.0-31-amd64 and 6.12.12-amd64

Building initial module zfs/2.3.0 for 6.1.0-31-amd64
Done.
Installing /lib/modules/6.1.0-31-amd64/updates/dkms/zfs.ko
Installing /lib/modules/6.1.0-31-amd64/updates/dkms/spl.ko
Running depmod... done.

Building initial module zfs/2.3.0 for 6.12.12-amd64
Done.
Installing /lib/modules/6.12.12-amd64/updates/dkms/zfs.ko.xz
Installing /lib/modules/6.12.12-amd64/updates/dkms/spl.ko.xz
Running depmod..... done.
hbarta@orion:/usr/src/zfs-2.3.0$ 
```

(Reboot to be absolutely certain that the patched module is loaded.)

Repeating steps from [the previous test](../2025-02-23_Linux_Bookworm_Trixie_2.3.0/setup.md#2025-02-24-secure-erase-and-create-pools)

```text
sudo zpool export recv
sudo zpool export send
sudo hdparm --user-master u --security-set-pass Eins /dev/sda
sudo hdparm --security-erase Eins /dev/sda
sudo hdparm --user-master u --security-set-pass Eins /dev/sdb
sudo hdparm --security-erase Eins /dev/sdb
```

```text
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
root@orion:/home/hbarta# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   552K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   612K   464G        -         -     0%     0%  1.00x    ONLINE  -
root@orion:/home/hbarta# 
```

Populate `send` pool.

```text
root@orion:/home/hbarta# sudo /home/hbarta/bin/populate_pool.sh
...
Capacity target 50 met
+ exit
```

First `syncoid` (as root)

```text
time -p syncoid --recursive --no-privilege-elevation send/test recv/test
```

```text
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 2432.08
user 40.82
sys 2020.74
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

## 2025-02-24 second syncoid

```text
hbarta@orion:~$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 16.31
user 4.08
sys 8.22
hbarta@orion:~$ 
```

[full output](./data.md#2025-02-24-second-syncoid)

## 2025-02-24 start thrashing

```text
cd
mkdir /mnt/storage/logs.2025-02-24_Linux_Trixie_2.3.0_patched/
ln -s /mnt/storage/logs.2025-02-24_Linux_Trixie_2.3.0_patched/ /home/hbarta/logs
tmux new -D -s "stir" thrash_stir.sh
tmux new -D -s syncoid thrash_syncoid.sh
tmux new -D -s snaps manage_snaps.sh
```

Kicked off at about 1942 and produced corruption at 2143.