# X86 third trial

Switching to a different H/W platform.

* Supermicro X86DTL
* 16GB ECC RAM
* 2x Intel Xeon E5620 @ 2.40GHz
* Serial Attached SCSI controller: Broadcom / LSI SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 03) (SATA3?)
* 2x 500GB EVO 850 on HBA
* 1x 240GB Patriot Burst Elite on motherboard SATA2 port. Boot device.


```text
root@orcus:~# zfs --version
zfs-2.2.6-1~bpo12+3
zfs-kmod-2.2.6-1~bpo12+3
root@orcus:~# 
```

Devices for pools (boot on `/dev/sdc`)

```text
root@orcus:~# ls -l /dev/disk/by-id|grep -E "sda|sdb"|grep -v part|grep wwn
lrwxrwxrwx 1 root root  9 Dec 22 20:46 wwn-0x5002538d40878f8e -> ../../sdb
lrwxrwxrwx 1 root root  9 Dec 22 20:46 wwn-0x5002538d41628a33 -> ../../sda
root@orcus:~# 
```

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

```text
root@orcus:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   716K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   740K   464G        -         -     0%     0%  1.00x    ONLINE  -
root@orcus:~# 
```

Since the text files are generated based on time, they ar a lot larger due to faster processor and storage. If the test results do not produce corruption within about a day, the `populate_pool.sh` needs to be modified to produce text file size based on byte count vs. time.

`syncoid` command

```
user=hbarta
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    send
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    recv
time -p /sbin/syncoid --recursive --no-privilege-elevation send/test recv/test
```

first, second `syncoid` runs. SSDs seem to be getting SATA3 throughput.

```text
hbarta@orcus:~$ time -p /sbin/syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_orcus_2024-12-23:00:26:47-GMT-06:00 (~ 86 KB) to new target filesystem:
47.7KiB 0:00:00 [2.13MiB/s] [======================================================>                                             ] 55%            
cannot mount 'recv/test': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_orcus_2024-12-23:00:26:47-GMT-06:00 (~ 288.7 GB) to new target filesystem:
 288GiB 0:08:18 [ 592MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_orcus_2024-12-23:00:35:06-GMT-06:00 (~ 315.1 GB) to new target filesystem:
 315GiB 0:09:05 [ 591MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_0': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_orcus_2024-12-23:00:44:12-GMT-06:00 (~ 266.1 GB) to new target filesystem:
 266GiB 0:07:31 [ 603MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_0/l2_0': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_orcus_2024-12-23:00:51:44-GMT-06:00 (~ 265.6 GB) to new target filesystem:
 265GiB 0:07:35 [ 597MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_0/l2_1': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_orcus_2024-12-23:00:59:20-GMT-06:00 (~ 280.8 GB) to new target filesystem:
 280GiB 0:08:05 [ 593MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_0/l2_2': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_orcus_2024-12-23:01:07:25-GMT-06:00 (~ 255.4 GB) to new target filesystem:
 255GiB 0:07:20 [ 594MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_0/l2_3': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_orcus_2024-12-23:01:14:45-GMT-06:00 (~ 267.8 GB) to new target filesystem:
 267GiB 0:07:47 [ 586MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_1': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_orcus_2024-12-23:01:22:33-GMT-06:00 (~ 317.3 GB) to new target filesystem:
 317GiB 0:08:59 [ 602MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_1/l2_0': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_orcus_2024-12-23:01:31:33-GMT-06:00 (~ 278.3 GB) to new target filesystem:
 278GiB 0:07:56 [ 598MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_1/l2_1': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_orcus_2024-12-23:01:39:29-GMT-06:00 (~ 330.0 GB) to new target filesystem:
 330GiB 0:09:29 [ 593MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_1/l2_2': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_orcus_2024-12-23:01:48:59-GMT-06:00 (~ 338.5 GB) to new target filesystem:
 338GiB 0:09:39 [ 598MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_1/l2_3': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_orcus_2024-12-23:01:58:39-GMT-06:00 (~ 288.8 GB) to new target filesystem:
 288GiB 0:08:19 [ 592MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_2': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_orcus_2024-12-23:02:06:59-GMT-06:00 (~ 338.4 GB) to new target filesystem:
 338GiB 0:09:45 [ 592MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_2/l2_0': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_orcus_2024-12-23:02:16:44-GMT-06:00 (~ 295.4 GB) to new target filesystem:
 295GiB 0:08:23 [ 601MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_2/l2_1': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_orcus_2024-12-23:02:25:07-GMT-06:00 (~ 228.8 GB) to new target filesystem:
 228GiB 0:06:39 [ 586MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_2/l2_2': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_orcus_2024-12-23:02:31:47-GMT-06:00 (~ 313.2 GB) to new target filesystem:
 313GiB 0:09:04 [ 589MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_2/l2_3': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_orcus_2024-12-23:02:40:52-GMT-06:00 (~ 248.4 GB) to new target filesystem:
 248GiB 0:07:10 [ 590MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_3': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_orcus_2024-12-23:02:48:03-GMT-06:00 (~ 303.5 GB) to new target filesystem:
 303GiB 0:08:38 [ 599MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_3/l2_0': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_orcus_2024-12-23:02:56:42-GMT-06:00 (~ 327.3 GB) to new target filesystem:
 327GiB 0:09:24 [ 594MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_3/l2_1': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_orcus_2024-12-23:03:06:06-GMT-06:00 (~ 266.9 GB) to new target filesystem:
 266GiB 0:07:41 [ 591MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_3/l2_2': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_orcus_2024-12-23:03:13:49-GMT-06:00 (~ 298.3 GB) to new target filesystem:
 298GiB 0:08:37 [ 591MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_0/l1_3/l2_3': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_orcus_2024-12-23:03:22:26-GMT-06:00 (~ 307.9 GB) to new target filesystem:
 308GiB 0:08:52 [ 592MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_orcus_2024-12-23:03:31:19-GMT-06:00 (~ 266.8 GB) to new target filesystem:
 266GiB 0:07:37 [ 597MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_0': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_orcus_2024-12-23:03:38:56-GMT-06:00 (~ 274.0 GB) to new target filesystem:
 274GiB 0:07:52 [ 594MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_0/l2_0': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_orcus_2024-12-23:03:46:49-GMT-06:00 (~ 341.2 GB) to new target filesystem:
 341GiB 0:09:48 [ 594MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_0/l2_1': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_orcus_2024-12-23:03:56:37-GMT-06:00 (~ 288.7 GB) to new target filesystem:
 288GiB 0:08:09 [ 604MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_0/l2_2': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_orcus_2024-12-23:04:04:46-GMT-06:00 (~ 306.3 GB) to new target filesystem:
 306GiB 0:08:53 [ 587MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_0/l2_3': Insufficient privileges
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_orcus_2024-12-23:04:13:41-GMT-06:00 (~ 296.3 GB) to new target filesystem:
 296GiB 0:12:40 [ 399MiB/s] [==================================================================================================>] 100%            
cannot mount 'recv/test/l0_1/l1_1': Insufficient privileges
real 14374.81
user 547.67
sys 32085.07
hbarta@orcus:~$ 
hbarta@orcus:~$ 
hbarta@orcus:~$ 
hbarta@orcus:~$ time -p /sbin/syncoid --recursive --no-privilege-elevation send/test recv/test
Sending incremental send/test@syncoid_orcus_2024-12-23:00:26:47-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:25-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [43.2KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_0@syncoid_orcus_2024-12-23:00:26:47-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:25-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [40.3KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_0/l1_0@syncoid_orcus_2024-12-23:00:35:06-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:25-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [38.3KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_orcus_2024-12-23:00:44:12-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:26-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [33.0KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_orcus_2024-12-23:00:51:44-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:26-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [40.7KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_orcus_2024-12-23:00:59:20-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:27-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [37.7KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_orcus_2024-12-23:01:07:25-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:27-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [38.4KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_0/l1_1@syncoid_orcus_2024-12-23:01:14:45-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:27-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [40.7KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_orcus_2024-12-23:01:22:33-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:28-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [38.2KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_orcus_2024-12-23:01:31:33-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:28-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [37.5KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orcus_2024-12-23:01:39:29-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:29-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [37.2KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orcus_2024-12-23:01:48:59-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:29-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [41.6KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_0/l1_2@syncoid_orcus_2024-12-23:01:58:39-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:29-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [42.1KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_orcus_2024-12-23:02:06:59-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:30-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [38.0KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_orcus_2024-12-23:02:16:44-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:30-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [37.2KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_orcus_2024-12-23:02:25:07-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:31-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [41.0KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_orcus_2024-12-23:02:31:47-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:31-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [38.2KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_0/l1_3@syncoid_orcus_2024-12-23:02:40:52-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:31-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [39.6KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_orcus_2024-12-23:02:48:03-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:32-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [38.9KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_orcus_2024-12-23:02:56:42-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:32-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [39.5KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_orcus_2024-12-23:03:06:06-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:33-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [39.6KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_orcus_2024-12-23:03:13:49-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:33-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [36.7KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_1@syncoid_orcus_2024-12-23:03:22:26-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:34-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [38.3KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_1/l1_0@syncoid_orcus_2024-12-23:03:31:19-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:34-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [39.7KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_orcus_2024-12-23:03:38:56-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:34-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [38.3KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_orcus_2024-12-23:03:46:49-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:35-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [37.8KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_orcus_2024-12-23:03:56:37-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:35-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [39.5KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_orcus_2024-12-23:04:04:46-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:36-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [40.7KiB/s] [=====================================>                                                              ] 38%            
Sending incremental send/test/l0_1/l1_1@syncoid_orcus_2024-12-23:04:13:41-GMT-06:00 ... syncoid_orcus_2024-12-23:07:42:36-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [39.6KiB/s] [=====================================>                                                              ] 38%            
real 12.00
user 2.95
sys 6.08
hbarta@orcus:~$ 
```

## 2024-12-23 looping start at 0900 

The loops run considerably faster.

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

