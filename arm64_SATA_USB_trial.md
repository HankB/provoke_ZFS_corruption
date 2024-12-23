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

Rather than try to guess what tunables will populate the pool, just kill the process when there is "enough" there. (62%) Prepasre the receiving dataset.

```text
sudo zfs create ST8TB-ZA20HR7B/namtarri-backup
```

```text
user=hbarta
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    namtarri_tank
```

And the command to run on `namtarri` to send the pool.

```text
/bin/time -p /sbin/syncoid --recursive --no-privilege-elevation namtarri_tank olive:ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank
```

```text
hbarta@namtarri:~$ /bin/time -p /sbin/syncoid --recursive --no-privilege-elevation namtarri_tank olive:ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank
INFO: Sending oldest full snapshot namtarri_tank@autosnap_2024-12-19_12:34:12_monthly (~ 98 KB) to new target filesystem:
45.8KiB 0:00:00 [1.62MiB/s] [============================================>                                                      ]  46%            
cannot mount '/mnt/ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'namtarri_tank'@'autosnap_2024-12-19_12:34:12_monthly' | pv -p -t -e -r -b -s 100464 | lzop  | mbuffer  -q -s 128k -m 16M | ssh      -S /tmp/syncoid-olive-1734633357-1157 olive ' mbuffer  -q -s 128k -m 16M | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank'"'"'' failed: 256 at /sbin/syncoid line 549.
INFO: Sending oldest full snapshot namtarri_tank/test@autosnap_2024-12-19_12:34:12_monthly (~ 98 KB) to new target filesystem:
45.8KiB 0:00:00 [1.54MiB/s] [============================================>                                                      ]  46%            
cannot mount '/mnt/ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'namtarri_tank/test'@'autosnap_2024-12-19_12:34:12_monthly' | pv -p -t -e -r -b -s 100464 | lzop  | mbuffer  -q -s 128k -m 16M | ssh      -S /tmp/syncoid-olive-1734633357-1157 olive ' mbuffer  -q -s 128k -m 16M | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test'"'"'' failed: 256 at /sbin/syncoid line 549.
INFO: Sending oldest full snapshot namtarri_tank/test/l0_0@autosnap_2024-12-19_12:34:12_monthly (~ 83.5 GB) to new target filesystem:
83.5GiB 0:07:01 [ 202MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'namtarri_tank/test/l0_0'@'autosnap_2024-12-19_12:34:12_monthly' | pv -p -t -e -r -b -s 89637659296 | lzop  | mbuffer  -q -s 128k -m 16M | ssh      -S /tmp/syncoid-olive-1734633357-1157 olive ' mbuffer  -q -s 128k -m 16M | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0'"'"'' failed: 256 at /sbin/syncoid line 549.
INFO: Sending oldest full snapshot namtarri_tank/test/l0_0/l1_0@autosnap_2024-12-19_12:34:12_monthly (~ 72.6 GB) to new target filesystem:
72.6GiB 0:06:10 [ 200MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'namtarri_tank/test/l0_0/l1_0'@'autosnap_2024-12-19_12:34:12_monthly' | pv -p -t -e -r -b -s 77949095552 | lzop  | mbuffer  -q -s 128k -m 16M | ssh      -S /tmp/syncoid-olive-1734633357-1157 olive ' mbuffer  -q -s 128k -m 16M | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_0'"'"'' failed: 256 at /sbin/syncoid line 549.
INFO: Sending oldest full snapshot namtarri_tank/test/l0_0/l1_0/l2_0@autosnap_2024-12-19_12:34:12_monthly (~ 80.8 GB) to new target filesystem:
80.8GiB 0:06:49 [ 202MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_0/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'namtarri_tank/test/l0_0/l1_0/l2_0'@'autosnap_2024-12-19_12:34:12_monthly' | pv -p -t -e -r -b -s 86769480320 | lzop  | mbuffer  -q -s 128k -m 16M | ssh      -S /tmp/syncoid-olive-1734633357-1157 olive ' mbuffer  -q -s 128k -m 16M | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_0/l2_0'"'"'' failed: 256 at /sbin/syncoid line 549.
INFO: Sending oldest full snapshot namtarri_tank/test/l0_0/l1_0/l2_1@autosnap_2024-12-19_12:34:12_monthly (~ 69.3 GB) to new target filesystem:
69.3GiB 0:05:54 [ 200MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_0/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'namtarri_tank/test/l0_0/l1_0/l2_1'@'autosnap_2024-12-19_12:34:12_monthly' | pv -p -t -e -r -b -s 74409057744 | lzop  | mbuffer  -q -s 128k -m 16M | ssh      -S /tmp/syncoid-olive-1734633357-1157 olive ' mbuffer  -q -s 128k -m 16M | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_0/l2_1'"'"'' failed: 256 at /sbin/syncoid line 549.
INFO: Sending oldest full snapshot namtarri_tank/test/l0_0/l1_0/l2_2@autosnap_2024-12-19_12:34:12_monthly (~ 87.1 GB) to new target filesystem:
87.2GiB 0:07:25 [ 200MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_0/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'namtarri_tank/test/l0_0/l1_0/l2_2'@'autosnap_2024-12-19_12:34:12_monthly' | pv -p -t -e -r -b -s 93542363832 | lzop  | mbuffer  -q -s 128k -m 16M | ssh      -S /tmp/syncoid-olive-1734633357-1157 olive ' mbuffer  -q -s 128k -m 16M | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_0/l2_2'"'"'' failed: 256 at /sbin/syncoid line 549.
INFO: Sending oldest full snapshot namtarri_tank/test/l0_0/l1_0/l2_3@autosnap_2024-12-19_12:34:12_monthly (~ 77.7 GB) to new target filesystem:
77.7GiB 0:06:39 [ 199MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_0/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'namtarri_tank/test/l0_0/l1_0/l2_3'@'autosnap_2024-12-19_12:34:12_monthly' | pv -p -t -e -r -b -s 83417300568 | lzop  | mbuffer  -q -s 128k -m 16M | ssh      -S /tmp/syncoid-olive-1734633357-1157 olive ' mbuffer  -q -s 128k -m 16M | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_0/l2_3'"'"'' failed: 256 at /sbin/syncoid line 549.
INFO: Sending oldest full snapshot namtarri_tank/test/l0_0/l1_1@autosnap_2024-12-19_12:34:12_monthly (~ 82.2 GB) to new target filesystem:
82.3GiB 0:06:59 [ 200MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'namtarri_tank/test/l0_0/l1_1'@'autosnap_2024-12-19_12:34:12_monthly' | pv -p -t -e -r -b -s 88278548984 | lzop  | mbuffer  -q -s 128k -m 16M | ssh      -S /tmp/syncoid-olive-1734633357-1157 olive ' mbuffer  -q -s 128k -m 16M | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_1'"'"'' failed: 256 at /sbin/syncoid line 549.
INFO: Sending oldest full snapshot namtarri_tank/test/l0_0/l1_1/l2_0@autosnap_2024-12-19_12:34:12_monthly (~ 63.1 GB) to new target filesystem:
63.1GiB 0:05:22 [ 200MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_1/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'namtarri_tank/test/l0_0/l1_1/l2_0'@'autosnap_2024-12-19_12:34:12_monthly' | pv -p -t -e -r -b -s 67717175568 | lzop  | mbuffer  -q -s 128k -m 16M | ssh      -S /tmp/syncoid-olive-1734633357-1157 olive ' mbuffer  -q -s 128k -m 16M | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_1/l2_0'"'"'' failed: 256 at /sbin/syncoid line 549.
INFO: Sending oldest full snapshot namtarri_tank/test/l0_0/l1_1/l2_1@autosnap_2024-12-19_12:34:12_monthly (~ 83.2 GB) to new target filesystem:
83.3GiB 0:07:07 [ 199MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_1/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'namtarri_tank/test/l0_0/l1_1/l2_1'@'autosnap_2024-12-19_12:34:12_monthly' | pv -p -t -e -r -b -s 89381704464 | lzop  | mbuffer  -q -s 128k -m 16M | ssh      -S /tmp/syncoid-olive-1734633357-1157 olive ' mbuffer  -q -s 128k -m 16M | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_1/l2_1'"'"'' failed: 256 at /sbin/syncoid line 549.
INFO: Sending oldest full snapshot namtarri_tank/test/l0_0/l1_1/l2_2@autosnap_2024-12-19_12:34:12_monthly (~ 73.9 GB) to new target filesystem:
73.9GiB 0:06:19 [ 199MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_1/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'namtarri_tank/test/l0_0/l1_1/l2_2'@'autosnap_2024-12-19_12:34:12_monthly' | pv -p -t -e -r -b -s 79301026208 | lzop  | mbuffer  -q -s 128k -m 16M | ssh      -S /tmp/syncoid-olive-1734633357-1157 olive ' mbuffer  -q -s 128k -m 16M | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_1/l2_2'"'"'' failed: 256 at /sbin/syncoid line 549.
INFO: Sending oldest full snapshot namtarri_tank/test/l0_0/l1_1/l2_3@autosnap_2024-12-19_12:34:12_monthly (~ 73.5 GB) to new target filesystem:
73.6GiB 0:06:18 [ 199MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_1/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'namtarri_tank/test/l0_0/l1_1/l2_3'@'autosnap_2024-12-19_12:34:12_monthly' | pv -p -t -e -r -b -s 78939575856 | lzop  | mbuffer  -q -s 128k -m 16M | ssh      -S /tmp/syncoid-olive-1734633357-1157 olive ' mbuffer  -q -s 128k -m 16M | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_1/l2_3'"'"'' failed: 256 at /sbin/syncoid line 549.
INFO: Sending oldest full snapshot namtarri_tank/test/l0_0/l1_2@autosnap_2024-12-19_12:34:12_monthly (~ 66.4 GB) to new target filesystem:
66.5GiB 0:05:51 [ 193MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_2': failed to create mountpoint: Permission denied
CRITICAL ERROR:  zfs send  'namtarri_tank/test/l0_0/l1_2'@'autosnap_2024-12-19_12:34:12_monthly' | pv -p -t -e -r -b -s 71320484072 | lzop  | mbuffer  -q -s 128k -m 16M | ssh      -S /tmp/syncoid-olive-1734633357-1157 olive ' mbuffer  -q -s 128k -m 16M | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank/test/l0_0/l1_2'"'"'' failed: 256 at /sbin/syncoid line 549.
real 4690.91
user 1440.30
sys 4771.14
hbarta@namtarri:~$ /bin/time -p /sbin/syncoid --recursive --no-privilege-elevation namtarri_tank olive:ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank
Sending incremental namtarri_tank@autosnap_2024-12-19_12:34:12_monthly ... syncoid_namtarri_2024-12-19:14:18:13-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [46.3KiB/s] [===================================================================================================] 110%            
Sending incremental namtarri_tank/test@autosnap_2024-12-19_12:34:12_monthly ... syncoid_namtarri_2024-12-19:14:18:19-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [42.1KiB/s] [===================================================================================================] 110%            
Sending incremental namtarri_tank/test/l0_0@autosnap_2024-12-19_12:34:12_monthly ... syncoid_namtarri_2024-12-19:14:18:24-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [37.9KiB/s] [===================================================================================================] 110%            
Sending incremental namtarri_tank/test/l0_0/l1_0@autosnap_2024-12-19_12:34:12_monthly ... syncoid_namtarri_2024-12-19:14:18:29-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [33.3KiB/s] [===================================================================================================] 110%            
Sending incremental namtarri_tank/test/l0_0/l1_0/l2_0@autosnap_2024-12-19_12:34:12_monthly ... syncoid_namtarri_2024-12-19:14:18:34-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [31.0KiB/s] [===================================================================================================] 110%            
Sending incremental namtarri_tank/test/l0_0/l1_0/l2_1@autosnap_2024-12-19_12:34:12_monthly ... syncoid_namtarri_2024-12-19:14:18:39-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [30.9KiB/s] [===================================================================================================] 110%            
Sending incremental namtarri_tank/test/l0_0/l1_0/l2_2@autosnap_2024-12-19_12:34:12_monthly ... syncoid_namtarri_2024-12-19:14:18:45-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [30.9KiB/s] [===================================================================================================] 110%            
Sending incremental namtarri_tank/test/l0_0/l1_0/l2_3@autosnap_2024-12-19_12:34:12_monthly ... syncoid_namtarri_2024-12-19:14:18:50-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [31.8KiB/s] [===================================================================================================] 110%            
Sending incremental namtarri_tank/test/l0_0/l1_1@autosnap_2024-12-19_12:34:12_monthly ... syncoid_namtarri_2024-12-19:14:18:55-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [32.9KiB/s] [===================================================================================================] 110%            
Sending incremental namtarri_tank/test/l0_0/l1_1/l2_0@autosnap_2024-12-19_12:34:12_monthly ... syncoid_namtarri_2024-12-19:14:19:00-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [29.9KiB/s] [===================================================================================================] 110%            
Sending incremental namtarri_tank/test/l0_0/l1_1/l2_1@autosnap_2024-12-19_12:34:12_monthly ... syncoid_namtarri_2024-12-19:14:19:05-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [31.1KiB/s] [===================================================================================================] 110%            
Sending incremental namtarri_tank/test/l0_0/l1_1/l2_2@autosnap_2024-12-19_12:34:12_monthly ... syncoid_namtarri_2024-12-19:14:19:11-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [30.3KiB/s] [===================================================================================================] 110%            
Sending incremental namtarri_tank/test/l0_0/l1_1/l2_3@autosnap_2024-12-19_12:34:12_monthly ... syncoid_namtarri_2024-12-19:14:19:16-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [30.1KiB/s] [===================================================================================================] 110%            
Sending incremental namtarri_tank/test/l0_0/l1_2@autosnap_2024-12-19_12:34:12_monthly ... syncoid_namtarri_2024-12-19:14:19:21-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [33.4KiB/s] [===================================================================================================] 110%            
real 73.86
user 2.14
sys 8.99
hbarta@namtarri:~$ 
```

## 2024-12-20 start looping

```text
sudo chown hbarta:hbarta -R /mnt/namtarri_tank/
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
    /bin/time -p /sbin/syncoid --recursive --no-privilege-elevation namtarri_tank olive:ST8TB-ZA20HR7B/namtarri-backup/namtarri_tank
    zpool status namtarri_tank
    echo
    sleep 750
done
```

## 2024-12-23 still looping - no errors

As of 0900.
