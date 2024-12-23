# X86 trial ZFS from backports

The first trial was inconclusive in that H/W errors may have caused the errors. Before repeating, ZFS will be upgraded from `bookworm-backports`.

## 2024-12-20 upgrade ZFS

Following instructions at <https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/index.html#installation>

```text
root@iox86:~# apt list --upgradable
Listing... Done
libnvpair3linux/stable-backports 2.2.6-1~bpo12+3 amd64 [upgradable from: 2.1.11-1]
libuutil3linux/stable-backports 2.2.6-1~bpo12+3 amd64 [upgradable from: 2.1.11-1]
libzfs4linux/stable-backports 2.2.6-1~bpo12+3 amd64 [upgradable from: 2.1.11-1]
libzpool5linux/stable-backports 2.2.6-1~bpo12+3 amd64 [upgradable from: 2.1.11-1]
zfs-dkms/stable-backports 2.2.6-1~bpo12+3 all [upgradable from: 2.1.11-1]
zfs-zed/stable-backports 2.2.6-1~bpo12+3 amd64 [upgradable from: 2.1.11-1]
zfsutils-linux/stable-backports 2.2.6-1~bpo12+3 amd64 [upgradable from: 2.1.11-1]
root@iox86:~# 
```

```text
root@iox86:~# zfs --version
zfs-2.2.6-1~bpo12+3
zfs-kmod-2.2.6-1~bpo12+3
root@iox86:~# 
```

## 2024-12-20 destroy and reconstitute pools

```text
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
rm -r /mnt/recv
zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O mountpoint=/mnt/recv \
      recv wwn-0x5002538d40dca5d9-part8
chmod a+rwx /mnt/recv/
```

```text
root@iox86:~# zpool destroy send
root@iox86:~# zpool destroy recv
root@iox86:~# zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O encryption=aes-256-gcm  -O keylocation=file:///pool-key -O keyformat=raw \
      -O mountpoint=/mnt/send \
      send wwn-0x5002538d40dca5d9-part7
mountpoint '/mnt/send' exists and is not empty
use '-m' option to provide a different default
root@iox86:~# rm -r /mnt/send
root@iox86:~# zpool create -o ashift=12       -O acltype=posixacl -O canmount=on -O compression=lz4       -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa       -O encryption=aes-256-gcm  -O keylocation=file:///pool-key -O keyformat=raw       -O mountpoint=/mnt/send       send wwn-0x5002538d40dca5d9-part7
root@iox86:~# rm -r /mnt/recv
root@iox86:~# zfs load-key -a
chmod a+rwx /mnt/send/
root@iox86:~# rm -r /mnt/recv
zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O mountpoint=/mnt/recv \
      recv wwn-0x5002538d40dca5d9-part8
chmod a+rwx /mnt/recv/
rm: cannot remove '/mnt/recv': No such file or directory
root@iox86:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   440G   548K   440G        -         -     0%     0%  1.00x    ONLINE  -
send   448G   576K   448G        -         -     0%     0%  1.00x    ONLINE  -
root@iox86:~# 
```

```text
cd /home/hbarta/Programming/provoke_ZFS_corruption
root@iox86:/home/hbarta/Programming/provoke_ZFS_corruption# ./populate_pool.sh 
```

Repeated a second time to get to 59%.

```text
hbarta@iox86:~$ find /mnt/send -type f | wc -l
5497
hbarta@iox86:~$ zfs list -r send|wc -l
142
hbarta@iox86:~$ 
```

```
user=hbarta
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    send
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    recv
time -p /sbin/syncoid --recursive --no-privilege-elevation send/text recv/text
```

```text
hbarta@iox86:~$ time -p /sbin/syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_iox86_2024-12-20:19:35:30-GMT-06:00 (~ 88 KB) to new target filesystem:
52.4KiB 0:00:00 [2.02MiB/s] [==========================================================>                                         ] 59%            
cannot mount 'recv/test': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_iox86_2024-12-20:19:35:30-GMT-06:00 (~ 63.5 GB) to new target filesystem:
63.5GiB 0:03:39 [ 297MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_iox86_2024-12-20:19:39:09-GMT-06:00 (~ 53.4 GB) to new target filesystem:
53.4GiB 0:02:58 [ 306MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_0': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-20:19:42:08-GMT-06:00 (~ 72.6 GB) to new target filesystem:
72.7GiB 0:04:13 [ 293MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_0/l2_0': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 75.4 GB) to new target filesystem:
75.4GiB 0:04:17 [ 299MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_0/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_0/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:19:46:21-GMT-06:00 (~ 4 KB):
3.35KiB 0:00:00 [29.7KiB/s] [==================================================================================>                 ] 83%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 58.2 GB) to new target filesystem:
58.2GiB 0:03:25 [ 289MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_0/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_0/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:19:50:40-GMT-06:00 (~ 4 KB):
3.35KiB 0:00:00 [27.3KiB/s] [==================================================================================>                 ] 83%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 47.0 GB) to new target filesystem:
47.0GiB 0:02:36 [ 306MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_0/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_0/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:19:54:07-GMT-06:00 (~ 4 KB):
3.35KiB 0:00:00 [31.2KiB/s] [==================================================================================>                 ] 83%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@autosnap_2024-12-21_01:45:51_monthly (~ 72.1 GB) to new target filesystem:
72.1GiB 0:04:06 [ 299MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:19:56:44-GMT-06:00 (~ 4 KB):
3.35KiB 0:00:00 [32.3KiB/s] [==================================================================================>                 ] 83%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 67.3 GB) to new target filesystem:
67.4GiB 0:03:53 [ 295MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_1/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_1/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:20:00:51-GMT-06:00 (~ 4 KB):
4.57KiB 0:00:00 [35.2KiB/s] [===================================================================================================] 114%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 70.0 GB) to new target filesystem:
70.1GiB 0:04:01 [ 296MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_1/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_1/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:20:04:46-GMT-06:00 (~ 4 KB):
4.57KiB 0:00:00 [36.6KiB/s] [===================================================================================================] 114%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 70.7 GB) to new target filesystem:
70.7GiB 0:04:07 [ 292MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_1/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_1/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:20:08:49-GMT-06:00 (~ 4 KB):
4.57KiB 0:00:00 [34.6KiB/s] [===================================================================================================] 114%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 60.2 GB) to new target filesystem:
60.2GiB 0:03:24 [ 301MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_1/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_1/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:20:12:58-GMT-06:00 (~ 4 KB):
4.57KiB 0:00:00 [32.6KiB/s] [===================================================================================================] 114%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@autosnap_2024-12-21_01:45:51_monthly (~ 56.0 GB) to new target filesystem:
56.0GiB 0:03:13 [ 296MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:20:16:24-GMT-06:00 (~ 4 KB):
5.18KiB 0:00:00 [40.1KiB/s] [===================================================================================================] 121%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 56.8 GB) to new target filesystem:
56.8GiB 0:03:14 [ 299MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_2/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_2/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:20:19:38-GMT-06:00 (~ 4 KB):
5.18KiB 0:00:00 [38.1KiB/s] [===================================================================================================] 121%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 55.3 GB) to new target filesystem:
55.3GiB 0:03:08 [ 301MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_2/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_2/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:20:22:53-GMT-06:00 (~ 4 KB):
5.18KiB 0:00:00 [37.5KiB/s] [===================================================================================================] 121%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 62.2 GB) to new target filesystem:
62.2GiB 0:03:36 [ 294MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_2/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_2/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:20:26:03-GMT-06:00 (~ 4 KB):
5.18KiB 0:00:00 [37.4KiB/s] [===================================================================================================] 121%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 66.1 GB) to new target filesystem:
66.1GiB 0:03:50 [ 294MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_2/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_2/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:20:29:40-GMT-06:00 (~ 4 KB):
5.18KiB 0:00:00 [34.9KiB/s] [===================================================================================================] 121%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@autosnap_2024-12-21_01:45:51_monthly (~ 51.5 GB) to new target filesystem:
51.5GiB 0:02:52 [ 305MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:20:33:32-GMT-06:00 (~ 4 KB):
5.79KiB 0:00:00 [41.5KiB/s] [===================================================================================================] 118%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 49.4 GB) to new target filesystem:
49.4GiB 0:02:46 [ 304MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_3/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_3/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:20:36:25-GMT-06:00 (~ 4 KB):
5.79KiB 0:00:00 [40.0KiB/s] [===================================================================================================] 118%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 73.3 GB) to new target filesystem:
73.3GiB 0:04:14 [ 295MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_3/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_3/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:20:39:13-GMT-06:00 (~ 4 KB):
5.79KiB 0:00:00 [37.5KiB/s] [===================================================================================================] 118%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 63.8 GB) to new target filesystem:
63.8GiB 0:03:36 [ 302MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_3/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_3/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:20:43:28-GMT-06:00 (~ 4 KB):
5.79KiB 0:00:00 [34.2KiB/s] [===================================================================================================] 118%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 64.2 GB) to new target filesystem:
64.2GiB 0:03:41 [ 297MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_3/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_3/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:20:47:06-GMT-06:00 (~ 5 KB):
6.40KiB 0:00:00 [37.4KiB/s] [===================================================================================================] 116%            
INFO: Sending oldest full snapshot send/test/l0_1@autosnap_2024-12-21_01:45:51_monthly (~ 60.6 GB) to new target filesystem:
60.6GiB 0:03:29 [ 296MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:20:50:48-GMT-06:00 (~ 5 KB):
6.40KiB 0:00:00 [49.0KiB/s] [===================================================================================================] 116%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@autosnap_2024-12-21_01:45:51_monthly (~ 63.3 GB) to new target filesystem:
63.4GiB 0:03:36 [ 299MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:20:54:19-GMT-06:00 (~ 5 KB):
6.40KiB 0:00:00 [44.0KiB/s] [===================================================================================================] 116%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 80.6 GB) to new target filesystem:
80.6GiB 0:04:37 [ 297MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_0/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_0/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:20:57:57-GMT-06:00 (~ 5 KB):
6.40KiB 0:00:00 [36.4KiB/s] [===================================================================================================] 116%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 48.5 GB) to new target filesystem:
48.5GiB 0:02:41 [ 307MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_0/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_0/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:21:02:35-GMT-06:00 (~ 6 KB):
7.62KiB 0:00:00 [41.1KiB/s] [===================================================================================================] 113%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 54.2 GB) to new target filesystem:
54.2GiB 0:03:06 [ 297MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_0/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_0/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:21:05:18-GMT-06:00 (~ 6 KB):
7.62KiB 0:00:00 [41.0KiB/s] [===================================================================================================] 113%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 55.5 GB) to new target filesystem:
55.5GiB 0:03:08 [ 302MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_0/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_0/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:21:08:26-GMT-06:00 (~ 6 KB):
7.62KiB 0:00:00 [43.8KiB/s] [===================================================================================================] 113%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@autosnap_2024-12-21_01:45:51_monthly (~ 62.5 GB) to new target filesystem:
62.5GiB 0:03:30 [ 304MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:21:11:36-GMT-06:00 (~ 6 KB):
7.62KiB 0:00:00 [43.5KiB/s] [===================================================================================================] 113%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 64.2 GB) to new target filesystem:
64.2GiB 0:03:40 [ 298MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_1/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_1/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:21:15:08-GMT-06:00 (~ 6 KB):
7.62KiB 0:00:00 [40.4KiB/s] [===================================================================================================] 113%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 40.3 GB) to new target filesystem:
40.3GiB 0:02:20 [ 293MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_1/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_1/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:21:18:50-GMT-06:00 (~ 7 KB):
8.23KiB 0:00:00 [43.6KiB/s] [===================================================================================================] 112%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 60.1 GB) to new target filesystem:
60.1GiB 0:03:24 [ 300MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_1/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_1/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:21:21:12-GMT-06:00 (~ 7 KB):
8.23KiB 0:00:00 [41.3KiB/s] [===================================================================================================] 112%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 51.2 GB) to new target filesystem:
51.2GiB 0:02:54 [ 301MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_1/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_1/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:21:24:39-GMT-06:00 (~ 7 KB):
8.23KiB 0:00:00 [41.4KiB/s] [===================================================================================================] 112%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2@autosnap_2024-12-21_01:45:51_monthly (~ 57.6 GB) to new target filesystem:
57.6GiB 0:03:18 [ 297MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:21:27:34-GMT-06:00 (~ 7 KB):
8.23KiB 0:00:00 [47.0KiB/s] [===================================================================================================] 112%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 60.2 GB) to new target filesystem:
60.3GiB 0:03:19 [ 309MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_2/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_2/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:21:30:55-GMT-06:00 (~ 7 KB):
8.84KiB 0:00:00 [45.8KiB/s] [===================================================================================================] 111%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 73.8 GB) to new target filesystem:
73.8GiB 0:04:06 [ 306MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_2/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_2/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:21:34:16-GMT-06:00 (~ 7 KB):
8.84KiB 0:00:00 [47.0KiB/s] [===================================================================================================] 111%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 68.1 GB) to new target filesystem:
68.1GiB 0:03:51 [ 301MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_2/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_2/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:21:38:24-GMT-06:00 (~ 7 KB):
8.84KiB 0:00:00 [45.7KiB/s] [===================================================================================================] 111%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 51.9 GB) to new target filesystem:
51.9GiB 0:02:59 [ 295MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_2/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_2/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:21:42:17-GMT-06:00 (~ 7 KB):
8.84KiB 0:00:00 [44.1KiB/s] [===================================================================================================] 111%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3@autosnap_2024-12-21_01:45:51_monthly (~ 55.9 GB) to new target filesystem:
55.9GiB 0:03:12 [ 297MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:21:45:19-GMT-06:00 (~ 7 KB):
8.84KiB 0:00:00 [44.5KiB/s] [===================================================================================================] 111%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 69.4 GB) to new target filesystem:
69.4GiB 0:04:01 [ 294MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_3/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_3/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:21:48:33-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [45.0KiB/s] [===================================================================================================] 110%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 66.1 GB) to new target filesystem:
66.1GiB 0:03:48 [ 296MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_3/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_3/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:21:52:36-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [45.6KiB/s] [===================================================================================================] 110%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 69.4 GB) to new target filesystem:
69.5GiB 0:03:59 [ 296MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_3/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_3/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:21:56:26-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [44.4KiB/s] [===================================================================================================] 110%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 74.1 GB) to new target filesystem:
74.1GiB 0:04:14 [ 298MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_3/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_3/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:22:00:27-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [42.8KiB/s] [===================================================================================================] 110%            
INFO: Sending oldest full snapshot send/test/l0_2@autosnap_2024-12-21_01:45:51_monthly (~ 58.5 GB) to new target filesystem:
58.5GiB 0:03:17 [ 303MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:22:04:44-GMT-06:00 (~ 9 KB):
10.7KiB 0:00:00 [54.1KiB/s] [===================================================================================================] 109%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_0@autosnap_2024-12-21_01:45:51_monthly (~ 63.1 GB) to new target filesystem:
63.2GiB 0:03:33 [ 303MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2/l1_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_2/l1_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:22:08:03-GMT-06:00 (~ 9 KB):
10.7KiB 0:00:00 [51.5KiB/s] [===================================================================================================] 109%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_0/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 59.2 GB) to new target filesystem:
59.2GiB 0:03:23 [ 297MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2/l1_0/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_2/l1_0/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:22:11:38-GMT-06:00 (~ 9 KB):
10.7KiB 0:00:00 [45.9KiB/s] [===================================================================================================] 109%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_0/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 55.3 GB) to new target filesystem:
55.3GiB 0:03:10 [ 297MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2/l1_0/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_2/l1_0/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:22:15:04-GMT-06:00 (~ 9 KB):
10.7KiB 0:00:00 [45.0KiB/s] [===================================================================================================] 109%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_0/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 62.7 GB) to new target filesystem:
62.7GiB 0:03:30 [ 304MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2/l1_0/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_2/l1_0/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:22:18:17-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [47.5KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_0/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 63.5 GB) to new target filesystem:
63.6GiB 0:03:39 [ 297MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2/l1_0/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_2/l1_0/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:22:21:50-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [44.5KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_1@autosnap_2024-12-21_01:45:51_monthly (~ 53.3 GB) to new target filesystem:
53.3GiB 0:03:03 [ 298MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2/l1_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_2/l1_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:22:25:31-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [52.0KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_1/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 67.2 GB) to new target filesystem:
67.3GiB 0:03:53 [ 295MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2/l1_1/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_2/l1_1/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:22:28:36-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [45.2KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_1/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 60.5 GB) to new target filesystem:
60.6GiB 0:03:29 [ 295MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2/l1_1/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_2/l1_1/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:22:32:32-GMT-06:00 (~ 9 KB):
10.7KiB 0:00:00 [45.0KiB/s] [===================================================================================================] 109%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_1/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 66.8 GB) to new target filesystem:
66.9GiB 0:03:44 [ 304MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2/l1_1/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_2/l1_1/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:22:36:04-GMT-06:00 (~ 9 KB):
10.7KiB 0:00:00 [46.6KiB/s] [===================================================================================================] 109%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_1/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 69.7 GB) to new target filesystem:
69.7GiB 0:04:01 [ 296MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2/l1_1/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_2/l1_1/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:22:39:51-GMT-06:00 (~ 9 KB):
10.7KiB 0:00:00 [44.2KiB/s] [===================================================================================================] 109%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_2@autosnap_2024-12-21_01:45:51_monthly (~ 65.7 GB) to new target filesystem:
65.7GiB 0:03:44 [ 300MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2/l1_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_2/l1_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:22:43:54-GMT-06:00 (~ 9 KB):
10.7KiB 0:00:00 [47.2KiB/s] [===================================================================================================] 109%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_2/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 58.8 GB) to new target filesystem:
58.8GiB 0:03:21 [ 299MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2/l1_2/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_2/l1_2/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:22:47:40-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [47.4KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_2/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 50.1 GB) to new target filesystem:
50.1GiB 0:02:53 [ 295MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2/l1_2/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_2/l1_2/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:22:51:04-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [47.4KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_2/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 46.8 GB) to new target filesystem:
46.8GiB 0:02:35 [ 307MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2/l1_2/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_2/l1_2/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:22:53:59-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [47.9KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_2/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 50.5 GB) to new target filesystem:
50.6GiB 0:02:52 [ 300MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2/l1_2/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_2/l1_2/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:22:56:37-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [45.9KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_3@autosnap_2024-12-21_01:45:51_monthly (~ 53.1 GB) to new target filesystem:
53.1GiB 0:03:01 [ 299MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2/l1_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_2/l1_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:22:59:32-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [48.6KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_3/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 61.3 GB) to new target filesystem:
61.3GiB 0:03:27 [ 302MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2/l1_3/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_2/l1_3/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:23:02:36-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [44.9KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_3/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 60.1 GB) to new target filesystem:
60.1GiB 0:03:28 [ 295MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2/l1_3/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_2/l1_3/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:23:06:06-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [47.6KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_3/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 52.4 GB) to new target filesystem:
52.4GiB 0:03:00 [ 296MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2/l1_3/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_2/l1_3/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:23:09:37-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [46.7KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_3/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 62.0 GB) to new target filesystem:
62.0GiB 0:03:37 [ 291MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_2/l1_3/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_2/l1_3/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:23:12:40-GMT-06:00 (~ 10 KB):
11.9KiB 0:00:00 [44.4KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_3@autosnap_2024-12-21_01:45:51_monthly (~ 58.0 GB) to new target filesystem:
58.0GiB 0:03:19 [ 298MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:23:16:20-GMT-06:00 (~ 10 KB):
11.9KiB 0:00:00 [54.3KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_3/l1_0@autosnap_2024-12-21_01:45:51_monthly (~ 59.0 GB) to new target filesystem:
59.1GiB 0:03:24 [ 296MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3/l1_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_3/l1_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:23:19:41-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [54.1KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_3/l1_0/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 56.8 GB) to new target filesystem:
56.8GiB 0:03:15 [ 297MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3/l1_0/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_3/l1_0/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:23:23:07-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [48.0KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_3/l1_0/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 55.1 GB) to new target filesystem:
55.1GiB 0:03:08 [ 298MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3/l1_0/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_3/l1_0/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:23:26:25-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [48.3KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_3/l1_0/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 63.8 GB) to new target filesystem:
63.9GiB 0:03:40 [ 296MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3/l1_0/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_3/l1_0/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:23:29:36-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [46.0KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_3/l1_0/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 68.3 GB) to new target filesystem:
68.4GiB 0:03:48 [ 305MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3/l1_0/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_3/l1_0/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:23:33:19-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [46.7KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_3/l1_1@autosnap_2024-12-21_01:45:51_monthly (~ 64.0 GB) to new target filesystem:
64.0GiB 0:03:35 [ 303MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3/l1_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_3/l1_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:23:37:10-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [51.5KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_3/l1_1/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 53.6 GB) to new target filesystem:
53.6GiB 0:03:04 [ 297MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3/l1_1/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_3/l1_1/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:23:40:48-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [46.6KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_3/l1_1/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 61.5 GB) to new target filesystem:
61.5GiB 0:03:30 [ 300MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3/l1_1/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_3/l1_1/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:23:43:55-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [45.5KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_3/l1_1/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 63.8 GB) to new target filesystem:
63.9GiB 0:03:38 [ 299MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3/l1_1/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_3/l1_1/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:23:47:27-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [47.2KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_3/l1_1/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 59.4 GB) to new target filesystem:
59.5GiB 0:03:27 [ 293MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3/l1_1/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_3/l1_1/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:23:51:08-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [47.6KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_3/l1_2@autosnap_2024-12-21_01:45:51_monthly (~ 62.8 GB) to new target filesystem:
62.8GiB 0:03:33 [ 301MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3/l1_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_3/l1_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:23:54:37-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [51.2KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_3/l1_2/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 49.8 GB) to new target filesystem:
49.8GiB 0:02:54 [ 291MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3/l1_2/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_3/l1_2/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-20:23:58:13-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [47.1KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_3/l1_2/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 71.3 GB) to new target filesystem:
71.3GiB 0:04:07 [ 294MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3/l1_2/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_3/l1_2/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:00:01:10-GMT-06:00 (~ 10 KB):
11.9KiB 0:00:00 [47.8KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_3/l1_2/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 49.4 GB) to new target filesystem:
49.5GiB 0:02:48 [ 300MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3/l1_2/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_3/l1_2/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:00:05:20-GMT-06:00 (~ 10 KB):
11.9KiB 0:00:00 [47.7KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_3/l1_2/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 71.2 GB) to new target filesystem:
71.2GiB 0:04:04 [ 297MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3/l1_2/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_3/l1_2/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:00:08:11-GMT-06:00 (~ 10 KB):
11.9KiB 0:00:00 [45.0KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_3/l1_3@autosnap_2024-12-21_01:45:51_monthly (~ 57.2 GB) to new target filesystem:
57.2GiB 0:03:17 [ 296MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3/l1_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_3/l1_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:00:12:18-GMT-06:00 (~ 10 KB):
11.9KiB 0:00:00 [49.5KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_3/l1_3/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 74.1 GB) to new target filesystem:
74.1GiB 0:04:14 [ 297MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3/l1_3/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_3/l1_3/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:00:15:37-GMT-06:00 (~ 10 KB):
11.9KiB 0:00:00 [45.0KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_3/l1_3/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 55.4 GB) to new target filesystem:
55.4GiB 0:03:11 [ 296MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3/l1_3/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_3/l1_3/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:00:19:55-GMT-06:00 (~ 10 KB):
11.9KiB 0:00:00 [46.9KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_3/l1_3/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 60.2 GB) to new target filesystem:
60.3GiB 0:03:24 [ 301MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3/l1_3/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_3/l1_3/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:00:23:08-GMT-06:00 (~ 10 KB):
11.9KiB 0:00:00 [48.4KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/l0_3/l1_3/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 63.6 GB) to new target filesystem:
63.6GiB 0:03:34 [ 304MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_3/l1_3/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/l0_3/l1_3/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:00:26:35-GMT-06:00 (~ 10 KB):
11.9KiB 0:00:00 [49.2KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/x@autosnap_2024-12-21_01:45:51_monthly (~ 103 KB) to new target filesystem:
49.6KiB 0:00:00 [1.70MiB/s] [===============================================>                                                    ] 48%            
cannot mount 'recv/test/x': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:00:30:12-GMT-06:00 (~ 10 KB):
11.9KiB 0:00:00 [51.4KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/x/l0_0@autosnap_2024-12-21_01:45:51_monthly (~ 60.9 GB) to new target filesystem:
60.9GiB 0:03:29 [ 297MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:00:30:14-GMT-06:00 (~ 10 KB):
11.9KiB 0:00:00 [46.7KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/x/l0_0/l1_0@autosnap_2024-12-21_01:45:51_monthly (~ 59.6 GB) to new target filesystem:
59.7GiB 0:03:21 [ 303MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_0/l1_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_0/l1_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:00:33:46-GMT-06:00 (~ 10 KB):
11.9KiB 0:00:00 [45.6KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/x/l0_0/l1_0/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 49.2 GB) to new target filesystem:
49.3GiB 0:02:50 [ 296MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_0/l1_0/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_0/l1_0/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:00:37:10-GMT-06:00 (~ 10 KB):
11.9KiB 0:00:00 [44.8KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/x/l0_0/l1_0/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 47.3 GB) to new target filesystem:
47.3GiB 0:02:39 [ 303MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_0/l1_0/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_0/l1_0/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:00:40:03-GMT-06:00 (~ 10 KB):
11.9KiB 0:00:00 [42.2KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/x/l0_0/l1_0/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 51.7 GB) to new target filesystem:
51.7GiB 0:02:54 [ 302MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_0/l1_0/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_0/l1_0/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:00:42:45-GMT-06:00 (~ 10 KB):
11.9KiB 0:00:00 [41.5KiB/s] [===================================================================================================] 108%            
INFO: Sending oldest full snapshot send/test/x/l0_0/l1_0/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 61.1 GB) to new target filesystem:
61.1GiB 0:03:32 [ 294MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_0/l1_0/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_0/l1_0/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:00:45:43-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [44.6KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_0/l1_1@autosnap_2024-12-21_01:45:51_monthly (~ 62.2 GB) to new target filesystem:
62.3GiB 0:03:35 [ 295MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_0/l1_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_0/l1_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:00:49:18-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [46.3KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_0/l1_1/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 64.5 GB) to new target filesystem:
64.6GiB 0:03:43 [ 296MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_0/l1_1/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_0/l1_1/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:00:52:57-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [44.3KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_0/l1_1/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 56.6 GB) to new target filesystem:
56.7GiB 0:03:15 [ 297MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_0/l1_1/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_0/l1_1/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:00:56:43-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [41.7KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_0/l1_1/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 51.6 GB) to new target filesystem:
51.6GiB 0:02:59 [ 294MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_0/l1_1/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_0/l1_1/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:01:00:01-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [41.7KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_0/l1_1/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 49.1 GB) to new target filesystem:
49.2GiB 0:02:47 [ 300MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_0/l1_1/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_0/l1_1/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:01:03:03-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [41.9KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_0/l1_2@autosnap_2024-12-21_01:45:51_monthly (~ 59.2 GB) to new target filesystem:
59.2GiB 0:03:29 [ 290MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_0/l1_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_0/l1_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:01:05:54-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [44.7KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_0/l1_2/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 62.3 GB) to new target filesystem:
62.3GiB 0:03:33 [ 298MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_0/l1_2/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_0/l1_2/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:01:09:25-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [43.5KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_0/l1_2/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 65.0 GB) to new target filesystem:
65.0GiB 0:03:43 [ 298MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_0/l1_2/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_0/l1_2/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:01:13:02-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [37.0KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_0/l1_2/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 53.1 GB) to new target filesystem:
53.1GiB 0:03:01 [ 299MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_0/l1_2/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_0/l1_2/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:01:16:48-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [44.7KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_0/l1_2/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 57.0 GB) to new target filesystem:
57.0GiB 0:03:18 [ 294MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_0/l1_2/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_0/l1_2/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:01:19:52-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [44.7KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_0/l1_3@autosnap_2024-12-21_01:45:51_monthly (~ 69.0 GB) to new target filesystem:
69.0GiB 0:03:54 [ 300MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_0/l1_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_0/l1_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:01:23:14-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [49.3KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_0/l1_3/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 62.9 GB) to new target filesystem:
62.9GiB 0:03:34 [ 299MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_0/l1_3/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_0/l1_3/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:01:27:11-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [45.9KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_0/l1_3/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 50.3 GB) to new target filesystem:
50.3GiB 0:02:56 [ 291MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_0/l1_3/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_0/l1_3/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:01:30:49-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [44.9KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_0/l1_3/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 64.4 GB) to new target filesystem:
64.4GiB 0:03:38 [ 301MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_0/l1_3/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_0/l1_3/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:01:33:48-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [42.1KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_0/l1_3/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 60.6 GB) to new target filesystem:
60.6GiB 0:03:30 [ 294MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_0/l1_3/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_0/l1_3/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:01:37:30-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [42.6KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_1@autosnap_2024-12-21_01:45:51_monthly (~ 51.9 GB) to new target filesystem:
51.9GiB 0:02:58 [ 297MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:01:41:03-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [50.9KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_1/l1_0@autosnap_2024-12-21_01:45:51_monthly (~ 54.5 GB) to new target filesystem:
54.5GiB 0:03:07 [ 297MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_1/l1_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_1/l1_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:01:44:04-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [47.9KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_1/l1_0/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 57.2 GB) to new target filesystem:
57.2GiB 0:03:14 [ 300MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_1/l1_0/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_1/l1_0/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:01:47:14-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [44.8KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_1/l1_0/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 66.0 GB) to new target filesystem:
66.0GiB 0:03:42 [ 304MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_1/l1_0/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_1/l1_0/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:01:50:32-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [45.8KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_1/l1_0/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 47.5 GB) to new target filesystem:
47.5GiB 0:02:47 [ 289MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_1/l1_0/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_1/l1_0/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:01:54:17-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [44.6KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_1/l1_0/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 62.8 GB) to new target filesystem:
62.8GiB 0:03:31 [ 304MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_1/l1_0/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_1/l1_0/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:01:57:08-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [45.7KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_1/l1_1@autosnap_2024-12-21_01:45:51_monthly (~ 78.9 GB) to new target filesystem:
79.0GiB 0:04:31 [ 297MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_1/l1_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_1/l1_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:02:00:42-GMT-06:00 (~ 13 KB):
14.3KiB 0:00:00 [47.3KiB/s] [===================================================================================================] 106%            
INFO: Sending oldest full snapshot send/test/x/l0_1/l1_1/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 57.8 GB) to new target filesystem:
57.8GiB 0:03:17 [ 299MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_1/l1_1/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_1/l1_1/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:02:05:16-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [43.9KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_1/l1_1/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 42.5 GB) to new target filesystem:
42.6GiB 0:02:28 [ 293MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_1/l1_1/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_1/l1_1/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:02:08:37-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [43.9KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_1/l1_1/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 49.7 GB) to new target filesystem:
49.7GiB 0:02:52 [ 294MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_1/l1_1/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_1/l1_1/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:02:11:08-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [42.1KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_1/l1_1/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 53.2 GB) to new target filesystem:
53.3GiB 0:03:04 [ 296MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_1/l1_1/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_1/l1_1/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:02:14:04-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [43.5KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_1/l1_2@autosnap_2024-12-21_01:45:51_monthly (~ 48.3 GB) to new target filesystem:
48.4GiB 0:02:46 [ 296MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_1/l1_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_1/l1_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:02:17:11-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [49.1KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_1/l1_2/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 58.6 GB) to new target filesystem:
58.6GiB 0:03:21 [ 298MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_1/l1_2/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_1/l1_2/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:02:20:01-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [46.3KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_1/l1_2/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 58.7 GB) to new target filesystem:
58.7GiB 0:03:16 [ 306MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_1/l1_2/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_1/l1_2/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:02:23:25-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [44.0KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_1/l1_2/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 57.7 GB) to new target filesystem:
57.8GiB 0:03:15 [ 302MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_1/l1_2/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_1/l1_2/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:02:26:44-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [44.3KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_1/l1_2/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 53.6 GB) to new target filesystem:
53.6GiB 0:03:03 [ 299MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_1/l1_2/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_1/l1_2/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:02:30:02-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [41.9KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_1/l1_3@autosnap_2024-12-21_01:45:51_monthly (~ 60.2 GB) to new target filesystem:
60.2GiB 0:03:30 [ 293MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_1/l1_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_1/l1_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:02:33:09-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [49.1KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_1/l1_3/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 62.6 GB) to new target filesystem:
62.6GiB 0:03:33 [ 300MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_1/l1_3/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_1/l1_3/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:02:36:42-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [45.5KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_1/l1_3/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 54.7 GB) to new target filesystem:
54.7GiB 0:03:05 [ 302MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_1/l1_3/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_1/l1_3/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:02:40:18-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [44.5KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_1/l1_3/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 82.7 GB) to new target filesystem:
82.7GiB 0:04:48 [ 293MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_1/l1_3/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_1/l1_3/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:02:43:26-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [42.5KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_1/l1_3/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 71.2 GB) to new target filesystem:
71.3GiB 0:03:59 [ 304MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_1/l1_3/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_1/l1_3/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:02:48:18-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [45.4KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_2@autosnap_2024-12-21_01:45:51_monthly (~ 58.2 GB) to new target filesystem:
58.2GiB 0:03:15 [ 305MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:02:52:20-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [52.9KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_2/l1_0@autosnap_2024-12-21_01:45:51_monthly (~ 48.0 GB) to new target filesystem:
48.1GiB 0:02:39 [ 308MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_2/l1_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_2/l1_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:02:55:38-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [46.9KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_2/l1_0/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 68.0 GB) to new target filesystem:
68.0GiB 0:03:55 [ 296MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_2/l1_0/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_2/l1_0/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:02:58:21-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [44.4KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_2/l1_0/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 53.3 GB) to new target filesystem:
53.3GiB 0:03:05 [ 294MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_2/l1_0/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_2/l1_0/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:03:02:19-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [45.7KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_2/l1_0/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 56.4 GB) to new target filesystem:
56.4GiB 0:03:13 [ 298MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_2/l1_0/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_2/l1_0/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:03:05:27-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [45.0KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_2/l1_0/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 63.3 GB) to new target filesystem:
63.4GiB 0:03:39 [ 294MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_2/l1_0/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_2/l1_0/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:03:08:44-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [43.8KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_2/l1_1@autosnap_2024-12-21_01:45:51_monthly (~ 38.6 GB) to new target filesystem:
38.6GiB 0:02:09 [ 305MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_2/l1_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_2/l1_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:03:12:27-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [47.3KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_2/l1_1/l2_0@autosnap_2024-12-21_01:45:51_monthly (~ 51.7 GB) to new target filesystem:
51.7GiB 0:02:59 [ 295MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_2/l1_1/l2_0': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_2/l1_1/l2_0@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:03:14:39-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [43.9KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_2/l1_1/l2_1@autosnap_2024-12-21_01:45:51_monthly (~ 50.7 GB) to new target filesystem:
50.8GiB 0:02:55 [ 296MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_2/l1_1/l2_1': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_2/l1_1/l2_1@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:03:17:41-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [45.8KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_2/l1_1/l2_2@autosnap_2024-12-21_01:45:51_monthly (~ 68.6 GB) to new target filesystem:
68.6GiB 0:03:51 [ 303MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_2/l1_1/l2_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_2/l1_1/l2_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:03:20:40-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [44.1KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_2/l1_1/l2_3@autosnap_2024-12-21_01:45:51_monthly (~ 40.5 GB) to new target filesystem:
40.5GiB 0:02:03 [ 336MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_2/l1_1/l2_3': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_2/l1_1/l2_3@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:03:24:34-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [44.3KiB/s] [===================================================================================================] 107%            
INFO: Sending oldest full snapshot send/test/x/l0_2/l1_2@autosnap_2024-12-21_01:45:51_monthly (~ 32.3 GB) to new target filesystem:
32.3GiB 0:01:31 [ 360MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/x/l0_2/l1_2': Insufficient privileges
INFO: Updating new target filesystem with incremental send/test/x/l0_2/l1_2@autosnap_2024-12-21_01:45:51_monthly ... syncoid_iox86_2024-12-21:03:26:41-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [49.6KiB/s] [===================================================================================================] 107%            
real 28365.84
user 2312.94
sys 42099.52
hbarta@iox86:~$ time -p /sbin/syncoid --recursive --no-privilege-elevation send/test recv/test
Sending incremental send/test@syncoid_iox86_2024-12-20:19:35:30-GMT-06:00 ... syncoid_iox86_2024-12-21:10:32:23-GMT-06:00 (~ 18 KB):
19.2KiB 0:00:00 [72.0KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_0@syncoid_iox86_2024-12-20:19:35:30-GMT-06:00 ... syncoid_iox86_2024-12-21:10:32:25-GMT-06:00 (~ 18 KB):
19.2KiB 0:00:00 [63.4KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_0/l1_0@syncoid_iox86_2024-12-20:19:39:09-GMT-06:00 ... syncoid_iox86_2024-12-21:10:32:28-GMT-06:00 (~ 18 KB):
19.2KiB 0:00:00 [60.9KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-20:19:42:08-GMT-06:00 ... syncoid_iox86_2024-12-21:10:32:31-GMT-06:00 (~ 18 KB):
19.2KiB 0:00:00 [52.6KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-20:19:46:21-GMT-06:00 ... syncoid_iox86_2024-12-21:10:32:35-GMT-06:00 (~ 16 KB):
17.4KiB 0:00:00 [52.3KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-20:19:50:40-GMT-06:00 ... syncoid_iox86_2024-12-21:10:32:38-GMT-06:00 (~ 16 KB):
17.4KiB 0:00:00 [53.1KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-20:19:54:07-GMT-06:00 ... syncoid_iox86_2024-12-21:10:32:41-GMT-06:00 (~ 16 KB):
17.4KiB 0:00:00 [50.2KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_0/l1_1@syncoid_iox86_2024-12-20:19:56:44-GMT-06:00 ... syncoid_iox86_2024-12-21:10:32:44-GMT-06:00 (~ 16 KB):
17.4KiB 0:00:00 [60.2KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-20:20:00:51-GMT-06:00 ... syncoid_iox86_2024-12-21:10:32:47-GMT-06:00 (~ 15 KB):
16.8KiB 0:00:00 [52.8KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-20:20:04:46-GMT-06:00 ... syncoid_iox86_2024-12-21:10:32:51-GMT-06:00 (~ 15 KB):
16.8KiB 0:00:00 [52.3KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-20:20:08:49-GMT-06:00 ... syncoid_iox86_2024-12-21:10:32:54-GMT-06:00 (~ 15 KB):
16.8KiB 0:00:00 [50.3KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-20:20:12:58-GMT-06:00 ... syncoid_iox86_2024-12-21:10:32:57-GMT-06:00 (~ 15 KB):
16.8KiB 0:00:00 [51.5KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_0/l1_2@syncoid_iox86_2024-12-20:20:16:24-GMT-06:00 ... syncoid_iox86_2024-12-21:10:33:00-GMT-06:00 (~ 15 KB):
16.8KiB 0:00:00 [57.9KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-20:20:19:38-GMT-06:00 ... syncoid_iox86_2024-12-21:10:33:03-GMT-06:00 (~ 15 KB):
16.8KiB 0:00:00 [49.6KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-20:20:22:53-GMT-06:00 ... syncoid_iox86_2024-12-21:10:33:06-GMT-06:00 (~ 15 KB):
16.8KiB 0:00:00 [51.6KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-20:20:26:03-GMT-06:00 ... syncoid_iox86_2024-12-21:10:33:10-GMT-06:00 (~ 15 KB):
16.8KiB 0:00:00 [53.2KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-20:20:29:40-GMT-06:00 ... syncoid_iox86_2024-12-21:10:33:13-GMT-06:00 (~ 15 KB):
16.8KiB 0:00:00 [50.3KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_0/l1_3@syncoid_iox86_2024-12-20:20:33:32-GMT-06:00 ... syncoid_iox86_2024-12-21:10:33:16-GMT-06:00 (~ 15 KB):
16.8KiB 0:00:00 [58.8KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-20:20:36:25-GMT-06:00 ... syncoid_iox86_2024-12-21:10:33:19-GMT-06:00 (~ 15 KB):
16.8KiB 0:00:00 [51.9KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-20:20:39:13-GMT-06:00 ... syncoid_iox86_2024-12-21:10:33:22-GMT-06:00 (~ 15 KB):
16.8KiB 0:00:00 [50.4KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-20:20:43:28-GMT-06:00 ... syncoid_iox86_2024-12-21:10:33:26-GMT-06:00 (~ 15 KB):
16.8KiB 0:00:00 [51.6KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-20:20:47:06-GMT-06:00 ... syncoid_iox86_2024-12-21:10:33:29-GMT-06:00 (~ 15 KB):
16.8KiB 0:00:00 [50.2KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_1@syncoid_iox86_2024-12-20:20:50:48-GMT-06:00 ... syncoid_iox86_2024-12-21:10:33:32-GMT-06:00 (~ 15 KB):
16.8KiB 0:00:00 [62.9KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_1/l1_0@syncoid_iox86_2024-12-20:20:54:19-GMT-06:00 ... syncoid_iox86_2024-12-21:10:33:35-GMT-06:00 (~ 15 KB):
16.8KiB 0:00:00 [54.9KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-20:20:57:57-GMT-06:00 ... syncoid_iox86_2024-12-21:10:33:38-GMT-06:00 (~ 15 KB):
16.8KiB 0:00:00 [49.0KiB/s] [===================================================================================================] 105%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-20:21:02:35-GMT-06:00 ... syncoid_iox86_2024-12-21:10:33:41-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [50.4KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-20:21:05:18-GMT-06:00 ... syncoid_iox86_2024-12-21:10:33:44-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [49.6KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-20:21:08:26-GMT-06:00 ... syncoid_iox86_2024-12-21:10:33:47-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [50.6KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_1/l1_1@syncoid_iox86_2024-12-20:21:11:36-GMT-06:00 ... syncoid_iox86_2024-12-21:10:33:50-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [53.3KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-20:21:15:08-GMT-06:00 ... syncoid_iox86_2024-12-21:10:33:53-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [51.3KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-20:21:18:50-GMT-06:00 ... syncoid_iox86_2024-12-21:10:33:56-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [48.9KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-20:21:21:12-GMT-06:00 ... syncoid_iox86_2024-12-21:10:34:00-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [51.9KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-20:21:24:39-GMT-06:00 ... syncoid_iox86_2024-12-21:10:34:03-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [50.7KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_1/l1_2@syncoid_iox86_2024-12-20:21:27:34-GMT-06:00 ... syncoid_iox86_2024-12-21:10:34:06-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [54.9KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-20:21:30:55-GMT-06:00 ... syncoid_iox86_2024-12-21:10:34:09-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [49.2KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-20:21:34:16-GMT-06:00 ... syncoid_iox86_2024-12-21:10:34:12-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [49.0KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-20:21:38:24-GMT-06:00 ... syncoid_iox86_2024-12-21:10:34:16-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [46.5KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-20:21:42:17-GMT-06:00 ... syncoid_iox86_2024-12-21:10:34:19-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [49.8KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_1/l1_3@syncoid_iox86_2024-12-20:21:45:19-GMT-06:00 ... syncoid_iox86_2024-12-21:10:34:22-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [55.1KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-20:21:48:33-GMT-06:00 ... syncoid_iox86_2024-12-21:10:34:25-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [50.5KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-20:21:52:36-GMT-06:00 ... syncoid_iox86_2024-12-21:10:34:28-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [49.1KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-20:21:56:26-GMT-06:00 ... syncoid_iox86_2024-12-21:10:34:31-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [49.4KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-20:22:00:27-GMT-06:00 ... syncoid_iox86_2024-12-21:10:34:34-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [50.1KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_2@syncoid_iox86_2024-12-20:22:04:44-GMT-06:00 ... syncoid_iox86_2024-12-21:10:34:37-GMT-06:00 (~ 14 KB):
15.5KiB 0:00:00 [58.7KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_2/l1_0@syncoid_iox86_2024-12-20:22:08:03-GMT-06:00 ... syncoid_iox86_2024-12-21:10:34:40-GMT-06:00 (~ 14 KB):
15.5KiB 0:00:00 [54.0KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-20:22:11:38-GMT-06:00 ... syncoid_iox86_2024-12-21:10:34:43-GMT-06:00 (~ 14 KB):
15.5KiB 0:00:00 [49.4KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-20:22:15:04-GMT-06:00 ... syncoid_iox86_2024-12-21:10:34:46-GMT-06:00 (~ 14 KB):
15.5KiB 0:00:00 [49.2KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-20:22:18:17-GMT-06:00 ... syncoid_iox86_2024-12-21:10:34:49-GMT-06:00 (~ 14 KB):
15.5KiB 0:00:00 [48.5KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-20:22:21:50-GMT-06:00 ... syncoid_iox86_2024-12-21:10:34:52-GMT-06:00 (~ 14 KB):
15.5KiB 0:00:00 [52.1KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_2/l1_1@syncoid_iox86_2024-12-20:22:25:31-GMT-06:00 ... syncoid_iox86_2024-12-21:10:34:55-GMT-06:00 (~ 14 KB):
15.5KiB 0:00:00 [49.5KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-20:22:28:36-GMT-06:00 ... syncoid_iox86_2024-12-21:10:34:58-GMT-06:00 (~ 14 KB):
15.5KiB 0:00:00 [51.9KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-20:22:32:32-GMT-06:00 ... syncoid_iox86_2024-12-21:10:35:01-GMT-06:00 (~ 14 KB):
15.5KiB 0:00:00 [49.2KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-20:22:36:04-GMT-06:00 ... syncoid_iox86_2024-12-21:10:35:04-GMT-06:00 (~ 14 KB):
15.5KiB 0:00:00 [47.2KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-20:22:39:51-GMT-06:00 ... syncoid_iox86_2024-12-21:10:35:08-GMT-06:00 (~ 14 KB):
15.5KiB 0:00:00 [50.2KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_2/l1_2@syncoid_iox86_2024-12-20:22:43:54-GMT-06:00 ... syncoid_iox86_2024-12-21:10:35:11-GMT-06:00 (~ 14 KB):
15.5KiB 0:00:00 [53.4KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_2/l1_2/l2_0@syncoid_iox86_2024-12-20:22:47:40-GMT-06:00 ... syncoid_iox86_2024-12-21:10:35:13-GMT-06:00 (~ 14 KB):
15.5KiB 0:00:00 [50.7KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_2/l1_2/l2_1@syncoid_iox86_2024-12-20:22:51:04-GMT-06:00 ... syncoid_iox86_2024-12-21:10:35:17-GMT-06:00 (~ 14 KB):
15.5KiB 0:00:00 [49.9KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_2/l1_2/l2_2@syncoid_iox86_2024-12-20:22:53:59-GMT-06:00 ... syncoid_iox86_2024-12-21:10:35:20-GMT-06:00 (~ 14 KB):
15.5KiB 0:00:00 [50.1KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_2/l1_2/l2_3@syncoid_iox86_2024-12-20:22:56:37-GMT-06:00 ... syncoid_iox86_2024-12-21:10:35:23-GMT-06:00 (~ 14 KB):
15.5KiB 0:00:00 [48.6KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_2/l1_3@syncoid_iox86_2024-12-20:22:59:32-GMT-06:00 ... syncoid_iox86_2024-12-21:10:35:26-GMT-06:00 (~ 14 KB):
15.5KiB 0:00:00 [57.0KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_2/l1_3/l2_0@syncoid_iox86_2024-12-20:23:02:36-GMT-06:00 ... syncoid_iox86_2024-12-21:10:35:29-GMT-06:00 (~ 14 KB):
14.9KiB 0:00:00 [47.6KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-20:23:06:06-GMT-06:00 ... syncoid_iox86_2024-12-21:10:35:32-GMT-06:00 (~ 14 KB):
14.9KiB 0:00:00 [47.2KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_2/l1_3/l2_2@syncoid_iox86_2024-12-20:23:09:37-GMT-06:00 ... syncoid_iox86_2024-12-21:10:35:35-GMT-06:00 (~ 14 KB):
14.9KiB 0:00:00 [49.6KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-20:23:12:40-GMT-06:00 ... syncoid_iox86_2024-12-21:10:35:38-GMT-06:00 (~ 14 KB):
14.9KiB 0:00:00 [48.6KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_3@syncoid_iox86_2024-12-20:23:16:20-GMT-06:00 ... syncoid_iox86_2024-12-21:10:35:41-GMT-06:00 (~ 14 KB):
14.9KiB 0:00:00 [62.2KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_3/l1_0@syncoid_iox86_2024-12-20:23:19:41-GMT-06:00 ... syncoid_iox86_2024-12-21:10:35:43-GMT-06:00 (~ 14 KB):
14.9KiB 0:00:00 [50.7KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_3/l1_0/l2_0@syncoid_iox86_2024-12-20:23:23:07-GMT-06:00 ... syncoid_iox86_2024-12-21:10:35:46-GMT-06:00 (~ 14 KB):
14.9KiB 0:00:00 [46.7KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_3/l1_0/l2_1@syncoid_iox86_2024-12-20:23:26:25-GMT-06:00 ... syncoid_iox86_2024-12-21:10:35:49-GMT-06:00 (~ 14 KB):
14.9KiB 0:00:00 [46.9KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_3/l1_0/l2_2@syncoid_iox86_2024-12-20:23:29:36-GMT-06:00 ... syncoid_iox86_2024-12-21:10:35:52-GMT-06:00 (~ 14 KB):
14.9KiB 0:00:00 [48.0KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_3/l1_0/l2_3@syncoid_iox86_2024-12-20:23:33:19-GMT-06:00 ... syncoid_iox86_2024-12-21:10:35:55-GMT-06:00 (~ 14 KB):
14.9KiB 0:00:00 [49.8KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_3/l1_1@syncoid_iox86_2024-12-20:23:37:10-GMT-06:00 ... syncoid_iox86_2024-12-21:10:35:58-GMT-06:00 (~ 14 KB):
14.9KiB 0:00:00 [53.6KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_3/l1_1/l2_0@syncoid_iox86_2024-12-20:23:40:48-GMT-06:00 ... syncoid_iox86_2024-12-21:10:36:01-GMT-06:00 (~ 14 KB):
14.9KiB 0:00:00 [47.8KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_3/l1_1/l2_1@syncoid_iox86_2024-12-20:23:43:55-GMT-06:00 ... syncoid_iox86_2024-12-21:10:36:04-GMT-06:00 (~ 14 KB):
14.9KiB 0:00:00 [51.7KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_3/l1_1/l2_2@syncoid_iox86_2024-12-20:23:47:27-GMT-06:00 ... syncoid_iox86_2024-12-21:10:36:07-GMT-06:00 (~ 14 KB):
14.9KiB 0:00:00 [47.3KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_3/l1_1/l2_3@syncoid_iox86_2024-12-20:23:51:08-GMT-06:00 ... syncoid_iox86_2024-12-21:10:36:10-GMT-06:00 (~ 14 KB):
14.9KiB 0:00:00 [49.2KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_3/l1_2@syncoid_iox86_2024-12-20:23:54:37-GMT-06:00 ... syncoid_iox86_2024-12-21:10:36:13-GMT-06:00 (~ 14 KB):
14.9KiB 0:00:00 [54.0KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_3/l1_2/l2_0@syncoid_iox86_2024-12-20:23:58:13-GMT-06:00 ... syncoid_iox86_2024-12-21:10:36:16-GMT-06:00 (~ 14 KB):
14.9KiB 0:00:00 [50.4KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_3/l1_2/l2_1@syncoid_iox86_2024-12-21:00:01:10-GMT-06:00 ... syncoid_iox86_2024-12-21:10:36:19-GMT-06:00 (~ 13 KB):
14.3KiB 0:00:00 [49.6KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_3/l1_2/l2_2@syncoid_iox86_2024-12-21:00:05:20-GMT-06:00 ... syncoid_iox86_2024-12-21:10:36:22-GMT-06:00 (~ 13 KB):
14.3KiB 0:00:00 [47.2KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_3/l1_2/l2_3@syncoid_iox86_2024-12-21:00:08:11-GMT-06:00 ... syncoid_iox86_2024-12-21:10:36:25-GMT-06:00 (~ 13 KB):
14.3KiB 0:00:00 [48.6KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_3/l1_3@syncoid_iox86_2024-12-21:00:12:18-GMT-06:00 ... syncoid_iox86_2024-12-21:10:36:28-GMT-06:00 (~ 13 KB):
14.3KiB 0:00:00 [55.3KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_3/l1_3/l2_0@syncoid_iox86_2024-12-21:00:15:37-GMT-06:00 ... syncoid_iox86_2024-12-21:10:36:30-GMT-06:00 (~ 13 KB):
14.3KiB 0:00:00 [49.2KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_3/l1_3/l2_1@syncoid_iox86_2024-12-21:00:19:55-GMT-06:00 ... syncoid_iox86_2024-12-21:10:36:33-GMT-06:00 (~ 13 KB):
14.3KiB 0:00:00 [49.1KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_3/l1_3/l2_2@syncoid_iox86_2024-12-21:00:23:08-GMT-06:00 ... syncoid_iox86_2024-12-21:10:36:36-GMT-06:00 (~ 13 KB):
14.3KiB 0:00:00 [47.7KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-21:00:26:35-GMT-06:00 ... syncoid_iox86_2024-12-21:10:36:39-GMT-06:00 (~ 13 KB):
14.3KiB 0:00:00 [49.4KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/x@syncoid_iox86_2024-12-21:00:30:12-GMT-06:00 ... syncoid_iox86_2024-12-21:10:36:42-GMT-06:00 (~ 13 KB):
14.3KiB 0:00:00 [58.1KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/x/l0_0@syncoid_iox86_2024-12-21:00:30:14-GMT-06:00 ... syncoid_iox86_2024-12-21:10:36:45-GMT-06:00 (~ 13 KB):
14.3KiB 0:00:00 [50.7KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/x/l0_0/l1_0@syncoid_iox86_2024-12-21:00:33:46-GMT-06:00 ... syncoid_iox86_2024-12-21:10:36:47-GMT-06:00 (~ 13 KB):
14.3KiB 0:00:00 [48.4KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/x/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-21:00:37:10-GMT-06:00 ... syncoid_iox86_2024-12-21:10:36:50-GMT-06:00 (~ 13 KB):
14.3KiB 0:00:00 [44.2KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/x/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-21:00:40:03-GMT-06:00 ... syncoid_iox86_2024-12-21:10:36:54-GMT-06:00 (~ 13 KB):
14.3KiB 0:00:00 [46.6KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/x/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-21:00:42:45-GMT-06:00 ... syncoid_iox86_2024-12-21:10:36:57-GMT-06:00 (~ 13 KB):
14.3KiB 0:00:00 [45.4KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/x/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-21:00:45:43-GMT-06:00 ... syncoid_iox86_2024-12-21:10:37:00-GMT-06:00 (~ 13 KB):
14.3KiB 0:00:00 [46.2KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/x/l0_0/l1_1@syncoid_iox86_2024-12-21:00:49:18-GMT-06:00 ... syncoid_iox86_2024-12-21:10:37:03-GMT-06:00 (~ 13 KB):
14.3KiB 0:00:00 [49.7KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/x/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-21:00:52:57-GMT-06:00 ... syncoid_iox86_2024-12-21:10:37:06-GMT-06:00 (~ 13 KB):
14.3KiB 0:00:00 [44.8KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/x/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-21:00:56:43-GMT-06:00 ... syncoid_iox86_2024-12-21:10:37:10-GMT-06:00 (~ 13 KB):
14.3KiB 0:00:00 [46.4KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/x/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-21:01:00:01-GMT-06:00 ... syncoid_iox86_2024-12-21:10:37:13-GMT-06:00 (~ 13 KB):
14.3KiB 0:00:00 [43.8KiB/s] [===================================================================================================] 106%            
Sending incremental send/test/x/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-21:01:03:03-GMT-06:00 ... syncoid_iox86_2024-12-21:10:37:16-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [46.5KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_0/l1_2@syncoid_iox86_2024-12-21:01:05:54-GMT-06:00 ... syncoid_iox86_2024-12-21:10:37:19-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [48.0KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-21:01:09:25-GMT-06:00 ... syncoid_iox86_2024-12-21:10:37:22-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [42.8KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-21:01:13:02-GMT-06:00 ... syncoid_iox86_2024-12-21:10:37:25-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [48.4KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-21:01:16:48-GMT-06:00 ... syncoid_iox86_2024-12-21:10:37:29-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [47.5KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-21:01:19:52-GMT-06:00 ... syncoid_iox86_2024-12-21:10:37:32-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [42.4KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_0/l1_3@syncoid_iox86_2024-12-21:01:23:14-GMT-06:00 ... syncoid_iox86_2024-12-21:10:37:35-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [45.1KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-21:01:27:11-GMT-06:00 ... syncoid_iox86_2024-12-21:10:37:39-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [43.8KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-21:01:30:49-GMT-06:00 ... syncoid_iox86_2024-12-21:10:37:42-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [45.1KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-21:01:33:48-GMT-06:00 ... syncoid_iox86_2024-12-21:10:37:46-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [43.7KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-21:01:37:30-GMT-06:00 ... syncoid_iox86_2024-12-21:10:37:49-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [44.0KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_1@syncoid_iox86_2024-12-21:01:41:03-GMT-06:00 ... syncoid_iox86_2024-12-21:10:37:53-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [50.2KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_1/l1_0@syncoid_iox86_2024-12-21:01:44:04-GMT-06:00 ... syncoid_iox86_2024-12-21:10:37:56-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [46.8KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-21:01:47:14-GMT-06:00 ... syncoid_iox86_2024-12-21:10:37:59-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [43.8KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-21:01:50:32-GMT-06:00 ... syncoid_iox86_2024-12-21:10:38:02-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [42.5KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-21:01:54:17-GMT-06:00 ... syncoid_iox86_2024-12-21:10:38:06-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [44.1KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-21:01:57:08-GMT-06:00 ... syncoid_iox86_2024-12-21:10:38:09-GMT-06:00 (~ 12 KB):
13.7KiB 0:00:00 [43.4KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_1/l1_1@syncoid_iox86_2024-12-21:02:00:42-GMT-06:00 ... syncoid_iox86_2024-12-21:10:38:13-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [48.6KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-21:02:05:16-GMT-06:00 ... syncoid_iox86_2024-12-21:10:38:16-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [44.1KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-21:02:08:37-GMT-06:00 ... syncoid_iox86_2024-12-21:10:38:19-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [42.2KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-21:02:11:08-GMT-06:00 ... syncoid_iox86_2024-12-21:10:38:23-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [43.0KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-21:02:14:04-GMT-06:00 ... syncoid_iox86_2024-12-21:10:38:26-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [43.7KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_1/l1_2@syncoid_iox86_2024-12-21:02:17:11-GMT-06:00 ... syncoid_iox86_2024-12-21:10:38:30-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [47.1KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-21:02:20:01-GMT-06:00 ... syncoid_iox86_2024-12-21:10:38:33-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [43.6KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-21:02:23:25-GMT-06:00 ... syncoid_iox86_2024-12-21:10:38:36-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [40.2KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-21:02:26:44-GMT-06:00 ... syncoid_iox86_2024-12-21:10:38:40-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [41.5KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-21:02:30:02-GMT-06:00 ... syncoid_iox86_2024-12-21:10:38:43-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [42.0KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_1/l1_3@syncoid_iox86_2024-12-21:02:33:09-GMT-06:00 ... syncoid_iox86_2024-12-21:10:38:47-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [46.2KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-21:02:36:42-GMT-06:00 ... syncoid_iox86_2024-12-21:10:38:50-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [41.9KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-21:02:40:18-GMT-06:00 ... syncoid_iox86_2024-12-21:10:38:53-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [43.8KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-21:02:43:26-GMT-06:00 ... syncoid_iox86_2024-12-21:10:38:57-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [43.9KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-21:02:48:18-GMT-06:00 ... syncoid_iox86_2024-12-21:10:39:00-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [44.2KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_2@syncoid_iox86_2024-12-21:02:52:20-GMT-06:00 ... syncoid_iox86_2024-12-21:10:39:04-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [47.3KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_2/l1_0@syncoid_iox86_2024-12-21:02:55:38-GMT-06:00 ... syncoid_iox86_2024-12-21:10:39:06-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [46.7KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-21:02:58:21-GMT-06:00 ... syncoid_iox86_2024-12-21:10:39:10-GMT-06:00 (~ 12 KB):
13.1KiB 0:00:00 [43.3KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-21:03:02:19-GMT-06:00 ... syncoid_iox86_2024-12-21:10:39:13-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [41.5KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-21:03:05:27-GMT-06:00 ... syncoid_iox86_2024-12-21:10:39:16-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [41.7KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-21:03:08:44-GMT-06:00 ... syncoid_iox86_2024-12-21:10:39:20-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [42.7KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_2/l1_1@syncoid_iox86_2024-12-21:03:12:27-GMT-06:00 ... syncoid_iox86_2024-12-21:10:39:23-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [45.7KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-21:03:14:39-GMT-06:00 ... syncoid_iox86_2024-12-21:10:39:26-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [40.7KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-21:03:17:41-GMT-06:00 ... syncoid_iox86_2024-12-21:10:39:29-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [42.6KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-21:03:20:40-GMT-06:00 ... syncoid_iox86_2024-12-21:10:39:33-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [42.8KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-21:03:24:34-GMT-06:00 ... syncoid_iox86_2024-12-21:10:39:36-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [42.8KiB/s] [===================================================================================================] 107%            
Sending incremental send/test/x/l0_2/l1_2@syncoid_iox86_2024-12-21:03:26:41-GMT-06:00 ... syncoid_iox86_2024-12-21:10:39:39-GMT-06:00 (~ 11 KB):
12.5KiB 0:00:00 [48.4KiB/s] [===================================================================================================] 107%            
real 440.01
user 25.94
sys 207.35
hbarta@iox86:~$ zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   440G   260G   180G        -         -     5%    59%  1.00x    ONLINE  -
send   448G   266G   182G        -         -     4%    59%  1.00x    ONLINE  -
hbarta@iox86:~$ zpool status
  pool: recv
 state: ONLINE
config:

        NAME                            STATE     READ WRITE CKSUM
        recv                            ONLINE       0     0     0
          wwn-0x5002538d40dca5d9-part8  ONLINE       0     0     0

errors: No known data errors

  pool: send
 state: ONLINE
config:

        NAME                            STATE     READ WRITE CKSUM
        send                            ONLINE       0     0     0
          wwn-0x5002538d40dca5d9-part7  ONLINE       0     0     0

errors: No known data errors
hbarta@iox86:~$ 
```

First two send/recv look clean. Starting loops.

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
    time -p /sbin/syncoid --recursive --no-privilege-elevation send/test recv/test
    zpool status send
    echo
    sleep 750
done
```

## 2024-12-22 (early AM)

The following console capture (along with 20 that were removed as uninteresting but [saved](./X86_trial_2-elided.md) in case I had missed something) show the progression of errors reported by `syncoid` as well as errors reported by `zpool status`. At the end of this "test run" the scripts that were stirring the pool and sending the pool using `syncoid` were stopped and the entry in `/etc/sanoid/sanoid.conf` that specified snapshots for `send` was commented out. `recv` did not have any snapshot management specified. The first `syncoid` run appears clean and is included for completeness. The second reports the following error

```text
warning: cannot send 'send/test/l0_2/l1_3/l2_2@syncoid_iox86_2024-12-22:00:27:22-GMT-06:00': Input/output error
 797KiB 0:00:00 [4.84MiB/s] [============================================>                                                       ] 45%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-10a0ab0a75-118-789c636064000310a501c49c50360710a715e5e7a69766a630408108d3b7afbf0eeb3c5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f910574cdca1b55bfe11934202923c27583e2f31379581a138352f451f6854897e8e41bc917e8e61bcb17e8e51bc914371655e727e664a7c667e858559bc91819189aea191ae91919581819591b9959191aebb6f88ae8119900f7303005e912c8d
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_2'@'syncoid_iox86_2024-12-22:00:10:36-GMT-06:00' 'send/test/l0_2/l1_3/l2_2'@'syncoid_iox86_2024-12-22:00:27:22-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1809976 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
```

There is no report of any error in `dmesg` output and nothing obvious found examining `journalctl -xb`. Following this `syncoid` run `zpool status` reported one error. Subsequent runs reported more errors (both `syncoid` and `zpool`) and at the point it was stopped, `zpool status` listed 81 errors but `zpool status -v` listed no files.

```text
hbarta@iox86:~$ zpool status send
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

errors: 81 data errors, use '-v' for a list
hbarta@iox86:~$ sudo zpool status -v send
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

errors: Permanent errors have been detected in the following files:

hbarta@iox86:~$ 
```

```text
Sending incremental send/test@syncoid_iox86_2024-12-21:23:52:09-GMT-06:00 ... syncoid_iox86_2024-12-22:00:08:46-GMT-06:00 (~ 4 KB):
2.74KiB 0:00:00 [31.0KiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_0@syncoid_iox86_2024-12-21:23:52:10-GMT-06:00 ... syncoid_iox86_2024-12-22:00:08:47-GMT-06:00 (~ 514 KB):
 407KiB 0:00:00 [2.82MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_0/l1_0@syncoid_iox86_2024-12-21:23:52:11-GMT-06:00 ... syncoid_iox86_2024-12-22:00:08:49-GMT-06:00 (~ 766 KB):
 536KiB 0:00:00 [3.79MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-21:23:52:13-GMT-06:00 ... syncoid_iox86_2024-12-22:00:08:51-GMT-06:00 (~ 766 KB):
 533KiB 0:00:00 [3.31MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-21:23:52:15-GMT-06:00 ... syncoid_iox86_2024-12-22:00:08:53-GMT-06:00 (~ 899 KB):
 666KiB 0:00:00 [4.22MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-21:23:52:16-GMT-06:00 ... syncoid_iox86_2024-12-22:00:08:54-GMT-06:00 (~ 574 KB):
 409KiB 0:00:00 [2.70MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-21:23:52:18-GMT-06:00 ... syncoid_iox86_2024-12-22:00:08:56-GMT-06:00 (~ 1.1 MB):
 797KiB 0:00:00 [4.88MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_0/l1_1@syncoid_iox86_2024-12-21:23:52:20-GMT-06:00 ... syncoid_iox86_2024-12-22:00:08:58-GMT-06:00 (~ 810 KB):
 674KiB 0:00:00 [4.28MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-21:23:52:21-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:00-GMT-06:00 (~ 706 KB):
 532KiB 0:00:00 [3.44MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-21:23:52:23-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:01-GMT-06:00 (~ 706 KB):
 535KiB 0:00:00 [3.48MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-21:23:52:25-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:03-GMT-06:00 (~ 558 KB):
 395KiB 0:00:00 [2.50MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-21:23:52:26-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:05-GMT-06:00 (~ 646 KB):
 534KiB 0:00:00 [3.48MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_0/l1_2@syncoid_iox86_2024-12-21:23:52:28-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:07-GMT-06:00 (~ 959 KB):
 665KiB 0:00:00 [4.60MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-21:23:52:30-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:08-GMT-06:00 (~ 530 KB):
 414KiB 0:00:00 [2.54MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-21:23:52:31-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:10-GMT-06:00 (~ 662 KB):
 544KiB 0:00:00 [3.46MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-21:23:52:33-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:12-GMT-06:00 (~ 646 KB):
 532KiB 0:00:00 [3.42MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-21:23:52:35-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:14-GMT-06:00 (~ 650 KB):
 411KiB 0:00:00 [2.79MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_0/l1_3@syncoid_iox86_2024-12-21:23:52:36-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:15-GMT-06:00 (~ 642 KB):
 484KiB 0:00:00 [3.33MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-21:23:52:38-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:17-GMT-06:00 (~ 722 KB):
 544KiB 0:00:00 [3.51MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-21:23:52:40-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:19-GMT-06:00 (~ 706 KB):
 534KiB 0:00:00 [3.30MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-21:23:52:41-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:21-GMT-06:00 (~ 574 KB):
 404KiB 0:00:00 [2.68MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-21:23:52:43-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:22-GMT-06:00 (~ 634 KB):
 410KiB 0:00:00 [2.81MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_1@syncoid_iox86_2024-12-21:23:52:44-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:24-GMT-06:00 (~ 306 KB):
 272KiB 0:00:00 [2.03MiB/s] [========================================================================================>           ] 89%            
Sending incremental send/test/l0_1/l1_0@syncoid_iox86_2024-12-21:23:52:46-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:26-GMT-06:00 (~ 574 KB):
 408KiB 0:00:00 [2.85MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-21:23:52:48-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:27-GMT-06:00 (~ 514 KB):
 407KiB 0:00:00 [2.67MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-21:23:52:49-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:29-GMT-06:00 (~ 794 KB):
 670KiB 0:00:00 [3.89MiB/s] [===================================================================================>                ] 84%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-21:23:52:51-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:31-GMT-06:00 (~ 590 KB):
 415KiB 0:00:00 [2.71MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-21:23:52:53-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:33-GMT-06:00 (~ 662 KB):
 547KiB 0:00:00 [3.44MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_1/l1_1@syncoid_iox86_2024-12-21:23:52:54-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:34-GMT-06:00 (~ 706 KB):
 539KiB 0:00:00 [3.67MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-21:23:52:56-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:36-GMT-06:00 (~ 498 KB):
 384KiB 0:00:00 [2.49MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-21:23:52:58-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:38-GMT-06:00 (~ 722 KB):
 542KiB 0:00:00 [3.46MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-21:23:52:59-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:40-GMT-06:00 (~ 722 KB):
 540KiB 0:00:00 [3.37MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-21:23:53:01-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:42-GMT-06:00 (~ 634 KB):
 410KiB 0:00:00 [2.78MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_1/l1_2@syncoid_iox86_2024-12-21:23:53:03-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:43-GMT-06:00 (~ 382 KB):
 281KiB 0:00:00 [2.04MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-21:23:53:04-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:45-GMT-06:00 (~ 722 KB):
 546KiB 0:00:00 [3.47MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-21:23:53:06-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:47-GMT-06:00 (~ 854 KB):
 668KiB 0:00:00 [4.11MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-21:23:53:08-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:49-GMT-06:00 (~ 915 KB):
 672KiB 0:00:00 [4.39MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-21:23:53:10-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:51-GMT-06:00 (~ 706 KB):
 536KiB 0:00:00 [3.41MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_1/l1_3@syncoid_iox86_2024-12-21:23:53:11-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:52-GMT-06:00 (~ 574 KB):
 406KiB 0:00:00 [2.89MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-21:23:53:13-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:54-GMT-06:00 (~ 1.1 MB):
 810KiB 0:00:00 [5.11MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-21:23:53:15-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:56-GMT-06:00 (~ 870 KB):
 676KiB 0:00:00 [4.16MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-21:23:53:16-GMT-06:00 ... syncoid_iox86_2024-12-22:00:09:58-GMT-06:00 (~ 762 KB):
 644KiB 0:00:00 [3.96MiB/s] [===================================================================================>                ] 84%            
Sending incremental send/test/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-21:23:53:18-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:00-GMT-06:00 (~ 662 KB):
 540KiB 0:00:00 [3.42MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_2@syncoid_iox86_2024-12-21:23:53:19-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:01-GMT-06:00 (~ 870 KB):
 677KiB 0:00:00 [4.83MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_2/l1_0@syncoid_iox86_2024-12-21:23:53:21-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:03-GMT-06:00 (~ 722 KB):
 545KiB 0:00:00 [3.72MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-21:23:53:23-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:05-GMT-06:00 (~ 482 KB):
 374KiB 0:00:00 [2.44MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-21:23:53:24-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:06-GMT-06:00 (~ 722 KB):
 538KiB 0:00:00 [3.38MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-21:23:53:26-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:08-GMT-06:00 (~ 975 KB):
 671KiB 0:00:00 [4.12MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-21:23:53:28-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:10-GMT-06:00 (~ 662 KB):
 547KiB 0:00:00 [3.38MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_2/l1_1@syncoid_iox86_2024-12-21:23:53:30-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:12-GMT-06:00 (~ 382 KB):
 281KiB 0:00:00 [1.90MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-21:23:53:31-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:14-GMT-06:00 (~ 530 KB):
 412KiB 0:00:00 [2.46MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-21:23:53:33-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:16-GMT-06:00 (~ 1.1 MB):
 793KiB 0:00:00 [4.96MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-21:23:53:35-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:17-GMT-06:00 (~ 530 KB):
 411KiB 0:00:00 [2.67MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-21:23:53:36-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:19-GMT-06:00 (~ 794 KB):
 670KiB 0:00:00 [3.87MiB/s] [===================================================================================>                ] 84%            
Sending incremental send/test/l0_2/l1_2@syncoid_iox86_2024-12-21:23:53:38-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:21-GMT-06:00 (~ 514 KB):
 410KiB 0:00:00 [2.83MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_2/l1_2/l2_0@syncoid_iox86_2024-12-21:23:53:40-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:23-GMT-06:00 (~ 722 KB):
 538KiB 0:00:00 [3.49MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_2/l1_2/l2_1@syncoid_iox86_2024-12-21:23:53:42-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:25-GMT-06:00 (~ 1.1 MB):
 924KiB 0:00:00 [5.35MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_2/l1_2/l2_2@syncoid_iox86_2024-12-21:23:53:43-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:27-GMT-06:00 (~ 722 KB):
 541KiB 0:00:00 [3.70MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_2/l1_2/l2_3@syncoid_iox86_2024-12-21:23:53:45-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:28-GMT-06:00 (~ 662 KB):
 543KiB 0:00:00 [3.48MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_2/l1_3@syncoid_iox86_2024-12-21:23:53:47-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:30-GMT-06:00 (~ 1.3 MB):
 937KiB 0:00:00 [6.27MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_2/l1_3/l2_0@syncoid_iox86_2024-12-21:23:53:48-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:32-GMT-06:00 (~ 382 KB):
 280KiB 0:00:00 [1.79MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-21:23:53:50-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:34-GMT-06:00 (~ 782 KB):
 539KiB 0:00:00 [3.43MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_2/l1_3/l2_2@syncoid_iox86_2024-12-21:23:53:52-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:36-GMT-06:00 (~ 530 KB):
 413KiB 0:00:00 [2.66MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-21:23:53:54-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:37-GMT-06:00 (~ 574 KB):
 412KiB 0:00:00 [2.68MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_3@syncoid_iox86_2024-12-21:23:53:55-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:39-GMT-06:00 (~ 782 KB):
 546KiB 0:00:00 [4.02MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_3/l1_0@syncoid_iox86_2024-12-21:23:53:57-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:41-GMT-06:00 (~ 174 KB):
 139KiB 0:00:00 [ 983KiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_3/l1_0/l2_0@syncoid_iox86_2024-12-21:23:53:58-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:42-GMT-06:00 (~ 1.0 MB):
 807KiB 0:00:00 [5.08MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_3/l1_0/l2_1@syncoid_iox86_2024-12-21:23:54:00-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:44-GMT-06:00 (~ 574 KB):
 404KiB 0:00:00 [2.63MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_3/l1_0/l2_2@syncoid_iox86_2024-12-21:23:54:02-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:46-GMT-06:00 (~ 706 KB):
 535KiB 0:00:00 [3.40MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_3/l1_0/l2_3@syncoid_iox86_2024-12-21:23:54:04-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:48-GMT-06:00 (~ 674 KB):
 502KiB 0:00:00 [3.01MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_3/l1_1@syncoid_iox86_2024-12-21:23:54:05-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:50-GMT-06:00 (~ 602 KB):
 542KiB 0:00:00 [3.55MiB/s] [=========================================================================================>          ] 90%            
Sending incremental send/test/l0_3/l1_1/l2_0@syncoid_iox86_2024-12-21:23:54:07-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:51-GMT-06:00 (~ 762 KB):
 640KiB 0:00:00 [3.93MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/l0_3/l1_1/l2_1@syncoid_iox86_2024-12-21:23:54:09-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:53-GMT-06:00 (~ 899 KB):
 663KiB 0:00:00 [4.09MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_3/l1_1/l2_2@syncoid_iox86_2024-12-21:23:54:11-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:55-GMT-06:00 (~ 690 KB):
 529KiB 0:00:00 [3.22MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_3/l1_1/l2_3@syncoid_iox86_2024-12-21:23:54:13-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:57-GMT-06:00 (~ 650 KB):
 413KiB 0:00:00 [2.81MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_3/l1_2@syncoid_iox86_2024-12-21:23:54:14-GMT-06:00 ... syncoid_iox86_2024-12-22:00:10:59-GMT-06:00 (~ 426 KB):
 269KiB 0:00:00 [1.95MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_3/l1_2/l2_0@syncoid_iox86_2024-12-21:23:54:16-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:00-GMT-06:00 (~ 782 KB):
 538KiB 0:00:00 [3.45MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_3/l1_2/l2_1@syncoid_iox86_2024-12-21:23:54:18-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:02-GMT-06:00 (~ 738 KB):
 546KiB 0:00:00 [3.46MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_3/l1_2/l2_2@syncoid_iox86_2024-12-21:23:54:19-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:04-GMT-06:00 (~ 722 KB):
 545KiB 0:00:00 [3.52MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_3/l1_2/l2_3@syncoid_iox86_2024-12-21:23:54:21-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:06-GMT-06:00 (~ 574 KB):
 401KiB 0:00:00 [2.62MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_3/l1_3@syncoid_iox86_2024-12-21:23:54:23-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:08-GMT-06:00 (~ 514 KB):
 410KiB 0:00:00 [2.88MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_3/l1_3/l2_0@syncoid_iox86_2024-12-21:23:54:24-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:10-GMT-06:00 (~ 382 KB):
 283KiB 0:00:00 [1.89MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_3/l1_3/l2_1@syncoid_iox86_2024-12-21:23:54:26-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:11-GMT-06:00 (~ 854 KB):
 668KiB 0:00:00 [4.13MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_3/l1_3/l2_2@syncoid_iox86_2024-12-21:23:54:28-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:13-GMT-06:00 (~ 1.3 MB):
 934KiB 0:00:00 [6.05MiB/s] [==================================================================>                                 ] 67%            
Sending incremental send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-21:23:54:30-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:15-GMT-06:00 (~ 322 KB):
 276KiB 0:00:00 [1.78MiB/s] [====================================================================================>               ] 85%            
Sending incremental send/test/x@syncoid_iox86_2024-12-21:23:54:31-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:17-GMT-06:00 (~ 4 KB):
2.74KiB 0:00:00 [28.8KiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/x/l0_0@syncoid_iox86_2024-12-21:23:54:33-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:18-GMT-06:00 (~ 794 KB):
 670KiB 0:00:00 [4.28MiB/s] [===================================================================================>                ] 84%            
Sending incremental send/test/x/l0_0/l1_0@syncoid_iox86_2024-12-21:23:54:35-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:20-GMT-06:00 (~ 662 KB):
 544KiB 0:00:00 [3.39MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/x/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-21:23:54:37-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:22-GMT-06:00 (~ 574 KB):
 410KiB 0:00:00 [2.55MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/x/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-21:23:54:39-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:24-GMT-06:00 (~ 442 KB):
 275KiB 0:00:00 [1.64MiB/s] [=============================================================>                                      ] 62%            
Sending incremental send/test/x/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-21:23:54:40-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:26-GMT-06:00 (~ 646 KB):
 533KiB 0:00:00 [3.02MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/x/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-21:23:54:42-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:28-GMT-06:00 (~ 1.4 MB):
1.04MiB 0:00:00 [5.98MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/x/l0_0/l1_1@syncoid_iox86_2024-12-21:23:54:44-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:30-GMT-06:00 (~ 426 KB):
 272KiB 0:00:00 [1.90MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/x/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-21:23:54:46-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:32-GMT-06:00 (~ 858 KB):
 549KiB 0:00:00 [3.24MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/x/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-21:23:54:48-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:34-GMT-06:00 (~ 438 KB):
 401KiB 0:00:00 [1.51MiB/s] [==========================================================================================>         ] 91%            
Sending incremental send/test/x/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-21:23:54:50-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:36-GMT-06:00 (~ 1.2 MB):
 944KiB 0:00:00 [1.71MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/x/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-21:23:54:52-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:39-GMT-06:00 (~ 1.6 MB):
1.27MiB 0:00:00 [2.60MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/x/l0_0/l1_2@syncoid_iox86_2024-12-21:23:54:54-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:41-GMT-06:00 (~ 1.2 MB):
 935KiB 0:00:00 [2.58MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/x/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-21:23:54:56-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:43-GMT-06:00 (~ 1.4 MB):
1.05MiB 0:00:00 [2.70MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/x/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-21:23:54:58-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:45-GMT-06:00 (~ 1.5 MB):
1.26MiB 0:00:00 [3.30MiB/s] [===================================================================================>                ] 84%            
Sending incremental send/test/x/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-21:23:55:00-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:47-GMT-06:00 (~ 1.2 MB):
 937KiB 0:00:00 [2.29MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/x/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-21:23:55:02-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:50-GMT-06:00 (~ 967 KB):
 805KiB 0:00:00 [1.98MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/x/l0_0/l1_3@syncoid_iox86_2024-12-21:23:55:04-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:51-GMT-06:00 (~ 1.7 MB):
1.29MiB 0:00:00 [3.66MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/x/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-21:23:55:06-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:53-GMT-06:00 (~ 1.5 MB):
1.18MiB 0:00:00 [3.01MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/x/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-21:23:55:08-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:55-GMT-06:00 (~ 1.7 MB):
1.19MiB 0:00:00 [2.95MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/x/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-21:23:55:10-GMT-06:00 ... syncoid_iox86_2024-12-22:00:11:58-GMT-06:00 (~ 966 KB):
 807KiB 0:00:00 [1.90MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/x/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-21:23:55:12-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:00-GMT-06:00 (~ 1.6 MB):
1.06MiB 0:00:00 [2.67MiB/s] [=================================================================>                                  ] 66%            
Sending incremental send/test/x/l0_1@syncoid_iox86_2024-12-21:23:55:13-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:01-GMT-06:00 (~ 1.5 MB):
1.05MiB 0:00:00 [3.23MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/x/l0_1/l1_0@syncoid_iox86_2024-12-21:23:55:15-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:03-GMT-06:00 (~ 742 KB):
 653KiB 0:00:00 [1.73MiB/s] [=======================================================================================>            ] 88%            
Sending incremental send/test/x/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-21:23:55:17-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:05-GMT-06:00 (~ 910 KB):
 696KiB 0:00:00 [1.73MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/x/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-21:23:55:19-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:07-GMT-06:00 (~ 1.6 MB):
1.18MiB 0:00:00 [2.90MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/x/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-21:23:55:21-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:09-GMT-06:00 (~ 1.2 MB):
 944KiB 0:00:00 [2.26MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/x/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-21:23:55:23-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:12-GMT-06:00 (~ 1.1 MB):
 933KiB 0:00:00 [2.23MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/x/l0_1/l1_1@syncoid_iox86_2024-12-21:23:55:25-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:13-GMT-06:00 (~ 1.7 MB):
1.31MiB 0:00:00 [3.60MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/x/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-21:23:55:27-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:16-GMT-06:00 (~ 982 KB):
 819KiB 0:00:00 [2.21MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/x/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-21:23:55:29-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:18-GMT-06:00 (~ 1.6 MB):
1.15MiB 0:00:00 [3.08MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/x/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-21:23:55:31-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:20-GMT-06:00 (~ 1.6 MB):
1.15MiB 0:00:00 [2.88MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/x/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-21:23:55:33-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:22-GMT-06:00 (~ 1.9 MB):
1.43MiB 0:00:00 [3.42MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/x/l0_1/l1_2@syncoid_iox86_2024-12-21:23:55:35-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:24-GMT-06:00 (~ 2.1 MB):
1.56MiB 0:00:00 [4.42MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/x/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-21:23:55:36-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:26-GMT-06:00 (~ 1.6 MB):
1.28MiB 0:00:00 [3.03MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/x/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-21:23:55:38-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:28-GMT-06:00 (~ 1.4 MB):
1.05MiB 0:00:00 [2.63MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/x/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-21:23:55:40-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:30-GMT-06:00 (~ 1.5 MB):
1.05MiB 0:00:00 [2.69MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/x/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-21:23:55:42-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:32-GMT-06:00 (~ 1.1 MB):
 828KiB 0:00:00 [2.19MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/x/l0_1/l1_3@syncoid_iox86_2024-12-21:23:55:44-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:34-GMT-06:00 (~ 1.6 MB):
1.18MiB 0:00:00 [3.28MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/x/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-21:23:55:46-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:36-GMT-06:00 (~ 1.4 MB):
1.05MiB 0:00:00 [2.76MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/x/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-21:23:55:48-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:38-GMT-06:00 (~ 1.4 MB):
1.06MiB 0:00:00 [2.77MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/x/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-21:23:55:50-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:40-GMT-06:00 (~ 1.3 MB):
 952KiB 0:00:00 [2.53MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/x/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-21:23:55:52-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:42-GMT-06:00 (~ 906 KB):
 797KiB 0:00:00 [1.89MiB/s] [======================================================================================>             ] 87%            
Sending incremental send/test/x/l0_2@syncoid_iox86_2024-12-21:23:55:53-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:44-GMT-06:00 (~ 1.7 MB):
1.30MiB 0:00:00 [4.03MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/x/l0_2/l1_0@syncoid_iox86_2024-12-21:23:55:55-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:46-GMT-06:00 (~ 1.4 MB):
1.07MiB 0:00:00 [3.05MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/x/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-21:23:55:57-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:48-GMT-06:00 (~ 1.9 MB):
1.42MiB 0:00:00 [3.64MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/x/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-21:23:55:59-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:50-GMT-06:00 (~ 1.5 MB):
1.06MiB 0:00:00 [2.77MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/x/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-21:23:56:01-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:52-GMT-06:00 (~ 1.2 MB):
 938KiB 0:00:00 [2.44MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/x/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-21:23:56:03-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:54-GMT-06:00 (~ 1.0 MB):
 811KiB 0:00:00 [2.16MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/x/l0_2/l1_1@syncoid_iox86_2024-12-21:23:56:05-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:56-GMT-06:00 (~ 1.1 MB):
 816KiB 0:00:00 [2.35MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/x/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-21:23:56:07-GMT-06:00 ... syncoid_iox86_2024-12-22:00:12:58-GMT-06:00 (~ 1.4 MB):
1.05MiB 0:00:00 [2.75MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/x/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-21:23:56:09-GMT-06:00 ... syncoid_iox86_2024-12-22:00:13:00-GMT-06:00 (~ 1.5 MB):
1.07MiB 0:00:00 [2.84MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/x/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-21:23:56:11-GMT-06:00 ... syncoid_iox86_2024-12-22:00:13:02-GMT-06:00 (~ 1.4 MB):
 928KiB 0:00:00 [2.25MiB/s] [=================================================================>                                  ] 66%            
Sending incremental send/test/x/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-21:23:56:13-GMT-06:00 ... syncoid_iox86_2024-12-22:00:13:04-GMT-06:00 (~ 1.5 MB):
1.05MiB 0:00:00 [2.58MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/x/l0_2/l1_2@syncoid_iox86_2024-12-21:23:56:14-GMT-06:00 ... syncoid_iox86_2024-12-22:00:13:06-GMT-06:00 (~ 670 KB):
 504KiB 0:00:00 [1.45MiB/s] [==========================================================================>                         ] 75%            
real 261.80
user 27.01
sys 192.09
  pool: send
 state: ONLINE
config:

        NAME                            STATE     READ WRITE CKSUM
        send                            ONLINE       0     0     0
          wwn-0x5002538d40dca5d9-part7  ONLINE       0     0     0

errors: No known data errors

Sending incremental send/test@syncoid_iox86_2024-12-22:00:08:46-GMT-06:00 ... syncoid_iox86_2024-12-22:00:25:38-GMT-06:00 (~ 4 KB):
2.13KiB 0:00:00 [26.9KiB/s] [====================================================>                                               ] 53%            
Sending incremental send/test/l0_0@syncoid_iox86_2024-12-22:00:08:47-GMT-06:00 ... syncoid_iox86_2024-12-22:00:25:39-GMT-06:00 (~ 1.5 MB):
1.18MiB 0:00:00 [5.57MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_0/l1_0@syncoid_iox86_2024-12-22:00:08:49-GMT-06:00 ... syncoid_iox86_2024-12-22:00:25:41-GMT-06:00 (~ 1.2 MB):
 943KiB 0:00:00 [4.02MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-22:00:08:51-GMT-06:00 ... syncoid_iox86_2024-12-22:00:25:42-GMT-06:00 (~ 1.4 MB):
1.07MiB 0:00:00 [4.25MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-22:00:08:53-GMT-06:00 ... syncoid_iox86_2024-12-22:00:25:44-GMT-06:00 (~ 1.7 MB):
1.30MiB 0:00:00 [5.23MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-22:00:08:54-GMT-06:00 ... syncoid_iox86_2024-12-22:00:25:46-GMT-06:00 (~ 1.4 MB):
1.06MiB 0:00:00 [4.01MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-22:00:08:56-GMT-06:00 ... syncoid_iox86_2024-12-22:00:25:47-GMT-06:00 (~ 1.5 MB):
1.05MiB 0:00:00 [4.39MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_0/l1_1@syncoid_iox86_2024-12-22:00:08:58-GMT-06:00 ... syncoid_iox86_2024-12-22:00:25:49-GMT-06:00 (~ 1.6 MB):
1.17MiB 0:00:00 [4.98MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-22:00:09:00-GMT-06:00 ... syncoid_iox86_2024-12-22:00:25:51-GMT-06:00 (~ 1.7 MB):
1.19MiB 0:00:00 [4.77MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-22:00:09:01-GMT-06:00 ... syncoid_iox86_2024-12-22:00:25:52-GMT-06:00 (~ 1.6 MB):
1.17MiB 0:00:00 [4.92MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-22:00:09:03-GMT-06:00 ... syncoid_iox86_2024-12-22:00:25:54-GMT-06:00 (~ 1.5 MB):
1.05MiB 0:00:00 [4.08MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-22:00:09:05-GMT-06:00 ... syncoid_iox86_2024-12-22:00:25:56-GMT-06:00 (~ 1.4 MB):
 954KiB 0:00:00 [3.63MiB/s] [=================================================================>                                  ] 66%            
Sending incremental send/test/l0_0/l1_2@syncoid_iox86_2024-12-22:00:09:07-GMT-06:00 ... syncoid_iox86_2024-12-22:00:25:57-GMT-06:00 (~ 1.8 MB):
1.45MiB 0:00:00 [5.95MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-22:00:09:08-GMT-06:00 ... syncoid_iox86_2024-12-22:00:25:59-GMT-06:00 (~ 878 KB):
 675KiB 0:00:00 [2.71MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-22:00:09:10-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:01-GMT-06:00 (~ 1.2 MB):
 947KiB 0:00:00 [3.86MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-22:00:09:12-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:02-GMT-06:00 (~ 1.3 MB):
 948KiB 0:00:00 [3.91MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-22:00:09:14-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:04-GMT-06:00 (~ 1.1 MB):
 813KiB 0:00:00 [3.24MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_0/l1_3@syncoid_iox86_2024-12-22:00:09:15-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:06-GMT-06:00 (~ 1.3 MB):
1.04MiB 0:00:00 [4.53MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-22:00:09:17-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:07-GMT-06:00 (~ 1.0 MB):
 681KiB 0:00:00 [2.58MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-22:00:09:19-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:09-GMT-06:00 (~ 1.8 MB):
1.17MiB 0:00:00 [4.91MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-22:00:09:21-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:11-GMT-06:00 (~ 1.5 MB):
1.17MiB 0:00:00 [4.45MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-22:00:09:22-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:13-GMT-06:00 (~ 1.8 MB):
1.31MiB 0:00:00 [5.13MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_1@syncoid_iox86_2024-12-22:00:09:24-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:14-GMT-06:00 (~ 1.3 MB):
 948KiB 0:00:00 [4.29MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_1/l1_0@syncoid_iox86_2024-12-22:00:09:26-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:16-GMT-06:00 (~ 1.5 MB):
1.19MiB 0:00:00 [4.80MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-22:00:09:27-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:17-GMT-06:00 (~ 1.7 MB):
1.18MiB 0:00:00 [4.66MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-22:00:09:29-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:19-GMT-06:00 (~ 1.2 MB):
 942KiB 0:00:00 [3.57MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-22:00:09:31-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:21-GMT-06:00 (~ 1.6 MB):
1.19MiB 0:00:00 [4.80MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-22:00:09:33-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:23-GMT-06:00 (~ 1.5 MB):
1.07MiB 0:00:00 [4.21MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_1/l1_1@syncoid_iox86_2024-12-22:00:09:34-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:24-GMT-06:00 (~ 1.3 MB):
 953KiB 0:00:00 [4.08MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-22:00:09:36-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:26-GMT-06:00 (~ 1.3 MB):
 945KiB 0:00:00 [3.74MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-22:00:09:38-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:28-GMT-06:00 (~ 1.2 MB):
1.06MiB 0:00:00 [4.29MiB/s] [====================================================================================>               ] 85%            
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-22:00:09:40-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:29-GMT-06:00 (~ 1.3 MB):
1.02MiB 0:00:00 [4.08MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-22:00:09:42-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:31-GMT-06:00 (~ 1.8 MB):
1.29MiB 0:00:00 [5.27MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_1/l1_2@syncoid_iox86_2024-12-22:00:09:43-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:33-GMT-06:00 (~ 1.9 MB):
1.51MiB 0:00:00 [6.65MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-22:00:09:45-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:34-GMT-06:00 (~ 685 KB):
 546KiB 0:00:00 [2.20MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-22:00:09:47-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:36-GMT-06:00 (~ 1.1 MB):
 934KiB 0:00:00 [3.67MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-22:00:09:49-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:38-GMT-06:00 (~ 1.6 MB):
1.17MiB 0:00:00 [4.61MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-22:00:09:51-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:40-GMT-06:00 (~ 1.2 MB):
 934KiB 0:00:00 [3.76MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_1/l1_3@syncoid_iox86_2024-12-22:00:09:52-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:41-GMT-06:00 (~ 1.3 MB):
1022KiB 0:00:00 [4.24MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-22:00:09:54-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:43-GMT-06:00 (~ 1.9 MB):
1.43MiB 0:00:00 [5.69MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-22:00:09:56-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:45-GMT-06:00 (~ 1.6 MB):
1.18MiB 0:00:00 [4.65MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-22:00:09:58-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:46-GMT-06:00 (~ 1.4 MB):
1.05MiB 0:00:00 [4.30MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-22:00:10:00-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:48-GMT-06:00 (~ 1.7 MB):
1.18MiB 0:00:00 [4.65MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_2@syncoid_iox86_2024-12-22:00:10:01-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:50-GMT-06:00 (~ 1.1 MB):
 943KiB 0:00:00 [4.01MiB/s] [===================================================================================>                ] 84%            
Sending incremental send/test/l0_2/l1_0@syncoid_iox86_2024-12-22:00:10:03-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:51-GMT-06:00 (~ 1.5 MB):
1.17MiB 0:00:00 [4.90MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-22:00:10:05-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:53-GMT-06:00 (~ 2.2 MB):
1.65MiB 0:00:00 [6.13MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-22:00:10:06-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:55-GMT-06:00 (~ 1.5 MB):
1.18MiB 0:00:00 [4.68MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-22:00:10:08-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:56-GMT-06:00 (~ 1.6 MB):
1.15MiB 0:00:00 [4.55MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-22:00:10:10-GMT-06:00 ... syncoid_iox86_2024-12-22:00:26:58-GMT-06:00 (~ 1.5 MB):
1.19MiB 0:00:00 [4.68MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_2/l1_1@syncoid_iox86_2024-12-22:00:10:12-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:00-GMT-06:00 (~ 1.4 MB):
1.05MiB 0:00:00 [4.59MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-22:00:10:14-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:02-GMT-06:00 (~ 1.3 MB):
1.04MiB 0:00:00 [4.07MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-22:00:10:16-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:03-GMT-06:00 (~ 1.3 MB):
1.06MiB 0:00:00 [4.31MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-22:00:10:17-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:05-GMT-06:00 (~ 1.7 MB):
1.31MiB 0:00:00 [5.05MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-22:00:10:19-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:07-GMT-06:00 (~ 1.7 MB):
1.30MiB 0:00:00 [5.11MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_2/l1_2@syncoid_iox86_2024-12-22:00:10:21-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:09-GMT-06:00 (~ 998 KB):
 662KiB 0:00:00 [3.00MiB/s] [=================================================================>                                  ] 66%            
Sending incremental send/test/l0_2/l1_2/l2_0@syncoid_iox86_2024-12-22:00:10:23-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:10-GMT-06:00 (~ 1.6 MB):
1.18MiB 0:00:00 [4.49MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_2/l1_2/l2_1@syncoid_iox86_2024-12-22:00:10:25-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:12-GMT-06:00 (~ 1.7 MB):
1.18MiB 0:00:00 [4.92MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_2/l1_2/l2_2@syncoid_iox86_2024-12-22:00:10:27-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:14-GMT-06:00 (~ 966 KB):
 806KiB 0:00:00 [3.15MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/l0_2/l1_2/l2_3@syncoid_iox86_2024-12-22:00:10:28-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:16-GMT-06:00 (~ 1.1 MB):
 815KiB 0:00:00 [3.46MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_2/l1_3@syncoid_iox86_2024-12-22:00:10:30-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:17-GMT-06:00 (~ 954 KB):
 679KiB 0:00:00 [3.01MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_2/l1_3/l2_0@syncoid_iox86_2024-12-22:00:10:32-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:19-GMT-06:00 (~ 1.1 MB):
 928KiB 0:00:00 [3.50MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-22:00:10:34-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:21-GMT-06:00 (~ 1.2 MB):
 917KiB 0:00:00 [3.53MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_2/l1_3/l2_2@syncoid_iox86_2024-12-22:00:10:36-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:22-GMT-06:00 (~ 1.7 MB):
warning: cannot send 'send/test/l0_2/l1_3/l2_2@syncoid_iox86_2024-12-22:00:27:22-GMT-06:00': Input/output error
 797KiB 0:00:00 [4.84MiB/s] [============================================>                                                       ] 45%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-10a0ab0a75-118-789c636064000310a501c49c50360710a715e5e7a69766a630408108d3b7afbf0eeb3c5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f910574cdca1b55bfe11934202923c27583e2f31379581a138352f451f6854897e8e41bc917e8e61bcb17e8e51bc914371655e727e664a7c667e858559bc91819189aea191ae91919581819591b9959191aebb6f88ae8119900f7303005e912c8d
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_2'@'syncoid_iox86_2024-12-22:00:10:36-GMT-06:00' 'send/test/l0_2/l1_3/l2_2'@'syncoid_iox86_2024-12-22:00:27:22-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1809976 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-22:00:10:37-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:24-GMT-06:00 (~ 1.6 MB):
1.18MiB 0:00:00 [4.64MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_3@syncoid_iox86_2024-12-22:00:10:39-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:26-GMT-06:00 (~ 1.1 MB):
 820KiB 0:00:00 [3.73MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_3/l1_0@syncoid_iox86_2024-12-22:00:10:41-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:27-GMT-06:00 (~ 1.3 MB):
 930KiB 0:00:00 [3.95MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_3/l1_0/l2_0@syncoid_iox86_2024-12-22:00:10:42-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:29-GMT-06:00 (~ 970 KB):
 682KiB 0:00:00 [2.76MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_3/l1_0/l2_1@syncoid_iox86_2024-12-22:00:10:44-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:31-GMT-06:00 (~ 1.3 MB):
1.05MiB 0:00:00 [4.18MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_3/l1_0/l2_2@syncoid_iox86_2024-12-22:00:10:46-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:32-GMT-06:00 (~ 1.5 MB):
1.27MiB 0:00:00 [5.05MiB/s] [===================================================================================>                ] 84%            
Sending incremental send/test/l0_3/l1_0/l2_3@syncoid_iox86_2024-12-22:00:10:48-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:34-GMT-06:00 (~ 1.2 MB):
 913KiB 0:00:00 [3.46MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_3/l1_1@syncoid_iox86_2024-12-22:00:10:50-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:36-GMT-06:00 (~ 1.5 MB):
1.19MiB 0:00:00 [4.91MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_3/l1_1/l2_0@syncoid_iox86_2024-12-22:00:10:51-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:38-GMT-06:00 (~ 1.6 MB):
1.16MiB 0:00:00 [4.63MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_3/l1_1/l2_1@syncoid_iox86_2024-12-22:00:10:53-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:39-GMT-06:00 (~ 1.6 MB):
1.19MiB 0:00:00 [4.40MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_3/l1_1/l2_2@syncoid_iox86_2024-12-22:00:10:55-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:41-GMT-06:00 (~ 1.3 MB):
 934KiB 0:00:00 [3.68MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_3/l1_1/l2_3@syncoid_iox86_2024-12-22:00:10:57-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:43-GMT-06:00 (~ 1.6 MB):
1.30MiB 0:00:00 [5.20MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_3/l1_2@syncoid_iox86_2024-12-22:00:10:59-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:45-GMT-06:00 (~ 1.3 MB):
 927KiB 0:00:00 [4.05MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_3/l1_2/l2_0@syncoid_iox86_2024-12-22:00:11:00-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:46-GMT-06:00 (~ 1.8 MB):
1.31MiB 0:00:00 [5.09MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_3/l1_2/l2_1@syncoid_iox86_2024-12-22:00:11:02-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:48-GMT-06:00 (~ 1.7 MB):
1.19MiB 0:00:00 [4.90MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_3/l1_2/l2_2@syncoid_iox86_2024-12-22:00:11:04-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:50-GMT-06:00 (~ 1.3 MB):
1.04MiB 0:00:00 [4.07MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_3/l1_2/l2_3@syncoid_iox86_2024-12-22:00:11:06-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:52-GMT-06:00 (~ 1.6 MB):
1.17MiB 0:00:00 [4.52MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_3/l1_3@syncoid_iox86_2024-12-22:00:11:08-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:53-GMT-06:00 (~ 1.1 MB):
 957KiB 0:00:00 [3.81MiB/s] [===================================================================================>                ] 84%            
Sending incremental send/test/l0_3/l1_3/l2_0@syncoid_iox86_2024-12-22:00:11:10-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:55-GMT-06:00 (~ 1.9 MB):
1.41MiB 0:00:00 [5.34MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_3/l1_3/l2_1@syncoid_iox86_2024-12-22:00:11:11-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:57-GMT-06:00 (~ 1.3 MB):
 954KiB 0:00:00 [3.78MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_3/l1_3/l2_2@syncoid_iox86_2024-12-22:00:11:13-GMT-06:00 ... syncoid_iox86_2024-12-22:00:27:59-GMT-06:00 (~ 1.7 MB):
1.31MiB 0:00:00 [5.28MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-22:00:11:15-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:00-GMT-06:00 (~ 1.5 MB):
1.07MiB 0:00:00 [4.03MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/x@syncoid_iox86_2024-12-22:00:11:17-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:02-GMT-06:00 (~ 4 KB):
2.13KiB 0:00:00 [26.1KiB/s] [====================================================>                                               ] 53%            
Sending incremental send/test/x/l0_0@syncoid_iox86_2024-12-22:00:11:18-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:03-GMT-06:00 (~ 1.5 MB):
1.06MiB 0:00:00 [4.54MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/x/l0_0/l1_0@syncoid_iox86_2024-12-22:00:11:20-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:05-GMT-06:00 (~ 1.1 MB):
 820KiB 0:00:00 [3.19MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/x/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-22:00:11:22-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:07-GMT-06:00 (~ 1.3 MB):
 946KiB 0:00:00 [3.58MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/x/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-22:00:11:24-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:09-GMT-06:00 (~ 1.7 MB):
1.31MiB 0:00:00 [4.50MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/x/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-22:00:11:26-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:11-GMT-06:00 (~ 1.2 MB):
 934KiB 0:00:00 [3.44MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/x/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-22:00:11:28-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:13-GMT-06:00 (~ 1.6 MB):
1.29MiB 0:00:00 [4.77MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/x/l0_0/l1_1@syncoid_iox86_2024-12-22:00:11:30-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:15-GMT-06:00 (~ 1.2 MB):
 944KiB 0:00:00 [3.64MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/x/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-22:00:11:32-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:17-GMT-06:00 (~ 1.0 MB):
 812KiB 0:00:00 [2.93MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/x/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-22:00:11:34-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:19-GMT-06:00 (~ 1.2 MB):
 944KiB 0:00:00 [3.39MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/x/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-22:00:11:36-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:21-GMT-06:00 (~ 914 KB):
 669KiB 0:00:00 [2.45MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/x/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-22:00:11:39-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:23-GMT-06:00 (~ 381 KB):
 270KiB 0:00:00 [1.01MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/x/l0_0/l1_2@syncoid_iox86_2024-12-22:00:11:41-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:25-GMT-06:00 (~ 1.2 MB):
 899KiB 0:00:00 [3.57MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/x/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-22:00:11:43-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:26-GMT-06:00 (~ 722 KB):
 542KiB 0:00:00 [2.01MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/x/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-22:00:11:45-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:28-GMT-06:00 (~ 305 KB):
 272KiB 0:00:00 [1006KiB/s] [========================================================================================>           ] 89%            
Sending incremental send/test/x/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-22:00:11:47-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:30-GMT-06:00 (~ 513 KB):
 400KiB 0:00:00 [1.56MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/x/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-22:00:11:50-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:32-GMT-06:00 (~ 766 KB):
 537KiB 0:00:00 [2.01MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/x/l0_0/l1_3@syncoid_iox86_2024-12-22:00:11:51-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:34-GMT-06:00 (~ 589 KB):
 407KiB 0:00:00 [1.59MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/x/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-22:00:11:53-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:36-GMT-06:00 (~ 633 KB):
 399KiB 0:00:00 [1.55MiB/s] [=============================================================>                                      ] 62%            
Sending incremental send/test/x/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-22:00:11:55-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:38-GMT-06:00 (~ 690 KB):
 523KiB 0:00:00 [1.85MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/x/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-22:00:11:58-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:40-GMT-06:00 (~ 513 KB):
 406KiB 0:00:00 [1.53MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/x/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-22:00:12:00-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:42-GMT-06:00 (~ 529 KB):
 411KiB 0:00:00 [1.51MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/x/l0_1@syncoid_iox86_2024-12-22:00:12:01-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:44-GMT-06:00 (~ 722 KB):
 545KiB 0:00:00 [2.32MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/x/l0_1/l1_0@syncoid_iox86_2024-12-22:00:12:03-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:45-GMT-06:00 (~ 798 KB):
 552KiB 0:00:00 [2.01MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/x/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-22:00:12:05-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:47-GMT-06:00 (~ 826 KB):
 537KiB 0:00:00 [1.95MiB/s] [================================================================>                                   ] 65%            
Sending incremental send/test/x/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-22:00:12:07-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:49-GMT-06:00 (~ 1.2 MB):
 925KiB 0:00:00 [3.33MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/x/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-22:00:12:09-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:51-GMT-06:00 (~ 690 KB):
 526KiB 0:00:00 [2.01MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/x/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-22:00:12:12-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:53-GMT-06:00 (~ 794 KB):
 668KiB 0:00:00 [2.33MiB/s] [===================================================================================>                ] 84%            
Sending incremental send/test/x/l0_1/l1_1@syncoid_iox86_2024-12-22:00:12:13-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:55-GMT-06:00 (~ 782 KB):
 548KiB 0:00:00 [2.24MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/x/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-22:00:12:16-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:57-GMT-06:00 (~ 662 KB):
 544KiB 0:00:00 [1.78MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/x/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-22:00:12:18-GMT-06:00 ... syncoid_iox86_2024-12-22:00:28:59-GMT-06:00 (~ 349 KB):
 246KiB 0:00:00 [ 832KiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/x/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-22:00:12:20-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:01-GMT-06:00 (~ 589 KB):
 414KiB 0:00:00 [1.49MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/x/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-22:00:12:22-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:03-GMT-06:00 (~ 453 KB):
 405KiB 0:00:00 [1.48MiB/s] [========================================================================================>           ] 89%            
Sending incremental send/test/x/l0_1/l1_2@syncoid_iox86_2024-12-22:00:12:24-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:05-GMT-06:00 (~ 1.0 MB):
 801KiB 0:00:00 [3.12MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/x/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-22:00:12:26-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:07-GMT-06:00 (~ 782 KB):
 536KiB 0:00:00 [1.96MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/x/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-22:00:12:28-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:09-GMT-06:00 (~ 529 KB):
 407KiB 0:00:00 [1.50MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/x/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-22:00:12:30-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:11-GMT-06:00 (~ 573 KB):
 407KiB 0:00:00 [1.51MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/x/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-22:00:12:32-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:13-GMT-06:00 (~ 529 KB):
 413KiB 0:00:00 [1.47MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/x/l0_1/l1_3@syncoid_iox86_2024-12-22:00:12:34-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:15-GMT-06:00 (~ 782 KB):
 543KiB 0:00:00 [2.20MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/x/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-22:00:12:36-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:17-GMT-06:00 (~ 321 KB):
 270KiB 0:00:00 [ 989KiB/s] [===================================================================================>                ] 84%            
Sending incremental send/test/x/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-22:00:12:38-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:19-GMT-06:00 (~ 513 KB):
 409KiB 0:00:00 [1.35MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/x/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-22:00:12:40-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:21-GMT-06:00 (~ 573 KB):
 407KiB 0:00:00 [1.44MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/x/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-22:00:12:42-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:23-GMT-06:00 (~ 854 KB):
 670KiB 0:00:00 [2.42MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/x/l0_2@syncoid_iox86_2024-12-22:00:12:44-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:24-GMT-06:00 (~ 646 KB):
 538KiB 0:00:00 [2.20MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/x/l0_2/l1_0@syncoid_iox86_2024-12-22:00:12:46-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:26-GMT-06:00 (~ 573 KB):
 407KiB 0:00:00 [1.65MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/x/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-22:00:12:48-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:28-GMT-06:00 (~ 974 KB):
 665KiB 0:00:00 [2.40MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/x/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-22:00:12:50-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:30-GMT-06:00 (~ 513 KB):
 409KiB 0:00:00 [1.47MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/x/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-22:00:12:52-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:32-GMT-06:00 (~ 573 KB):
 407KiB 0:00:00 [1.42MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/x/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-22:00:12:54-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:34-GMT-06:00 (~ 437 KB):
 399KiB 0:00:00 [1.47MiB/s] [==========================================================================================>         ] 91%            
Sending incremental send/test/x/l0_2/l1_1@syncoid_iox86_2024-12-22:00:12:56-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:36-GMT-06:00 (~ 782 KB):
 546KiB 0:00:00 [2.33MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/x/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-22:00:12:58-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:38-GMT-06:00 (~ 633 KB):
 410KiB 0:00:00 [1.54MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/x/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-22:00:13:00-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:40-GMT-06:00 (~ 589 KB):
 418KiB 0:00:00 [1.51MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/x/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-22:00:13:02-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:42-GMT-06:00 (~ 1.1 MB):
 805KiB 0:00:00 [2.89MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/x/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-22:00:13:04-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:44-GMT-06:00 (~ 778 KB):
 661KiB 0:00:00 [2.17MiB/s] [====================================================================================>               ] 85%            
Sending incremental send/test/x/l0_2/l1_2@syncoid_iox86_2024-12-22:00:13:06-GMT-06:00 ... syncoid_iox86_2024-12-22:00:29:46-GMT-06:00 (~ 321 KB):
 269KiB 0:00:00 [1.10MiB/s] [==================================================================================>                 ] 83%            
real 249.52
user 26.98
sys 189.48
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

errors: 1 data errors, use '-v' for a list

Sending incremental send/test@syncoid_iox86_2024-12-22:00:25:38-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:18-GMT-06:00 (~ 4 KB):
2.13KiB 0:00:00 [26.5KiB/s] [====================================================>                                               ] 53%            
Sending incremental send/test/l0_0@syncoid_iox86_2024-12-22:00:25:39-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:19-GMT-06:00 (~ 738 KB):
 549KiB 0:00:00 [2.59MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_0/l1_0@syncoid_iox86_2024-12-22:00:25:41-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:20-GMT-06:00 (~ 469 KB):
 416KiB 0:00:00 [1.80MiB/s] [=======================================================================================>            ] 88%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-22:00:25:42-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:22-GMT-06:00 (~ 589 KB):
 416KiB 0:00:00 [1.57MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-22:00:25:44-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:24-GMT-06:00 (~ 513 KB):
 403KiB 0:00:00 [1.62MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-22:00:25:46-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:25-GMT-06:00 (~ 706 KB):
 537KiB 0:00:00 [2.16MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-22:00:25:47-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:27-GMT-06:00 (~ 914 KB):
 672KiB 0:00:00 [2.64MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_0/l1_1@syncoid_iox86_2024-12-22:00:25:49-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:29-GMT-06:00 (~ 738 KB):
 543KiB 0:00:00 [2.46MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-22:00:25:51-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:30-GMT-06:00 (~ 974 KB):
 672KiB 0:00:00 [2.71MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-22:00:25:52-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:32-GMT-06:00 (~ 513 KB):
 402KiB 0:00:00 [1.59MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-22:00:25:54-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:34-GMT-06:00 (~ 870 KB):
 678KiB 0:00:00 [2.75MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-22:00:25:56-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:36-GMT-06:00 (~ 974 KB):
 671KiB 0:00:00 [2.72MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_0/l1_2@syncoid_iox86_2024-12-22:00:25:57-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:37-GMT-06:00 (~ 1.1 MB):
 799KiB 0:00:00 [3.52MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-22:00:25:59-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:39-GMT-06:00 (~ 782 KB):
 541KiB 0:00:00 [2.16MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-22:00:26:01-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:41-GMT-06:00 (~ 441 KB):
 274KiB 0:00:00 [1.17MiB/s] [=============================================================>                                      ] 62%            
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-22:00:26:02-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:42-GMT-06:00 (~ 601 KB):
 544KiB 0:00:00 [2.11MiB/s] [=========================================================================================>          ] 90%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-22:00:26:04-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:44-GMT-06:00 (~ 497 KB):
 397KiB 0:00:00 [1.64MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_0/l1_3@syncoid_iox86_2024-12-22:00:26:06-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:46-GMT-06:00 (~ 1.0 MB):
 796KiB 0:00:00 [3.58MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-22:00:26:07-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:47-GMT-06:00 (~ 513 KB):
 408KiB 0:00:00 [1.63MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-22:00:26:09-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:49-GMT-06:00 (~ 365 KB):
 272KiB 0:00:00 [1.12MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-22:00:26:11-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:51-GMT-06:00 (~ 722 KB):
 539KiB 0:00:00 [2.15MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-22:00:26:13-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:52-GMT-06:00 (~ 782 KB):
warning: cannot send 'send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-22:00:42:52-GMT-06:00': Input/output error
1.83KiB 0:00:00 [18.3KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-109661217d-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081e0c18af89b7cbd8715806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4154629df189a58fed72620c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61bebe718c51b3b1457e625e767a6c467e6575898c51b191899e81a1ae91a1959191858991859991ae9bafb86e81a9801f9303700009aaa2bd9
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_3'@'syncoid_iox86_2024-12-22:00:26:13-GMT-06:00' 'send/test/l0_0/l1_3/l2_3'@'syncoid_iox86_2024-12-22:00:42:52-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 801072 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1@syncoid_iox86_2024-12-22:00:26:14-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:54-GMT-06:00 (~ 722 KB):
 537KiB 0:00:00 [2.60MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_1/l1_0@syncoid_iox86_2024-12-22:00:26:16-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:55-GMT-06:00 (~ 854 KB):
 672KiB 0:00:00 [2.95MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-22:00:26:17-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:57-GMT-06:00 (~ 662 KB):
 535KiB 0:00:00 [2.12MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-22:00:26:19-GMT-06:00 ... syncoid_iox86_2024-12-22:00:42:59-GMT-06:00 (~ 633 KB):
 405KiB 0:00:00 [1.68MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-22:00:26:21-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:01-GMT-06:00 (~ 706 KB):
 532KiB 0:00:00 [2.09MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-22:00:26:23-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:02-GMT-06:00 (~ 589 KB):
 407KiB 0:00:00 [1.68MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_1/l1_1@syncoid_iox86_2024-12-22:00:26:24-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:04-GMT-06:00 (~ 662 KB):
warning: cannot send 'send/test/l0_1/l1_1@syncoid_iox86_2024-12-22:00:43:04-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [15.2KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-22:00:26:26-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:05-GMT-06:00 (~ 1.2 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-22:00:43:05-GMT-06:00': Input/output error
1.83KiB 0:00:00 [17.4KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-120ee40736-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1a98a3b06eb9f3bfd5600b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f910573c488b5ce910a3529b8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa89f6308228ce20d1c8a2bf392f33353e233f32b2ccce28d0c8c4c740d8d748d8cac0c0cac4c8cad0c4c75dd7d43740dcc807c981b00be522d0c
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_0'@'syncoid_iox86_2024-12-22:00:26:26-GMT-06:00' 'send/test/l0_1/l1_1/l2_0'@'syncoid_iox86_2024-12-22:00:43:05-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1235800 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-22:00:26:28-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:07-GMT-06:00 (~ 1.1 MB):
 918KiB 0:00:00 [3.44MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-22:00:26:29-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:09-GMT-06:00 (~ 1.2 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-22:00:43:09-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [15.1KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-22:00:26:31-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:11-GMT-06:00 (~ 601 KB):
warning: cannot send 'send/test/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-22:00:43:11-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [16.0KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_1/l1_2@syncoid_iox86_2024-12-22:00:26:33-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:12-GMT-06:00 (~ 173 KB):
 141KiB 0:00:00 [ 697KiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-22:00:26:34-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:14-GMT-06:00 (~ 650 KB):
 410KiB 0:00:00 [1.73MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-22:00:26:36-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:16-GMT-06:00 (~ 650 KB):
 410KiB 0:00:00 [1.76MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-22:00:26:38-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:17-GMT-06:00 (~ 706 KB):
warning: cannot send 'send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-22:00:43:17-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [15.4KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-22:00:26:40-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:19-GMT-06:00 (~ 838 KB):
warning: cannot send 'send/test/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-22:00:43:19-GMT-06:00': Input/output error
1.83KiB 0:00:00 [19.3KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11c63263b1-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c169b9235227aeff3aa20064b323a9cb4fca4a4d2e81f04100433e2dad38b584010e40f26c48f2499525a9c50ca8f2c8fa4bf221ae5822ccbfeb869b847602923c27583e2f31379581a138352f451f6854897e8e41bca17e8e61bc917e8e51bcb14371655e727e664a7c667e858559bc91819189aea191ae91919581819589b195a1a5aebb6f88ae8119900f7303007c502c74
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_3'@'syncoid_iox86_2024-12-22:00:26:40-GMT-06:00' 'send/test/l0_1/l1_2/l2_3'@'syncoid_iox86_2024-12-22:00:43:19-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 858416 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_3@syncoid_iox86_2024-12-22:00:26:41-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:20-GMT-06:00 (~ 662 KB):
 540KiB 0:00:00 [2.31MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-22:00:26:43-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:22-GMT-06:00 (~ 589 KB):
 407KiB 0:00:00 [1.75MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-22:00:26:45-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:24-GMT-06:00 (~ 854 KB):
 672KiB 0:00:00 [2.76MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-22:00:26:46-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:26-GMT-06:00 (~ 381 KB):
 278KiB 0:00:00 [1.19MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-22:00:26:48-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:27-GMT-06:00 (~ 678 KB):
 548KiB 0:00:00 [2.14MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_2@syncoid_iox86_2024-12-22:00:26:50-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:29-GMT-06:00 (~ 690 KB):
 517KiB 0:00:00 [2.47MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_2/l1_0@syncoid_iox86_2024-12-22:00:26:51-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:30-GMT-06:00 (~ 513 KB):
 408KiB 0:00:00 [1.79MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-22:00:26:53-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:32-GMT-06:00 (~ 706 KB):
 533KiB 0:00:00 [2.05MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-22:00:26:55-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:34-GMT-06:00 (~ 589 KB):
 409KiB 0:00:00 [1.57MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-22:00:26:56-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:36-GMT-06:00 (~ 914 KB):
 668KiB 0:00:00 [2.60MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-22:00:26:58-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:38-GMT-06:00 (~ 453 KB):
 410KiB 0:00:00 [1.68MiB/s] [=========================================================================================>          ] 90%            
Sending incremental send/test/l0_2/l1_1@syncoid_iox86_2024-12-22:00:27:00-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:39-GMT-06:00 (~ 573 KB):
 410KiB 0:00:00 [1.84MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-22:00:27:02-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:41-GMT-06:00 (~ 798 KB):
 540KiB 0:00:00 [2.26MiB/s] [==================================================================>                                 ] 67%            
Sending incremental send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-22:00:27:03-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:43-GMT-06:00 (~ 930 KB):
 676KiB 0:00:00 [2.73MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-22:00:27:05-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:44-GMT-06:00 (~ 646 KB):
warning: cannot send 'send/test/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-22:00:43:44-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [15.0KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-22:00:27:07-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:46-GMT-06:00 (~ 854 KB):
 669KiB 0:00:00 [2.69MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_2/l1_2@syncoid_iox86_2024-12-22:00:27:09-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:48-GMT-06:00 (~ 990 KB):
warning: cannot send 'send/test/l0_2/l1_2@syncoid_iox86_2024-12-22:00:43:48-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [15.4KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_2/l1_2/l2_0@syncoid_iox86_2024-12-22:00:27:10-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:49-GMT-06:00 (~ 722 KB):
 537KiB 0:00:00 [2.21MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_2/l1_2/l2_1@syncoid_iox86_2024-12-22:00:27:12-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:51-GMT-06:00 (~ 646 KB):
 533KiB 0:00:00 [2.03MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/l0_2/l1_2/l2_2@syncoid_iox86_2024-12-22:00:27:14-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:53-GMT-06:00 (~ 914 KB):
warning: cannot send 'send/test/l0_2/l1_2/l2_2@syncoid_iox86_2024-12-22:00:43:53-GMT-06:00': Input/output error
1.83KiB 0:00:00 [17.9KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-12f5e0b927-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041e80c4ed68712ff2f2b00d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b26f704063f88db129c8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f6308228ce28d1c8a2bf392f33353e233f32b2ccce28d0c8c4c740d8d748d8cac0c0cac4c8cad4c8d75dd7d43740dcc807c981b00b4e02c3b
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_2/l2_2'@'syncoid_iox86_2024-12-22:00:27:14-GMT-06:00' 'send/test/l0_2/l1_2/l2_2'@'syncoid_iox86_2024-12-22:00:43:53-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 936424 |  zfs receive  -s -F 'recv/test/l0_2/l1_2/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_2/l2_3@syncoid_iox86_2024-12-22:00:27:16-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:55-GMT-06:00 (~ 882 KB):
 804KiB 0:00:00 [2.85MiB/s] [==========================================================================================>         ] 91%            
Sending incremental send/test/l0_2/l1_3@syncoid_iox86_2024-12-22:00:27:17-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:56-GMT-06:00 (~ 381 KB):
warning: cannot send 'send/test/l0_2/l1_3@syncoid_iox86_2024-12-22:00:43:56-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [15.6KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_2/l1_3/l2_0@syncoid_iox86_2024-12-22:00:27:19-GMT-06:00 ... syncoid_iox86_2024-12-22:00:43:58-GMT-06:00 (~ 722 KB):
 534KiB 0:00:00 [2.14MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-22:00:27:21-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:00-GMT-06:00 (~ 541 KB):
 380KiB 0:00:00 [1.55MiB/s] [=====================================================================>                              ] 70%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_2 to recv/test/l0_2/l1_3/l2_2 (~ 721 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_3/l2_2@syncoid_iox86_2024-12-22:00:27:22-GMT-06:00': Invalid argument
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-10a0ab0a75-118-789c636064000310a501c49c50360710a715e5e7a69766a630408108d3b7afbf0eeb3c5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f910574cdca1b55bfe11934202923c27583e2f31379581a138352f451f6854897e8e41bc917e8e61bcb17e8e51bc914371655e727e664a7c667e858559bc91819189aea191ae91919581819591b9959191aebb6f88ae8119900f7303005e912c8d | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 738824 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-22:00:27:24-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:02-GMT-06:00 (~ 706 KB):
warning: cannot send 'send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-22:00:44:02-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [14.7KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_3@syncoid_iox86_2024-12-22:00:27:26-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:03-GMT-06:00 (~ 305 KB):
warning: cannot send 'send/test/l0_3@syncoid_iox86_2024-12-22:00:44:03-GMT-06:00': Input/output error
1.83KiB 0:00:00 [19.7KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-10a45913a1-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1e6871289a67a9d4b15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415bfaf499b27739d5b158124cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fec505c99979c9f99129f995f6161166f646064a26b68a46b64646560606562626560acebee1ba26b6006e423ec06002066294d
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3'@'syncoid_iox86_2024-12-22:00:27:26-GMT-06:00' 'send/test/l0_3'@'syncoid_iox86_2024-12-22:00:44:03-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 312912 |  zfs receive  -s -F 'recv/test/l0_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_0@syncoid_iox86_2024-12-22:00:27:27-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:05-GMT-06:00 (~ 810 KB):
warning: cannot send 'send/test/l0_3/l1_0@syncoid_iox86_2024-12-22:00:44:05-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [15.5KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_3/l1_0/l2_0@syncoid_iox86_2024-12-22:00:27:29-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:06-GMT-06:00 (~ 794 KB):
warning: cannot send 'send/test/l0_3/l1_0/l2_0@syncoid_iox86_2024-12-22:00:44:06-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [15.2KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_3/l1_0/l2_1@syncoid_iox86_2024-12-22:00:27:31-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:08-GMT-06:00 (~ 573 KB):
 401KiB 0:00:00 [1.64MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_3/l1_0/l2_2@syncoid_iox86_2024-12-22:00:27:32-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:10-GMT-06:00 (~ 798 KB):
 548KiB 0:00:00 [2.23MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_3/l1_0/l2_3@syncoid_iox86_2024-12-22:00:27:34-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:12-GMT-06:00 (~ 1002 KB):
 805KiB 0:00:00 [3.18MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_3/l1_1@syncoid_iox86_2024-12-22:00:27:36-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:13-GMT-06:00 (~ 914 KB):
 672KiB 0:00:00 [2.96MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_3/l1_1/l2_0@syncoid_iox86_2024-12-22:00:27:38-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:15-GMT-06:00 (~ 722 KB):
 539KiB 0:00:00 [2.21MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_3/l1_1/l2_1@syncoid_iox86_2024-12-22:00:27:39-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:17-GMT-06:00 (~ 974 KB):
 671KiB 0:00:00 [2.65MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_3/l1_1/l2_2@syncoid_iox86_2024-12-22:00:27:41-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:18-GMT-06:00 (~ 1.0 MB):
 800KiB 0:00:00 [3.09MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_3/l1_1/l2_3@syncoid_iox86_2024-12-22:00:27:43-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:20-GMT-06:00 (~ 513 KB):
 401KiB 0:00:00 [1.61MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_3/l1_2@syncoid_iox86_2024-12-22:00:27:45-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:22-GMT-06:00 (~ 573 KB):
 405KiB 0:00:00 [1.77MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_3/l1_2/l2_0@syncoid_iox86_2024-12-22:00:27:46-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:24-GMT-06:00 (~ 706 KB):
 542KiB 0:00:00 [2.24MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_3/l1_2/l2_1@syncoid_iox86_2024-12-22:00:27:48-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:25-GMT-06:00 (~ 898 KB):
 660KiB 0:00:00 [2.48MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_3/l1_2/l2_2@syncoid_iox86_2024-12-22:00:27:50-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:27-GMT-06:00 (~ 854 KB):
 673KiB 0:00:00 [2.69MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_3/l1_2/l2_3@syncoid_iox86_2024-12-22:00:27:52-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:29-GMT-06:00 (~ 722 KB):
 542KiB 0:00:00 [2.18MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_3/l1_3@syncoid_iox86_2024-12-22:00:27:53-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:30-GMT-06:00 (~ 854 KB):
warning: cannot send 'send/test/l0_3/l1_3@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_3 does not
match incremental source
64.0KiB 0:00:00 [ 426KiB/s] [======>                                                                                             ]  7%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3'@'syncoid_iox86_2024-12-22:00:27:53-GMT-06:00' 'send/test/l0_3/l1_3'@'syncoid_iox86_2024-12-22:00:44:30-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 874800 |  zfs receive  -s -F 'recv/test/l0_3/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_3/l2_0@syncoid_iox86_2024-12-22:00:27:55-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:32-GMT-06:00 (~ 974 KB):
 669KiB 0:00:00 [2.70MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/l0_3/l1_3/l2_1@syncoid_iox86_2024-12-22:00:27:57-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:34-GMT-06:00 (~ 1.0 MB):
 800KiB 0:00:00 [3.16MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_3/l1_3/l2_2@syncoid_iox86_2024-12-22:00:27:59-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:36-GMT-06:00 (~ 497 KB):
 394KiB 0:00:00 [1.64MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-22:00:28:00-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:37-GMT-06:00 (~ 613 KB):
 508KiB 0:00:00 [2.03MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/x@syncoid_iox86_2024-12-22:00:28:02-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:39-GMT-06:00 (~ 4 KB):
2.13KiB 0:00:00 [24.6KiB/s] [====================================================>                                               ] 53%            
Sending incremental send/test/x/l0_0@syncoid_iox86_2024-12-22:00:28:03-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:40-GMT-06:00 (~ 722 KB):
 543KiB 0:00:00 [2.40MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/x/l0_0/l1_0@syncoid_iox86_2024-12-22:00:28:05-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:42-GMT-06:00 (~ 513 KB):
 405KiB 0:00:00 [1.66MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/x/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-22:00:28:07-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:44-GMT-06:00 (~ 573 KB):
 404KiB 0:00:00 [1.53MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/x/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-22:00:28:09-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:46-GMT-06:00 (~ 990 KB):
 670KiB 0:00:00 [2.64MiB/s] [==================================================================>                                 ] 67%            
Sending incremental send/test/x/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-22:00:28:11-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:48-GMT-06:00 (~ 589 KB):
 414KiB 0:00:00 [1.62MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/x/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-22:00:28:13-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:50-GMT-06:00 (~ 1.0 MB):
 803KiB 0:00:00 [2.91MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/x/l0_0/l1_1@syncoid_iox86_2024-12-22:00:28:15-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:52-GMT-06:00 (~ 1.0 MB):
 807KiB 0:00:00 [3.13MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/x/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-22:00:28:17-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:54-GMT-06:00 (~ 722 KB):
 544KiB 0:00:00 [2.00MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/x/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-22:00:28:19-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:56-GMT-06:00 (~ 1.3 MB):
1.03MiB 0:00:00 [3.80MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/x/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-22:00:28:21-GMT-06:00 ... syncoid_iox86_2024-12-22:00:44:58-GMT-06:00 (~ 589 KB):
 415KiB 0:00:00 [1.50MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/x/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-22:00:28:23-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:00-GMT-06:00 (~ 734 KB):
 507KiB 0:00:00 [1.93MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/x/l0_0/l1_2@syncoid_iox86_2024-12-22:00:28:25-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:02-GMT-06:00 (~ 381 KB):
 280KiB 0:00:00 [1.16MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/x/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-22:00:28:26-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:03-GMT-06:00 (~ 766 KB):
 538KiB 0:00:00 [1.93MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/x/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-22:00:28:28-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:05-GMT-06:00 (~ 722 KB):
 544KiB 0:00:00 [2.04MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/x/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-22:00:28:30-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:07-GMT-06:00 (~ 1.1 MB):
 805KiB 0:00:00 [2.90MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/x/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-22:00:28:32-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:09-GMT-06:00 (~ 529 KB):
warning: cannot send 'send/test/x/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-22:00:45:09-GMT-06:00': Input/output error
1.83KiB 0:00:00 [16.8KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-116b818df6-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c197191a320bbe55ce5200b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057e44fad583a65f5bee60424794eb07c5e626e2a0343716a5e8a3ed0a812fd0afd1c837803fd1cc37823fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d23232b03032b13532b034b5d77df105d0333201fe20600a3b52e30
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_0/l1_2/l2_3'@'syncoid_iox86_2024-12-22:00:28:32-GMT-06:00' 'send/test/x/l0_0/l1_2/l2_3'@'syncoid_iox86_2024-12-22:00:45:09-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 542656 |  zfs receive  -s -F 'recv/test/x/l0_0/l1_2/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_0/l1_3@syncoid_iox86_2024-12-22:00:28:34-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:11-GMT-06:00 (~ 573 KB):
 409KiB 0:00:00 [1.65MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/x/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-22:00:28:36-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:13-GMT-06:00 (~ 706 KB):
 533KiB 0:00:00 [1.96MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/x/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-22:00:28:38-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:15-GMT-06:00 (~ 513 KB):
 403KiB 0:00:00 [1.49MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/x/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-22:00:28:40-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:17-GMT-06:00 (~ 706 KB):
warning: cannot send 'send/test/x/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-22:00:45:17-GMT-06:00': Input/output error
1.83KiB 0:00:00 [17.0KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1260c6d50e-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081554570ddd4ff99dd0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a2d8657761988be144f4092e704cbe725e6a6323014a7e6a5e8038d2ad1afd0cf318837d0cf318c37d6cf318a377228aecc4bcecf4c89cfccafb0308b37323032d13534d23532b23230b03231b53234d775f70dd1353003f2216e0000e1302cd8
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_0/l1_3/l2_2'@'syncoid_iox86_2024-12-22:00:28:40-GMT-06:00' 'send/test/x/l0_0/l1_3/l2_2'@'syncoid_iox86_2024-12-22:00:45:17-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 723064 |  zfs receive  -s -F 'recv/test/x/l0_0/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-22:00:28:42-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:19-GMT-06:00 (~ 513 KB):
 404KiB 0:00:00 [1.47MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/x/l0_1@syncoid_iox86_2024-12-22:00:28:44-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:21-GMT-06:00 (~ 678 KB):
warning: cannot send 'send/test/x/l0_1@syncoid_iox86_2024-12-22:00:45:21-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [15.6KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/x/l0_1/l1_0@syncoid_iox86_2024-12-22:00:28:45-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:22-GMT-06:00 (~ 365 KB):
 269KiB 0:00:00 [1.04MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/x/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-22:00:28:47-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:24-GMT-06:00 (~ 513 KB):
 408KiB 0:00:00 [1.47MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/x/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-22:00:28:49-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:26-GMT-06:00 (~ 633 KB):
 402KiB 0:00:00 [1.51MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/x/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-22:00:28:51-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:28-GMT-06:00 (~ 766 KB):
 534KiB 0:00:00 [1.98MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/x/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-22:00:28:53-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:30-GMT-06:00 (~ 794 KB):
 668KiB 0:00:00 [2.31MiB/s] [===================================================================================>                ] 84%            
Sending incremental send/test/x/l0_1/l1_1@syncoid_iox86_2024-12-22:00:28:55-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:32-GMT-06:00 (~ 782 KB):
warning: cannot send 'send/test/x/l0_1/l1_1@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_1 does not
match incremental source
64.0KiB 0:00:00 [ 405KiB/s] [=======>                                                                                            ]  8%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_1'@'syncoid_iox86_2024-12-22:00:28:55-GMT-06:00' 'send/test/x/l0_1/l1_1'@'syncoid_iox86_2024-12-22:00:45:32-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 801072 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-22:00:28:57-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:34-GMT-06:00 (~ 541 KB):
 371KiB 0:00:00 [1.33MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/x/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-22:00:28:59-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:36-GMT-06:00 (~ 541 KB):
warning: cannot send 'send/test/x/l0_1/l1_1/l2_1@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_1/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 402KiB/s] [==========>                                                                                         ] 11%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_1/l2_1'@'syncoid_iox86_2024-12-22:00:28:59-GMT-06:00' 'send/test/x/l0_1/l1_1/l2_1'@'syncoid_iox86_2024-12-22:00:45:36-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 554944 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-22:00:29:01-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:38-GMT-06:00 (~ 381 KB):
warning: cannot send 'send/test/x/l0_1/l1_1/l2_2@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_1/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 404KiB/s] [===============>                                                                                    ] 16%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_1/l2_2'@'syncoid_iox86_2024-12-22:00:29:01-GMT-06:00' 'send/test/x/l0_1/l1_1/l2_2'@'syncoid_iox86_2024-12-22:00:45:38-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 390736 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-22:00:29:03-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:39-GMT-06:00 (~ 706 KB):
 534KiB 0:00:00 [1.89MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/x/l0_1/l1_2@syncoid_iox86_2024-12-22:00:29:05-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:41-GMT-06:00 (~ 589 KB):
warning: cannot send 'send/test/x/l0_1/l1_2@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_2 does not
match incremental source
64.0KiB 0:00:00 [ 399KiB/s] [=========>                                                                                          ] 10%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_2'@'syncoid_iox86_2024-12-22:00:29:05-GMT-06:00' 'send/test/x/l0_1/l1_2'@'syncoid_iox86_2024-12-22:00:45:41-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 604096 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-22:00:29:07-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:43-GMT-06:00 (~ 574 KB):
 404KiB 0:00:00 [1.17MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/x/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-22:00:29:09-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:45-GMT-06:00 (~ 987 KB):
warning: cannot send 'send/test/x/l0_1/l1_2/l2_1@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_2/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 322KiB/s] [=====>                                                                                              ]  6%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-22:00:29:09-GMT-06:00' 'send/test/x/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-22:00:45:45-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1010776 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-22:00:29:11-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:47-GMT-06:00 (~ 1.1 MB):
warning: cannot send 'send/test/x/l0_1/l1_2/l2_2@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_2/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 363KiB/s] [====>                                                                                               ]  5%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_2/l2_2'@'syncoid_iox86_2024-12-22:00:29:11-GMT-06:00' 'send/test/x/l0_1/l1_2/l2_2'@'syncoid_iox86_2024-12-22:00:45:47-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1150224 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_2/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-22:00:29:13-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:49-GMT-06:00 (~ 722 KB):
warning: cannot send 'send/test/x/l0_1/l1_2/l2_3@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_2/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 363KiB/s] [=======>                                                                                            ]  8%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_2/l2_3'@'syncoid_iox86_2024-12-22:00:29:13-GMT-06:00' 'send/test/x/l0_1/l1_2/l2_3'@'syncoid_iox86_2024-12-22:00:45:49-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 740072 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_2/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1/l1_3@syncoid_iox86_2024-12-22:00:29:15-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:51-GMT-06:00 (~ 810 KB):
warning: cannot send 'send/test/x/l0_1/l1_3@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_3 does not
match incremental source
64.0KiB 0:00:00 [ 357KiB/s] [======>                                                                                             ]  7%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_3'@'syncoid_iox86_2024-12-22:00:29:15-GMT-06:00' 'send/test/x/l0_1/l1_3'@'syncoid_iox86_2024-12-22:00:45:51-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 830368 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-22:00:29:17-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:52-GMT-06:00 (~ 782 KB):
warning: cannot send 'send/test/x/l0_1/l1_3/l2_0@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_3/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 360KiB/s] [=======>                                                                                            ]  8%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_3/l2_0'@'syncoid_iox86_2024-12-22:00:29:17-GMT-06:00' 'send/test/x/l0_1/l1_3/l2_0'@'syncoid_iox86_2024-12-22:00:45:52-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 801696 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-22:00:29:19-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:54-GMT-06:00 (~ 1.4 MB):
warning: cannot send 'send/test/x/l0_1/l1_3/l2_1@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_3/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 347KiB/s] [===>                                                                                                ]  4%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_3/l2_1'@'syncoid_iox86_2024-12-22:00:29:19-GMT-06:00' 'send/test/x/l0_1/l1_3/l2_1'@'syncoid_iox86_2024-12-22:00:45:54-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1466168 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-22:00:29:21-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:56-GMT-06:00 (~ 766 KB):
 536KiB 0:00:00 [1.80MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/x/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-22:00:29:23-GMT-06:00 ... syncoid_iox86_2024-12-22:00:45:58-GMT-06:00 (~ 558 KB):
warning: cannot send 'send/test/x/l0_1/l1_3/l2_3@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_3/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 365KiB/s] [==========>                                                                                         ] 11%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_3/l2_3'@'syncoid_iox86_2024-12-22:00:29:23-GMT-06:00' 'send/test/x/l0_1/l1_3/l2_3'@'syncoid_iox86_2024-12-22:00:45:58-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 571952 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_2@syncoid_iox86_2024-12-22:00:29:24-GMT-06:00 ... syncoid_iox86_2024-12-22:00:46:00-GMT-06:00 (~ 1.1 MB):
 802KiB 0:00:00 [3.07MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/x/l0_2/l1_0@syncoid_iox86_2024-12-22:00:29:26-GMT-06:00 ... syncoid_iox86_2024-12-22:00:46:01-GMT-06:00 (~ 174 KB):
 144KiB 0:00:00 [ 566KiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/x/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-22:00:29:28-GMT-06:00 ... syncoid_iox86_2024-12-22:00:46:04-GMT-06:00 (~ 646 KB):
 535KiB 0:00:00 [1.65MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/x/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-22:00:29:30-GMT-06:00 ... syncoid_iox86_2024-12-22:00:46:06-GMT-06:00 (~ 1003 KB):
warning: cannot send 'send/test/x/l0_2/l1_0/l2_1@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_2/l1_0/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 337KiB/s] [=====>                                                                                              ]  6%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_2/l1_0/l2_1'@'syncoid_iox86_2024-12-22:00:29:30-GMT-06:00' 'send/test/x/l0_2/l1_0/l2_1'@'syncoid_iox86_2024-12-22:00:46:06-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1027160 |  zfs receive  -s -F 'recv/test/x/l0_2/l1_0/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-22:00:29:32-GMT-06:00 ... syncoid_iox86_2024-12-22:00:46:08-GMT-06:00 (~ 838 KB):
warning: cannot send 'send/test/x/l0_2/l1_0/l2_2@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_2/l1_0/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 357KiB/s] [======>                                                                                             ]  7%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_2/l1_0/l2_2'@'syncoid_iox86_2024-12-22:00:29:32-GMT-06:00' 'send/test/x/l0_2/l1_0/l2_2'@'syncoid_iox86_2024-12-22:00:46:08-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 859040 |  zfs receive  -s -F 'recv/test/x/l0_2/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-22:00:29:34-GMT-06:00 ... syncoid_iox86_2024-12-22:00:46:09-GMT-06:00 (~ 722 KB):
warning: cannot send 'send/test/x/l0_2/l1_0/l2_3@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_2/l1_0/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 357KiB/s] [=======>                                                                                            ]  8%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_2/l1_0/l2_3'@'syncoid_iox86_2024-12-22:00:29:34-GMT-06:00' 'send/test/x/l0_2/l1_0/l2_3'@'syncoid_iox86_2024-12-22:00:46:09-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 740072 |  zfs receive  -s -F 'recv/test/x/l0_2/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_2/l1_1@syncoid_iox86_2024-12-22:00:29:36-GMT-06:00 ... syncoid_iox86_2024-12-22:00:46:11-GMT-06:00 (~ 915 KB):
 673KiB 0:00:00 [2.22MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/x/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-22:00:29:38-GMT-06:00 ... syncoid_iox86_2024-12-22:00:46:13-GMT-06:00 (~ 514 KB):
 403KiB 0:00:00 [1.37MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/x/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-22:00:29:40-GMT-06:00 ... syncoid_iox86_2024-12-22:00:46:15-GMT-06:00 (~ 915 KB):
warning: cannot send 'send/test/x/l0_2/l1_1/l2_1@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_2/l1_1/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 347KiB/s] [=====>                                                                                              ]  6%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_2/l1_1/l2_1'@'syncoid_iox86_2024-12-22:00:29:40-GMT-06:00' 'send/test/x/l0_2/l1_1/l2_1'@'syncoid_iox86_2024-12-22:00:46:15-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 937048 |  zfs receive  -s -F 'recv/test/x/l0_2/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-22:00:29:42-GMT-06:00 ... syncoid_iox86_2024-12-22:00:46:17-GMT-06:00 (~ 602 KB):
warning: cannot send 'send/test/x/l0_2/l1_1/l2_2@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_2/l1_1/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 345KiB/s] [=========>                                                                                          ] 10%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_2/l1_1/l2_2'@'syncoid_iox86_2024-12-22:00:29:42-GMT-06:00' 'send/test/x/l0_2/l1_1/l2_2'@'syncoid_iox86_2024-12-22:00:46:17-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 617008 |  zfs receive  -s -F 'recv/test/x/l0_2/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-22:00:29:44-GMT-06:00 ... syncoid_iox86_2024-12-22:00:46:19-GMT-06:00 (~ 514 KB):
warning: cannot send 'send/test/x/l0_2/l1_1/l2_3@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_2/l1_1/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 367KiB/s] [===========>                                                                                        ] 12%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_2/l1_1/l2_3'@'syncoid_iox86_2024-12-22:00:29:44-GMT-06:00' 'send/test/x/l0_2/l1_1/l2_3'@'syncoid_iox86_2024-12-22:00:46:19-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 526896 |  zfs receive  -s -F 'recv/test/x/l0_2/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_2/l1_2@syncoid_iox86_2024-12-22:00:29:46-GMT-06:00 ... syncoid_iox86_2024-12-22:00:46:20-GMT-06:00 (~ 174 KB):
 137KiB 0:00:00 [ 509KiB/s] [=============================================================================>                      ] 78%            
real 244.82
user 26.20
sys 189.15
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

errors: 38 data errors, use '-v' for a list

Sending incremental send/test@syncoid_iox86_2024-12-22:00:42:18-GMT-06:00 ... syncoid_iox86_2024-12-22:00:58:52-GMT-06:00 (~ 4 KB):
2.13KiB 0:00:00 [27.1KiB/s] [====================================================>                                               ] 53%            
Sending incremental send/test/l0_0@syncoid_iox86_2024-12-22:00:42:19-GMT-06:00 ... syncoid_iox86_2024-12-22:00:58:54-GMT-06:00 (~ 914 KB):
 670KiB 0:00:00 [3.18MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_0/l1_0@syncoid_iox86_2024-12-22:00:42:20-GMT-06:00 ... syncoid_iox86_2024-12-22:00:58:55-GMT-06:00 (~ 589 KB):
warning: cannot send 'send/test/l0_0/l1_0@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_0 does not
match incremental source
64.0KiB 0:00:00 [ 457KiB/s] [=========>                                                                                          ] 10%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0'@'syncoid_iox86_2024-12-22:00:42:20-GMT-06:00' 'send/test/l0_0/l1_0'@'syncoid_iox86_2024-12-22:00:58:55-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 604096 |  zfs receive  -s -F 'recv/test/l0_0/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-22:00:42:22-GMT-06:00 ... syncoid_iox86_2024-12-22:00:58:57-GMT-06:00 (~ 914 KB):
 667KiB 0:00:00 [2.64MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-22:00:42:24-GMT-06:00 ... syncoid_iox86_2024-12-22:00:58:58-GMT-06:00 (~ 381 KB):
 275KiB 0:00:00 [1.06MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-22:00:42:25-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:00-GMT-06:00 (~ 513 KB):
 409KiB 0:00:00 [1.60MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-22:00:42:27-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:02-GMT-06:00 (~ 782 KB):
 541KiB 0:00:00 [2.19MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_0/l1_1@syncoid_iox86_2024-12-22:00:42:29-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:03-GMT-06:00 (~ 381 KB):
 276KiB 0:00:00 [1.26MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-22:00:42:30-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:05-GMT-06:00 (~ 854 KB):
 672KiB 0:00:00 [2.51MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-22:00:42:32-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:07-GMT-06:00 (~ 662 KB):
 539KiB 0:00:00 [2.05MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-22:00:42:34-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:09-GMT-06:00 (~ 1.0 MB):
 789KiB 0:00:00 [3.25MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-22:00:42:36-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:10-GMT-06:00 (~ 650 KB):
 412KiB 0:00:00 [1.72MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_0/l1_2@syncoid_iox86_2024-12-22:00:42:37-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:12-GMT-06:00 (~ 529 KB):
warning: cannot send 'send/test/l0_0/l1_2@syncoid_iox86_2024-12-22:00:59:12-GMT-06:00': Invalid argument
1.52KiB 0:00:00 [15.4KiB/s] [>                                                                                                   ]  0%            
Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-22:00:42:39-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:14-GMT-06:00 (~ 986 KB):
 795KiB 0:00:00 [3.09MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-22:00:42:41-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:15-GMT-06:00 (~ 722 KB):
warning: cannot send 'send/test/l0_0/l1_2/l2_1@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_2/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 413KiB/s] [=======>                                                                                            ]  8%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_1'@'syncoid_iox86_2024-12-22:00:42:41-GMT-06:00' 'send/test/l0_0/l1_2/l2_1'@'syncoid_iox86_2024-12-22:00:59:15-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 739448 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-22:00:42:42-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:17-GMT-06:00 (~ 421 KB):
 371KiB 0:00:00 [1.52MiB/s] [=======================================================================================>            ] 88%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-22:00:42:44-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:19-GMT-06:00 (~ 854 KB):
warning: cannot send 'send/test/l0_0/l1_2/l2_3@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_2/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 411KiB/s] [======>                                                                                             ]  7%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_3'@'syncoid_iox86_2024-12-22:00:42:44-GMT-06:00' 'send/test/l0_0/l1_2/l2_3'@'syncoid_iox86_2024-12-22:00:59:19-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 874800 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_3@syncoid_iox86_2024-12-22:00:42:46-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:20-GMT-06:00 (~ 1.1 MB):
 796KiB 0:00:00 [3.40MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-22:00:42:47-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:22-GMT-06:00 (~ 898 KB):
 661KiB 0:00:00 [2.73MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-22:00:42:49-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:23-GMT-06:00 (~ 662 KB):
 538KiB 0:00:00 [2.18MiB/s] [================================================================================>                   ] 81%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-22:00:42:51-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:25-GMT-06:00 (~ 1.2 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_2@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_3/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 410KiB/s] [====>                                                                                               ]  5%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_2'@'syncoid_iox86_2024-12-22:00:42:51-GMT-06:00' 'send/test/l0_0/l1_3/l2_2'@'syncoid_iox86_2024-12-22:00:59:25-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1211224 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_0/l1_3/l2_3 to recv/test/l0_0/l1_3/l2_3 (~ 781 KB remaining):
internal error: warning: cannot send 'send/test/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-22:00:42:52-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-109661217d-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081e0c18af89b7cbd8715806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4154629df189a58fed72620c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61bebe718c51b3b1457e625e767a6c467e6575898c51b191899e81a1ae91a1959191858991859991ae9bafb86e81a9801f9303700009aaa2bd9 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 800448 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1@syncoid_iox86_2024-12-22:00:42:54-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:27-GMT-06:00 (~ 1.4 MB):
warning: cannot send 'send/test/l0_1@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1 does not
match incremental source
64.0KiB 0:00:00 [ 411KiB/s] [===>                                                                                                ]  4%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1'@'syncoid_iox86_2024-12-22:00:42:54-GMT-06:00' 'send/test/l0_1'@'syncoid_iox86_2024-12-22:00:59:27-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1477832 |  zfs receive  -s -F 'recv/test/l0_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_0@syncoid_iox86_2024-12-22:00:42:55-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:28-GMT-06:00 (~ 513 KB):
warning: cannot send 'send/test/l0_1/l1_0@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_0 does not
match incremental source
64.0KiB 0:00:00 [ 445KiB/s] [===========>                                                                                        ] 12%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0'@'syncoid_iox86_2024-12-22:00:42:55-GMT-06:00' 'send/test/l0_1/l1_0'@'syncoid_iox86_2024-12-22:00:59:28-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 526272 |  zfs receive  -s -F 'recv/test/l0_1/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-22:00:42:57-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:29-GMT-06:00 (~ 674 KB):
 511KiB 0:00:00 [2.06MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-22:00:42:59-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:31-GMT-06:00 (~ 381 KB):
warning: cannot send 'send/test/l0_1/l1_0/l2_1@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_0/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 412KiB/s] [===============>                                                                                    ] 16%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_1'@'syncoid_iox86_2024-12-22:00:42:59-GMT-06:00' 'send/test/l0_1/l1_0/l2_1'@'syncoid_iox86_2024-12-22:00:59:31-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 390736 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-22:00:43:01-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:33-GMT-06:00 (~ 722 KB):
warning: cannot send 'send/test/l0_1/l1_0/l2_2@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_0/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 415KiB/s] [=======>                                                                                            ]  8%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_2'@'syncoid_iox86_2024-12-22:00:43:01-GMT-06:00' 'send/test/l0_1/l1_0/l2_2'@'syncoid_iox86_2024-12-22:00:59:33-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 739448 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-22:00:43:02-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:34-GMT-06:00 (~ 838 KB):
 662KiB 0:00:00 [2.52MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_1/l1_1@autosnap_2024-12-22_06:30:38_frequently ... syncoid_iox86_2024-12-22:00:59:36-GMT-06:00 (~ 1.3 MB):
warning: cannot send 'send/test/l0_1/l1_1@syncoid_iox86_2024-12-22:00:43:04-GMT-06:00': Invalid argument
warning: cannot send 'send/test/l0_1/l1_1@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_1 does not
match incremental source
64.0KiB 0:00:00 [ 417KiB/s] [===>                                                                                                ]  4%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1'@'autosnap_2024-12-22_06:30:38_frequently' 'send/test/l0_1/l1_1'@'syncoid_iox86_2024-12-22:00:59:36-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1343104 |  zfs receive  -s -F 'recv/test/l0_1/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_1/l2_0 to recv/test/l0_1/l1_1/l2_0 (~ 1.2 MB remaining):
internal error: warning: cannot send 'send/test/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-22:00:43:05-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-120ee40736-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1a98a3b06eb9f3bfd5600b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f910573c488b5ce910a3529b8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa89f6308228ce20d1c8a2bf392f33353e233f32b2ccce28d0c8c4c740d8d748d8cac0c0cac4c8cad0c4c75dd7d43740dcc807c981b00be522d0c | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1235176 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-22:00:43:07-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:38-GMT-06:00 (~ 1.0 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_1@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_1/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 399KiB/s] [=====>                                                                                              ]  6%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_1'@'syncoid_iox86_2024-12-22:00:43:07-GMT-06:00' 'send/test/l0_1/l1_1/l2_1'@'syncoid_iox86_2024-12-22:00:59:38-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1055392 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1/l2_2@autosnap_2024-12-22_06:30:38_frequently ... syncoid_iox86_2024-12-22:00:59:39-GMT-06:00 (~ 1.8 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-22:00:43:09-GMT-06:00': Invalid argument
warning: cannot send 'send/test/l0_1/l1_1/l2_2@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_1/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 374KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_2'@'autosnap_2024-12-22_06:30:38_frequently' 'send/test/l0_1/l1_1/l2_2'@'syncoid_iox86_2024-12-22:00:59:39-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1929568 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1/l2_3@autosnap_2024-12-22_06:30:38_frequently ... syncoid_iox86_2024-12-22:00:59:41-GMT-06:00 (~ 1.2 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-22:00:43:11-GMT-06:00': Invalid argument
warning: cannot send 'send/test/l0_1/l1_1/l2_3@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_1/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 380KiB/s] [====>                                                                                               ]  5%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_3'@'autosnap_2024-12-22_06:30:38_frequently' 'send/test/l0_1/l1_1/l2_3'@'syncoid_iox86_2024-12-22:00:59:41-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1215760 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2@syncoid_iox86_2024-12-22:00:43:12-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:42-GMT-06:00 (~ 674 KB):
 509KiB 0:00:00 [2.25MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-22:00:43:14-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:44-GMT-06:00 (~ 706 KB):
warning: cannot send 'send/test/l0_1/l1_2/l2_0@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_2/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 415KiB/s] [========>                                                                                           ]  9%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_0'@'syncoid_iox86_2024-12-22:00:43:14-GMT-06:00' 'send/test/l0_1/l1_2/l2_0'@'syncoid_iox86_2024-12-22:00:59:44-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 723064 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-22:00:43:16-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:46-GMT-06:00 (~ 722 KB):
warning: cannot send 'send/test/l0_1/l1_2/l2_1@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_2/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 421KiB/s] [=======>                                                                                            ]  8%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-22:00:43:16-GMT-06:00' 'send/test/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-22:00:59:46-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 739448 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_2/l2_2@autosnap_2024-12-22_06:30:38_frequently ... syncoid_iox86_2024-12-22:00:59:47-GMT-06:00 (~ 1.1 MB):
warning: cannot send 'send/test/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-22:00:43:17-GMT-06:00': Invalid argument
warning: cannot send 'send/test/l0_1/l1_2/l2_2@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_2/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 377KiB/s] [====>                                                                                               ]  5%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_2'@'autosnap_2024-12-22_06:30:38_frequently' 'send/test/l0_1/l1_2/l2_2'@'syncoid_iox86_2024-12-22:00:59:47-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1187088 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_1/l1_2/l2_3 to recv/test/l0_1/l1_2/l2_3 (~ 837 KB remaining):
internal error: warning: cannot send 'send/test/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-22:00:43:19-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-11c63263b1-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c169b9235227aeff3aa20064b323a9cb4fca4a4d2e81f04100433e2dad38b584010e40f26c48f2499525a9c50ca8f2c8fa4bf221ae5822ccbfeb869b847602923c27583e2f31379581a138352f451f6854897e8e41bca17e8e61bc917e8e51bcb14371655e727e664a7c667e858559bc91819189aea191ae91919581819589b195a1a5aebb6f88ae8119900f7303007c502c74 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 857792 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_1/l1_3@syncoid_iox86_2024-12-22:00:43:20-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:49-GMT-06:00 (~ 497 KB):
warning: cannot send 'send/test/l0_1/l1_3@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_3 does not
match incremental source
64.0KiB 0:00:00 [ 426KiB/s] [===========>                                                                                        ] 12%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_3'@'syncoid_iox86_2024-12-22:00:43:20-GMT-06:00' 'send/test/l0_1/l1_3'@'syncoid_iox86_2024-12-22:00:59:49-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 509704 |  zfs receive  -s -F 'recv/test/l0_1/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-22:00:43:22-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:50-GMT-06:00 (~ 573 KB):
warning: cannot send 'send/test/l0_1/l1_3/l2_0@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_3/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 431KiB/s] [==========>                                                                                         ] 11%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_3/l2_0'@'syncoid_iox86_2024-12-22:00:43:22-GMT-06:00' 'send/test/l0_1/l1_3/l2_0'@'syncoid_iox86_2024-12-22:00:59:50-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 587712 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-22:00:43:24-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:52-GMT-06:00 (~ 497 KB):
warning: cannot send 'send/test/l0_1/l1_3/l2_1@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_3/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 406KiB/s] [===========>                                                                                        ] 12%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_3/l2_1'@'syncoid_iox86_2024-12-22:00:43:24-GMT-06:00' 'send/test/l0_1/l1_3/l2_1'@'syncoid_iox86_2024-12-22:00:59:52-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 509704 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-22:00:43:26-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:53-GMT-06:00 (~ 513 KB):
warning: cannot send 'send/test/l0_1/l1_3/l2_2@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_3/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 411KiB/s] [===========>                                                                                        ] 12%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_3/l2_2'@'syncoid_iox86_2024-12-22:00:43:26-GMT-06:00' 'send/test/l0_1/l1_3/l2_2'@'syncoid_iox86_2024-12-22:00:59:53-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 526272 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-22:00:43:27-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:55-GMT-06:00 (~ 810 KB):
warning: cannot send 'send/test/l0_1/l1_3/l2_3@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_3/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 407KiB/s] [======>                                                                                             ]  7%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_3/l2_3'@'syncoid_iox86_2024-12-22:00:43:27-GMT-06:00' 'send/test/l0_1/l1_3/l2_3'@'syncoid_iox86_2024-12-22:00:59:55-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 829744 |  zfs receive  -s -F 'recv/test/l0_1/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2@syncoid_iox86_2024-12-22:00:43:29-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:56-GMT-06:00 (~ 305 KB):
warning: cannot send 'send/test/l0_2@syncoid_iox86_2024-12-22:00:59:56-GMT-06:00': Input/output error
1.83KiB 0:00:00 [19.5KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-10a5401082-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c197d365821293f8a514806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec4157aa73bec92ffef9b168124cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fe4505c99979c9f99129f995f6161166f646064a26b68a46b6464656060656a69656aa6ebee1ba26b6006e423ec0600d6302942
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2'@'syncoid_iox86_2024-12-22:00:43:29-GMT-06:00' 'send/test/l0_2'@'syncoid_iox86_2024-12-22:00:59:56-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 312912 |  zfs receive  -s -F 'recv/test/l0_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_0@syncoid_iox86_2024-12-22:00:43:30-GMT-06:00 ... syncoid_iox86_2024-12-22:00:59:58-GMT-06:00 (~ 1.0 MB):
 795KiB 0:00:00 [3.55MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-22:00:43:32-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:00-GMT-06:00 (~ 858 KB):
 549KiB 0:00:00 [2.35MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-22:00:43:34-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:01-GMT-06:00 (~ 782 KB):
 542KiB 0:00:00 [2.14MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-22:00:43:36-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:03-GMT-06:00 (~ 646 KB):
 537KiB 0:00:00 [2.21MiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-22:00:43:38-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:05-GMT-06:00 (~ 633 KB):
 407KiB 0:00:00 [1.62MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_2/l1_1@syncoid_iox86_2024-12-22:00:43:39-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:07-GMT-06:00 (~ 854 KB):
 671KiB 0:00:00 [2.90MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-22:00:43:41-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:08-GMT-06:00 (~ 690 KB):
 528KiB 0:00:00 [1.86MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-22:00:43:43-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:10-GMT-06:00 (~ 498 KB):
 401KiB 0:00:00 [1.41MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_2/l1_1/l2_2@autosnap_2024-12-22_06:30:38_frequently ... syncoid_iox86_2024-12-22:01:00:12-GMT-06:00 (~ 1.1 MB):
warning: cannot send 'send/test/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-22:00:43:44-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_1/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 338KiB/s] [====>                                                                                               ]  5%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_1/l2_2'@'autosnap_2024-12-22_06:30:38_frequently' 'send/test/l0_2/l1_1/l2_2'@'syncoid_iox86_2024-12-22:01:00:12-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1204904 |  zfs receive  -s -F 'recv/test/l0_2/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-22:00:43:46-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:14-GMT-06:00 (~ 591 KB):
 416KiB 0:00:00 [1.45MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_2/l1_2@autosnap_2024-12-22_06:30:38_frequently ... syncoid_iox86_2024-12-22:01:00:16-GMT-06:00 (~ 1.1 MB):
warning: cannot send 'send/test/l0_2/l1_2@syncoid_iox86_2024-12-22:00:43:48-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_2 does not
match incremental source
64.0KiB 0:00:00 [ 389KiB/s] [====>                                                                                               ]  5%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_2'@'autosnap_2024-12-22_06:30:38_frequently' 'send/test/l0_2/l1_2'@'syncoid_iox86_2024-12-22:01:00:16-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1192432 |  zfs receive  -s -F 'recv/test/l0_2/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_2/l2_0@syncoid_iox86_2024-12-22:00:43:49-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:18-GMT-06:00 (~ 767 KB):
warning: cannot send 'send/test/l0_2/l1_2/l2_0@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
warning: cannot send 'send/test/l0_2/l1_2/l2_0@autosnap_2024-12-22_07:00:08_hourly': Invalid argument
2.13KiB 0:00:00 [17.0KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_2/l2_0 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_2/l2_0'@'syncoid_iox86_2024-12-22:00:43:49-GMT-06:00' 'send/test/l0_2/l1_2/l2_0'@'syncoid_iox86_2024-12-22:01:00:18-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 785752 |  zfs receive  -s -F 'recv/test/l0_2/l1_2/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_2/l2_1@syncoid_iox86_2024-12-22:00:43:51-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:19-GMT-06:00 (~ 739 KB):
warning: cannot send 'send/test/l0_2/l1_2/l2_1@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
warning: cannot send 'send/test/l0_2/l1_2/l2_1@autosnap_2024-12-22_07:00:08_hourly': Invalid argument
2.13KiB 0:00:00 [17.2KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_2/l2_1 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_2/l2_1'@'syncoid_iox86_2024-12-22:00:43:51-GMT-06:00' 'send/test/l0_2/l1_2/l2_1'@'syncoid_iox86_2024-12-22:01:00:19-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 757080 |  zfs receive  -s -F 'recv/test/l0_2/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_2/l1_2/l2_2 to recv/test/l0_2/l1_2/l2_2 (~ 913 KB remaining):
warning: cannot send 'send/test/l0_2/l1_2/l2_2@syncoid_iox86_2024-12-22:00:43:53-GMT-06:00': Input/output error
 408 B 0:00:00 [2.73KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-12f5e0b927-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041e80c4ed68712ff2f2b00d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b26f704063f88db129c8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f6308228ce28d1c8a2bf392f33353e233f32b2ccce28d0c8c4c740d8d748d8cac0c0cac4c8cad4c8d75dd7d43740dcc807c981b00b4e02c3b
CRITICAL ERROR:  zfs send  -t 1-12f5e0b927-118-789c636064000310a501c49c50360710a715e5e7a69766a6304041e80c4ed68712ff2f2b00d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882b26f704063f88db129c8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa49f6308228ce28d1c8a2bf392f33353e233f32b2ccce28d0c8c4c740d8d748d8cac0c0cac4c8cad4c8d75dd7d43740dcc807c981b00b4e02c3b | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 935800 |  zfs receive  -s -F 'recv/test/l0_2/l1_2/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_2/l2_3@syncoid_iox86_2024-12-22:00:43:55-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:21-GMT-06:00 (~ 679 KB):
warning: cannot send 'send/test/l0_2/l1_2/l2_3@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
warning: cannot send 'send/test/l0_2/l1_2/l2_3@autosnap_2024-12-22_07:00:08_hourly': Invalid argument
2.13KiB 0:00:00 [18.3KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_2/l2_3 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_2/l2_3'@'syncoid_iox86_2024-12-22:00:43:55-GMT-06:00' 'send/test/l0_2/l1_2/l2_3'@'syncoid_iox86_2024-12-22:01:00:21-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 695640 |  zfs receive  -s -F 'recv/test/l0_2/l1_2/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_3@autosnap_2024-12-22_06:30:38_frequently ... syncoid_iox86_2024-12-22:01:00:23-GMT-06:00 (~ 1.4 MB):
warning: cannot send 'send/test/l0_2/l1_3@syncoid_iox86_2024-12-22:00:43:56-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_3 does not
match incremental source
64.0KiB 0:00:00 [ 371KiB/s] [===>                                                                                                ]  4%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3'@'autosnap_2024-12-22_06:30:38_frequently' 'send/test/l0_2/l1_3'@'syncoid_iox86_2024-12-22:01:00:23-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1450848 |  zfs receive  -s -F 'recv/test/l0_2/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_3/l2_0@syncoid_iox86_2024-12-22:00:43:58-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:24-GMT-06:00 (~ 575 KB):
warning: cannot send 'send/test/l0_2/l1_3/l2_0@autosnap_2024-12-22_07:00:08_hourly': Input/output error
3.05KiB 0:00:00 [26.3KiB/s] [>                                                                                                   ]  0%            
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_0'@'syncoid_iox86_2024-12-22:00:43:58-GMT-06:00' 'send/test/l0_2/l1_3/l2_0'@'syncoid_iox86_2024-12-22:01:00:24-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 588960 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_2/l1_3/l2_1@syncoid_iox86_2024-12-22:00:44:00-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:26-GMT-06:00 (~ 855 KB):
 668KiB 0:00:00 [2.28MiB/s] [=============================================================================>                      ] 78%            
Resuming interrupted zfs send/receive from send/test/l0_2/l1_3/l2_2 to recv/test/l0_2/l1_3/l2_2 (~ 721 KB remaining):
internal error: warning: cannot send 'send/test/l0_2/l1_3/l2_2@syncoid_iox86_2024-12-22:00:27:22-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-10a0ab0a75-118-789c636064000310a501c49c50360710a715e5e7a69766a630408108d3b7afbf0eeb3c5300b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f910574cdca1b55bfe11934202923c27583e2f31379581a138352f451f6854897e8e41bc917e8e61bcb17e8e51bc914371655e727e664a7c667e858559bc91819189aea191ae91919581819591b9959191aebb6f88ae8119900f7303005e912c8d | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 738824 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_2/l1_3/l2_3@autosnap_2024-12-22_06:30:38_frequently ... syncoid_iox86_2024-12-22:01:00:29-GMT-06:00 (~ 1012 KB):
warning: cannot send 'send/test/l0_2/l1_3/l2_3@syncoid_iox86_2024-12-22:00:44:02-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_2/l1_3/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 350KiB/s] [=====>                                                                                              ]  6%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_2/l1_3/l2_3'@'autosnap_2024-12-22_06:30:38_frequently' 'send/test/l0_2/l1_3/l2_3'@'syncoid_iox86_2024-12-22:01:00:29-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1036600 |  zfs receive  -s -F 'recv/test/l0_2/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Resuming interrupted zfs send/receive from send/test/l0_3 to recv/test/l0_3 (~ 304 KB remaining):
internal error: warning: cannot send 'send/test/l0_3@syncoid_iox86_2024-12-22:00:44:03-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-10a45913a1-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1e6871289a67a9d4b15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415bfaf499b27739d5b158124cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fec505c99979c9f99129f995f6161166f646064a26b68a46b64646560606562626560acebee1ba26b6006e423ec06002066294d | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 312288 |  zfs receive  -s -F 'recv/test/l0_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/l0_3/l1_0@autosnap_2024-12-22_06:30:38_frequently ... syncoid_iox86_2024-12-22:01:00:30-GMT-06:00 (~ 1.3 MB):
warning: cannot send 'send/test/l0_3/l1_0@syncoid_iox86_2024-12-22:00:44:05-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_0 does not
match incremental source
64.0KiB 0:00:00 [ 350KiB/s] [===>                                                                                                ]  4%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_0'@'autosnap_2024-12-22_06:30:38_frequently' 'send/test/l0_3/l1_0'@'syncoid_iox86_2024-12-22:01:00:30-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1413984 |  zfs receive  -s -F 'recv/test/l0_3/l1_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_0/l2_0@autosnap_2024-12-22_06:30:38_frequently ... syncoid_iox86_2024-12-22:01:00:32-GMT-06:00 (~ 1.8 MB):
warning: cannot send 'send/test/l0_3/l1_0/l2_0@syncoid_iox86_2024-12-22:00:44:06-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_0/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 340KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_0/l2_0'@'autosnap_2024-12-22_06:30:38_frequently' 'send/test/l0_3/l1_0/l2_0'@'syncoid_iox86_2024-12-22:01:00:32-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1885760 |  zfs receive  -s -F 'recv/test/l0_3/l1_0/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_0/l2_1@syncoid_iox86_2024-12-22:00:44:08-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:34-GMT-06:00 (~ 587 KB):
 534KiB 0:00:00 [1.87MiB/s] [==========================================================================================>         ] 91%            
Sending incremental send/test/l0_3/l1_0/l2_2@syncoid_iox86_2024-12-22:00:44:10-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:36-GMT-06:00 (~ 1.0 MB):
 671KiB 0:00:00 [2.39MiB/s] [===============================================================>                                    ] 64%            
Sending incremental send/test/l0_3/l1_0/l2_3@syncoid_iox86_2024-12-22:00:44:12-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:38-GMT-06:00 (~ 931 KB):
 678KiB 0:00:00 [2.43MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_3/l1_1@syncoid_iox86_2024-12-22:00:44:13-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:40-GMT-06:00 (~ 691 KB):
 524KiB 0:00:00 [2.09MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/l0_3/l1_1/l2_0@syncoid_iox86_2024-12-22:00:44:15-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:42-GMT-06:00 (~ 306 KB):
 266KiB 0:00:00 [1007KiB/s] [=====================================================================================>              ] 86%            
Sending incremental send/test/l0_3/l1_1/l2_1@syncoid_iox86_2024-12-22:00:44:17-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:44-GMT-06:00 (~ 426 KB):
 269KiB 0:00:00 [ 999KiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/l0_3/l1_1/l2_2@syncoid_iox86_2024-12-22:00:44:18-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:46-GMT-06:00 (~ 575 KB):
 407KiB 0:00:00 [1.54MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/l0_3/l1_1/l2_3@syncoid_iox86_2024-12-22:00:44:20-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:48-GMT-06:00 (~ 422 KB):
 378KiB 0:00:00 [1.30MiB/s] [========================================================================================>           ] 89%            
Sending incremental send/test/l0_3/l1_2@syncoid_iox86_2024-12-22:00:44:22-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:50-GMT-06:00 (~ 1003 KB):
 809KiB 0:00:00 [2.74MiB/s] [===============================================================================>                    ] 80%            
Sending incremental send/test/l0_3/l1_2/l2_0@syncoid_iox86_2024-12-22:00:44:24-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:52-GMT-06:00 (~ 839 KB):
 667KiB 0:00:00 [2.19MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/l0_3/l1_2/l2_1@syncoid_iox86_2024-12-22:00:44:25-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:54-GMT-06:00 (~ 306 KB):
 273KiB 0:00:00 [ 981KiB/s] [========================================================================================>           ] 89%            
Sending incremental send/test/l0_3/l1_2/l2_2@syncoid_iox86_2024-12-22:00:44:27-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:56-GMT-06:00 (~ 723 KB):
 536KiB 0:00:00 [1.82MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_3/l1_2/l2_3@syncoid_iox86_2024-12-22:00:44:29-GMT-06:00 ... syncoid_iox86_2024-12-22:01:00:58-GMT-06:00 (~ 691 KB):
 511KiB 0:00:00 [1.77MiB/s] [=========================================================================>                          ] 74%            
Sending incremental send/test/l0_3/l1_3@syncoid_iox86_2024-12-22:00:27:53-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:00-GMT-06:00 (~ 1.7 MB):
warning: cannot send 'send/test/l0_3/l1_3@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_3/l1_3 does not
match incremental source
64.0KiB 0:00:00 [ 374KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/l0_3/l1_3'@'syncoid_iox86_2024-12-22:00:27:53-GMT-06:00' 'send/test/l0_3/l1_3'@'syncoid_iox86_2024-12-22:01:01:00-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1812472 |  zfs receive  -s -F 'recv/test/l0_3/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_3/l1_3/l2_0@syncoid_iox86_2024-12-22:00:44:32-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:02-GMT-06:00 (~ 959 KB):
 668KiB 0:00:00 [2.19MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/l0_3/l1_3/l2_1@syncoid_iox86_2024-12-22:00:44:34-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:04-GMT-06:00 (~ 575 KB):
 409KiB 0:00:00 [1.46MiB/s] [======================================================================>                             ] 71%            
Sending incremental send/test/l0_3/l1_3/l2_2@syncoid_iox86_2024-12-22:00:44:36-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:06-GMT-06:00 (~ 931 KB):
 678KiB 0:00:00 [2.34MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/l0_3/l1_3/l2_3@syncoid_iox86_2024-12-22:00:44:37-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:08-GMT-06:00 (~ 975 KB):
 673KiB 0:00:00 [2.32MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/x@syncoid_iox86_2024-12-22:00:44:39-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:10-GMT-06:00 (~ 4 KB):
3.35KiB 0:00:00 [34.4KiB/s] [==================================================================================>                 ] 83%            
Sending incremental send/test/x/l0_0@syncoid_iox86_2024-12-22:00:44:40-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:11-GMT-06:00 (~ 811 KB):
warning: cannot send 'send/test/x/l0_0@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_0 does not
match incremental source
64.0KiB 0:00:00 [ 373KiB/s] [======>                                                                                             ]  7%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_0'@'syncoid_iox86_2024-12-22:00:44:40-GMT-06:00' 'send/test/x/l0_0'@'syncoid_iox86_2024-12-22:01:01:11-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 830992 |  zfs receive  -s -F 'recv/test/x/l0_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_0/l1_0@syncoid_iox86_2024-12-22:00:44:42-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:13-GMT-06:00 (~ 366 KB):
 269KiB 0:00:00 [ 984KiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/x/l0_0/l1_0/l2_0@syncoid_iox86_2024-12-22:00:44:44-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:15-GMT-06:00 (~ 663 KB):
warning: cannot send 'send/test/x/l0_0/l1_0/l2_0@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_0/l1_0/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 334KiB/s] [========>                                                                                           ]  9%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_0/l1_0/l2_0'@'syncoid_iox86_2024-12-22:00:44:44-GMT-06:00' 'send/test/x/l0_0/l1_0/l2_0'@'syncoid_iox86_2024-12-22:01:01:15-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 679256 |  zfs receive  -s -F 'recv/test/x/l0_0/l1_0/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_0/l1_0/l2_1@syncoid_iox86_2024-12-22:00:44:46-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:17-GMT-06:00 (~ 591 KB):
 404KiB 0:00:00 [1.31MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/x/l0_0/l1_0/l2_2@syncoid_iox86_2024-12-22:00:44:48-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:19-GMT-06:00 (~ 470 KB):
 412KiB 0:00:00 [1.34MiB/s] [======================================================================================>             ] 87%            
Sending incremental send/test/x/l0_0/l1_0/l2_3@syncoid_iox86_2024-12-22:00:44:50-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:22-GMT-06:00 (~ 895 KB):
 776KiB 0:00:00 [2.44MiB/s] [=====================================================================================>              ] 86%            
Sending incremental send/test/x/l0_0/l1_1@syncoid_iox86_2024-12-22:00:44:52-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:24-GMT-06:00 (~ 647 KB):
warning: cannot send 'send/test/x/l0_0/l1_1@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_0/l1_1 does not
match incremental source
64.0KiB 0:00:00 [ 360KiB/s] [========>                                                                                           ]  9%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_0/l1_1'@'syncoid_iox86_2024-12-22:00:44:52-GMT-06:00' 'send/test/x/l0_0/l1_1'@'syncoid_iox86_2024-12-22:01:01:24-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 662872 |  zfs receive  -s -F 'recv/test/x/l0_0/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_0/l1_1/l2_0@syncoid_iox86_2024-12-22:00:44:54-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:26-GMT-06:00 (~ 767 KB):
 537KiB 0:00:00 [1.72MiB/s] [=====================================================================>                              ] 70%            
Sending incremental send/test/x/l0_0/l1_1/l2_1@syncoid_iox86_2024-12-22:00:44:56-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:28-GMT-06:00 (~ 575 KB):
warning: cannot send 'send/test/x/l0_0/l1_1/l2_1@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_0/l1_1/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 336KiB/s] [==========>                                                                                         ] 11%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_0/l1_1/l2_1'@'syncoid_iox86_2024-12-22:00:44:56-GMT-06:00' 'send/test/x/l0_0/l1_1/l2_1'@'syncoid_iox86_2024-12-22:01:01:28-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 588960 |  zfs receive  -s -F 'recv/test/x/l0_0/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_0/l1_1/l2_2@syncoid_iox86_2024-12-22:00:44:58-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:30-GMT-06:00 (~ 663 KB):
warning: cannot send 'send/test/x/l0_0/l1_1/l2_2@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_0/l1_1/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 330KiB/s] [========>                                                                                           ]  9%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_0/l1_1/l2_2'@'syncoid_iox86_2024-12-22:00:44:58-GMT-06:00' 'send/test/x/l0_0/l1_1/l2_2'@'syncoid_iox86_2024-12-22:01:01:30-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 679256 |  zfs receive  -s -F 'recv/test/x/l0_0/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_0/l1_1/l2_3@syncoid_iox86_2024-12-22:00:45:00-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:32-GMT-06:00 (~ 855 KB):
warning: cannot send 'send/test/x/l0_0/l1_1/l2_3@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_0/l1_1/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 328KiB/s] [======>                                                                                             ]  7%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_0/l1_1/l2_3'@'syncoid_iox86_2024-12-22:00:45:00-GMT-06:00' 'send/test/x/l0_0/l1_1/l2_3'@'syncoid_iox86_2024-12-22:01:01:32-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 876048 |  zfs receive  -s -F 'recv/test/x/l0_0/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_0/l1_2@syncoid_iox86_2024-12-22:00:45:02-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:33-GMT-06:00 (~ 723 KB):
 543KiB 0:00:00 [1.81MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/x/l0_0/l1_2/l2_0@syncoid_iox86_2024-12-22:00:45:03-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:35-GMT-06:00 (~ 515 KB):
 411KiB 0:00:00 [1.28MiB/s] [==============================================================================>                     ] 79%            
Sending incremental send/test/x/l0_0/l1_2/l2_1@syncoid_iox86_2024-12-22:00:45:05-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:38-GMT-06:00 (~ 839 KB):
warning: cannot send 'send/test/x/l0_0/l1_2/l2_1@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_0/l1_2/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 347KiB/s] [======>                                                                                             ]  7%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_0/l1_2/l2_1'@'syncoid_iox86_2024-12-22:00:45:05-GMT-06:00' 'send/test/x/l0_0/l1_2/l2_1'@'syncoid_iox86_2024-12-22:01:01:38-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 859664 |  zfs receive  -s -F 'recv/test/x/l0_0/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_0/l1_2/l2_2@syncoid_iox86_2024-12-22:00:45:07-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:40-GMT-06:00 (~ 382 KB):
 273KiB 0:00:00 [ 872KiB/s] [======================================================================>                             ] 71%            
Resuming interrupted zfs send/receive from send/test/x/l0_0/l1_2/l2_3 to recv/test/x/l0_0/l1_2/l2_3 (~ 529 KB remaining):
warning: cannot send 'send/test/x/l0_0/l1_2/l2_3@syncoid_iox86_2024-12-22:00:45:09-GMT-06:00': Input/output error
 408 B 0:00:00 [2.14KiB/s] [>                                                                                                    ]  0%            
cannot receive resume stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-116b818df6-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c197191a320bbe55ce5200b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057e44fad583a65f5bee60424794eb07c5e626e2a0343716a5e8a3ed0a812fd0afd1c837803fd1cc37823fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d23232b03032b13532b034b5d77df105d0333201fe20600a3b52e30
CRITICAL ERROR:  zfs send  -t 1-116b818df6-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c197191a320bbe55ce5200b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057e44fad583a65f5bee60424794eb07c5e626e2a0343716a5e8a3ed0a812fd0afd1c837803fd1cc37823fd1ca3786387e2cabce4fccc94f8ccfc0a0bb378230323135d43235d23232b03032b13532b034b5d77df105d0333201fe20600a3b52e30 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 542032 |  zfs receive  -s -F 'recv/test/x/l0_0/l1_2/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/x/l0_0/l1_3@syncoid_iox86_2024-12-22:00:45:11-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:42-GMT-06:00 (~ 723 KB):
 543KiB 0:00:00 [1.88MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/x/l0_0/l1_3/l2_0@syncoid_iox86_2024-12-22:00:45:13-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:45-GMT-06:00 (~ 811 KB):
warning: cannot send 'send/test/x/l0_0/l1_3/l2_0@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_0/l1_3/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 333KiB/s] [======>                                                                                             ]  7%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_0/l1_3/l2_0'@'syncoid_iox86_2024-12-22:00:45:13-GMT-06:00' 'send/test/x/l0_0/l1_3/l2_0'@'syncoid_iox86_2024-12-22:01:01:45-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 830992 |  zfs receive  -s -F 'recv/test/x/l0_0/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_0/l1_3/l2_1@syncoid_iox86_2024-12-22:00:45:15-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:46-GMT-06:00 (~ 647 KB):
 533KiB 0:00:00 [1.61MiB/s] [=================================================================================>                  ] 82%            
Resuming interrupted zfs send/receive from send/test/x/l0_0/l1_3/l2_2 to recv/test/x/l0_0/l1_3/l2_2 (~ 705 KB remaining):
internal error: warning: cannot send 'send/test/x/l0_0/l1_3/l2_2@syncoid_iox86_2024-12-22:00:45:17-GMT-06:00': Invalid argument
Aborted
0.00 B 0:00:00 [0.00 B/s] [>                                                                                                     ]  0%            
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -t 1-1260c6d50e-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081554570ddd4ff99dd0a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a2d8657761988be144f4092e704cbe725e6a6323014a7e6a5e8038d2ad1afd0cf318837d0cf318c37d6cf318a377228aecc4bcecf4c89cfccafb0308b37323032d13534d23532b23230b03231b53234d775f70dd1353003f2216e0000e1302cd8 | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 722440 |  zfs receive  -s -F 'recv/test/x/l0_0/l1_3/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 580.
Sending incremental send/test/x/l0_0/l1_3/l2_3@syncoid_iox86_2024-12-22:00:45:19-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:49-GMT-06:00 (~ 959 KB):
warning: cannot send 'send/test/x/l0_0/l1_3/l2_3@autosnap_2024-12-22_06:45:43_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_0/l1_3/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 337KiB/s] [=====>                                                                                              ]  6%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_0/l1_3/l2_3'@'syncoid_iox86_2024-12-22:00:45:19-GMT-06:00' 'send/test/x/l0_0/l1_3/l2_3'@'syncoid_iox86_2024-12-22:01:01:49-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 982728 |  zfs receive  -s -F 'recv/test/x/l0_0/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1@autosnap_2024-12-22_06:30:38_frequently ... syncoid_iox86_2024-12-22:01:01:51-GMT-06:00 (~ 1.9 MB):
warning: cannot send 'send/test/x/l0_1@syncoid_iox86_2024-12-22:00:45:21-GMT-06:00': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1 does not
match incremental source
64.0KiB 0:00:00 [ 335KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1'@'autosnap_2024-12-22_06:30:38_frequently' 'send/test/x/l0_1'@'syncoid_iox86_2024-12-22:01:01:51-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2041592 |  zfs receive  -s -F 'recv/test/x/l0_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1/l1_0@syncoid_iox86_2024-12-22:00:45:22-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:52-GMT-06:00 (~ 651 KB):
 414KiB 0:00:00 [1.48MiB/s] [==============================================================>                                     ] 63%            
Sending incremental send/test/x/l0_1/l1_0/l2_0@syncoid_iox86_2024-12-22:00:45:24-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:55-GMT-06:00 (~ 515 KB):
 406KiB 0:00:00 [1.21MiB/s] [=============================================================================>                      ] 78%            
Sending incremental send/test/x/l0_1/l1_0/l2_1@syncoid_iox86_2024-12-22:00:45:26-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:57-GMT-06:00 (~ 899 KB):
 664KiB 0:00:00 [1.95MiB/s] [========================================================================>                           ] 73%            
Sending incremental send/test/x/l0_1/l1_0/l2_2@syncoid_iox86_2024-12-22:00:45:28-GMT-06:00 ... syncoid_iox86_2024-12-22:01:01:59-GMT-06:00 (~ 991 KB):
 678KiB 0:00:00 [1.57MiB/s] [===================================================================>                                ] 68%            
Sending incremental send/test/x/l0_1/l1_0/l2_3@syncoid_iox86_2024-12-22:00:45:30-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:02-GMT-06:00 (~ 1.4 MB):
1.04MiB 0:00:00 [1.44MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/x/l0_1/l1_1@syncoid_iox86_2024-12-22:00:28:55-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:05-GMT-06:00 (~ 2.6 MB):
warning: cannot send 'send/test/x/l0_1/l1_1@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_1 does not
match incremental source
64.0KiB 0:00:00 [ 364KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_1'@'syncoid_iox86_2024-12-22:00:28:55-GMT-06:00' 'send/test/x/l0_1/l1_1'@'syncoid_iox86_2024-12-22:01:02:05-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2718976 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1/l1_1/l2_0@syncoid_iox86_2024-12-22:00:45:34-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:07-GMT-06:00 (~ 1.1 MB):
 950KiB 0:00:00 [1.79MiB/s] [===================================================================================>                ] 84%            
Sending incremental send/test/x/l0_1/l1_1/l2_1@syncoid_iox86_2024-12-22:00:28:59-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:09-GMT-06:00 (~ 2.7 MB):
warning: cannot send 'send/test/x/l0_1/l1_1/l2_1@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_1/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 344KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x40000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_1/l2_1'@'syncoid_iox86_2024-12-22:00:28:59-GMT-06:00' 'send/test/x/l0_1/l1_1/l2_1'@'syncoid_iox86_2024-12-22:01:02:09-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2817464 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1/l1_1/l2_2@syncoid_iox86_2024-12-22:00:29:01-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:11-GMT-06:00 (~ 1.8 MB):
warning: cannot send 'send/test/x/l0_1/l1_1/l2_2@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
64.0KiB 0:00:00 [ 334KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_1/l2_2 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_1/l2_2'@'syncoid_iox86_2024-12-22:00:29:01-GMT-06:00' 'send/test/x/l0_1/l1_1/l2_2'@'syncoid_iox86_2024-12-22:01:02:11-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1931256 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1/l1_1/l2_3@syncoid_iox86_2024-12-22:00:45:39-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:13-GMT-06:00 (~ 2.2 MB):
1.69MiB 0:00:00 [3.08MiB/s] [============================================================================>                       ] 77%            
Sending incremental send/test/x/l0_1/l1_2@syncoid_iox86_2024-12-22:00:29:05-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:15-GMT-06:00 (~ 1.8 MB):
warning: cannot send 'send/test/x/l0_1/l1_2@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_2 does not
match incremental source
64.0KiB 0:00:00 [ 371KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_2'@'syncoid_iox86_2024-12-22:00:29:05-GMT-06:00' 'send/test/x/l0_1/l1_2'@'syncoid_iox86_2024-12-22:01:02:15-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1853432 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1/l1_2/l2_0@syncoid_iox86_2024-12-22:00:45:43-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:17-GMT-06:00 (~ 1.7 MB):
1.17MiB 0:00:00 [3.00MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/x/l0_1/l1_2/l2_1@syncoid_iox86_2024-12-22:00:29:09-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:19-GMT-06:00 (~ 2.3 MB):
warning: cannot send 'send/test/x/l0_1/l1_2/l2_1@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_2/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 343KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-22:00:29:09-GMT-06:00' 'send/test/x/l0_1/l1_2/l2_1'@'syncoid_iox86_2024-12-22:01:02:19-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2456280 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_2/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1/l1_2/l2_2@syncoid_iox86_2024-12-22:00:29:11-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:21-GMT-06:00 (~ 2.2 MB):
warning: cannot send 'send/test/x/l0_1/l1_2/l2_2@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_2/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 344KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_2/l2_2'@'syncoid_iox86_2024-12-22:00:29:11-GMT-06:00' 'send/test/x/l0_1/l1_2/l2_2'@'syncoid_iox86_2024-12-22:01:02:21-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2353880 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_2/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1/l1_2/l2_3@syncoid_iox86_2024-12-22:00:29:13-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:22-GMT-06:00 (~ 1.8 MB):
warning: cannot send 'send/test/x/l0_1/l1_2/l2_3@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_2/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 353KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_2/l2_3'@'syncoid_iox86_2024-12-22:00:29:13-GMT-06:00' 'send/test/x/l0_1/l1_2/l2_3'@'syncoid_iox86_2024-12-22:01:02:22-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1910776 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_2/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1/l1_3@syncoid_iox86_2024-12-22:00:29:15-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:24-GMT-06:00 (~ 1.9 MB):
warning: cannot send 'send/test/x/l0_1/l1_3@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_3 does not
match incremental source
64.0KiB 0:00:00 [ 356KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_3'@'syncoid_iox86_2024-12-22:00:29:15-GMT-06:00' 'send/test/x/l0_1/l1_3'@'syncoid_iox86_2024-12-22:01:02:24-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1943544 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1/l1_3/l2_0@syncoid_iox86_2024-12-22:00:29:17-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:26-GMT-06:00 (~ 2.2 MB):
warning: cannot send 'send/test/x/l0_1/l1_3/l2_0@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_3/l2_0 does not
match incremental source
64.0KiB 0:00:00 [ 366KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_3/l2_0'@'syncoid_iox86_2024-12-22:00:29:17-GMT-06:00' 'send/test/x/l0_1/l1_3/l2_0'@'syncoid_iox86_2024-12-22:01:02:26-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2263768 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_3/l2_0' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1/l1_3/l2_1@syncoid_iox86_2024-12-22:00:29:19-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:28-GMT-06:00 (~ 2.9 MB):
warning: cannot send 'send/test/x/l0_1/l1_3/l2_1@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_3/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 354KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_3/l2_1'@'syncoid_iox86_2024-12-22:00:29:19-GMT-06:00' 'send/test/x/l0_1/l1_3/l2_1'@'syncoid_iox86_2024-12-22:01:02:28-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2989680 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_3/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_1/l1_3/l2_2@syncoid_iox86_2024-12-22:00:45:56-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:29-GMT-06:00 (~ 1.5 MB):
1.18MiB 0:00:00 [3.08MiB/s] [===========================================================================>                        ] 76%            
Sending incremental send/test/x/l0_1/l1_3/l2_3@syncoid_iox86_2024-12-22:00:29:23-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:32-GMT-06:00 (~ 1.6 MB):
warning: cannot send 'send/test/x/l0_1/l1_3/l2_3@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_1/l1_3/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 353KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_1/l1_3/l2_3'@'syncoid_iox86_2024-12-22:00:29:23-GMT-06:00' 'send/test/x/l0_1/l1_3/l2_3'@'syncoid_iox86_2024-12-22:01:02:32-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1718080 |  zfs receive  -s -F 'recv/test/x/l0_1/l1_3/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_2@syncoid_iox86_2024-12-22:00:46:00-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:33-GMT-06:00 (~ 1.7 MB):
1.31MiB 0:00:00 [3.81MiB/s] [==========================================================================>                         ] 75%            
Sending incremental send/test/x/l0_2/l1_0@syncoid_iox86_2024-12-22:00:46:01-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:35-GMT-06:00 (~ 1.3 MB):
1.05MiB 0:00:00 [2.84MiB/s] [=================================================================================>                  ] 82%            
Sending incremental send/test/x/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-22:00:46:04-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:37-GMT-06:00 (~ 1.4 MB):
warning: cannot send 'send/test/x/l0_2/l1_0/l2_0@syncoid_iox86_2024-12-22:01:02:37-GMT-06:00': Invalid argument
 537KiB 0:00:00 [3.11MiB/s] [===================================>                                                                ] 36%            
Sending incremental send/test/x/l0_2/l1_0/l2_1@syncoid_iox86_2024-12-22:00:29:30-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:39-GMT-06:00 (~ 2.5 MB):
warning: cannot send 'send/test/x/l0_2/l1_0/l2_1@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_2/l1_0/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 322KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_2/l1_0/l2_1'@'syncoid_iox86_2024-12-22:00:29:30-GMT-06:00' 'send/test/x/l0_2/l1_0/l2_1'@'syncoid_iox86_2024-12-22:01:02:39-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2579344 |  zfs receive  -s -F 'recv/test/x/l0_2/l1_0/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_2/l1_0/l2_2@syncoid_iox86_2024-12-22:00:29:32-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:41-GMT-06:00 (~ 2.1 MB):
warning: cannot send 'send/test/x/l0_2/l1_0/l2_2@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_2/l1_0/l2_2 does not
match incremental source
64.0KiB 0:00:00 [ 349KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_2/l1_0/l2_2'@'syncoid_iox86_2024-12-22:00:29:32-GMT-06:00' 'send/test/x/l0_2/l1_0/l2_2'@'syncoid_iox86_2024-12-22:01:02:41-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2185760 |  zfs receive  -s -F 'recv/test/x/l0_2/l1_0/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_2/l1_0/l2_3@syncoid_iox86_2024-12-22:00:29:34-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:43-GMT-06:00 (~ 1.9 MB):
warning: cannot send 'send/test/x/l0_2/l1_0/l2_3@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_2/l1_0/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 363KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_2/l1_0/l2_3'@'syncoid_iox86_2024-12-22:00:29:34-GMT-06:00' 'send/test/x/l0_2/l1_0/l2_3'@'syncoid_iox86_2024-12-22:01:02:43-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2005168 |  zfs receive  -s -F 'recv/test/x/l0_2/l1_0/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_2/l1_1@syncoid_iox86_2024-12-22:00:46:11-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:44-GMT-06:00 (~ 1.3 MB):
 960KiB 0:00:00 [2.52MiB/s] [=======================================================================>                            ] 72%            
Sending incremental send/test/x/l0_2/l1_1/l2_0@syncoid_iox86_2024-12-22:00:46:13-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:46-GMT-06:00 (~ 1.5 MB):
1.05MiB 0:00:00 [2.68MiB/s] [====================================================================>                               ] 69%            
Sending incremental send/test/x/l0_2/l1_1/l2_1@syncoid_iox86_2024-12-22:00:29:40-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:48-GMT-06:00 (~ 2.5 MB):
warning: cannot send 'send/test/x/l0_2/l1_1/l2_1@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_2/l1_1/l2_1 does not
match incremental source
64.0KiB 0:00:00 [ 345KiB/s] [=>                                                                                                  ]  2%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_2/l1_1/l2_1'@'syncoid_iox86_2024-12-22:00:29:40-GMT-06:00' 'send/test/x/l0_2/l1_1/l2_1'@'syncoid_iox86_2024-12-22:01:02:48-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 2673736 |  zfs receive  -s -F 'recv/test/x/l0_2/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_2/l1_1/l2_2@syncoid_iox86_2024-12-22:00:29:42-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:50-GMT-06:00 (~ 1.9 MB):
warning: cannot send 'send/test/x/l0_2/l1_1/l2_2@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
64.0KiB 0:00:00 [ 354KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x30000: Broken pipe
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_2/l1_1/l2_2 does not
match incremental source
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_2/l1_1/l2_2'@'syncoid_iox86_2024-12-22:00:29:42-GMT-06:00' 'send/test/x/l0_2/l1_1/l2_2'@'syncoid_iox86_2024-12-22:01:02:50-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1943544 |  zfs receive  -s -F 'recv/test/x/l0_2/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_2/l1_1/l2_3@syncoid_iox86_2024-12-22:00:29:44-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:52-GMT-06:00 (~ 1.8 MB):
warning: cannot send 'send/test/x/l0_2/l1_1/l2_3@autosnap_2024-12-22_06:30:38_frequently': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/x/l0_2/l1_1/l2_3 does not
match incremental source
64.0KiB 0:00:00 [ 337KiB/s] [==>                                                                                                 ]  3%            
mbuffer: error: outputThread: error writing to <stdout> at offset 0x20000: Broken pipe
mbuffer: warning: error during output to <stdout>: Broken pipe
CRITICAL ERROR:  zfs send  -I 'send/test/x/l0_2/l1_1/l2_3'@'syncoid_iox86_2024-12-22:00:29:44-GMT-06:00' 'send/test/x/l0_2/l1_1/l2_3'@'syncoid_iox86_2024-12-22:01:02:52-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 1898672 |  zfs receive  -s -F 'recv/test/x/l0_2/l1_1/l2_3' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/x/l0_2/l1_2@syncoid_iox86_2024-12-22:00:46:20-GMT-06:00 ... syncoid_iox86_2024-12-22:01:02:54-GMT-06:00 (~ 234 KB):
 133KiB 0:00:00 [ 371KiB/s] [========================================================>                                           ] 57%            
real 243.20
user 24.46
sys 188.43
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

errors: 81 data errors, use '-v' for a list

hbarta@iox86:~$ zpool status send
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

errors: 81 data errors, use '-v' for a list
hbarta@iox86:~$ sudo zpool status -v send
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

errors: Permanent errors have been detected in the following files:

hbarta@iox86:~$ 
```
