# ARM64 SATA via ISB trial

`namtarri`, Pi 4B/4GB running Ubuntu 24.04 and ZFS `zfs-2.2.2-0ubuntu9.1` on a small-ish (120GB) SSD and with Ubuntu and KDE desktops installed. Already in use for some other storage testing and that makes it an ideal candidate for this.

## 2024-12-19 add ZFS

```text
apt install zfsutils-linux
```

```text
user=hbarta
pool=namtarri_tank
device=wwn-0x50026b77823afca1-part3
dd if=/dev/urandom bs=32 count=1 of=/pool-key
zpool create -o ashift=13 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O encryption=aes-256-gcm  -O keylocation=file:///pool-key -O keyformat=raw \
      -O mountpoint=/mnt/$pool \
      $pool $device
zfs load-key -a
zfs mount $pool
chmod a+rwx /mnt/$pool/
```

Rather than try to guess what tunables will populate the pool, just kill the process when there is "enouth" there.

