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

(`populate_pool.sh` already started)

```text
root@iox86:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   440G   516K   440G        -         -     0%     0%  1.00x    ONLINE  -
send   448G  1.03G   447G        -         -     0%     0%  1.00x    ONLINE  -
root@iox86:~# 
```

Pool populated, 34% only. Should be enough.

```text
hbarta@iox86:~$ zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   440G   432K   440G        -         -     0%     0%  1.00x    ONLINE  -
send   448G   153G   295G        -         -     1%    34%  1.00x    ONLINE  -
hbarta@iox86:~$ 
```

`syncoid` command

```
user=hbarta
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    send
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    recv
time -p /sbin/syncoid --recursive --no-privilege-elevation send recv
```

```text
hbarta@iox86:~$ time -p /sbin/syncoid --recursive --no-privilege-elevation send recv

CRITICAL ERROR: Target recv exists but has no snapshots matching with send!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.

Sending incremental send/test@autosnap_2024-12-17_18:08:55_monthly ... syncoid_iox86_2024-12-17:18:27:41-GMT-06:00 (~ 4 KB):
4.57KiB 0:00:00 [32.7KiB/s] [===================================================================================================] 114%            
Sending incremental send/test/l0_0@autosnap_2024-12-17_18:08:55_monthly ... syncoid_iox86_2024-12-17:18:27:41-GMT-06:00 (~ 4 KB):
4.57KiB 0:00:00 [26.4KiB/s] [===================================================================================================] 114%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_0 to recv/test/l0_0/l1_0 (~ 44.3 GB remaining):
44.4GiB 0:02:45 [ 273MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_0': Insufficient privileges
CRITICAL ERROR:  zfs send  -t 1-f14a5c7b5-e8-789c636064000310a500c4ec50360710e72765a52697303030419460caa7a515a7968064527a61f26c48f2499525a9c5405ac3644f2f36fd25f9e9a599290c0c6d89e5fd8f65ba152390e439c1f27989b9a90c0cc5a97929fa40a34af4730ce20df4730ce30d1c124b4bf28bf3120be28d0c8c4c740d8d740dcde30d2dac0c2cac4c4de373f3f34a32722a19900000d967254d | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 47597326712 |  zfs receive  -s -F 'recv/test/l0_0/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@autosnap_2024-12-17_18:08:55_monthly (~ 54.7 GB) to new target filesystem:
54.8GiB 0:03:24 [ 274MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_0/l1_0/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_0/l1_0/l2_0'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 58757400512 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_0' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@autosnap_2024-12-17_18:08:55_monthly (~ 61.3 GB) to new target filesystem:
61.3GiB 0:03:47 [ 275MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_0/l1_0/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_0/l1_0/l2_1'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 65795564688 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_1' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@autosnap_2024-12-17_18:08:55_monthly (~ 56.8 GB) to new target filesystem:
56.8GiB 0:03:30 [ 276MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_0/l1_0/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_0/l1_0/l2_2'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 60989925624 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_2' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@autosnap_2024-12-17_18:08:55_monthly (~ 59.8 GB) to new target filesystem:
59.9GiB 0:03:42 [ 274MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_0/l1_0/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_0/l1_0/l2_3'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 64232596912 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_3' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@autosnap_2024-12-17_18:08:55_monthly (~ 59.5 GB) to new target filesystem:
59.6GiB 0:03:41 [ 275MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_1': Insufficient privileges
CRITICAL ERROR:  zfs send  'send/test/l0_0/l1_1'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 63920628208 |  zfs receive  -s -F 'recv/test/l0_0/l1_1' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@autosnap_2024-12-17_18:08:55_monthly (~ 57.5 GB) to new target filesystem:
57.5GiB 0:03:31 [ 278MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_0/l1_1/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_0/l1_1/l2_0'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 61728552472 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_0' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@autosnap_2024-12-17_18:08:55_monthly (~ 56.5 GB) to new target filesystem:
56.6GiB 0:03:28 [ 277MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_0/l1_1/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_0/l1_1/l2_1'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 60696400344 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_1' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@autosnap_2024-12-17_18:08:55_monthly (~ 59.3 GB) to new target filesystem:
59.3GiB 0:03:39 [ 277MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_0/l1_1/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_0/l1_1/l2_2'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 63672896752 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_2' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@autosnap_2024-12-17_18:08:55_monthly (~ 63.3 GB) to new target filesystem:
63.3GiB 0:03:54 [ 276MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_0/l1_1/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_0/l1_1/l2_3'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 67915853632 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_3' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@autosnap_2024-12-17_18:08:55_monthly (~ 47.6 GB) to new target filesystem:
47.7GiB 0:02:54 [ 279MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_2': Insufficient privileges
CRITICAL ERROR:  zfs send  'send/test/l0_0/l1_2'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 51141392128 |  zfs receive  -s -F 'recv/test/l0_0/l1_2' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@autosnap_2024-12-17_18:08:55_monthly (~ 57.2 GB) to new target filesystem:
57.3GiB 0:03:29 [ 279MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_0/l1_2/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_0/l1_2/l2_0'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 61462012496 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_0' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@autosnap_2024-12-17_18:08:55_monthly (~ 55.9 GB) to new target filesystem:
55.9GiB 0:03:23 [ 281MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_0/l1_2/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_0/l1_2/l2_1'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 60042737272 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_1' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@autosnap_2024-12-17_18:08:55_monthly (~ 47.0 GB) to new target filesystem:
47.0GiB 0:02:53 [ 278MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_0/l1_2/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_0/l1_2/l2_2'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 50492062552 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_2' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@autosnap_2024-12-17_18:08:55_monthly (~ 46.1 GB) to new target filesystem:
46.1GiB 0:02:47 [ 282MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_0/l1_2/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_0/l1_2/l2_3'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 49456268208 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_3' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@autosnap_2024-12-17_18:08:55_monthly (~ 46.8 GB) to new target filesystem:
46.9GiB 0:02:50 [ 282MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_3': Insufficient privileges
CRITICAL ERROR:  zfs send  'send/test/l0_0/l1_3'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 50287145312 |  zfs receive  -s -F 'recv/test/l0_0/l1_3' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@autosnap_2024-12-17_18:08:55_monthly (~ 64.6 GB) to new target filesystem:
64.7GiB 0:03:55 [ 280MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_0/l1_3/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_0/l1_3/l2_0'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 69389645152 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_0' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@autosnap_2024-12-17_18:08:55_monthly (~ 54.8 GB) to new target filesystem:
54.8GiB 0:03:19 [ 281MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_0/l1_3/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_0/l1_3/l2_1'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 58829341272 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_1' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@autosnap_2024-12-17_18:08:55_monthly (~ 52.1 GB) to new target filesystem:
52.1GiB 0:03:10 [ 280MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_0/l1_3/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_0/l1_3/l2_2'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 55905630256 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_2' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@autosnap_2024-12-17_18:08:55_monthly (~ 62.3 GB) to new target filesystem:
62.3GiB 0:03:44 [ 284MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_0/l1_3/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_0/l1_3/l2_3'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 66900945376 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_3' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_1@autosnap_2024-12-17_18:08:55_monthly (~ 58.1 GB) to new target filesystem:
58.2GiB 0:03:29 [ 283MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1': Insufficient privileges
CRITICAL ERROR:  zfs send  'send/test/l0_1'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 62415749312 |  zfs receive  -s -F 'recv/test/l0_1' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@autosnap_2024-12-17_18:08:55_monthly (~ 58.7 GB) to new target filesystem:
58.8GiB 0:03:31 [ 283MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_1/l1_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_1/l1_0'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 63063218776 |  zfs receive  -s -F 'recv/test/l0_1/l1_0' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@autosnap_2024-12-17_18:08:55_monthly (~ 47.1 GB) to new target filesystem:
47.1GiB 0:02:51 [ 281MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_1/l1_0/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_1/l1_0/l2_0'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 50571550440 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_0' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@autosnap_2024-12-17_18:08:55_monthly (~ 56.6 GB) to new target filesystem:
56.6GiB 0:03:25 [ 281MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_1/l1_0/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_1/l1_0/l2_1'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 60759850424 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_1' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@autosnap_2024-12-17_18:08:55_monthly (~ 53.8 GB) to new target filesystem:
53.9GiB 0:03:15 [ 282MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_1/l1_0/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_1/l1_0/l2_2'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 57794871592 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_2' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@autosnap_2024-12-17_18:08:55_monthly (~ 49.6 GB) to new target filesystem:
49.6GiB 0:02:58 [ 283MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_1/l1_0/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_1/l1_0/l2_3'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 53217938008 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_3' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@autosnap_2024-12-17_18:08:55_monthly (~ 52.2 GB) to new target filesystem:
52.2GiB 0:03:07 [ 285MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_1/l1_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_1/l1_1'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 56068607016 |  zfs receive  -s -F 'recv/test/l0_1/l1_1' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@autosnap_2024-12-17_18:08:55_monthly (~ 55.2 GB) to new target filesystem:
55.3GiB 0:03:18 [ 285MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_1/l1_1/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_1/l1_1/l2_0'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 59313925952 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_0' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@autosnap_2024-12-17_18:08:55_monthly (~ 55.3 GB) to new target filesystem:
55.3GiB 0:03:19 [ 283MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_1/l1_1/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_1/l1_1/l2_1'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 59387638576 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_1' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_2@autosnap_2024-12-17_18:08:55_monthly (~ 55.2 GB) to new target filesystem:
55.2GiB 0:03:17 [ 286MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_1/l1_1/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_1/l1_1/l2_2'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 59220496440 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_2' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_3@autosnap_2024-12-17_18:08:55_monthly (~ 67.2 GB) to new target filesystem:
67.2GiB 0:03:59 [ 287MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_1/l1_1/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_1/l1_1/l2_3'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 72167686584 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_3' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_1/l1_2@autosnap_2024-12-17_18:08:55_monthly (~ 61.8 GB) to new target filesystem:
61.8GiB 0:03:42 [ 284MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_1/l1_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_1/l1_2'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 66337018216 |  zfs receive  -s -F 'recv/test/l0_1/l1_2' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_0@autosnap_2024-12-17_18:08:55_monthly (~ 55.7 GB) to new target filesystem:
55.8GiB 0:03:19 [ 286MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_1/l1_2/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_1/l1_2/l2_0'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 59852038688 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_0' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_1@autosnap_2024-12-17_18:08:55_monthly (~ 64.2 GB) to new target filesystem:
64.2GiB 0:03:49 [ 286MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_1/l1_2/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_1/l1_2/l2_1'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 68926118776 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_1' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_2@autosnap_2024-12-17_18:08:55_monthly (~ 49.8 GB) to new target filesystem:
49.8GiB 0:02:58 [ 286MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_1/l1_2/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_1/l1_2/l2_2'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 53489666600 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_2' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_3@autosnap_2024-12-17_18:08:55_monthly (~ 55.7 GB) to new target filesystem:
55.7GiB 0:03:19 [ 285MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_1/l1_2/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_1/l1_2/l2_3'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 59756865800 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_3' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_1/l1_3@autosnap_2024-12-17_18:08:55_monthly (~ 47.9 GB) to new target filesystem:
47.9GiB 0:02:53 [ 282MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_1/l1_3': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_1/l1_3'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 51425569560 |  zfs receive  -s -F 'recv/test/l0_1/l1_3' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_1/l1_3/l2_0@autosnap_2024-12-17_18:08:55_monthly (~ 61.2 GB) to new target filesystem:
61.2GiB 0:03:38 [ 286MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_1/l1_3/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_1/l1_3/l2_0'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 65669764096 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_0' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_1/l1_3/l2_1@autosnap_2024-12-17_18:08:55_monthly (~ 52.2 GB) to new target filesystem:
52.3GiB 0:03:07 [ 286MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_1/l1_3/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_1/l1_3/l2_1'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 56095368904 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_1' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_1/l1_3/l2_2@autosnap_2024-12-17_18:08:55_monthly (~ 64.0 GB) to new target filesystem:
64.0GiB 0:03:48 [ 287MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_1/l1_3/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_1/l1_3/l2_2'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 68714579160 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_2' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_1/l1_3/l2_3@autosnap_2024-12-17_18:08:55_monthly (~ 55.3 GB) to new target filesystem:
55.3GiB 0:03:21 [ 280MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_1/l1_3/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_1/l1_3/l2_3'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 59352482448 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_3' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_2@autosnap_2024-12-17_18:08:55_monthly (~ 46.0 GB) to new target filesystem:
46.0GiB 0:02:44 [ 286MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2': Insufficient privileges
CRITICAL ERROR:  zfs send  'send/test/l0_2'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 49381827624 |  zfs receive  -s -F 'recv/test/l0_2' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_2/l1_0@autosnap_2024-12-17_18:08:55_monthly (~ 58.9 GB) to new target filesystem:
59.0GiB 0:03:30 [ 286MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_2/l1_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_2/l1_0'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 63266546608 |  zfs receive  -s -F 'recv/test/l0_2/l1_0' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_2/l1_0/l2_0@autosnap_2024-12-17_18:08:55_monthly (~ 49.5 GB) to new target filesystem:
49.5GiB 0:02:57 [ 285MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_2/l1_0/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_2/l1_0/l2_0'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 53112363128 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_0' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_2/l1_0/l2_1@autosnap_2024-12-17_18:08:55_monthly (~ 69.5 GB) to new target filesystem:
69.5GiB 0:04:08 [ 286MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_2/l1_0/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_2/l1_0/l2_1'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 74599368192 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_1' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_2/l1_0/l2_2@autosnap_2024-12-17_18:08:55_monthly (~ 59.9 GB) to new target filesystem:
60.0GiB 0:03:36 [ 283MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_2/l1_0/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_2/l1_0/l2_2'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 64359423160 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_2' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_2/l1_0/l2_3@autosnap_2024-12-17_18:08:55_monthly (~ 56.6 GB) to new target filesystem:
56.7GiB 0:03:23 [ 284MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_2/l1_0/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_2/l1_0/l2_3'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 60825408608 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_3' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_2/l1_1@autosnap_2024-12-17_18:08:55_monthly (~ 52.4 GB) to new target filesystem:
52.4GiB 0:03:07 [ 286MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_2/l1_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_2/l1_1'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 56248879032 |  zfs receive  -s -F 'recv/test/l0_2/l1_1' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_2/l1_1/l2_0@autosnap_2024-12-17_18:08:55_monthly (~ 46.9 GB) to new target filesystem:
46.9GiB 0:02:48 [ 284MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_2/l1_1/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_2/l1_1/l2_0'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 50361659808 |  zfs receive  -s -F 'recv/test/l0_2/l1_1/l2_0' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_2/l1_1/l2_1@autosnap_2024-12-17_18:08:55_monthly (~ 61.4 GB) to new target filesystem:
61.5GiB 0:03:41 [ 283MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_2/l1_1/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_2/l1_1/l2_1'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 65978227984 |  zfs receive  -s -F 'recv/test/l0_2/l1_1/l2_1' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_2/l1_1/l2_2@autosnap_2024-12-17_18:08:55_monthly (~ 58.8 GB) to new target filesystem:
58.8GiB 0:03:29 [ 287MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_2/l1_1/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_2/l1_1/l2_2'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 63085452424 |  zfs receive  -s -F 'recv/test/l0_2/l1_1/l2_2' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_2/l1_1/l2_3@autosnap_2024-12-17_18:08:55_monthly (~ 64.5 GB) to new target filesystem:
64.5GiB 0:03:49 [ 287MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_2/l1_1/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_2/l1_1/l2_3'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 69247203720 |  zfs receive  -s -F 'recv/test/l0_2/l1_1/l2_3' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_2/l1_2@autosnap_2024-12-17_18:08:55_monthly (~ 65.7 GB) to new target filesystem:
65.7GiB 0:03:54 [ 286MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_2/l1_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_2/l1_2'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 70525315256 |  zfs receive  -s -F 'recv/test/l0_2/l1_2' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_2/l1_2/l2_0@autosnap_2024-12-17_18:08:55_monthly (~ 53.8 GB) to new target filesystem:
53.9GiB 0:03:15 [ 282MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_2/l1_2/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_2/l1_2/l2_0'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 57795675512 |  zfs receive  -s -F 'recv/test/l0_2/l1_2/l2_0' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_2/l1_2/l2_1@autosnap_2024-12-17_18:08:55_monthly (~ 44.0 GB) to new target filesystem:
44.0GiB 0:02:40 [ 280MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_2/l1_2/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_2/l1_2/l2_1'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 47242143512 |  zfs receive  -s -F 'recv/test/l0_2/l1_2/l2_1' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_2/l1_2/l2_2@autosnap_2024-12-17_18:08:55_monthly (~ 52.1 GB) to new target filesystem:
52.2GiB 0:03:05 [ 287MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_2/l1_2/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_2/l1_2/l2_2'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 55982111360 |  zfs receive  -s -F 'recv/test/l0_2/l1_2/l2_2' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_2/l1_2/l2_3@autosnap_2024-12-17_18:08:55_monthly (~ 57.5 GB) to new target filesystem:
57.6GiB 0:03:24 [ 288MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_2/l1_2/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_2/l1_2/l2_3'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 61790287848 |  zfs receive  -s -F 'recv/test/l0_2/l1_2/l2_3' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_2/l1_3@autosnap_2024-12-17_18:08:55_monthly (~ 57.4 GB) to new target filesystem:
57.4GiB 0:03:26 [ 285MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_2/l1_3': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_2/l1_3'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 61629029704 |  zfs receive  -s -F 'recv/test/l0_2/l1_3' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_2/l1_3/l2_0@autosnap_2024-12-17_18:08:55_monthly (~ 54.7 GB) to new target filesystem:
54.7GiB 0:03:17 [ 283MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_2/l1_3/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_2/l1_3/l2_0'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 58691464944 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_0' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_2/l1_3/l2_1@autosnap_2024-12-17_18:08:55_monthly (~ 56.6 GB) to new target filesystem:
56.7GiB 0:03:22 [ 286MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_2/l1_3/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_2/l1_3/l2_1'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 60799079400 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_1' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_2/l1_3/l2_2@autosnap_2024-12-17_18:08:55_monthly (~ 51.0 GB) to new target filesystem:
51.0GiB 0:03:02 [ 285MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_2/l1_3/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_2/l1_3/l2_2'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 54765630752 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_2' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_2/l1_3/l2_3@autosnap_2024-12-17_18:08:55_monthly (~ 58.2 GB) to new target filesystem:
58.2GiB 0:03:27 [ 288MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_2/l1_3/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_2/l1_3/l2_3'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 62509037512 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_3' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_3@autosnap_2024-12-17_18:08:55_monthly (~ 61.5 GB) to new target filesystem:
61.6GiB 0:03:40 [ 286MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3': Insufficient privileges
CRITICAL ERROR:  zfs send  'send/test/l0_3'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 66082352904 |  zfs receive  -s -F 'recv/test/l0_3' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_3/l1_0@autosnap_2024-12-17_18:08:55_monthly (~ 62.5 GB) to new target filesystem:
62.5GiB 0:03:42 [ 288MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_3/l1_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_3/l1_0'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 67102523688 |  zfs receive  -s -F 'recv/test/l0_3/l1_0' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_3/l1_0/l2_0@autosnap_2024-12-17_18:08:55_monthly (~ 50.6 GB) to new target filesystem:
50.7GiB 0:03:00 [ 287MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_3/l1_0/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_3/l1_0/l2_0'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 54381140968 |  zfs receive  -s -F 'recv/test/l0_3/l1_0/l2_0' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_3/l1_0/l2_1@autosnap_2024-12-17_18:08:55_monthly (~ 62.1 GB) to new target filesystem:
62.2GiB 0:03:41 [ 287MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_3/l1_0/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_3/l1_0/l2_1'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 66702650328 |  zfs receive  -s -F 'recv/test/l0_3/l1_0/l2_1' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_3/l1_0/l2_2@autosnap_2024-12-17_18:08:55_monthly (~ 63.0 GB) to new target filesystem:
63.1GiB 0:03:44 [ 287MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_3/l1_0/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_3/l1_0/l2_2'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 67675835560 |  zfs receive  -s -F 'recv/test/l0_3/l1_0/l2_2' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_3/l1_0/l2_3@autosnap_2024-12-17_18:08:55_monthly (~ 61.7 GB) to new target filesystem:
61.8GiB 0:03:43 [ 283MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_3/l1_0/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_3/l1_0/l2_3'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 66284263544 |  zfs receive  -s -F 'recv/test/l0_3/l1_0/l2_3' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_3/l1_1@autosnap_2024-12-17_18:08:55_monthly (~ 53.8 GB) to new target filesystem:
53.9GiB 0:03:12 [ 287MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_3/l1_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_3/l1_1'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 57793524216 |  zfs receive  -s -F 'recv/test/l0_3/l1_1' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_3/l1_1/l2_0@autosnap_2024-12-17_18:08:55_monthly (~ 51.3 GB) to new target filesystem:
51.3GiB 0:03:03 [ 286MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_3/l1_1/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_3/l1_1/l2_0'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 55101137472 |  zfs receive  -s -F 'recv/test/l0_3/l1_1/l2_0' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_3/l1_1/l2_1@autosnap_2024-12-17_18:08:55_monthly (~ 44.8 GB) to new target filesystem:
44.9GiB 0:02:40 [ 285MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_3/l1_1/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_3/l1_1/l2_1'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 48150984632 |  zfs receive  -s -F 'recv/test/l0_3/l1_1/l2_1' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_3/l1_1/l2_2@autosnap_2024-12-17_18:08:55_monthly (~ 53.1 GB) to new target filesystem:
53.1GiB 0:03:09 [ 287MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_3/l1_1/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_3/l1_1/l2_2'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 56986207472 |  zfs receive  -s -F 'recv/test/l0_3/l1_1/l2_2' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_3/l1_1/l2_3@autosnap_2024-12-17_18:08:55_monthly (~ 59.0 GB) to new target filesystem:
59.0GiB 0:03:33 [ 283MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_3/l1_1/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_3/l1_1/l2_3'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 63316540808 |  zfs receive  -s -F 'recv/test/l0_3/l1_1/l2_3' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_3/l1_2@autosnap_2024-12-17_18:08:55_monthly (~ 45.9 GB) to new target filesystem:
46.0GiB 0:02:43 [ 287MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_3/l1_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_3/l1_2'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 49324850232 |  zfs receive  -s -F 'recv/test/l0_3/l1_2' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_3/l1_2/l2_0@autosnap_2024-12-17_18:08:55_monthly (~ 57.5 GB) to new target filesystem:
57.5GiB 0:03:24 [ 287MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_3/l1_2/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_3/l1_2/l2_0'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 61735783840 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_0' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_3/l1_2/l2_1@autosnap_2024-12-17_18:08:55_monthly (~ 64.9 GB) to new target filesystem:
64.9GiB 0:03:51 [ 286MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_3/l1_2/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_3/l1_2/l2_1'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 69649392584 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_1' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_3/l1_2/l2_2@autosnap_2024-12-17_18:08:55_monthly (~ 57.0 GB) to new target filesystem:
57.0GiB 0:03:26 [ 282MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_3/l1_2/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_3/l1_2/l2_2'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 61151711024 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_2' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_3/l1_2/l2_3@autosnap_2024-12-17_18:08:55_monthly (~ 49.7 GB) to new target filesystem:
49.7GiB 0:02:57 [ 286MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_3/l1_2/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_3/l1_2/l2_3'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 53314751688 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_3' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_3/l1_3@autosnap_2024-12-17_18:08:55_monthly (~ 51.1 GB) to new target filesystem:
51.1GiB 0:03:01 [ 287MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_3/l1_3': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_3/l1_3'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 54847848392 |  zfs receive  -s -F 'recv/test/l0_3/l1_3' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_3/l1_3/l2_0@autosnap_2024-12-17_18:08:55_monthly (~ 59.0 GB) to new target filesystem:
59.1GiB 0:03:29 [ 288MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_3/l1_3/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_3/l1_3/l2_0'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 63386705424 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_0' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_3/l1_3/l2_1@autosnap_2024-12-17_18:08:55_monthly (~ 61.8 GB) to new target filesystem:
61.9GiB 0:03:40 [ 287MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_3/l1_3/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_3/l1_3/l2_1'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 66400630272 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_1' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_3/l1_3/l2_2@autosnap_2024-12-17_18:08:55_monthly (~ 63.3 GB) to new target filesystem:
63.3GiB 0:03:45 [ 288MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_3/l1_3/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_3/l1_3/l2_2'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 67975817144 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_2' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot send/test/l0_3/l1_3/l2_3@autosnap_2024-12-17_18:08:55_monthly (~ 56.1 GB) to new target filesystem:
56.1GiB 0:03:19 [ 287MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/recv/test/l0_3/l1_3/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'send/test/l0_3/l1_3/l2_3'@'autosnap_2024-12-17_18:08:55_monthly' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 60193320672 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_3' failed: 256 at /sbin/syncoid line 492.
real 16815.53
user 1474.01
sys 26570.27
hbarta@iox86:~$ 
hbarta@iox86:~$ zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   440G   150G   290G        -         -     1%    34%  1.00x    ONLINE  -
send   448G   153G   295G        -         -     1%    34%  1.00x    ONLINE  -
hbarta@iox86:~$ 
```

Rerunning the `syncoid` command took 338.20s.

## 2024-12-18 stirring and syncing

Looping `stir_pool.sh` and the syncoid command on the other host `io` has successfully provoked the errors. That process will be repeated here, again with a 15 minute delay.

First mount all datasets and change ownership to user.

```text
for i in $(zfs list -r send -o name -H)
do 
    sudo zfs mount $i
    echo $i mounted
done
sudo chown -R hbarta:hbarta /mnt/send
```

```text
while(:)
do
    time -p /home/hbarta/Programming/provoke_ZFS_corruption/stir_pool.sh 2>/dev/null
    echo
    sleep 750
done
```

```text
while(:)
do
    time -p /sbin/syncoid --recursive --no-privilege-elevation send recv
    zpool status send
    echo
    sleep 750
done
```

## 2024-12-19 no corruption yet

`syncoid` runs are taking about 170s, stirring the pool about 3s, so they don't seem to be synchronizing. Overall, everything appears to be working as desired and w/out the warnings seen on `io`.

## 2024-12-19 late evening - corruption

Screen capture from `syncoid` loop. Multiple loops with no exceptional results elided. I rebooted the host w/out checking to see if there was anything in `dmesg` or logs to indicate problems external to ZFS. This test will be repeated but with ZFS from backports.

```text
CRITICAL ERROR: Target recv exists but has no snapshots matching with send!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.

Sending incremental send/test@syncoid_iox86_2024-12-19:14:52:14-GMT-06:00 ... syncoid_iox86_2024-12-19:15:07:47-GMT-06:00 (~ 4 KB):
2.74KiB 0:00:00 [34.2KiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_0@syncoid_iox86_2024-12-19:14:52:16-GMT-06:00 ... syncoid_iox86_2024-12-19:15:07:49-GMT-06:00 (~ 878 KB):
 673KiB 0:00:00 [2.62MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_0/l1_0@syncoid_iox86_2024-12-19:14:52:17-GMT-06:00 ... syncoid_iox86_2024-12-19:15:07:50-GMT-06:00 (~ 1.7 MB):
1.30MiB 0:00:00 [4.01MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-19:14:52:20-GMT-06:00 ... syncoid_iox86_2024-12-19:15:07:53-GMT-06:00 (~ 1.1 MB):
 807KiB 0:00:00 [2.34MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-19:14:52:22-GMT-06:00 ... syncoid_iox86_2024-12-19:15:07:55-GMT-06:00 (~ 1.6 MB):
1.17MiB 0:00:00 [3.54MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-19:14:52:24-GMT-06:00 ... syncoid_iox86_2024-12-19:15:07:57-GMT-06:00 (~ 1.2 MB):
 958KiB 0:00:00 [2.79MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-19:14:52:26-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:00-GMT-06:00 (~ 1.4 MB):
1.15MiB 0:00:00 [3.33MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_0/l1_1@syncoid_iox86_2024-12-19:14:52:28-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:02-GMT-06:00 (~ 1.1 MB):
 960KiB 0:00:00 [3.06MiB/s] [===================================================================================>                ] 84%            
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-19:14:52:30-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:04-GMT-06:00 (~ 1.6 MB):
1.18MiB 0:00:00 [3.50MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-19:14:52:33-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:07-GMT-06:00 (~ 1.2 MB):
 932KiB 0:00:00 [2.67MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-19:14:52:35-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:09-GMT-06:00 (~ 1.4 MB):
1.03MiB 0:00:00 [2.99MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-19:14:52:37-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:11-GMT-06:00 (~ 1.1 MB):
 950KiB 0:00:00 [2.75MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_0/l1_2@syncoid_iox86_2024-12-19:14:52:39-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:13-GMT-06:00 (~ 1.5 MB):
1.13MiB 0:00:00 [3.60MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-19:14:52:41-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:16-GMT-06:00 (~ 1.2 MB):
 809KiB 0:00:00 [2.39MiB/s] [==================================================================>                                 ] 67%            
Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-19:14:52:43-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:18-GMT-06:00 (~ 2.0 MB):
1.43MiB 0:00:00 [4.17MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-19:14:52:46-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:20-GMT-06:00 (~ 1.2 MB):
 945KiB 0:00:00 [2.67MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-19:14:52:48-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:23-GMT-06:00 (~ 1.3 MB):
1.05MiB 0:00:00 [2.94MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_0/l1_3@syncoid_iox86_2024-12-19:14:52:50-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:25-GMT-06:00 (~ 1.2 MB):
 949KiB 0:00:00 [2.89MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-19:14:52:52-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:27-GMT-06:00 (~ 1.1 MB):
 947KiB 0:00:00 [2.62MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-19:14:52:54-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:29-GMT-06:00 (~ 1.2 MB):
 822KiB 0:00:00 [2.31MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-19:14:52:57-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:32-GMT-06:00 (~ 1.5 MB):
1.06MiB 0:00:00 [3.22MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-19:14:52:59-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:34-GMT-06:00 (~ 1.0 MB):
 807KiB 0:00:00 [2.36MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_1@syncoid_iox86_2024-12-19:14:53:01-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:36-GMT-06:00 (~ 1.8 MB):
1.32MiB 0:00:00 [4.46MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_1/l1_0@syncoid_iox86_2024-12-19:14:53:02-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:38-GMT-06:00 (~ 1.1 MB):
 783KiB 0:00:00 [2.44MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-19:14:53:05-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:40-GMT-06:00 (~ 1.2 MB):
 950KiB 0:00:00 [2.66MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-19:14:53:07-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:42-GMT-06:00 (~ 1.6 MB):
1.30MiB 0:00:00 [3.67MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-19:14:53:10-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:45-GMT-06:00 (~ 574 KB):
 402KiB 0:00:00 [1.14MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-19:14:53:12-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:47-GMT-06:00 (~ 634 KB):
 409KiB 0:00:00 [1.18MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_1/l1_1@syncoid_iox86_2024-12-19:14:53:14-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:49-GMT-06:00 (~ 630 KB):
 529KiB 0:00:00 [1.66MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-19:14:53:16-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:51-GMT-06:00 (~ 514 KB):
 408KiB 0:00:00 [1.18MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-19:14:53:18-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:54-GMT-06:00 (~ 554 KB):
 511KiB 0:00:00 [1.48MiB/s] [===========================================================================================>        ] 92%            
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-19:14:53:21-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:56-GMT-06:00 (~ 810 KB):
 677KiB 0:00:00 [1.91MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-19:14:53:23-GMT-06:00 ... syncoid_iox86_2024-12-19:15:08:58-GMT-06:00 (~ 514 KB):
 400KiB 0:00:00 [1.14MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_1/l1_2@syncoid_iox86_2024-12-19:14:53:25-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:01-GMT-06:00 (~ 766 KB):
 538KiB 0:00:00 [1.72MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:14:53:27-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:03-GMT-06:00 (~ 899 KB):
 661KiB 0:00:00 [1.89MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-19:14:53:29-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:05-GMT-06:00 (~ 766 KB):
 538KiB 0:00:00 [1.56MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-19:14:53:31-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:07-GMT-06:00 (~ 1.2 MB):
 806KiB 0:00:00 [2.32MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-19:14:53:34-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:10-GMT-06:00 (~ 766 KB):
 534KiB 0:00:00 [1.51MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_1/l1_3@syncoid_iox86_2024-12-19:14:53:36-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:12-GMT-06:00 (~ 1.1 MB):
 909KiB 0:00:00 [2.74MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-19:14:53:38-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:14-GMT-06:00 (~ 794 KB):
 672KiB 0:00:00 [1.93MiB/s] [===================================================================================>                ] 84%            
Sending incremental send/test/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-19:14:53:40-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:17-GMT-06:00 (~ 514 KB):
 406KiB 0:00:00 [1.17MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-19:14:53:42-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:19-GMT-06:00 (~ 722 KB):
 546KiB 0:00:00 [1.55MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-19:14:53:45-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:21-GMT-06:00 (~ 590 KB):
 412KiB 0:00:00 [1.21MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_2@syncoid_iox86_2024-12-19:14:53:46-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:23-GMT-06:00 (~ 975 KB):
 667KiB 0:00:00 [2.27MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_2/l1_0@syncoid_iox86_2024-12-19:14:53:48-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:25-GMT-06:00 (~ 931 KB):
 681KiB 0:00:00 [2.14MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-19:14:53:51-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:28-GMT-06:00 (~ 574 KB):
 408KiB 0:00:00 [1.23MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-19:14:53:53-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:30-GMT-06:00 (~ 766 KB):
 539KiB 0:00:00 [1.58MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-19:14:53:55-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:32-GMT-06:00 (~ 646 KB):
 521KiB 0:00:00 [1.50MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-19:14:53:57-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:35-GMT-06:00 (~ 646 KB):
 538KiB 0:00:00 [1.57MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/l0_2/l1_1@syncoid_iox86_2024-12-19:14:53:59-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:37-GMT-06:00 (~ 1.2 MB):
 926KiB 0:00:00 [2.74MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-19:14:54:01-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:39-GMT-06:00 (~ 662 KB):
 544KiB 0:00:00 [1.51MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-19:14:54:04-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:41-GMT-06:00 (~ 442 KB):
 280KiB 0:00:00 [ 850KiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-19:14:54:06-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:44-GMT-06:00 (~ 662 KB):
 542KiB 0:00:00 [1.52MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-19:14:54:08-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:46-GMT-06:00 (~ 1.5 MB):
1.04MiB 0:00:00 [3.01MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_2/l1_2@syncoid_iox86_2024-12-19:14:54:10-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:48-GMT-06:00 (~ 1.2 MB):
 936KiB 0:00:00 [2.78MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_2/l1_2/l2_0@syncoid_iox86_2024-12-19:14:54:12-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:51-GMT-06:00 (~ 426 KB):
 272KiB 0:00:00 [ 811KiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_2/l1_2/l2_1@syncoid_iox86_2024-12-19:14:54:15-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:53-GMT-06:00 (~ 822 KB):
 644KiB 0:00:00 [1.85MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_2/l1_2/l2_2@syncoid_iox86_2024-12-19:14:54:17-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:55-GMT-06:00 (~ 959 KB):
 662KiB 0:00:00 [1.91MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_2/l1_2/l2_3@syncoid_iox86_2024-12-19:14:54:19-GMT-06:00 ... syncoid_iox86_2024-12-19:15:09:58-GMT-06:00 (~ 662 KB):
 541KiB 0:00:00 [1.59MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_2/l1_3@syncoid_iox86_2024-12-19:14:54:21-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:00-GMT-06:00 (~ 650 KB):
 413KiB 0:00:00 [1.34MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_2/l1_3/l2_0@syncoid_iox86_2024-12-19:14:54:23-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:02-GMT-06:00 (~ 530 KB):
 416KiB 0:00:00 [1.19MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-19:14:54:25-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:04-GMT-06:00 (~ 1015 KB):
 769KiB 0:00:00 [2.12MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_2/l1_3/l2_2@syncoid_iox86_2024-12-19:14:54:28-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:07-GMT-06:00 (~ 438 KB):
 397KiB 0:00:00 [1.13MiB/s] [=========================================================================================>          ] 90%            
Sending incremental send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-19:14:54:30-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:09-GMT-06:00 (~ 766 KB):
 536KiB 0:00:00 [1.54MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_3@syncoid_iox86_2024-12-19:14:54:32-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:11-GMT-06:00 (~ 706 KB):
 542KiB 0:00:00 [1.84MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_3/l1_0@syncoid_iox86_2024-12-19:14:54:33-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:13-GMT-06:00 (~ 630 KB):
 515KiB 0:00:00 [1.62MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_3/l1_0/l2_0@syncoid_iox86_2024-12-19:14:54:36-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:15-GMT-06:00 (~ 482 KB):
 379KiB 0:00:00 [1.08MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_3/l1_0/l2_1@syncoid_iox86_2024-12-19:14:54:38-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:18-GMT-06:00 (~ 1.1 MB):
 806KiB 0:00:00 [2.25MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_3/l1_0/l2_2@syncoid_iox86_2024-12-19:14:54:40-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:20-GMT-06:00 (~ 782 KB):
 540KiB 0:00:00 [1.57MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_3/l1_0/l2_3@syncoid_iox86_2024-12-19:14:54:42-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:22-GMT-06:00 (~ 762 KB):
 642KiB 0:00:00 [1.86MiB/s] [===================================================================================>                ] 84%            
Sending incremental send/test/l0_3/l1_1@syncoid_iox86_2024-12-19:14:54:44-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:24-GMT-06:00 (~ 866 KB):
 640KiB 0:00:00 [2.04MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_3/l1_1/l2_0@syncoid_iox86_2024-12-19:14:54:47-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:27-GMT-06:00 (~ 854 KB):
 678KiB 0:00:00 [1.85MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_3/l1_1/l2_1@syncoid_iox86_2024-12-19:14:54:49-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:29-GMT-06:00 (~ 630 KB):
 513KiB 0:00:00 [1.44MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_3/l1_1/l2_2@syncoid_iox86_2024-12-19:14:54:51-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:31-GMT-06:00 (~ 558 KB):
 399KiB 0:00:00 [1.12MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_3/l1_1/l2_3@syncoid_iox86_2024-12-19:14:54:53-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:34-GMT-06:00 (~ 646 KB):
 537KiB 0:00:00 [1.53MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/l0_3/l1_2@syncoid_iox86_2024-12-19:14:54:55-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:36-GMT-06:00 (~ 766 KB):
 534KiB 0:00:00 [1.74MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_3/l1_2/l2_0@syncoid_iox86_2024-12-19:14:54:57-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:38-GMT-06:00 (~ 382 KB):
 278KiB 0:00:00 [ 817KiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_3/l1_2/l2_1@syncoid_iox86_2024-12-19:14:55:00-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:40-GMT-06:00 (~ 931 KB):
 678KiB 0:00:00 [1.99MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_3/l1_2/l2_2@syncoid_iox86_2024-12-19:14:55:02-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:43-GMT-06:00 (~ 514 KB):
 401KiB 0:00:00 [1.18MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_3/l1_2/l2_3@syncoid_iox86_2024-12-19:14:55:04-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:45-GMT-06:00 (~ 542 KB):
 380KiB 0:00:00 [1.15MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_3/l1_3@syncoid_iox86_2024-12-19:14:55:06-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:47-GMT-06:00 (~ 782 KB):
 547KiB 0:00:00 [1.76MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_3/l1_3/l2_0@syncoid_iox86_2024-12-19:14:55:08-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:49-GMT-06:00 (~ 586 KB):
 536KiB 0:00:00 [1.50MiB/s] [==========================================================================================>         ] 91%            
Sending incremental send/test/l0_3/l1_3/l2_1@syncoid_iox86_2024-12-19:14:55:10-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:52-GMT-06:00 (~ 634 KB):
 409KiB 0:00:00 [1.20MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_3/l1_3/l2_2@syncoid_iox86_2024-12-19:14:55:13-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:54-GMT-06:00 (~ 514 KB):
 401KiB 0:00:00 [1.15MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-19:14:55:15-GMT-06:00 ... syncoid_iox86_2024-12-19:15:10:56-GMT-06:00 (~ 690 KB):
 527KiB 0:00:00 [1.53MiB/s] [===========================================================================>                        ] 76%            
real 191.59
user 17.66
sys 148.50
  pool: send
 state: ONLINE
config:

        NAME                            STATE     READ WRITE CKSUM
        send                            ONLINE       0     0     0
          wwn-0x5002538d40dca5d9-part7  ONLINE       0     0     0

errors: No known data errors


CRITICAL ERROR: Target recv exists but has no snapshots matching with send!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.

Sending incremental send/test@syncoid_iox86_2024-12-19:15:07:47-GMT-06:00 ... syncoid_iox86_2024-12-19:15:23:29-GMT-06:00 (~ 4 KB):
2.13KiB 0:00:00 [27.2KiB/s] [====================================================>                                               ] 53%            
Sending incremental send/test/l0_0@syncoid_iox86_2024-12-19:15:07:49-GMT-06:00 ... syncoid_iox86_2024-12-19:15:23:30-GMT-06:00 (~ 1.6 MB):
1.14MiB 0:00:00 [6.19MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_0/l1_0@syncoid_iox86_2024-12-19:15:07:50-GMT-06:00 ... syncoid_iox86_2024-12-19:15:23:32-GMT-06:00 (~ 529 KB):
 414KiB 0:00:00 [1.84MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-19:15:07:53-GMT-06:00 ... syncoid_iox86_2024-12-19:15:23:34-GMT-06:00 (~ 573 KB):
 405KiB 0:00:00 [1.69MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-19:15:07:55-GMT-06:00 ... syncoid_iox86_2024-12-19:15:23:36-GMT-06:00 (~ 381 KB):
 278KiB 0:00:00 [1.21MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-19:15:07:57-GMT-06:00 ... syncoid_iox86_2024-12-19:15:23:39-GMT-06:00 (~ 365 KB):
 267KiB 0:00:00 [1.16MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-19:15:08:00-GMT-06:00 ... syncoid_iox86_2024-12-19:15:23:41-GMT-06:00 (~ 513 KB):
 407KiB 0:00:00 [1.77MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_0/l1_1@syncoid_iox86_2024-12-19:15:08:02-GMT-06:00 ... syncoid_iox86_2024-12-19:15:23:43-GMT-06:00 (~ 766 KB):
warning: cannot send 'send/test/l0_0/l1_1@syncoid_iox86_2024-12-19:15:23:43-GMT-06:00': Input/output error
1.83KiB 0:00:00 [19.8KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11a7fcef30-110-789c636064000310a501c49c50360710a715e5e7a69766a63040812cfbeff43ac69b310a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a857d1e9723d5bead8d4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d0cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b63231d675f70dd13530b3323000db0d00f6802ab3
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1'@'syncoid_iox86_2024-12-19:15:08:02-GMT-06:00' 'send/test/l0_0/l1_1'@'syncoid_iox86_2024-12-19:15:23:43-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 784504 |  zfs receive  -s -F 'recv/test/l0_0/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-19:15:08:04-GMT-06:00 ... syncoid_iox86_2024-12-19:15:23:45-GMT-06:00 (~ 882 KB):
 641KiB 0:00:00 [2.67MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-19:15:08:07-GMT-06:00 ... syncoid_iox86_2024-12-19:15:23:47-GMT-06:00 (~ 782 KB):
 538KiB 0:00:00 [2.29MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-19:15:08:09-GMT-06:00 ... syncoid_iox86_2024-12-19:15:23:50-GMT-06:00 (~ 662 KB):
 539KiB 0:00:00 [2.16MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-19:15:08:11-GMT-06:00 ... syncoid_iox86_2024-12-19:15:23:52-GMT-06:00 (~ 738 KB):
 549KiB 0:00:00 [2.27MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_0/l1_2@syncoid_iox86_2024-12-19:15:08:13-GMT-06:00 ... syncoid_iox86_2024-12-19:15:23:54-GMT-06:00 (~ 557 KB):
 400KiB 0:00:00 [1.88MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-19:15:08:16-GMT-06:00 ... syncoid_iox86_2024-12-19:15:23:56-GMT-06:00 (~ 589 KB):
 412KiB 0:00:00 [1.73MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-19:15:08:18-GMT-06:00 ... syncoid_iox86_2024-12-19:15:23:58-GMT-06:00 (~ 585 KB):
 536KiB 0:00:00 [2.11MiB/s] [==========================================================================================>         ] 91%            
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-19:15:08:20-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:00-GMT-06:00 (~ 421 KB):
 378KiB 0:00:00 [1.55MiB/s] [========================================================================================>           ] 89%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-19:15:08:23-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:03-GMT-06:00 (~ 650 KB):
 415KiB 0:00:00 [1.74MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_0/l1_3@syncoid_iox86_2024-12-19:15:08:25-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:05-GMT-06:00 (~ 798 KB):
 552KiB 0:00:00 [2.44MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-19:15:08:27-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:07-GMT-06:00 (~ 513 KB):
 409KiB 0:00:00 [1.66MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-19:15:08:29-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:09-GMT-06:00 (~ 722 KB):
 532KiB 0:00:00 [2.23MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-19:15:08:32-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:11-GMT-06:00 (~ 585 KB):
 541KiB 0:00:00 [2.14MiB/s] [===========================================================================================>        ] 92%            
Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-19:15:08:34-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:14-GMT-06:00 (~ 766 KB):
 531KiB 0:00:00 [2.25MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_1@syncoid_iox86_2024-12-19:15:08:36-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:15-GMT-06:00 (~ 321 KB):
 275KiB 0:00:00 [1.35MiB/s] [====================================================================================>               ] 85%            
Sending incremental send/test/l0_1/l1_0@syncoid_iox86_2024-12-19:15:08:38-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:17-GMT-06:00 (~ 1.2 MB):
 930KiB 0:00:00 [3.95MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-19:15:08:40-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:20-GMT-06:00 (~ 573 KB):
 409KiB 0:00:00 [1.73MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-19:15:08:42-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:22-GMT-06:00 (~ 589 KB):
 415KiB 0:00:00 [1.78MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-19:15:08:45-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:24-GMT-06:00 (~ 646 KB):
 535KiB 0:00:00 [2.19MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-19:15:08:47-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:26-GMT-06:00 (~ 914 KB):
warning: cannot send 'send/test/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-19:15:24:26-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [17.2KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_1/l1_1@syncoid_iox86_2024-12-19:15:08:49-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:28-GMT-06:00 (~ 678 KB):
 547KiB 0:00:00 [2.38MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-19:15:08:51-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:30-GMT-06:00 (~ 529 KB):
 413KiB 0:00:00 [1.71MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-19:15:08:54-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:33-GMT-06:00 (~ 497 KB):
 388KiB 0:00:00 [1.62MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-19:15:08:56-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:35-GMT-06:00 (~ 1.1 MB):
 797KiB 0:00:00 [3.38MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-19:15:08:58-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:37-GMT-06:00 (~ 646 KB):
 536KiB 0:00:00 [2.19MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_1/l1_2@syncoid_iox86_2024-12-19:15:09:01-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:39-GMT-06:00 (~ 633 KB):
 409KiB 0:00:00 [1.89MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:09:03-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:41-GMT-06:00 (~ 529 KB):
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:24:41-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [17.3KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-19:15:09:05-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:43-GMT-06:00 (~ 573 KB):
 399KiB 0:00:00 [1.71MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-19:15:09:07-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:46-GMT-06:00 (~ 441 KB):
warning: cannot send 'send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-19:15:24:46-GMT-06:00': Input/output error
1.83KiB 0:00:00 [21.3KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-10c0c26d5d-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c119ee6bd985a9cf1415806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415c2fbb6ac5820c35a9e8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa89f63186fa49f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a6564626562a6ebee1ba26b6066656000730300a3612bd3
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_2'@'syncoid_iox86_2024-12-19:15:09:07-GMT-06:00' 'send/test/l0_1/l1_2/l2_2'@'syncoid_iox86_2024-12-19:15:24:46-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 452360 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-19:15:09:10-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:48-GMT-06:00 (~ 678 KB):
 544KiB 0:00:00 [2.21MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_1/l1_3@syncoid_iox86_2024-12-19:15:09:12-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:50-GMT-06:00 (~ 986 KB):
 803KiB 0:00:00 [3.62MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-19:15:09:14-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:52-GMT-06:00 (~ 914 KB):
warning: cannot send 'send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-19:15:24:52-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [16.0KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-19:15:09:17-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:54-GMT-06:00 (~ 662 KB):
 546KiB 0:00:00 [2.16MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-19:15:09:19-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:57-GMT-06:00 (~ 798 KB):
 549KiB 0:00:00 [2.34MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-19:15:09:21-GMT-06:00 ... syncoid_iox86_2024-12-19:15:24:59-GMT-06:00 (~ 722 KB):
 540KiB 0:00:00 [2.18MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_2@syncoid_iox86_2024-12-19:15:09:23-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:01-GMT-06:00 (~ 722 KB):
 541KiB 0:00:00 [2.64MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_2/l1_0@syncoid_iox86_2024-12-19:15:09:25-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:02-GMT-06:00 (~ 173 KB):
warning: cannot send 'send/test/l0_2/l1_0@syncoid_iox86_2024-12-19:15:25:02-GMT-06:00': Input/output error
1.83KiB 0:00:00 [21.8KiB/s] [>                                                                                                   ]  1%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-13c9ed8a18-110-789c636064000310a501c49c50360710a715e5e7a69766a6304041f15cde74936d7c350a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a904dbc359336a67d8c4092e704cbe725e6a602dd979a97a20f34aa443fc720de483fc730dec0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cac048d7dd3744d7c0cccac0006c3700a3a12a2c
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_0'@'syncoid_iox86_2024-12-19:15:09:25-GMT-06:00' 'send/test/l0_2/l1_0'@'syncoid_iox86_2024-12-19:15:25:02-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 177560 |  zfs receive  -s -F 'recv/test/l0_2/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-19:15:09:28-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:05-GMT-06:00 (~ 589 KB):
 416KiB 0:00:00 [1.76MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-19:15:09:30-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:07-GMT-06:00 (~ 437 KB):
 377KiB 0:00:00 [1.51MiB/s] [=====================================================================================>              ] 86%            
Sending incremental send/test/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-19:15:09:32-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:09-GMT-06:00 (~ 585 KB):
warning: cannot send 'send/test/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-19:15:25:09-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [16.9KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-19:15:09:35-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:11-GMT-06:00 (~ 766 KB):
 537KiB 0:00:00 [2.21MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_2/l1_1@syncoid_iox86_2024-12-19:15:09:37-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:13-GMT-06:00 (~ 990 KB):
 680KiB 0:00:00 [3.07MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-19:15:09:39-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:15-GMT-06:00 (~ 782 KB):
 544KiB 0:00:00 [2.26MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-19:15:09:41-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:18-GMT-06:00 (~ 722 KB):
warning: cannot send 'send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-19:15:25:18-GMT-06:00': Input/output error
1.83KiB 0:00:00 [21.4KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-ff823389f-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1222bc149011dceef15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4151f5e86aa54575f399a8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa89f63146fe8505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6568a1ebee1ba26b6066656000730300d8b82ce2
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_1/l2_1'@'syncoid_iox86_2024-12-19:15:09:41-GMT-06:00' 'send/test/l0_2/l1_1/l2_1'@'syncoid_iox86_2024-12-19:15:25:18-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 739448 |  zfs receive  -s -F 'recv/test/l0_2/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-19:15:09:44-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:20-GMT-06:00 (~ 854 KB):
 670KiB 0:00:00 [2.66MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-19:15:09:46-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:22-GMT-06:00 (~ 662 KB):
 542KiB 0:00:00 [2.22MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_2/l1_2@syncoid_iox86_2024-12-19:15:09:48-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:24-GMT-06:00 (~ 441 KB):
 282KiB 0:00:00 [1.33MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_2/l1_2/l2_0@syncoid_iox86_2024-12-19:15:09:51-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:26-GMT-06:00 (~ 706 KB):
 531KiB 0:00:00 [2.24MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_2/l1_2/l2_1@syncoid_iox86_2024-12-19:15:09:53-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:28-GMT-06:00 (~ 529 KB):
 414KiB 0:00:00 [1.73MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_2/l1_2/l2_2@syncoid_iox86_2024-12-19:15:09:55-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:31-GMT-06:00 (~ 573 KB):
 410KiB 0:00:00 [1.70MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_2/l1_2/l2_3@syncoid_iox86_2024-12-19:15:09:58-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:33-GMT-06:00 (~ 529 KB):
 412KiB 0:00:00 [1.72MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_2/l1_3@syncoid_iox86_2024-12-19:15:10:00-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:35-GMT-06:00 (~ 986 KB):
 800KiB 0:00:00 [3.34MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_2/l1_3/l2_0@syncoid_iox86_2024-12-19:15:10:02-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:37-GMT-06:00 (~ 806 KB):
warning: cannot send 'send/test/l0_2/l1_3/l2_0@syncoid_iox86_2024-12-19:15:25:37-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [18.4KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-19:15:10:04-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:39-GMT-06:00 (~ 557 KB):
warning: cannot send 'send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-19:15:25:39-GMT-06:00': Input/output error
1.83KiB 0:00:00 [20.8KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-14c7859310-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1459fa97f6772eabe5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057a42cf1b39e5e29783601499e132c9f97989bcac0509c9a97a20f34aa443fc720de483fc730de583fc728ded0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cad852d7dd3744d7c0cccac000e6060018eb2c68
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_1'@'syncoid_iox86_2024-12-19:15:10:04-GMT-06:00' 'send/test/l0_2/l1_3/l2_1'@'syncoid_iox86_2024-12-19:15:25:39-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 571328 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_3/l2_2@syncoid_iox86_2024-12-19:15:10:07-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:41-GMT-06:00 (~ 441 KB):
 278KiB 0:00:00 [1.18MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-19:15:10:09-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:44-GMT-06:00 (~ 629 KB):
warning: cannot send 'send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-19:15:25:44-GMT-06:00': Input/output error
1.83KiB 0:00:00 [19.6KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-14bb428d41-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c193fcf2ca3fbbf6592900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b6a5e1844ad2cbeb03f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de483fc730de583fc728ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cac444d7dd3744d7c0cccac000e6060004302e05
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_3'@'syncoid_iox86_2024-12-19:15:10:09-GMT-06:00' 'send/test/l0_2/l1_3/l2_3'@'syncoid_iox86_2024-12-19:15:25:44-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 645056 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3@syncoid_iox86_2024-12-19:15:10:11-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:45-GMT-06:00 (~ 529 KB):
warning: cannot send 'send/test/l0_3@syncoid_iox86_2024-12-19:15:25:45-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [17.3KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_3/l1_0@syncoid_iox86_2024-12-19:15:10:13-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:47-GMT-06:00 (~ 1.5 MB):
warning: cannot send 'send/test/l0_3/l1_0@syncoid_iox86_2024-12-19:15:25:47-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [18.5KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_3/l1_0/l2_0@syncoid_iox86_2024-12-19:15:10:15-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:49-GMT-06:00 (~ 529 KB):
 411KiB 0:00:00 [1.70MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_3/l1_0/l2_1@syncoid_iox86_2024-12-19:15:10:18-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:51-GMT-06:00 (~ 722 KB):
 543KiB 0:00:00 [2.25MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_3/l1_0/l2_2@syncoid_iox86_2024-12-19:15:10:20-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:54-GMT-06:00 (~ 722 KB):
 540KiB 0:00:00 [2.22MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_3/l1_0/l2_3@syncoid_iox86_2024-12-19:15:10:22-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:56-GMT-06:00 (~ 541 KB):
 374KiB 0:00:00 [1.62MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_3/l1_1@syncoid_iox86_2024-12-19:15:10:24-GMT-06:00 ... syncoid_iox86_2024-12-19:15:25:58-GMT-06:00 (~ 818 KB):
 750KiB 0:00:00 [3.21MiB/s] [==========================================================================================>         ] 91%            
Sending incremental send/test/l0_3/l1_1/l2_0@syncoid_iox86_2024-12-19:15:10:27-GMT-06:00 ... syncoid_iox86_2024-12-19:15:26:00-GMT-06:00 (~ 557 KB):
 400KiB 0:00:00 [1.75MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_3/l1_1/l2_1@syncoid_iox86_2024-12-19:15:10:29-GMT-06:00 ... syncoid_iox86_2024-12-19:15:26:02-GMT-06:00 (~ 690 KB):
 524KiB 0:00:00 [2.22MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_3/l1_1/l2_2@syncoid_iox86_2024-12-19:15:10:31-GMT-06:00 ... syncoid_iox86_2024-12-19:15:26:05-GMT-06:00 (~ 854 KB):
 672KiB 0:00:00 [2.77MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_3/l1_1/l2_3@syncoid_iox86_2024-12-19:15:10:34-GMT-06:00 ... syncoid_iox86_2024-12-19:15:26:07-GMT-06:00 (~ 569 KB):
 514KiB 0:00:00 [2.11MiB/s] [=========================================================================================>          ] 90%            
Sending incremental send/test/l0_3/l1_2@syncoid_iox86_2024-12-19:15:10:36-GMT-06:00 ... syncoid_iox86_2024-12-19:15:26:09-GMT-06:00 (~ 453 KB):
 405KiB 0:00:00 [1.87MiB/s] [========================================================================================>           ] 89%            
Sending incremental send/test/l0_3/l1_2/l2_0@syncoid_iox86_2024-12-19:15:10:38-GMT-06:00 ... syncoid_iox86_2024-12-19:15:26:11-GMT-06:00 (~ 589 KB):
 414KiB 0:00:00 [1.70MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_3/l1_2/l2_1@syncoid_iox86_2024-12-19:15:10:40-GMT-06:00 ... syncoid_iox86_2024-12-19:15:26:13-GMT-06:00 (~ 513 KB):
 407KiB 0:00:00 [1.70MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_3/l1_2/l2_2@syncoid_iox86_2024-12-19:15:10:43-GMT-06:00 ... syncoid_iox86_2024-12-19:15:26:16-GMT-06:00 (~ 650 KB):
 405KiB 0:00:00 [1.67MiB/s] [=============================================================>                                      ] 62%            
Sending incremental send/test/l0_3/l1_2/l2_3@syncoid_iox86_2024-12-19:15:10:45-GMT-06:00 ... syncoid_iox86_2024-12-19:15:26:18-GMT-06:00 (~ 453 KB):
 407KiB 0:00:00 [1.66MiB/s] [========================================================================================>           ] 89%            
Sending incremental send/test/l0_3/l1_3@syncoid_iox86_2024-12-19:15:10:47-GMT-06:00 ... syncoid_iox86_2024-12-19:15:26:20-GMT-06:00 (~ 1.6 MB):
1.29MiB 0:00:00 [5.63MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_3/l1_3/l2_0@syncoid_iox86_2024-12-19:15:10:49-GMT-06:00 ... syncoid_iox86_2024-12-19:15:26:22-GMT-06:00 (~ 381 KB):
 274KiB 0:00:00 [1.17MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_3/l1_3/l2_1@syncoid_iox86_2024-12-19:15:10:52-GMT-06:00 ... syncoid_iox86_2024-12-19:15:26:24-GMT-06:00 (~ 381 KB):
warning: cannot send 'send/test/l0_3/l1_3/l2_1@syncoid_iox86_2024-12-19:15:26:24-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [16.2KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_3/l1_3/l2_2@syncoid_iox86_2024-12-19:15:10:54-GMT-06:00 ... syncoid_iox86_2024-12-19:15:26:27-GMT-06:00 (~ 557 KB):
 399KiB 0:00:00 [1.65MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-19:15:10:56-GMT-06:00 ... syncoid_iox86_2024-12-19:15:26:29-GMT-06:00 (~ 589 KB):
warning: cannot send 'send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-19:15:26:29-GMT-06:00': Input/output error
1.83KiB 0:00:00 [21.9KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-118b3c37f5-118-789c636064000310a501c49c50360710a715e5e7a69766a630408145cff65f8b5a247914806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415f2219fbfbfbf12cc9c8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fac9f6308228ce28d1d8a2bf392f33353e233f32b2ccce28d0c8c4c740d8d740d2dad0c4dad8cccac8c2c75dd7d43740dccac0c0c606e0000e4702cb6
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3/l2_3'@'syncoid_iox86_2024-12-19:15:10:56-GMT-06:00' 'send/test/l0_3/l1_3/l2_3'@'syncoid_iox86_2024-12-19:15:26:29-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 604096 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
real 182.09
user 17.26
sys 145.93
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
config:

        NAME                            STATE     READ WRITE CKSUM
        send                            ONLINE       0     0     0
          wwn-0x5002538d40dca5d9-part7  ONLINE       0     0     0
errors: List of errors unavailable: permission denied

errors: 15 data errors, use '-v' for a list


CRITICAL ERROR: Target recv exists but has no snapshots matching with send!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.

Sending incremental send/test@syncoid_iox86_2024-12-19:15:23:29-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:01-GMT-06:00 (~ 4 KB):
2.13KiB 0:00:00 [27.7KiB/s] [====================================================>                                               ] 53%            
Sending incremental send/test/l0_0@syncoid_iox86_2024-12-19:15:23:30-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:02-GMT-06:00 (~ 305 KB):
 269KiB 0:00:00 [1.51MiB/s] [=======================================================================================>            ] 88%            
Sending incremental send/test/l0_0/l1_0@syncoid_iox86_2024-12-19:15:23:32-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:04-GMT-06:00 (~ 722 KB):
 543KiB 0:00:00 [2.47MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-19:15:23:34-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:06-GMT-06:00 (~ 782 KB):
 539KiB 0:00:00 [2.28MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-19:15:23:36-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:09-GMT-06:00 (~ 722 KB):
 541KiB 0:00:00 [2.25MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-19:15:23:39-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:11-GMT-06:00 (~ 1.2 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-19:15:39:11-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [16.9KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-19:15:23:41-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:13-GMT-06:00 (~ 794 KB):
 670KiB 0:00:00 [2.62MiB/s] [===================================================================================>                ] 84%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1 to recv/test/l0_0/l1_1 (~ 765 KB remaining):
internal error: warning: cannot send 'send/test/l0_0/l1_1@syncoid_iox86_2024-12-19:15:23:43-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-11a7fcef30-110-789c636064000310a501c49c50360710a715e5e7a69766a63040812cfbeff43ac69b310a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a857d1e9723d5bead8d4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d0cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b63231d675f70dd13530b3323000db0d00f6802ab3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 783880 |  zfs receive  -s -F 'recv/test/l0_0/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-19:15:23:45-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:16-GMT-06:00 (~ 674 KB):
 500KiB 0:00:00 [2.15MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-19:15:23:47-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:18-GMT-06:00 (~ 794 KB):
 670KiB 0:00:00 [2.66MiB/s] [===================================================================================>                ] 84%            
Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-19:15:23:50-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:20-GMT-06:00 (~ 842 KB):
warning: cannot send 'send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-19:15:39:20-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [17.0KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-19:15:23:52-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:22-GMT-06:00 (~ 914 KB):
warning: cannot send 'send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-19:15:39:22-GMT-06:00': Input/output error
1.83KiB 0:00:00 [20.6KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1136c0efbd-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041d3b6c3921ba7f09d5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057d8f4bf9952bfe4dbe10424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837803fd1cc37843fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b634b2b23235d77df105d03332b0303981b0090282dd3
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_3'@'syncoid_iox86_2024-12-19:15:23:52-GMT-06:00' 'send/test/l0_0/l1_1/l2_3'@'syncoid_iox86_2024-12-19:15:39:22-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 936424 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_2@syncoid_iox86_2024-12-19:15:23:54-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:24-GMT-06:00 (~ 581 KB):
 482KiB 0:00:00 [2.12MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-19:15:23:56-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:26-GMT-06:00 (~ 782 KB):
warning: cannot send 'send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-19:15:39:26-GMT-06:00': Input/output error
1.83KiB 0:00:00 [21.4KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11d384ec20-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c142be63273a9bb6c62900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bd4ec24bf987ee23f998024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fa49f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656c696564a6ebee1ba26b6066656000730300ff272c45
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_0'@'syncoid_iox86_2024-12-19:15:23:56-GMT-06:00' 'send/test/l0_0/l1_2/l2_0'@'syncoid_iox86_2024-12-19:15:39:26-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 801072 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-19:15:23:58-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:28-GMT-06:00 (~ 678 KB):
warning: cannot send 'send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-19:15:39:28-GMT-06:00': Input/output error
1.83KiB 0:00:00 [20.4KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-127e44ff0a-118-789c636064000310a501c49c50360710a715e5e7a69766a630408154cbf596c2961b1a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28aa97713ed98eb959f2420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61be9e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1959e8bafb86e81a98591918c0dc0000b0b52c05
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_1'@'syncoid_iox86_2024-12-19:15:23:58-GMT-06:00' 'send/test/l0_0/l1_2/l2_1'@'syncoid_iox86_2024-12-19:15:39:28-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 694392 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-19:15:24:00-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:31-GMT-06:00 (~ 782 KB):
 543KiB 0:00:00 [2.24MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-19:15:24:03-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:33-GMT-06:00 (~ 750 KB):
 515KiB 0:00:00 [2.16MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_0/l1_3@syncoid_iox86_2024-12-19:15:24:05-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:35-GMT-06:00 (~ 898 KB):
 661KiB 0:00:00 [2.92MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-19:15:24:07-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:37-GMT-06:00 (~ 1002 KB):
 805KiB 0:00:00 [3.22MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-19:15:24:09-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:39-GMT-06:00 (~ 766 KB):
 535KiB 0:00:00 [2.29MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-19:15:24:11-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:41-GMT-06:00 (~ 722 KB):
 544KiB 0:00:00 [2.19MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-19:15:24:14-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:44-GMT-06:00 (~ 782 KB):
warning: cannot send 'send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-19:15:39:44-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [17.0KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_1@syncoid_iox86_2024-12-19:15:24:15-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:45-GMT-06:00 (~ 854 KB):
 675KiB 0:00:00 [3.13MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_1/l1_0@syncoid_iox86_2024-12-19:15:24:17-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:47-GMT-06:00 (~ 854 KB):
warning: cannot send 'send/test/l0_1/l1_0@syncoid_iox86_2024-12-19:15:39:47-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [18.2KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-19:15:24:20-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:49-GMT-06:00 (~ 782 KB):
 542KiB 0:00:00 [2.23MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-19:15:24:22-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:52-GMT-06:00 (~ 738 KB):
 546KiB 0:00:00 [2.23MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-19:15:24:24-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:54-GMT-06:00 (~ 1.0 MB):
 804KiB 0:00:00 [3.14MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_1/l1_0/l2_3@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:15:39:56-GMT-06:00 (~ 1.8 MB):
warning: cannot send 'send/test/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-19:15:24:26-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_0/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 387KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_3'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_1/l1_0/l2_3'@'syncoid_iox86_2024-12-19:15:39:56-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1839272 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1@syncoid_iox86_2024-12-19:15:24:28-GMT-06:00 ... syncoid_iox86_2024-12-19:15:39:58-GMT-06:00 (~ 1.0 MB):
 803KiB 0:00:00 [3.49MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-19:15:24:30-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:00-GMT-06:00 (~ 573 KB):
 408KiB 0:00:00 [1.70MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-19:15:24:33-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:03-GMT-06:00 (~ 762 KB):
 643KiB 0:00:00 [2.55MiB/s] [===================================================================================>                ] 84%            
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-19:15:24:35-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:05-GMT-06:00 (~ 513 KB):
 404KiB 0:00:00 [1.69MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-19:15:24:37-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:07-GMT-06:00 (~ 662 KB):
 540KiB 0:00:00 [2.15MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_1/l1_2@syncoid_iox86_2024-12-19:15:24:39-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:09-GMT-06:00 (~ 381 KB):
 284KiB 0:00:00 [1.28MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_1/l1_2/l2_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:15:40:11-GMT-06:00 (~ 1.1 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:24:41-GMT-06:00': Invalid argument
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:40:11-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [15.7KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_2/l2_0 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_1/l1_2/l2_0'@'syncoid_iox86_2024-12-19:15:40:11-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1203656 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-19:15:24:43-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:13-GMT-06:00 (~ 914 KB):
 673KiB 0:00:00 [2.83MiB/s] [========================================================================>                           ] 73%            
Resuming interrupted zfs send/receive from send/test/l0_1/l1_2/l2_2 to recv/test/l0_1/l1_2/l2_2 (~ 441 KB remaining):
internal error: warning: cannot send 'send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-19:15:24:46-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-10c0c26d5d-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c119ee6bd985a9cf1415806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415c2fbb6ac5820c35a9e8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa89f63186fa49f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a6564626562a6ebee1ba26b6066656000730300a3612bd3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 451736 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-19:15:24:48-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:16-GMT-06:00 (~ 1.0 MB):
 799KiB 0:00:00 [3.22MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_1/l1_3@syncoid_iox86_2024-12-19:15:24:50-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:18-GMT-06:00 (~ 573 KB):
 410KiB 0:00:00 [1.91MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_1/l1_3/l2_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:15:40:20-GMT-06:00 (~ 1.4 MB):
warning: cannot send 'send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-19:15:24:52-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_3/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 382KiB/s] [===>                                                                                                ]  4%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_3/l2_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_1/l1_3/l2_0'@'syncoid_iox86_2024-12-19:15:40:20-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1478456 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-19:15:24:54-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:22-GMT-06:00 (~ 425 KB):
 273KiB 0:00:00 [1.16MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-19:15:24:57-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:25-GMT-06:00 (~ 898 KB):
 662KiB 0:00:00 [2.69MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-19:15:24:59-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:27-GMT-06:00 (~ 573 KB):
 406KiB 0:00:00 [1.70MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_2@syncoid_iox86_2024-12-19:15:25:01-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:28-GMT-06:00 (~ 513 KB):
 404KiB 0:00:00 [1.93MiB/s] [=============================================================================>                      ] 78%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_0 to recv/test/l0_2/l1_0 (~ 172 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_0@syncoid_iox86_2024-12-19:15:25:02-GMT-06:00': Invalid argument
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            Aborted

cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-13c9ed8a18-110-789c636064000310a501c49c50360710a715e5e7a69766a6304041f15cde74936d7c350a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a904dbc359336a67d8c4092e704cbe725e6a602dd979a97a20f34aa443fc720de483fc730dec0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cac048d7dd3744d7c0cccac0006c3700a3a12a2c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 176936 |  zfs receive  -s -F 'recv/test/l0_2/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-19:15:25:05-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:31-GMT-06:00 (~ 529 KB):
 416KiB 0:00:00 [1.69MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-19:15:25:07-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:33-GMT-06:00 (~ 497 KB):
 400KiB 0:00:00 [1.67MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_2/l1_0/l2_2@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:15:40:36-GMT-06:00 (~ 1.0 MB):
warning: cannot send 'send/test/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-19:15:25:09-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_0/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 358KiB/s] [=====>                                                                                              ]  6%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_0/l2_2'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_2/l1_0/l2_2'@'syncoid_iox86_2024-12-19:15:40:36-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1080408 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-19:15:25:11-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:38-GMT-06:00 (~ 914 KB):
 662KiB 0:00:00 [2.69MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_2/l1_1@syncoid_iox86_2024-12-19:15:25:13-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:40-GMT-06:00 (~ 810 KB):
 677KiB 0:00:00 [2.84MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-19:15:25:15-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:42-GMT-06:00 (~ 930 KB):
 677KiB 0:00:00 [2.81MiB/s] [=======================================================================>                            ] 72%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_1/l2_1 to recv/test/l0_2/l1_1/l2_1 (~ 721 KB remaining):
warning: cannot send 'send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-19:15:25:18-GMT-06:00': Input/output error
 408 B 0:00:00 [4.34KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-ff823389f-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1222bc149011dceef15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4151f5e86aa54575f399a8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa89f63146fe8505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6568a1ebee1ba26b6066656000730300d8b82ce2
CRITICAL ERROR:  zfs send  -t 1-ff823389f-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1222bc149011dceef15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4151f5e86aa54575f399a8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa89f63146fe8505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6568a1ebee1ba26b6066656000730300d8b82ce2 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 738824 |  zfs receive  -s -F 'recv/test/l0_2/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-19:15:25:20-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:45-GMT-06:00 (~ 970 KB):
 792KiB 0:00:00 [3.12MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-19:15:25:22-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:47-GMT-06:00 (~ 573 KB):
 404KiB 0:00:00 [1.69MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_2/l1_2@syncoid_iox86_2024-12-19:15:25:24-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:49-GMT-06:00 (~ 722 KB):
 540KiB 0:00:00 [2.44MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_2/l1_2/l2_0@syncoid_iox86_2024-12-19:15:25:26-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:51-GMT-06:00 (~ 1.0 MB):
 804KiB 0:00:00 [3.23MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_2/l1_2/l2_1@syncoid_iox86_2024-12-19:15:25:28-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:53-GMT-06:00 (~ 513 KB):
 406KiB 0:00:00 [1.69MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_2/l1_2/l2_2@syncoid_iox86_2024-12-19:15:25:31-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:56-GMT-06:00 (~ 633 KB):
 404KiB 0:00:00 [1.69MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_2/l1_2/l2_3@syncoid_iox86_2024-12-19:15:25:33-GMT-06:00 ... syncoid_iox86_2024-12-19:15:40:58-GMT-06:00 (~ 529 KB):
 411KiB 0:00:00 [1.72MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_2/l1_3@syncoid_iox86_2024-12-19:15:25:35-GMT-06:00 ... syncoid_iox86_2024-12-19:15:41:00-GMT-06:00 (~ 233 KB):
 139KiB 0:00:00 [ 672KiB/s] [==========================================================>                                         ] 59%            
Sending incremental send/test/l0_2/l1_3/l2_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:15:41:02-GMT-06:00 (~ 1.3 MB):
warning: cannot send 'send/test/l0_2/l1_3/l2_0@syncoid_iox86_2024-12-19:15:25:37-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_3/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 384KiB/s] [===>                                                                                                ]  4%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_2/l1_3/l2_0'@'syncoid_iox86_2024-12-19:15:41:02-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1351296 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_1 to recv/test/l0_2/l1_3/l2_1 (~ 557 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-19:15:25:39-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-14c7859310-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1459fa97f6772eabe5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057a42cf1b39e5e29783601499e132c9f97989bcac0509c9a97a20f34aa443fc720de483fc730de583fc728ded0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cad852d7dd3744d7c0cccac000e6060018eb2c68 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 570704 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_3/l2_2@syncoid_iox86_2024-12-19:15:25:41-GMT-06:00 ... syncoid_iox86_2024-12-19:15:41:05-GMT-06:00 (~ 722 KB):
 547KiB 0:00:00 [2.25MiB/s] [==========================================================================>                         ] 75%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_3 to recv/test/l0_2/l1_3/l2_3 (~ 629 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-19:15:25:44-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-14bb428d41-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c193fcf2ca3fbbf6592900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b6a5e1844ad2cbeb03f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de483fc730de583fc728ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cac444d7dd3744d7c0cccac000e6060004302e05 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 644432 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:15:41:07-GMT-06:00 (~ 1.0 MB):
warning: cannot send 'send/test/l0_3@syncoid_iox86_2024-12-19:15:25:45-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3 does not
match incremental source
64.0KiB 0:00:00 [ 424KiB/s] [=====>                                                                                              ]  6%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_3'@'syncoid_iox86_2024-12-19:15:41:07-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1068304 |  zfs receive  -s -F 'recv/test/l0_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:15:41:09-GMT-06:00 (~ 2.2 MB):
warning: cannot send 'send/test/l0_3/l1_0@syncoid_iox86_2024-12-19:15:25:47-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_0 does not
match incremental source
64.0KiB 0:00:00 [ 394KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_3/l1_0'@'syncoid_iox86_2024-12-19:15:41:09-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2327432 |  zfs receive  -s -F 'recv/test/l0_3/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_0/l2_0@syncoid_iox86_2024-12-19:15:25:49-GMT-06:00 ... syncoid_iox86_2024-12-19:15:41:11-GMT-06:00 (~ 1.2 MB):
 931KiB 0:00:00 [3.72MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_3/l1_0/l2_1@syncoid_iox86_2024-12-19:15:25:51-GMT-06:00 ... syncoid_iox86_2024-12-19:15:41:13-GMT-06:00 (~ 529 KB):
 413KiB 0:00:00 [1.68MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_3/l1_0/l2_2@syncoid_iox86_2024-12-19:15:25:54-GMT-06:00 ... syncoid_iox86_2024-12-19:15:41:15-GMT-06:00 (~ 706 KB):
 530KiB 0:00:00 [2.13MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_3/l1_0/l2_3@syncoid_iox86_2024-12-19:15:25:56-GMT-06:00 ... syncoid_iox86_2024-12-19:15:41:17-GMT-06:00 (~ 529 KB):
 414KiB 0:00:00 [1.79MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_3/l1_1@syncoid_iox86_2024-12-19:15:25:58-GMT-06:00 ... syncoid_iox86_2024-12-19:15:41:19-GMT-06:00 (~ 878 KB):
warning: cannot send 'send/test/l0_3/l1_1@syncoid_iox86_2024-12-19:15:41:19-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [17.9KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_3/l1_1/l2_0@syncoid_iox86_2024-12-19:15:26:00-GMT-06:00 ... syncoid_iox86_2024-12-19:15:41:21-GMT-06:00 (~ 722 KB):
 549KiB 0:00:00 [2.13MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_3/l1_1/l2_1@syncoid_iox86_2024-12-19:15:26:02-GMT-06:00 ... syncoid_iox86_2024-12-19:15:41:24-GMT-06:00 (~ 722 KB):
 542KiB 0:00:00 [2.27MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_3/l1_1/l2_2@syncoid_iox86_2024-12-19:15:26:05-GMT-06:00 ... syncoid_iox86_2024-12-19:15:41:26-GMT-06:00 (~ 646 KB):
 533KiB 0:00:00 [2.11MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_3/l1_1/l2_3@syncoid_iox86_2024-12-19:15:26:07-GMT-06:00 ... syncoid_iox86_2024-12-19:15:41:28-GMT-06:00 (~ 822 KB):
 643KiB 0:00:00 [2.57MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_3/l1_2@syncoid_iox86_2024-12-19:15:26:09-GMT-06:00 ... syncoid_iox86_2024-12-19:15:41:30-GMT-06:00 (~ 573 KB):
 411KiB 0:00:00 [1.90MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_3/l1_2/l2_0@syncoid_iox86_2024-12-19:15:26:11-GMT-06:00 ... syncoid_iox86_2024-12-19:15:41:33-GMT-06:00 (~ 1018 KB):
warning: cannot send 'send/test/l0_3/l1_2/l2_0@syncoid_iox86_2024-12-19:15:41:33-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [16.8KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_3/l1_2/l2_1@syncoid_iox86_2024-12-19:15:26:13-GMT-06:00 ... syncoid_iox86_2024-12-19:15:41:35-GMT-06:00 (~ 926 KB):
warning: cannot send 'send/test/l0_3/l1_2/l2_1@syncoid_iox86_2024-12-19:15:41:35-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [17.5KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_3/l1_2/l2_2@syncoid_iox86_2024-12-19:15:26:16-GMT-06:00 ... syncoid_iox86_2024-12-19:15:41:37-GMT-06:00 (~ 838 KB):
 661KiB 0:00:00 [2.72MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_3/l1_2/l2_3@syncoid_iox86_2024-12-19:15:26:18-GMT-06:00 ... syncoid_iox86_2024-12-19:15:41:39-GMT-06:00 (~ 822 KB):
 633KiB 0:00:00 [2.57MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_3/l1_3@syncoid_iox86_2024-12-19:15:26:20-GMT-06:00 ... syncoid_iox86_2024-12-19:15:41:41-GMT-06:00 (~ 914 KB):
 672KiB 0:00:00 [2.99MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_3/l1_3/l2_0@syncoid_iox86_2024-12-19:15:26:22-GMT-06:00 ... syncoid_iox86_2024-12-19:15:41:44-GMT-06:00 (~ 529 KB):
 410KiB 0:00:00 [1.69MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_3/l1_3/l2_1@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:15:41:46-GMT-06:00 (~ 822 KB):
warning: cannot send 'send/test/l0_3/l1_3/l2_1@syncoid_iox86_2024-12-19:15:26:24-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_3/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 393KiB/s] [======>                                                                                             ]  7%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3/l2_1'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_3/l1_3/l2_1'@'syncoid_iox86_2024-12-19:15:41:46-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 842472 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_3/l2_2@syncoid_iox86_2024-12-19:15:26:27-GMT-06:00 ... syncoid_iox86_2024-12-19:15:41:48-GMT-06:00 (~ 898 KB):
 664KiB 0:00:00 [2.68MiB/s] [========================================================================>                           ] 73%            
Resuming interrupted zfs send/receive from send/test/l0_3/l1_3/l2_3 to recv/test/l0_3/l1_3/l2_3 (~ 589 KB remaining):
internal error: warning: cannot send 'send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-19:15:26:29-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-118b3c37f5-118-789c636064000310a501c49c50360710a715e5e7a69766a630408145cff65f8b5a247914806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415f2219fbfbfbf12cc9c8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fac9f6308228ce28d1d8a2bf392f33353e233f32b2ccce28d0c8c4c740d8d740d2dad0c4dad8cccac8c2c75dd7d43740dccac0c0c606e0000e4702cb6 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 603472 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
real 169.65
user 16.70
sys 136.96
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
config:

        NAME                            STATE     READ WRITE CKSUM
        send                            ONLINE       0     0     0
          wwn-0x5002538d40dca5d9-part7  ONLINE       0     0     0
errors: List of errors unavailable: permission denied

errors: 32 data errors, use '-v' for a list


CRITICAL ERROR: Target recv exists but has no snapshots matching with send!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.

Sending incremental send/test@syncoid_iox86_2024-12-19:15:39:01-GMT-06:00 ... syncoid_iox86_2024-12-19:15:54:20-GMT-06:00 (~ 4 KB):
2.13KiB 0:00:00 [28.2KiB/s] [====================================================>                                               ] 53%            
Sending incremental send/test/l0_0@syncoid_iox86_2024-12-19:15:39:02-GMT-06:00 ... syncoid_iox86_2024-12-19:15:54:22-GMT-06:00 (~ 702 KB):
 642KiB 0:00:00 [5.56MiB/s] [==========================================================================================>         ] 91%            
Sending incremental send/test/l0_0/l1_0@syncoid_iox86_2024-12-19:15:39:04-GMT-06:00 ... syncoid_iox86_2024-12-19:15:54:24-GMT-06:00 (~ 1.0 MB):
 799KiB 0:00:00 [5.63MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-19:15:39:06-GMT-06:00 ... syncoid_iox86_2024-12-19:15:54:26-GMT-06:00 (~ 646 KB):
 533KiB 0:00:00 [3.70MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-19:15:39:09-GMT-06:00 ... syncoid_iox86_2024-12-19:15:54:28-GMT-06:00 (~ 766 KB):
 533KiB 0:00:00 [3.84MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_0/l1_0/l2_2@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:15:54:30-GMT-06:00 (~ 1.8 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-19:15:39:11-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_0/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 400KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_2'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_0/l1_0/l2_2'@'syncoid_iox86_2024-12-19:15:54:30-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1900896 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-19:15:39:13-GMT-06:00 ... syncoid_iox86_2024-12-19:15:54:32-GMT-06:00 (~ 650 KB):
 411KiB 0:00:00 [3.21MiB/s] [==============================================================>                                     ] 63%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1 to recv/test/l0_0/l1_1 (~ 765 KB remaining):
internal error: warning: cannot send 'send/test/l0_0/l1_1@syncoid_iox86_2024-12-19:15:23:43-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-11a7fcef30-110-789c636064000310a501c49c50360710a715e5e7a69766a63040812cfbeff43ac69b310a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a857d1e9723d5bead8d4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d0cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b63231d675f70dd13530b3323000db0d00f6802ab3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 783880 |  zfs receive  -s -F 'recv/test/l0_0/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-19:15:39:16-GMT-06:00 ... syncoid_iox86_2024-12-19:15:54:35-GMT-06:00 (~ 766 KB):
 536KiB 0:00:00 [4.02MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-19:15:39:18-GMT-06:00 ... syncoid_iox86_2024-12-19:15:54:37-GMT-06:00 (~ 381 KB):
 270KiB 0:00:00 [2.04MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_0/l1_1/l2_2@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:15:54:40-GMT-06:00 (~ 1.3 MB):
warning: cannot send 'send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-19:15:39:20-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_1/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 389KiB/s] [===>                                                                                                ]  4%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_2'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_0/l1_1/l2_2'@'syncoid_iox86_2024-12-19:15:54:40-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1404544 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1/l2_3 to recv/test/l0_0/l1_1/l2_3 (~ 913 KB remaining):
warning: cannot send 'send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-19:15:39:22-GMT-06:00': Input/output error
 408 B 0:00:00 [4.59KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1136c0efbd-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041d3b6c3921ba7f09d5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057d8f4bf9952bfe4dbe10424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837803fd1cc37843fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b634b2b23235d77df105d03332b0303981b0090282dd3
CRITICAL ERROR:  zfs send  -t 1-1136c0efbd-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041d3b6c3921ba7f09d5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057d8f4bf9952bfe4dbe10424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837803fd1cc37843fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b634b2b23235d77df105d03332b0303981b0090282dd3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 935800 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_2@syncoid_iox86_2024-12-19:15:39:24-GMT-06:00 ... syncoid_iox86_2024-12-19:15:54:42-GMT-06:00 (~ 826 KB):
 538KiB 0:00:00 [4.58MiB/s] [================================================================>                                   ] 65%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_2/l2_0 to recv/test/l0_0/l1_2/l2_0 (~ 781 KB remaining):
warning: cannot send 'send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-19:15:39:26-GMT-06:00': Input/output error
 408 B 0:00:00 [3.90KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11d384ec20-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c142be63273a9bb6c62900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bd4ec24bf987ee23f998024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fa49f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656c696564a6ebee1ba26b6066656000730300ff272c45
CRITICAL ERROR:  zfs send  -t 1-11d384ec20-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c142be63273a9bb6c62900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bd4ec24bf987ee23f998024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fa49f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656c696564a6ebee1ba26b6066656000730300ff272c45 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 800448 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_2/l2_1 to recv/test/l0_0/l1_2/l2_1 (~ 677 KB remaining):
warning: cannot send 'send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-19:15:39:28-GMT-06:00': Input/output error
 408 B 0:00:00 [3.86KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-127e44ff0a-118-789c636064000310a501c49c50360710a715e5e7a69766a630408154cbf596c2961b1a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28aa97713ed98eb959f2420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61be9e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1959e8bafb86e81a98591918c0dc0000b0b52c05
CRITICAL ERROR:  zfs send  -t 1-127e44ff0a-118-789c636064000310a501c49c50360710a715e5e7a69766a630408154cbf596c2961b1a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28aa97713ed98eb959f2420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61be9e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1959e8bafb86e81a98591918c0dc0000b0b52c05 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 693768 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-19:15:39:31-GMT-06:00 ... syncoid_iox86_2024-12-19:15:54:45-GMT-06:00 (~ 870 KB):
 673KiB 0:00:00 [4.72MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-19:15:39:33-GMT-06:00 ... syncoid_iox86_2024-12-19:15:54:47-GMT-06:00 (~ 453 KB):
 409KiB 0:00:00 [2.96MiB/s] [=========================================================================================>          ] 90%            
Sending incremental send/test/l0_0/l1_3@syncoid_iox86_2024-12-19:15:39:35-GMT-06:00 ... syncoid_iox86_2024-12-19:15:54:49-GMT-06:00 (~ 646 KB):
 535KiB 0:00:00 [4.01MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-19:15:39:37-GMT-06:00 ... syncoid_iox86_2024-12-19:15:54:51-GMT-06:00 (~ 974 KB):
 671KiB 0:00:00 [4.94MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-19:15:39:39-GMT-06:00 ... syncoid_iox86_2024-12-19:15:54:53-GMT-06:00 (~ 589 KB):
 409KiB 0:00:00 [2.86MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-19:15:39:41-GMT-06:00 ... syncoid_iox86_2024-12-19:15:54:56-GMT-06:00 (~ 898 KB):
 669KiB 0:00:00 [4.75MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_0/l1_3/l2_3@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:15:54:58-GMT-06:00 (~ 1.1 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-19:15:39:44-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 407KiB/s] [====>                                                                                               ]  5%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_3'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_0/l1_3/l2_3'@'syncoid_iox86_2024-12-19:15:54:58-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1191184 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1@syncoid_iox86_2024-12-19:15:39:45-GMT-06:00 ... syncoid_iox86_2024-12-19:15:54:59-GMT-06:00 (~ 678 KB):
 552KiB 0:00:00 [4.58MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_1/l1_0@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:15:55:01-GMT-06:00 (~ 1.6 MB):
warning: cannot send 'send/test/l0_1/l1_0@syncoid_iox86_2024-12-19:15:39:47-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_0 does not
match incremental source
64.0KiB 0:00:00 [ 403KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_1/l1_0'@'syncoid_iox86_2024-12-19:15:55:01-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1658680 |  zfs receive  -s -F 'recv/test/l0_1/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-19:15:39:49-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:03-GMT-06:00 (~ 1.1 MB):
 799KiB 0:00:00 [5.81MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-19:15:39:52-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:06-GMT-06:00 (~ 854 KB):
 667KiB 0:00:00 [4.44MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-19:15:39:54-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:08-GMT-06:00 (~ 441 KB):
 278KiB 0:00:00 [2.20MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_1/l1_0/l2_3@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:15:55:10-GMT-06:00 (~ 2.4 MB):
warning: cannot send 'send/test/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-19:15:24:26-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 496KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_3'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_1/l1_0/l2_3'@'syncoid_iox86_2024-12-19:15:55:10-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2484328 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1@syncoid_iox86_2024-12-19:15:39:58-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:12-GMT-06:00 (~ 589 KB):
 414KiB 0:00:00 [3.32MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-19:15:40:00-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:14-GMT-06:00 (~ 914 KB):
 670KiB 0:00:00 [4.76MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-19:15:40:03-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:17-GMT-06:00 (~ 1.4 MB):
1.04MiB 0:00:00 [7.13MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-19:15:40:05-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:19-GMT-06:00 (~ 974 KB):
 669KiB 0:00:00 [4.94MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-19:15:40:07-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:21-GMT-06:00 (~ 782 KB):
 534KiB 0:00:00 [3.97MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_1/l1_2@syncoid_iox86_2024-12-19:15:40:09-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:23-GMT-06:00 (~ 633 KB):
 408KiB 0:00:00 [3.05MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_1/l1_2/l2_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:15:55:25-GMT-06:00 (~ 1.8 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:24:41-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:40:11-GMT-06:00': Invalid argument
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 483KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_1/l1_2/l2_0'@'syncoid_iox86_2024-12-19:15:55:25-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1926720 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-19:15:40:13-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:27-GMT-06:00 (~ 573 KB):
 405KiB 0:00:00 [3.02MiB/s] [=====================================================================>                              ] 70%            
Resuming interrupted zfs send/receive from send/test/l0_1/l1_2/l2_2 to recv/test/l0_1/l1_2/l2_2 (~ 441 KB remaining):
internal error: warning: cannot send 'send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-19:15:24:46-GMT-06:00': Invalid argument
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
Aborted
CRITICAL ERROR:  zfs send  -t 1-10c0c26d5d-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c119ee6bd985a9cf1415806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415c2fbb6ac5820c35a9e8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa89f63186fa49f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a6564626562a6ebee1ba26b6066656000730300a3612bd3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 451736 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-19:15:40:16-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:30-GMT-06:00 (~ 782 KB):
 542KiB 0:00:00 [3.75MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_1/l1_3@syncoid_iox86_2024-12-19:15:40:18-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:32-GMT-06:00 (~ 381 KB):
 278KiB 0:00:00 [2.28MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_1/l1_3/l2_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:15:55:34-GMT-06:00 (~ 2.2 MB):
warning: cannot send 'send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-19:15:24:52-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 494KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_3/l2_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_1/l1_3/l2_0'@'syncoid_iox86_2024-12-19:15:55:34-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2291816 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-19:15:40:22-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:36-GMT-06:00 (~ 942 KB):
 809KiB 0:00:00 [5.50MiB/s] [====================================================================================>               ] 85%            
Sending incremental send/test/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-19:15:40:25-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:38-GMT-06:00 (~ 1.1 MB):
 794KiB 0:00:00 [5.44MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-19:15:40:27-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:40-GMT-06:00 (~ 629 KB):
 514KiB 0:00:00 [3.71MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_2@syncoid_iox86_2024-12-19:15:40:28-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:42-GMT-06:00 (~ 706 KB):
 535KiB 0:00:00 [4.49MiB/s] [==========================================================================>                         ] 75%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_0 to recv/test/l0_2/l1_0 (~ 172 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_0@syncoid_iox86_2024-12-19:15:25:02-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-13c9ed8a18-110-789c636064000310a501c49c50360710a715e5e7a69766a6304041f15cde74936d7c350a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a904dbc359336a67d8c4092e704cbe725e6a602dd979a97a20f34aa443fc720de483fc730dec0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cac048d7dd3744d7c0cccac0006c3700a3a12a2c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 176936 |  zfs receive  -s -F 'recv/test/l0_2/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-19:15:40:31-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:45-GMT-06:00 (~ 633 KB):
 407KiB 0:00:00 [3.03MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-19:15:40:33-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:47-GMT-06:00 (~ 646 KB):
 538KiB 0:00:00 [3.84MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/l0_2/l1_0/l2_2@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:15:55:49-GMT-06:00 (~ 1.7 MB):
warning: cannot send 'send/test/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-19:15:25:09-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 503KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_0/l2_2'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_2/l1_0/l2_2'@'syncoid_iox86_2024-12-19:15:55:49-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1742032 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-19:15:40:38-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:51-GMT-06:00 (~ 930 KB):
 675KiB 0:00:00 [4.83MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_2/l1_1@syncoid_iox86_2024-12-19:15:40:40-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:53-GMT-06:00 (~ 854 KB):
 669KiB 0:00:00 [2.59MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-19:15:40:42-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:56-GMT-06:00 (~ 1.0 MB):
 815KiB 0:00:00 [3.26MiB/s] [=============================================================================>                      ] 78%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_1/l2_1 to recv/test/l0_2/l1_1/l2_1 (~ 721 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-19:15:25:18-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-ff823389f-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1222bc149011dceef15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4151f5e86aa54575f399a8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa89f63146fe8505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6568a1ebee1ba26b6066656000730300d8b82ce2 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 738824 |  zfs receive  -s -F 'recv/test/l0_2/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-19:15:40:45-GMT-06:00 ... syncoid_iox86_2024-12-19:15:55:59-GMT-06:00 (~ 1.5 MB):
1.04MiB 0:00:00 [4.45MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-19:15:40:47-GMT-06:00 ... syncoid_iox86_2024-12-19:15:56:01-GMT-06:00 (~ 1.2 MB):
 951KiB 0:00:00 [3.84MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_2/l1_2@syncoid_iox86_2024-12-19:15:40:49-GMT-06:00 ... syncoid_iox86_2024-12-19:15:56:03-GMT-06:00 (~ 1.3 MB):
 947KiB 0:00:00 [4.15MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_2/l1_2/l2_0@syncoid_iox86_2024-12-19:15:40:51-GMT-06:00 ... syncoid_iox86_2024-12-19:15:56:05-GMT-06:00 (~ 2.2 MB):
1.56MiB 0:00:00 [6.48MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_2/l1_2/l2_1@syncoid_iox86_2024-12-19:15:40:53-GMT-06:00 ... syncoid_iox86_2024-12-19:15:56:07-GMT-06:00 (~ 1.4 MB):
1.06MiB 0:00:00 [4.31MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_2/l1_2/l2_2@syncoid_iox86_2024-12-19:15:40:56-GMT-06:00 ... syncoid_iox86_2024-12-19:15:56:10-GMT-06:00 (~ 1.4 MB):
1.16MiB 0:00:00 [4.65MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_2/l1_2/l2_3@syncoid_iox86_2024-12-19:15:40:58-GMT-06:00 ... syncoid_iox86_2024-12-19:15:56:12-GMT-06:00 (~ 1.2 MB):
 929KiB 0:00:00 [3.80MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_2/l1_3@syncoid_iox86_2024-12-19:15:41:00-GMT-06:00 ... syncoid_iox86_2024-12-19:15:56:14-GMT-06:00 (~ 954 KB):
 682KiB 0:00:00 [3.01MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_2/l1_3/l2_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:15:56:16-GMT-06:00 (~ 3.0 MB):
warning: cannot send 'send/test/l0_2/l1_3/l2_0@syncoid_iox86_2024-12-19:15:25:37-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 515KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_2/l1_3/l2_0'@'syncoid_iox86_2024-12-19:15:56:16-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3128504 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_1 to recv/test/l0_2/l1_3/l2_1 (~ 557 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-19:15:25:39-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-14c7859310-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1459fa97f6772eabe5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057a42cf1b39e5e29783601499e132c9f97989bcac0509c9a97a20f34aa443fc720de483fc730de583fc728ded0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cad852d7dd3744d7c0cccac000e6060018eb2c68 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 570704 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_3/l2_2@syncoid_iox86_2024-12-19:15:41:05-GMT-06:00 ... syncoid_iox86_2024-12-19:15:56:18-GMT-06:00 (~ 1.3 MB):
1.02MiB 0:00:00 [4.16MiB/s] [===========================================================================>                        ] 76%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_3 to recv/test/l0_2/l1_3/l2_3 (~ 629 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-19:15:25:44-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-14bb428d41-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c193fcf2ca3fbbf6592900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b6a5e1844ad2cbeb03f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de483fc730de583fc728ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cac444d7dd3744d7c0cccac000e6060004302e05 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 644432 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:15:56:21-GMT-06:00 (~ 2.5 MB):
warning: cannot send 'send/test/l0_3@syncoid_iox86_2024-12-19:15:25:45-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 589KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_3'@'syncoid_iox86_2024-12-19:15:56:21-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2607576 |  zfs receive  -s -F 'recv/test/l0_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:15:56:22-GMT-06:00 (~ 4.2 MB):
warning: cannot send 'send/test/l0_3/l1_0@syncoid_iox86_2024-12-19:15:25:47-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_0 does not
match incremental source
64.0KiB 0:00:00 [ 393KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_3/l1_0'@'syncoid_iox86_2024-12-19:15:56:22-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4424496 |  zfs receive  -s -F 'recv/test/l0_3/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_0/l2_0@syncoid_iox86_2024-12-19:15:41:11-GMT-06:00 ... syncoid_iox86_2024-12-19:15:56:24-GMT-06:00 (~ 1.5 MB):
1.12MiB 0:00:00 [4.57MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_3/l1_0/l2_1@syncoid_iox86_2024-12-19:15:41:13-GMT-06:00 ... syncoid_iox86_2024-12-19:15:56:27-GMT-06:00 (~ 1.2 MB):
1.02MiB 0:00:00 [4.17MiB/s] [====================================================================================>               ] 85%            
Sending incremental send/test/l0_3/l1_0/l2_2@syncoid_iox86_2024-12-19:15:41:15-GMT-06:00 ... syncoid_iox86_2024-12-19:15:56:29-GMT-06:00 (~ 1.5 MB):
1.26MiB 0:00:00 [4.85MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_3/l1_0/l2_3@syncoid_iox86_2024-12-19:15:41:17-GMT-06:00 ... syncoid_iox86_2024-12-19:15:56:31-GMT-06:00 (~ 1.2 MB):
 938KiB 0:00:00 [3.92MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_3/l1_1@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:15:56:33-GMT-06:00 (~ 2.2 MB):
warning: cannot send 'send/test/l0_3/l1_1@syncoid_iox86_2024-12-19:15:41:19-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_1 does not
match incremental source
64.0KiB 0:00:00 [ 407KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_1'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_3/l1_1'@'syncoid_iox86_2024-12-19:15:56:33-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2339536 |  zfs receive  -s -F 'recv/test/l0_3/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_1/l2_0@syncoid_iox86_2024-12-19:15:41:21-GMT-06:00 ... syncoid_iox86_2024-12-19:15:56:35-GMT-06:00 (~ 954 KB):
 667KiB 0:00:00 [2.70MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_3/l1_1/l2_1@syncoid_iox86_2024-12-19:15:41:24-GMT-06:00 ... syncoid_iox86_2024-12-19:15:56:37-GMT-06:00 (~ 1.5 MB):
1.18MiB 0:00:00 [4.80MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_3/l1_1/l2_2@syncoid_iox86_2024-12-19:15:41:26-GMT-06:00 ... syncoid_iox86_2024-12-19:15:56:40-GMT-06:00 (~ 1.5 MB):
1.18MiB 0:00:00 [4.82MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_3/l1_1/l2_3@syncoid_iox86_2024-12-19:15:41:28-GMT-06:00 ... syncoid_iox86_2024-12-19:15:56:42-GMT-06:00 (~ 1.1 MB):
 906KiB 0:00:00 [3.77MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_3/l1_2@syncoid_iox86_2024-12-19:15:41:30-GMT-06:00 ... syncoid_iox86_2024-12-19:15:56:44-GMT-06:00 (~ 1.3 MB):
 955KiB 0:00:00 [4.13MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_3/l1_2/l2_0@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:15:56:46-GMT-06:00 (~ 2.5 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_0@syncoid_iox86_2024-12-19:15:41:33-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_2/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 369KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_0'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_3/l1_2/l2_0'@'syncoid_iox86_2024-12-19:15:56:46-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2610240 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2/l2_1@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:15:56:48-GMT-06:00 (~ 2.4 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_1@syncoid_iox86_2024-12-19:15:41:35-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_2/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 390KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_1'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_3/l1_2/l2_1'@'syncoid_iox86_2024-12-19:15:56:48-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2470792 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2/l2_2@syncoid_iox86_2024-12-19:15:41:37-GMT-06:00 ... syncoid_iox86_2024-12-19:15:56:50-GMT-06:00 (~ 1.7 MB):
1.30MiB 0:00:00 [5.24MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_3/l1_2/l2_3@syncoid_iox86_2024-12-19:15:41:39-GMT-06:00 ... syncoid_iox86_2024-12-19:15:56:53-GMT-06:00 (~ 1022 KB):
 767KiB 0:00:00 [3.16MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_3/l1_3@syncoid_iox86_2024-12-19:15:41:41-GMT-06:00 ... syncoid_iox86_2024-12-19:15:56:55-GMT-06:00 (~ 1.1 MB):
 949KiB 0:00:00 [3.98MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_3/l1_3/l2_0@syncoid_iox86_2024-12-19:15:41:44-GMT-06:00 ... syncoid_iox86_2024-12-19:15:56:57-GMT-06:00 (~ 1.2 MB):
 817KiB 0:00:00 [3.32MiB/s] [=================================================================>                                  ] 66%            
Sending incremental send/test/l0_3/l1_3/l2_1@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:15:56:59-GMT-06:00 (~ 2.0 MB):
warning: cannot send 'send/test/l0_3/l1_3/l2_1@syncoid_iox86_2024-12-19:15:26:24-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 529KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3/l2_1'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_3/l1_3/l2_1'@'syncoid_iox86_2024-12-19:15:56:59-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2139712 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_3/l2_2@syncoid_iox86_2024-12-19:15:41:48-GMT-06:00 ... syncoid_iox86_2024-12-19:15:57:01-GMT-06:00 (~ 1.7 MB):
1.31MiB 0:00:00 [5.42MiB/s] [==========================================================================>                         ] 75%            
Resuming interrupted zfs send/receive from send/test/l0_3/l1_3/l2_3 to recv/test/l0_3/l1_3/l2_3 (~ 589 KB remaining):
internal error: warning: cannot send 'send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-19:15:26:29-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-118b3c37f5-118-789c636064000310a501c49c50360710a715e5e7a69766a630408145cff65f8b5a247914806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415f2219fbfbfbf12cc9c8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fac9f6308228ce28d1d8a2bf392f33353e233f32b2ccce28d0c8c4c740d8d740d2dad0c4dad8cccac8c2c75dd7d43740dccac0c0c606e0000e4702cb6 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 603472 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
real 163.12
user 16.12
sys 132.10
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
config:

        NAME                            STATE     READ WRITE CKSUM
        send                            ONLINE       0     0     0
          wwn-0x5002538d40dca5d9-part7  ONLINE       0     0     0
errors: List of errors unavailable: permission denied

errors: 45 data errors, use '-v' for a list


CRITICAL ERROR: Target recv exists but has no snapshots matching with send!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.

Sending incremental send/test@syncoid_iox86_2024-12-19:15:54:20-GMT-06:00 ... syncoid_iox86_2024-12-19:16:09:34-GMT-06:00 (~ 4 KB):
2.74KiB 0:00:00 [34.8KiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_0@syncoid_iox86_2024-12-19:15:54:22-GMT-06:00 ... syncoid_iox86_2024-12-19:16:09:35-GMT-06:00 (~ 1.1 MB):
 812KiB 0:00:00 [3.09MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_0/l1_0@syncoid_iox86_2024-12-19:15:54:24-GMT-06:00 ... syncoid_iox86_2024-12-19:16:09:37-GMT-06:00 (~ 1.0 MB):
 813KiB 0:00:00 [2.54MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-19:15:54:26-GMT-06:00 ... syncoid_iox86_2024-12-19:16:09:40-GMT-06:00 (~ 1.3 MB):
1.05MiB 0:00:00 [3.07MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-19:15:54:28-GMT-06:00 ... syncoid_iox86_2024-12-19:16:09:42-GMT-06:00 (~ 1.8 MB):
1.31MiB 0:00:00 [3.84MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_0/l1_0/l2_2@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:09:44-GMT-06:00 (~ 3.2 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-19:15:39:11-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_0/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 371KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_2'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_0/l1_0/l2_2'@'syncoid_iox86_2024-12-19:16:09:44-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3334112 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-19:15:54:32-GMT-06:00 ... syncoid_iox86_2024-12-19:16:09:46-GMT-06:00 (~ 1.0 MB):
 796KiB 0:00:00 [2.22MiB/s] [============================================================================>                       ] 77%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1 to recv/test/l0_0/l1_1 (~ 765 KB remaining):
internal error: warning: cannot send 'send/test/l0_0/l1_1@syncoid_iox86_2024-12-19:15:23:43-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-11a7fcef30-110-789c636064000310a501c49c50360710a715e5e7a69766a63040812cfbeff43ac69b310a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a857d1e9723d5bead8d4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d0cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b63231d675f70dd13530b3323000db0d00f6802ab3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 783880 |  zfs receive  -s -F 'recv/test/l0_0/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-19:15:54:35-GMT-06:00 ... syncoid_iox86_2024-12-19:16:09:49-GMT-06:00 (~ 1.2 MB):
 920KiB 0:00:00 [2.55MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-19:15:54:37-GMT-06:00 ... syncoid_iox86_2024-12-19:16:09:51-GMT-06:00 (~ 1.6 MB):
1.15MiB 0:00:00 [3.40MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_0/l1_1/l2_2@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:09:54-GMT-06:00 (~ 2.6 MB):
warning: cannot send 'send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-19:15:39:20-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 510KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_2'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_0/l1_1/l2_2'@'syncoid_iox86_2024-12-19:16:09:54-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2731080 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1/l2_3 to recv/test/l0_0/l1_1/l2_3 (~ 913 KB remaining):
warning: cannot send 'send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-19:15:39:22-GMT-06:00': Input/output error
 408 B 0:00:00 [4.53KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1136c0efbd-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041d3b6c3921ba7f09d5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057d8f4bf9952bfe4dbe10424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837803fd1cc37843fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b634b2b23235d77df105d03332b0303981b0090282dd3
CRITICAL ERROR:  zfs send  -t 1-1136c0efbd-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041d3b6c3921ba7f09d5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057d8f4bf9952bfe4dbe10424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837803fd1cc37843fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b634b2b23235d77df105d03332b0303981b0090282dd3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 935800 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_2@syncoid_iox86_2024-12-19:15:54:42-GMT-06:00 ... syncoid_iox86_2024-12-19:16:09:56-GMT-06:00 (~ 1.7 MB):
1.31MiB 0:00:00 [4.11MiB/s] [=============================================================================>                      ] 78%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_2/l2_0 to recv/test/l0_0/l1_2/l2_0 (~ 781 KB remaining):
warning: cannot send 'send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-19:15:39:26-GMT-06:00': Input/output error
 408 B 0:00:00 [3.67KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11d384ec20-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c142be63273a9bb6c62900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bd4ec24bf987ee23f998024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fa49f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656c696564a6ebee1ba26b6066656000730300ff272c45
CRITICAL ERROR:  zfs send  -t 1-11d384ec20-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c142be63273a9bb6c62900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bd4ec24bf987ee23f998024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fa49f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656c696564a6ebee1ba26b6066656000730300ff272c45 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 800448 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_2/l2_1 to recv/test/l0_0/l1_2/l2_1 (~ 677 KB remaining):
warning: cannot send 'send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-19:15:39:28-GMT-06:00': Input/output error
 408 B 0:00:00 [4.05KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-127e44ff0a-118-789c636064000310a501c49c50360710a715e5e7a69766a630408154cbf596c2961b1a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28aa97713ed98eb959f2420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61be9e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1959e8bafb86e81a98591918c0dc0000b0b52c05
CRITICAL ERROR:  zfs send  -t 1-127e44ff0a-118-789c636064000310a501c49c50360710a715e5e7a69766a630408154cbf596c2961b1a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28aa97713ed98eb959f2420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61be9e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1959e8bafb86e81a98591918c0dc0000b0b52c05 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 693768 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-19:15:54:45-GMT-06:00 ... syncoid_iox86_2024-12-19:16:09:59-GMT-06:00 (~ 1.6 MB):
1.17MiB 0:00:00 [3.33MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-19:15:54:47-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:01-GMT-06:00 (~ 1.4 MB):
1.06MiB 0:00:00 [3.10MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_3@syncoid_iox86_2024-12-19:15:54:49-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:03-GMT-06:00 (~ 1.2 MB):
 939KiB 0:00:00 [2.90MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-19:15:54:51-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:06-GMT-06:00 (~ 1.1 MB):
 943KiB 0:00:00 [2.77MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-19:15:54:53-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:08-GMT-06:00 (~ 999 KB):
 827KiB 0:00:00 [2.42MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-19:15:54:56-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:10-GMT-06:00 (~ 1.6 MB):
1.18MiB 0:00:00 [3.51MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_0/l1_3/l2_3@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:10:13-GMT-06:00 (~ 2.9 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-19:15:39:44-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 377KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_3'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_0/l1_3/l2_3'@'syncoid_iox86_2024-12-19:16:10:13-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3026360 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1@syncoid_iox86_2024-12-19:15:54:59-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:14-GMT-06:00 (~ 1.5 MB):
1.19MiB 0:00:00 [4.05MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_1/l1_0@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:10:16-GMT-06:00 (~ 3.4 MB):
warning: cannot send 'send/test/l0_1/l1_0@syncoid_iox86_2024-12-19:15:39:47-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_0 does not
match incremental source
64.0KiB 0:00:00 [ 373KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_1/l1_0'@'syncoid_iox86_2024-12-19:16:10:16-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3543008 |  zfs receive  -s -F 'recv/test/l0_1/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-19:15:55:03-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:19-GMT-06:00 (~ 1.1 MB):
 775KiB 0:00:00 [2.28MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-19:15:55:06-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:21-GMT-06:00 (~ 1.6 MB):
1.17MiB 0:00:00 [3.52MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-19:15:55:08-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:23-GMT-06:00 (~ 939 KB):
 671KiB 0:00:00 [2.01MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_1/l1_0/l2_3@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:10:26-GMT-06:00 (~ 4.0 MB):
warning: cannot send 'send/test/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-19:15:24:26-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 426KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_3'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_1/l1_0/l2_3'@'syncoid_iox86_2024-12-19:16:10:26-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4221016 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1@syncoid_iox86_2024-12-19:15:55:12-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:28-GMT-06:00 (~ 910 KB):
 690KiB 0:00:00 [2.14MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-19:15:55:14-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:30-GMT-06:00 (~ 1.5 MB):
1.18MiB 0:00:00 [3.35MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-19:15:55:17-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:32-GMT-06:00 (~ 1.5 MB):
1.18MiB 0:00:00 [3.39MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-19:15:55:19-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:35-GMT-06:00 (~ 1.4 MB):
1.05MiB 0:00:00 [3.15MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-19:15:55:21-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:37-GMT-06:00 (~ 1.3 MB):
 943KiB 0:00:00 [2.68MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_1/l1_2@syncoid_iox86_2024-12-19:15:55:23-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:39-GMT-06:00 (~ 1.9 MB):
warning: cannot send 'send/test/l0_1/l1_2@syncoid_iox86_2024-12-19:16:10:39-GMT-06:00': Invalid argument
 934KiB 0:00:00 [6.07MiB/s] [================================================>                                                   ] 49%            
Sending incremental send/test/l0_1/l1_2/l2_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:10:41-GMT-06:00 (~ 3.2 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:24:41-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:40:11-GMT-06:00': Invalid argument
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 415KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_1/l1_2/l2_0'@'syncoid_iox86_2024-12-19:16:10:41-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3372408 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-19:15:55:27-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:43-GMT-06:00 (~ 1.1 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_1@autosnap_2024-12-19_22:00:37_hourly': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_2/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 382KiB/s] [====>                                                                                               ]  5%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-19:15:55:27-GMT-06:00' 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-19:16:10:43-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1113176 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_2/l2_2 to recv/test/l0_1/l1_2/l2_2 (~ 441 KB remaining):
internal error: warning: cannot send 'send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-19:15:24:46-GMT-06:00': Invalid argument
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-10c0c26d5d-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c119ee6bd985a9cf1415806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415c2fbb6ac5820c35a9e8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa89f63186fa49f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a6564626562a6ebee1ba26b6066656000730300a3612bd3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 451736 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-19:15:55:30-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:46-GMT-06:00 (~ 1.5 MB):
1.18MiB 0:00:00 [3.46MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_1/l1_3@syncoid_iox86_2024-12-19:15:55:32-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:48-GMT-06:00 (~ 1.6 MB):
warning: cannot send 'send/test/l0_1/l1_3@syncoid_iox86_2024-12-19:16:10:48-GMT-06:00': Invalid argument
 142KiB 0:00:00 [1.08MiB/s] [=======>                                                                                            ]  8%            
Sending incremental send/test/l0_1/l1_3/l2_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:10:50-GMT-06:00 (~ 3.9 MB):
warning: cannot send 'send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-19:15:24:52-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 427KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_3/l2_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_1/l1_3/l2_0'@'syncoid_iox86_2024-12-19:16:10:50-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4102416 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-19:15:55:36-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:52-GMT-06:00 (~ 1.1 MB):
 961KiB 0:00:00 [2.74MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-19:15:55:38-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:55-GMT-06:00 (~ 1.5 MB):
1.06MiB 0:00:00 [3.12MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-19:15:55:40-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:57-GMT-06:00 (~ 1.7 MB):
1.16MiB 0:00:00 [3.38MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_2@syncoid_iox86_2024-12-19:15:55:42-GMT-06:00 ... syncoid_iox86_2024-12-19:16:10:59-GMT-06:00 (~ 714 KB):
 521KiB 0:00:00 [1.79MiB/s] [=======================================================================>                            ] 72%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_0 to recv/test/l0_2/l1_0 (~ 172 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_0@syncoid_iox86_2024-12-19:15:25:02-GMT-06:00': Invalid argument
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            Aborted

cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-13c9ed8a18-110-789c636064000310a501c49c50360710a715e5e7a69766a6304041f15cde74936d7c350a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a904dbc359336a67d8c4092e704cbe725e6a602dd979a97a20f34aa443fc720de483fc730dec0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cac048d7dd3744d7c0cccac0006c3700a3a12a2c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 176936 |  zfs receive  -s -F 'recv/test/l0_2/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-19:15:55:45-GMT-06:00 ... syncoid_iox86_2024-12-19:16:11:02-GMT-06:00 (~ 1.2 MB):
1.04MiB 0:00:00 [3.00MiB/s] [=====================================================================================>              ] 86%            
Sending incremental send/test/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-19:15:55:47-GMT-06:00 ... syncoid_iox86_2024-12-19:16:11:04-GMT-06:00 (~ 938 KB):
 665KiB 0:00:00 [1.91MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_2/l1_0/l2_2@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:11:06-GMT-06:00 (~ 3.2 MB):
warning: cannot send 'send/test/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-19:15:25:09-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
68.0KiB 0:00:00 [ 323KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x31000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_0/l2_2'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_2/l1_0/l2_2'@'syncoid_iox86_2024-12-19:16:11:06-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3326984 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-19:15:55:51-GMT-06:00 ... syncoid_iox86_2024-12-19:16:11:08-GMT-06:00 (~ 1.4 MB):
1.05MiB 0:00:00 [3.07MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_2/l1_1@syncoid_iox86_2024-12-19:15:55:53-GMT-06:00 ... syncoid_iox86_2024-12-19:16:11:10-GMT-06:00 (~ 1.5 MB):
1.18MiB 0:00:00 [3.60MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-19:15:55:56-GMT-06:00 ... syncoid_iox86_2024-12-19:16:11:13-GMT-06:00 (~ 706 KB):
 531KiB 0:00:00 [1.55MiB/s] [==========================================================================>                         ] 75%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_1/l2_1 to recv/test/l0_2/l1_1/l2_1 (~ 721 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-19:15:25:18-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-ff823389f-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1222bc149011dceef15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4151f5e86aa54575f399a8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa89f63146fe8505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6568a1ebee1ba26b6066656000730300d8b82ce2 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 738824 |  zfs receive  -s -F 'recv/test/l0_2/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-19:15:55:59-GMT-06:00 ... syncoid_iox86_2024-12-19:16:11:16-GMT-06:00 (~ 590 KB):
 415KiB 0:00:00 [1.21MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-19:15:56:01-GMT-06:00 ... syncoid_iox86_2024-12-19:16:11:18-GMT-06:00 (~ 738 KB):
 549KiB 0:00:00 [1.57MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_2/l1_2@syncoid_iox86_2024-12-19:15:56:03-GMT-06:00 ... syncoid_iox86_2024-12-19:16:11:20-GMT-06:00 (~ 650 KB):
 415KiB 0:00:00 [1.37MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_2/l1_2/l2_0@syncoid_iox86_2024-12-19:15:56:05-GMT-06:00 ... syncoid_iox86_2024-12-19:16:11:22-GMT-06:00 (~ 782 KB):
 545KiB 0:00:00 [1.59MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_2/l1_2/l2_1@syncoid_iox86_2024-12-19:15:56:07-GMT-06:00 ... syncoid_iox86_2024-12-19:16:11:25-GMT-06:00 (~ 722 KB):
warning: cannot send 'send/test/l0_2/l1_2/l2_1@syncoid_iox86_2024-12-19:16:11:25-GMT-06:00': Input/output error
2.44KiB 0:00:00 [22.9KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1401815849-118-789c636064000310a501c49c50360710a715e5e7a69766a630408169bb71866b7259970290cd8ea42e3f292b35b904c207010cf9b4b4e2d412063800c9b321c9275596a41633a0ca23eb2fc987b8a2bfb4f74661828a6502923c27583e2f31379581a138352f451f6854897e8e41bc917e8e2188308a377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b43232d575f70dd13530b3323080b90100d6e62b09
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_2/l2_1'@'syncoid_iox86_2024-12-19:15:56:07-GMT-06:00' 'send/test/l0_2/l1_2/l2_1'@'syncoid_iox86_2024-12-19:16:11:25-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 740072 |  zfs receive  -s -F 'recv/test/l0_2/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_2/l2_2@syncoid_iox86_2024-12-19:15:56:10-GMT-06:00 ... syncoid_iox86_2024-12-19:16:11:27-GMT-06:00 (~ 1.0 MB):
 806KiB 0:00:00 [2.29MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_2/l1_2/l2_3@syncoid_iox86_2024-12-19:15:56:12-GMT-06:00 ... syncoid_iox86_2024-12-19:16:11:29-GMT-06:00 (~ 706 KB):
 536KiB 0:00:00 [1.57MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_2/l1_3@syncoid_iox86_2024-12-19:15:56:14-GMT-06:00 ... syncoid_iox86_2024-12-19:16:11:31-GMT-06:00 (~ 382 KB):
 280KiB 0:00:00 [ 907KiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_2/l1_3/l2_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:11:34-GMT-06:00 (~ 3.7 MB):
warning: cannot send 'send/test/l0_2/l1_3/l2_0@syncoid_iox86_2024-12-19:15:25:37-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 474KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_2/l1_3/l2_0'@'syncoid_iox86_2024-12-19:16:11:34-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3852192 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_1 to recv/test/l0_2/l1_3/l2_1 (~ 557 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-19:15:25:39-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-14c7859310-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1459fa97f6772eabe5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057a42cf1b39e5e29783601499e132c9f97989bcac0509c9a97a20f34aa443fc720de483fc730de583fc728ded0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cad852d7dd3744d7c0cccac000e6060018eb2c68 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 570704 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_3/l2_2@syncoid_iox86_2024-12-19:15:56:18-GMT-06:00 ... syncoid_iox86_2024-12-19:16:11:36-GMT-06:00 (~ 690 KB):
 525KiB 0:00:00 [1.54MiB/s] [===========================================================================>                        ] 76%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_3 to recv/test/l0_2/l1_3/l2_3 (~ 629 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-19:15:25:44-GMT-06:00': Invalid argument
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-14bb428d41-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c193fcf2ca3fbbf6592900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b6a5e1844ad2cbeb03f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de483fc730de583fc728ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cac444d7dd3744d7c0cccac000e6060004302e05 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 644432 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:11:38-GMT-06:00 (~ 3.3 MB):
warning: cannot send 'send/test/l0_3@syncoid_iox86_2024-12-19:15:25:45-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 533KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_3'@'syncoid_iox86_2024-12-19:16:11:38-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3483000 |  zfs receive  -s -F 'recv/test/l0_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:11:40-GMT-06:00 (~ 5.4 MB):
warning: cannot send 'send/test/l0_3/l1_0@syncoid_iox86_2024-12-19:15:25:47-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 468KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_3/l1_0'@'syncoid_iox86_2024-12-19:16:11:40-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5648632 |  zfs receive  -s -F 'recv/test/l0_3/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_0/l2_0@syncoid_iox86_2024-12-19:15:56:24-GMT-06:00 ... syncoid_iox86_2024-12-19:16:11:42-GMT-06:00 (~ 650 KB):
 405KiB 0:00:00 [1.18MiB/s] [=============================================================>                                      ] 62%            
Sending incremental send/test/l0_3/l1_0/l2_1@syncoid_iox86_2024-12-19:15:56:27-GMT-06:00 ... syncoid_iox86_2024-12-19:16:11:45-GMT-06:00 (~ 782 KB):
 538KiB 0:00:00 [1.58MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_3/l1_0/l2_2@syncoid_iox86_2024-12-19:15:56:29-GMT-06:00 ... syncoid_iox86_2024-12-19:16:11:47-GMT-06:00 (~ 931 KB):
 677KiB 0:00:00 [2.04MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_3/l1_0/l2_3@syncoid_iox86_2024-12-19:15:56:31-GMT-06:00 ... syncoid_iox86_2024-12-19:16:11:49-GMT-06:00 (~ 634 KB):
 407KiB 0:00:00 [1.19MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_3/l1_1@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:11:51-GMT-06:00 (~ 2.7 MB):
warning: cannot send 'send/test/l0_3/l1_1@syncoid_iox86_2024-12-19:15:41:19-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
72.0KiB 0:00:00 [ 373KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x42000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_1'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_3/l1_1'@'syncoid_iox86_2024-12-19:16:11:51-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2784328 |  zfs receive  -s -F 'recv/test/l0_3/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_1/l2_0@syncoid_iox86_2024-12-19:15:56:35-GMT-06:00 ... syncoid_iox86_2024-12-19:16:11:54-GMT-06:00 (~ 1.4 MB):
 938KiB 0:00:00 [2.74MiB/s] [==================================================================>                                 ] 67%            
Sending incremental send/test/l0_3/l1_1/l2_1@syncoid_iox86_2024-12-19:15:56:37-GMT-06:00 ... syncoid_iox86_2024-12-19:16:11:56-GMT-06:00 (~ 1.4 MB):
1.04MiB 0:00:00 [2.98MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_3/l1_1/l2_2@syncoid_iox86_2024-12-19:15:56:40-GMT-06:00 ... syncoid_iox86_2024-12-19:16:11:58-GMT-06:00 (~ 975 KB):
 668KiB 0:00:00 [2.03MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_3/l1_1/l2_3@syncoid_iox86_2024-12-19:15:56:42-GMT-06:00 ... syncoid_iox86_2024-12-19:16:12:01-GMT-06:00 (~ 662 KB):
 543KiB 0:00:00 [1.58MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_3/l1_2@syncoid_iox86_2024-12-19:15:56:44-GMT-06:00 ... syncoid_iox86_2024-12-19:16:12:03-GMT-06:00 (~ 1.2 MB):
 936KiB 0:00:00 [2.84MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_3/l1_2/l2_0@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:12:05-GMT-06:00 (~ 3.1 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_0@syncoid_iox86_2024-12-19:15:41:33-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_2/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 371KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_0'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_3/l1_2/l2_0'@'syncoid_iox86_2024-12-19:16:12:05-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3198576 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2/l2_1@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:12:07-GMT-06:00 (~ 2.8 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_1@syncoid_iox86_2024-12-19:15:41:35-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 506KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_1'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_3/l1_2/l2_1'@'syncoid_iox86_2024-12-19:16:12:07-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2936064 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2/l2_2@syncoid_iox86_2024-12-19:15:56:50-GMT-06:00 ... syncoid_iox86_2024-12-19:16:12:09-GMT-06:00 (~ 738 KB):
 546KiB 0:00:00 [1.60MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_3/l1_2/l2_3@syncoid_iox86_2024-12-19:15:56:53-GMT-06:00 ... syncoid_iox86_2024-12-19:16:12:11-GMT-06:00 (~ 558 KB):
 392KiB 0:00:00 [1.16MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_3/l1_3@syncoid_iox86_2024-12-19:15:56:55-GMT-06:00 ... syncoid_iox86_2024-12-19:16:12:14-GMT-06:00 (~ 722 KB):
 547KiB 0:00:00 [1.79MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_3/l1_3/l2_0@syncoid_iox86_2024-12-19:15:56:57-GMT-06:00 ... syncoid_iox86_2024-12-19:16:12:16-GMT-06:00 (~ 706 KB):
 531KiB 0:00:00 [1.54MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_3/l1_3/l2_1@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:12:18-GMT-06:00 (~ 3.0 MB):
warning: cannot send 'send/test/l0_3/l1_3/l2_1@syncoid_iox86_2024-12-19:15:26:24-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 441KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3/l2_1'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_3/l1_3/l2_1'@'syncoid_iox86_2024-12-19:16:12:18-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3166872 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_3/l2_2@syncoid_iox86_2024-12-19:15:57:01-GMT-06:00 ... syncoid_iox86_2024-12-19:16:12:20-GMT-06:00 (~ 574 KB):
warning: cannot send 'send/test/l0_3/l1_3/l2_2@syncoid_iox86_2024-12-19:16:12:20-GMT-06:00': Invalid argument
2.13KiB 0:00:00 [21.2KiB/s] [>                                                                                                   ]  0%            
Resuming interrupted zfs send/receive from send/test/l0_3/l1_3/l2_3 to recv/test/l0_3/l1_3/l2_3 (~ 589 KB remaining):
internal error: warning: cannot send 'send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-19:15:26:29-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-118b3c37f5-118-789c636064000310a501c49c50360710a715e5e7a69766a630408145cff65f8b5a247914806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415f2219fbfbfbf12cc9c8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fac9f6308228ce28d1d8a2bf392f33353e233f32b2ccce28d0c8c4c740d8d740d2dad0c4dad8cccac8c2c75dd7d43740dccac0c0c606e0000e4702cb6 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 603472 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
real 169.32
user 16.27
sys 135.08
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
config:

        NAME                            STATE     READ WRITE CKSUM
        send                            ONLINE       0     0     0
          wwn-0x5002538d40dca5d9-part7  ONLINE       0     0     0
errors: List of errors unavailable: permission denied

errors: 60 data errors, use '-v' for a list


CRITICAL ERROR: Target recv exists but has no snapshots matching with send!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.

Sending incremental send/test@syncoid_iox86_2024-12-19:16:09:34-GMT-06:00 ... syncoid_iox86_2024-12-19:16:24:53-GMT-06:00 (~ 4 KB):
2.13KiB 0:00:00 [30.4KiB/s] [====================================================>                                               ] 53%            
Sending incremental send/test/l0_0@syncoid_iox86_2024-12-19:16:09:35-GMT-06:00 ... syncoid_iox86_2024-12-19:16:24:54-GMT-06:00 (~ 513 KB):
 405KiB 0:00:00 [2.28MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_0/l1_0@syncoid_iox86_2024-12-19:16:09:37-GMT-06:00 ... syncoid_iox86_2024-12-19:16:24:56-GMT-06:00 (~ 321 KB):
 279KiB 0:00:00 [1.24MiB/s] [=====================================================================================>              ] 86%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-19:16:09:40-GMT-06:00 ... syncoid_iox86_2024-12-19:16:24:59-GMT-06:00 (~ 842 KB):
 538KiB 0:00:00 [2.34MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-19:16:09:42-GMT-06:00 ... syncoid_iox86_2024-12-19:16:25:01-GMT-06:00 (~ 854 KB):
 670KiB 0:00:00 [2.72MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_0/l1_0/l2_2@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:25:03-GMT-06:00 (~ 3.7 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-19:15:39:11-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_0/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 336KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_2'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_0/l1_0/l2_2'@'syncoid_iox86_2024-12-19:16:25:03-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3860384 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-19:16:09:46-GMT-06:00 ... syncoid_iox86_2024-12-19:16:25:05-GMT-06:00 (~ 678 KB):
 546KiB 0:00:00 [2.22MiB/s] [===============================================================================>                    ] 80%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1 to recv/test/l0_0/l1_1 (~ 765 KB remaining):
internal error: warning: cannot send 'send/test/l0_0/l1_1@syncoid_iox86_2024-12-19:15:23:43-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-11a7fcef30-110-789c636064000310a501c49c50360710a715e5e7a69766a63040812cfbeff43ac69b310a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a857d1e9723d5bead8d4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d0cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b63231d675f70dd13530b3323000db0d00f6802ab3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 783880 |  zfs receive  -s -F 'recv/test/l0_0/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-19:16:09:49-GMT-06:00 ... syncoid_iox86_2024-12-19:16:25:08-GMT-06:00 (~ 766 KB):
 535KiB 0:00:00 [2.26MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-19:16:09:51-GMT-06:00 ... syncoid_iox86_2024-12-19:16:25:10-GMT-06:00 (~ 722 KB):
 539KiB 0:00:00 [2.31MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_0/l1_1/l2_2@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:25:12-GMT-06:00 (~ 3.5 MB):
warning: cannot send 'send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-19:15:39:20-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 325KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_2'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_0/l1_1/l2_2'@'syncoid_iox86_2024-12-19:16:25:12-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3712560 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1/l2_3 to recv/test/l0_0/l1_1/l2_3 (~ 913 KB remaining):
warning: cannot send 'send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-19:15:39:22-GMT-06:00': Input/output error
 408 B 0:00:00 [4.85KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1136c0efbd-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041d3b6c3921ba7f09d5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057d8f4bf9952bfe4dbe10424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837803fd1cc37843fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b634b2b23235d77df105d03332b0303981b0090282dd3
CRITICAL ERROR:  zfs send  -t 1-1136c0efbd-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041d3b6c3921ba7f09d5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057d8f4bf9952bfe4dbe10424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837803fd1cc37843fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b634b2b23235d77df105d03332b0303981b0090282dd3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 935800 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_2@syncoid_iox86_2024-12-19:16:09:56-GMT-06:00 ... syncoid_iox86_2024-12-19:16:25:14-GMT-06:00 (~ 822 KB):
 645KiB 0:00:00 [2.87MiB/s] [=============================================================================>                      ] 78%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_2/l2_0 to recv/test/l0_0/l1_2/l2_0 (~ 781 KB remaining):
warning: cannot send 'send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-19:15:39:26-GMT-06:00': Input/output error
 408 B 0:00:00 [3.58KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11d384ec20-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c142be63273a9bb6c62900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bd4ec24bf987ee23f998024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fa49f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656c696564a6ebee1ba26b6066656000730300ff272c45
CRITICAL ERROR:  zfs send  -t 1-11d384ec20-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c142be63273a9bb6c62900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bd4ec24bf987ee23f998024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fa49f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656c696564a6ebee1ba26b6066656000730300ff272c45 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 800448 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_2/l2_1 to recv/test/l0_0/l1_2/l2_1 (~ 677 KB remaining):
warning: cannot send 'send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-19:15:39:28-GMT-06:00': Input/output error
 408 B 0:00:00 [3.98KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-127e44ff0a-118-789c636064000310a501c49c50360710a715e5e7a69766a630408154cbf596c2961b1a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28aa97713ed98eb959f2420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61be9e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1959e8bafb86e81a98591918c0dc0000b0b52c05
CRITICAL ERROR:  zfs send  -t 1-127e44ff0a-118-789c636064000310a501c49c50360710a715e5e7a69766a630408154cbf596c2961b1a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28aa97713ed98eb959f2420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61be9e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1959e8bafb86e81a98591918c0dc0000b0b52c05 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 693768 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-19:16:09:59-GMT-06:00 ... syncoid_iox86_2024-12-19:16:25:18-GMT-06:00 (~ 573 KB):
 404KiB 0:00:00 [1.71MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-19:16:10:01-GMT-06:00 ... syncoid_iox86_2024-12-19:16:25:20-GMT-06:00 (~ 425 KB):
 269KiB 0:00:00 [1.18MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_0/l1_3@syncoid_iox86_2024-12-19:16:10:03-GMT-06:00 ... syncoid_iox86_2024-12-19:16:25:22-GMT-06:00 (~ 513 KB):
 400KiB 0:00:00 [1.87MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-19:16:10:06-GMT-06:00 ... syncoid_iox86_2024-12-19:16:25:24-GMT-06:00 (~ 453 KB):
 402KiB 0:00:00 [1.68MiB/s] [=======================================================================================>            ] 88%            
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-19:16:10:08-GMT-06:00 ... syncoid_iox86_2024-12-19:16:25:26-GMT-06:00 (~ 1.1 MB):
 898KiB 0:00:00 [3.68MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-19:16:10:10-GMT-06:00 ... syncoid_iox86_2024-12-19:16:25:29-GMT-06:00 (~ 453 KB):
 413KiB 0:00:00 [1.62MiB/s] [==========================================================================================>         ] 91%            
Sending incremental send/test/l0_0/l1_3/l2_3@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:25:31-GMT-06:00 (~ 3.8 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-19:15:39:44-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 335KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_3'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_0/l1_3/l2_3'@'syncoid_iox86_2024-12-19:16:25:31-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3979168 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1@syncoid_iox86_2024-12-19:16:10:14-GMT-06:00 ... syncoid_iox86_2024-12-19:16:25:33-GMT-06:00 (~ 497 KB):
 398KiB 0:00:00 [2.07MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_1/l1_0@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:25:34-GMT-06:00 (~ 4.0 MB):
warning: cannot send 'send/test/l0_1/l1_0@syncoid_iox86_2024-12-19:15:39:47-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_0 does not
match incremental source
64.0KiB 0:00:00 [ 355KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_1/l1_0'@'syncoid_iox86_2024-12-19:16:25:34-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4192160 |  zfs receive  -s -F 'recv/test/l0_1/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-19:16:10:19-GMT-06:00 ... syncoid_iox86_2024-12-19:16:25:37-GMT-06:00 (~ 842 KB):
 533KiB 0:00:00 [2.24MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-19:16:10:21-GMT-06:00 ... syncoid_iox86_2024-12-19:16:25:39-GMT-06:00 (~ 1.0 MB):
 800KiB 0:00:00 [3.25MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-19:16:10:23-GMT-06:00 ... syncoid_iox86_2024-12-19:16:25:41-GMT-06:00 (~ 633 KB):
 407KiB 0:00:00 [1.77MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_1/l1_0/l2_3@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:25:43-GMT-06:00 (~ 4.9 MB):
warning: cannot send 'send/test/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-19:15:24:26-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 405KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_3'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_1/l1_0/l2_3'@'syncoid_iox86_2024-12-19:16:25:43-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5157440 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1@syncoid_iox86_2024-12-19:16:10:28-GMT-06:00 ... syncoid_iox86_2024-12-19:16:25:45-GMT-06:00 (~ 381 KB):
 278KiB 0:00:00 [1.31MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-19:16:10:30-GMT-06:00 ... syncoid_iox86_2024-12-19:16:25:47-GMT-06:00 (~ 870 KB):
 671KiB 0:00:00 [2.64MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-19:16:10:32-GMT-06:00 ... syncoid_iox86_2024-12-19:16:25:50-GMT-06:00 (~ 581 KB):
 474KiB 0:00:00 [1.95MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-19:16:10:35-GMT-06:00 ... syncoid_iox86_2024-12-19:16:25:52-GMT-06:00 (~ 581 KB):
 475KiB 0:00:00 [1.95MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-19:16:10:37-GMT-06:00 ... syncoid_iox86_2024-12-19:16:25:54-GMT-06:00 (~ 601 KB):
warning: cannot send 'send/test/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-19:16:25:54-GMT-06:00': Input/output error
1.83KiB 0:00:00 [21.8KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11c3a6aed0-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1bedd5d59377b023f2900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bae1e8b14e34b5c362f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc7104418c51b3b1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5919995a999ae8bafb86e81a98591918c0dc0000cbf32d4c
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_3'@'syncoid_iox86_2024-12-19:16:10:37-GMT-06:00' 'send/test/l0_1/l1_1/l2_3'@'syncoid_iox86_2024-12-19:16:25:54-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 616384 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2@autosnap_2024-12-19_22:00:37_frequently ... syncoid_iox86_2024-12-19:16:25:56-GMT-06:00 (~ 1.7 MB):
warning: cannot send 'send/test/l0_1/l1_2@syncoid_iox86_2024-12-19:16:10:39-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_2 does not
match incremental source
64.0KiB 0:00:00 [ 402KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2'@'autosnap_2024-12-19_22:00:37_frequently' 'send/test/l0_1/l1_2'@'syncoid_iox86_2024-12-19:16:25:56-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1814696 |  zfs receive  -s -F 'recv/test/l0_1/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:25:58-GMT-06:00 (~ 3.9 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:24:41-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:40:11-GMT-06:00': Invalid argument
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 408KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_1/l1_2/l2_0'@'syncoid_iox86_2024-12-19:16:25:58-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4111856 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-19:15:55:27-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:00-GMT-06:00 (~ 1.5 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_1@autosnap_2024-12-19_22:00:37_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 501KiB/s] [===>                                                                                                ]  4%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-19:15:55:27-GMT-06:00' 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-19:16:26:00-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1594208 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_2/l2_2 to recv/test/l0_1/l1_2/l2_2 (~ 441 KB remaining):
internal error: warning: cannot send 'send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-19:15:24:46-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-10c0c26d5d-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c119ee6bd985a9cf1415806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415c2fbb6ac5820c35a9e8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa89f63186fa49f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a6564626562a6ebee1ba26b6066656000730300a3612bd3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 451736 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-19:16:10:46-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:03-GMT-06:00 (~ 453 KB):
 405KiB 0:00:00 [1.70MiB/s] [========================================================================================>           ] 89%            
Sending incremental send/test/l0_1/l1_3@autosnap_2024-12-19_22:00:37_frequently ... syncoid_iox86_2024-12-19:16:26:05-GMT-06:00 (~ 2.3 MB):
warning: cannot send 'send/test/l0_1/l1_3@syncoid_iox86_2024-12-19:16:10:48-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_3 does not
match incremental source
64.0KiB 0:00:00 [ 400KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_3'@'autosnap_2024-12-19_22:00:37_frequently' 'send/test/l0_1/l1_3'@'syncoid_iox86_2024-12-19:16:26:05-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2413632 |  zfs receive  -s -F 'recv/test/l0_1/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_3/l2_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:26:07-GMT-06:00 (~ 4.8 MB):
warning: cannot send 'send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-19:15:24:52-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-19:16:10:50-GMT-06:00': Invalid argument
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 313KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_3/l2_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_1/l1_3/l2_0'@'syncoid_iox86_2024-12-19:16:26:07-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4993600 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-19:16:10:52-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:09-GMT-06:00 (~ 573 KB):
 414KiB 0:00:00 [1.69MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-19:16:10:55-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:11-GMT-06:00 (~ 706 KB):
 534KiB 0:00:00 [2.13MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-19:16:10:57-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:13-GMT-06:00 (~ 529 KB):
 413KiB 0:00:00 [1.71MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_2@syncoid_iox86_2024-12-19:16:10:59-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:15-GMT-06:00 (~ 798 KB):
 545KiB 0:00:00 [2.68MiB/s] [===================================================================>                                ] 68%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_0 to recv/test/l0_2/l1_0 (~ 172 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_0@syncoid_iox86_2024-12-19:15:25:02-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-13c9ed8a18-110-789c636064000310a501c49c50360710a715e5e7a69766a6304041f15cde74936d7c350a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a904dbc359336a67d8c4092e704cbe725e6a602dd979a97a20f34aa443fc720de483fc730dec0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cac048d7dd3744d7c0cccac0006c3700a3a12a2c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 176936 |  zfs receive  -s -F 'recv/test/l0_2/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-19:16:11:02-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:17-GMT-06:00 (~ 513 KB):
 406KiB 0:00:00 [1.64MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-19:16:11:04-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:20-GMT-06:00 (~ 662 KB):
 543KiB 0:00:00 [2.20MiB/s] [=================================================================================>                  ] 82%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_0/l2_2 to recv/test/l0_2/l1_0/l2_2 (~ 585 KB remaining):
warning: cannot send 'send/test/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-19:15:25:09-GMT-06:00': Input/output error
5.22KiB 0:00:00 [44.9KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11afa6c057-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c187d56e616f8fb13c5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057b84d89e20ee3377c9d8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa09f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6560a9ebee1ba26b606665600073030027ef2c0c
CRITICAL ERROR:  zfs send  -t 1-11afa6c057-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c187d56e616f8fb13c5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057b84d89e20ee3377c9d8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa09f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6560a9ebee1ba26b606665600073030027ef2c0c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 599376 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-19:16:11:08-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:23-GMT-06:00 (~ 497 KB):
 400KiB 0:00:00 [1.66MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_2/l1_1@syncoid_iox86_2024-12-19:16:11:10-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:25-GMT-06:00 (~ 794 KB):
 669KiB 0:00:00 [2.92MiB/s] [===================================================================================>                ] 84%            
Sending incremental send/test/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-19:16:11:13-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:27-GMT-06:00 (~ 381 KB):
 276KiB 0:00:00 [1.14MiB/s] [=======================================================================>                            ] 72%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_1/l2_1 to recv/test/l0_2/l1_1/l2_1 (~ 721 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-19:15:25:18-GMT-06:00': Invalid argument
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-ff823389f-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1222bc149011dceef15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4151f5e86aa54575f399a8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa89f63146fe8505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6568a1ebee1ba26b6066656000730300d8b82ce2 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 738824 |  zfs receive  -s -F 'recv/test/l0_2/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-19:16:11:16-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:29-GMT-06:00 (~ 1.1 MB):
 798KiB 0:00:00 [3.15MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-19:16:11:18-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:32-GMT-06:00 (~ 706 KB):
 535KiB 0:00:00 [2.22MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_2/l1_2@syncoid_iox86_2024-12-19:16:11:20-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:34-GMT-06:00 (~ 646 KB):
 538KiB 0:00:00 [2.40MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/l0_2/l1_2/l2_0@syncoid_iox86_2024-12-19:16:11:22-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:36-GMT-06:00 (~ 441 KB):
 281KiB 0:00:00 [1.20MiB/s] [==============================================================>                                     ] 63%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_2/l2_1 to recv/test/l0_2/l1_2/l2_1 (~ 721 KB remaining):
warning: cannot send 'send/test/l0_2/l1_2/l2_1@syncoid_iox86_2024-12-19:16:11:25-GMT-06:00': Input/output error
 408 B 0:00:00 [3.21KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1401815849-118-789c636064000310a501c49c50360710a715e5e7a69766a630408169bb71866b7259970290cd8ea42e3f292b35b904c207010cf9b4b4e2d412063800c9b321c9275596a41633a0ca23eb2fc987b8a2bfb4f74661828a6502923c27583e2f31379581a138352f451f6854897e8e41bc917e8e2188308a377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b43232d575f70dd13530b3323080b90100d6e62b09
CRITICAL ERROR:  zfs send  -t 1-1401815849-118-789c636064000310a501c49c50360710a715e5e7a69766a630408169bb71866b7259970290cd8ea42e3f292b35b904c207010cf9b4b4e2d412063800c9b321c9275596a41633a0ca23eb2fc987b8a2bfb4f74661828a6502923c27583e2f31379581a138352f451f6854897e8e41bc917e8e2188308a377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b43232d575f70dd13530b3323080b90100d6e62b09 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 738824 |  zfs receive  -s -F 'recv/test/l0_2/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_2/l2_2@syncoid_iox86_2024-12-19:16:11:27-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:39-GMT-06:00 (~ 970 KB):
 777KiB 0:00:00 [3.13MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_2/l1_2/l2_3@syncoid_iox86_2024-12-19:16:11:29-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:41-GMT-06:00 (~ 974 KB):
 669KiB 0:00:00 [2.77MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_2/l1_3@syncoid_iox86_2024-12-19:16:11:31-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:43-GMT-06:00 (~ 365 KB):
 269KiB 0:00:00 [1.26MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_2/l1_3/l2_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:26:45-GMT-06:00 (~ 4.9 MB):
warning: cannot send 'send/test/l0_2/l1_3/l2_0@syncoid_iox86_2024-12-19:15:25:37-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 420KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_2/l1_3/l2_0'@'syncoid_iox86_2024-12-19:16:26:45-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5108472 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_1 to recv/test/l0_2/l1_3/l2_1 (~ 557 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-19:15:25:39-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-14c7859310-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1459fa97f6772eabe5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057a42cf1b39e5e29783601499e132c9f97989bcac0509c9a97a20f34aa443fc720de483fc730de583fc728ded0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cad852d7dd3744d7c0cccac000e6060018eb2c68 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 570704 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_3/l2_2@syncoid_iox86_2024-12-19:16:11:36-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:48-GMT-06:00 (~ 453 KB):
 411KiB 0:00:00 [1.62MiB/s] [=========================================================================================>          ] 90%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_3 to recv/test/l0_2/l1_3/l2_3 (~ 629 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-19:15:25:44-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-14bb428d41-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c193fcf2ca3fbbf6592900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b6a5e1844ad2cbeb03f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de483fc730de583fc728ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cac444d7dd3744d7c0cccac000e6060004302e05 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 644432 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:26:50-GMT-06:00 (~ 4.0 MB):
warning: cannot send 'send/test/l0_3@syncoid_iox86_2024-12-19:15:25:45-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 491KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_3'@'syncoid_iox86_2024-12-19:16:26:50-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4222448 |  zfs receive  -s -F 'recv/test/l0_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:26:52-GMT-06:00 (~ 6.4 MB):
warning: cannot send 'send/test/l0_3/l1_0@syncoid_iox86_2024-12-19:15:25:47-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 445KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_3/l1_0'@'syncoid_iox86_2024-12-19:16:26:52-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 6675168 |  zfs receive  -s -F 'recv/test/l0_3/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_0/l2_0@syncoid_iox86_2024-12-19:16:11:42-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:54-GMT-06:00 (~ 974 KB):
 670KiB 0:00:00 [2.80MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_3/l1_0/l2_1@syncoid_iox86_2024-12-19:16:11:45-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:56-GMT-06:00 (~ 722 KB):
 537KiB 0:00:00 [2.19MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_3/l1_0/l2_2@syncoid_iox86_2024-12-19:16:11:47-GMT-06:00 ... syncoid_iox86_2024-12-19:16:26:58-GMT-06:00 (~ 381 KB):
 279KiB 0:00:00 [1.19MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_3/l1_0/l2_3@syncoid_iox86_2024-12-19:16:11:49-GMT-06:00 ... syncoid_iox86_2024-12-19:16:27:00-GMT-06:00 (~ 589 KB):
 414KiB 0:00:00 [1.71MiB/s] [=====================================================================>                              ] 70%            
Resuming interrupted zfs send/receive from send/test/l0_3/l1_1 to recv/test/l0_3/l1_1 (~ 877 KB remaining):
warning: cannot send 'send/test/l0_3/l1_1@syncoid_iox86_2024-12-19:15:41:19-GMT-06:00': Input/output error
9.12KiB 0:00:00 [80.7KiB/s] [>                                                                                                   ]  1%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-125df0eeb4-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1a76f724ab5d752d314806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415abb53e8b33be29ef894092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d6cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53231b432b4d475f70dd13530b3323000db0d00ab4b2b28
CRITICAL ERROR:  zfs send  -t 1-125df0eeb4-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1a76f724ab5d752d314806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415abb53e8b33be29ef894092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d6cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53231b432b4d475f70dd13530b3323000db0d00ab4b2b28 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 898752 |  zfs receive  -s -F 'recv/test/l0_3/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_1/l2_0@syncoid_iox86_2024-12-19:16:11:54-GMT-06:00 ... syncoid_iox86_2024-12-19:16:27:03-GMT-06:00 (~ 589 KB):
 409KiB 0:00:00 [1.71MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_3/l1_1/l2_1@syncoid_iox86_2024-12-19:16:11:56-GMT-06:00 ... syncoid_iox86_2024-12-19:16:27:05-GMT-06:00 (~ 914 KB):
 670KiB 0:00:00 [2.66MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_3/l1_1/l2_2@syncoid_iox86_2024-12-19:16:11:58-GMT-06:00 ... syncoid_iox86_2024-12-19:16:27:08-GMT-06:00 (~ 722 KB):
 544KiB 0:00:00 [2.31MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_3/l1_1/l2_3@syncoid_iox86_2024-12-19:16:12:01-GMT-06:00 ... syncoid_iox86_2024-12-19:16:27:10-GMT-06:00 (~ 854 KB):
 671KiB 0:00:00 [2.63MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_3/l1_2@syncoid_iox86_2024-12-19:16:12:03-GMT-06:00 ... syncoid_iox86_2024-12-19:16:27:12-GMT-06:00 (~ 513 KB):
 403KiB 0:00:00 [1.73MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_3/l1_2/l2_0@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:27:14-GMT-06:00 (~ 3.9 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_0@syncoid_iox86_2024-12-19:15:41:33-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_2/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 317KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_0'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_3/l1_2/l2_0'@'syncoid_iox86_2024-12-19:16:27:14-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4106144 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2/l2_1@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:27:16-GMT-06:00 (~ 3.5 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_1@syncoid_iox86_2024-12-19:15:41:35-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 477KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_1'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_3/l1_2/l2_1'@'syncoid_iox86_2024-12-19:16:27:16-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3720568 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2/l2_2@syncoid_iox86_2024-12-19:16:12:09-GMT-06:00 ... syncoid_iox86_2024-12-19:16:27:19-GMT-06:00 (~ 794 KB):
 664KiB 0:00:00 [2.64MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/l0_3/l1_2/l2_3@syncoid_iox86_2024-12-19:16:12:11-GMT-06:00 ... syncoid_iox86_2024-12-19:16:27:21-GMT-06:00 (~ 806 KB):
 641KiB 0:00:00 [2.67MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_3/l1_3@syncoid_iox86_2024-12-19:16:12:14-GMT-06:00 ... syncoid_iox86_2024-12-19:16:27:23-GMT-06:00 (~ 573 KB):
 407KiB 0:00:00 [1.83MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_3/l1_3/l2_0@syncoid_iox86_2024-12-19:16:12:16-GMT-06:00 ... syncoid_iox86_2024-12-19:16:27:25-GMT-06:00 (~ 513 KB):
 407KiB 0:00:00 [1.69MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_3/l1_3/l2_1@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:27:27-GMT-06:00 (~ 4.1 MB):
warning: cannot send 'send/test/l0_3/l1_3/l2_1@syncoid_iox86_2024-12-19:15:26:24-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 423KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3/l2_1'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_3/l1_3/l2_1'@'syncoid_iox86_2024-12-19:16:27:27-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4255032 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_3/l2_2@autosnap_2024-12-19_22:00:37_frequently ... syncoid_iox86_2024-12-19:16:27:30-GMT-06:00 (~ 1.4 MB):
warning: cannot send 'send/test/l0_3/l1_3/l2_2@syncoid_iox86_2024-12-19:16:12:20-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_3/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 376KiB/s] [===>                                                                                                ]  4%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3/l2_2'@'autosnap_2024-12-19_22:00:37_frequently' 'send/test/l0_3/l1_3/l2_2'@'syncoid_iox86_2024-12-19:16:27:30-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1461888 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_3/l2_3 to recv/test/l0_3/l1_3/l2_3 (~ 589 KB remaining):
internal error: warning: cannot send 'send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-19:15:26:29-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-118b3c37f5-118-789c636064000310a501c49c50360710a715e5e7a69766a630408145cff65f8b5a247914806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415f2219fbfbfbf12cc9c8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fac9f6308228ce28d1d8a2bf392f33353e233f32b2ccce28d0c8c4c740d8d740d2dad0c4dad8cccac8c2c75dd7d43740dccac0c0c606e0000e4702cb6 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 603472 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
real 158.98
user 15.76
sys 129.62
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
config:

        NAME                            STATE     READ WRITE CKSUM
        send                            ONLINE       0     0     0
          wwn-0x5002538d40dca5d9-part7  ONLINE       0     0     0
errors: List of errors unavailable: permission denied

errors: 63 data errors, use '-v' for a list


CRITICAL ERROR: Target recv exists but has no snapshots matching with send!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.

Sending incremental send/test@syncoid_iox86_2024-12-19:16:24:53-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:02-GMT-06:00 (~ 4 KB):
2.13KiB 0:00:00 [29.4KiB/s] [====================================================>                                               ] 53%            
Sending incremental send/test/l0_0@syncoid_iox86_2024-12-19:16:24:54-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:03-GMT-06:00 (~ 573 KB):
 408KiB 0:00:00 [2.30MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_0/l1_0@syncoid_iox86_2024-12-19:16:24:56-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:05-GMT-06:00 (~ 722 KB):
 545KiB 0:00:00 [2.41MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-19:16:24:59-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:08-GMT-06:00 (~ 974 KB):
 672KiB 0:00:00 [2.82MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-19:16:25:01-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:10-GMT-06:00 (~ 646 KB):
 536KiB 0:00:00 [2.16MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_0/l1_0/l2_2@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:40:12-GMT-06:00 (~ 4.7 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-19:15:39:11-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_0/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 343KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_2'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_0/l1_0/l2_2'@'syncoid_iox86_2024-12-19:16:40:12-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4948544 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-19:16:25:05-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:14-GMT-06:00 (~ 513 KB):
 398KiB 0:00:00 [1.71MiB/s] [============================================================================>                       ] 77%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1 to recv/test/l0_0/l1_1 (~ 765 KB remaining):
internal error: warning: cannot send 'send/test/l0_0/l1_1@syncoid_iox86_2024-12-19:15:23:43-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-11a7fcef30-110-789c636064000310a501c49c50360710a715e5e7a69766a63040812cfbeff43ac69b310a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a857d1e9723d5bead8d4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d0cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b63231d675f70dd13530b3323000db0d00f6802ab3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 783880 |  zfs receive  -s -F 'recv/test/l0_0/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-19:16:25:08-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:17-GMT-06:00 (~ 453 KB):
 408KiB 0:00:00 [1.62MiB/s] [=========================================================================================>          ] 90%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-19:16:25:10-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:19-GMT-06:00 (~ 513 KB):
 403KiB 0:00:00 [1.71MiB/s] [=============================================================================>                      ] 78%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1/l2_2 to recv/test/l0_0/l1_1/l2_2 (~ 841 KB remaining):
warning: cannot send 'send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-19:15:39:20-GMT-06:00': Input/output error
 408 B 0:00:00 [3.12KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-129b2dd437-118-789c636064000310a501c49c50360710a715e5e7a69766a63040013b8b465497715aa802888da42e3f292b35b904c207010cf9b4b4e2d412063800c9b321c9275596a41633a0ca23eb2fc987b8e2faa903a25b34df182420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61beae718c51b391457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1919e8bafb86e81a98591918c0dc00004b072ae9
CRITICAL ERROR:  zfs send  -t 1-129b2dd437-118-789c636064000310a501c49c50360710a715e5e7a69766a63040013b8b465497715aa802888da42e3f292b35b904c207010cf9b4b4e2d412063800c9b321c9275596a41633a0ca23eb2fc987b8e2faa903a25b34df182420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61beae718c51b391457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1919e8bafb86e81a98591918c0dc00004b072ae9 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 861888 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1/l2_3 to recv/test/l0_0/l1_1/l2_3 (~ 913 KB remaining):
warning: cannot send 'send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-19:15:39:22-GMT-06:00': Input/output error
 408 B 0:00:00 [4.56KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1136c0efbd-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041d3b6c3921ba7f09d5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057d8f4bf9952bfe4dbe10424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837803fd1cc37843fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b634b2b23235d77df105d03332b0303981b0090282dd3
CRITICAL ERROR:  zfs send  -t 1-1136c0efbd-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041d3b6c3921ba7f09d5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057d8f4bf9952bfe4dbe10424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837803fd1cc37843fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b634b2b23235d77df105d03332b0303981b0090282dd3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 935800 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_2@syncoid_iox86_2024-12-19:16:25:14-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:22-GMT-06:00 (~ 662 KB):
 545KiB 0:00:00 [2.40MiB/s] [=================================================================================>                  ] 82%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_2/l2_0 to recv/test/l0_0/l1_2/l2_0 (~ 781 KB remaining):
warning: cannot send 'send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-19:15:39:26-GMT-06:00': Input/output error
 408 B 0:00:00 [3.60KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11d384ec20-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c142be63273a9bb6c62900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bd4ec24bf987ee23f998024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fa49f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656c696564a6ebee1ba26b6066656000730300ff272c45
CRITICAL ERROR:  zfs send  -t 1-11d384ec20-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c142be63273a9bb6c62900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bd4ec24bf987ee23f998024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fa49f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656c696564a6ebee1ba26b6066656000730300ff272c45 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 800448 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_2/l2_1 to recv/test/l0_0/l1_2/l2_1 (~ 677 KB remaining):
warning: cannot send 'send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-19:15:39:28-GMT-06:00': Input/output error
 408 B 0:00:00 [3.99KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-127e44ff0a-118-789c636064000310a501c49c50360710a715e5e7a69766a630408154cbf596c2961b1a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28aa97713ed98eb959f2420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61be9e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1959e8bafb86e81a98591918c0dc0000b0b52c05
CRITICAL ERROR:  zfs send  -t 1-127e44ff0a-118-789c636064000310a501c49c50360710a715e5e7a69766a630408154cbf596c2961b1a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28aa97713ed98eb959f2420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61be9e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1959e8bafb86e81a98591918c0dc0000b0b52c05 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 693768 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-19:16:25:18-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:25-GMT-06:00 (~ 858 KB):
 547KiB 0:00:00 [2.33MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-19:16:25:20-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:27-GMT-06:00 (~ 722 KB):
 543KiB 0:00:00 [2.18MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_3@syncoid_iox86_2024-12-19:16:25:22-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:30-GMT-06:00 (~ 722 KB):
 544KiB 0:00:00 [2.45MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-19:16:25:24-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:32-GMT-06:00 (~ 646 KB):
 530KiB 0:00:00 [2.11MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-19:16:25:26-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:34-GMT-06:00 (~ 1.1 MB):
 800KiB 0:00:00 [3.32MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-19:16:25:29-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:36-GMT-06:00 (~ 441 KB):
 274KiB 0:00:00 [1.16MiB/s] [=============================================================>                                      ] 62%            
Sending incremental send/test/l0_0/l1_3/l2_3@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:40:39-GMT-06:00 (~ 4.4 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-19:15:39:44-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 319KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_3'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_0/l1_3/l2_3'@'syncoid_iox86_2024-12-19:16:40:39-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4657176 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1@syncoid_iox86_2024-12-19:16:25:33-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:40-GMT-06:00 (~ 381 KB):
 278KiB 0:00:00 [1.45MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_1/l1_0@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:40:42-GMT-06:00 (~ 4.6 MB):
warning: cannot send 'send/test/l0_1/l1_0@syncoid_iox86_2024-12-19:15:39:47-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_0 does not
match incremental source
64.0KiB 0:00:00 [ 365KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_1/l1_0'@'syncoid_iox86_2024-12-19:16:40:42-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4837216 |  zfs receive  -s -F 'recv/test/l0_1/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-19:16:25:37-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:44-GMT-06:00 (~ 1.0 MB):
 799KiB 0:00:00 [3.20MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-19:16:25:39-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:47-GMT-06:00 (~ 870 KB):
 674KiB 0:00:00 [2.75MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-19:16:25:41-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:49-GMT-06:00 (~ 782 KB):
 541KiB 0:00:00 [2.27MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_1/l1_0/l2_3@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:40:51-GMT-06:00 (~ 5.4 MB):
warning: cannot send 'send/test/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-19:15:24:26-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 372KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_3'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_1/l1_0/l2_3'@'syncoid_iox86_2024-12-19:16:40:51-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5700096 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1@syncoid_iox86_2024-12-19:16:25:45-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:53-GMT-06:00 (~ 958 KB):
 808KiB 0:00:00 [3.49MiB/s] [===================================================================================>                ] 84%            
Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-19:16:25:47-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:55-GMT-06:00 (~ 381 KB):
warning: cannot send 'send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-19:16:40:55-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [17.6KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-19:16:25:50-GMT-06:00 ... syncoid_iox86_2024-12-19:16:40:58-GMT-06:00 (~ 782 KB):
 534KiB 0:00:00 [2.26MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-19:16:25:52-GMT-06:00 ... syncoid_iox86_2024-12-19:16:41:00-GMT-06:00 (~ 766 KB):
 532KiB 0:00:00 [2.22MiB/s] [====================================================================>                               ] 69%            
Resuming interrupted zfs send/receive from send/test/l0_1/l1_1/l2_3 to recv/test/l0_1/l1_1/l2_3 (~ 601 KB remaining):
warning: cannot send 'send/test/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-19:16:25:54-GMT-06:00': Input/output error
 408 B 0:00:00 [5.06KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11c3a6aed0-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1bedd5d59377b023f2900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bae1e8b14e34b5c362f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc7104418c51b3b1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5919995a999ae8bafb86e81a98591918c0dc0000cbf32d4c
CRITICAL ERROR:  zfs send  -t 1-11c3a6aed0-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1bedd5d59377b023f2900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bae1e8b14e34b5c362f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc7104418c51b3b1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5919995a999ae8bafb86e81a98591918c0dc0000cbf32d4c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 615760 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_2@autosnap_2024-12-19_22:00:37_frequently ... syncoid_iox86_2024-12-19:16:41:02-GMT-06:00 (~ 2.7 MB):
warning: cannot send 'send/test/l0_1/l1_2@syncoid_iox86_2024-12-19:16:10:39-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
72.0KiB 0:00:00 [ 391KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x22000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2'@'autosnap_2024-12-19_22:00:37_frequently' 'send/test/l0_1/l1_2'@'syncoid_iox86_2024-12-19:16:41:02-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2779792 |  zfs receive  -s -F 'recv/test/l0_1/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:41:04-GMT-06:00 (~ 4.6 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:24:41-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:40:11-GMT-06:00': Invalid argument
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 379KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_1/l1_2/l2_0'@'syncoid_iox86_2024-12-19:16:41:04-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4834920 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-19:15:55:27-GMT-06:00 ... syncoid_iox86_2024-12-19:16:41:06-GMT-06:00 (~ 2.1 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_1@autosnap_2024-12-19_22:00:37_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 494KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-19:15:55:27-GMT-06:00' 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-19:16:41:06-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2226976 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_2/l2_2 to recv/test/l0_1/l1_2/l2_2 (~ 441 KB remaining):
internal error: warning: cannot send 'send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-19:15:24:46-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-10c0c26d5d-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c119ee6bd985a9cf1415806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415c2fbb6ac5820c35a9e8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa89f63186fa49f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a6564626562a6ebee1ba26b6066656000730300a3612bd3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 451736 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-19:16:26:03-GMT-06:00 ... syncoid_iox86_2024-12-19:16:41:09-GMT-06:00 (~ 513 KB):
 405KiB 0:00:00 [1.62MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_1/l1_3@autosnap_2024-12-19_22:00:37_frequently ... syncoid_iox86_2024-12-19:16:41:11-GMT-06:00 (~ 3.1 MB):
warning: cannot send 'send/test/l0_1/l1_3@syncoid_iox86_2024-12-19:16:10:48-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 350KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_3'@'autosnap_2024-12-19_22:00:37_frequently' 'send/test/l0_1/l1_3'@'syncoid_iox86_2024-12-19:16:41:11-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3292528 |  zfs receive  -s -F 'recv/test/l0_1/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_3/l2_0 to recv/test/l0_1/l1_3/l2_0 (~ 913 KB remaining):
warning: cannot send 'send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-19:15:24:52-GMT-06:00': Input/output error
1.01KiB 0:00:00 [10.0KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-14f1ada464-118-789c636064000310a501c49c50360710a715e5e7a69766a63040418addc3edb7bfcc105400b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f910579857b1fed8fe8dd33b01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730de583fc728dec0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8c4cad448d7dd3744d7c0cccac000e606006a502cd6
CRITICAL ERROR:  zfs send  -t 1-14f1ada464-118-789c636064000310a501c49c50360710a715e5e7a69766a63040418addc3edb7bfcc105400b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f910579857b1fed8fe8dd33b01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730de583fc728dec0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8c4cad448d7dd3744d7c0cccac000e606006a502cd6 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 935800 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-19:16:26:09-GMT-06:00 ... syncoid_iox86_2024-12-19:16:41:13-GMT-06:00 (~ 706 KB):
 530KiB 0:00:00 [2.16MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-19:16:26:11-GMT-06:00 ... syncoid_iox86_2024-12-19:16:41:16-GMT-06:00 (~ 782 KB):
 540KiB 0:00:00 [2.29MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-19:16:26:13-GMT-06:00 ... syncoid_iox86_2024-12-19:16:41:18-GMT-06:00 (~ 854 KB):
 668KiB 0:00:00 [2.73MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_2@syncoid_iox86_2024-12-19:16:26:15-GMT-06:00 ... syncoid_iox86_2024-12-19:16:41:20-GMT-06:00 (~ 529 KB):
 413KiB 0:00:00 [2.01MiB/s] [=============================================================================>                      ] 78%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_0 to recv/test/l0_2/l1_0 (~ 172 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_0@syncoid_iox86_2024-12-19:15:25:02-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-13c9ed8a18-110-789c636064000310a501c49c50360710a715e5e7a69766a6304041f15cde74936d7c350a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a904dbc359336a67d8c4092e704cbe725e6a602dd979a97a20f34aa443fc720de483fc730dec0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cac048d7dd3744d7c0cccac0006c3700a3a12a2c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 176936 |  zfs receive  -s -F 'recv/test/l0_2/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-19:16:26:17-GMT-06:00 ... syncoid_iox86_2024-12-19:16:41:22-GMT-06:00 (~ 914 KB):
 673KiB 0:00:00 [2.71MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-19:16:26:20-GMT-06:00 ... syncoid_iox86_2024-12-19:16:41:25-GMT-06:00 (~ 1.0 MB):
warning: cannot send 'send/test/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-19:16:41:25-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [17.2KiB/s] [>                                                                                                   ]  0%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_0/l2_2 to recv/test/l0_2/l1_0/l2_2 (~ 585 KB remaining):
warning: cannot send 'send/test/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-19:15:25:09-GMT-06:00': Input/output error
6.00KiB 0:00:00 [49.8KiB/s] [>                                                                                                   ]  1%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11afa6c057-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c187d56e616f8fb13c5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057b84d89e20ee3377c9d8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa09f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6560a9ebee1ba26b606665600073030027ef2c0c
CRITICAL ERROR:  zfs send  -t 1-11afa6c057-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c187d56e616f8fb13c5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057b84d89e20ee3377c9d8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa09f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6560a9ebee1ba26b606665600073030027ef2c0c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 599376 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-19:16:26:23-GMT-06:00 ... syncoid_iox86_2024-12-19:16:41:27-GMT-06:00 (~ 882 KB):
 640KiB 0:00:00 [2.63MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_2/l1_1@syncoid_iox86_2024-12-19:16:26:25-GMT-06:00 ... syncoid_iox86_2024-12-19:16:41:29-GMT-06:00 (~ 838 KB):
 661KiB 0:00:00 [2.94MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-19:16:26:27-GMT-06:00 ... syncoid_iox86_2024-12-19:16:41:32-GMT-06:00 (~ 1.2 MB):
 905KiB 0:00:00 [3.61MiB/s] [=========================================================================>                          ] 74%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_1/l2_1 to recv/test/l0_2/l1_1/l2_1 (~ 721 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-19:15:25:18-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-ff823389f-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1222bc149011dceef15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4151f5e86aa54575f399a8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa89f63146fe8505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6568a1ebee1ba26b6066656000730300d8b82ce2 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 738824 |  zfs receive  -s -F 'recv/test/l0_2/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-19:16:26:29-GMT-06:00 ... syncoid_iox86_2024-12-19:16:41:34-GMT-06:00 (~ 633 KB):
 407KiB 0:00:00 [1.78MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-19:16:26:32-GMT-06:00 ... syncoid_iox86_2024-12-19:16:41:36-GMT-06:00 (~ 798 KB):
 549KiB 0:00:00 [2.32MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_2/l1_2@syncoid_iox86_2024-12-19:16:26:34-GMT-06:00 ... syncoid_iox86_2024-12-19:16:41:39-GMT-06:00 (~ 573 KB):
warning: cannot send 'send/test/l0_2/l1_2@syncoid_iox86_2024-12-19:16:41:39-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [18.0KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_2/l1_2/l2_0@syncoid_iox86_2024-12-19:16:26:36-GMT-06:00 ... syncoid_iox86_2024-12-19:16:41:41-GMT-06:00 (~ 914 KB):
 668KiB 0:00:00 [2.75MiB/s] [========================================================================>                           ] 73%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_2/l2_1 to recv/test/l0_2/l1_2/l2_1 (~ 721 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_2/l2_1@syncoid_iox86_2024-12-19:16:11:25-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-1401815849-118-789c636064000310a501c49c50360710a715e5e7a69766a630408169bb71866b7259970290cd8ea42e3f292b35b904c207010cf9b4b4e2d412063800c9b321c9275596a41633a0ca23eb2fc987b8a2bfb4f74661828a6502923c27583e2f31379581a138352f451f6854897e8e41bc917e8e2188308a377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b43232d575f70dd13530b3323080b90100d6e62b09 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 738824 |  zfs receive  -s -F 'recv/test/l0_2/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_2/l2_2@syncoid_iox86_2024-12-19:16:26:39-GMT-06:00 ... syncoid_iox86_2024-12-19:16:41:43-GMT-06:00 (~ 573 KB):
 410KiB 0:00:00 [1.75MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_2/l1_2/l2_3@syncoid_iox86_2024-12-19:16:26:41-GMT-06:00 ... syncoid_iox86_2024-12-19:16:41:46-GMT-06:00 (~ 529 KB):
 412KiB 0:00:00 [1.69MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_2/l1_3@syncoid_iox86_2024-12-19:16:26:43-GMT-06:00 ... syncoid_iox86_2024-12-19:16:41:48-GMT-06:00 (~ 573 KB):
 407KiB 0:00:00 [1.91MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_2/l1_3/l2_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:41:50-GMT-06:00 (~ 5.4 MB):
warning: cannot send 'send/test/l0_2/l1_3/l2_0@syncoid_iox86_2024-12-19:15:25:37-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
68.0KiB 0:00:00 [ 292KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x21000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_2/l1_3/l2_0'@'syncoid_iox86_2024-12-19:16:41:50-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5712568 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_1 to recv/test/l0_2/l1_3/l2_1 (~ 557 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-19:15:25:39-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-14c7859310-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1459fa97f6772eabe5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057a42cf1b39e5e29783601499e132c9f97989bcac0509c9a97a20f34aa443fc720de483fc730de583fc728ded0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cad852d7dd3744d7c0cccac000e6060018eb2c68 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 570704 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_3/l2_2@syncoid_iox86_2024-12-19:16:26:48-GMT-06:00 ... syncoid_iox86_2024-12-19:16:41:53-GMT-06:00 (~ 529 KB):
 410KiB 0:00:00 [1.67MiB/s] [============================================================================>                       ] 77%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_3 to recv/test/l0_2/l1_3/l2_3 (~ 629 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-19:15:25:44-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-14bb428d41-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c193fcf2ca3fbbf6592900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b6a5e1844ad2cbeb03f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de483fc730de583fc728ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cac444d7dd3744d7c0cccac000e6060004302e05 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 644432 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:41:55-GMT-06:00 (~ 4.3 MB):
warning: cannot send 'send/test/l0_3@syncoid_iox86_2024-12-19:15:25:45-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 470KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_3'@'syncoid_iox86_2024-12-19:16:41:55-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4461448 |  zfs receive  -s -F 'recv/test/l0_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:41:56-GMT-06:00 (~ 6.8 MB):
warning: cannot send 'send/test/l0_3/l1_0@syncoid_iox86_2024-12-19:15:25:47-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 313KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_3/l1_0'@'syncoid_iox86_2024-12-19:16:41:56-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 7139816 |  zfs receive  -s -F 'recv/test/l0_3/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_0/l2_0@syncoid_iox86_2024-12-19:16:26:54-GMT-06:00 ... syncoid_iox86_2024-12-19:16:41:59-GMT-06:00 (~ 549 KB):
 448KiB 0:00:00 [1.85MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_3/l1_0/l2_1@syncoid_iox86_2024-12-19:16:26:56-GMT-06:00 ... syncoid_iox86_2024-12-19:16:42:01-GMT-06:00 (~ 990 KB):
 677KiB 0:00:00 [2.77MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_3/l1_0/l2_2@syncoid_iox86_2024-12-19:16:26:58-GMT-06:00 ... syncoid_iox86_2024-12-19:16:42:03-GMT-06:00 (~ 766 KB):
 530KiB 0:00:00 [2.28MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_3/l1_0/l2_3@syncoid_iox86_2024-12-19:16:27:00-GMT-06:00 ... syncoid_iox86_2024-12-19:16:42:05-GMT-06:00 (~ 766 KB):
 535KiB 0:00:00 [2.21MiB/s] [====================================================================>                               ] 69%            
Resuming interrupted zfs send/receive from send/test/l0_3/l1_1 to recv/test/l0_3/l1_1 (~ 877 KB remaining):
warning: cannot send 'send/test/l0_3/l1_1@syncoid_iox86_2024-12-19:15:41:19-GMT-06:00': Input/output error
9.12KiB 0:00:00 [83.9KiB/s] [>                                                                                                   ]  1%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-125df0eeb4-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1a76f724ab5d752d314806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415abb53e8b33be29ef894092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d6cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53231b432b4d475f70dd13530b3323000db0d00ab4b2b28
CRITICAL ERROR:  zfs send  -t 1-125df0eeb4-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1a76f724ab5d752d314806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415abb53e8b33be29ef894092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d6cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53231b432b4d475f70dd13530b3323000db0d00ab4b2b28 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 898752 |  zfs receive  -s -F 'recv/test/l0_3/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_1/l2_0@syncoid_iox86_2024-12-19:16:27:03-GMT-06:00 ... syncoid_iox86_2024-12-19:16:42:08-GMT-06:00 (~ 633 KB):
 408KiB 0:00:00 [1.76MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_3/l1_1/l2_1@syncoid_iox86_2024-12-19:16:27:05-GMT-06:00 ... syncoid_iox86_2024-12-19:16:42:10-GMT-06:00 (~ 842 KB):
 543KiB 0:00:00 [2.35MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_3/l1_1/l2_2@syncoid_iox86_2024-12-19:16:27:08-GMT-06:00 ... syncoid_iox86_2024-12-19:16:42:13-GMT-06:00 (~ 810 KB):
warning: cannot send 'send/test/l0_3/l1_1/l2_2@syncoid_iox86_2024-12-19:16:42:13-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [17.5KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_3/l1_1/l2_3@syncoid_iox86_2024-12-19:16:27:10-GMT-06:00 ... syncoid_iox86_2024-12-19:16:42:15-GMT-06:00 (~ 882 KB):
 654KiB 0:00:00 [2.67MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_3/l1_2@syncoid_iox86_2024-12-19:16:27:12-GMT-06:00 ... syncoid_iox86_2024-12-19:16:42:17-GMT-06:00 (~ 662 KB):
 544KiB 0:00:00 [2.38MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_3/l1_2/l2_0@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:42:19-GMT-06:00 (~ 4.6 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_0@syncoid_iox86_2024-12-19:15:41:33-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_2/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 302KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_0'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_3/l1_2/l2_0'@'syncoid_iox86_2024-12-19:16:42:19-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4771864 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2/l2_1@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:42:21-GMT-06:00 (~ 4.1 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_1@syncoid_iox86_2024-12-19:15:41:35-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 428KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_1'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_3/l1_2/l2_1'@'syncoid_iox86_2024-12-19:16:42:21-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4291896 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2/l2_2@syncoid_iox86_2024-12-19:16:27:19-GMT-06:00 ... syncoid_iox86_2024-12-19:16:42:23-GMT-06:00 (~ 782 KB):
 533KiB 0:00:00 [2.24MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_3/l1_2/l2_3@syncoid_iox86_2024-12-19:16:27:21-GMT-06:00 ... syncoid_iox86_2024-12-19:16:42:26-GMT-06:00 (~ 1.0 MB):
 676KiB 0:00:00 [2.91MiB/s] [================================================================>                                   ] 65%            
Sending incremental send/test/l0_3/l1_3@syncoid_iox86_2024-12-19:16:27:23-GMT-06:00 ... syncoid_iox86_2024-12-19:16:42:28-GMT-06:00 (~ 986 KB):
 803KiB 0:00:00 [3.58MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_3/l1_3/l2_0@syncoid_iox86_2024-12-19:16:27:25-GMT-06:00 ... syncoid_iox86_2024-12-19:16:42:30-GMT-06:00 (~ 617 KB):
 400KiB 0:00:00 [1.72MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_3/l1_3/l2_1@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:42:32-GMT-06:00 (~ 4.8 MB):
warning: cannot send 'send/test/l0_3/l1_3/l2_1@syncoid_iox86_2024-12-19:15:26:24-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
68.0KiB 0:00:00 [ 308KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x21000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3/l2_1'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_3/l1_3/l2_1'@'syncoid_iox86_2024-12-19:16:42:32-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5068392 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_3/l2_2@autosnap_2024-12-19_22:00:37_frequently ... syncoid_iox86_2024-12-19:16:42:34-GMT-06:00 (~ 2.2 MB):
warning: cannot send 'send/test/l0_3/l1_3/l2_2@syncoid_iox86_2024-12-19:16:12:20-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 509KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3/l2_2'@'autosnap_2024-12-19_22:00:37_frequently' 'send/test/l0_3/l1_3/l2_2'@'syncoid_iox86_2024-12-19:16:42:34-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2262960 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_3/l2_3 to recv/test/l0_3/l1_3/l2_3 (~ 589 KB remaining):
internal error: warning: cannot send 'send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-19:15:26:29-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-118b3c37f5-118-789c636064000310a501c49c50360710a715e5e7a69766a630408145cff65f8b5a247914806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415f2219fbfbfbf12cc9c8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fac9f6308228ce28d1d8a2bf392f33353e233f32b2ccce28d0c8c4c740d8d740d2dad0c4dad8cccac8c2c75dd7d43740dccac0c0c606e0000e4702cb6 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 603472 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
real 154.77
user 15.77
sys 125.75
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
config:

        NAME                            STATE     READ WRITE CKSUM
        send                            ONLINE       0     0     0
          wwn-0x5002538d40dca5d9-part7  ONLINE       0     0     0
errors: List of errors unavailable: permission denied

errors: 75 data errors, use '-v' for a list


CRITICAL ERROR: Target recv exists but has no snapshots matching with send!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.

Sending incremental send/test@syncoid_iox86_2024-12-19:16:40:02-GMT-06:00 ... syncoid_iox86_2024-12-19:16:55:07-GMT-06:00 (~ 4 KB):
2.13KiB 0:00:00 [29.5KiB/s] [====================================================>                                               ] 53%            
Sending incremental send/test/l0_0@syncoid_iox86_2024-12-19:16:40:03-GMT-06:00 ... syncoid_iox86_2024-12-19:16:55:08-GMT-06:00 (~ 513 KB):
warning: cannot send 'send/test/l0_0@syncoid_iox86_2024-12-19:16:55:08-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [18.8KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_0/l1_0@syncoid_iox86_2024-12-19:16:40:05-GMT-06:00 ... syncoid_iox86_2024-12-19:16:55:10-GMT-06:00 (~ 646 KB):
 536KiB 0:00:00 [2.41MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-19:16:40:08-GMT-06:00 ... syncoid_iox86_2024-12-19:16:55:12-GMT-06:00 (~ 573 KB):
 407KiB 0:00:00 [1.73MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-19:16:40:10-GMT-06:00 ... syncoid_iox86_2024-12-19:16:55:15-GMT-06:00 (~ 381 KB):
 278KiB 0:00:00 [1.22MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_0/l1_0/l2_2@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:55:17-GMT-06:00 (~ 5.7 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-19:15:39:11-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_0/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 322KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_2'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_0/l1_0/l2_2'@'syncoid_iox86_2024-12-19:16:55:17-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 6024416 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-19:16:40:14-GMT-06:00 ... syncoid_iox86_2024-12-19:16:55:19-GMT-06:00 (~ 573 KB):
warning: cannot send 'send/test/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-19:16:55:19-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [17.3KiB/s] [>                                                                                                   ]  0%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1 to recv/test/l0_0/l1_1 (~ 765 KB remaining):
internal error: warning: cannot send 'send/test/l0_0/l1_1@syncoid_iox86_2024-12-19:15:23:43-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-11a7fcef30-110-789c636064000310a501c49c50360710a715e5e7a69766a63040812cfbeff43ac69b310a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a857d1e9723d5bead8d4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d0cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b63231d675f70dd13530b3323000db0d00f6802ab3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 783880 |  zfs receive  -s -F 'recv/test/l0_0/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-19:16:40:17-GMT-06:00 ... syncoid_iox86_2024-12-19:16:55:22-GMT-06:00 (~ 706 KB):
 536KiB 0:00:00 [2.28MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-19:16:40:19-GMT-06:00 ... syncoid_iox86_2024-12-19:16:55:24-GMT-06:00 (~ 1.0 MB):
 933KiB 0:00:00 [3.57MiB/s] [=========================================================================================>          ] 90%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1/l2_2 to recv/test/l0_0/l1_1/l2_2 (~ 841 KB remaining):
internal error: warning: cannot send 'send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-19:15:39:20-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-129b2dd437-118-789c636064000310a501c49c50360710a715e5e7a69766a63040013b8b465497715aa802888da42e3f292b35b904c207010cf9b4b4e2d412063800c9b321c9275596a41633a0ca23eb2fc987b8e2faa903a25b34df182420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61beae718c51b391457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1919e8bafb86e81a98591918c0dc00004b072ae9 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 861888 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1/l2_3 to recv/test/l0_0/l1_1/l2_3 (~ 913 KB remaining):
warning: cannot send 'send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-19:15:39:22-GMT-06:00': Input/output error
 408 B 0:00:00 [4.59KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1136c0efbd-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041d3b6c3921ba7f09d5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057d8f4bf9952bfe4dbe10424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837803fd1cc37843fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b634b2b23235d77df105d03332b0303981b0090282dd3
CRITICAL ERROR:  zfs send  -t 1-1136c0efbd-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041d3b6c3921ba7f09d5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057d8f4bf9952bfe4dbe10424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837803fd1cc37843fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b634b2b23235d77df105d03332b0303981b0090282dd3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 935800 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_2@syncoid_iox86_2024-12-19:16:40:22-GMT-06:00 ... syncoid_iox86_2024-12-19:16:55:27-GMT-06:00 (~ 425 KB):
 272KiB 0:00:00 [1.28MiB/s] [==============================================================>                                     ] 63%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_2/l2_0 to recv/test/l0_0/l1_2/l2_0 (~ 781 KB remaining):
warning: cannot send 'send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-19:15:39:26-GMT-06:00': Input/output error
 408 B 0:00:00 [3.52KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11d384ec20-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c142be63273a9bb6c62900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bd4ec24bf987ee23f998024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fa49f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656c696564a6ebee1ba26b6066656000730300ff272c45
CRITICAL ERROR:  zfs send  -t 1-11d384ec20-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c142be63273a9bb6c62900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bd4ec24bf987ee23f998024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fa49f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656c696564a6ebee1ba26b6066656000730300ff272c45 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 800448 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_2/l2_1 to recv/test/l0_0/l1_2/l2_1 (~ 677 KB remaining):
warning: cannot send 'send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-19:15:39:28-GMT-06:00': Input/output error
 408 B 0:00:00 [3.93KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-127e44ff0a-118-789c636064000310a501c49c50360710a715e5e7a69766a630408154cbf596c2961b1a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28aa97713ed98eb959f2420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61be9e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1959e8bafb86e81a98591918c0dc0000b0b52c05
CRITICAL ERROR:  zfs send  -t 1-127e44ff0a-118-789c636064000310a501c49c50360710a715e5e7a69766a630408154cbf596c2961b1a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28aa97713ed98eb959f2420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61be9e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1959e8bafb86e81a98591918c0dc0000b0b52c05 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 693768 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-19:16:40:25-GMT-06:00 ... syncoid_iox86_2024-12-19:16:55:30-GMT-06:00 (~ 914 KB):
 671KiB 0:00:00 [2.66MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-19:16:40:27-GMT-06:00 ... syncoid_iox86_2024-12-19:16:55:32-GMT-06:00 (~ 722 KB):
 543KiB 0:00:00 [2.20MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_3@syncoid_iox86_2024-12-19:16:40:30-GMT-06:00 ... syncoid_iox86_2024-12-19:16:55:34-GMT-06:00 (~ 986 KB):
warning: cannot send 'send/test/l0_0/l1_3@syncoid_iox86_2024-12-19:16:55:34-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [17.6KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-19:16:40:32-GMT-06:00 ... syncoid_iox86_2024-12-19:16:55:36-GMT-06:00 (~ 650 KB):
warning: cannot send 'send/test/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-19:16:55:36-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [17.0KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-19:16:40:34-GMT-06:00 ... syncoid_iox86_2024-12-19:16:55:38-GMT-06:00 (~ 722 KB):
 543KiB 0:00:00 [2.31MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-19:16:40:36-GMT-06:00 ... syncoid_iox86_2024-12-19:16:55:41-GMT-06:00 (~ 662 KB):
 537KiB 0:00:00 [2.18MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_0/l1_3/l2_3@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:55:43-GMT-06:00 (~ 5.0 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-19:15:39:44-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 325KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_3'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_0/l1_3/l2_3'@'syncoid_iox86_2024-12-19:16:55:43-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5261272 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1@syncoid_iox86_2024-12-19:16:40:40-GMT-06:00 ... syncoid_iox86_2024-12-19:16:55:45-GMT-06:00 (~ 1.0 MB):
 804KiB 0:00:00 [3.92MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_1/l1_0@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:55:46-GMT-06:00 (~ 5.3 MB):
warning: cannot send 'send/test/l0_1/l1_0@syncoid_iox86_2024-12-19:15:39:47-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_0 does not
match incremental source
64.0KiB 0:00:00 [ 347KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_1/l1_0'@'syncoid_iox86_2024-12-19:16:55:46-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5576664 |  zfs receive  -s -F 'recv/test/l0_1/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-19:16:40:44-GMT-06:00 ... syncoid_iox86_2024-12-19:16:55:49-GMT-06:00 (~ 914 KB):
 670KiB 0:00:00 [2.85MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-19:16:40:47-GMT-06:00 ... syncoid_iox86_2024-12-19:16:55:51-GMT-06:00 (~ 678 KB):
 546KiB 0:00:00 [2.20MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-19:16:40:49-GMT-06:00 ... syncoid_iox86_2024-12-19:16:55:53-GMT-06:00 (~ 469 KB):
 408KiB 0:00:00 [1.65MiB/s] [=====================================================================================>              ] 86%            
Sending incremental send/test/l0_1/l1_0/l2_3@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:55:56-GMT-06:00 (~ 6.5 MB):
warning: cannot send 'send/test/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-19:15:24:26-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
68.0KiB 0:00:00 [ 300KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x31000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_3'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_1/l1_0/l2_3'@'syncoid_iox86_2024-12-19:16:55:56-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 6845600 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1@syncoid_iox86_2024-12-19:16:40:53-GMT-06:00 ... syncoid_iox86_2024-12-19:16:55:58-GMT-06:00 (~ 914 KB):
 666KiB 0:00:00 [2.98MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_1/l1_1/l2_0@autosnap_2024-12-19_22:30:07_frequently ... syncoid_iox86_2024-12-19:16:56:00-GMT-06:00 (~ 1.1 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-19:16:40:55-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_1/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 373KiB/s] [====>                                                                                               ]  5%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_0'@'autosnap_2024-12-19_22:30:07_frequently' 'send/test/l0_1/l1_1/l2_0'@'syncoid_iox86_2024-12-19:16:56:00-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1113176 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-19:16:40:58-GMT-06:00 ... syncoid_iox86_2024-12-19:16:56:02-GMT-06:00 (~ 365 KB):
 272KiB 0:00:00 [1.15MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-19:16:41:00-GMT-06:00 ... syncoid_iox86_2024-12-19:16:56:04-GMT-06:00 (~ 381 KB):
 275KiB 0:00:00 [1.17MiB/s] [=======================================================================>                            ] 72%            
Resuming interrupted zfs send/receive from send/test/l0_1/l1_1/l2_3 to recv/test/l0_1/l1_1/l2_3 (~ 601 KB remaining):
warning: cannot send 'send/test/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-19:16:25:54-GMT-06:00': Input/output error
 408 B 0:00:00 [5.50KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11c3a6aed0-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1bedd5d59377b023f2900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bae1e8b14e34b5c362f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc7104418c51b3b1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5919995a999ae8bafb86e81a98591918c0dc0000cbf32d4c
CRITICAL ERROR:  zfs send  -t 1-11c3a6aed0-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1bedd5d59377b023f2900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bae1e8b14e34b5c362f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc7104418c51b3b1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5919995a999ae8bafb86e81a98591918c0dc0000cbf32d4c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 615760 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_2 to recv/test/l0_1/l1_2 (~ 781 KB remaining):
warning: cannot send 'send/test/l0_1/l1_2@syncoid_iox86_2024-12-19:16:10:39-GMT-06:00': Input/output error
9.12KiB 0:00:00 [ 163KiB/s] [>                                                                                                   ]  1%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-12c765b085-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e0e2e662f129d1fb14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec41532e1e96c9ba43f1f8e4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d4cf318c377228aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b032b6d475f70dd13530b3323000db0d00bdab29e2
CRITICAL ERROR:  zfs send  -t 1-12c765b085-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e0e2e662f129d1fb14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec41532e1e96c9ba43f1f8e4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d4cf318c377228aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b032b6d475f70dd13530b3323000db0d00bdab29e2 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 800448 |  zfs receive  -s -F 'recv/test/l0_1/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_2/l2_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:56:07-GMT-06:00 (~ 5.1 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:24:41-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:40:11-GMT-06:00': Invalid argument
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 353KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_1/l1_2/l2_0'@'syncoid_iox86_2024-12-19:16:56:07-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5361192 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-19:15:55:27-GMT-06:00 ... syncoid_iox86_2024-12-19:16:56:09-GMT-06:00 (~ 3.2 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_1@autosnap_2024-12-19_22:00:37_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 440KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-19:15:55:27-GMT-06:00' 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-19:16:56:09-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3372480 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_2/l2_2 to recv/test/l0_1/l1_2/l2_2 (~ 441 KB remaining):
internal error: warning: cannot send 'send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-19:15:24:46-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-10c0c26d5d-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c119ee6bd985a9cf1415806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415c2fbb6ac5820c35a9e8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa89f63186fa49f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a6564626562a6ebee1ba26b6066656000730300a3612bd3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 451736 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-19:16:41:09-GMT-06:00 ... syncoid_iox86_2024-12-19:16:56:12-GMT-06:00 (~ 589 KB):
 414KiB 0:00:00 [1.72MiB/s] [=====================================================================>                              ] 70%            
Resuming interrupted zfs send/receive from send/test/l0_1/l1_3 to recv/test/l0_1/l1_3 (~ 1.4 MB remaining):
warning: cannot send 'send/test/l0_1/l1_3@syncoid_iox86_2024-12-19:16:10:48-GMT-06:00': Input/output error
2.88KiB 0:00:00 [25.6KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-10a8cedad3-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e802cf8827d51fca14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4157aef0ebc7f13e6f52402499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccad0c0cac442d7dd3744d7c0cccac0006c370009f72c68
CRITICAL ERROR:  zfs send  -t 1-10a8cedad3-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e802cf8827d51fca14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4157aef0ebc7f13e6f52402499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccad0c0cac442d7dd3744d7c0cccac0006c370009f72c68 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1477208 |  zfs receive  -s -F 'recv/test/l0_1/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_3/l2_0 to recv/test/l0_1/l1_3/l2_0 (~ 913 KB remaining):
warning: cannot send 'send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-19:15:24:52-GMT-06:00': Input/output error
1.01KiB 0:00:00 [10.5KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-14f1ada464-118-789c636064000310a501c49c50360710a715e5e7a69766a63040418addc3edb7bfcc105400b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f910579857b1fed8fe8dd33b01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730de583fc728dec0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8c4cad448d7dd3744d7c0cccac000e606006a502cd6
CRITICAL ERROR:  zfs send  -t 1-14f1ada464-118-789c636064000310a501c49c50360710a715e5e7a69766a63040418addc3edb7bfcc105400b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f910579857b1fed8fe8dd33b01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730de583fc728dec0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8c4cad448d7dd3744d7c0cccac000e606006a502cd6 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 935800 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-19:16:41:13-GMT-06:00 ... syncoid_iox86_2024-12-19:16:56:15-GMT-06:00 (~ 722 KB):
 538KiB 0:00:00 [2.23MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-19:16:41:16-GMT-06:00 ... syncoid_iox86_2024-12-19:16:56:17-GMT-06:00 (~ 573 KB):
 408KiB 0:00:00 [1.70MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-19:16:41:18-GMT-06:00 ... syncoid_iox86_2024-12-19:16:56:19-GMT-06:00 (~ 870 KB):
 675KiB 0:00:00 [2.75MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_2@syncoid_iox86_2024-12-19:16:41:20-GMT-06:00 ... syncoid_iox86_2024-12-19:16:56:21-GMT-06:00 (~ 573 KB):
 407KiB 0:00:00 [2.01MiB/s] [=====================================================================>                              ] 70%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_0 to recv/test/l0_2/l1_0 (~ 172 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_0@syncoid_iox86_2024-12-19:15:25:02-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-13c9ed8a18-110-789c636064000310a501c49c50360710a715e5e7a69766a6304041f15cde74936d7c350a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a904dbc359336a67d8c4092e704cbe725e6a602dd979a97a20f34aa443fc720de483fc730dec0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cac048d7dd3744d7c0cccac0006c3700a3a12a2c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 176936 |  zfs receive  -s -F 'recv/test/l0_2/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-19:16:41:22-GMT-06:00 ... syncoid_iox86_2024-12-19:16:56:24-GMT-06:00 (~ 633 KB):
 407KiB 0:00:00 [1.78MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_2/l1_0/l2_1@autosnap_2024-12-19_22:30:07_frequently ... syncoid_iox86_2024-12-19:16:56:26-GMT-06:00 (~ 1.5 MB):
warning: cannot send 'send/test/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-19:16:41:25-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_0/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 382KiB/s] [===>                                                                                                ]  4%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_0/l2_1'@'autosnap_2024-12-19_22:30:07_frequently' 'send/test/l0_2/l1_0/l2_1'@'syncoid_iox86_2024-12-19:16:56:26-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1613808 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_0/l2_2 to recv/test/l0_2/l1_0/l2_2 (~ 585 KB remaining):
warning: cannot send 'send/test/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-19:15:25:09-GMT-06:00': Input/output error
6.00KiB 0:00:00 [51.2KiB/s] [>                                                                                                   ]  1%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11afa6c057-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c187d56e616f8fb13c5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057b84d89e20ee3377c9d8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa09f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6560a9ebee1ba26b606665600073030027ef2c0c
CRITICAL ERROR:  zfs send  -t 1-11afa6c057-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c187d56e616f8fb13c5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057b84d89e20ee3377c9d8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa09f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6560a9ebee1ba26b606665600073030027ef2c0c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 599376 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-19:16:41:27-GMT-06:00 ... syncoid_iox86_2024-12-19:16:56:28-GMT-06:00 (~ 998 KB):
 763KiB 0:00:00 [3.14MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_2/l1_1@syncoid_iox86_2024-12-19:16:41:29-GMT-06:00 ... syncoid_iox86_2024-12-19:16:56:30-GMT-06:00 (~ 854 KB):
 673KiB 0:00:00 [2.87MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-19:16:41:32-GMT-06:00 ... syncoid_iox86_2024-12-19:16:56:33-GMT-06:00 (~ 585 KB):
 538KiB 0:00:00 [2.17MiB/s] [==========================================================================================>         ] 91%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_1/l2_1 to recv/test/l0_2/l1_1/l2_1 (~ 721 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-19:15:25:18-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-ff823389f-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1222bc149011dceef15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4151f5e86aa54575f399a8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa89f63146fe8505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6568a1ebee1ba26b6066656000730300d8b82ce2 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 738824 |  zfs receive  -s -F 'recv/test/l0_2/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-19:16:41:34-GMT-06:00 ... syncoid_iox86_2024-12-19:16:56:35-GMT-06:00 (~ 1.0 MB):
 805KiB 0:00:00 [3.14MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-19:16:41:36-GMT-06:00 ... syncoid_iox86_2024-12-19:16:56:38-GMT-06:00 (~ 573 KB):
 407KiB 0:00:00 [1.67MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_2/l1_2@autosnap_2024-12-19_22:30:07_frequently ... syncoid_iox86_2024-12-19:16:56:40-GMT-06:00 (~ 1.1 MB):
warning: cannot send 'send/test/l0_2/l1_2@syncoid_iox86_2024-12-19:16:41:39-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_2 does not
match incremental source
64.0KiB 0:00:00 [ 407KiB/s] [====>                                                                                               ]  5%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_2'@'autosnap_2024-12-19_22:30:07_frequently' 'send/test/l0_2/l1_2'@'syncoid_iox86_2024-12-19:16:56:40-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1113360 |  zfs receive  -s -F 'recv/test/l0_2/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_2/l2_0@syncoid_iox86_2024-12-19:16:41:41-GMT-06:00 ... syncoid_iox86_2024-12-19:16:56:42-GMT-06:00 (~ 1.0 MB):
 793KiB 0:00:00 [3.10MiB/s] [==========================================================================>                         ] 75%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_2/l2_1 to recv/test/l0_2/l1_2/l2_1 (~ 721 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_2/l2_1@syncoid_iox86_2024-12-19:16:11:25-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-1401815849-118-789c636064000310a501c49c50360710a715e5e7a69766a630408169bb71866b7259970290cd8ea42e3f292b35b904c207010cf9b4b4e2d412063800c9b321c9275596a41633a0ca23eb2fc987b8a2bfb4f74661828a6502923c27583e2f31379581a138352f451f6854897e8e41bc917e8e2188308a377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b43232d575f70dd13530b3323080b90100d6e62b09 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 738824 |  zfs receive  -s -F 'recv/test/l0_2/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_2/l2_2@syncoid_iox86_2024-12-19:16:41:43-GMT-06:00 ... syncoid_iox86_2024-12-19:16:56:45-GMT-06:00 (~ 1.0 MB):
 801KiB 0:00:00 [3.43MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_2/l1_2/l2_3@syncoid_iox86_2024-12-19:16:41:46-GMT-06:00 ... syncoid_iox86_2024-12-19:16:56:47-GMT-06:00 (~ 898 KB):
 661KiB 0:00:00 [2.81MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_2/l1_3@syncoid_iox86_2024-12-19:16:41:48-GMT-06:00 ... syncoid_iox86_2024-12-19:16:56:49-GMT-06:00 (~ 529 KB):
 416KiB 0:00:00 [1.83MiB/s] [=============================================================================>                      ] 78%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_0 to recv/test/l0_2/l1_3/l2_0 (~ 805 KB remaining):
warning: cannot send 'send/test/l0_2/l1_3/l2_0@syncoid_iox86_2024-12-19:15:25:37-GMT-06:00': Input/output error
3.66KiB 0:00:00 [26.2KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-13257a23ca-118-789c636064000310a501c49c50360710a715e5e7a69766a63040811793597dc5b5386d05209b1d495d7e52566a7209840f0218f26969c5a9250c7000926743924faa2c492d66409547d65f920f71c5fbb9227763bfec0c494092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d2cf318c37d6cf318a377028aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b53236d775f70dd13530b3323080b90100368a2c2d
CRITICAL ERROR:  zfs send  -t 1-13257a23ca-118-789c636064000310a501c49c50360710a715e5e7a69766a63040811793597dc5b5386d05209b1d495d7e52566a7209840f0218f26969c5a9250c7000926743924faa2c492d66409547d65f920f71c5fbb9227763bfec0c494092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d2cf318c37d6cf318a377028aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b53236d775f70dd13530b3323080b90100368a2c2d | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 825024 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_1 to recv/test/l0_2/l1_3/l2_1 (~ 557 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-19:15:25:39-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-14c7859310-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1459fa97f6772eabe5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057a42cf1b39e5e29783601499e132c9f97989bcac0509c9a97a20f34aa443fc720de483fc730de583fc728ded0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cad852d7dd3744d7c0cccac000e6060018eb2c68 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 570704 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_3/l2_2@syncoid_iox86_2024-12-19:16:41:53-GMT-06:00 ... syncoid_iox86_2024-12-19:16:56:52-GMT-06:00 (~ 782 KB):
 547KiB 0:00:00 [2.34MiB/s] [=====================================================================>                              ] 70%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_3 to recv/test/l0_2/l1_3/l2_3 (~ 629 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-19:15:25:44-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-14bb428d41-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c193fcf2ca3fbbf6592900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b6a5e1844ad2cbeb03f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de483fc730de583fc728ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cac444d7dd3744d7c0cccac000e6060004302e05 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 644432 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:16:56:54-GMT-06:00 (~ 5.4 MB):
warning: cannot send 'send/test/l0_3@syncoid_iox86_2024-12-19:15:25:45-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 450KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_3'@'syncoid_iox86_2024-12-19:16:56:54-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5684960 |  zfs receive  -s -F 'recv/test/l0_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_0 to recv/test/l0_3/l1_0 (~ 1.5 MB remaining):
warning: cannot send 'send/test/l0_3/l1_0@syncoid_iox86_2024-12-19:15:25:47-GMT-06:00': Input/output error
2.88KiB 0:00:00 [24.5KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-125adfe068-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c17716fba2b593971d5700b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057541fa9bef9519ceb5c04923c27583e2f31379581a138352f451f6854897e8e41bcb17e8e61bc814371655e727e664a7c667e858559bc91819189aea191aea1a595a1a99591a99589b9aebb6f88ae8199958101d86e00f7a72be1
CRITICAL ERROR:  zfs send  -t 1-125adfe068-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c17716fba2b593971d5700b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057541fa9bef9519ceb5c04923c27583e2f31379581a138352f451f6854897e8e41bcb17e8e61bc814371655e727e664a7c667e858559bc91819189aea191aea1a595a1a99591a99589b9aebb6f88ae8199958101d86e00f7a72be1 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1526360 |  zfs receive  -s -F 'recv/test/l0_3/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_0/l2_0@syncoid_iox86_2024-12-19:16:41:59-GMT-06:00 ... syncoid_iox86_2024-12-19:16:56:57-GMT-06:00 (~ 425 KB):
 265KiB 0:00:00 [1.14MiB/s] [=============================================================>                                      ] 62%            
Sending incremental send/test/l0_3/l1_0/l2_1@syncoid_iox86_2024-12-19:16:42:01-GMT-06:00 ... syncoid_iox86_2024-12-19:16:56:59-GMT-06:00 (~ 782 KB):
 540KiB 0:00:00 [2.21MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_3/l1_0/l2_2@syncoid_iox86_2024-12-19:16:42:03-GMT-06:00 ... syncoid_iox86_2024-12-19:16:57:01-GMT-06:00 (~ 674 KB):
 506KiB 0:00:00 [2.13MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_3/l1_0/l2_3@syncoid_iox86_2024-12-19:16:42:05-GMT-06:00 ... syncoid_iox86_2024-12-19:16:57:04-GMT-06:00 (~ 986 KB):
 799KiB 0:00:00 [3.24MiB/s] [================================================================================>                   ] 81%            
Resuming interrupted zfs send/receive from send/test/l0_3/l1_1 to recv/test/l0_3/l1_1 (~ 877 KB remaining):
warning: cannot send 'send/test/l0_3/l1_1@syncoid_iox86_2024-12-19:15:41:19-GMT-06:00': Input/output error
9.12KiB 0:00:00 [83.8KiB/s] [>                                                                                                   ]  1%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-125df0eeb4-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1a76f724ab5d752d314806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415abb53e8b33be29ef894092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d6cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53231b432b4d475f70dd13530b3323000db0d00ab4b2b28
CRITICAL ERROR:  zfs send  -t 1-125df0eeb4-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1a76f724ab5d752d314806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415abb53e8b33be29ef894092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d6cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53231b432b4d475f70dd13530b3323000db0d00ab4b2b28 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 898752 |  zfs receive  -s -F 'recv/test/l0_3/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_1/l2_0@syncoid_iox86_2024-12-19:16:42:08-GMT-06:00 ... syncoid_iox86_2024-12-19:16:57:06-GMT-06:00 (~ 1.2 MB):
 937KiB 0:00:00 [3.72MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_3/l1_1/l2_1@syncoid_iox86_2024-12-19:16:42:10-GMT-06:00 ... syncoid_iox86_2024-12-19:16:57:09-GMT-06:00 (~ 722 KB):
 543KiB 0:00:00 [2.20MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_3/l1_1/l2_2@autosnap_2024-12-19_22:30:07_frequently ... syncoid_iox86_2024-12-19:16:57:11-GMT-06:00 (~ 1.4 MB):
warning: cannot send 'send/test/l0_3/l1_1/l2_2@syncoid_iox86_2024-12-19:16:42:13-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_1/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 363KiB/s] [===>                                                                                                ]  4%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_1/l2_2'@'autosnap_2024-12-19_22:30:07_frequently' 'send/test/l0_3/l1_1/l2_2'@'syncoid_iox86_2024-12-19:16:57:11-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1429120 |  zfs receive  -s -F 'recv/test/l0_3/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_1/l2_3@syncoid_iox86_2024-12-19:16:42:15-GMT-06:00 ... syncoid_iox86_2024-12-19:16:57:13-GMT-06:00 (~ 766 KB):
 536KiB 0:00:00 [2.27MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_3/l1_2@syncoid_iox86_2024-12-19:16:42:17-GMT-06:00 ... syncoid_iox86_2024-12-19:16:57:15-GMT-06:00 (~ 798 KB):
 551KiB 0:00:00 [2.51MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_3/l1_2/l2_0@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:57:17-GMT-06:00 (~ 5.3 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_0@syncoid_iox86_2024-12-19:15:41:33-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_2/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 312KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_0'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_3/l1_2/l2_0'@'syncoid_iox86_2024-12-19:16:57:17-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5572936 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2/l2_1@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:16:57:20-GMT-06:00 (~ 4.7 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_1@syncoid_iox86_2024-12-19:15:41:35-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 393KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_1'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_3/l1_2/l2_1'@'syncoid_iox86_2024-12-19:16:57:20-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4895992 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2/l2_2@syncoid_iox86_2024-12-19:16:42:23-GMT-06:00 ... syncoid_iox86_2024-12-19:16:57:22-GMT-06:00 (~ 990 KB):
 674KiB 0:00:00 [2.70MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_3/l1_2/l2_3@syncoid_iox86_2024-12-19:16:42:26-GMT-06:00 ... syncoid_iox86_2024-12-19:16:57:24-GMT-06:00 (~ 990 KB):
 679KiB 0:00:00 [2.87MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_3/l1_3@syncoid_iox86_2024-12-19:16:42:28-GMT-06:00 ... syncoid_iox86_2024-12-19:16:57:26-GMT-06:00 (~ 1.0 MB):
 803KiB 0:00:00 [3.54MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_3/l1_3/l2_0@syncoid_iox86_2024-12-19:16:42:30-GMT-06:00 ... syncoid_iox86_2024-12-19:16:57:28-GMT-06:00 (~ 650 KB):
 414KiB 0:00:00 [1.65MiB/s] [==============================================================>                                     ] 63%            
Resuming interrupted zfs send/receive from send/test/l0_3/l1_3/l2_1 to recv/test/l0_3/l1_3/l2_1 (~ 380 KB remaining):
warning: cannot send 'send/test/l0_3/l1_3/l2_1@syncoid_iox86_2024-12-19:15:26:24-GMT-06:00': Input/output error
6.78KiB 0:00:00 [59.7KiB/s] [>                                                                                                   ]  1%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1207838ecb-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1b68fb9cbf98eafae5000b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f9105708dd7c3dcdf440bf4c02923c27583e2f31379581a138352f451f6854897e8e41bcb17e8e2188308a377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b30272dd7d43740dccac0c0c606e000094ae2d38
CRITICAL ERROR:  zfs send  -t 1-1207838ecb-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1b68fb9cbf98eafae5000b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f9105708dd7c3dcdf440bf4c02923c27583e2f31379581a138352f451f6854897e8e41bcb17e8e2188308a377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b30272dd7d43740dccac0c0c606e000094ae2d38 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 390112 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_3/l2_2@autosnap_2024-12-19_22:00:37_frequently ... syncoid_iox86_2024-12-19:16:57:31-GMT-06:00 (~ 2.5 MB):
warning: cannot send 'send/test/l0_3/l1_3/l2_2@syncoid_iox86_2024-12-19:16:12:20-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 485KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3/l2_2'@'autosnap_2024-12-19_22:00:37_frequently' 'send/test/l0_3/l1_3/l2_2'@'syncoid_iox86_2024-12-19:16:57:31-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2653696 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_3/l2_3 to recv/test/l0_3/l1_3/l2_3 (~ 589 KB remaining):
internal error: warning: cannot send 'send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-19:15:26:29-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-118b3c37f5-118-789c636064000310a501c49c50360710a715e5e7a69766a630408145cff65f8b5a247914806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415f2219fbfbfbf12cc9c8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fac9f6308228ce28d1d8a2bf392f33353e233f32b2ccce28d0c8c4c740d8d740d2dad0c4dad8cccac8c2c75dd7d43740dccac0c0c606e0000e4702cb6 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 603472 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
real 146.74
user 15.58
sys 118.89
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
config:

        NAME                            STATE     READ WRITE CKSUM
        send                            ONLINE       0     0     0
          wwn-0x5002538d40dca5d9-part7  ONLINE       0     0     0
errors: List of errors unavailable: permission denied

errors: 83 data errors, use '-v' for a list


CRITICAL ERROR: Target recv exists but has no snapshots matching with send!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.

Sending incremental send/test@syncoid_iox86_2024-12-19:16:55:07-GMT-06:00 ... syncoid_iox86_2024-12-19:17:10:03-GMT-06:00 (~ 4 KB):
2.74KiB 0:00:00 [31.9KiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_0@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:17:10:05-GMT-06:00 (~ 687 KB):
warning: cannot send 'send/test/l0_0@syncoid_iox86_2024-12-19:16:55:08-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0 does not
match incremental source
64.0KiB 0:00:00 [ 482KiB/s] [========>                                                                                           ]  9%            
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0'@'syncoid_iox86_2024-12-19:17:10:05-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 703832 |  zfs receive  -s -F 'recv/test/l0_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_0@syncoid_iox86_2024-12-19:16:55:10-GMT-06:00 ... syncoid_iox86_2024-12-19:17:10:07-GMT-06:00 (~ 514 KB):
 408KiB 0:00:00 [3.21MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-19:16:55:12-GMT-06:00 ... syncoid_iox86_2024-12-19:17:10:09-GMT-06:00 (~ 838 KB):
 658KiB 0:00:00 [4.56MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-19:16:55:15-GMT-06:00 ... syncoid_iox86_2024-12-19:17:10:11-GMT-06:00 (~ 706 KB):
 536KiB 0:00:00 [3.69MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_0/l2_2@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:17:10:14-GMT-06:00 (~ 6.5 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-19:15:39:11-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_0/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 302KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_2'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_0/l1_0/l2_2'@'syncoid_iox86_2024-12-19:17:10:14-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 6826112 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_0/l2_3@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:17:10:16-GMT-06:00 (~ 1.3 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-19:16:55:19-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_0/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 385KiB/s] [===>                                                                                                ]  4%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_3'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0/l1_0/l2_3'@'syncoid_iox86_2024-12-19:17:10:16-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1310776 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1 to recv/test/l0_0/l1_1 (~ 765 KB remaining):
internal error: warning: cannot send 'send/test/l0_0/l1_1@syncoid_iox86_2024-12-19:15:23:43-GMT-06:00': Invalid argument
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-11a7fcef30-110-789c636064000310a501c49c50360710a715e5e7a69766a63040812cfbeff43ac69b310a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a857d1e9723d5bead8d4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d0cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b63231d675f70dd13530b3323000db0d00f6802ab3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 783880 |  zfs receive  -s -F 'recv/test/l0_0/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-19:16:55:22-GMT-06:00 ... syncoid_iox86_2024-12-19:17:10:18-GMT-06:00 (~ 574 KB):
 400KiB 0:00:00 [2.89MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-19:16:55:24-GMT-06:00 ... syncoid_iox86_2024-12-19:17:10:21-GMT-06:00 (~ 322 KB):
 276KiB 0:00:00 [2.00MiB/s] [====================================================================================>               ] 85%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1/l2_2 to recv/test/l0_0/l1_1/l2_2 (~ 841 KB remaining):
internal error: warning: cannot send 'send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-19:15:39:20-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-129b2dd437-118-789c636064000310a501c49c50360710a715e5e7a69766a63040013b8b465497715aa802888da42e3f292b35b904c207010cf9b4b4e2d412063800c9b321c9275596a41633a0ca23eb2fc987b8e2faa903a25b34df182420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61beae718c51b391457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1919e8bafb86e81a98591918c0dc00004b072ae9 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 861888 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1/l2_3 to recv/test/l0_0/l1_1/l2_3 (~ 913 KB remaining):
warning: cannot send 'send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-19:15:39:22-GMT-06:00': Input/output error
 408 B 0:00:00 [4.31KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1136c0efbd-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041d3b6c3921ba7f09d5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057d8f4bf9952bfe4dbe10424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837803fd1cc37843fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b634b2b23235d77df105d03332b0303981b0090282dd3
CRITICAL ERROR:  zfs send  -t 1-1136c0efbd-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041d3b6c3921ba7f09d5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057d8f4bf9952bfe4dbe10424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837803fd1cc37843fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b634b2b23235d77df105d03332b0303981b0090282dd3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 935800 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_2@syncoid_iox86_2024-12-19:16:55:27-GMT-06:00 ... syncoid_iox86_2024-12-19:17:10:24-GMT-06:00 (~ 542 KB):
 377KiB 0:00:00 [2.84MiB/s] [====================================================================>                               ] 69%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_2/l2_0 to recv/test/l0_0/l1_2/l2_0 (~ 781 KB remaining):
warning: cannot send 'send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-19:15:39:26-GMT-06:00': Input/output error
 408 B 0:00:00 [3.70KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11d384ec20-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c142be63273a9bb6c62900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bd4ec24bf987ee23f998024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fa49f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656c696564a6ebee1ba26b6066656000730300ff272c45
CRITICAL ERROR:  zfs send  -t 1-11d384ec20-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c142be63273a9bb6c62900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bd4ec24bf987ee23f998024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fa49f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656c696564a6ebee1ba26b6066656000730300ff272c45 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 800448 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_2/l2_1 to recv/test/l0_0/l1_2/l2_1 (~ 677 KB remaining):
warning: cannot send 'send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-19:15:39:28-GMT-06:00': Input/output error
 408 B 0:00:00 [4.12KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-127e44ff0a-118-789c636064000310a501c49c50360710a715e5e7a69766a630408154cbf596c2961b1a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28aa97713ed98eb959f2420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61be9e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1959e8bafb86e81a98591918c0dc0000b0b52c05
CRITICAL ERROR:  zfs send  -t 1-127e44ff0a-118-789c636064000310a501c49c50360710a715e5e7a69766a630408154cbf596c2961b1a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28aa97713ed98eb959f2420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61be9e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1959e8bafb86e81a98591918c0dc0000b0b52c05 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 693768 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-19:16:55:30-GMT-06:00 ... syncoid_iox86_2024-12-19:17:10:27-GMT-06:00 (~ 722 KB):
 544KiB 0:00:00 [3.76MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-19:16:55:32-GMT-06:00 ... syncoid_iox86_2024-12-19:17:10:29-GMT-06:00 (~ 1.0 MB):
 673KiB 0:00:00 [4.70MiB/s] [================================================================>                                   ] 65%            
Sending incremental send/test/l0_0/l1_3@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:17:10:31-GMT-06:00 (~ 1.9 MB):
warning: cannot send 'send/test/l0_0/l1_3@syncoid_iox86_2024-12-19:16:55:34-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3 does not
match incremental source
64.0KiB 0:00:00 [ 395KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0/l1_3'@'syncoid_iox86_2024-12-19:17:10:31-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1946576 |  zfs receive  -s -F 'recv/test/l0_0/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_3/l2_0@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:17:10:33-GMT-06:00 (~ 1.3 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-19:16:55:36-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 378KiB/s] [===>                                                                                                ]  4%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_0'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0/l1_3/l2_0'@'syncoid_iox86_2024-12-19:17:10:33-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1405168 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-19:16:55:38-GMT-06:00 ... syncoid_iox86_2024-12-19:17:10:35-GMT-06:00 (~ 822 KB):
 639KiB 0:00:00 [4.42MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-19:16:55:41-GMT-06:00 ... syncoid_iox86_2024-12-19:17:10:38-GMT-06:00 (~ 382 KB):
 275KiB 0:00:00 [2.00MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_0/l1_3/l2_3@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:17:10:40-GMT-06:00 (~ 5.8 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-19:15:39:44-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 297KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_3'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_0/l1_3/l2_3'@'syncoid_iox86_2024-12-19:17:10:40-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 6062968 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1@syncoid_iox86_2024-12-19:16:55:45-GMT-06:00 ... syncoid_iox86_2024-12-19:17:10:42-GMT-06:00 (~ 738 KB):
 552KiB 0:00:00 [4.47MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_1/l1_0@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:17:10:44-GMT-06:00 (~ 6.1 MB):
warning: cannot send 'send/test/l0_1/l1_0@syncoid_iox86_2024-12-19:15:39:47-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_0 does not
match incremental source
64.0KiB 0:00:00 [ 320KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_1/l1_0'@'syncoid_iox86_2024-12-19:17:10:44-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 6378360 |  zfs receive  -s -F 'recv/test/l0_1/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-19:16:55:49-GMT-06:00 ... syncoid_iox86_2024-12-19:17:10:46-GMT-06:00 (~ 454 KB):
 410KiB 0:00:00 [2.74MiB/s] [=========================================================================================>          ] 90%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-19:16:55:51-GMT-06:00 ... syncoid_iox86_2024-12-19:17:10:48-GMT-06:00 (~ 322 KB):
 275KiB 0:00:00 [1.90MiB/s] [====================================================================================>               ] 85%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-19:16:55:53-GMT-06:00 ... syncoid_iox86_2024-12-19:17:10:51-GMT-06:00 (~ 766 KB):
 535KiB 0:00:00 [3.93MiB/s] [====================================================================>                               ] 69%            
Resuming interrupted zfs send/receive from send/test/l0_1/l1_0/l2_3 to recv/test/l0_1/l1_0/l2_3 (~ 913 KB remaining):
warning: cannot send 'send/test/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-19:15:24:26-GMT-06:00': Input/output error
6.00KiB 0:00:00 [54.0KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1115fe3a2e-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041eeacba2d2205362a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe20ab9c977fc0ebe96cb4f4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d4cf318c37d0cf318a377628aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b13232d375f70dd13530b3323080b9010026142ba7
CRITICAL ERROR:  zfs send  -t 1-1115fe3a2e-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041eeacba2d2205362a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe20ab9c977fc0ebe96cb4f4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d4cf318c37d0cf318a377628aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b13232d375f70dd13530b3323080b9010026142ba7 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 935800 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_1@syncoid_iox86_2024-12-19:16:55:58-GMT-06:00 ... syncoid_iox86_2024-12-19:17:10:54-GMT-06:00 (~ 1.2 MB):
 932KiB 0:00:00 [6.78MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_1/l1_1/l2_0@autosnap_2024-12-19_22:30:07_frequently ... syncoid_iox86_2024-12-19:17:10:56-GMT-06:00 (~ 1.8 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-19:16:40:55-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 499KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_0'@'autosnap_2024-12-19_22:30:07_frequently' 'send/test/l0_1/l1_1/l2_0'@'syncoid_iox86_2024-12-19:17:10:56-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1836864 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-19:16:56:02-GMT-06:00 ... syncoid_iox86_2024-12-19:17:10:58-GMT-06:00 (~ 498 KB):
 398KiB 0:00:00 [2.83MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-19:16:56:04-GMT-06:00 ... syncoid_iox86_2024-12-19:17:11:00-GMT-06:00 (~ 662 KB):
 541KiB 0:00:00 [3.70MiB/s] [================================================================================>                   ] 81%            
Resuming interrupted zfs send/receive from send/test/l0_1/l1_1/l2_3 to recv/test/l0_1/l1_1/l2_3 (~ 601 KB remaining):
warning: cannot send 'send/test/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-19:16:25:54-GMT-06:00': Input/output error
 408 B 0:00:00 [5.59KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11c3a6aed0-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1bedd5d59377b023f2900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bae1e8b14e34b5c362f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc7104418c51b3b1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5919995a999ae8bafb86e81a98591918c0dc0000cbf32d4c
CRITICAL ERROR:  zfs send  -t 1-11c3a6aed0-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1bedd5d59377b023f2900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bae1e8b14e34b5c362f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc7104418c51b3b1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5919995a999ae8bafb86e81a98591918c0dc0000cbf32d4c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 615760 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_2 to recv/test/l0_1/l1_2 (~ 781 KB remaining):
warning: cannot send 'send/test/l0_1/l1_2@syncoid_iox86_2024-12-19:16:10:39-GMT-06:00': Input/output error
8.34KiB 0:00:00 [ 162KiB/s] [>                                                                                                   ]  1%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-12c765b085-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e0e2e662f129d1fb14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec41532e1e96c9ba43f1f8e4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d4cf318c377228aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b032b6d475f70dd13530b3323000db0d00bdab29e2
CRITICAL ERROR:  zfs send  -t 1-12c765b085-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e0e2e662f129d1fb14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec41532e1e96c9ba43f1f8e4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d4cf318c377228aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b032b6d475f70dd13530b3323000db0d00bdab29e2 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 800448 |  zfs receive  -s -F 'recv/test/l0_1/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_2/l2_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:17:11:03-GMT-06:00 (~ 6.0 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:24:41-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:40:11-GMT-06:00': Invalid argument
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 328KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_1/l1_2/l2_0'@'syncoid_iox86_2024-12-19:17:11:03-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 6298240 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-19:15:55:27-GMT-06:00 ... syncoid_iox86_2024-12-19:17:11:06-GMT-06:00 (~ 3.7 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_1@autosnap_2024-12-19_22:00:37_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 383KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-19:15:55:27-GMT-06:00' 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-19:17:11:06-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3899376 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_2/l2_2 to recv/test/l0_1/l1_2/l2_2 (~ 441 KB remaining):
internal error: warning: cannot send 'send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-19:15:24:46-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-10c0c26d5d-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c119ee6bd985a9cf1415806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415c2fbb6ac5820c35a9e8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa89f63186fa49f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a6564626562a6ebee1ba26b6066656000730300a3612bd3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 451736 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-19:16:56:12-GMT-06:00 ... syncoid_iox86_2024-12-19:17:11:08-GMT-06:00 (~ 618 KB):
 401KiB 0:00:00 [2.87MiB/s] [===============================================================>                                    ] 64%            
Resuming interrupted zfs send/receive from send/test/l0_1/l1_3 to recv/test/l0_1/l1_3 (~ 1.4 MB remaining):
warning: cannot send 'send/test/l0_1/l1_3@syncoid_iox86_2024-12-19:16:10:48-GMT-06:00': Input/output error
2.09KiB 0:00:00 [18.7KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-10a8cedad3-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e802cf8827d51fca14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4157aef0ebc7f13e6f52402499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccad0c0cac442d7dd3744d7c0cccac0006c370009f72c68
CRITICAL ERROR:  zfs send  -t 1-10a8cedad3-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e802cf8827d51fca14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4157aef0ebc7f13e6f52402499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccad0c0cac442d7dd3744d7c0cccac0006c370009f72c68 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1477208 |  zfs receive  -s -F 'recv/test/l0_1/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_3/l2_0 to recv/test/l0_1/l1_3/l2_0 (~ 913 KB remaining):
warning: cannot send 'send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-19:15:24:52-GMT-06:00': Input/output error
1.01KiB 0:00:00 [10.1KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-14f1ada464-118-789c636064000310a501c49c50360710a715e5e7a69766a63040418addc3edb7bfcc105400b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f910579857b1fed8fe8dd33b01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730de583fc728dec0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8c4cad448d7dd3744d7c0cccac000e606006a502cd6
CRITICAL ERROR:  zfs send  -t 1-14f1ada464-118-789c636064000310a501c49c50360710a715e5e7a69766a63040418addc3edb7bfcc105400b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f910579857b1fed8fe8dd33b01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730de583fc728dec0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8c4cad448d7dd3744d7c0cccac000e606006a502cd6 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 935800 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-19:16:56:15-GMT-06:00 ... syncoid_iox86_2024-12-19:17:11:11-GMT-06:00 (~ 558 KB):
 401KiB 0:00:00 [2.89MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-19:16:56:17-GMT-06:00 ... syncoid_iox86_2024-12-19:17:11:14-GMT-06:00 (~ 706 KB):
 537KiB 0:00:00 [2.37MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-19:16:56:19-GMT-06:00 ... syncoid_iox86_2024-12-19:17:11:16-GMT-06:00 (~ 1.9 MB):
1.28MiB 0:00:00 [2.86MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_2@syncoid_iox86_2024-12-19:16:56:21-GMT-06:00 ... syncoid_iox86_2024-12-19:17:11:18-GMT-06:00 (~ 1.1 MB):
 818KiB 0:00:00 [2.83MiB/s] [=====================================================================>                              ] 70%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_0 to recv/test/l0_2/l1_0 (~ 172 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_0@syncoid_iox86_2024-12-19:15:25:02-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-13c9ed8a18-110-789c636064000310a501c49c50360710a715e5e7a69766a6304041f15cde74936d7c350a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a904dbc359336a67d8c4092e704cbe725e6a602dd979a97a20f34aa443fc720de483fc730dec0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cac048d7dd3744d7c0cccac0006c3700a3a12a2c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 176936 |  zfs receive  -s -F 'recv/test/l0_2/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-19:16:56:24-GMT-06:00 ... syncoid_iox86_2024-12-19:17:11:21-GMT-06:00 (~ 1.2 MB):
 944KiB 0:00:00 [2.74MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_2/l1_0/l2_1@autosnap_2024-12-19_22:30:07_frequently ... syncoid_iox86_2024-12-19:17:11:24-GMT-06:00 (~ 2.8 MB):
warning: cannot send 'send/test/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-19:16:41:25-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_2/l1_0/l2_1@autosnap_2024-12-19_23:00:27_hourly': Invalid argument
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 488KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_0/l2_1'@'autosnap_2024-12-19_22:30:07_frequently' 'send/test/l0_2/l1_0/l2_1'@'syncoid_iox86_2024-12-19:17:11:24-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2952816 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_0/l2_2 to recv/test/l0_2/l1_0/l2_2 (~ 585 KB remaining):
warning: cannot send 'send/test/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-19:15:25:09-GMT-06:00': Input/output error
6.00KiB 0:00:00 [50.6KiB/s] [>                                                                                                   ]  1%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11afa6c057-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c187d56e616f8fb13c5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057b84d89e20ee3377c9d8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa09f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6560a9ebee1ba26b606665600073030027ef2c0c
CRITICAL ERROR:  zfs send  -t 1-11afa6c057-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c187d56e616f8fb13c5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057b84d89e20ee3377c9d8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa09f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6560a9ebee1ba26b606665600073030027ef2c0c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 599376 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-19:16:56:28-GMT-06:00 ... syncoid_iox86_2024-12-19:17:11:26-GMT-06:00 (~ 1.2 MB):
 905KiB 0:00:00 [2.60MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_2/l1_1@syncoid_iox86_2024-12-19:16:56:30-GMT-06:00 ... syncoid_iox86_2024-12-19:17:11:28-GMT-06:00 (~ 1.6 MB):
warning: cannot send 'send/test/l0_2/l1_1@autosnap_2024-12-19_23:00:27_hourly': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_1 does not
match incremental source
64.0KiB 0:00:00 [ 403KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_1'@'syncoid_iox86_2024-12-19:16:56:30-GMT-06:00' 'send/test/l0_2/l1_1'@'syncoid_iox86_2024-12-19:17:11:28-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1675248 |  zfs receive  -s -F 'recv/test/l0_2/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-19:16:56:33-GMT-06:00 ... syncoid_iox86_2024-12-19:17:11:30-GMT-06:00 (~ 1.8 MB):
1.32MiB 0:00:00 [3.72MiB/s] [========================================================================>                           ] 73%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_1/l2_1 to recv/test/l0_2/l1_1/l2_1 (~ 721 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-19:15:25:18-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-ff823389f-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1222bc149011dceef15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4151f5e86aa54575f399a8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa89f63146fe8505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6568a1ebee1ba26b6066656000730300d8b82ce2 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 738824 |  zfs receive  -s -F 'recv/test/l0_2/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-19:16:56:35-GMT-06:00 ... syncoid_iox86_2024-12-19:17:11:33-GMT-06:00 (~ 1.5 MB):
1.18MiB 0:00:00 [3.27MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-19:16:56:38-GMT-06:00 ... syncoid_iox86_2024-12-19:17:11:35-GMT-06:00 (~ 1.8 MB):
1.29MiB 0:00:00 [3.74MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_2/l1_2@autosnap_2024-12-19_22:30:07_frequently ... syncoid_iox86_2024-12-19:17:11:38-GMT-06:00 (~ 2.3 MB):
warning: cannot send 'send/test/l0_2/l1_2@syncoid_iox86_2024-12-19:16:41:39-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 511KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_2'@'autosnap_2024-12-19_22:30:07_frequently' 'send/test/l0_2/l1_2'@'syncoid_iox86_2024-12-19:17:11:38-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2439896 |  zfs receive  -s -F 'recv/test/l0_2/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_2/l2_0@syncoid_iox86_2024-12-19:16:56:42-GMT-06:00 ... syncoid_iox86_2024-12-19:17:11:40-GMT-06:00 (~ 1.4 MB):
1.06MiB 0:00:00 [3.07MiB/s] [=============================================================================>                      ] 78%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_2/l2_1 to recv/test/l0_2/l1_2/l2_1 (~ 721 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_2/l2_1@syncoid_iox86_2024-12-19:16:11:25-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-1401815849-118-789c636064000310a501c49c50360710a715e5e7a69766a630408169bb71866b7259970290cd8ea42e3f292b35b904c207010cf9b4b4e2d412063800c9b321c9275596a41633a0ca23eb2fc987b8a2bfb4f74661828a6502923c27583e2f31379581a138352f451f6854897e8e41bc917e8e2188308a377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b43232d575f70dd13530b3323080b90100d6e62b09 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 738824 |  zfs receive  -s -F 'recv/test/l0_2/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_2/l2_2@syncoid_iox86_2024-12-19:16:56:45-GMT-06:00 ... syncoid_iox86_2024-12-19:17:11:42-GMT-06:00 (~ 1.5 MB):
1.19MiB 0:00:00 [3.40MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_2/l1_2/l2_3@syncoid_iox86_2024-12-19:16:56:47-GMT-06:00 ... syncoid_iox86_2024-12-19:17:11:45-GMT-06:00 (~ 1.4 MB):
1.18MiB 0:00:00 [3.41MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/l0_2/l1_3@syncoid_iox86_2024-12-19:16:56:49-GMT-06:00 ... syncoid_iox86_2024-12-19:17:11:47-GMT-06:00 (~ 1.5 MB):
warning: cannot send 'send/test/l0_2/l1_3@autosnap_2024-12-19_23:00:27_hourly': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_3 does not
match incremental source
64.0KiB 0:00:00 [ 393KiB/s] [===>                                                                                                ]  4%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3'@'syncoid_iox86_2024-12-19:16:56:49-GMT-06:00' 'send/test/l0_2/l1_3'@'syncoid_iox86_2024-12-19:17:11:47-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1613808 |  zfs receive  -s -F 'recv/test/l0_2/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_0 to recv/test/l0_2/l1_3/l2_0 (~ 805 KB remaining):
warning: cannot send 'send/test/l0_2/l1_3/l2_0@syncoid_iox86_2024-12-19:15:25:37-GMT-06:00': Input/output error
3.66KiB 0:00:00 [26.1KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-13257a23ca-118-789c636064000310a501c49c50360710a715e5e7a69766a63040811793597dc5b5386d05209b1d495d7e52566a7209840f0218f26969c5a9250c7000926743924faa2c492d66409547d65f920f71c5fbb9227763bfec0c494092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d2cf318c37d6cf318a377028aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b53236d775f70dd13530b3323080b90100368a2c2d
CRITICAL ERROR:  zfs send  -t 1-13257a23ca-118-789c636064000310a501c49c50360710a715e5e7a69766a63040811793597dc5b5386d05209b1d495d7e52566a7209840f0218f26969c5a9250c7000926743924faa2c492d66409547d65f920f71c5fbb9227763bfec0c494092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d2cf318c37d6cf318a377028aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b53236d775f70dd13530b3323080b90100368a2c2d | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 825024 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_1 to recv/test/l0_2/l1_3/l2_1 (~ 557 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-19:15:25:39-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-14c7859310-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1459fa97f6772eabe5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057a42cf1b39e5e29783601499e132c9f97989bcac0509c9a97a20f34aa443fc720de483fc730de583fc728ded0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cad852d7dd3744d7c0cccac000e6060018eb2c68 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 570704 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_3/l2_2@syncoid_iox86_2024-12-19:16:56:52-GMT-06:00 ... syncoid_iox86_2024-12-19:17:11:50-GMT-06:00 (~ 1.1 MB):
warning: cannot send 'send/test/l0_2/l1_3/l2_2@autosnap_2024-12-19_23:00:27_hourly': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_3/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 383KiB/s] [====>                                                                                               ]  5%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_2'@'syncoid_iox86_2024-12-19:16:56:52-GMT-06:00' 'send/test/l0_2/l1_3/l2_2'@'syncoid_iox86_2024-12-19:17:11:50-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1170704 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_3 to recv/test/l0_2/l1_3/l2_3 (~ 629 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-19:15:25:44-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-14bb428d41-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c193fcf2ca3fbbf6592900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b6a5e1844ad2cbeb03f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de483fc730de583fc728ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cac444d7dd3744d7c0cccac000e6060004302e05 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 644432 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:17:11:52-GMT-06:00 (~ 7.1 MB):
warning: cannot send 'send/test/l0_3@syncoid_iox86_2024-12-19:15:25:45-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 288KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_3'@'syncoid_iox86_2024-12-19:17:11:52-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 7433936 |  zfs receive  -s -F 'recv/test/l0_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_0 to recv/test/l0_3/l1_0 (~ 1.5 MB remaining):
warning: cannot send 'send/test/l0_3/l1_0@syncoid_iox86_2024-12-19:15:25:47-GMT-06:00': Input/output error
3.66KiB 0:00:00 [31.2KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-125adfe068-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c17716fba2b593971d5700b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057541fa9bef9519ceb5c04923c27583e2f31379581a138352f451f6854897e8e41bcb17e8e61bc814371655e727e664a7c667e858559bc91819189aea191aea1a595a1a99591a99589b9aebb6f88ae8199958101d86e00f7a72be1
CRITICAL ERROR:  zfs send  -t 1-125adfe068-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c17716fba2b593971d5700b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057541fa9bef9519ceb5c04923c27583e2f31379581a138352f451f6854897e8e41bcb17e8e61bc814371655e727e664a7c667e858559bc91819189aea191aea1a595a1a99591a99589b9aebb6f88ae8199958101d86e00f7a72be1 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1526360 |  zfs receive  -s -F 'recv/test/l0_3/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_0/l2_0@syncoid_iox86_2024-12-19:16:56:57-GMT-06:00 ... syncoid_iox86_2024-12-19:17:11:55-GMT-06:00 (~ 1.3 MB):
1.00MiB 0:00:00 [2.90MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_3/l1_0/l2_1@syncoid_iox86_2024-12-19:16:56:59-GMT-06:00 ... syncoid_iox86_2024-12-19:17:11:57-GMT-06:00 (~ 1.6 MB):
1.18MiB 0:00:00 [3.35MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_3/l1_0/l2_2@syncoid_iox86_2024-12-19:16:57:01-GMT-06:00 ... syncoid_iox86_2024-12-19:17:12:00-GMT-06:00 (~ 1.2 MB):
 940KiB 0:00:00 [2.67MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_3/l1_0/l2_3@syncoid_iox86_2024-12-19:16:57:04-GMT-06:00 ... syncoid_iox86_2024-12-19:17:12:02-GMT-06:00 (~ 1.6 MB):
1.19MiB 0:00:00 [3.46MiB/s] [===========================================================================>                        ] 76%            
Resuming interrupted zfs send/receive from send/test/l0_3/l1_1 to recv/test/l0_3/l1_1 (~ 877 KB remaining):
warning: cannot send 'send/test/l0_3/l1_1@syncoid_iox86_2024-12-19:15:41:19-GMT-06:00': Input/output error
9.12KiB 0:00:00 [89.1KiB/s] [>                                                                                                   ]  1%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-125df0eeb4-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1a76f724ab5d752d314806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415abb53e8b33be29ef894092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d6cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53231b432b4d475f70dd13530b3323000db0d00ab4b2b28
CRITICAL ERROR:  zfs send  -t 1-125df0eeb4-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1a76f724ab5d752d314806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415abb53e8b33be29ef894092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d6cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53231b432b4d475f70dd13530b3323000db0d00ab4b2b28 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 898752 |  zfs receive  -s -F 'recv/test/l0_3/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_1/l2_0@syncoid_iox86_2024-12-19:16:57:06-GMT-06:00 ... syncoid_iox86_2024-12-19:17:12:05-GMT-06:00 (~ 1.4 MB):
1.07MiB 0:00:00 [3.14MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_3/l1_1/l2_1@syncoid_iox86_2024-12-19:16:57:09-GMT-06:00 ... syncoid_iox86_2024-12-19:17:12:07-GMT-06:00 (~ 922 KB):
 649KiB 0:00:00 [1.91MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_3/l1_1/l2_2@autosnap_2024-12-19_22:30:07_frequently ... syncoid_iox86_2024-12-19:17:12:10-GMT-06:00 (~ 2.7 MB):
warning: cannot send 'send/test/l0_3/l1_1/l2_2@syncoid_iox86_2024-12-19:16:42:13-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 307KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_1/l2_2'@'autosnap_2024-12-19_22:30:07_frequently' 'send/test/l0_3/l1_1/l2_2'@'syncoid_iox86_2024-12-19:17:12:10-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2817096 |  zfs receive  -s -F 'recv/test/l0_3/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_1/l2_3@syncoid_iox86_2024-12-19:16:57:13-GMT-06:00 ... syncoid_iox86_2024-12-19:17:12:12-GMT-06:00 (~ 1.5 MB):
1.18MiB 0:00:00 [3.53MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_3/l1_2@syncoid_iox86_2024-12-19:16:57:15-GMT-06:00 ... syncoid_iox86_2024-12-19:17:12:14-GMT-06:00 (~ 1.2 MB):
 948KiB 0:00:00 [2.97MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_3/l1_2/l2_0@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:17:12:16-GMT-06:00 (~ 6.6 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_0@syncoid_iox86_2024-12-19:15:41:33-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_2/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 298KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_0'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_3/l1_2/l2_0'@'syncoid_iox86_2024-12-19:17:12:16-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 6932240 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2/l2_1@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:17:12:18-GMT-06:00 (~ 5.7 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_1@syncoid_iox86_2024-12-19:15:41:35-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 361KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_1'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_3/l1_2/l2_1'@'syncoid_iox86_2024-12-19:17:12:18-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 6025736 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2/l2_2@syncoid_iox86_2024-12-19:16:57:22-GMT-06:00 ... syncoid_iox86_2024-12-19:17:12:20-GMT-06:00 (~ 1.0 MB):
 803KiB 0:00:00 [2.30MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_3/l1_2/l2_3@syncoid_iox86_2024-12-19:16:57:24-GMT-06:00 ... syncoid_iox86_2024-12-19:17:12:23-GMT-06:00 (~ 1.1 MB):
 878KiB 0:00:00 [2.57MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_3/l1_3@syncoid_iox86_2024-12-19:16:57:26-GMT-06:00 ... syncoid_iox86_2024-12-19:17:12:25-GMT-06:00 (~ 1.5 MB):
1.06MiB 0:00:00 [3.36MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_3/l1_3/l2_0@syncoid_iox86_2024-12-19:16:57:28-GMT-06:00 ... syncoid_iox86_2024-12-19:17:12:27-GMT-06:00 (~ 1.3 MB):
 944KiB 0:00:00 [2.74MiB/s] [====================================================================>                               ] 69%            
Resuming interrupted zfs send/receive from send/test/l0_3/l1_3/l2_1 to recv/test/l0_3/l1_3/l2_1 (~ 380 KB remaining):
warning: cannot send 'send/test/l0_3/l1_3/l2_1@syncoid_iox86_2024-12-19:15:26:24-GMT-06:00': Input/output error
6.00KiB 0:00:00 [55.0KiB/s] [>                                                                                                   ]  1%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1207838ecb-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1b68fb9cbf98eafae5000b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f9105708dd7c3dcdf440bf4c02923c27583e2f31379581a138352f451f6854897e8e41bcb17e8e2188308a377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b30272dd7d43740dccac0c0c606e000094ae2d38
CRITICAL ERROR:  zfs send  -t 1-1207838ecb-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1b68fb9cbf98eafae5000b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f9105708dd7c3dcdf440bf4c02923c27583e2f31379581a138352f451f6854897e8e41bcb17e8e2188308a377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b30272dd7d43740dccac0c0c606e000094ae2d38 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 390112 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_3/l2_2@autosnap_2024-12-19_22:00:37_frequently ... syncoid_iox86_2024-12-19:17:12:30-GMT-06:00 (~ 4.0 MB):
warning: cannot send 'send/test/l0_3/l1_3/l2_2@syncoid_iox86_2024-12-19:16:12:20-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 424KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3/l2_2'@'autosnap_2024-12-19_22:00:37_frequently' 'send/test/l0_3/l1_3/l2_2'@'syncoid_iox86_2024-12-19:17:12:30-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4177024 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_3/l2_3 to recv/test/l0_3/l1_3/l2_3 (~ 589 KB remaining):
internal error: warning: cannot send 'send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-19:15:26:29-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-118b3c37f5-118-789c636064000310a501c49c50360710a715e5e7a69766a630408145cff65f8b5a247914806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415f2219fbfbfbf12cc9c8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fac9f6308228ce28d1d8a2bf392f33353e233f32b2ccce28d0c8c4c740d8d740d2dad0c4dad8cccac8c2c75dd7d43740dccac0c0c606e0000e4702cb6 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 603472 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
real 149.15
user 14.96
sys 119.74
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
config:

        NAME                            STATE     READ WRITE CKSUM
        send                            ONLINE       0     0     0
          wwn-0x5002538d40dca5d9-part7  ONLINE       0     0     0
errors: List of errors unavailable: permission denied

errors: 95 data errors, use '-v' for a list


CRITICAL ERROR: Target recv exists but has no snapshots matching with send!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.

Sending incremental send/test@syncoid_iox86_2024-12-19:17:10:03-GMT-06:00 ... syncoid_iox86_2024-12-19:17:25:03-GMT-06:00 (~ 4 KB):
2.13KiB 0:00:00 [30.6KiB/s] [====================================================>                                               ] 53%            
Sending incremental send/test/l0_0@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:17:25:04-GMT-06:00 (~ 1.8 MB):
warning: cannot send 'send/test/l0_0@syncoid_iox86_2024-12-19:16:55:08-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
68.0KiB 0:00:00 [ 426KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x21000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0'@'syncoid_iox86_2024-12-19:17:25:04-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1894392 |  zfs receive  -s -F 'recv/test/l0_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_0@syncoid_iox86_2024-12-19:17:10:07-GMT-06:00 ... syncoid_iox86_2024-12-19:17:25:06-GMT-06:00 (~ 1.0 MB):
 825KiB 0:00:00 [3.66MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-19:17:10:09-GMT-06:00 ... syncoid_iox86_2024-12-19:17:25:08-GMT-06:00 (~ 1.5 MB):
1.17MiB 0:00:00 [4.76MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-19:17:10:11-GMT-06:00 ... syncoid_iox86_2024-12-19:17:25:11-GMT-06:00 (~ 1.0 MB):
 809KiB 0:00:00 [3.32MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_0/l1_0/l2_2@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:17:25:13-GMT-06:00 (~ 8.1 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-19:15:39:11-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_0/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 283KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_2'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_0/l1_0/l2_2'@'syncoid_iox86_2024-12-19:17:25:13-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 8488448 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_0/l2_3@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:17:25:15-GMT-06:00 (~ 2.4 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-19:16:55:19-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_0/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 372KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_3'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0/l1_0/l2_3'@'syncoid_iox86_2024-12-19:17:25:15-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2501520 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1 to recv/test/l0_0/l1_1 (~ 765 KB remaining):
internal error: warning: cannot send 'send/test/l0_0/l1_1@syncoid_iox86_2024-12-19:15:23:43-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-11a7fcef30-110-789c636064000310a501c49c50360710a715e5e7a69766a63040812cfbeff43ac69b310a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a857d1e9723d5bead8d4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d0cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b63231d675f70dd13530b3323000db0d00f6802ab3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 783880 |  zfs receive  -s -F 'recv/test/l0_0/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-19:17:10:18-GMT-06:00 ... syncoid_iox86_2024-12-19:17:25:18-GMT-06:00 (~ 1.3 MB):
1.03MiB 0:00:00 [4.16MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-19:17:10:21-GMT-06:00 ... syncoid_iox86_2024-12-19:17:25:20-GMT-06:00 (~ 894 KB):
 680KiB 0:00:00 [2.75MiB/s] [===========================================================================>                        ] 76%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1/l2_2 to recv/test/l0_0/l1_1/l2_2 (~ 841 KB remaining):
internal error: warning: cannot send 'send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-19:15:39:20-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-129b2dd437-118-789c636064000310a501c49c50360710a715e5e7a69766a63040013b8b465497715aa802888da42e3f292b35b904c207010cf9b4b4e2d412063800c9b321c9275596a41633a0ca23eb2fc987b8e2faa903a25b34df182420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61beae718c51b391457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1919e8bafb86e81a98591918c0dc00004b072ae9 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 861888 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1/l2_3 to recv/test/l0_0/l1_1/l2_3 (~ 913 KB remaining):
warning: cannot send 'send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-19:15:39:22-GMT-06:00': Input/output error
 408 B 0:00:00 [4.17KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1136c0efbd-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041d3b6c3921ba7f09d5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057d8f4bf9952bfe4dbe10424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837803fd1cc37843fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b634b2b23235d77df105d03332b0303981b0090282dd3
CRITICAL ERROR:  zfs send  -t 1-1136c0efbd-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041d3b6c3921ba7f09d5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057d8f4bf9952bfe4dbe10424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837803fd1cc37843fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b634b2b23235d77df105d03332b0303981b0090282dd3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 935800 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_2@syncoid_iox86_2024-12-19:17:10:24-GMT-06:00 ... syncoid_iox86_2024-12-19:17:25:23-GMT-06:00 (~ 1.4 MB):
1.02MiB 0:00:00 [4.53MiB/s] [======================================================================>                             ] 71%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_2/l2_0 to recv/test/l0_0/l1_2/l2_0 (~ 781 KB remaining):
warning: cannot send 'send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-19:15:39:26-GMT-06:00': Input/output error
 408 B 0:00:00 [3.51KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11d384ec20-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c142be63273a9bb6c62900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bd4ec24bf987ee23f998024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fa49f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656c696564a6ebee1ba26b6066656000730300ff272c45
CRITICAL ERROR:  zfs send  -t 1-11d384ec20-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c142be63273a9bb6c62900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bd4ec24bf987ee23f998024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fa49f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656c696564a6ebee1ba26b6066656000730300ff272c45 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 800448 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_2/l2_1 to recv/test/l0_0/l1_2/l2_1 (~ 677 KB remaining):
warning: cannot send 'send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-19:15:39:28-GMT-06:00': Input/output error
 408 B 0:00:00 [3.75KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-127e44ff0a-118-789c636064000310a501c49c50360710a715e5e7a69766a630408154cbf596c2961b1a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28aa97713ed98eb959f2420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61be9e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1959e8bafb86e81a98591918c0dc0000b0b52c05
CRITICAL ERROR:  zfs send  -t 1-127e44ff0a-118-789c636064000310a501c49c50360710a715e5e7a69766a630408154cbf596c2961b1a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28aa97713ed98eb959f2420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61be9e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1959e8bafb86e81a98591918c0dc0000b0b52c05 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 693768 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-19:17:10:27-GMT-06:00 ... syncoid_iox86_2024-12-19:17:25:26-GMT-06:00 (~ 1.4 MB):
1.06MiB 0:00:00 [4.28MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-19:17:10:29-GMT-06:00 ... syncoid_iox86_2024-12-19:17:25:28-GMT-06:00 (~ 1.2 MB):
 921KiB 0:00:00 [3.77MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_0/l1_3@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:17:25:30-GMT-06:00 (~ 3.3 MB):
warning: cannot send 'send/test/l0_0/l1_3@syncoid_iox86_2024-12-19:16:55:34-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3 does not
match incremental source
64.0KiB 0:00:00 [ 411KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0/l1_3'@'syncoid_iox86_2024-12-19:17:25:30-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3424408 |  zfs receive  -s -F 'recv/test/l0_0/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_3/l2_0@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:17:25:32-GMT-06:00 (~ 2.4 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-19:16:55:36-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 353KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_0'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0/l1_3/l2_0'@'syncoid_iox86_2024-12-19:17:25:32-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2562776 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-19:17:10:35-GMT-06:00 ... syncoid_iox86_2024-12-19:17:25:34-GMT-06:00 (~ 1.6 MB):
1.31MiB 0:00:00 [5.13MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-19:17:10:38-GMT-06:00 ... syncoid_iox86_2024-12-19:17:25:37-GMT-06:00 (~ 1.2 MB):
 952KiB 0:00:00 [3.89MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_0/l1_3/l2_3@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:17:25:39-GMT-06:00 (~ 7.3 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-19:15:39:44-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 285KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_3'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_0/l1_3/l2_3'@'syncoid_iox86_2024-12-19:17:25:39-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 7704640 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1@syncoid_iox86_2024-12-19:17:10:42-GMT-06:00 ... syncoid_iox86_2024-12-19:17:25:41-GMT-06:00 (~ 1.9 MB):
1.44MiB 0:00:00 [6.73MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_1/l1_0@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:17:25:43-GMT-06:00 (~ 7.9 MB):
warning: cannot send 'send/test/l0_1/l1_0@syncoid_iox86_2024-12-19:15:39:47-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_0 does not
match incremental source
64.0KiB 0:00:00 [ 294KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_1/l1_0'@'syncoid_iox86_2024-12-19:17:25:43-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 8303208 |  zfs receive  -s -F 'recv/test/l0_1/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-19:17:10:46-GMT-06:00 ... syncoid_iox86_2024-12-19:17:25:45-GMT-06:00 (~ 1.2 MB):
 954KiB 0:00:00 [3.78MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-19:17:10:48-GMT-06:00 ... syncoid_iox86_2024-12-19:17:25:47-GMT-06:00 (~ 625 KB):
 540KiB 0:00:00 [2.25MiB/s] [=====================================================================================>              ] 86%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-19:17:10:51-GMT-06:00 ... syncoid_iox86_2024-12-19:17:25:50-GMT-06:00 (~ 1.4 MB):
1.05MiB 0:00:00 [4.37MiB/s] [==========================================================================>                         ] 75%            
Resuming interrupted zfs send/receive from send/test/l0_1/l1_0/l2_3 to recv/test/l0_1/l1_0/l2_3 (~ 913 KB remaining):
warning: cannot send 'send/test/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-19:15:24:26-GMT-06:00': Input/output error
6.00KiB 0:00:00 [50.3KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1115fe3a2e-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041eeacba2d2205362a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe20ab9c977fc0ebe96cb4f4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d4cf318c37d0cf318a377628aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b13232d375f70dd13530b3323080b9010026142ba7
CRITICAL ERROR:  zfs send  -t 1-1115fe3a2e-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041eeacba2d2205362a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe20ab9c977fc0ebe96cb4f4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d4cf318c37d0cf318a377628aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b13232d375f70dd13530b3323080b9010026142ba7 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 935800 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_1@syncoid_iox86_2024-12-19:17:10:54-GMT-06:00 ... syncoid_iox86_2024-12-19:17:25:52-GMT-06:00 (~ 1.3 MB):
1.05MiB 0:00:00 [4.47MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_1/l1_1/l2_0@autosnap_2024-12-19_22:30:07_frequently ... syncoid_iox86_2024-12-19:17:25:54-GMT-06:00 (~ 2.8 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-19:16:40:55-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_1/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 344KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_0'@'autosnap_2024-12-19_22:30:07_frequently' 'send/test/l0_1/l1_1/l2_0'@'syncoid_iox86_2024-12-19:17:25:54-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2965984 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-19:17:10:58-GMT-06:00 ... syncoid_iox86_2024-12-19:17:25:57-GMT-06:00 (~ 1.2 MB):
 935KiB 0:00:00 [3.82MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-19:17:11:00-GMT-06:00 ... syncoid_iox86_2024-12-19:17:25:59-GMT-06:00 (~ 1.2 MB):
 944KiB 0:00:00 [3.80MiB/s] [===========================================================================>                        ] 76%            
Resuming interrupted zfs send/receive from send/test/l0_1/l1_1/l2_3 to recv/test/l0_1/l1_1/l2_3 (~ 601 KB remaining):
warning: cannot send 'send/test/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-19:16:25:54-GMT-06:00': Input/output error
 408 B 0:00:00 [5.74KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11c3a6aed0-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1bedd5d59377b023f2900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bae1e8b14e34b5c362f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc7104418c51b3b1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5919995a999ae8bafb86e81a98591918c0dc0000cbf32d4c
CRITICAL ERROR:  zfs send  -t 1-11c3a6aed0-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1bedd5d59377b023f2900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bae1e8b14e34b5c362f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc7104418c51b3b1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5919995a999ae8bafb86e81a98591918c0dc0000cbf32d4c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 615760 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_2 to recv/test/l0_1/l1_2 (~ 781 KB remaining):
warning: cannot send 'send/test/l0_1/l1_2@syncoid_iox86_2024-12-19:16:10:39-GMT-06:00': Input/output error
8.34KiB 0:00:00 [ 146KiB/s] [>                                                                                                   ]  1%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-12c765b085-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e0e2e662f129d1fb14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec41532e1e96c9ba43f1f8e4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d4cf318c377228aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b032b6d475f70dd13530b3323000db0d00bdab29e2
CRITICAL ERROR:  zfs send  -t 1-12c765b085-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e0e2e662f129d1fb14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec41532e1e96c9ba43f1f8e4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d4cf318c377228aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b032b6d475f70dd13530b3323000db0d00bdab29e2 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 800448 |  zfs receive  -s -F 'recv/test/l0_1/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_2/l2_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:17:26:02-GMT-06:00 (~ 7.0 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:24:41-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:40:11-GMT-06:00': Invalid argument
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 308KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_1/l1_2/l2_0'@'syncoid_iox86_2024-12-19:17:26:02-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 7353448 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-19:15:55:27-GMT-06:00 ... syncoid_iox86_2024-12-19:17:26:04-GMT-06:00 (~ 4.8 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_1@autosnap_2024-12-19_22:00:37_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 384KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-19:15:55:27-GMT-06:00' 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-19:17:26:04-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5040784 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_2/l2_2 to recv/test/l0_1/l1_2/l2_2 (~ 441 KB remaining):
internal error: warning: cannot send 'send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-19:15:24:46-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-10c0c26d5d-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c119ee6bd985a9cf1415806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415c2fbb6ac5820c35a9e8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa89f63186fa49f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a6564626562a6ebee1ba26b6066656000730300a3612bd3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 451736 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-19:17:11:08-GMT-06:00 ... syncoid_iox86_2024-12-19:17:26:07-GMT-06:00 (~ 1.2 MB):
 946KiB 0:00:00 [3.83MiB/s] [============================================================================>                       ] 77%            
Resuming interrupted zfs send/receive from send/test/l0_1/l1_3 to recv/test/l0_1/l1_3 (~ 1.4 MB remaining):
warning: cannot send 'send/test/l0_1/l1_3@syncoid_iox86_2024-12-19:16:10:48-GMT-06:00': Input/output error
2.88KiB 0:00:00 [25.6KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-10a8cedad3-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e802cf8827d51fca14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4157aef0ebc7f13e6f52402499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccad0c0cac442d7dd3744d7c0cccac0006c370009f72c68
CRITICAL ERROR:  zfs send  -t 1-10a8cedad3-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e802cf8827d51fca14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4157aef0ebc7f13e6f52402499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccad0c0cac442d7dd3744d7c0cccac0006c370009f72c68 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1477208 |  zfs receive  -s -F 'recv/test/l0_1/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_3/l2_0 to recv/test/l0_1/l1_3/l2_0 (~ 913 KB remaining):
warning: cannot send 'send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-19:15:24:52-GMT-06:00': Input/output error
1.01KiB 0:00:00 [10.1KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-14f1ada464-118-789c636064000310a501c49c50360710a715e5e7a69766a63040418addc3edb7bfcc105400b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f910579857b1fed8fe8dd33b01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730de583fc728dec0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8c4cad448d7dd3744d7c0cccac000e606006a502cd6
CRITICAL ERROR:  zfs send  -t 1-14f1ada464-118-789c636064000310a501c49c50360710a715e5e7a69766a63040418addc3edb7bfcc105400b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f910579857b1fed8fe8dd33b01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730de583fc728dec0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8c4cad448d7dd3744d7c0cccac000e606006a502cd6 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 935800 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-19:17:11:11-GMT-06:00 ... syncoid_iox86_2024-12-19:17:26:10-GMT-06:00 (~ 1.2 MB):
 937KiB 0:00:00 [3.88MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-19:17:11:14-GMT-06:00 ... syncoid_iox86_2024-12-19:17:26:12-GMT-06:00 (~ 1.5 MB):
1.17MiB 0:00:00 [4.74MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-19:17:11:16-GMT-06:00 ... syncoid_iox86_2024-12-19:17:26:14-GMT-06:00 (~ 782 KB):
 540KiB 0:00:00 [2.25MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_2@syncoid_iox86_2024-12-19:17:11:18-GMT-06:00 ... syncoid_iox86_2024-12-19:17:26:16-GMT-06:00 (~ 722 KB):
 539KiB 0:00:00 [2.65MiB/s] [=========================================================================>                          ] 74%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_0 to recv/test/l0_2/l1_0 (~ 172 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_0@syncoid_iox86_2024-12-19:15:25:02-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-13c9ed8a18-110-789c636064000310a501c49c50360710a715e5e7a69766a6304041f15cde74936d7c350a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a904dbc359336a67d8c4092e704cbe725e6a602dd979a97a20f34aa443fc720de483fc730dec0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cac048d7dd3744d7c0cccac0006c3700a3a12a2c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 176936 |  zfs receive  -s -F 'recv/test/l0_2/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-19:17:11:21-GMT-06:00 ... syncoid_iox86_2024-12-19:17:26:19-GMT-06:00 (~ 365 KB):
 269KiB 0:00:00 [1.13MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_2/l1_0/l2_1@autosnap_2024-12-19_22:30:07_frequently ... syncoid_iox86_2024-12-19:17:26:21-GMT-06:00 (~ 3.9 MB):
warning: cannot send 'send/test/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-19:16:41:25-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_2/l1_0/l2_1@autosnap_2024-12-19_23:00:27_hourly': Invalid argument
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 423KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_0/l2_1'@'autosnap_2024-12-19_22:30:07_frequently' 'send/test/l0_2/l1_0/l2_1'@'syncoid_iox86_2024-12-19:17:26:21-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4102416 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_0/l2_2 to recv/test/l0_2/l1_0/l2_2 (~ 585 KB remaining):
warning: cannot send 'send/test/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-19:15:25:09-GMT-06:00': Input/output error
6.00KiB 0:00:00 [48.0KiB/s] [>                                                                                                   ]  1%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11afa6c057-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c187d56e616f8fb13c5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057b84d89e20ee3377c9d8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa09f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6560a9ebee1ba26b606665600073030027ef2c0c
CRITICAL ERROR:  zfs send  -t 1-11afa6c057-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c187d56e616f8fb13c5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057b84d89e20ee3377c9d8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa09f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6560a9ebee1ba26b606665600073030027ef2c0c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 599376 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-19:17:11:26-GMT-06:00 ... syncoid_iox86_2024-12-19:17:26:24-GMT-06:00 (~ 1.1 MB):
 796KiB 0:00:00 [3.36MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_2/l1_1@syncoid_iox86_2024-12-19:16:56:30-GMT-06:00 ... syncoid_iox86_2024-12-19:17:26:26-GMT-06:00 (~ 2.3 MB):
warning: cannot send 'send/test/l0_2/l1_1@autosnap_2024-12-19_23:00:27_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 537KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_1'@'syncoid_iox86_2024-12-19:16:56:30-GMT-06:00' 'send/test/l0_2/l1_1'@'syncoid_iox86_2024-12-19:17:26:26-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2459752 |  zfs receive  -s -F 'recv/test/l0_2/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-19:17:11:30-GMT-06:00 ... syncoid_iox86_2024-12-19:17:26:28-GMT-06:00 (~ 589 KB):
 415KiB 0:00:00 [1.69MiB/s] [=====================================================================>                              ] 70%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_1/l2_1 to recv/test/l0_2/l1_1/l2_1 (~ 721 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-19:15:25:18-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-ff823389f-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1222bc149011dceef15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4151f5e86aa54575f399a8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa89f63146fe8505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6568a1ebee1ba26b6066656000730300d8b82ce2 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 738824 |  zfs receive  -s -F 'recv/test/l0_2/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-19:17:11:33-GMT-06:00 ... syncoid_iox86_2024-12-19:17:26:31-GMT-06:00 (~ 766 KB):
 531KiB 0:00:00 [2.30MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-19:17:11:35-GMT-06:00 ... syncoid_iox86_2024-12-19:17:26:33-GMT-06:00 (~ 914 KB):
 670KiB 0:00:00 [2.65MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_2/l1_2@autosnap_2024-12-19_22:30:07_frequently ... syncoid_iox86_2024-12-19:17:26:35-GMT-06:00 (~ 3.0 MB):
warning: cannot send 'send/test/l0_2/l1_2@syncoid_iox86_2024-12-19:16:41:39-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
68.0KiB 0:00:00 [ 338KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x31000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_2'@'autosnap_2024-12-19_22:30:07_frequently' 'send/test/l0_2/l1_2'@'syncoid_iox86_2024-12-19:17:26:35-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3179344 |  zfs receive  -s -F 'recv/test/l0_2/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_2/l2_0@syncoid_iox86_2024-12-19:17:11:40-GMT-06:00 ... syncoid_iox86_2024-12-19:17:26:37-GMT-06:00 (~ 662 KB):
 544KiB 0:00:00 [2.19MiB/s] [=================================================================================>                  ] 82%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_2/l2_1 to recv/test/l0_2/l1_2/l2_1 (~ 721 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_2/l2_1@syncoid_iox86_2024-12-19:16:11:25-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-1401815849-118-789c636064000310a501c49c50360710a715e5e7a69766a630408169bb71866b7259970290cd8ea42e3f292b35b904c207010cf9b4b4e2d412063800c9b321c9275596a41633a0ca23eb2fc987b8a2bfb4f74661828a6502923c27583e2f31379581a138352f451f6854897e8e41bc917e8e2188308a377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b43232d575f70dd13530b3323080b90100d6e62b09 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 738824 |  zfs receive  -s -F 'recv/test/l0_2/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_2/l2_2@syncoid_iox86_2024-12-19:17:11:42-GMT-06:00 ... syncoid_iox86_2024-12-19:17:26:40-GMT-06:00 (~ 405 KB):
 371KiB 0:00:00 [1.52MiB/s] [==========================================================================================>         ] 91%            
Sending incremental send/test/l0_2/l1_2/l2_3@syncoid_iox86_2024-12-19:17:11:45-GMT-06:00 ... syncoid_iox86_2024-12-19:17:26:42-GMT-06:00 (~ 381 KB):
 272KiB 0:00:00 [1.11MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_2/l1_3@syncoid_iox86_2024-12-19:16:56:49-GMT-06:00 ... syncoid_iox86_2024-12-19:17:26:44-GMT-06:00 (~ 2.2 MB):
warning: cannot send 'send/test/l0_2/l1_3@autosnap_2024-12-19_23:00:27_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 530KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3'@'syncoid_iox86_2024-12-19:16:56:49-GMT-06:00' 'send/test/l0_2/l1_3'@'syncoid_iox86_2024-12-19:17:26:44-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2353256 |  zfs receive  -s -F 'recv/test/l0_2/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_0 to recv/test/l0_2/l1_3/l2_0 (~ 805 KB remaining):
warning: cannot send 'send/test/l0_2/l1_3/l2_0@syncoid_iox86_2024-12-19:15:25:37-GMT-06:00': Input/output error
3.66KiB 0:00:00 [28.3KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-13257a23ca-118-789c636064000310a501c49c50360710a715e5e7a69766a63040811793597dc5b5386d05209b1d495d7e52566a7209840f0218f26969c5a9250c7000926743924faa2c492d66409547d65f920f71c5fbb9227763bfec0c494092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d2cf318c37d6cf318a377028aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b53236d775f70dd13530b3323080b90100368a2c2d
CRITICAL ERROR:  zfs send  -t 1-13257a23ca-118-789c636064000310a501c49c50360710a715e5e7a69766a63040811793597dc5b5386d05209b1d495d7e52566a7209840f0218f26969c5a9250c7000926743924faa2c492d66409547d65f920f71c5fbb9227763bfec0c494092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d2cf318c37d6cf318a377028aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b53236d775f70dd13530b3323080b90100368a2c2d | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 825024 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_1 to recv/test/l0_2/l1_3/l2_1 (~ 557 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-19:15:25:39-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-14c7859310-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1459fa97f6772eabe5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057a42cf1b39e5e29783601499e132c9f97989bcac0509c9a97a20f34aa443fc720de483fc730de583fc728ded0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cad852d7dd3744d7c0cccac000e6060018eb2c68 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 570704 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_3/l2_2@syncoid_iox86_2024-12-19:16:56:52-GMT-06:00 ... syncoid_iox86_2024-12-19:17:26:47-GMT-06:00 (~ 2.0 MB):
warning: cannot send 'send/test/l0_2/l1_3/l2_2@autosnap_2024-12-19_23:00:27_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 482KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_2'@'syncoid_iox86_2024-12-19:16:56:52-GMT-06:00' 'send/test/l0_2/l1_3/l2_2'@'syncoid_iox86_2024-12-19:17:26:47-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2119416 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_3 to recv/test/l0_2/l1_3/l2_3 (~ 629 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-19:15:25:44-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-14bb428d41-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c193fcf2ca3fbbf6592900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b6a5e1844ad2cbeb03f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de483fc730de583fc728ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cac444d7dd3744d7c0cccac000e6060004302e05 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 644432 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_3 to recv/test/l0_3 (~ 529 KB remaining):
warning: cannot send 'send/test/l0_3@syncoid_iox86_2024-12-19:15:25:45-GMT-06:00': Input/output error
12.2KiB 0:00:00 [ 113KiB/s] [=>                                                                                                  ]  2%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-131f1278b3-110-789c636064000310a501c49c50360710a715e5e7a69766a6304041dd244b8bf339effd14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415af56addbc7987d6e7704923c27583e2f31379581a138352f451f6854897e8e41bcb14371655e727e664a7c667e858559bc91819189aea191aea1a595a1a99591a99589a9aebb6f88ae8199958101c26e00c9482aa6
CRITICAL ERROR:  zfs send  -t 1-131f1278b3-110-789c636064000310a501c49c50360710a715e5e7a69766a6304041dd244b8bf339effd14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415af56addbc7987d6e7704923c27583e2f31379581a138352f451f6854897e8e41bcb14371655e727e664a7c667e858559bc91819189aea191aea1a595a1a99591a99589a9aebb6f88ae8199958101c26e00c9482aa6 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 542032 |  zfs receive  -s -F 'recv/test/l0_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_0 to recv/test/l0_3/l1_0 (~ 1.5 MB remaining):
warning: cannot send 'send/test/l0_3/l1_0@syncoid_iox86_2024-12-19:15:25:47-GMT-06:00': Input/output error
3.66KiB 0:00:00 [30.9KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-125adfe068-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c17716fba2b593971d5700b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057541fa9bef9519ceb5c04923c27583e2f31379581a138352f451f6854897e8e41bcb17e8e61bc814371655e727e664a7c667e858559bc91819189aea191aea1a595a1a99591a99589b9aebb6f88ae8199958101d86e00f7a72be1
CRITICAL ERROR:  zfs send  -t 1-125adfe068-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c17716fba2b593971d5700b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057541fa9bef9519ceb5c04923c27583e2f31379581a138352f451f6854897e8e41bcb17e8e61bc814371655e727e664a7c667e858559bc91819189aea191aea1a595a1a99591a99589b9aebb6f88ae8199958101d86e00f7a72be1 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1526360 |  zfs receive  -s -F 'recv/test/l0_3/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_0/l2_0@syncoid_iox86_2024-12-19:17:11:55-GMT-06:00 ... syncoid_iox86_2024-12-19:17:26:51-GMT-06:00 (~ 425 KB):
 272KiB 0:00:00 [1.12MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_3/l1_0/l2_1@syncoid_iox86_2024-12-19:17:11:57-GMT-06:00 ... syncoid_iox86_2024-12-19:17:26:53-GMT-06:00 (~ 513 KB):
 403KiB 0:00:00 [1.64MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_3/l1_0/l2_2@syncoid_iox86_2024-12-19:17:12:00-GMT-06:00 ... syncoid_iox86_2024-12-19:17:26:55-GMT-06:00 (~ 513 KB):
 407KiB 0:00:00 [1.66MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_3/l1_0/l2_3@syncoid_iox86_2024-12-19:17:12:02-GMT-06:00 ... syncoid_iox86_2024-12-19:17:26:58-GMT-06:00 (~ 986 KB):
 798KiB 0:00:00 [3.16MiB/s] [===============================================================================>                    ] 80%            
Resuming interrupted zfs send/receive from send/test/l0_3/l1_1 to recv/test/l0_3/l1_1 (~ 877 KB remaining):
warning: cannot send 'send/test/l0_3/l1_1@syncoid_iox86_2024-12-19:15:41:19-GMT-06:00': Input/output error
9.12KiB 0:00:00 [87.6KiB/s] [>                                                                                                   ]  1%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-125df0eeb4-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1a76f724ab5d752d314806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415abb53e8b33be29ef894092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d6cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53231b432b4d475f70dd13530b3323000db0d00ab4b2b28
CRITICAL ERROR:  zfs send  -t 1-125df0eeb4-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1a76f724ab5d752d314806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415abb53e8b33be29ef894092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d6cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53231b432b4d475f70dd13530b3323000db0d00ab4b2b28 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 898752 |  zfs receive  -s -F 'recv/test/l0_3/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_1/l2_0@syncoid_iox86_2024-12-19:17:12:05-GMT-06:00 ... syncoid_iox86_2024-12-19:17:27:00-GMT-06:00 (~ 706 KB):
 537KiB 0:00:00 [2.17MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_3/l1_1/l2_1@syncoid_iox86_2024-12-19:17:12:07-GMT-06:00 ... syncoid_iox86_2024-12-19:17:27:03-GMT-06:00 (~ 942 KB):
 642KiB 0:00:00 [2.66MiB/s] [===================================================================>                                ] 68%            
Resuming interrupted zfs send/receive from send/test/l0_3/l1_1/l2_2 to recv/test/l0_3/l1_1/l2_2 (~ 809 KB remaining):
warning: cannot send 'send/test/l0_3/l1_1/l2_2@syncoid_iox86_2024-12-19:16:42:13-GMT-06:00': Input/output error
2.88KiB 0:00:00 [26.4KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-144c988f86-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081e589bb375f2d16d8a80064b323a9cb4fca4a4d2e81f04100433e2dad38b584010e40f26c48f2499525a9c50ca8f2c8fa4bf221ae50be5f9432bf5ebf2301499e132c9f97989bcac0509c9a97a20f34aa443fc720de583fc730de503fc728dec8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccac4c8cad058d7dd3744d7c0cccac000e60600b6302d27
CRITICAL ERROR:  zfs send  -t 1-144c988f86-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081e589bb375f2d16d8a80064b323a9cb4fca4a4d2e81f04100433e2dad38b584010e40f26c48f2499525a9c50ca8f2c8fa4bf221ae50be5f9432bf5ebf2301499e132c9f97989bcac0509c9a97a20f34aa443fc720de583fc730de503fc728dec8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccac4c8cad058d7dd3744d7c0cccac000e60600b6302d27 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 829120 |  zfs receive  -s -F 'recv/test/l0_3/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_1/l2_3@syncoid_iox86_2024-12-19:17:12:12-GMT-06:00 ... syncoid_iox86_2024-12-19:17:27:05-GMT-06:00 (~ 497 KB):
 398KiB 0:00:00 [1.63MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_3/l1_2@syncoid_iox86_2024-12-19:17:12:14-GMT-06:00 ... syncoid_iox86_2024-12-19:17:27:08-GMT-06:00 (~ 1.1 MB):
 931KiB 0:00:00 [3.98MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/l0_3/l1_2/l2_0@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:17:27:10-GMT-06:00 (~ 7.2 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_0@syncoid_iox86_2024-12-19:15:41:33-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_2/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 275KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_0'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_3/l1_2/l2_0'@'syncoid_iox86_2024-12-19:17:27:10-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 7519952 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2/l2_1@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:17:27:12-GMT-06:00 (~ 6.2 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_1@syncoid_iox86_2024-12-19:15:41:35-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 339KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_1'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_3/l1_2/l2_1'@'syncoid_iox86_2024-12-19:17:27:12-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 6478096 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2/l2_2@syncoid_iox86_2024-12-19:17:12:20-GMT-06:00 ... syncoid_iox86_2024-12-19:17:27:14-GMT-06:00 (~ 557 KB):
 400KiB 0:00:00 [1.71MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_3/l1_2/l2_3@syncoid_iox86_2024-12-19:17:12:23-GMT-06:00 ... syncoid_iox86_2024-12-19:17:27:16-GMT-06:00 (~ 898 KB):
 641KiB 0:00:00 [2.65MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_3/l1_3@syncoid_iox86_2024-12-19:17:12:25-GMT-06:00 ... syncoid_iox86_2024-12-19:17:27:18-GMT-06:00 (~ 321 KB):
 282KiB 0:00:00 [1.30MiB/s] [======================================================================================>             ] 87%            
Sending incremental send/test/l0_3/l1_3/l2_0@syncoid_iox86_2024-12-19:17:12:27-GMT-06:00 ... syncoid_iox86_2024-12-19:17:27:21-GMT-06:00 (~ 766 KB):
 535KiB 0:00:00 [2.26MiB/s] [====================================================================>                               ] 69%            
Resuming interrupted zfs send/receive from send/test/l0_3/l1_3/l2_1 to recv/test/l0_3/l1_3/l2_1 (~ 380 KB remaining):
warning: cannot send 'send/test/l0_3/l1_3/l2_1@syncoid_iox86_2024-12-19:15:26:24-GMT-06:00': Input/output error
6.78KiB 0:00:00 [60.5KiB/s] [>                                                                                                   ]  1%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1207838ecb-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1b68fb9cbf98eafae5000b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f9105708dd7c3dcdf440bf4c02923c27583e2f31379581a138352f451f6854897e8e41bcb17e8e2188308a377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b30272dd7d43740dccac0c0c606e000094ae2d38
CRITICAL ERROR:  zfs send  -t 1-1207838ecb-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1b68fb9cbf98eafae5000b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f9105708dd7c3dcdf440bf4c02923c27583e2f31379581a138352f451f6854897e8e41bcb17e8e2188308a377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b30272dd7d43740dccac0c0c606e000094ae2d38 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 390112 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_3/l2_2@autosnap_2024-12-19_22:00:37_frequently ... syncoid_iox86_2024-12-19:17:27:23-GMT-06:00 (~ 5.0 MB):
warning: cannot send 'send/test/l0_3/l1_3/l2_2@syncoid_iox86_2024-12-19:16:12:20-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 273KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3/l2_2'@'autosnap_2024-12-19_22:00:37_frequently' 'send/test/l0_3/l1_3/l2_2'@'syncoid_iox86_2024-12-19:17:27:23-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5248800 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_3/l2_3 to recv/test/l0_3/l1_3/l2_3 (~ 589 KB remaining):
internal error: warning: cannot send 'send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-19:15:26:29-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-118b3c37f5-118-789c636064000310a501c49c50360710a715e5e7a69766a630408145cff65f8b5a247914806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415f2219fbfbfbf12cc9c8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fac9f6308228ce28d1d8a2bf392f33353e233f32b2ccce28d0c8c4c740d8d740d2dad0c4dad8cccac8c2c75dd7d43740dccac0c0c606e0000e4702cb6 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 603472 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
real 143.16
user 14.27
sys 117.47
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
config:

        NAME                            STATE     READ WRITE CKSUM
        send                            ONLINE       0     0     0
          wwn-0x5002538d40dca5d9-part7  ONLINE       0     0     0

errors: 109 data errors, use '-v' for a list


CRITICAL ERROR: Target recv exists but has no snapshots matching with send!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.

Sending incremental send/test@syncoid_iox86_2024-12-19:17:25:03-GMT-06:00 ... syncoid_iox86_2024-12-19:17:39:56-GMT-06:00 (~ 4 KB):
2.13KiB 0:00:00 [28.7KiB/s] [====================================================>                                               ] 53%            
Resuming interrupted zfs send/receive from send/test/l0_0 to recv/test/l0_0 (~ 513 KB remaining):
internal error: warning: cannot send 'send/test/l0_0@syncoid_iox86_2024-12-19:16:55:08-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-11ac6a83fa-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1fbaf06c22593bdef2800d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b7867defaf07fc9bfb60824794eb07c5e626e2a0343716a5e8a3ed0a812fd1c83780387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43332b53532b030b5d77df105d03332b030384dd0055552ba4 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 525648 |  zfs receive  -s -F 'recv/test/l0_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_0@syncoid_iox86_2024-12-19:17:25:06-GMT-06:00 ... syncoid_iox86_2024-12-19:17:39:58-GMT-06:00 (~ 633 KB):
 409KiB 0:00:00 [1.95MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-19:17:25:08-GMT-06:00 ... syncoid_iox86_2024-12-19:17:40:01-GMT-06:00 (~ 826 KB):
 534KiB 0:00:00 [2.26MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-19:17:25:11-GMT-06:00 ... syncoid_iox86_2024-12-19:17:40:03-GMT-06:00 (~ 930 KB):
 672KiB 0:00:00 [2.72MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_0/l1_0/l2_2@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:17:40:05-GMT-06:00 (~ 8.8 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-19:15:39:11-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_0/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 261KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_2'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_0/l1_0/l2_2'@'syncoid_iox86_2024-12-19:17:40:05-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 9211512 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_0/l2_3@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:17:40:08-GMT-06:00 (~ 3.0 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-19:16:55:19-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_0/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 335KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_3'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0/l1_0/l2_3'@'syncoid_iox86_2024-12-19:17:40:08-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3163144 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1 to recv/test/l0_0/l1_1 (~ 765 KB remaining):
internal error: warning: cannot send 'send/test/l0_0/l1_1@syncoid_iox86_2024-12-19:15:23:43-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-11a7fcef30-110-789c636064000310a501c49c50360710a715e5e7a69766a63040812cfbeff43ac69b310a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a857d1e9723d5bead8d4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d0cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b63231d675f70dd13530b3323000db0d00f6802ab3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 783880 |  zfs receive  -s -F 'recv/test/l0_0/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-19:17:25:18-GMT-06:00 ... syncoid_iox86_2024-12-19:17:40:10-GMT-06:00 (~ 794 KB):
 671KiB 0:00:00 [2.74MiB/s] [===================================================================================>                ] 84%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-19:17:25:20-GMT-06:00 ... syncoid_iox86_2024-12-19:17:40:12-GMT-06:00 (~ 678 KB):
 536KiB 0:00:00 [2.18MiB/s] [==============================================================================>                     ] 79%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1/l2_2 to recv/test/l0_0/l1_1/l2_2 (~ 841 KB remaining):
internal error: warning: cannot send 'send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-19:15:39:20-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-129b2dd437-118-789c636064000310a501c49c50360710a715e5e7a69766a63040013b8b465497715aa802888da42e3f292b35b904c207010cf9b4b4e2d412063800c9b321c9275596a41633a0ca23eb2fc987b8e2faa903a25b34df182420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61beae718c51b391457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1919e8bafb86e81a98591918c0dc00004b072ae9 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 861888 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1/l2_3 to recv/test/l0_0/l1_1/l2_3 (~ 913 KB remaining):
warning: cannot send 'send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-19:15:39:22-GMT-06:00': Input/output error
 408 B 0:00:00 [4.46KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1136c0efbd-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041d3b6c3921ba7f09d5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057d8f4bf9952bfe4dbe10424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837803fd1cc37843fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b634b2b23235d77df105d03332b0303981b0090282dd3
CRITICAL ERROR:  zfs send  -t 1-1136c0efbd-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041d3b6c3921ba7f09d5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057d8f4bf9952bfe4dbe10424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837803fd1cc37843fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b634b2b23235d77df105d03332b0303981b0090282dd3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 935800 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_2@syncoid_iox86_2024-12-19:17:25:23-GMT-06:00 ... syncoid_iox86_2024-12-19:17:40:15-GMT-06:00 (~ 349 KB):
 253KiB 0:00:00 [1.17MiB/s] [=======================================================================>                            ] 72%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_2/l2_0 to recv/test/l0_0/l1_2/l2_0 (~ 781 KB remaining):
warning: cannot send 'send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-19:15:39:26-GMT-06:00': Input/output error
 408 B 0:00:00 [3.41KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11d384ec20-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c142be63273a9bb6c62900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bd4ec24bf987ee23f998024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fa49f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656c696564a6ebee1ba26b6066656000730300ff272c45
CRITICAL ERROR:  zfs send  -t 1-11d384ec20-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c142be63273a9bb6c62900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bd4ec24bf987ee23f998024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fa49f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656c696564a6ebee1ba26b6066656000730300ff272c45 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 800448 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_2/l2_1 to recv/test/l0_0/l1_2/l2_1 (~ 677 KB remaining):
warning: cannot send 'send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-19:15:39:28-GMT-06:00': Input/output error
 408 B 0:00:00 [3.81KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-127e44ff0a-118-789c636064000310a501c49c50360710a715e5e7a69766a630408154cbf596c2961b1a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28aa97713ed98eb959f2420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61be9e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1959e8bafb86e81a98591918c0dc0000b0b52c05
CRITICAL ERROR:  zfs send  -t 1-127e44ff0a-118-789c636064000310a501c49c50360710a715e5e7a69766a630408154cbf596c2961b1a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28aa97713ed98eb959f2420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61be9e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1959e8bafb86e81a98591918c0dc0000b0b52c05 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 693768 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-19:17:25:26-GMT-06:00 ... syncoid_iox86_2024-12-19:17:40:18-GMT-06:00 (~ 497 KB):
 385KiB 0:00:00 [1.58MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-19:17:25:28-GMT-06:00 ... syncoid_iox86_2024-12-19:17:40:21-GMT-06:00 (~ 589 KB):
 415KiB 0:00:00 [1.74MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_0/l1_3@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:17:40:23-GMT-06:00 (~ 3.8 MB):
warning: cannot send 'send/test/l0_0/l1_3@syncoid_iox86_2024-12-19:16:55:34-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3 does not
match incremental source
64.0KiB 0:00:00 [ 372KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0/l1_3'@'syncoid_iox86_2024-12-19:17:40:23-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4028504 |  zfs receive  -s -F 'recv/test/l0_0/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_3/l2_0@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:17:40:25-GMT-06:00 (~ 3.1 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-19:16:55:36-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 345KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_0'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0/l1_3/l2_0'@'syncoid_iox86_2024-12-19:17:40:25-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3224400 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-19:17:25:34-GMT-06:00 ... syncoid_iox86_2024-12-19:17:40:27-GMT-06:00 (~ 573 KB):
 407KiB 0:00:00 [1.64MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-19:17:25:37-GMT-06:00 ... syncoid_iox86_2024-12-19:17:40:29-GMT-06:00 (~ 722 KB):
 543KiB 0:00:00 [2.23MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_3/l2_3@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:17:40:32-GMT-06:00 (~ 7.9 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-19:15:39:44-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 271KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_3'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_0/l1_3/l2_3'@'syncoid_iox86_2024-12-19:17:40:32-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 8247296 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1@syncoid_iox86_2024-12-19:17:25:41-GMT-06:00 ... syncoid_iox86_2024-12-19:17:40:33-GMT-06:00 (~ 646 KB):
 539KiB 0:00:00 [2.62MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/l0_1/l1_0@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:17:40:35-GMT-06:00 (~ 8.2 MB):
warning: cannot send 'send/test/l0_1/l1_0@syncoid_iox86_2024-12-19:15:39:47-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_0 does not
match incremental source
64.0KiB 0:00:00 [ 300KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_1/l1_0'@'syncoid_iox86_2024-12-19:17:40:35-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 8632504 |  zfs receive  -s -F 'recv/test/l0_1/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-19:17:25:45-GMT-06:00 ... syncoid_iox86_2024-12-19:17:40:38-GMT-06:00 (~ 557 KB):
 397KiB 0:00:00 [1.62MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-19:17:25:47-GMT-06:00 ... syncoid_iox86_2024-12-19:17:40:40-GMT-06:00 (~ 854 KB):
 672KiB 0:00:00 [2.68MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-19:17:25:50-GMT-06:00 ... syncoid_iox86_2024-12-19:17:40:42-GMT-06:00 (~ 734 KB):
 664KiB 0:00:00 [2.59MiB/s] [=========================================================================================>          ] 90%            
Resuming interrupted zfs send/receive from send/test/l0_1/l1_0/l2_3 to recv/test/l0_1/l1_0/l2_3 (~ 913 KB remaining):
warning: cannot send 'send/test/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-19:15:24:26-GMT-06:00': Input/output error
6.78KiB 0:00:00 [56.8KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1115fe3a2e-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041eeacba2d2205362a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe20ab9c977fc0ebe96cb4f4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d4cf318c37d0cf318a377628aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b13232d375f70dd13530b3323080b9010026142ba7
CRITICAL ERROR:  zfs send  -t 1-1115fe3a2e-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041eeacba2d2205362a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe20ab9c977fc0ebe96cb4f4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d4cf318c37d0cf318a377628aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b13232d375f70dd13530b3323080b9010026142ba7 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 935800 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_1@syncoid_iox86_2024-12-19:17:25:52-GMT-06:00 ... syncoid_iox86_2024-12-19:17:40:45-GMT-06:00 (~ 690 KB):
 522KiB 0:00:00 [2.25MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_1/l1_1/l2_0@autosnap_2024-12-19_22:30:07_frequently ... syncoid_iox86_2024-12-19:17:40:47-GMT-06:00 (~ 3.7 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-19:16:40:55-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 427KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_0'@'autosnap_2024-12-19_22:30:07_frequently' 'send/test/l0_1/l1_1/l2_0'@'syncoid_iox86_2024-12-19:17:40:47-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3869456 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-19:17:25:57-GMT-06:00 ... syncoid_iox86_2024-12-19:17:40:49-GMT-06:00 (~ 766 KB):
 533KiB 0:00:00 [2.24MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-19:17:25:59-GMT-06:00 ... syncoid_iox86_2024-12-19:17:40:52-GMT-06:00 (~ 573 KB):
 405KiB 0:00:00 [1.70MiB/s] [=====================================================================>                              ] 70%            
Resuming interrupted zfs send/receive from send/test/l0_1/l1_1/l2_3 to recv/test/l0_1/l1_1/l2_3 (~ 601 KB remaining):
internal error: warning: cannot send 'send/test/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-19:16:25:54-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-11c3a6aed0-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1bedd5d59377b023f2900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bae1e8b14e34b5c362f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc7104418c51b3b1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5919995a999ae8bafb86e81a98591918c0dc0000cbf32d4c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 615760 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_2 to recv/test/l0_1/l1_2 (~ 781 KB remaining):
warning: cannot send 'send/test/l0_1/l1_2@syncoid_iox86_2024-12-19:16:10:39-GMT-06:00': Input/output error
9.12KiB 0:00:00 [ 157KiB/s] [>                                                                                                   ]  1%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-12c765b085-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e0e2e662f129d1fb14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec41532e1e96c9ba43f1f8e4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d4cf318c377228aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b032b6d475f70dd13530b3323000db0d00bdab29e2
CRITICAL ERROR:  zfs send  -t 1-12c765b085-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e0e2e662f129d1fb14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec41532e1e96c9ba43f1f8e4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d4cf318c377228aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b032b6d475f70dd13530b3323000db0d00bdab29e2 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 800448 |  zfs receive  -s -F 'recv/test/l0_1/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_2/l2_0@autosnap_2024-12-19_21:15:07_frequently ... syncoid_iox86_2024-12-19:17:40:54-GMT-06:00 (~ 8.2 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:24:41-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:40:11-GMT-06:00': Invalid argument
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
76.0KiB 0:00:00 [ 290KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x33000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_0'@'autosnap_2024-12-19_21:15:07_frequently' 'send/test/l0_1/l1_2/l2_0'@'syncoid_iox86_2024-12-19:17:40:54-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 8548288 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-19:15:55:27-GMT-06:00 ... syncoid_iox86_2024-12-19:17:40:57-GMT-06:00 (~ 5.1 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_1@autosnap_2024-12-19_22:00:37_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 366KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-19:15:55:27-GMT-06:00' 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-19:17:40:57-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5353696 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_2/l2_2 to recv/test/l0_1/l1_2/l2_2 (~ 441 KB remaining):
internal error: warning: cannot send 'send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-19:15:24:46-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-10c0c26d5d-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c119ee6bd985a9cf1415806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415c2fbb6ac5820c35a9e8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa89f63186fa49f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a6564626562a6ebee1ba26b6066656000730300a3612bd3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 451736 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-19:17:26:07-GMT-06:00 ... syncoid_iox86_2024-12-19:17:40:59-GMT-06:00 (~ 722 KB):
 543KiB 0:00:00 [2.21MiB/s] [==========================================================================>                         ] 75%            
Resuming interrupted zfs send/receive from send/test/l0_1/l1_3 to recv/test/l0_1/l1_3 (~ 1.4 MB remaining):
warning: cannot send 'send/test/l0_1/l1_3@syncoid_iox86_2024-12-19:16:10:48-GMT-06:00': Input/output error
2.09KiB 0:00:00 [18.7KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-10a8cedad3-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e802cf8827d51fca14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4157aef0ebc7f13e6f52402499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccad0c0cac442d7dd3744d7c0cccac0006c370009f72c68
CRITICAL ERROR:  zfs send  -t 1-10a8cedad3-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e802cf8827d51fca14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4157aef0ebc7f13e6f52402499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccad0c0cac442d7dd3744d7c0cccac0006c370009f72c68 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1477208 |  zfs receive  -s -F 'recv/test/l0_1/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_3/l2_0 to recv/test/l0_1/l1_3/l2_0 (~ 913 KB remaining):
warning: cannot send 'send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-19:15:24:52-GMT-06:00': Input/output error
2.09KiB 0:00:00 [21.2KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-14f1ada464-118-789c636064000310a501c49c50360710a715e5e7a69766a63040418addc3edb7bfcc105400b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f910579857b1fed8fe8dd33b01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730de583fc728dec0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8c4cad448d7dd3744d7c0cccac000e606006a502cd6
CRITICAL ERROR:  zfs send  -t 1-14f1ada464-118-789c636064000310a501c49c50360710a715e5e7a69766a63040418addc3edb7bfcc105400b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f910579857b1fed8fe8dd33b01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730de583fc728dec0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8c4cad448d7dd3744d7c0cccac000e606006a502cd6 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 935800 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-19:17:26:10-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:02-GMT-06:00 (~ 1.2 MB):
 937KiB 0:00:00 [3.87MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-19:17:26:12-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:05-GMT-06:00 (~ 589 KB):
 412KiB 0:00:00 [1.72MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-19:17:26:14-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:07-GMT-06:00 (~ 954 KB):
 771KiB 0:00:00 [3.05MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_2@syncoid_iox86_2024-12-19:17:26:16-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:09-GMT-06:00 (~ 381 KB):
 278KiB 0:00:00 [1.36MiB/s] [========================================================================>                           ] 73%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_0 to recv/test/l0_2/l1_0 (~ 172 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_0@syncoid_iox86_2024-12-19:15:25:02-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-13c9ed8a18-110-789c636064000310a501c49c50360710a715e5e7a69766a6304041f15cde74936d7c350a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a904dbc359336a67d8c4092e704cbe725e6a602dd979a97a20f34aa443fc720de483fc730dec0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cac048d7dd3744d7c0cccac0006c3700a3a12a2c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 176936 |  zfs receive  -s -F 'recv/test/l0_2/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-19:17:26:19-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:11-GMT-06:00 (~ 722 KB):
 540KiB 0:00:00 [2.22MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_2/l1_0/l2_1@autosnap_2024-12-19_22:30:07_frequently ... syncoid_iox86_2024-12-19:17:41:14-GMT-06:00 (~ 4.8 MB):
warning: cannot send 'send/test/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-19:16:41:25-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_2/l1_0/l2_1@autosnap_2024-12-19_23:00:27_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 382KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_0/l2_1'@'autosnap_2024-12-19_22:30:07_frequently' 'send/test/l0_2/l1_0/l2_1'@'syncoid_iox86_2024-12-19:17:41:14-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5022456 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_0/l2_2 to recv/test/l0_2/l1_0/l2_2 (~ 585 KB remaining):
warning: cannot send 'send/test/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-19:15:25:09-GMT-06:00': Input/output error
6.00KiB 0:00:00 [50.9KiB/s] [>                                                                                                   ]  1%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11afa6c057-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c187d56e616f8fb13c5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057b84d89e20ee3377c9d8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa09f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6560a9ebee1ba26b606665600073030027ef2c0c
CRITICAL ERROR:  zfs send  -t 1-11afa6c057-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c187d56e616f8fb13c5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057b84d89e20ee3377c9d8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa09f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6560a9ebee1ba26b606665600073030027ef2c0c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 599376 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-19:17:26:24-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:16-GMT-06:00 (~ 1.2 MB):
 933KiB 0:00:00 [3.66MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_2/l1_1@syncoid_iox86_2024-12-19:16:56:30-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:18-GMT-06:00 (~ 2.9 MB):
warning: cannot send 'send/test/l0_2/l1_1@autosnap_2024-12-19_23:00:27_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
68.0KiB 0:00:00 [ 369KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x21000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_1'@'syncoid_iox86_2024-12-19:16:56:30-GMT-06:00' 'send/test/l0_2/l1_1'@'syncoid_iox86_2024-12-19:17:41:18-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3002408 |  zfs receive  -s -F 'recv/test/l0_2/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-19:17:26:28-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:20-GMT-06:00 (~ 782 KB):
 543KiB 0:00:00 [2.29MiB/s] [====================================================================>                               ] 69%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_1/l2_1 to recv/test/l0_2/l1_1/l2_1 (~ 721 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-19:15:25:18-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-ff823389f-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1222bc149011dceef15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4151f5e86aa54575f399a8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa89f63146fe8505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6568a1ebee1ba26b6066656000730300d8b82ce2 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 738824 |  zfs receive  -s -F 'recv/test/l0_2/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-19:17:26:31-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:23-GMT-06:00 (~ 706 KB):
 529KiB 0:00:00 [2.19MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-19:17:26:33-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:25-GMT-06:00 (~ 810 KB):
 677KiB 0:00:00 [2.65MiB/s] [==================================================================================>                 ] 83%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_2 to recv/test/l0_2/l1_2 (~ 573 KB remaining):
warning: cannot send 'send/test/l0_2/l1_2@syncoid_iox86_2024-12-19:16:41:39-GMT-06:00': Input/output error
5.22KiB 0:00:00 [43.1KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-12261ff335-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c12d65d5a6cfa5abe62b00d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b0e9e2b93fdb3e7c6ec0824794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837823fd1cc3782387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43332b13432b634b5d77df105d03332b0303b0dd00453f2cb8
CRITICAL ERROR:  zfs send  -t 1-12261ff335-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c12d65d5a6cfa5abe62b00d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b0e9e2b93fdb3e7c6ec0824794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837823fd1cc3782387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43332b13432b634b5d77df105d03332b0303b0dd00453f2cb8 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 587088 |  zfs receive  -s -F 'recv/test/l0_2/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_2/l2_0@syncoid_iox86_2024-12-19:17:26:37-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:28-GMT-06:00 (~ 766 KB):
 532KiB 0:00:00 [2.24MiB/s] [====================================================================>                               ] 69%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_2/l2_1 to recv/test/l0_2/l1_2/l2_1 (~ 721 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_2/l2_1@syncoid_iox86_2024-12-19:16:11:25-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-1401815849-118-789c636064000310a501c49c50360710a715e5e7a69766a630408169bb71866b7259970290cd8ea42e3f292b35b904c207010cf9b4b4e2d412063800c9b321c9275596a41633a0ca23eb2fc987b8a2bfb4f74661828a6502923c27583e2f31379581a138352f451f6854897e8e41bc917e8e2188308a377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b43232d575f70dd13530b3323080b90100d6e62b09 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 738824 |  zfs receive  -s -F 'recv/test/l0_2/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_2/l2_2@syncoid_iox86_2024-12-19:17:26:40-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:31-GMT-06:00 (~ 513 KB):
 403KiB 0:00:00 [1.68MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_2/l1_2/l2_3@syncoid_iox86_2024-12-19:17:26:42-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:33-GMT-06:00 (~ 986 KB):
 800KiB 0:00:00 [3.16MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_2/l1_3@syncoid_iox86_2024-12-19:16:56:49-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:35-GMT-06:00 (~ 2.7 MB):
warning: cannot send 'send/test/l0_2/l1_3@autosnap_2024-12-19_23:00:27_hourly': Invalid argument
warning: cannot send 'send/test/l0_2/l1_3@syncoid_iox86_2024-12-19:17:41:35-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_3 does not
match incremental source
64.0KiB 0:00:00 [ 367KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3'@'syncoid_iox86_2024-12-19:16:56:49-GMT-06:00' 'send/test/l0_2/l1_3'@'syncoid_iox86_2024-12-19:17:41:35-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2805616 |  zfs receive  -s -F 'recv/test/l0_2/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_0 to recv/test/l0_2/l1_3/l2_0 (~ 805 KB remaining):
warning: cannot send 'send/test/l0_2/l1_3/l2_0@syncoid_iox86_2024-12-19:15:25:37-GMT-06:00': Input/output error
3.66KiB 0:00:00 [26.4KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-13257a23ca-118-789c636064000310a501c49c50360710a715e5e7a69766a63040811793597dc5b5386d05209b1d495d7e52566a7209840f0218f26969c5a9250c7000926743924faa2c492d66409547d65f920f71c5fbb9227763bfec0c494092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d2cf318c37d6cf318a377028aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b53236d775f70dd13530b3323080b90100368a2c2d
CRITICAL ERROR:  zfs send  -t 1-13257a23ca-118-789c636064000310a501c49c50360710a715e5e7a69766a63040811793597dc5b5386d05209b1d495d7e52566a7209840f0218f26969c5a9250c7000926743924faa2c492d66409547d65f920f71c5fbb9227763bfec0c494092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d2cf318c37d6cf318a377028aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b53236d775f70dd13530b3323080b90100368a2c2d | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 825024 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_1 to recv/test/l0_2/l1_3/l2_1 (~ 557 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-19:15:25:39-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-14c7859310-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1459fa97f6772eabe5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057a42cf1b39e5e29783601499e132c9f97989bcac0509c9a97a20f34aa443fc720de483fc730de583fc728ded0a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cad852d7dd3744d7c0cccac000e6060018eb2c68 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 570704 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_3/l2_2@syncoid_iox86_2024-12-19:16:56:52-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:38-GMT-06:00 (~ 2.8 MB):
warning: cannot send 'send/test/l0_2/l1_3/l2_2@autosnap_2024-12-19_23:00:27_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 441KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_2'@'syncoid_iox86_2024-12-19:16:56:52-GMT-06:00' 'send/test/l0_2/l1_3/l2_2'@'syncoid_iox86_2024-12-19:17:41:38-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2899824 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_3 to recv/test/l0_2/l1_3/l2_3 (~ 629 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-19:15:25:44-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-14bb428d41-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c193fcf2ca3fbbf6592900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b6a5e1844ad2cbeb03f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de483fc730de583fc728ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0d4cac8d4cac444d7dd3744d7c0cccac000e6060004302e05 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 644432 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_3 to recv/test/l0_3 (~ 529 KB remaining):
warning: cannot send 'send/test/l0_3@syncoid_iox86_2024-12-19:15:25:45-GMT-06:00': Input/output error
 408 B 0:00:00 [3.73KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-131f1278b3-110-789c636064000310a501c49c50360710a715e5e7a69766a6304041dd244b8bf339effd14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415af56addbc7987d6e7704923c27583e2f31379581a138352f451f6854897e8e41bcb14371655e727e664a7c667e858559bc91819189aea191aea1a595a1a99591a99589a9aebb6f88ae8199958101c26e00c9482aa6
CRITICAL ERROR:  zfs send  -t 1-131f1278b3-110-789c636064000310a501c49c50360710a715e5e7a69766a6304041dd244b8bf339effd14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415af56addbc7987d6e7704923c27583e2f31379581a138352f451f6854897e8e41bcb14371655e727e664a7c667e858559bc91819189aea191aea1a595a1a99591a99589a9aebb6f88ae8199958101c26e00c9482aa6 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 542032 |  zfs receive  -s -F 'recv/test/l0_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_0 to recv/test/l0_3/l1_0 (~ 1.5 MB remaining):
warning: cannot send 'send/test/l0_3/l1_0@syncoid_iox86_2024-12-19:15:25:47-GMT-06:00': Input/output error
3.66KiB 0:00:00 [31.8KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-125adfe068-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c17716fba2b593971d5700b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057541fa9bef9519ceb5c04923c27583e2f31379581a138352f451f6854897e8e41bcb17e8e61bc814371655e727e664a7c667e858559bc91819189aea191aea1a595a1a99591a99589b9aebb6f88ae8199958101d86e00f7a72be1
CRITICAL ERROR:  zfs send  -t 1-125adfe068-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c17716fba2b593971d5700b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057541fa9bef9519ceb5c04923c27583e2f31379581a138352f451f6854897e8e41bcb17e8e61bc814371655e727e664a7c667e858559bc91819189aea191aea1a595a1a99591a99589b9aebb6f88ae8199958101d86e00f7a72be1 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1526360 |  zfs receive  -s -F 'recv/test/l0_3/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_0/l2_0@syncoid_iox86_2024-12-19:17:26:51-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:41-GMT-06:00 (~ 497 KB):
 400KiB 0:00:00 [1.69MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_3/l1_0/l2_1@syncoid_iox86_2024-12-19:17:26:53-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:44-GMT-06:00 (~ 986 KB):
 800KiB 0:00:00 [3.17MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_3/l1_0/l2_2@syncoid_iox86_2024-12-19:17:26:55-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:46-GMT-06:00 (~ 529 KB):
 416KiB 0:00:00 [1.76MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_3/l1_0/l2_3@syncoid_iox86_2024-12-19:17:26:58-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:48-GMT-06:00 (~ 1.2 MB):
 805KiB 0:00:00 [3.37MiB/s] [===================================================================>                                ] 68%            
Resuming interrupted zfs send/receive from send/test/l0_3/l1_1 to recv/test/l0_3/l1_1 (~ 877 KB remaining):
warning: cannot send 'send/test/l0_3/l1_1@syncoid_iox86_2024-12-19:15:41:19-GMT-06:00': Input/output error
9.12KiB 0:00:00 [89.3KiB/s] [>                                                                                                   ]  1%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-125df0eeb4-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1a76f724ab5d752d314806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415abb53e8b33be29ef894092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d6cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53231b432b4d475f70dd13530b3323000db0d00ab4b2b28
CRITICAL ERROR:  zfs send  -t 1-125df0eeb4-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1a76f724ab5d752d314806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415abb53e8b33be29ef894092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d6cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53231b432b4d475f70dd13530b3323000db0d00ab4b2b28 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 898752 |  zfs receive  -s -F 'recv/test/l0_3/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_1/l2_0@syncoid_iox86_2024-12-19:17:27:00-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:51-GMT-06:00 (~ 1.2 MB):
1.04MiB 0:00:00 [4.34MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/l0_3/l1_1/l2_1@syncoid_iox86_2024-12-19:17:27:03-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:53-GMT-06:00 (~ 381 KB):
 278KiB 0:00:00 [1.18MiB/s] [=======================================================================>                            ] 72%            
Resuming interrupted zfs send/receive from send/test/l0_3/l1_1/l2_2 to recv/test/l0_3/l1_1/l2_2 (~ 809 KB remaining):
warning: cannot send 'send/test/l0_3/l1_1/l2_2@syncoid_iox86_2024-12-19:16:42:13-GMT-06:00': Input/output error
2.88KiB 0:00:00 [27.0KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-144c988f86-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081e589bb375f2d16d8a80064b323a9cb4fca4a4d2e81f04100433e2dad38b584010e40f26c48f2499525a9c50ca8f2c8fa4bf221ae50be5f9432bf5ebf2301499e132c9f97989bcac0509c9a97a20f34aa443fc720de583fc730de503fc728dec8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccac4c8cad058d7dd3744d7c0cccac000e60600b6302d27
CRITICAL ERROR:  zfs send  -t 1-144c988f86-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081e589bb375f2d16d8a80064b323a9cb4fca4a4d2e81f04100433e2dad38b584010e40f26c48f2499525a9c50ca8f2c8fa4bf221ae50be5f9432bf5ebf2301499e132c9f97989bcac0509c9a97a20f34aa443fc720de583fc730de503fc728dec8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccac4c8cad058d7dd3744d7c0cccac000e60600b6302d27 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 829120 |  zfs receive  -s -F 'recv/test/l0_3/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_1/l2_3@syncoid_iox86_2024-12-19:17:27:05-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:56-GMT-06:00 (~ 1.0 MB):
 805KiB 0:00:00 [3.32MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_3/l1_2@syncoid_iox86_2024-12-19:17:27:08-GMT-06:00 ... syncoid_iox86_2024-12-19:17:41:58-GMT-06:00 (~ 365 KB):
 270KiB 0:00:00 [1.21MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_3/l1_2/l2_0@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:17:42:00-GMT-06:00 (~ 7.9 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_0@syncoid_iox86_2024-12-19:15:41:33-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_2/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 272KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_0'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_3/l1_2/l2_0'@'syncoid_iox86_2024-12-19:17:42:00-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 8321024 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2/l2_1@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:17:42:03-GMT-06:00 (~ 7.0 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_1@syncoid_iox86_2024-12-19:15:41:35-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 254KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_1'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_3/l1_2/l2_1'@'syncoid_iox86_2024-12-19:17:42:03-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 7320128 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2/l2_2@syncoid_iox86_2024-12-19:17:27:14-GMT-06:00 ... syncoid_iox86_2024-12-19:17:42:05-GMT-06:00 (~ 722 KB):
 538KiB 0:00:00 [2.19MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_3/l1_2/l2_3@syncoid_iox86_2024-12-19:17:27:16-GMT-06:00 ... syncoid_iox86_2024-12-19:17:42:07-GMT-06:00 (~ 750 KB):
 679KiB 0:00:00 [2.69MiB/s] [=========================================================================================>          ] 90%            
Sending incremental send/test/l0_3/l1_3@syncoid_iox86_2024-12-19:17:27:18-GMT-06:00 ... syncoid_iox86_2024-12-19:17:42:09-GMT-06:00 (~ 954 KB):
 761KiB 0:00:00 [3.24MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_3/l1_3/l2_0@syncoid_iox86_2024-12-19:17:27:21-GMT-06:00 ... syncoid_iox86_2024-12-19:17:42:12-GMT-06:00 (~ 589 KB):
warning: cannot send 'send/test/l0_3/l1_3/l2_0@syncoid_iox86_2024-12-19:17:42:12-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [17.1KiB/s] [>                                                                                                   ]  0%            
Resuming interrupted zfs send/receive from send/test/l0_3/l1_3/l2_1 to recv/test/l0_3/l1_3/l2_1 (~ 380 KB remaining):
warning: cannot send 'send/test/l0_3/l1_3/l2_1@syncoid_iox86_2024-12-19:15:26:24-GMT-06:00': Input/output error
6.78KiB 0:00:00 [63.0KiB/s] [>                                                                                                   ]  1%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1207838ecb-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1b68fb9cbf98eafae5000b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f9105708dd7c3dcdf440bf4c02923c27583e2f31379581a138352f451f6854897e8e41bcb17e8e2188308a377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b30272dd7d43740dccac0c0c606e000094ae2d38
CRITICAL ERROR:  zfs send  -t 1-1207838ecb-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1b68fb9cbf98eafae5000b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f9105708dd7c3dcdf440bf4c02923c27583e2f31379581a138352f451f6854897e8e41bcb17e8e2188308a377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53232b30272dd7d43740dccac0c0c606e000094ae2d38 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 390112 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_3/l2_2 to recv/test/l0_3/l1_3/l2_2 (~ 573 KB remaining):
warning: cannot send 'send/test/l0_3/l1_3/l2_2@syncoid_iox86_2024-12-19:16:12:20-GMT-06:00': Input/output error
2.09KiB 0:00:00 [16.2KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-10cf7a106e-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041a1e52c23c6b30cdf15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415cb25fffdbdd8f0293c01499e132c9f97989bcac0509c9a97a20f34aa443fc720de583fc7104418c51b391457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a59191a591919e8bafb86e81a98591918c0dc0000c1002d02
CRITICAL ERROR:  zfs send  -t 1-10cf7a106e-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041a1e52c23c6b30cdf15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415cb25fffdbdd8f0293c01499e132c9f97989bcac0509c9a97a20f34aa443fc720de583fc7104418c51b391457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a59191a591919e8bafb86e81a98591918c0dc0000c1002d02 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 587088 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_3/l2_3 to recv/test/l0_3/l1_3/l2_3 (~ 589 KB remaining):
internal error: warning: cannot send 'send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-19:15:26:29-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-118b3c37f5-118-789c636064000310a501c49c50360710a715e5e7a69766a630408145cff65f8b5a247914806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415f2219fbfbfbf12cc9c8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fac9f6308228ce28d1d8a2bf392f33353e233f32b2ccce28d0c8c4c740d8d740d2dad0c4dad8cccac8c2c75dd7d43740dccac0c0c606e0000e4702cb6 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 603472 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
real 139.28
user 14.48
sys 113.86
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
config:

        NAME                            STATE     READ WRITE CKSUM
        send                            ONLINE       0     0     0
          wwn-0x5002538d40dca5d9-part7  ONLINE       0     0     0

errors: 121 data errors, use '-v' for a list


CRITICAL ERROR: Target recv exists but has no snapshots matching with send!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.

Sending incremental send/test@syncoid_iox86_2024-12-19:17:39:56-GMT-06:00 ... syncoid_iox86_2024-12-19:17:54:45-GMT-06:00 (~ 4 KB):
2.13KiB 0:00:00 [27.9KiB/s] [====================================================>                                               ] 53%            
Resuming interrupted zfs send/receive from send/test/l0_0 to recv/test/l0_0 (~ 513 KB remaining):
internal error: warning: cannot send 'send/test/l0_0@syncoid_iox86_2024-12-19:16:55:08-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-11ac6a83fa-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1fbaf06c22593bdef2800d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b7867defaf07fc9bfb60824794eb07c5e626e2a0343716a5e8a3ed0a812fd1c83780387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43332b53532b030b5d77df105d03332b030384dd0055552ba4 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 525648 |  zfs receive  -s -F 'recv/test/l0_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_0@syncoid_iox86_2024-12-19:17:39:58-GMT-06:00 ... syncoid_iox86_2024-12-19:17:54:48-GMT-06:00 (~ 782 KB):
 538KiB 0:00:00 [2.47MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-19:17:40:01-GMT-06:00 ... syncoid_iox86_2024-12-19:17:54:50-GMT-06:00 (~ 441 KB):
 277KiB 0:00:00 [1.18MiB/s] [=============================================================>                                      ] 62%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-19:17:40:03-GMT-06:00 ... syncoid_iox86_2024-12-19:17:54:52-GMT-06:00 (~ 321 KB):
 273KiB 0:00:00 [1.11MiB/s] [====================================================================================>               ] 85%            
Sending incremental send/test/l0_0/l1_0/l2_2@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:17:54:54-GMT-06:00 (~ 9.4 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-19:15:39:11-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_0/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 269KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_2'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_0/l1_0/l2_2'@'syncoid_iox86_2024-12-19:17:54:54-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 9889520 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_0/l2_3@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:17:54:57-GMT-06:00 (~ 3.7 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-19:16:55:19-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_0/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 305KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_3'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0/l1_0/l2_3'@'syncoid_iox86_2024-12-19:17:54:57-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3902592 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1 to recv/test/l0_0/l1_1 (~ UNKNOWN remaining):
cannot resume send: incremental source 0x5cd9017e67fb071d no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_0/l1_1@syncoid_iox86_2024-12-19:15:08:02-GMT-06:00 ... syncoid_iox86_2024-12-19:17:55:24-GMT-06:00 (~ 10.1 MB):
warning: cannot send 'send/test/l0_0/l1_1@syncoid_iox86_2024-12-19:15:23:43-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_1 does not
match incremental source
64.0KiB 0:00:00 [ 305KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1'@'syncoid_iox86_2024-12-19:15:08:02-GMT-06:00' 'send/test/l0_0/l1_1'@'syncoid_iox86_2024-12-19:17:55:24-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 10569920 |  zfs receive  -s -F 'recv/test/l0_0/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-19:17:40:10-GMT-06:00 ... syncoid_iox86_2024-12-19:17:55:26-GMT-06:00 (~ 838 KB):
 641KiB 0:00:00 [2.75MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-19:17:40:12-GMT-06:00 ... syncoid_iox86_2024-12-19:17:55:28-GMT-06:00 (~ 662 KB):
 542KiB 0:00:00 [2.26MiB/s] [================================================================================>                   ] 81%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1/l2_2 to recv/test/l0_0/l1_1/l2_2 (~ 841 KB remaining):
internal error: warning: cannot send 'send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-19:15:39:20-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-129b2dd437-118-789c636064000310a501c49c50360710a715e5e7a69766a63040013b8b465497715aa802888da42e3f292b35b904c207010cf9b4b4e2d412063800c9b321c9275596a41633a0ca23eb2fc987b8e2faa903a25b34df182420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61beae718c51b391457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1919e8bafb86e81a98591918c0dc00004b072ae9 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 861888 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1/l2_3 to recv/test/l0_0/l1_1/l2_3 (~ 913 KB remaining):
warning: cannot send 'send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-19:15:39:22-GMT-06:00': Input/output error
 408 B 0:00:00 [4.18KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1136c0efbd-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041d3b6c3921ba7f09d5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057d8f4bf9952bfe4dbe10424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837803fd1cc37843fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b634b2b23235d77df105d03332b0303981b0090282dd3
CRITICAL ERROR:  zfs send  -t 1-1136c0efbd-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041d3b6c3921ba7f09d5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057d8f4bf9952bfe4dbe10424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837803fd1cc37843fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b634b2b23235d77df105d03332b0303981b0090282dd3 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 935800 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_2@syncoid_iox86_2024-12-19:17:40:15-GMT-06:00 ... syncoid_iox86_2024-12-19:17:55:31-GMT-06:00 (~ 589 KB):
 416KiB 0:00:00 [1.88MiB/s] [=====================================================================>                              ] 70%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_2/l2_0 to recv/test/l0_0/l1_2/l2_0 (~ 781 KB remaining):
warning: cannot send 'send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-19:15:39:26-GMT-06:00': Input/output error
 408 B 0:00:00 [3.37KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11d384ec20-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c142be63273a9bb6c62900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bd4ec24bf987ee23f998024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fa49f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656c696564a6ebee1ba26b6066656000730300ff272c45
CRITICAL ERROR:  zfs send  -t 1-11d384ec20-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c142be63273a9bb6c62900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bd4ec24bf987ee23f998024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fa49f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656c696564a6ebee1ba26b6066656000730300ff272c45 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 800448 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_2/l2_1 to recv/test/l0_0/l1_2/l2_1 (~ 677 KB remaining):
warning: cannot send 'send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-19:15:39:28-GMT-06:00': Input/output error
 408 B 0:00:00 [3.79KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-127e44ff0a-118-789c636064000310a501c49c50360710a715e5e7a69766a630408154cbf596c2961b1a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28aa97713ed98eb959f2420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61be9e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1959e8bafb86e81a98591918c0dc0000b0b52c05
CRITICAL ERROR:  zfs send  -t 1-127e44ff0a-118-789c636064000310a501c49c50360710a715e5e7a69766a630408154cbf596c2961b1a0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28aa97713ed98eb959f2420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61be9e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5a195b5a1959e8bafb86e81a98591918c0dc0000b0b52c05 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 693768 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-19:17:40:18-GMT-06:00 ... syncoid_iox86_2024-12-19:17:55:34-GMT-06:00 (~ 822 KB):
 641KiB 0:00:00 [2.57MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-19:17:40:21-GMT-06:00 ... syncoid_iox86_2024-12-19:17:55:37-GMT-06:00 (~ 722 KB):
 541KiB 0:00:00 [2.27MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_3@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:17:55:39-GMT-06:00 (~ 4.3 MB):
warning: cannot send 'send/test/l0_0/l1_3@syncoid_iox86_2024-12-19:16:55:34-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3 does not
match incremental source
64.0KiB 0:00:00 [ 365KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0/l1_3'@'syncoid_iox86_2024-12-19:17:55:39-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4554776 |  zfs receive  -s -F 'recv/test/l0_0/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_3/l2_0@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:17:55:41-GMT-06:00 (~ 3.6 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-19:16:55:36-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 301KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_0'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0/l1_3/l2_0'@'syncoid_iox86_2024-12-19:17:55:41-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3750672 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-19:17:40:27-GMT-06:00 ... syncoid_iox86_2024-12-19:17:55:43-GMT-06:00 (~ 722 KB):
 541KiB 0:00:00 [2.24MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-19:17:40:29-GMT-06:00 ... syncoid_iox86_2024-12-19:17:55:45-GMT-06:00 (~ 722 KB):
 543KiB 0:00:00 [2.26MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_3/l2_3@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:17:55:48-GMT-06:00 (~ 8.6 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-19:15:39:44-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 269KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_3'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_0/l1_3/l2_3'@'syncoid_iox86_2024-12-19:17:55:48-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 9048368 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1@syncoid_iox86_2024-12-19:17:40:33-GMT-06:00 ... syncoid_iox86_2024-12-19:17:55:49-GMT-06:00 (~ 381 KB):
 278KiB 0:00:00 [1.39MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_1/l1_0@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:17:55:51-GMT-06:00 (~ 8.8 MB):
warning: cannot send 'send/test/l0_1/l1_0@syncoid_iox86_2024-12-19:15:39:47-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_0 does not
match incremental source
64.0KiB 0:00:00 [ 283KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_1/l1_0'@'syncoid_iox86_2024-12-19:17:55:51-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 9236600 |  zfs receive  -s -F 'recv/test/l0_1/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-19:17:40:38-GMT-06:00 ... syncoid_iox86_2024-12-19:17:55:53-GMT-06:00 (~ 646 KB):
 538KiB 0:00:00 [2.20MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-19:17:40:40-GMT-06:00 ... syncoid_iox86_2024-12-19:17:55:56-GMT-06:00 (~ 722 KB):
 544KiB 0:00:00 [2.21MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-19:17:40:42-GMT-06:00 ... syncoid_iox86_2024-12-19:17:55:58-GMT-06:00 (~ 646 KB):
 535KiB 0:00:00 [2.13MiB/s] [=================================================================================>                  ] 82%            
Resuming interrupted zfs send/receive from send/test/l0_1/l1_0/l2_3 to recv/test/l0_1/l1_0/l2_3 (~ UNKNOWN remaining):
cannot resume send: incremental source 0x243c7014b47e9a6d no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_1/l1_0/l2_3@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:17:56:26-GMT-06:00 (~ 10.2 MB):
warning: cannot send 'send/test/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-19:15:24:26-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 305KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_3'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_1/l1_0/l2_3'@'syncoid_iox86_2024-12-19:17:56:26-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 10733224 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1@syncoid_iox86_2024-12-19:17:40:45-GMT-06:00 ... syncoid_iox86_2024-12-19:17:56:28-GMT-06:00 (~ 826 KB):
 534KiB 0:00:00 [2.58MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_1/l1_1/l2_0@autosnap_2024-12-19_22:30:07_frequently ... syncoid_iox86_2024-12-19:17:56:30-GMT-06:00 (~ 4.3 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-19:16:40:55-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 404KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_0'@'autosnap_2024-12-19_22:30:07_frequently' 'send/test/l0_1/l1_1/l2_0'@'syncoid_iox86_2024-12-19:17:56:30-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4518608 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-19:17:40:49-GMT-06:00 ... syncoid_iox86_2024-12-19:17:56:32-GMT-06:00 (~ 722 KB):
 534KiB 0:00:00 [2.24MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-19:17:40:52-GMT-06:00 ... syncoid_iox86_2024-12-19:17:56:34-GMT-06:00 (~ 854 KB):
 667KiB 0:00:00 [2.72MiB/s] [=============================================================================>                      ] 78%            
Resuming interrupted zfs send/receive from send/test/l0_1/l1_1/l2_3 to recv/test/l0_1/l1_1/l2_3 (~ 601 KB remaining):
internal error: warning: cannot send 'send/test/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-19:16:25:54-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-11c3a6aed0-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1bedd5d59377b023f2900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bae1e8b14e34b5c362f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc7104418c51b3b1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5919995a999ae8bafb86e81a98591918c0dc0000cbf32d4c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 615760 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_2 to recv/test/l0_1/l1_2 (~ 781 KB remaining):
warning: cannot send 'send/test/l0_1/l1_2@syncoid_iox86_2024-12-19:16:10:39-GMT-06:00': Input/output error
9.12KiB 0:00:00 [ 139KiB/s] [>                                                                                                   ]  1%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-12c765b085-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e0e2e662f129d1fb14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec41532e1e96c9ba43f1f8e4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d4cf318c377228aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b032b6d475f70dd13530b3323000db0d00bdab29e2
CRITICAL ERROR:  zfs send  -t 1-12c765b085-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e0e2e662f129d1fb14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec41532e1e96c9ba43f1f8e4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d4cf318c377228aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b032b6d475f70dd13530b3323000db0d00bdab29e2 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 800448 |  zfs receive  -s -F 'recv/test/l0_1/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_2/l2_0 to recv/test/l0_1/l1_2/l2_0 (~ UNKNOWN remaining):
cannot resume send: incremental source 0xaae055e18fd3096b no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_1/l1_2/l2_0@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:17:57:03-GMT-06:00 (~ 9.9 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:24:41-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:40:11-GMT-06:00': Invalid argument
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 282KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_0'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_1/l1_2/l2_0'@'syncoid_iox86_2024-12-19:17:57:03-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 10345976 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-19:15:55:27-GMT-06:00 ... syncoid_iox86_2024-12-19:17:57:05-GMT-06:00 (~ 6.3 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_1@autosnap_2024-12-19_22:00:37_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 326KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-19:15:55:27-GMT-06:00' 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-19:17:57:05-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 6560824 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_2/l2_2 to recv/test/l0_1/l1_2/l2_2 (~ UNKNOWN remaining):
cannot resume send: incremental source 0x21e665716bd60bcc no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-19:15:09:07-GMT-06:00 ... syncoid_iox86_2024-12-19:17:57:32-GMT-06:00 (~ 8.0 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-19:15:24:46-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_2/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 279KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_2'@'syncoid_iox86_2024-12-19:15:09:07-GMT-06:00' 'send/test/l0_1/l1_2/l2_2'@'syncoid_iox86_2024-12-19:17:57:32-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 8354952 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-19:17:40:59-GMT-06:00 ... syncoid_iox86_2024-12-19:17:57:35-GMT-06:00 (~ 914 KB):
 665KiB 0:00:00 [2.73MiB/s] [=======================================================================>                            ] 72%            
Resuming interrupted zfs send/receive from send/test/l0_1/l1_3 to recv/test/l0_1/l1_3 (~ 1.4 MB remaining):
warning: cannot send 'send/test/l0_1/l1_3@syncoid_iox86_2024-12-19:16:10:48-GMT-06:00': Input/output error
2.88KiB 0:00:00 [24.9KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-10a8cedad3-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e802cf8827d51fca14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4157aef0ebc7f13e6f52402499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccad0c0cac442d7dd3744d7c0cccac0006c370009f72c68
CRITICAL ERROR:  zfs send  -t 1-10a8cedad3-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e802cf8827d51fca14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4157aef0ebc7f13e6f52402499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccad0c0cac442d7dd3744d7c0cccac0006c370009f72c68 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1477208 |  zfs receive  -s -F 'recv/test/l0_1/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_3/l2_0 to recv/test/l0_1/l1_3/l2_0 (~ UNKNOWN remaining):
cannot resume send: incremental source 0x1198f4dbb7e13e64 no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_1/l1_3/l2_0@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:17:58:03-GMT-06:00 (~ 9.9 MB):
warning: cannot send 'send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-19:15:24:52-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-19:16:10:50-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 236KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_3/l2_0'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_1/l1_3/l2_0'@'syncoid_iox86_2024-12-19:17:58:03-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 10420496 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-19:17:41:02-GMT-06:00 ... syncoid_iox86_2024-12-19:17:58:05-GMT-06:00 (~ 513 KB):
 406KiB 0:00:00 [1.66MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-19:17:41:05-GMT-06:00 ... syncoid_iox86_2024-12-19:17:58:07-GMT-06:00 (~ 722 KB):
 545KiB 0:00:00 [2.26MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-19:17:41:07-GMT-06:00 ... syncoid_iox86_2024-12-19:17:58:10-GMT-06:00 (~ 738 KB):
 548KiB 0:00:00 [2.27MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_2@syncoid_iox86_2024-12-19:17:41:09-GMT-06:00 ... syncoid_iox86_2024-12-19:17:58:11-GMT-06:00 (~ 629 KB):
 513KiB 0:00:00 [2.48MiB/s] [================================================================================>                   ] 81%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_0 to recv/test/l0_2/l1_0 (~ UNKNOWN remaining):
cannot resume send: incremental source 0x7c0eb634670d9d73 no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_2/l1_0@syncoid_iox86_2024-12-19:15:09:25-GMT-06:00 ... syncoid_iox86_2024-12-19:17:58:39-GMT-06:00 (~ 9.1 MB):
warning: cannot send 'send/test/l0_2/l1_0@syncoid_iox86_2024-12-19:15:25:02-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_0 does not
match incremental source
64.0KiB 0:00:00 [ 305KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_0'@'syncoid_iox86_2024-12-19:15:09:25-GMT-06:00' 'send/test/l0_2/l1_0'@'syncoid_iox86_2024-12-19:17:58:39-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 9515776 |  zfs receive  -s -F 'recv/test/l0_2/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-19:17:41:11-GMT-06:00 ... syncoid_iox86_2024-12-19:17:58:41-GMT-06:00 (~ 629 KB):
 516KiB 0:00:00 [2.05MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_2/l1_0/l2_1@autosnap_2024-12-19_22:30:07_frequently ... syncoid_iox86_2024-12-19:17:58:43-GMT-06:00 (~ 5.3 MB):
warning: cannot send 'send/test/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-19:16:41:25-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_2/l1_0/l2_1@autosnap_2024-12-19_23:00:27_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
68.0KiB 0:00:00 [ 287KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x31000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_0/l2_1'@'autosnap_2024-12-19_22:30:07_frequently' 'send/test/l0_2/l1_0/l2_1'@'syncoid_iox86_2024-12-19:17:58:43-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5565112 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_0/l2_2 to recv/test/l0_2/l1_0/l2_2 (~ UNKNOWN remaining):
cannot resume send: incremental source 0xe604c6ed5646abf0 no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_2/l1_0/l2_2@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:17:59:10-GMT-06:00 (~ 9.2 MB):
warning: cannot send 'send/test/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-19:15:25:09-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
68.0KiB 0:00:00 [ 264KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x41000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_0/l2_2'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_2/l1_0/l2_2'@'syncoid_iox86_2024-12-19:17:59:10-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 9648536 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-19:17:41:16-GMT-06:00 ... syncoid_iox86_2024-12-19:17:59:13-GMT-06:00 (~ 365 KB):
 268KiB 0:00:00 [1.08MiB/s] [========================================================================>                           ] 73%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_1 to recv/test/l0_2/l1_1 (~ 1.0 MB remaining):
warning: cannot send 'send/test/l0_2/l1_1@autosnap_2024-12-19_23:00:27_hourly': Input/output error
5.22KiB 0:00:00 [81.0KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-10e7b93718-108-789c636064000310a501c49c50360710a715e5e7a69766a6304081fbde879666be5c910a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a9f7cdca237bddecd0d4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d2cf318c3774482c2dc92fce4b2c8837323032d13534d235b48c3732b63230b032328fcfc82f2dcaa904db0900391c2916
CRITICAL ERROR:  zfs send  -t 1-10e7b93718-108-789c636064000310a501c49c50360710a715e5e7a69766a6304081fbde879666be5c910a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a9f7cdca237bddecd0d4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d2cf318c3774482c2dc92fce4b2c8837323032d13534d235b48c3732b63230b032328fcfc82f2dcaa904db0900391c2916 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1071152 |  zfs receive  -s -F 'recv/test/l0_2/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-19:17:41:20-GMT-06:00 ... syncoid_iox86_2024-12-19:17:59:16-GMT-06:00 (~ 870 KB):
 677KiB 0:00:00 [2.64MiB/s] [============================================================================>                       ] 77%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_1/l2_1 to recv/test/l0_2/l1_1/l2_1 (~ UNKNOWN remaining):
cannot resume send: incremental source 0xef43885092113aa2 no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-19:15:09:41-GMT-06:00 ... syncoid_iox86_2024-12-19:17:59:43-GMT-06:00 (~ 8.9 MB):
warning: cannot send 'send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-19:15:25:18-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_1/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 275KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_1/l2_1'@'syncoid_iox86_2024-12-19:15:09:41-GMT-06:00' 'send/test/l0_2/l1_1/l2_1'@'syncoid_iox86_2024-12-19:17:59:43-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 9323080 |  zfs receive  -s -F 'recv/test/l0_2/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-19:17:41:23-GMT-06:00 ... syncoid_iox86_2024-12-19:17:59:46-GMT-06:00 (~ 573 KB):
 407KiB 0:00:00 [1.70MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-19:17:41:25-GMT-06:00 ... syncoid_iox86_2024-12-19:17:59:48-GMT-06:00 (~ 930 KB):
 677KiB 0:00:00 [2.80MiB/s] [=======================================================================>                            ] 72%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_2 to recv/test/l0_2/l1_2 (~ 573 KB remaining):
warning: cannot send 'send/test/l0_2/l1_2@syncoid_iox86_2024-12-19:16:41:39-GMT-06:00': Input/output error
5.22KiB 0:00:00 [43.4KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-12261ff335-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c12d65d5a6cfa5abe62b00d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b0e9e2b93fdb3e7c6ec0824794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837823fd1cc3782387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43332b13432b634b5d77df105d03332b0303b0dd00453f2cb8
CRITICAL ERROR:  zfs send  -t 1-12261ff335-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c12d65d5a6cfa5abe62b00d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b0e9e2b93fdb3e7c6ec0824794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837823fd1cc3782387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43332b13432b634b5d77df105d03332b0303b0dd00453f2cb8 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 587088 |  zfs receive  -s -F 'recv/test/l0_2/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_2/l2_0@syncoid_iox86_2024-12-19:17:41:28-GMT-06:00 ... syncoid_iox86_2024-12-19:17:59:51-GMT-06:00 (~ 722 KB):
 538KiB 0:00:00 [2.20MiB/s] [=========================================================================>                          ] 74%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_2/l2_1 to recv/test/l0_2/l1_2/l2_1 (~ 721 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_2/l2_1@syncoid_iox86_2024-12-19:16:11:25-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-1401815849-118-789c636064000310a501c49c50360710a715e5e7a69766a630408169bb71866b7259970290cd8ea42e3f292b35b904c207010cf9b4b4e2d412063800c9b321c9275596a41633a0ca23eb2fc987b8a2bfb4f74661828a6502923c27583e2f31379581a138352f451f6854897e8e41bc917e8e2188308a377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b43232d575f70dd13530b3323080b90100d6e62b09 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 738824 |  zfs receive  -s -F 'recv/test/l0_2/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_2/l2_2@syncoid_iox86_2024-12-19:17:41:31-GMT-06:00 ... syncoid_iox86_2024-12-19:17:59:53-GMT-06:00 (~ 778 KB):
 649KiB 0:00:00 [2.62MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/l0_2/l1_2/l2_3@syncoid_iox86_2024-12-19:17:41:33-GMT-06:00 ... syncoid_iox86_2024-12-19:17:59:56-GMT-06:00 (~ 437 KB):
 398KiB 0:00:00 [1.68MiB/s] [==========================================================================================>         ] 91%            
Sending incremental send/test/l0_2/l1_3@syncoid_iox86_2024-12-19:16:56:49-GMT-06:00 ... syncoid_iox86_2024-12-19:17:59:58-GMT-06:00 (~ 3.4 MB):
warning: cannot send 'send/test/l0_2/l1_3@autosnap_2024-12-19_23:00:27_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 456KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
warning: cannot send 'send/test/l0_2/l1_3@syncoid_iox86_2024-12-19:17:41:35-GMT-06:00': Invalid argument
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3'@'syncoid_iox86_2024-12-19:16:56:49-GMT-06:00' 'send/test/l0_2/l1_3'@'syncoid_iox86_2024-12-19:17:59:58-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3606688 |  zfs receive  -s -F 'recv/test/l0_2/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_0 to recv/test/l0_2/l1_3/l2_0 (~ UNKNOWN remaining):
cannot resume send: incremental source 0x2b5ed6787f36024a no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_2/l1_3/l2_0@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:00:25-GMT-06:00 (~ 9.7 MB):
warning: cannot send 'send/test/l0_2/l1_3/l2_0@syncoid_iox86_2024-12-19:15:25:37-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
68.0KiB 0:00:00 [ 257KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x41000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_0'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_2/l1_3/l2_0'@'syncoid_iox86_2024-12-19:18:00:25-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 10199568 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_1 to recv/test/l0_2/l1_3/l2_1 (~ UNKNOWN remaining):
cannot resume send: incremental source 0xee2d0999fd954cd1 no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-19:15:10:04-GMT-06:00 ... syncoid_iox86_2024-12-19:18:00:54-GMT-06:00 (~ 8.8 MB):
warning: cannot send 'send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-19:15:25:39-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_3/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 260KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_1'@'syncoid_iox86_2024-12-19:15:10:04-GMT-06:00' 'send/test/l0_2/l1_3/l2_1'@'syncoid_iox86_2024-12-19:18:00:54-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 9205616 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_3/l2_2@syncoid_iox86_2024-12-19:16:56:52-GMT-06:00 ... syncoid_iox86_2024-12-19:18:00:57-GMT-06:00 (~ 3.5 MB):
warning: cannot send 'send/test/l0_2/l1_3/l2_2@autosnap_2024-12-19_23:00:27_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 383KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_2'@'syncoid_iox86_2024-12-19:16:56:52-GMT-06:00' 'send/test/l0_2/l1_3/l2_2'@'syncoid_iox86_2024-12-19:18:00:57-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3620664 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_3 to recv/test/l0_2/l1_3/l2_3 (~ UNKNOWN remaining):
cannot resume send: incremental source 0x3abebafc79776fe4 no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-19:15:10:09-GMT-06:00 ... syncoid_iox86_2024-12-19:18:01:25-GMT-06:00 (~ 9.4 MB):
warning: cannot send 'send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-19:15:25:44-GMT-06:00': Invalid argument
warning: cannot send 'send/test/l0_2/l1_3/l2_3@autosnap_2024-12-19_22:00:37_hourly': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_3/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 247KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_3'@'syncoid_iox86_2024-12-19:15:10:09-GMT-06:00' 'send/test/l0_2/l1_3/l2_3'@'syncoid_iox86_2024-12-19:18:01:25-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 9861896 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3 to recv/test/l0_3 (~ UNKNOWN remaining):
cannot resume send: incremental source 0x4eef6ccf3839927e no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_3@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:01:54-GMT-06:00 (~ 10.9 MB):
warning: cannot send 'send/test/l0_3@syncoid_iox86_2024-12-19:15:25:45-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 235KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_3'@'syncoid_iox86_2024-12-19:18:01:54-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 11400192 |  zfs receive  -s -F 'recv/test/l0_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_0 to recv/test/l0_3/l1_0 (~ UNKNOWN remaining):
cannot resume send: incremental source 0xc7a693ad723f04f7 no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_3/l1_0@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:02:23-GMT-06:00 (~ 11.5 MB):
warning: cannot send 'send/test/l0_3/l1_0@syncoid_iox86_2024-12-19:15:25:47-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 294KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_0'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_3/l1_0'@'syncoid_iox86_2024-12-19:18:02:23-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 12051312 |  zfs receive  -s -F 'recv/test/l0_3/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_0/l2_0@syncoid_iox86_2024-12-19:17:41:41-GMT-06:00 ... syncoid_iox86_2024-12-19:18:02:25-GMT-06:00 (~ 1.5 MB):
1.26MiB 0:00:00 [2.22MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/l0_3/l1_0/l2_1@syncoid_iox86_2024-12-19:17:41:44-GMT-06:00 ... syncoid_iox86_2024-12-19:18:02:28-GMT-06:00 (~ 1.2 MB):
 815KiB 0:00:00 [1.40MiB/s] [=================================================================>                                  ] 66%            
Sending incremental send/test/l0_3/l1_0/l2_2@syncoid_iox86_2024-12-19:17:41:46-GMT-06:00 ... syncoid_iox86_2024-12-19:18:02:31-GMT-06:00 (~ 984 KB):
 817KiB 0:00:00 [1.40MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/l0_3/l1_0/l2_3@syncoid_iox86_2024-12-19:17:41:48-GMT-06:00 ... syncoid_iox86_2024-12-19:18:02:34-GMT-06:00 (~ 1.6 MB):
1.17MiB 0:00:00 [2.00MiB/s] [=========================================================================>                          ] 74%            
Resuming interrupted zfs send/receive from send/test/l0_3/l1_1 to recv/test/l0_3/l1_1 (~ 877 KB remaining):
warning: cannot send 'send/test/l0_3/l1_1@syncoid_iox86_2024-12-19:15:41:19-GMT-06:00': Input/output error
 408 B 0:00:00 [3.76KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-125df0eeb4-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1a76f724ab5d752d314806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415abb53e8b33be29ef894092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d6cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53231b432b4d475f70dd13530b3323000db0d00ab4b2b28
CRITICAL ERROR:  zfs send  -t 1-125df0eeb4-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1a76f724ab5d752d314806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415abb53e8b33be29ef894092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d6cf318c377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53231b432b4d475f70dd13530b3323000db0d00ab4b2b28 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 898752 |  zfs receive  -s -F 'recv/test/l0_3/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_1/l2_0@syncoid_iox86_2024-12-19:17:41:51-GMT-06:00 ... syncoid_iox86_2024-12-19:18:02:37-GMT-06:00 (~ 1.4 MB):
1.06MiB 0:00:00 [1.86MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_3/l1_1/l2_1@syncoid_iox86_2024-12-19:17:41:53-GMT-06:00 ... syncoid_iox86_2024-12-19:18:02:39-GMT-06:00 (~ 1.9 MB):
1.30MiB 0:00:00 [2.27MiB/s] [===================================================================>                                ] 68%            
Resuming interrupted zfs send/receive from send/test/l0_3/l1_1/l2_2 to recv/test/l0_3/l1_1/l2_2 (~ 809 KB remaining):
warning: cannot send 'send/test/l0_3/l1_1/l2_2@syncoid_iox86_2024-12-19:16:42:13-GMT-06:00': Input/output error
 408 B 0:00:00 [4.02KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-144c988f86-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081e589bb375f2d16d8a80064b323a9cb4fca4a4d2e81f04100433e2dad38b584010e40f26c48f2499525a9c50ca8f2c8fa4bf221ae50be5f9432bf5ebf2301499e132c9f97989bcac0509c9a97a20f34aa443fc720de583fc730de503fc728dec8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccac4c8cad058d7dd3744d7c0cccac000e60600b6302d27
CRITICAL ERROR:  zfs send  -t 1-144c988f86-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081e589bb375f2d16d8a80064b323a9cb4fca4a4d2e81f04100433e2dad38b584010e40f26c48f2499525a9c50ca8f2c8fa4bf221ae50be5f9432bf5ebf2301499e132c9f97989bcac0509c9a97a20f34aa443fc720de583fc730de503fc728dec8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccac4c8cad058d7dd3744d7c0cccac000e60600b6302d27 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 829120 |  zfs receive  -s -F 'recv/test/l0_3/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_1/l2_3@syncoid_iox86_2024-12-19:17:41:56-GMT-06:00 ... syncoid_iox86_2024-12-19:18:02:42-GMT-06:00 (~ 1.0 MB):
warning: cannot send 'send/test/l0_3/l1_1/l2_3@syncoid_iox86_2024-12-19:18:02:42-GMT-06:00': Input/output error
 410KiB 0:00:00 [1.51MiB/s] [======================================>                                                             ] 39%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-142cb251ad-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041c385eb6715c55ffe5000b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f9105748afda2b7b415b272801499e132c9f97989bcac0509c9a97a20f34aa443fc720de583fc730de503fc728ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0c2cac0c8cac448d7dd3744d7c0cccac000e6060080c92c9b
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_1/l2_3'@'syncoid_iox86_2024-12-19:17:41:56-GMT-06:00' 'send/test/l0_3/l1_1/l2_3'@'syncoid_iox86_2024-12-19:18:02:42-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1053168 |  zfs receive  -s -F 'recv/test/l0_3/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2@syncoid_iox86_2024-12-19:17:41:58-GMT-06:00 ... syncoid_iox86_2024-12-19:18:02:45-GMT-06:00 (~ 1.4 MB):
1.05MiB 0:00:00 [1.94MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_3/l1_2/l2_0@autosnap_2024-12-19_21:30:07_frequently ... syncoid_iox86_2024-12-19:18:02:47-GMT-06:00 (~ 9.6 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_0@syncoid_iox86_2024-12-19:15:41:33-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_2/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 229KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_0'@'autosnap_2024-12-19_21:30:07_frequently' 'send/test/l0_3/l1_2/l2_0'@'syncoid_iox86_2024-12-19:18:02:47-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 10058960 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_2/l2_1 to recv/test/l0_3/l1_2/l2_1 (~ 925 KB remaining):
warning: cannot send 'send/test/l0_3/l1_2/l2_1@syncoid_iox86_2024-12-19:15:41:35-GMT-06:00': Input/output error
 408 B 0:00:00 [4.83KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-15860655fb-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081d4e9129dcf3a25f50a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe20a1fe73f9a8ae217841290e439c1f27989b9a90c0cc5a97929fa40a34af4730ce28df5730ce38df4738ce20d1d8a2bf392f33353e233f32b2ccce28d0c8c4c740d8d740d2dad0c4dad4c0cad8c4d75dd7d43740dccac0c0c606e00000e812adc
CRITICAL ERROR:  zfs send  -t 1-15860655fb-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081d4e9129dcf3a25f50a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe20a1fe73f9a8ae217841290e439c1f27989b9a90c0cc5a97929fa40a34af4730ce28df5730ce38df4738ce20d1d8a2bf392f33353e233f32b2ccce28d0c8c4c740d8d740d2dad0c4dad4c0cad8c4d75dd7d43740dccac0c0c606e00000e812adc | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 948088 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_2/l2_2@syncoid_iox86_2024-12-19:17:42:05-GMT-06:00 ... syncoid_iox86_2024-12-19:18:02:50-GMT-06:00 (~ 1.6 MB):
1.18MiB 0:00:00 [2.02MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_3/l1_2/l2_3@syncoid_iox86_2024-12-19:17:42:07-GMT-06:00 ... syncoid_iox86_2024-12-19:18:02:53-GMT-06:00 (~ 1.7 MB):
1.31MiB 0:00:00 [2.31MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_3/l1_3@syncoid_iox86_2024-12-19:17:42:09-GMT-06:00 ... syncoid_iox86_2024-12-19:18:02:55-GMT-06:00 (~ 1.7 MB):
1.32MiB 0:00:00 [2.39MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_3/l1_3/l2_0@autosnap_2024-12-19_23:30:42_frequently ... syncoid_iox86_2024-12-19:18:02:58-GMT-06:00 (~ 2.2 MB):
warning: cannot send 'send/test/l0_3/l1_3/l2_0@syncoid_iox86_2024-12-19:17:42:12-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_3/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 307KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3/l2_0'@'autosnap_2024-12-19_23:30:42_frequently' 'send/test/l0_3/l1_3/l2_0'@'syncoid_iox86_2024-12-19:18:02:58-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2357792 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_3/l2_1 to recv/test/l0_3/l1_3/l2_1 (~ UNKNOWN remaining):
cannot resume send: incremental source 0x78abc70ea76df1b6 no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_3/l1_3/l2_1@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:03:27-GMT-06:00 (~ 11.1 MB):
warning: cannot send 'send/test/l0_3/l1_3/l2_1@syncoid_iox86_2024-12-19:15:26:24-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 259KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3/l2_1'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_3/l1_3/l2_1'@'syncoid_iox86_2024-12-19:18:03:27-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 11686216 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_3/l2_2 to recv/test/l0_3/l1_3/l2_2 (~ 573 KB remaining):
warning: cannot send 'send/test/l0_3/l1_3/l2_2@syncoid_iox86_2024-12-19:16:12:20-GMT-06:00': Input/output error
 408 B 0:00:00 [2.72KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-10cf7a106e-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041a1e52c23c6b30cdf15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415cb25fffdbdd8f0293c01499e132c9f97989bcac0509c9a97a20f34aa443fc720de583fc7104418c51b391457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a59191a591919e8bafb86e81a98591918c0dc0000c1002d02
CRITICAL ERROR:  zfs send  -t 1-10cf7a106e-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041a1e52c23c6b30cdf15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415cb25fffdbdd8f0293c01499e132c9f97989bcac0509c9a97a20f34aa443fc720de583fc7104418c51b391457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a59191a591919e8bafb86e81a98591918c0dc0000c1002d02 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 587088 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_3/l2_3 to recv/test/l0_3/l1_3/l2_3 (~ UNKNOWN remaining):
cannot resume send: incremental source 0xc1984a2fab78c38 no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-19:15:10:56-GMT-06:00 ... syncoid_iox86_2024-12-19:18:03:56-GMT-06:00 (~ 8.4 MB):
warning: cannot send 'send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-19:15:26:29-GMT-06:00': Invalid argument
64.0KiB 0:00:00 [ 268KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_3/l2_3 does not
match incremental source
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3/l2_3'@'syncoid_iox86_2024-12-19:15:10:56-GMT-06:00' 'send/test/l0_3/l1_3/l2_3'@'syncoid_iox86_2024-12-19:18:03:56-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 8811224 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
real 552.52
user 31.15
sys 504.83
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
config:

        NAME                            STATE     READ WRITE CKSUM
        send                            ONLINE       0     0     0
          wwn-0x5002538d40dca5d9-part7  ONLINE       0     0     0

errors: 127 data errors, use '-v' for a list


CRITICAL ERROR: Target recv exists but has no snapshots matching with send!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.

Sending incremental send/test@syncoid_iox86_2024-12-19:17:54:45-GMT-06:00 ... syncoid_iox86_2024-12-19:18:16:28-GMT-06:00 (~ 4 KB):
3.96KiB 0:00:00 [42.6KiB/s] [==================================================================================================> ] 99%            
Resuming interrupted zfs send/receive from send/test/l0_0 to recv/test/l0_0 (~ 513 KB remaining):
internal error: warning: cannot send 'send/test/l0_0@syncoid_iox86_2024-12-19:16:55:08-GMT-06:00': Invalid argument
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-11ac6a83fa-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1fbaf06c22593bdef2800d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b7867defaf07fc9bfb60824794eb07c5e626e2a0343716a5e8a3ed0a812fd1c83780387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43332b53532b030b5d77df105d03332b030384dd0055552ba4 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 525648 |  zfs receive  -s -F 'recv/test/l0_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_0@syncoid_iox86_2024-12-19:17:54:48-GMT-06:00 ... syncoid_iox86_2024-12-19:18:16:30-GMT-06:00 (~ 1.0 MB):
 799KiB 0:00:00 [1.98MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-19:17:54:50-GMT-06:00 ... syncoid_iox86_2024-12-19:18:16:33-GMT-06:00 (~ 1.9 MB):
1.42MiB 0:00:00 [2.88MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-19:17:54:52-GMT-06:00 ... syncoid_iox86_2024-12-19:18:16:36-GMT-06:00 (~ 988 KB):
 799KiB 0:00:00 [1.51MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_0/l1_0/l2_2@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:16:38-GMT-06:00 (~ 11.6 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-19:15:39:11-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_0/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 234KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_2'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_0/l1_0/l2_2'@'syncoid_iox86_2024-12-19:18:16:38-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 12156576 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_0/l2_3@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:18:16:41-GMT-06:00 (~ 5.0 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-19:16:55:19-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_0/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 273KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_3'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0/l1_0/l2_3'@'syncoid_iox86_2024-12-19:18:16:41-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5246944 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_1@syncoid_iox86_2024-12-19:15:08:02-GMT-06:00 ... syncoid_iox86_2024-12-19:18:16:43-GMT-06:00 (~ 11.5 MB):
warning: cannot send 'send/test/l0_0/l1_1@syncoid_iox86_2024-12-19:15:23:43-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 333KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1'@'syncoid_iox86_2024-12-19:15:08:02-GMT-06:00' 'send/test/l0_0/l1_1'@'syncoid_iox86_2024-12-19:18:16:43-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 12036712 |  zfs receive  -s -F 'recv/test/l0_0/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-19:17:55:26-GMT-06:00 ... syncoid_iox86_2024-12-19:18:16:45-GMT-06:00 (~ 1.3 MB):
1.01MiB 0:00:00 [2.00MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-19:17:55:28-GMT-06:00 ... syncoid_iox86_2024-12-19:18:16:48-GMT-06:00 (~ 944 KB):
 804KiB 0:00:00 [1.56MiB/s] [====================================================================================>               ] 85%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1/l2_2 to recv/test/l0_0/l1_1/l2_2 (~ UNKNOWN remaining):
cannot resume send: incremental source 0x5566338a5a280407 no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_0/l1_1/l2_2@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:17:18-GMT-06:00 (~ 9.9 MB):
warning: cannot send 'send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-19:15:39:20-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_1/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 258KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_2'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_0/l1_1/l2_2'@'syncoid_iox86_2024-12-19:18:17:18-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 10360120 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1/l2_3 to recv/test/l0_0/l1_1/l2_3 (~ UNKNOWN remaining):
cannot resume send: incremental source 0xcd0e94b119c3b682 no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-19:15:23:52-GMT-06:00 ... syncoid_iox86_2024-12-19:18:17:46-GMT-06:00 (~ 8.5 MB):
warning: cannot send 'send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-19:15:39:22-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 345KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_3'@'syncoid_iox86_2024-12-19:15:23:52-GMT-06:00' 'send/test/l0_0/l1_1/l2_3'@'syncoid_iox86_2024-12-19:18:17:46-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 8958864 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_2@syncoid_iox86_2024-12-19:17:55:31-GMT-06:00 ... syncoid_iox86_2024-12-19:18:17:48-GMT-06:00 (~ 2.2 MB):
1.63MiB 0:00:00 [3.97MiB/s] [=======================================================================>                            ] 72%            
Resuming interrupted zfs send/receive from send/test/l0_0/l1_2/l2_0 to recv/test/l0_0/l1_2/l2_0 (~ UNKNOWN remaining):
cannot resume send: incremental source 0x5eb58289c8c60ea1 no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-19:15:23:56-GMT-06:00 ... syncoid_iox86_2024-12-19:18:18:16-GMT-06:00 (~ 8.8 MB):
warning: cannot send 'send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-19:15:39:26-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 307KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_0'@'syncoid_iox86_2024-12-19:15:23:56-GMT-06:00' 'send/test/l0_0/l1_2/l2_0'@'syncoid_iox86_2024-12-19:18:18:16-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 9205360 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_2/l2_1 to recv/test/l0_0/l1_2/l2_1 (~ UNKNOWN remaining):
cannot resume send: incremental source 0x28d8847184d7841a no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-19:15:23:58-GMT-06:00 ... syncoid_iox86_2024-12-19:18:18:44-GMT-06:00 (~ 8.0 MB):
warning: cannot send 'send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-19:15:39:28-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 332KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_1'@'syncoid_iox86_2024-12-19:15:23:58-GMT-06:00' 'send/test/l0_0/l1_2/l2_1'@'syncoid_iox86_2024-12-19:18:18:44-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 8380960 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-19:17:55:34-GMT-06:00 ... syncoid_iox86_2024-12-19:18:18:46-GMT-06:00 (~ 1.6 MB):
1.28MiB 0:00:00 [2.74MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-19:17:55:37-GMT-06:00 ... syncoid_iox86_2024-12-19:18:18:49-GMT-06:00 (~ 1.3 MB):
 928KiB 0:00:00 [2.03MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_0/l1_3@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:18:18:51-GMT-06:00 (~ 5.4 MB):
warning: cannot send 'send/test/l0_0/l1_3@syncoid_iox86_2024-12-19:16:55:34-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3 does not
match incremental source
64.0KiB 0:00:00 [ 308KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0/l1_3'@'syncoid_iox86_2024-12-19:18:18:51-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5612040 |  zfs receive  -s -F 'recv/test/l0_0/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_3/l2_0@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:18:18:53-GMT-06:00 (~ 5.1 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-19:16:55:36-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 294KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_0'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0/l1_3/l2_0'@'syncoid_iox86_2024-12-19:18:18:53-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5349344 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-19:17:55:43-GMT-06:00 ... syncoid_iox86_2024-12-19:18:18:55-GMT-06:00 (~ 1.5 MB):
1.17MiB 0:00:00 [2.49MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-19:17:55:45-GMT-06:00 ... syncoid_iox86_2024-12-19:18:18:58-GMT-06:00 (~ 900 KB):
 671KiB 0:00:00 [1.46MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_0/l1_3/l2_3@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:19:01-GMT-06:00 (~ 10.9 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-19:15:39:44-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 239KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_3'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_0/l1_3/l2_3'@'syncoid_iox86_2024-12-19:18:19:01-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 11405096 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1@syncoid_iox86_2024-12-19:17:55:49-GMT-06:00 ... syncoid_iox86_2024-12-19:18:19:03-GMT-06:00 (~ 1.8 MB):
1.29MiB 0:00:00 [3.60MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_1/l1_0@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:19:05-GMT-06:00 (~ 11.7 MB):
warning: cannot send 'send/test/l0_1/l1_0@syncoid_iox86_2024-12-19:15:39:47-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_0 does not
match incremental source
64.0KiB 0:00:00 [ 259KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_1/l1_0'@'syncoid_iox86_2024-12-19:18:19:05-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 12241600 |  zfs receive  -s -F 'recv/test/l0_1/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-19:17:55:53-GMT-06:00 ... syncoid_iox86_2024-12-19:18:19:07-GMT-06:00 (~ 1.5 MB):
1.14MiB 0:00:00 [2.50MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-19:17:55:56-GMT-06:00 ... syncoid_iox86_2024-12-19:18:19:10-GMT-06:00 (~ 1.1 MB):
 795KiB 0:00:00 [1.71MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-19:17:55:58-GMT-06:00 ... syncoid_iox86_2024-12-19:18:19:13-GMT-06:00 (~ 912 KB):
 793KiB 0:00:00 [1.71MiB/s] [======================================================================================>             ] 87%            
Sending incremental send/test/l0_1/l1_0/l2_3@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:19:15-GMT-06:00 (~ 11.3 MB):
warning: cannot send 'send/test/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-19:15:24:26-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 275KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_3'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_1/l1_0/l2_3'@'syncoid_iox86_2024-12-19:18:19:15-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 11883448 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1@syncoid_iox86_2024-12-19:17:56:28-GMT-06:00 ... syncoid_iox86_2024-12-19:18:19:17-GMT-06:00 (~ 912 KB):
warning: cannot send 'send/test/l0_1/l1_1@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
3.35KiB 0:00:00 [30.8KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_1 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1'@'syncoid_iox86_2024-12-19:17:56:28-GMT-06:00' 'send/test/l0_1/l1_1'@'syncoid_iox86_2024-12-19:18:19:17-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 934200 |  zfs receive  -s -F 'recv/test/l0_1/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1/l2_0@autosnap_2024-12-19_22:30:07_frequently ... syncoid_iox86_2024-12-19:18:19:20-GMT-06:00 (~ 5.4 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-19:16:40:55-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 258KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_0'@'autosnap_2024-12-19_22:30:07_frequently' 'send/test/l0_1/l1_1/l2_0'@'syncoid_iox86_2024-12-19:18:19:20-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5670080 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-19:17:56:32-GMT-06:00 ... syncoid_iox86_2024-12-19:18:19:22-GMT-06:00 (~ 1.6 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_1@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
3.35KiB 0:00:00 [27.3KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_1/l2_1 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_1'@'syncoid_iox86_2024-12-19:17:56:32-GMT-06:00' 'send/test/l0_1/l1_1/l2_1'@'syncoid_iox86_2024-12-19:18:19:22-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1635536 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-19:17:56:34-GMT-06:00 ... syncoid_iox86_2024-12-19:18:19:24-GMT-06:00 (~ 1.1 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_2@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
3.35KiB 0:00:00 [28.2KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_1/l2_2 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_2'@'syncoid_iox86_2024-12-19:17:56:34-GMT-06:00' 'send/test/l0_1/l1_1/l2_2'@'syncoid_iox86_2024-12-19:18:19:24-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1196712 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_1/l2_3 to recv/test/l0_1/l1_1/l2_3 (~ 601 KB remaining):
internal error: warning: cannot send 'send/test/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-19:16:25:54-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-11c3a6aed0-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1bedd5d59377b023f2900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bae1e8b14e34b5c362f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc7104418c51b3b1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5919995a999ae8bafb86e81a98591918c0dc0000cbf32d4c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 615760 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_2 to recv/test/l0_1/l1_2 (~ 781 KB remaining):
warning: cannot send 'send/test/l0_1/l1_2@syncoid_iox86_2024-12-19:16:10:39-GMT-06:00': Input/output error
 408 B 0:00:00 [7.03KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-12c765b085-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e0e2e662f129d1fb14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec41532e1e96c9ba43f1f8e4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d4cf318c377228aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b032b6d475f70dd13530b3323000db0d00bdab29e2
CRITICAL ERROR:  zfs send  -t 1-12c765b085-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e0e2e662f129d1fb14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec41532e1e96c9ba43f1f8e4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d4cf318c377228aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b032b6d475f70dd13530b3323000db0d00bdab29e2 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 800448 |  zfs receive  -s -F 'recv/test/l0_1/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_2/l2_0@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:19:27-GMT-06:00 (~ 11.6 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:24:41-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:40:11-GMT-06:00': Invalid argument
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 274KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_0'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_1/l1_2/l2_0'@'syncoid_iox86_2024-12-19:18:19:27-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 12144288 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-19:15:55:27-GMT-06:00 ... syncoid_iox86_2024-12-19:18:19:30-GMT-06:00 (~ 7.4 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_1@autosnap_2024-12-19_22:00:37_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 291KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-19:15:55:27-GMT-06:00' 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-19:18:19:30-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 7753440 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-19:15:09:07-GMT-06:00 ... syncoid_iox86_2024-12-19:18:19:32-GMT-06:00 (~ 8.9 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-19:15:24:46-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 338KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_2'@'syncoid_iox86_2024-12-19:15:09:07-GMT-06:00' 'send/test/l0_1/l1_2/l2_2'@'syncoid_iox86_2024-12-19:18:19:32-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 9341152 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-19:17:57:35-GMT-06:00 ... syncoid_iox86_2024-12-19:18:19:34-GMT-06:00 (~ 1.2 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_3@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
3.35KiB 0:00:00 [26.7KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_2/l2_3 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_3'@'syncoid_iox86_2024-12-19:17:57:35-GMT-06:00' 'send/test/l0_1/l1_2/l2_3'@'syncoid_iox86_2024-12-19:18:19:34-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1209000 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_3 to recv/test/l0_1/l1_3 (~ 1.4 MB remaining):
warning: cannot send 'send/test/l0_1/l1_3@syncoid_iox86_2024-12-19:16:10:48-GMT-06:00': Input/output error
2.09KiB 0:00:00 [17.9KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-10a8cedad3-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e802cf8827d51fca14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4157aef0ebc7f13e6f52402499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccad0c0cac442d7dd3744d7c0cccac0006c370009f72c68
CRITICAL ERROR:  zfs send  -t 1-10a8cedad3-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081e802cf8827d51fca14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4157aef0ebc7f13e6f52402499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccad0c0cac442d7dd3744d7c0cccac0006c370009f72c68 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1477208 |  zfs receive  -s -F 'recv/test/l0_1/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_3/l2_0 to recv/test/l0_1/l1_3/l2_0 (~ 1.5 MB remaining):
warning: cannot send 'send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-19:15:24:52-GMT-06:00': Input/output error
1.01KiB 0:00:00 [7.82KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-12bd110567-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041ed67db3702fb3ef92800d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bccab587f6cffc6e99d8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa89f63186fac9f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656462656aa4ebee1ba26b60666560007303005ec92cc9
CRITICAL ERROR:  zfs send  -t 1-12bd110567-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041ed67db3702fb3ef92800d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bccab587f6cffc6e99d8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa89f63186fac9f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656462656aa4ebee1ba26b60666560007303005ec92cc9 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1538648 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-19:17:58:05-GMT-06:00 ... syncoid_iox86_2024-12-19:18:19:38-GMT-06:00 (~ 1.2 MB):
warning: cannot send 'send/test/l0_1/l1_3/l2_1@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
3.35KiB 0:00:00 [28.9KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_3/l2_1 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_3/l2_1'@'syncoid_iox86_2024-12-19:17:58:05-GMT-06:00' 'send/test/l0_1/l1_3/l2_1'@'syncoid_iox86_2024-12-19:18:19:38-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1237672 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-19:17:58:07-GMT-06:00 ... syncoid_iox86_2024-12-19:18:19:40-GMT-06:00 (~ 1.5 MB):
warning: cannot send 'send/test/l0_1/l1_3/l2_2@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
3.35KiB 0:00:00 [29.1KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_3/l2_2 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_3/l2_2'@'syncoid_iox86_2024-12-19:17:58:07-GMT-06:00' 'send/test/l0_1/l1_3/l2_2'@'syncoid_iox86_2024-12-19:18:19:40-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1619152 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-19:17:58:10-GMT-06:00 ... syncoid_iox86_2024-12-19:18:19:43-GMT-06:00 (~ 2.2 MB):
warning: cannot send 'send/test/l0_1/l1_3/l2_3@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
3.35KiB 0:00:00 [28.7KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_3/l2_3 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_3/l2_3'@'syncoid_iox86_2024-12-19:17:58:10-GMT-06:00' 'send/test/l0_1/l1_3/l2_3'@'syncoid_iox86_2024-12-19:18:19:43-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2316392 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2@syncoid_iox86_2024-12-19:17:58:11-GMT-06:00 ... syncoid_iox86_2024-12-19:18:19:45-GMT-06:00 (~ 1.9 MB):
warning: cannot send 'send/test/l0_2@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
3.35KiB 0:00:00 [31.9KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_2 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2'@'syncoid_iox86_2024-12-19:17:58:11-GMT-06:00' 'send/test/l0_2'@'syncoid_iox86_2024-12-19:18:19:45-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1967680 |  zfs receive  -s -F 'recv/test/l0_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_0@syncoid_iox86_2024-12-19:15:09:25-GMT-06:00 ... syncoid_iox86_2024-12-19:18:19:47-GMT-06:00 (~ 10.2 MB):
warning: cannot send 'send/test/l0_2/l1_0@syncoid_iox86_2024-12-19:15:25:02-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 390KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_0'@'syncoid_iox86_2024-12-19:15:09:25-GMT-06:00' 'send/test/l0_2/l1_0'@'syncoid_iox86_2024-12-19:18:19:47-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 10666000 |  zfs receive  -s -F 'recv/test/l0_2/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-19:17:58:41-GMT-06:00 ... syncoid_iox86_2024-12-19:18:19:49-GMT-06:00 (~ 1.6 MB):
warning: cannot send 'send/test/l0_2/l1_0/l2_0@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
3.35KiB 0:00:00 [26.1KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_0/l2_0 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_0/l2_0'@'syncoid_iox86_2024-12-19:17:58:41-GMT-06:00' 'send/test/l0_2/l1_0/l2_0'@'syncoid_iox86_2024-12-19:18:19:49-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1643728 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_0/l2_1 to recv/test/l0_2/l1_0/l2_1 (~ 1.0 MB remaining):
warning: cannot send 'send/test/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-19:16:41:25-GMT-06:00': Input/output error
6.00KiB 0:00:00 [74.4KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1467e75bbf-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1cfae0afef83cee670a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe20ac745c7f4d689582a2620c97382e5f312735319188a53f352f4814695e8e718c41be9e718c61be8e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5999185a1999eabafb86e81a98591918c0dc00004cd02b2f
CRITICAL ERROR:  zfs send  -t 1-1467e75bbf-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1cfae0afef83cee670a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe20ac745c7f4d689582a2620c97382e5f312735319188a53f352f4814695e8e718c41be9e718c61be8e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5999185a1999eabafb86e81a98591918c0dc00004cd02b2f | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1087536 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_0/l2_2 to recv/test/l0_2/l1_0/l2_2 (~ 1.0 MB remaining):
warning: cannot send 'send/test/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-19:15:25:09-GMT-06:00': Input/output error
6.00KiB 0:00:00 [48.3KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11c7d76160-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081f2fe9b395f6f25ac5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057b84d89e20ee3377c9d8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa09f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6560a9ebee1ba26b606665600073030050aa2c3b
CRITICAL ERROR:  zfs send  -t 1-11c7d76160-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081f2fe9b395f6f25ac5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057b84d89e20ee3377c9d8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa09f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6560a9ebee1ba26b606665600073030050aa2c3b | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1067056 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-19:17:59:13-GMT-06:00 ... syncoid_iox86_2024-12-19:18:19:52-GMT-06:00 (~ 1.2 MB):
warning: cannot send 'send/test/l0_2/l1_0/l2_3@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
3.35KiB 0:00:00 [28.0KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_0/l2_3 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_0/l2_3'@'syncoid_iox86_2024-12-19:17:59:13-GMT-06:00' 'send/test/l0_2/l1_0/l2_3'@'syncoid_iox86_2024-12-19:18:19:52-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1286824 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_1 to recv/test/l0_2/l1_1 (~ 1.0 MB remaining):
warning: cannot send 'send/test/l0_2/l1_1@autosnap_2024-12-19_23:00:27_hourly': Input/output error
6.00KiB 0:00:00 [88.0KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-10e7b93718-108-789c636064000310a501c49c50360710a715e5e7a69766a6304081fbde879666be5c910a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a9f7cdca237bddecd0d4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d2cf318c3774482c2dc92fce4b2c8837323032d13534d235b48c3732b63230b032328fcfc82f2dcaa904db0900391c2916
CRITICAL ERROR:  zfs send  -t 1-10e7b93718-108-789c636064000310a501c49c50360710a715e5e7a69766a6304081fbde879666be5c910a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a9f7cdca237bddecd0d4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d2cf318c3774482c2dc92fce4b2c8837323032d13534d235b48c3732b63230b032328fcfc82f2dcaa904db0900391c2916 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1071152 |  zfs receive  -s -F 'recv/test/l0_2/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-19:17:59:16-GMT-06:00 ... syncoid_iox86_2024-12-19:18:19:55-GMT-06:00 (~ 1.4 MB):
1.04MiB 0:00:00 [2.27MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-19:15:09:41-GMT-06:00 ... syncoid_iox86_2024-12-19:18:19:58-GMT-06:00 (~ 10.2 MB):
warning: cannot send 'send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-19:15:25:18-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 326KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_1/l2_1'@'syncoid_iox86_2024-12-19:15:09:41-GMT-06:00' 'send/test/l0_2/l1_1/l2_1'@'syncoid_iox86_2024-12-19:18:19:58-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 10674376 |  zfs receive  -s -F 'recv/test/l0_2/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-19:17:59:46-GMT-06:00 ... syncoid_iox86_2024-12-19:18:20:00-GMT-06:00 (~ 1.2 MB):
 935KiB 0:00:00 [2.00MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-19:17:59:48-GMT-06:00 ... syncoid_iox86_2024-12-19:18:20:02-GMT-06:00 (~ 1.2 MB):
 929KiB 0:00:00 [1.90MiB/s] [=========================================================================>                          ] 74%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_2 to recv/test/l0_2/l1_2 (~ 573 KB remaining):
warning: cannot send 'send/test/l0_2/l1_2@syncoid_iox86_2024-12-19:16:41:39-GMT-06:00': Input/output error
5.22KiB 0:00:00 [41.9KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-12261ff335-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c12d65d5a6cfa5abe62b00d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b0e9e2b93fdb3e7c6ec0824794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837823fd1cc3782387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43332b13432b634b5d77df105d03332b0303b0dd00453f2cb8
CRITICAL ERROR:  zfs send  -t 1-12261ff335-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c12d65d5a6cfa5abe62b00d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b0e9e2b93fdb3e7c6ec0824794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837823fd1cc3782387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43332b13432b634b5d77df105d03332b0303b0dd00453f2cb8 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 587088 |  zfs receive  -s -F 'recv/test/l0_2/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_2/l2_0@syncoid_iox86_2024-12-19:17:59:51-GMT-06:00 ... syncoid_iox86_2024-12-19:18:20:06-GMT-06:00 (~ 1.2 MB):
 931KiB 0:00:00 [2.00MiB/s] [==========================================================================>                         ] 75%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_2/l2_1 to recv/test/l0_2/l1_2/l2_1 (~ 721 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_2/l2_1@syncoid_iox86_2024-12-19:16:11:25-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-1401815849-118-789c636064000310a501c49c50360710a715e5e7a69766a630408169bb71866b7259970290cd8ea42e3f292b35b904c207010cf9b4b4e2d412063800c9b321c9275596a41633a0ca23eb2fc987b8a2bfb4f74661828a6502923c27583e2f31379581a138352f451f6854897e8e41bc917e8e2188308a377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b33234b43232d575f70dd13530b3323080b90100d6e62b09 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 738824 |  zfs receive  -s -F 'recv/test/l0_2/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_2/l2_2@syncoid_iox86_2024-12-19:17:59:53-GMT-06:00 ... syncoid_iox86_2024-12-19:18:20:09-GMT-06:00 (~ 1.2 MB):
 935KiB 0:00:00 [1.95MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_2/l1_2/l2_3@syncoid_iox86_2024-12-19:17:59:56-GMT-06:00 ... syncoid_iox86_2024-12-19:18:20:11-GMT-06:00 (~ 1.2 MB):
 930KiB 0:00:00 [1.97MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_2/l1_3@syncoid_iox86_2024-12-19:16:56:49-GMT-06:00 ... syncoid_iox86_2024-12-19:18:20:14-GMT-06:00 (~ 5.2 MB):
warning: cannot send 'send/test/l0_2/l1_3@autosnap_2024-12-19_23:00:27_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 390KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
warning: cannot send 'send/test/l0_2/l1_3@syncoid_iox86_2024-12-19:17:41:35-GMT-06:00': Input/output error
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3'@'syncoid_iox86_2024-12-19:16:56:49-GMT-06:00' 'send/test/l0_2/l1_3'@'syncoid_iox86_2024-12-19:18:20:14-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5422632 |  zfs receive  -s -F 'recv/test/l0_2/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_0 to recv/test/l0_2/l1_3/l2_0 (~ 1.2 MB remaining):
warning: cannot send 'send/test/l0_2/l1_3/l2_0@syncoid_iox86_2024-12-19:15:25:37-GMT-06:00': Input/output error
 408 B 0:00:00 [2.48KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-13d16d669a-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c183afd31a759456e82800d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bdecf15b91bfb65674802923c27583e2f31379581a138352f451f6854897e8e41bc917e8e61bcb17e8e51bc814371655e727e664a7c667e858559bc91819189aea191aea1a595a1a99591a995b1b9aebb6f88ae8199958101cc0d0055992d63
CRITICAL ERROR:  zfs send  -t 1-13d16d669a-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c183afd31a759456e82800d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bdecf15b91bfb65674802923c27583e2f31379581a138352f451f6854897e8e41bc917e8e61bcb17e8e51bc814371655e727e664a7c667e858559bc91819189aea191aea1a595a1a99591a995b1b9aebb6f88ae8199958101cc0d0055992d63 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1308904 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-19:15:10:04-GMT-06:00 ... syncoid_iox86_2024-12-19:18:20:16-GMT-06:00 (~ 10.0 MB):
warning: cannot send 'send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-19:15:25:39-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 283KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_1'@'syncoid_iox86_2024-12-19:15:10:04-GMT-06:00' 'send/test/l0_2/l1_3/l2_1'@'syncoid_iox86_2024-12-19:18:20:16-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 10518360 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_3/l2_2@syncoid_iox86_2024-12-19:16:56:52-GMT-06:00 ... syncoid_iox86_2024-12-19:18:20:19-GMT-06:00 (~ 4.5 MB):
warning: cannot send 'send/test/l0_2/l1_3/l2_2@autosnap_2024-12-19_23:00:27_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 365KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_2'@'syncoid_iox86_2024-12-19:16:56:52-GMT-06:00' 'send/test/l0_2/l1_3/l2_2'@'syncoid_iox86_2024-12-19:18:20:19-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 4749784 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-19:15:10:09-GMT-06:00 ... syncoid_iox86_2024-12-19:18:20:21-GMT-06:00 (~ 10.9 MB):
warning: cannot send 'send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-19:15:25:44-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_2/l1_3/l2_3@autosnap_2024-12-19_22:00:37_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 300KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_3'@'syncoid_iox86_2024-12-19:15:10:09-GMT-06:00' 'send/test/l0_2/l1_3/l2_3'@'syncoid_iox86_2024-12-19:18:20:21-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 11408296 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3 to recv/test/l0_3 (~ 1.2 MB remaining):
warning: cannot send 'send/test/l0_3@syncoid_iox86_2024-12-19:15:25:45-GMT-06:00': Input/output error
3.66KiB 0:00:00 [32.6KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11d36e1b58-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081c7fd850cdccfa6f72900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b5ead5ab78f31fbdcee0824794eb07c5e626e2a0343716a5e8a3ed0a812fd1c83786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b23532b13535d77df105d03332b030384dd00b1c52a8b
CRITICAL ERROR:  zfs send  -t 1-11d36e1b58-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081c7fd850cdccfa6f72900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b5ead5ab78f31fbdcee0824794eb07c5e626e2a0343716a5e8a3ed0a812fd1c83786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b23532b13535d77df105d03332b030384dd00b1c52a8b | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1206504 |  zfs receive  -s -F 'recv/test/l0_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_0@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:20:23-GMT-06:00 (~ 12.3 MB):
warning: cannot send 'send/test/l0_3/l1_0@syncoid_iox86_2024-12-19:15:25:47-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 315KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_0'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_3/l1_0'@'syncoid_iox86_2024-12-19:18:20:23-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 12916856 |  zfs receive  -s -F 'recv/test/l0_3/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_0/l2_0@syncoid_iox86_2024-12-19:18:02:25-GMT-06:00 ... syncoid_iox86_2024-12-19:18:20:25-GMT-06:00 (~ 405 KB):
warning: cannot send 'send/test/l0_3/l1_0/l2_0@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
warning: cannot send 'send/test/l0_3/l1_0/l2_0@syncoid_iox86_2024-12-19:18:20:25-GMT-06:00': Invalid argument
 936 B 0:00:00 [10.3KiB/s] [>                                                                                                    ]  0%            
Sending incremental send/test/l0_3/l1_0/l2_1@syncoid_iox86_2024-12-19:18:02:28-GMT-06:00 ... syncoid_iox86_2024-12-19:18:20:28-GMT-06:00 (~ 722 KB):
 543KiB 0:00:00 [3.59MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_3/l1_0/l2_2@syncoid_iox86_2024-12-19:18:02:31-GMT-06:00 ... syncoid_iox86_2024-12-19:18:20:30-GMT-06:00 (~ 722 KB):
warning: cannot send 'send/test/l0_3/l1_0/l2_2@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
warning: cannot send 'send/test/l0_3/l1_0/l2_2@syncoid_iox86_2024-12-19:18:20:30-GMT-06:00': Invalid argument
 936 B 0:00:00 [11.3KiB/s] [>                                                                                                    ]  0%            
Sending incremental send/test/l0_3/l1_0/l2_3@syncoid_iox86_2024-12-19:18:02:34-GMT-06:00 ... syncoid_iox86_2024-12-19:18:20:32-GMT-06:00 (~ 762 KB):
warning: cannot send 'send/test/l0_3/l1_0/l2_3@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
1.52KiB 0:00:00 [17.0KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_0/l2_3 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_0/l2_3'@'syncoid_iox86_2024-12-19:18:02:34-GMT-06:00' 'send/test/l0_3/l1_0/l2_3'@'syncoid_iox86_2024-12-19:18:20:32-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 780408 |  zfs receive  -s -F 'recv/test/l0_3/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_1 to recv/test/l0_3/l1_1 (~ UNKNOWN remaining):
cannot resume send: incremental source 0x6665d67d221ef6f2 no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_3/l1_1@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:21:00-GMT-06:00 (~ 12.1 MB):
warning: cannot send 'send/test/l0_3/l1_1@syncoid_iox86_2024-12-19:15:41:19-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 329KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_1'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_3/l1_1'@'syncoid_iox86_2024-12-19:18:21:00-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 12700816 |  zfs receive  -s -F 'recv/test/l0_3/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_1/l2_0@syncoid_iox86_2024-12-19:18:02:37-GMT-06:00 ... syncoid_iox86_2024-12-19:18:21:02-GMT-06:00 (~ 1.3 MB):
warning: cannot send 'send/test/l0_3/l1_1/l2_0@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
warning: cannot send 'send/test/l0_3/l1_1/l2_0@syncoid_iox86_2024-12-19:18:21:02-GMT-06:00': Invalid argument
 936 B 0:00:00 [11.2KiB/s] [>                                                                                                    ]  0%            
Sending incremental send/test/l0_3/l1_1/l2_1@syncoid_iox86_2024-12-19:18:02:39-GMT-06:00 ... syncoid_iox86_2024-12-19:18:21:05-GMT-06:00 (~ 513 KB):
warning: cannot send 'send/test/l0_3/l1_1/l2_1@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
1.52KiB 0:00:00 [17.7KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_1/l2_1 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_1/l2_1'@'syncoid_iox86_2024-12-19:18:02:39-GMT-06:00' 'send/test/l0_3/l1_1/l2_1'@'syncoid_iox86_2024-12-19:18:21:05-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 526272 |  zfs receive  -s -F 'recv/test/l0_3/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_1/l2_2 to recv/test/l0_3/l1_1/l2_2 (~ 809 KB remaining):
warning: cannot send 'send/test/l0_3/l1_1/l2_2@syncoid_iox86_2024-12-19:16:42:13-GMT-06:00': Input/output error
2.88KiB 0:00:00 [26.2KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-144c988f86-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081e589bb375f2d16d8a80064b323a9cb4fca4a4d2e81f04100433e2dad38b584010e40f26c48f2499525a9c50ca8f2c8fa4bf221ae50be5f9432bf5ebf2301499e132c9f97989bcac0509c9a97a20f34aa443fc720de583fc730de503fc728dec8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccac4c8cad058d7dd3744d7c0cccac000e60600b6302d27
CRITICAL ERROR:  zfs send  -t 1-144c988f86-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081e589bb375f2d16d8a80064b323a9cb4fca4a4d2e81f04100433e2dad38b584010e40f26c48f2499525a9c50ca8f2c8fa4bf221ae50be5f9432bf5ebf2301499e132c9f97989bcac0509c9a97a20f34aa443fc720de583fc730de503fc728dec8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccac4c8cad058d7dd3744d7c0cccac000e60600b6302d27 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 829120 |  zfs receive  -s -F 'recv/test/l0_3/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_1/l2_3 to recv/test/l0_3/l1_1/l2_3 (~ 513 KB remaining):
warning: cannot send 'send/test/l0_3/l1_1/l2_3@syncoid_iox86_2024-12-19:18:02:42-GMT-06:00': Input/output error
 408 B 0:00:00 [4.62KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-142cb251ad-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041c385eb6715c55ffe5000b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f9105748afda2b7b415b272801499e132c9f97989bcac0509c9a97a20f34aa443fc720de583fc730de503fc728ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0c2cac0c8cac448d7dd3744d7c0cccac000e6060080c92c9b
CRITICAL ERROR:  zfs send  -t 1-142cb251ad-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041c385eb6715c55ffe5000b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f9105748afda2b7b415b272801499e132c9f97989bcac0509c9a97a20f34aa443fc720de583fc730de503fc728ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0c2cac0c8cac448d7dd3744d7c0cccac000e6060080c92c9b | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 525648 |  zfs receive  -s -F 'recv/test/l0_3/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_2@syncoid_iox86_2024-12-19:18:02:45-GMT-06:00 ... syncoid_iox86_2024-12-19:18:21:07-GMT-06:00 (~ 782 KB):
warning: cannot send 'send/test/l0_3/l1_2@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
1.52KiB 0:00:00 [19.3KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_2 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2'@'syncoid_iox86_2024-12-19:18:02:45-GMT-06:00' 'send/test/l0_3/l1_2'@'syncoid_iox86_2024-12-19:18:21:07-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 801072 |  zfs receive  -s -F 'recv/test/l0_3/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2/l2_0@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:21:09-GMT-06:00 (~ 10.9 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_0@syncoid_iox86_2024-12-19:15:41:33-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_2/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 233KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_0'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_3/l1_2/l2_0'@'syncoid_iox86_2024-12-19:18:21:09-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 11388712 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_2/l2_1 to recv/test/l0_3/l1_2/l2_1 (~ UNKNOWN remaining):
cannot resume send: incremental source 0x7f742cf32c74cb1a no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_3/l1_2/l2_1@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:21:38-GMT-06:00 (~ 9.8 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_1@syncoid_iox86_2024-12-19:15:41:35-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 217KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_1'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_3/l1_2/l2_1'@'syncoid_iox86_2024-12-19:18:21:38-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 10284792 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2/l2_2@syncoid_iox86_2024-12-19:18:02:50-GMT-06:00 ... syncoid_iox86_2024-12-19:18:21:40-GMT-06:00 (~ 662 KB):
warning: cannot send 'send/test/l0_3/l1_2/l2_2@autosnap_2024-12-20_00:15:07_frequently': Input/output error
1.83KiB 0:00:00 [20.2KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_2'@'syncoid_iox86_2024-12-19:18:02:50-GMT-06:00' 'send/test/l0_3/l1_2/l2_2'@'syncoid_iox86_2024-12-19:18:21:40-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 678008 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2/l2_3@syncoid_iox86_2024-12-19:18:02:53-GMT-06:00 ... syncoid_iox86_2024-12-19:18:21:43-GMT-06:00 (~ 497 KB):
warning: cannot send 'send/test/l0_3/l1_2/l2_3@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
warning: cannot send 'send/test/l0_3/l1_2/l2_3@syncoid_iox86_2024-12-19:18:21:43-GMT-06:00': Invalid argument
 936 B 0:00:00 [10.8KiB/s] [>                                                                                                    ]  0%            
Sending incremental send/test/l0_3/l1_3@syncoid_iox86_2024-12-19:18:02:55-GMT-06:00 ... syncoid_iox86_2024-12-19:18:21:44-GMT-06:00 (~ 650 KB):
warning: cannot send 'send/test/l0_3/l1_3@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
1.52KiB 0:00:00 [18.6KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_3 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3'@'syncoid_iox86_2024-12-19:18:02:55-GMT-06:00' 'send/test/l0_3/l1_3'@'syncoid_iox86_2024-12-19:18:21:44-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 665720 |  zfs receive  -s -F 'recv/test/l0_3/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_3/l2_0@autosnap_2024-12-19_23:30:42_frequently ... syncoid_iox86_2024-12-19:18:21:47-GMT-06:00 (~ 3.1 MB):
warning: cannot send 'send/test/l0_3/l1_3/l2_0@syncoid_iox86_2024-12-19:17:42:12-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_3/l1_3/l2_0@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
warning: cannot send 'send/test/l0_3/l1_3/l2_0@syncoid_iox86_2024-12-19:18:21:47-GMT-06:00': Invalid argument
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
72.0KiB 0:00:00 [ 329KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x32000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3/l2_0'@'autosnap_2024-12-19_23:30:42_frequently' 'send/test/l0_3/l1_3/l2_0'@'syncoid_iox86_2024-12-19:18:21:47-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3232592 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_3/l2_1@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:21:49-GMT-06:00 (~ 11.6 MB):
warning: cannot send 'send/test/l0_3/l1_3/l2_1@syncoid_iox86_2024-12-19:15:26:24-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_3/l1_3/l2_1@syncoid_iox86_2024-12-19:16:42:32-GMT-06:00': Invalid argument
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 224KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3/l2_1'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_3/l1_3/l2_1'@'syncoid_iox86_2024-12-19:18:21:49-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 12170280 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_3/l2_2 to recv/test/l0_3/l1_3/l2_2 (~ 573 KB remaining):
warning: cannot send 'send/test/l0_3/l1_3/l2_2@syncoid_iox86_2024-12-19:16:12:20-GMT-06:00': Input/output error
2.09KiB 0:00:00 [15.7KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-10cf7a106e-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041a1e52c23c6b30cdf15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415cb25fffdbdd8f0293c01499e132c9f97989bcac0509c9a97a20f34aa443fc720de583fc7104418c51b391457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a59191a591919e8bafb86e81a98591918c0dc0000c1002d02
CRITICAL ERROR:  zfs send  -t 1-10cf7a106e-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041a1e52c23c6b30cdf15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415cb25fffdbdd8f0293c01499e132c9f97989bcac0509c9a97a20f34aa443fc720de583fc7104418c51b391457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a59191a591919e8bafb86e81a98591918c0dc0000c1002d02 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 587088 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-19:15:10:56-GMT-06:00 ... syncoid_iox86_2024-12-19:18:21:51-GMT-06:00 (~ 8.9 MB):
warning: cannot send 'send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-19:15:26:29-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_3/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 287KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3/l2_3'@'syncoid_iox86_2024-12-19:15:10:56-GMT-06:00' 'send/test/l0_3/l1_3/l2_3'@'syncoid_iox86_2024-12-19:18:21:51-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 9340968 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
real 325.75
user 22.28
sys 286.26
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
config:

        NAME                            STATE     READ WRITE CKSUM
        send                            ONLINE       0     0     0
          wwn-0x5002538d40dca5d9-part7  ONLINE       0     0     0

errors: 179 data errors, use '-v' for a list


CRITICAL ERROR: Target recv exists but has no snapshots matching with send!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.

Sending incremental send/test@syncoid_iox86_2024-12-19:18:16:28-GMT-06:00 ... syncoid_iox86_2024-12-19:18:34:24-GMT-06:00 (~ 4 KB):
2.13KiB 0:00:00 [26.3KiB/s] [====================================================>                                               ] 53%            
Resuming interrupted zfs send/receive from send/test/l0_0 to recv/test/l0_0 (~ 513 KB remaining):
internal error: warning: cannot send 'send/test/l0_0@syncoid_iox86_2024-12-19:16:55:08-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-11ac6a83fa-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1fbaf06c22593bdef2800d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b7867defaf07fc9bfb60824794eb07c5e626e2a0343716a5e8a3ed0a812fd1c83780387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43332b53532b030b5d77df105d03332b030384dd0055552ba4 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 525648 |  zfs receive  -s -F 'recv/test/l0_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_0@syncoid_iox86_2024-12-19:18:16:30-GMT-06:00 ... syncoid_iox86_2024-12-19:18:34:26-GMT-06:00 (~ 706 KB):
 533KiB 0:00:00 [4.12MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-19:18:16:33-GMT-06:00 ... syncoid_iox86_2024-12-19:18:34:28-GMT-06:00 (~ 1.0 MB):
 800KiB 0:00:00 [5.45MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-19:18:16:36-GMT-06:00 ... syncoid_iox86_2024-12-19:18:34:31-GMT-06:00 (~ 986 KB):
 799KiB 0:00:00 [5.25MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_0/l1_0/l2_2@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:34:33-GMT-06:00 (~ 12.1 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-19:15:39:11-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_0/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 235KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_2'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_0/l1_0/l2_2'@'syncoid_iox86_2024-12-19:18:34:33-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 12697984 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_0/l2_3@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:18:34:35-GMT-06:00 (~ 5.6 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-19:16:55:19-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_0/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 279KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_3'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0/l1_0/l2_3'@'syncoid_iox86_2024-12-19:18:34:35-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5912664 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_1@syncoid_iox86_2024-12-19:15:08:02-GMT-06:00 ... syncoid_iox86_2024-12-19:18:34:37-GMT-06:00 (~ 11.6 MB):
warning: cannot send 'send/test/l0_0/l1_1@syncoid_iox86_2024-12-19:15:23:43-GMT-06:00': Input/output error
64.0KiB 0:00:00 [ 375KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1'@'syncoid_iox86_2024-12-19:15:08:02-GMT-06:00' 'send/test/l0_0/l1_1'@'syncoid_iox86_2024-12-19:18:34:37-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 12172064 |  zfs receive  -s -F 'recv/test/l0_0/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-19:18:16:45-GMT-06:00 ... syncoid_iox86_2024-12-19:18:34:40-GMT-06:00 (~ 930 KB):
 675KiB 0:00:00 [4.66MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-19:18:16:48-GMT-06:00 ... syncoid_iox86_2024-12-19:18:34:42-GMT-06:00 (~ 690 KB):
 514KiB 0:00:00 [3.65MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_0/l1_1/l2_2@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:34:44-GMT-06:00 (~ 11.0 MB):
warning: cannot send 'send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-19:15:39:20-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-19:15:54:40-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 234KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_2'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_0/l1_1/l2_2'@'syncoid_iox86_2024-12-19:18:34:44-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 11508472 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-19:15:23:52-GMT-06:00 ... syncoid_iox86_2024-12-19:18:34:47-GMT-06:00 (~ 9.3 MB):
warning: cannot send 'send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-19:15:39:22-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 337KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_3'@'syncoid_iox86_2024-12-19:15:23:52-GMT-06:00' 'send/test/l0_0/l1_1/l2_3'@'syncoid_iox86_2024-12-19:18:34:47-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 9742744 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_2@syncoid_iox86_2024-12-19:18:17:48-GMT-06:00 ... syncoid_iox86_2024-12-19:18:34:49-GMT-06:00 (~ 930 KB):
 673KiB 0:00:00 [5.03MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-19:15:23:56-GMT-06:00 ... syncoid_iox86_2024-12-19:18:34:51-GMT-06:00 (~ 9.3 MB):
warning: cannot send 'send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-19:15:39:26-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 341KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_0'@'syncoid_iox86_2024-12-19:15:23:56-GMT-06:00' 'send/test/l0_0/l1_2/l2_0'@'syncoid_iox86_2024-12-19:18:34:51-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 9792448 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-19:15:23:58-GMT-06:00 ... syncoid_iox86_2024-12-19:18:34:53-GMT-06:00 (~ 8.6 MB):
warning: cannot send 'send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-19:15:39:28-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 311KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_1'@'syncoid_iox86_2024-12-19:15:23:58-GMT-06:00' 'send/test/l0_0/l1_2/l2_1'@'syncoid_iox86_2024-12-19:18:34:53-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 9041960 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-19:18:18:46-GMT-06:00 ... syncoid_iox86_2024-12-19:18:34:55-GMT-06:00 (~ 838 KB):
 662KiB 0:00:00 [4.70MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-19:18:18:49-GMT-06:00 ... syncoid_iox86_2024-12-19:18:34:58-GMT-06:00 (~ 1.3 MB):
1.16MiB 0:00:00 [7.27MiB/s] [========================================================================================>           ] 89%            
Sending incremental send/test/l0_0/l1_3@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:18:35:00-GMT-06:00 (~ 6.1 MB):
warning: cannot send 'send/test/l0_0/l1_3@syncoid_iox86_2024-12-19:16:55:34-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3 does not
match incremental source
64.0KiB 0:00:00 [ 290KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0/l1_3'@'syncoid_iox86_2024-12-19:18:35:00-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 6351488 |  zfs receive  -s -F 'recv/test/l0_0/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_3/l2_0@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:18:35:02-GMT-06:00 (~ 5.7 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-19:16:55:36-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 267KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_0'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0/l1_3/l2_0'@'syncoid_iox86_2024-12-19:18:35:02-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 5937056 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-19:18:18:55-GMT-06:00 ... syncoid_iox86_2024-12-19:18:35:04-GMT-06:00 (~ 573 KB):
 400KiB 0:00:00 [2.93MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-19:18:18:58-GMT-06:00 ... syncoid_iox86_2024-12-19:18:35:07-GMT-06:00 (~ 870 KB):
 678KiB 0:00:00 [4.47MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_0/l1_3/l2_3@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:35:09-GMT-06:00 (~ 11.2 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-19:15:39:44-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 236KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_3'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_0/l1_3/l2_3'@'syncoid_iox86_2024-12-19:18:35:09-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 11795208 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1@syncoid_iox86_2024-12-19:18:19:03-GMT-06:00 ... syncoid_iox86_2024-12-19:18:35:11-GMT-06:00 (~ 529 KB):
 412KiB 0:00:00 [3.43MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_1/l1_0@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:35:13-GMT-06:00 (~ 12.4 MB):
warning: cannot send 'send/test/l0_1/l1_0@syncoid_iox86_2024-12-19:15:39:47-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_0 does not
match incremental source
64.0KiB 0:00:00 [ 253KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_1/l1_0'@'syncoid_iox86_2024-12-19:18:35:13-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 12980424 |  zfs receive  -s -F 'recv/test/l0_1/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-19:18:19:07-GMT-06:00 ... syncoid_iox86_2024-12-19:18:35:15-GMT-06:00 (~ 585 KB):
warning: cannot send 'send/test/l0_1/l1_0/l2_0@autosnap_2024-12-20_00:30:07_frequently': Input/output error
1.83KiB 0:00:00 [21.5KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_0'@'syncoid_iox86_2024-12-19:18:19:07-GMT-06:00' 'send/test/l0_1/l1_0/l2_0'@'syncoid_iox86_2024-12-19:18:35:15-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 600000 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-19:18:19:10-GMT-06:00 ... syncoid_iox86_2024-12-19:18:35:17-GMT-06:00 (~ 706 KB):
 535KiB 0:00:00 [3.87MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-19:18:19:13-GMT-06:00 ... syncoid_iox86_2024-12-19:18:35:20-GMT-06:00 (~ 633 KB):
 407KiB 0:00:00 [3.11MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_1/l1_0/l2_3@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:35:22-GMT-06:00 (~ 12.0 MB):
warning: cannot send 'send/test/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-19:15:24:26-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
68.0KiB 0:00:00 [ 231KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x31000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_3'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_1/l1_0/l2_3'@'syncoid_iox86_2024-12-19:18:35:22-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 12622272 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1@autosnap_2024-12-20_00:00:37_frequently ... syncoid_iox86_2024-12-19:18:35:24-GMT-06:00 (~ 1.5 MB):
warning: cannot send 'send/test/l0_1/l1_1@autosnap_2024-12-20_00:15:07_frequently': Input/output error
warning: cannot send 'send/test/l0_1/l1_1@autosnap_2024-12-20_00:30:07_frequently': Invalid argument
3.05KiB 0:00:00 [29.6KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1'@'autosnap_2024-12-20_00:00:37_frequently' 'send/test/l0_1/l1_1'@'syncoid_iox86_2024-12-19:18:35:24-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1610336 |  zfs receive  -s -F 'recv/test/l0_1/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_1/l2_0 to recv/test/l0_1/l1_1/l2_0 (~ 380 KB remaining):
warning: cannot send 'send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-19:16:40:55-GMT-06:00': Input/output error
2.88KiB 0:00:00 [22.8KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-121563953e-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1c5cf21ab19592aa72800d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b8c263edec0102ef03c01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc7104418c51b381457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a59991858999aeabafb86e81a98591918c0dc00009fe92bee
CRITICAL ERROR:  zfs send  -t 1-121563953e-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1c5cf21ab19592aa72800d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b8c263edec0102ef03c01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc7104418c51b381457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a59991858999aeabafb86e81a98591918c0dc00009fe92bee | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 390112 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_1/l2_1@autosnap_2024-12-20_00:00:37_frequently ... syncoid_iox86_2024-12-19:18:35:27-GMT-06:00 (~ 2.1 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_1@autosnap_2024-12-20_00:15:07_frequently': Input/output error
64.0KiB 0:00:00 [ 487KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_1'@'autosnap_2024-12-20_00:00:37_frequently' 'send/test/l0_1/l1_1/l2_1'@'syncoid_iox86_2024-12-19:18:35:27-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2176320 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1/l2_2@autosnap_2024-12-20_00:00:37_frequently ... syncoid_iox86_2024-12-19:18:35:29-GMT-06:00 (~ 1.9 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_2@autosnap_2024-12-20_00:15:07_frequently': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
68.0KiB 0:00:00 [ 353KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x31000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_2'@'autosnap_2024-12-20_00:00:37_frequently' 'send/test/l0_1/l1_1/l2_2'@'syncoid_iox86_2024-12-19:18:35:29-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1991816 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_1/l2_3 to recv/test/l0_1/l1_1/l2_3 (~ 601 KB remaining):
internal error: warning: cannot send 'send/test/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-19:16:25:54-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-11c3a6aed0-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1bedd5d59377b023f2900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bae1e8b14e34b5c362f01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc7104418c51b3b1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5919995a999ae8bafb86e81a98591918c0dc0000cbf32d4c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 615760 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_2 to recv/test/l0_1/l1_2 (~ UNKNOWN remaining):
cannot resume send: incremental source 0xbe5b94177383a311 no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_1/l1_2@autosnap_2024-12-19_22:00:37_hourly ... syncoid_iox86_2024-12-19:18:35:57-GMT-06:00 (~ 9.0 MB):
warning: cannot send 'send/test/l0_1/l1_2@syncoid_iox86_2024-12-19:16:10:39-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
72.0KiB 0:00:00 [ 282KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x32000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2'@'autosnap_2024-12-19_22:00:37_hourly' 'send/test/l0_1/l1_2'@'syncoid_iox86_2024-12-19:18:35:57-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 9402776 |  zfs receive  -s -F 'recv/test/l0_1/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_0@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:36:00-GMT-06:00 (~ 12.1 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:24:41-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-19:15:40:11-GMT-06:00': Invalid argument
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
76.0KiB 0:00:00 [ 246KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x23000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_0'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_1/l1_2/l2_0'@'syncoid_iox86_2024-12-19:18:36:00-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 12686320 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-19:15:55:27-GMT-06:00 ... syncoid_iox86_2024-12-19:18:36:02-GMT-06:00 (~ 8.4 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_1@autosnap_2024-12-19_22:00:37_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 293KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-19:15:55:27-GMT-06:00' 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-19:18:36:02-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 8824592 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-19:15:09:07-GMT-06:00 ... syncoid_iox86_2024-12-19:18:36:04-GMT-06:00 (~ 9.4 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-19:15:24:46-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 325KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_2'@'syncoid_iox86_2024-12-19:15:09:07-GMT-06:00' 'send/test/l0_1/l1_2/l2_2'@'syncoid_iox86_2024-12-19:18:36:04-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 9866800 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_3@autosnap_2024-12-20_00:00:37_frequently ... syncoid_iox86_2024-12-19:18:36:06-GMT-06:00 (~ 1.8 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_3@autosnap_2024-12-20_00:15:07_frequently': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 532KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_3'@'autosnap_2024-12-20_00:00:37_frequently' 'send/test/l0_1/l1_2/l2_3'@'syncoid_iox86_2024-12-19:18:36:06-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1856280 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_3 to recv/test/l0_1/l1_3 (~ UNKNOWN remaining):
cannot resume send: incremental source 0x76f07be45849a015 no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_1/l1_3@autosnap_2024-12-19_22:00:37_hourly ... syncoid_iox86_2024-12-19:18:36:34-GMT-06:00 (~ 10.7 MB):
warning: cannot send 'send/test/l0_1/l1_3@syncoid_iox86_2024-12-19:16:10:48-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 379KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_3'@'autosnap_2024-12-19_22:00:37_hourly' 'send/test/l0_1/l1_3'@'syncoid_iox86_2024-12-19:18:36:34-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 11228256 |  zfs receive  -s -F 'recv/test/l0_1/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_3/l2_0 to recv/test/l0_1/l1_3/l2_0 (~ 1.5 MB remaining):
warning: cannot send 'send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-19:15:24:52-GMT-06:00': Input/output error
2.09KiB 0:00:00 [15.5KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-12bd110567-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041ed67db3702fb3ef92800d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bccab587f6cffc6e99d8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa89f63186fac9f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656462656aa4ebee1ba26b60666560007303005ec92cc9
CRITICAL ERROR:  zfs send  -t 1-12bd110567-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041ed67db3702fb3ef92800d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bccab587f6cffc6e99d8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa89f63186fac9f63146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686a656462656aa4ebee1ba26b60666560007303005ec92cc9 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1538648 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_3/l2_1@autosnap_2024-12-20_00:00:37_frequently ... syncoid_iox86_2024-12-19:18:36:37-GMT-06:00 (~ 2.1 MB):
warning: cannot send 'send/test/l0_1/l1_3/l2_1@autosnap_2024-12-20_00:15:07_frequently': Input/output error
warning: cannot send 'send/test/l0_1/l1_3/l2_1@autosnap_2024-12-20_00:30:07_frequently': Invalid argument
2.44KiB 0:00:00 [22.0KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_3/l2_1'@'autosnap_2024-12-20_00:00:37_frequently' 'send/test/l0_1/l1_3/l2_1'@'syncoid_iox86_2024-12-19:18:36:37-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2184512 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_3/l2_2@autosnap_2024-12-20_00:00:37_frequently ... syncoid_iox86_2024-12-19:18:36:39-GMT-06:00 (~ 2.0 MB):
warning: cannot send 'send/test/l0_1/l1_3/l2_2@autosnap_2024-12-20_00:15:07_frequently': Input/output error
warning: cannot send 'send/test/l0_1/l1_3/l2_2@autosnap_2024-12-20_00:30:07_frequently': Input/output error
5.22KiB 0:00:00 [47.5KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_3/l2_2'@'autosnap_2024-12-20_00:00:37_frequently' 'send/test/l0_1/l1_3/l2_2'@'syncoid_iox86_2024-12-19:18:36:39-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2069640 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_3/l2_3@autosnap_2024-12-20_00:00:37_frequently ... syncoid_iox86_2024-12-19:18:36:41-GMT-06:00 (~ 2.8 MB):
warning: cannot send 'send/test/l0_1/l1_3/l2_3@autosnap_2024-12-20_00:15:07_frequently': Input/output error
warning: cannot send 'send/test/l0_1/l1_3/l2_3@autosnap_2024-12-20_00:30:07_frequently': Invalid argument
5.70KiB 0:00:00 [49.2KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_3/l2_3'@'autosnap_2024-12-20_00:00:37_frequently' 'send/test/l0_1/l1_3/l2_3'@'syncoid_iox86_2024-12-19:18:36:41-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2902232 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2@autosnap_2024-12-20_00:00:37_frequently ... syncoid_iox86_2024-12-19:18:36:43-GMT-06:00 (~ 2.6 MB):
warning: cannot send 'send/test/l0_2@autosnap_2024-12-20_00:15:07_frequently': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
68.0KiB 0:00:00 [ 386KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x31000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2'@'autosnap_2024-12-20_00:00:37_frequently' 'send/test/l0_2'@'syncoid_iox86_2024-12-19:18:36:43-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2766880 |  zfs receive  -s -F 'recv/test/l0_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_0@syncoid_iox86_2024-12-19:15:09:25-GMT-06:00 ... syncoid_iox86_2024-12-19:18:36:45-GMT-06:00 (~ 11.0 MB):
warning: cannot send 'send/test/l0_2/l1_0@syncoid_iox86_2024-12-19:15:25:02-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 308KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_0'@'syncoid_iox86_2024-12-19:15:09:25-GMT-06:00' 'send/test/l0_2/l1_0'@'syncoid_iox86_2024-12-19:18:36:45-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 11482832 |  zfs receive  -s -F 'recv/test/l0_2/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_0/l2_0@autosnap_2024-12-20_00:00:37_frequently ... syncoid_iox86_2024-12-19:18:36:47-GMT-06:00 (~ 2.1 MB):
warning: cannot send 'send/test/l0_2/l1_0/l2_0@autosnap_2024-12-20_00:15:07_frequently': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 341KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_0/l2_0'@'autosnap_2024-12-20_00:00:37_frequently' 'send/test/l0_2/l1_0/l2_0'@'syncoid_iox86_2024-12-19:18:36:47-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2168128 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_0/l2_1 to recv/test/l0_2/l1_0/l2_1 (~ 1.0 MB remaining):
warning: cannot send 'send/test/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-19:16:41:25-GMT-06:00': Input/output error
5.22KiB 0:00:00 [65.0KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1467e75bbf-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1cfae0afef83cee670a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe20ac745c7f4d689582a2620c97382e5f312735319188a53f352f4814695e8e718c41be9e718c61be8e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5999185a1999eabafb86e81a98591918c0dc00004cd02b2f
CRITICAL ERROR:  zfs send  -t 1-1467e75bbf-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1cfae0afef83cee670a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe20ac745c7f4d689582a2620c97382e5f312735319188a53f352f4814695e8e718c41be9e718c61be8e718c51b3a1457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a5999185a1999eabafb86e81a98591918c0dc00004cd02b2f | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1087536 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_0/l2_2 to recv/test/l0_2/l1_0/l2_2 (~ 1.0 MB remaining):
warning: cannot send 'send/test/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-19:15:25:09-GMT-06:00': Input/output error
6.00KiB 0:00:00 [45.8KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11c7d76160-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081f2fe9b395f6f25ac5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057b84d89e20ee3377c9d8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa09f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6560a9ebee1ba26b606665600073030050aa2c3b
CRITICAL ERROR:  zfs send  -t 1-11c7d76160-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081f2fe9b395f6f25ac5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057b84d89e20ee3377c9d8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fa09f63146fe4505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a6560a9ebee1ba26b606665600073030050aa2c3b | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1067056 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_0/l2_3@autosnap_2024-12-20_00:00:37_frequently ... syncoid_iox86_2024-12-19:18:36:50-GMT-06:00 (~ 1.7 MB):
warning: cannot send 'send/test/l0_2/l1_0/l2_3@autosnap_2024-12-20_00:15:07_frequently': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 333KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_0/l2_3'@'autosnap_2024-12-20_00:00:37_frequently' 'send/test/l0_2/l1_0/l2_3'@'syncoid_iox86_2024-12-19:18:36:50-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1778272 |  zfs receive  -s -F 'recv/test/l0_2/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_1 to recv/test/l0_2/l1_1 (~ 1.0 MB remaining):
warning: cannot send 'send/test/l0_2/l1_1@autosnap_2024-12-19_23:00:27_hourly': Input/output error
6.00KiB 0:00:00 [97.7KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-10e7b93718-108-789c636064000310a501c49c50360710a715e5e7a69766a6304081fbde879666be5c910a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a9f7cdca237bddecd0d4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d2cf318c3774482c2dc92fce4b2c8837323032d13534d235b48c3732b63230b032328fcfc82f2dcaa904db0900391c2916
CRITICAL ERROR:  zfs send  -t 1-10e7b93718-108-789c636064000310a501c49c50360710a715e5e7a69766a6304081fbde879666be5c910a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a9f7cdca237bddecd0d4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d2cf318c3774482c2dc92fce4b2c8837323032d13534d235b48c3732b63230b032328fcfc82f2dcaa904db0900391c2916 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1071152 |  zfs receive  -s -F 'recv/test/l0_2/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-19:18:19:55-GMT-06:00 ... syncoid_iox86_2024-12-19:18:36:53-GMT-06:00 (~ 854 KB):
 672KiB 0:00:00 [4.57MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-19:15:09:41-GMT-06:00 ... syncoid_iox86_2024-12-19:18:36:55-GMT-06:00 (~ 11.1 MB):
warning: cannot send 'send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-19:15:25:18-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 311KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_1/l2_1'@'syncoid_iox86_2024-12-19:15:09:41-GMT-06:00' 'send/test/l0_2/l1_1/l2_1'@'syncoid_iox86_2024-12-19:18:36:55-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 11593792 |  zfs receive  -s -F 'recv/test/l0_2/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-19:18:20:00-GMT-06:00 ... syncoid_iox86_2024-12-19:18:36:57-GMT-06:00 (~ 513 KB):
 405KiB 0:00:00 [2.89MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-19:18:20:02-GMT-06:00 ... syncoid_iox86_2024-12-19:18:36:59-GMT-06:00 (~ 589 KB):
 413KiB 0:00:00 [3.05MiB/s] [=====================================================================>                              ] 70%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_2 to recv/test/l0_2/l1_2 (~ 573 KB remaining):
warning: cannot send 'send/test/l0_2/l1_2@syncoid_iox86_2024-12-19:16:41:39-GMT-06:00': Input/output error
5.22KiB 0:00:00 [43.7KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-12261ff335-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c12d65d5a6cfa5abe62b00d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b0e9e2b93fdb3e7c6ec0824794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837823fd1cc3782387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43332b13432b634b5d77df105d03332b0303b0dd00453f2cb8
CRITICAL ERROR:  zfs send  -t 1-12261ff335-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c12d65d5a6cfa5abe62b00d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b0e9e2b93fdb3e7c6ec0824794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837823fd1cc3782387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43332b13432b634b5d77df105d03332b0303b0dd00453f2cb8 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 587088 |  zfs receive  -s -F 'recv/test/l0_2/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_2/l2_0@syncoid_iox86_2024-12-19:18:20:06-GMT-06:00 ... syncoid_iox86_2024-12-19:18:37:02-GMT-06:00 (~ 914 KB):
 673KiB 0:00:00 [4.82MiB/s] [========================================================================>                           ] 73%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_2/l2_1 to recv/test/l0_2/l1_2/l2_1 (~ UNKNOWN remaining):
cannot resume send: incremental source 0x8a76634568338735 no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_2/l1_2/l2_1@autosnap_2024-12-19_22:00:37_hourly ... syncoid_iox86_2024-12-19:18:37:31-GMT-06:00 (~ 8.3 MB):
warning: cannot send 'send/test/l0_2/l1_2/l2_1@syncoid_iox86_2024-12-19:16:11:25-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_2/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 279KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_2/l2_1'@'autosnap_2024-12-19_22:00:37_hourly' 'send/test/l0_2/l1_2/l2_1'@'syncoid_iox86_2024-12-19:18:37:31-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 8667424 |  zfs receive  -s -F 'recv/test/l0_2/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_2/l2_2@syncoid_iox86_2024-12-19:18:20:09-GMT-06:00 ... syncoid_iox86_2024-12-19:18:37:33-GMT-06:00 (~ 914 KB):
 666KiB 0:00:00 [4.59MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_2/l1_2/l2_3@syncoid_iox86_2024-12-19:18:20:11-GMT-06:00 ... syncoid_iox86_2024-12-19:18:37:35-GMT-06:00 (~ 1.0 MB):
 805KiB 0:00:00 [5.45MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_2/l1_3@syncoid_iox86_2024-12-19:16:56:49-GMT-06:00 ... syncoid_iox86_2024-12-19:18:37:37-GMT-06:00 (~ 6.0 MB):
warning: cannot send 'send/test/l0_2/l1_3@autosnap_2024-12-19_23:00:27_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 366KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
warning: cannot send 'send/test/l0_2/l1_3@syncoid_iox86_2024-12-19:17:41:35-GMT-06:00': Input/output error
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3'@'syncoid_iox86_2024-12-19:16:56:49-GMT-06:00' 'send/test/l0_2/l1_3'@'syncoid_iox86_2024-12-19:18:37:37-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 6285144 |  zfs receive  -s -F 'recv/test/l0_2/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_0 to recv/test/l0_2/l1_3/l2_0 (~ 1.2 MB remaining):
warning: cannot send 'send/test/l0_2/l1_3/l2_0@syncoid_iox86_2024-12-19:15:25:37-GMT-06:00': Input/output error
3.66KiB 0:00:00 [23.1KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-13d16d669a-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c183afd31a759456e82800d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bdecf15b91bfb65674802923c27583e2f31379581a138352f451f6854897e8e41bc917e8e61bcb17e8e51bc814371655e727e664a7c667e858559bc91819189aea191aea1a595a1a99591a995b1b9aebb6f88ae8199958101cc0d0055992d63
CRITICAL ERROR:  zfs send  -t 1-13d16d669a-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c183afd31a759456e82800d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bdecf15b91bfb65674802923c27583e2f31379581a138352f451f6854897e8e41bc917e8e61bcb17e8e51bc814371655e727e664a7c667e858559bc91819189aea191aea1a595a1a99591a995b1b9aebb6f88ae8199958101cc0d0055992d63 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1308904 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_1 to recv/test/l0_2/l1_3/l2_1 (~ 557 KB remaining):
warning: cannot send 'send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-19:15:25:39-GMT-06:00': Input/output error
 720 B 0:00:00 [5.07KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11d1996bc8-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c19330c3153bf7c7362900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b5296f8594faf143c9b8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fac9f63146fe8505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a656ca9ebee1ba26b606665600073030016962c66
CRITICAL ERROR:  zfs send  -t 1-11d1996bc8-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c19330c3153bf7c7362900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b5296f8594faf143c9b8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f63186fac9f63146fe8505c99979c9f99129f995f6161166f646064a26b68a46b686965686a65646a656ca9ebee1ba26b606665600073030016962c66 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 570704 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_3/l2_2@syncoid_iox86_2024-12-19:16:56:52-GMT-06:00 ... syncoid_iox86_2024-12-19:18:37:41-GMT-06:00 (~ 5.8 MB):
warning: cannot send 'send/test/l0_2/l1_3/l2_2@autosnap_2024-12-19_23:00:27_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 346KiB/s] [>                                                                                                   ]  1%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_2'@'syncoid_iox86_2024-12-19:16:56:52-GMT-06:00' 'send/test/l0_2/l1_3/l2_2'@'syncoid_iox86_2024-12-19:18:37:41-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 6063592 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-19:15:10:09-GMT-06:00 ... syncoid_iox86_2024-12-19:18:37:43-GMT-06:00 (~ 11.4 MB):
warning: cannot send 'send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-19:15:25:44-GMT-06:00': Input/output error
warning: cannot send 'send/test/l0_2/l1_3/l2_3@autosnap_2024-12-19_22:00:37_hourly': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 304KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_3'@'syncoid_iox86_2024-12-19:15:10:09-GMT-06:00' 'send/test/l0_2/l1_3/l2_3'@'syncoid_iox86_2024-12-19:18:37:43-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 11933944 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3 to recv/test/l0_3 (~ 1.2 MB remaining):
warning: cannot send 'send/test/l0_3@syncoid_iox86_2024-12-19:15:25:45-GMT-06:00': Input/output error
3.66KiB 0:00:00 [31.7KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11d36e1b58-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081c7fd850cdccfa6f72900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b5ead5ab78f31fbdcee0824794eb07c5e626e2a0343716a5e8a3ed0a812fd1c83786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b23532b13535d77df105d03332b030384dd00b1c52a8b
CRITICAL ERROR:  zfs send  -t 1-11d36e1b58-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081c7fd850cdccfa6f72900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b5ead5ab78f31fbdcee0824794eb07c5e626e2a0343716a5e8a3ed0a812fd1c83786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b23532b13535d77df105d03332b030384dd00b1c52a8b | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1206504 |  zfs receive  -s -F 'recv/test/l0_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_0@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:37:45-GMT-06:00 (~ 13.2 MB):
warning: cannot send 'send/test/l0_3/l1_0@syncoid_iox86_2024-12-19:15:25:47-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 319KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_0'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_3/l1_0'@'syncoid_iox86_2024-12-19:18:37:45-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 13864944 |  zfs receive  -s -F 'recv/test/l0_3/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_0/l2_0@autosnap_2024-12-20_00:00:37_frequently ... syncoid_iox86_2024-12-19:18:37:47-GMT-06:00 (~ 2.0 MB):
warning: cannot send 'send/test/l0_3/l1_0/l2_0@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
warning: cannot send 'send/test/l0_3/l1_0/l2_0@syncoid_iox86_2024-12-19:18:20:25-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_0/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 368KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_0/l2_0'@'autosnap_2024-12-20_00:00:37_frequently' 'send/test/l0_3/l1_0/l2_0'@'syncoid_iox86_2024-12-19:18:37:47-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2106688 |  zfs receive  -s -F 'recv/test/l0_3/l1_0/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_0/l2_1@syncoid_iox86_2024-12-19:18:20:28-GMT-06:00 ... syncoid_iox86_2024-12-19:18:37:50-GMT-06:00 (~ 898 KB):
 661KiB 0:00:00 [4.72MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_3/l1_0/l2_2@autosnap_2024-12-20_00:00:37_frequently ... syncoid_iox86_2024-12-19:18:37:52-GMT-06:00 (~ 1.9 MB):
warning: cannot send 'send/test/l0_3/l1_0/l2_2@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
warning: cannot send 'send/test/l0_3/l1_0/l2_2@syncoid_iox86_2024-12-19:18:20:30-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_0/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 377KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_0/l2_2'@'autosnap_2024-12-20_00:00:37_frequently' 'send/test/l0_3/l1_0/l2_2'@'syncoid_iox86_2024-12-19:18:37:52-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2024584 |  zfs receive  -s -F 'recv/test/l0_3/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_0/l2_3@syncoid_iox86_2024-12-19:18:02:34-GMT-06:00 ... syncoid_iox86_2024-12-19:18:37:54-GMT-06:00 (~ 1.2 MB):
warning: cannot send 'send/test/l0_3/l1_0/l2_3@autosnap_2024-12-20_00:15:07_frequently': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 352KiB/s] [====>                                                                                               ]  5%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_0/l2_3'@'syncoid_iox86_2024-12-19:18:02:34-GMT-06:00' 'send/test/l0_3/l1_0/l2_3'@'syncoid_iox86_2024-12-19:18:37:54-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1228672 |  zfs receive  -s -F 'recv/test/l0_3/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_1@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:37:56-GMT-06:00 (~ 12.7 MB):
warning: cannot send 'send/test/l0_3/l1_1@syncoid_iox86_2024-12-19:15:41:19-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 335KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_1'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_3/l1_1'@'syncoid_iox86_2024-12-19:18:37:56-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 13304288 |  zfs receive  -s -F 'recv/test/l0_3/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_1/l2_0@autosnap_2024-12-20_00:00:37_frequently ... syncoid_iox86_2024-12-19:18:37:58-GMT-06:00 (~ 2.6 MB):
warning: cannot send 'send/test/l0_3/l1_1/l2_0@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
warning: cannot send 'send/test/l0_3/l1_1/l2_0@syncoid_iox86_2024-12-19:18:21:02-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_1/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 359KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_1/l2_0'@'autosnap_2024-12-20_00:00:37_frequently' 'send/test/l0_3/l1_1/l2_0'@'syncoid_iox86_2024-12-19:18:37:58-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2705440 |  zfs receive  -s -F 'recv/test/l0_3/l1_1/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_1/l2_1@syncoid_iox86_2024-12-19:18:02:39-GMT-06:00 ... syncoid_iox86_2024-12-19:18:38:00-GMT-06:00 (~ 895 KB):
warning: cannot send 'send/test/l0_3/l1_1/l2_1@autosnap_2024-12-20_00:15:07_frequently': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 535KiB/s] [======>                                                                                             ]  7%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_1/l2_1'@'syncoid_iox86_2024-12-19:18:02:39-GMT-06:00' 'send/test/l0_3/l1_1/l2_1'@'syncoid_iox86_2024-12-19:18:38:00-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 917008 |  zfs receive  -s -F 'recv/test/l0_3/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_1/l2_2 to recv/test/l0_3/l1_1/l2_2 (~ 809 KB remaining):
warning: cannot send 'send/test/l0_3/l1_1/l2_2@syncoid_iox86_2024-12-19:16:42:13-GMT-06:00': Input/output error
2.09KiB 0:00:00 [20.1KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-144c988f86-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081e589bb375f2d16d8a80064b323a9cb4fca4a4d2e81f04100433e2dad38b584010e40f26c48f2499525a9c50ca8f2c8fa4bf221ae50be5f9432bf5ebf2301499e132c9f97989bcac0509c9a97a20f34aa443fc720de583fc730de503fc728dec8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccac4c8cad058d7dd3744d7c0cccac000e60600b6302d27
CRITICAL ERROR:  zfs send  -t 1-144c988f86-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081e589bb375f2d16d8a80064b323a9cb4fca4a4d2e81f04100433e2dad38b584010e40f26c48f2499525a9c50ca8f2c8fa4bf221ae50be5f9432bf5ebf2301499e132c9f97989bcac0509c9a97a20f34aa443fc720de583fc730de503fc728dec8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0cccac4c8cad058d7dd3744d7c0cccac000e60600b6302d27 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 829120 |  zfs receive  -s -F 'recv/test/l0_3/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_1/l2_3 to recv/test/l0_3/l1_1/l2_3 (~ 513 KB remaining):
warning: cannot send 'send/test/l0_3/l1_1/l2_3@syncoid_iox86_2024-12-19:18:02:42-GMT-06:00': Input/output error
 408 B 0:00:00 [4.55KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-142cb251ad-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041c385eb6715c55ffe5000b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f9105748afda2b7b415b272801499e132c9f97989bcac0509c9a97a20f34aa443fc720de583fc730de503fc728ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0c2cac0c8cac448d7dd3744d7c0cccac000e6060080c92c9b
CRITICAL ERROR:  zfs send  -t 1-142cb251ad-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041c385eb6715c55ffe5000b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f9105748afda2b7b415b272801499e132c9f97989bcac0509c9a97a20f34aa443fc720de583fc730de503fc728ded8a1b8322f393f33253e33bfc2c22cdec8c0c844d7d048d7d0d2cad0c2cac0c8cac448d7dd3744d7c0cccac000e6060080c92c9b | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 525648 |  zfs receive  -s -F 'recv/test/l0_3/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_2@syncoid_iox86_2024-12-19:18:02:45-GMT-06:00 ... syncoid_iox86_2024-12-19:18:38:03-GMT-06:00 (~ 2.0 MB):
warning: cannot send 'send/test/l0_3/l1_2@autosnap_2024-12-20_00:15:07_frequently': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
68.0KiB 0:00:00 [ 378KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x21000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2'@'syncoid_iox86_2024-12-19:18:02:45-GMT-06:00' 'send/test/l0_3/l1_2'@'syncoid_iox86_2024-12-19:18:38:03-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2069640 |  zfs receive  -s -F 'recv/test/l0_3/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2/l2_0@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:38:05-GMT-06:00 (~ 11.4 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_0@syncoid_iox86_2024-12-19:15:41:33-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_2/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 238KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_0'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_3/l1_2/l2_0'@'syncoid_iox86_2024-12-19:18:38:05-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 11992184 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_2/l2_1 to recv/test/l0_3/l1_2/l2_1 (~ 2.0 MB remaining):
warning: cannot send 'send/test/l0_3/l1_2/l2_1@syncoid_iox86_2024-12-19:15:41:35-GMT-06:00': Input/output error
2.09KiB 0:00:00 [16.6KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-12522561b3-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1aa35016c3ed32f952900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b7c9cff682a8a5f104a4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d6cf318c37d2cf318a377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53231b43236d575f70dd13530b3323080b9010048ea2b1c
CRITICAL ERROR:  zfs send  -t 1-12522561b3-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1aa35016c3ed32f952900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b7c9cff682a8a5f104a4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d6cf318c37d2cf318a377428aecc4bcecf4c89cfccafb0308b37323032d13534d235b4b43234b53231b43236d575f70dd13530b3323080b9010048ea2b1c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2113008 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_2/l2_2@syncoid_iox86_2024-12-19:18:02:50-GMT-06:00 ... syncoid_iox86_2024-12-19:18:38:08-GMT-06:00 (~ 1.1 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_2@autosnap_2024-12-20_00:15:07_frequently': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 467KiB/s] [====>                                                                                               ]  5%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_2'@'syncoid_iox86_2024-12-19:18:02:50-GMT-06:00' 'send/test/l0_3/l1_2/l2_2'@'syncoid_iox86_2024-12-19:18:38:08-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1159040 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_2/l2_3@autosnap_2024-12-20_00:00:37_frequently ... syncoid_iox86_2024-12-19:18:38:10-GMT-06:00 (~ 1.9 MB):
warning: cannot send 'send/test/l0_3/l1_2/l2_3@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
warning: cannot send 'send/test/l0_3/l1_2/l2_3@syncoid_iox86_2024-12-19:18:21:43-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_2/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 334KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_2/l2_3'@'autosnap_2024-12-20_00:00:37_frequently' 'send/test/l0_3/l1_2/l2_3'@'syncoid_iox86_2024-12-19:18:38:10-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2028680 |  zfs receive  -s -F 'recv/test/l0_3/l1_2/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_3@syncoid_iox86_2024-12-19:18:02:55-GMT-06:00 ... syncoid_iox86_2024-12-19:18:38:12-GMT-06:00 (~ 1.3 MB):
warning: cannot send 'send/test/l0_3/l1_3@autosnap_2024-12-20_00:15:07_frequently': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
72.0KiB 0:00:00 [ 423KiB/s] [====>                                                                                               ]  5%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x22000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3'@'syncoid_iox86_2024-12-19:18:02:55-GMT-06:00' 'send/test/l0_3/l1_3'@'syncoid_iox86_2024-12-19:18:38:12-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1405168 |  zfs receive  -s -F 'recv/test/l0_3/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_3/l2_0 to recv/test/l0_3/l1_3/l2_0 (~ 589 KB remaining):
warning: cannot send 'send/test/l0_3/l1_3/l2_0@syncoid_iox86_2024-12-19:17:42:12-GMT-06:00': Input/output error
7.56KiB 0:00:00 [ 102KiB/s] [>                                                                                                   ]  1%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-146a2ee2ca-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081c3bab8ffdb5284a62900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bfa03f6ccfe7b68d5820424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837863fd1c431061146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686e6562640564bbfb86e81a98591918c0dc0000779f2dc1
CRITICAL ERROR:  zfs send  -t 1-146a2ee2ca-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081c3bab8ffdb5284a62900d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bfa03f6ccfe7b68d5820424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837863fd1c431061146fe0505c99979c9f99129f995f6161166f646064a26b68a46b686965686e6562640564bbfb86e81a98591918c0dc0000779f2dc1 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 603472 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_3/l2_1 to recv/test/l0_3/l1_3/l2_1 (~ 973 KB remaining):
warning: cannot send 'send/test/l0_3/l1_3/l2_1@syncoid_iox86_2024-12-19:15:26:24-GMT-06:00': Input/output error
2.09KiB 0:00:00 [14.6KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-104c025c0f-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c17badf6b2c9450a8b15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec41542375f4f333dd02f938024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fac9f6308228ce20d1d8a2bf392f33353e233f32b2ccce28d0c8c4c740d8d740d2dad0c4dad8cccac805c77df105d03332b0303981b00d3132c63
CRITICAL ERROR:  zfs send  -t 1-104c025c0f-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c17badf6b2c9450a8b15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec41542375f4f333dd02f938024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fac9f6308228ce20d1d8a2bf392f33353e233f32b2ccce28d0c8c4c740d8d740d2dad0c4dad8cccac805c77df105d03332b0303981b00d3132c63 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 997240 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_3/l1_3/l2_2 to recv/test/l0_3/l1_3/l2_2 (~ UNKNOWN remaining):
cannot resume send: incremental source 0xf700cd01329a3971 no longer exists
cannot receive: failed to read from stream
WARN: resetting partially receive state because the snapshot source no longer exists
Sending incremental send/test/l0_3/l1_3/l2_2@autosnap_2024-12-19_22:00:37_hourly ... syncoid_iox86_2024-12-19:18:38:41-GMT-06:00 (~ 8.0 MB):
warning: cannot send 'send/test/l0_3/l1_3/l2_2@syncoid_iox86_2024-12-19:16:12:20-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 246KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3/l2_2'@'autosnap_2024-12-19_22:00:37_hourly' 'send/test/l0_3/l1_3/l2_2'@'syncoid_iox86_2024-12-19:18:38:41-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 8399656 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-19:15:10:56-GMT-06:00 ... syncoid_iox86_2024-12-19:18:38:44-GMT-06:00 (~ 9.4 MB):
warning: cannot send 'send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-19:15:26:29-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_3/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 271KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3/l2_3'@'syncoid_iox86_2024-12-19:15:10:56-GMT-06:00' 'send/test/l0_3/l1_3/l2_3'@'syncoid_iox86_2024-12-19:18:38:44-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 9804992 |  zfs receive  -s -F 'recv/test/l0_3/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
real 262.13
user 19.62
sys 232.62
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
config:

        NAME                            STATE     READ WRITE CKSUM
        send                            ONLINE       0     0     0
          wwn-0x5002538d40dca5d9-part7  ONLINE       0     0     0

errors: 222 data errors, use '-v' for a list


CRITICAL ERROR: Target recv exists but has no snapshots matching with send!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.

Sending incremental send/test@syncoid_iox86_2024-12-19:18:34:24-GMT-06:00 ... syncoid_iox86_2024-12-19:18:51:16-GMT-06:00 (~ 4 KB):
2.13KiB 0:00:00 [29.7KiB/s] [====================================================>                                               ] 53%            
Resuming interrupted zfs send/receive from send/test/l0_0 to recv/test/l0_0 (~ 513 KB remaining):
internal error: warning: cannot send 'send/test/l0_0@syncoid_iox86_2024-12-19:16:55:08-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-11ac6a83fa-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1fbaf06c22593bdef2800d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b7867defaf07fc9bfb60824794eb07c5e626e2a0343716a5e8a3ed0a812fd1c83780387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43332b53532b030b5d77df105d03332b030384dd0055552ba4 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 525648 |  zfs receive  -s -F 'recv/test/l0_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_0@syncoid_iox86_2024-12-19:18:34:26-GMT-06:00 ... syncoid_iox86_2024-12-19:18:51:18-GMT-06:00 (~ 557 KB):
warning: cannot send 'send/test/l0_0/l1_0@autosnap_2024-12-20_00:45:07_frequently': Input/output error
1.83KiB 0:00:00 [23.1KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0'@'syncoid_iox86_2024-12-19:18:34:26-GMT-06:00' 'send/test/l0_0/l1_0'@'syncoid_iox86_2024-12-19:18:51:18-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 571328 |  zfs receive  -s -F 'recv/test/l0_0/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-19:18:34:28-GMT-06:00 ... syncoid_iox86_2024-12-19:18:51:20-GMT-06:00 (~ 1.5 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_0@autosnap_2024-12-20_00:45:07_frequently': Input/output error
1.83KiB 0:00:00 [20.8KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_0'@'syncoid_iox86_2024-12-19:18:34:28-GMT-06:00' 'send/test/l0_0/l1_0/l2_0'@'syncoid_iox86_2024-12-19:18:51:20-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1526984 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-19:18:34:31-GMT-06:00 ... syncoid_iox86_2024-12-19:18:51:22-GMT-06:00 (~ 650 KB):
warning: cannot send 'send/test/l0_0/l1_0/l2_1@autosnap_2024-12-20_00:45:07_frequently': Invalid argument
1.52KiB 0:00:00 [18.7KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_0/l2_1 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_1'@'syncoid_iox86_2024-12-19:18:34:31-GMT-06:00' 'send/test/l0_0/l1_0/l2_1'@'syncoid_iox86_2024-12-19:18:51:22-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 665720 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_0/l2_2@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:51:24-GMT-06:00 (~ 13.1 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-19:15:39:11-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_0/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 230KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_2'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_0/l1_0/l2_2'@'syncoid_iox86_2024-12-19:18:51:24-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 13707512 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_0/l2_3@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:18:51:27-GMT-06:00 (~ 6.4 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-19:16:55:19-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_0/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 275KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_3'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0/l1_0/l2_3'@'syncoid_iox86_2024-12-19:18:51:27-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 6697168 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_1@syncoid_iox86_2024-12-19:15:08:02-GMT-06:00 ... syncoid_iox86_2024-12-19:18:51:29-GMT-06:00 (~ 12.0 MB):
warning: cannot send 'send/test/l0_0/l1_1@syncoid_iox86_2024-12-19:15:23:43-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 297KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1'@'syncoid_iox86_2024-12-19:15:08:02-GMT-06:00' 'send/test/l0_0/l1_1'@'syncoid_iox86_2024-12-19:18:51:29-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 12611512 |  zfs receive  -s -F 'recv/test/l0_0/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-19:18:34:40-GMT-06:00 ... syncoid_iox86_2024-12-19:18:51:31-GMT-06:00 (~ 633 KB):
warning: cannot send 'send/test/l0_0/l1_1/l2_0@autosnap_2024-12-20_00:45:07_frequently': Invalid argument
1.52KiB 0:00:00 [18.2KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_1/l2_0 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_0'@'syncoid_iox86_2024-12-19:18:34:40-GMT-06:00' 'send/test/l0_0/l1_1/l2_0'@'syncoid_iox86_2024-12-19:18:51:31-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 649152 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-19:18:34:42-GMT-06:00 ... syncoid_iox86_2024-12-19:18:51:33-GMT-06:00 (~ 942 KB):
warning: cannot send 'send/test/l0_0/l1_1/l2_1@autosnap_2024-12-20_00:45:07_frequently': Invalid argument
1.52KiB 0:00:00 [17.9KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_1/l2_1 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_1'@'syncoid_iox86_2024-12-19:18:34:42-GMT-06:00' 'send/test/l0_0/l1_1/l2_1'@'syncoid_iox86_2024-12-19:18:51:33-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 965096 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_1/l2_2 to recv/test/l0_0/l1_1/l2_2 (~ 1.6 MB remaining):
warning: cannot send 'send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-19:15:39:20-GMT-06:00': Input/output error
2.09KiB 0:00:00 [16.1KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11177557f2-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081c4c4e71382d77d085200b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f910575c3f7540748be61b830424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837803fd1cc37843fd1ca3782387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b634b2b23035d77df105d03332b0303981b00726e2d47
CRITICAL ERROR:  zfs send  -t 1-11177557f2-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081c4c4e71382d77d085200b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f910575c3f7540748be61b830424794eb07c5e626e2a0343716a5e8a3ed0a812fd1c837803fd1cc37843fd1ca3782387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d434b2b43532b634b2b23035d77df105d03332b0303981b00726e2d47 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1678096 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-19:15:23:52-GMT-06:00 ... syncoid_iox86_2024-12-19:18:51:36-GMT-06:00 (~ 10.1 MB):
warning: cannot send 'send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-19:15:39:22-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 324KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_3'@'syncoid_iox86_2024-12-19:15:23:52-GMT-06:00' 'send/test/l0_0/l1_1/l2_3'@'syncoid_iox86_2024-12-19:18:51:36-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 10621200 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_2@syncoid_iox86_2024-12-19:18:34:49-GMT-06:00 ... syncoid_iox86_2024-12-19:18:51:38-GMT-06:00 (~ 585 KB):
warning: cannot send 'send/test/l0_0/l1_2@autosnap_2024-12-20_00:45:07_frequently': Input/output error
1.83KiB 0:00:00 [22.3KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2'@'syncoid_iox86_2024-12-19:18:34:49-GMT-06:00' 'send/test/l0_0/l1_2'@'syncoid_iox86_2024-12-19:18:51:38-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 600000 |  zfs receive  -s -F 'recv/test/l0_0/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-19:15:23:56-GMT-06:00 ... syncoid_iox86_2024-12-19:18:51:40-GMT-06:00 (~ 10.2 MB):
warning: cannot send 'send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-19:15:39:26-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 293KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_0'@'syncoid_iox86_2024-12-19:15:23:56-GMT-06:00' 'send/test/l0_0/l1_2/l2_0'@'syncoid_iox86_2024-12-19:18:51:40-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 10687288 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-19:15:23:58-GMT-06:00 ... syncoid_iox86_2024-12-19:18:51:42-GMT-06:00 (~ 9.7 MB):
warning: cannot send 'send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-19:15:39:28-GMT-06:00': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 258KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_1'@'syncoid_iox86_2024-12-19:15:23:58-GMT-06:00' 'send/test/l0_0/l1_2/l2_1'@'syncoid_iox86_2024-12-19:18:51:42-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 10166360 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-19:18:34:55-GMT-06:00 ... syncoid_iox86_2024-12-19:18:51:44-GMT-06:00 (~ 1010 KB):
warning: cannot send 'send/test/l0_0/l1_2/l2_2@autosnap_2024-12-20_00:45:07_frequently': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 252KiB/s] [=====>                                                                                              ]  6%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_2'@'syncoid_iox86_2024-12-19:18:34:55-GMT-06:00' 'send/test/l0_0/l1_2/l2_2'@'syncoid_iox86_2024-12-19:18:51:44-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1034728 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-19:18:34:58-GMT-06:00 ... syncoid_iox86_2024-12-19:18:51:47-GMT-06:00 (~ 966 KB):
warning: cannot send 'send/test/l0_0/l1_2/l2_3@autosnap_2024-12-20_00:45:07_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_2/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 387KiB/s] [=====>                                                                                              ]  6%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_3'@'syncoid_iox86_2024-12-19:18:34:58-GMT-06:00' 'send/test/l0_0/l1_2/l2_3'@'syncoid_iox86_2024-12-19:18:51:47-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 989672 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_3@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:18:51:49-GMT-06:00 (~ 7.3 MB):
warning: cannot send 'send/test/l0_0/l1_3@syncoid_iox86_2024-12-19:16:55:34-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3 does not
match incremental source
64.0KiB 0:00:00 [ 296KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0/l1_3'@'syncoid_iox86_2024-12-19:18:51:49-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 7661016 |  zfs receive  -s -F 'recv/test/l0_0/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_3/l2_0@autosnap_2024-12-19_22:45:07_frequently ... syncoid_iox86_2024-12-19:18:51:51-GMT-06:00 (~ 6.9 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-19:16:55:36-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 262KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_0'@'autosnap_2024-12-19_22:45:07_frequently' 'send/test/l0_0/l1_3/l2_0'@'syncoid_iox86_2024-12-19:18:51:51-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 7230200 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-19:18:35:04-GMT-06:00 ... syncoid_iox86_2024-12-19:18:51:54-GMT-06:00 (~ 1.6 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_1@autosnap_2024-12-20_00:45:07_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 383KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_1'@'syncoid_iox86_2024-12-19:18:35:04-GMT-06:00' 'send/test/l0_0/l1_3/l2_1'@'syncoid_iox86_2024-12-19:18:51:54-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1649864 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-19:18:35:07-GMT-06:00 ... syncoid_iox86_2024-12-19:18:51:56-GMT-06:00 (~ 1.5 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_2@autosnap_2024-12-20_00:45:07_frequently': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 543KiB/s] [===>                                                                                                ]  4%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_2'@'syncoid_iox86_2024-12-19:18:35:07-GMT-06:00' 'send/test/l0_0/l1_3/l2_2'@'syncoid_iox86_2024-12-19:18:51:56-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1592704 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_3/l2_3@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:51:58-GMT-06:00 (~ 12.5 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-19:15:39:44-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 227KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_3'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_0/l1_3/l2_3'@'syncoid_iox86_2024-12-19:18:51:58-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 13087728 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1@syncoid_iox86_2024-12-19:18:35:11-GMT-06:00 ... syncoid_iox86_2024-12-19:18:52:00-GMT-06:00 (~ 1.2 MB):
 941KiB 0:00:00 [4.38MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_1/l1_0@autosnap_2024-12-19_21:00:17_hourly ... syncoid_iox86_2024-12-19:18:52:02-GMT-06:00 (~ 13.8 MB):
warning: cannot send 'send/test/l0_1/l1_0@syncoid_iox86_2024-12-19:15:39:47-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_0 does not
match incremental source
64.0KiB 0:00:00 [ 247KiB/s] [>                                                                                                   ]  0%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0'@'autosnap_2024-12-19_21:00:17_hourly' 'send/test/l0_1/l1_0'@'syncoid_iox86_2024-12-19:18:52:02-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 14441064 |  zfs receive  -s -F 'recv/test/l0_1/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-19:18:19:07-GMT-06:00 ... syncoid_iox86_2024-12-19:18:52:04-GMT-06:00 (~ 2.0 MB):
warning: cannot send 'send/test/l0_1/l1_0/l2_0@autosnap_2024-12-20_00:30:07_frequently': Input/output error
warning: cannot send 'send/test/l0_1/l1_0/l2_0@autosnap_2024-12-20_00:45:07_frequently': Invalid argument
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
64.0KiB 0:00:00 [ 464KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_0'@'syncoid_iox86_2024-12-19:18:19:07-GMT-06:00' 'send/test/l0_1/l1_0/l2_0'@'syncoid_iox86_2024-12-19:18:52:04-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2061448 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-19:18:35:17-GMT-06:00 ... syncoid_iox86_2024-12-19:18:52:06-GMT-06:00 (~ 1.8 MB):
warning: cannot send 'send/test/l0_1/l1_0/l2_1@autosnap_2024-12-20_00:45:07_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_0/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 370KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_1'@'syncoid_iox86_2024-12-19:18:35:17-GMT-06:00' 'send/test/l0_1/l1_0/l2_1'@'syncoid_iox86_2024-12-19:18:52:06-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1928944 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-19:18:35:20-GMT-06:00 ... syncoid_iox86_2024-12-19:18:52:08-GMT-06:00 (~ 1.4 MB):
warning: cannot send 'send/test/l0_1/l1_0/l2_2@autosnap_2024-12-20_00:45:07_frequently': Invalid argument
warning: cannot send 'send/test/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-19:18:52:08-GMT-06:00': Invalid argument
 936 B 0:00:00 [10.3KiB/s] [>                                                                                                    ]  0%            
Resuming interrupted zfs send/receive from send/test/l0_1/l1_0/l2_3 to recv/test/l0_1/l1_0/l2_3 (~ 1.1 MB remaining):
warning: cannot send 'send/test/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-19:15:24:26-GMT-06:00': Input/output error
 408 B 0:00:00 [2.51KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-13e81ab7c3-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1e28bad72b2170edd5000b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057c84dbee377f0b55c7e02923c27583e2f31379581a138352f451f6854897e8e41bca17e8e61bc817e8e51bcb14371655e727e664a7c667e858559bc91819189aea191aea1a595a1a9959189959199aebb6f88ae8199958101cc0d0080782d28
CRITICAL ERROR:  zfs send  -t 1-13e81ab7c3-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1e28bad72b2170edd5000b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057c84dbee377f0b55c7e02923c27583e2f31379581a138352f451f6854897e8e41bca17e8e61bc817e8e51bcb14371655e727e664a7c667e858559bc91819189aea191aea1a595a1a9959189959199aebb6f88ae8199958101cc0d0080782d28 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1132592 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_1 to recv/test/l0_1/l1_1 (~ 909 KB remaining):
warning: cannot send 'send/test/l0_1/l1_1@autosnap_2024-12-20_00:15:07_frequently': Input/output error
 408 B 0:00:00 [3.81KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-101ba0d766-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1c5d4ac25968dd9e714806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415a6ff3ef5336d7b24118124cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa89f63186fe890585a925f9c9758106f646064a26b68a46b64106f606065686a65601e9f56945a589a9a57925309b71b00dace2c84
CRITICAL ERROR:  zfs send  -t 1-101ba0d766-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1c5d4ac25968dd9e714806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415a6ff3ef5336d7b24118124cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa89f63186fe890585a925f9c9758106f646064a26b68a46b64106f606065686a65601e9f56945a589a9a57925309b71b00dace2c84 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 931704 |  zfs receive  -s -F 'recv/test/l0_1/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_1/l2_0 to recv/test/l0_1/l1_1/l2_0 (~ 380 KB remaining):
warning: cannot send 'send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-19:16:40:55-GMT-06:00': Input/output error
 408 B 0:00:00 [3.36KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-121563953e-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1c5cf21ab19592aa72800d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b8c263edec0102ef03c01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc7104418c51b381457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a59991858999aeabafb86e81a98591918c0dc00009fe92bee
CRITICAL ERROR:  zfs send  -t 1-121563953e-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1c5cf21ab19592aa72800d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b8c263edec0102ef03c01499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc7104418c51b381457e625e767a6c467e6575898c51b191899e81a1ae91a5a5a199a59991858999aeabafb86e81a98591918c0dc00009fe92bee | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 390112 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_1/l2_1@autosnap_2024-12-20_00:00:37_frequently ... syncoid_iox86_2024-12-19:18:52:12-GMT-06:00 (~ 3.1 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_1@autosnap_2024-12-20_00:15:07_frequently': Invalid argument
warning: cannot send 'send/test/l0_1/l1_1/l2_1@autosnap_2024-12-20_00:45:07_frequently': Input/output error
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_1/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 349KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_1'@'autosnap_2024-12-20_00:00:37_frequently' 'send/test/l0_1/l1_1/l2_1'@'syncoid_iox86_2024-12-19:18:52:12-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 3227616 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_1/l2_2 to recv/test/l0_1/l1_1/l2_2 (~ 1.1 MB remaining):
warning: cannot send 'send/test/l0_1/l1_1/l2_2@autosnap_2024-12-20_00:15:07_frequently': Input/output error
5.22KiB 0:00:00 [46.4KiB/s] [>                                                                                                   ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-e753b203e-118-789c636064000310a501c49c50360710a715e5e7a69766a630400117cf8a7a85a9aa0715806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4159d4c3f7d980ed6ff4b4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d4cf31041146f1460e89a525f9c5798905f146064626ba8646ba4606f106065686a65606e6f16945a985a5a979253995484e600000e6232c35
CRITICAL ERROR:  zfs send  -t 1-e753b203e-118-789c636064000310a501c49c50360710a715e5e7a69766a630400117cf8a7a85a9aa0715806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4159d4c3f7d980ed6ff4b4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d4cf31041146f1460e89a525f9c5798905f146064626ba8646ba4606f106065686a65606e6f16945a985a5a979253995484e600000e6232c35 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1194216 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_1/l2_3 to recv/test/l0_1/l1_1/l2_3 (~ UNKNOWN remaining):

Broadcast message from root@iox86 on pts/4 (Thu 2024-12-19 18:52:35 CST):

The system will reboot now!

Connection to mesquite closed by remote host.
Connection to mesquite closed.
hbarta@olive:~$ 
```
