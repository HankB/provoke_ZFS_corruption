# Linux Trixie 2.3.0 bzfs

Suggestion to use `bzfs` to drive ZFS send/recv insteaf of `syncoid` to see if the patterns it uses similarly provoke the error. <https://zfsonlinux.topicbox.com/groups/zfs-discuss/Tf3aa320b5d3f11ef>

## 2025-02-26 plan

Revert the patch and `dpkg-reconfigure` to return to the released version.

```text
sudo vim /usr/src/zfs-2.3.0/module/zfs/dbuf.c
sudo dpkg-reconfigure zfs-dkms
sudo shutdown -r now
```

Destroy and recreate pools.

```text
sudo zpool export recv
sudo zpool export send
sudo smartctl -a /dev/sda # confirn device for pool
sudo smartctl -a /dev/sdb
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
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   480K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   600K   464G        -         -     0%     0%  1.00x    ONLINE  -
root@orion:~# 
```

Populate `send` pool.

```text
root@orion:~# time -p sudo /home/hbarta/bin/populate_pool.sh
...
real 2249.36
user 1.85
sys 6.22
root@orion:~#
```

Pull `bzfs` from Github.

```text
cd
git clone https://github.com/whoschek/bzfs.git
sudo apt-get -y install zfsutils-linux python3 
sudo apt-get -y install zstd pv mbuffer
cd bzfs/bzfs
./bzfs --help  # Run the CLI
cd
ln /home/hbarta/bzfs/bzfs/bzfs bin/
ln /home/hbarta/bzfs/bzfs/bzfs.py bin/
bzfs --help # verify operation
```

First `bzfs` invocation as `root`.

```text
time -p /home/hbarta/bin/bzfs --verbose --recursive --no-privilege-elevation send/test recv/test

time -p /home/hbarta/bin/bzfs send/test recv/test

zfs snap -r send@2025-02-26-1252
time -p /home/hbarta/bin/bzfs --verbose --recursive --no-privilege-elevation send/test recv/test
```

## 2025-02-26 Results

[Data](./data.md)

This test copied the pool in record time - 543.38s, but there were issues.

* The script itself reported errors.
* It copied the pool encrypted. 
* It's not obvious that this script will manage snapshots in the way that `syncoid` does.

Lacking the knowledge configure `bzfs` to behave as a drop in replacement for `syncoid` I'm setting it aside.
