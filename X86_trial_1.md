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