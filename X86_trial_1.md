# X86 trial one

Purpose: Try on a more performant host and avoid the network bottleneck by copying between pools on the same SSD.

## 2024-12-17 setup

Secure erase a 1TB 850 EVO SSD and install Debian (w/out desktop) Using 12.7.0 Netinst media on bootable USB. The UUID of the boot partition suggest it is current as of 2024-08-31 (`2024-08-31-10-43-00-00`).

Add ZFS and other miscellaneous stuff.

```text
root@iox86:~# zfs --version
zfs-2.1.11-1
zfs-kmod-2.1.11-1
root@iox86:~# 
```

Partition table following repartition (fullowing installation with separate HOME partition.)

```text
root@iox86:~# partx -l /dev/sda
# 1:      2048- 58593279 ( 58591232 sectors,  29998 MB)
# 2:  58595326-1953523711 (1894928386 sectors, 970203 MB)
# 5:  58595328- 60594175 (  1998848 sectors,   1023 MB)
# 6:  60596224- 81567743 ( 20971520 sectors,  10737 MB)
# 7:  81569792-1027786751 (946216960 sectors, 484463 MB)
# 8: 1027788800-1953523711 (925734912 sectors, 473976 MB)
root@iox86:~# 
```

#7 will be an encrypted (send) receive partition and #8 will be an unencrypted (recv) partition and will be named accordingly.

```text
zpool destroy send
user=hbarta
dd if=/dev/urandom bs=32 count=1 of=/pool-key
zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O encryption=aes-256-gcm  -O keylocation=file:///pool-key -O keyformat=raw \
      -O mountpoint=/mnt/send \
      send wwn-0x5002538d40dca5d9-part7
zfs load-key -a
chmod a+rwx /mnt/send/
```

```text
zpool destroy recv
user=hbarta
zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O mountpoint=/mnt/recv \
      recv wwn-0x5002538d40dca5d9-part8
chmod a+rwx /mnt/recv/
```

(`populate_pol.sh` already started)

```text
root@iox86:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   440G   516K   440G        -         -     0%     0%  1.00x    ONLINE  -
send   448G  1.03G   447G        -         -     0%     0%  1.00x    ONLINE  -
root@iox86:~# 
```

