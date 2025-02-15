# second try

Adjust some parameters when creating the pool to get more files and tweak `stir-pools.sh`

```text
zpool destroy io_tank # Save the user directory first!
user=hbarta
chown -R $user:$user /home/$user
dd if=/dev/urandom bs=32 count=1 of=/pool-key
zpool create -o ashift=13 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O encryption=aes-256-gcm  -O keylocation=file:///pool-key -O keyformat=raw \
      -O mountpoint=/mnt/io_tank \
      io_tank /dev/disk/by-id/nvme-eui.0000000001000000e4d25c8051695501-part3
zfs load-key -a
zfs mount io_tank
chmod a+rwx /mnt/io_tank/
zfs create -o mountpoint=/home/hbarta/Programming io_tank/Programming
```

```text
hbarta@io:~$ find /mnt/io_tank/test -type f|wc -l
3360
hbarta@io:~$ zfs list|wc -l
88
hbarta@io:~$ zpool list
NAME      SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
io_tank   920G   114G   806G        -         -     0%    12%  1.00x    ONLINE  -
hbarta@io:~$
```

Went too far, but now I know I need to quadruple the result, so double the number of files and limits for file size. Rerunning again, but this time just destroy `io_tank/test` rather than the entire pool.

## 2024-12-16 starting third run

Using modified tunables in `populate_pool.sh`. Result was 42% capacity with 1% fragmentation reported. Kicked off a `syncoid` to start an initial backup (while `populate_pool.sh` was still running.)

```text
hbarta@io:~/Programming/provoke_ZFS_corruption$ /bin/time -p /sbin/syncoid --recursive --no-privilege-elevation io:io_tank olive:ST8TB-ZA20HR7B/io-backup/io_tank
INFO: Sending oldest full snapshot io_tank@autosnap_2024-12-16_05:30:08_monthly (~ 97 KB) to new target filesystem:
44.2KiB 0:00:00 [ 577KiB/s] [============================================>                                                       ] 45%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734364482 io ' zfs send  '"'"'io_tank'"'"'@'"'"'autosnap_2024-12-16_05:30:08_monthly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 99952 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734364484 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/Programming@autosnap_2024-12-16_06:00:01_hourly (~ 387 KB) to new target filesystem:
 364KiB 0:00:00 [3.03MiB/s] [=============================================================================================>      ] 94%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/Programming': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734364482 io ' zfs send  '"'"'io_tank/Programming'"'"'@'"'"'autosnap_2024-12-16_06:00:01_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 396952 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734364484 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/Programming'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test@syncoid_io_2024-12-16:09:54:48-GMT-06:00 (~ 98 KB) to new target filesystem:
45.8KiB 0:00:00 [ 645KiB/s] [=============================================>                                                      ] 46%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734364482 io ' zfs send  '"'"'io_tank/test'"'"'@'"'"'syncoid_io_2024-12-16:09:54:48-GMT-06:00'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 100464 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734364484 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0@syncoid_io_2024-12-16:09:54:50-GMT-06:00 (~ 75.7 GB) to new target filesystem:
75.8GiB 0:18:04 [71.5MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734364482 io ' zfs send  '"'"'io_tank/test/l0_0'"'"'@'"'"'syncoid_io_2024-12-16:09:54:50-GMT-06:00'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 81326900104 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734364484 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0'"'"'' failed: 256 at /sbin/syncoid line 492.
real 1093.87
user 373.27
sys 389.33
hbarta@io:~/Programming/provoke_ZFS_corruption$ /bin/time -p /sbin/syncoid --recursive --no-privilege-elevation io:io_tank olive:ST8TB-ZA20HR7B/io-backup/io_tank
Sending incremental io_tank@autosnap_2024-12-16_05:30:08_monthly ... syncoid_io_2024-12-16:10:41:40-GMT-06:00 (~ 205 KB):
66.4KiB 0:00:00 [68.3KiB/s] [===============================>                                                                    ] 32%            
Sending incremental io_tank/Programming@autosnap_2024-12-16_06:00:01_hourly ... syncoid_io_2024-12-16:10:41:52-GMT-06:00 (~ 137 KB):
45.6KiB 0:00:01 [35.1KiB/s] [================================>                                                                   ] 33%            
Sending incremental io_tank/test@syncoid_io_2024-12-16:09:54:48-GMT-06:00 ... syncoid_io_2024-12-16:10:42:03-GMT-06:00 (~ 4 KB):
3.96KiB 0:00:00 [3.99KiB/s] [==================================================================================================> ] 99%            
Sending incremental io_tank/test/l0_0@syncoid_io_2024-12-16:09:54:50-GMT-06:00 ... syncoid_io_2024-12-16:10:42:07-GMT-06:00 (~ 4.4 GB):
4.36GiB 0:00:57 [77.0MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_0@autosnap_2024-12-16_16:00:04_hourly (~ 29.5 GB) to new target filesystem:
29.6GiB 0:06:54 [72.9MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734367297 io ' zfs send  '"'"'io_tank/test/l0_0/l1_0'"'"'@'"'"'autosnap_2024-12-16_16:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 31720198624 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734367299 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_0/l2_0@autosnap_2024-12-16_16:15:03_frequently (~ 40.4 GB) to new target filesystem:
40.4GiB 0:09:27 [73.0MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734367297 io ' zfs send  '"'"'io_tank/test/l0_0/l1_0/l2_0'"'"'@'"'"'autosnap_2024-12-16_16:15:03_frequently'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 43407854840 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734367299 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_0/l2_1@autosnap_2024-12-16_16:15:03_frequently (~ 48.2 GB) to new target filesystem:
48.2GiB 0:11:24 [72.1MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734367297 io ' zfs send  '"'"'io_tank/test/l0_0/l1_0/l2_1'"'"'@'"'"'autosnap_2024-12-16_16:15:03_frequently'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 51763454432 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734367299 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_0/l2_2@autosnap_2024-12-16_16:30:03_frequently (~ 83.8 GB) to new target filesystem:
83.8GiB 0:19:37 [72.9MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734367297 io ' zfs send  '"'"'io_tank/test/l0_0/l1_0/l2_2'"'"'@'"'"'autosnap_2024-12-16_16:30:03_frequently'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 89932524272 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734367299 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_0/l2_3@autosnap_2024-12-16_16:30:03_frequently (~ 75.0 GB) to new target filesystem:
75.0GiB 0:17:35 [72.8MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734367297 io ' zfs send  '"'"'io_tank/test/l0_0/l1_0/l2_3'"'"'@'"'"'autosnap_2024-12-16_16:30:03_frequently'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 80499175704 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734367299 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_3'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_1@autosnap_2024-12-16_16:45:04_frequently (~ 81.8 GB) to new target filesystem:
81.9GiB 0:19:16 [72.5MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734367297 io ' zfs send  '"'"'io_tank/test/l0_0/l1_1'"'"'@'"'"'autosnap_2024-12-16_16:45:04_frequently'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 87864492296 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734367299 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_1/l2_0@autosnap_2024-12-16_16:45:04_frequently (~ 73.6 GB) to new target filesystem:
73.6GiB 0:17:17 [72.6MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734367297 io ' zfs send  '"'"'io_tank/test/l0_0/l1_1/l2_0'"'"'@'"'"'autosnap_2024-12-16_16:45:04_frequently'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 79024887648 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734367299 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1/l2_0'"'"'' failed: 256 at /sbin/syncoid line 492.
real 6195.88
user 2137.82
sys 2233.12
hbarta@io:~/Programming/provoke_ZFS_corruption$ zpool status
  pool: io_tank
 state: ONLINE
config:

        NAME                                               STATE     READ WRITE CKSUM
        io_tank                                            ONLINE       0     0     0
          nvme-eui.0000000001000000e4d25c8051695501-part3  ONLINE       0     0     0

errors: No known data errors
hbarta@io:~/Programming/provoke_ZFS_corruption$ 
```

Started another when 

## 2024-12-17 backup complete

Seems like it took longer than expected and the "no snapshots matching" warnings require further investigation.

```text
hbarta@io:~$ while(:); do /bin/time -p /sbin/syncoid --recursive --no-privilege-elevation io:io_tank olive:ST8TB-ZA20HR7B/io-backup/io_tank; echo; zpool status;echo; sleep 750; doneSending incremental io_tank@syncoid_io_2024-12-16:10:41:40-GMT-06:00 ... syncoid_io_2024-12-16:20:02:01-GMT-06:00 (~ 73 KB):
19.4KiB 0:00:00 [74.5KiB/s] [====================================>                                                                                                             ] 26%            
Sending incremental io_tank/Programming@syncoid_io_2024-12-16:10:41:52-GMT-06:00 ... syncoid_io_2024-12-16:20:02:12-GMT-06:00 (~ 326 KB):
 204KiB 0:00:00 [ 706KiB/s] [=========================================================================================>                                                        ] 62%            
Sending incremental io_tank/test@syncoid_io_2024-12-16:10:42:03-GMT-06:00 ... syncoid_io_2024-12-16:20:02:22-GMT-06:00 (~ 308 KB):
42.5KiB 0:00:00 [ 138KiB/s] [=================>                                                                                                                                ] 13%            
Sending incremental io_tank/test/l0_0@syncoid_io_2024-12-16:10:42:07-GMT-06:00 ... syncoid_io_2024-12-16:20:02:33-GMT-06:00 (~ 173 KB):
42.1KiB 0:00:00 [ 136KiB/s] [==================================>                                                                                                               ] 24%            
Sending incremental io_tank/test/l0_0/l1_0@autosnap_2024-12-16_16:00:04_hourly ... syncoid_io_2024-12-16:20:02:43-GMT-06:00 (~ 19.0 GB):
19.0GiB 0:02:45 [ 117MiB/s] [================================================================================================================================================>] 100%            

CRITICAL ERROR: Target ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_0 exists but has no snapshots matching with io_tank/test/l0_0/l1_0/l2_0!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.


CRITICAL ERROR: Target ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_1 exists but has no snapshots matching with io_tank/test/l0_0/l1_0/l2_1!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.


CRITICAL ERROR: Target ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_2 exists but has no snapshots matching with io_tank/test/l0_0/l1_0/l2_2!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.


CRITICAL ERROR: Target ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_3 exists but has no snapshots matching with io_tank/test/l0_0/l1_0/l2_3!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.


CRITICAL ERROR: Target ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1 exists but has no snapshots matching with io_tank/test/l0_0/l1_1!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.


CRITICAL ERROR: Target ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1/l2_0 exists but has no snapshots matching with io_tank/test/l0_0/l1_1/l2_0!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.

INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_1/l2_1@autosnap_2024-12-16_17:00:12_hourly (~ 45.1 GB) to new target filesystem:
45.1GiB 0:06:31 [ 118MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_0/l1_1/l2_1'"'"'@'"'"'autosnap_2024-12-16_17:00:12_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 48395566456 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1/l2_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_1/l2_2@autosnap_2024-12-16_17:00:12_hourly (~ 43.6 GB) to new target filesystem:
43.7GiB 0:06:25 [ 115MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_0/l1_1/l2_2'"'"'@'"'"'autosnap_2024-12-16_17:00:12_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 46855248624 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1/l2_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_1/l2_3@autosnap_2024-12-16_17:00:12_hourly (~ 1.3 GB) to new target filesystem:
1.31GiB 0:00:11 [ 114MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_0/l1_1/l2_3'"'"'@'"'"'autosnap_2024-12-16_17:00:12_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 1406056880 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1/l2_3'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_2@autosnap_2024-12-16_18:00:04_hourly (~ 48.9 GB) to new target filesystem:
48.9GiB 0:07:05 [ 117MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_0/l1_2'"'"'@'"'"'autosnap_2024-12-16_18:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 52510337424 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_2/l2_0@autosnap_2024-12-16_18:00:04_hourly (~ 46.8 GB) to new target filesystem:
46.8GiB 0:06:54 [ 115MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_2/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_0/l1_2/l2_0'"'"'@'"'"'autosnap_2024-12-16_18:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 50225365208 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_2/l2_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_2/l2_1@autosnap_2024-12-16_18:00:04_hourly (~ 41.1 GB) to new target filesystem:
41.2GiB 0:06:00 [ 117MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_2/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_0/l1_2/l2_1'"'"'@'"'"'autosnap_2024-12-16_18:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 44184135592 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_2/l2_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_2/l2_2@autosnap_2024-12-16_18:00:04_hourly (~ 41.3 GB) to new target filesystem:
41.3GiB 0:05:59 [ 117MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_2/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_0/l1_2/l2_2'"'"'@'"'"'autosnap_2024-12-16_18:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 44298972304 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_2/l2_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_2/l2_3@autosnap_2024-12-16_18:00:04_hourly (~ 39.4 GB) to new target filesystem:
39.4GiB 0:05:45 [ 116MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_2/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_0/l1_2/l2_3'"'"'@'"'"'autosnap_2024-12-16_18:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 42280804624 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_2/l2_3'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_3@autosnap_2024-12-16_18:00:04_hourly (~ 44.0 GB) to new target filesystem:
44.0GiB 0:06:43 [ 111MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_0/l1_3'"'"'@'"'"'autosnap_2024-12-16_18:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 47244300624 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_3'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_3/l2_0@autosnap_2024-12-16_18:00:04_hourly (~ 39.3 GB) to new target filesystem:
39.3GiB 0:06:09 [ 108MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_3/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_0/l1_3/l2_0'"'"'@'"'"'autosnap_2024-12-16_18:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 42178359408 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_3/l2_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_3/l2_1@autosnap_2024-12-16_18:00:04_hourly (~ 17.5 GB) to new target filesystem:
17.5GiB 0:02:41 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_3/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_0/l1_3/l2_1'"'"'@'"'"'autosnap_2024-12-16_18:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 18800596304 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_3/l2_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_3/l2_2@autosnap_2024-12-16_19:00:03_hourly (~ 43.6 GB) to new target filesystem:
43.6GiB 0:06:41 [ 111MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_3/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_0/l1_3/l2_2'"'"'@'"'"'autosnap_2024-12-16_19:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 46814214648 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_3/l2_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_3/l2_3@autosnap_2024-12-16_19:00:03_hourly (~ 45.1 GB) to new target filesystem:
45.1GiB 0:07:01 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_3/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_0/l1_3/l2_3'"'"'@'"'"'autosnap_2024-12-16_19:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 48406152952 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_3/l2_3'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_1@autosnap_2024-12-16_19:00:03_hourly (~ 57.0 GB) to new target filesystem:
57.0GiB 0:08:42 [ 111MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_1'"'"'@'"'"'autosnap_2024-12-16_19:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 61210180360 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_1/l1_0@autosnap_2024-12-16_19:00:03_hourly (~ 88.5 GB) to new target filesystem:
88.5GiB 0:13:40 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_1/l1_0'"'"'@'"'"'autosnap_2024-12-16_19:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 94996026080 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_1/l1_0/l2_0@autosnap_2024-12-16_19:00:03_hourly (~ 81.9 GB) to new target filesystem:
82.0GiB 0:12:39 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_0/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_1/l1_0/l2_0'"'"'@'"'"'autosnap_2024-12-16_19:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 87970698368 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_0/l2_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_1/l1_0/l2_1@autosnap_2024-12-16_19:00:03_hourly (~ 72.7 GB) to new target filesystem:
72.8GiB 0:11:13 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_0/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_1/l1_0/l2_1'"'"'@'"'"'autosnap_2024-12-16_19:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 78108729472 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_0/l2_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_1/l1_0/l2_2@autosnap_2024-12-16_19:00:03_hourly (~ 85.5 GB) to new target filesystem:
85.5GiB 0:13:11 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_0/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_1/l1_0/l2_2'"'"'@'"'"'autosnap_2024-12-16_19:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 91812606544 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_0/l2_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_1/l1_0/l2_3@autosnap_2024-12-16_19:00:03_hourly (~ 61.5 GB) to new target filesystem:
61.5GiB 0:09:24 [ 111MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_0/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_1/l1_0/l2_3'"'"'@'"'"'autosnap_2024-12-16_19:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 66041785072 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_0/l2_3'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_1/l1_1@autosnap_2024-12-16_20:00:04_hourly (~ 78.1 GB) to new target filesystem:
78.2GiB 0:12:04 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_1/l1_1'"'"'@'"'"'autosnap_2024-12-16_20:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 83901797184 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_1/l1_1/l2_0@autosnap_2024-12-16_20:00:04_hourly (~ 81.9 GB) to new target filesystem:
81.9GiB 0:12:32 [ 111MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_1/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_1/l1_1/l2_0'"'"'@'"'"'autosnap_2024-12-16_20:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 87899414072 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_1/l2_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_1/l1_1/l2_1@autosnap_2024-12-16_20:00:04_hourly (~ 70.8 GB) to new target filesystem:
70.9GiB 0:11:01 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_1/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_1/l1_1/l2_1'"'"'@'"'"'autosnap_2024-12-16_20:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 76073892464 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_1/l2_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_1/l1_1/l2_2@autosnap_2024-12-16_20:00:04_hourly (~ 83.9 GB) to new target filesystem:
84.0GiB 0:12:56 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_1/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_1/l1_1/l2_2'"'"'@'"'"'autosnap_2024-12-16_20:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 90135499480 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_1/l2_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_1/l1_1/l2_3@autosnap_2024-12-16_20:00:04_hourly (~ 83.0 GB) to new target filesystem:
83.1GiB 0:12:50 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_1/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_1/l1_1/l2_3'"'"'@'"'"'autosnap_2024-12-16_20:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 89160956448 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_1/l2_3'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_1/l1_2@autosnap_2024-12-16_20:00:04_hourly (~ 82.8 GB) to new target filesystem:
82.8GiB 0:12:45 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_1/l1_2'"'"'@'"'"'autosnap_2024-12-16_20:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 88898011256 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_1/l1_2/l2_0@autosnap_2024-12-16_20:00:04_hourly (~ 76.2 GB) to new target filesystem:
76.2GiB 0:11:48 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_2/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_1/l1_2/l2_0'"'"'@'"'"'autosnap_2024-12-16_20:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 81813709152 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_2/l2_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_1/l1_2/l2_1@autosnap_2024-12-16_20:00:04_hourly (~ 86.1 GB) to new target filesystem:
86.1GiB 0:13:17 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_2/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_1/l1_2/l2_1'"'"'@'"'"'autosnap_2024-12-16_20:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 92449797080 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_2/l2_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_1/l1_2/l2_2@autosnap_2024-12-16_20:00:04_hourly (~ 21.8 GB) to new target filesystem:
21.8GiB 0:03:19 [ 111MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_2/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_1/l1_2/l2_2'"'"'@'"'"'autosnap_2024-12-16_20:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 23422714208 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_2/l2_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_1/l1_2/l2_3@autosnap_2024-12-16_21:00:03_hourly (~ 78.0 GB) to new target filesystem:
78.0GiB 0:12:04 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_2/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_1/l1_2/l2_3'"'"'@'"'"'autosnap_2024-12-16_21:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 83721260792 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_2/l2_3'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_1/l1_3@autosnap_2024-12-16_21:00:03_hourly (~ 85.3 GB) to new target filesystem:
85.4GiB 0:13:17 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_1/l1_3'"'"'@'"'"'autosnap_2024-12-16_21:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 91638604096 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_3'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_1/l1_3/l2_0@autosnap_2024-12-16_21:00:03_hourly (~ 81.2 GB) to new target filesystem:
81.2GiB 0:12:35 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_3/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_1/l1_3/l2_0'"'"'@'"'"'autosnap_2024-12-16_21:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 87169167128 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_3/l2_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_1/l1_3/l2_1@autosnap_2024-12-16_21:00:03_hourly (~ 85.8 GB) to new target filesystem:
85.8GiB 0:13:20 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_3/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_1/l1_3/l2_1'"'"'@'"'"'autosnap_2024-12-16_21:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 92074979096 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_3/l2_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_1/l1_3/l2_2@autosnap_2024-12-16_21:00:03_hourly (~ 86.5 GB) to new target filesystem:
86.5GiB 0:13:29 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_3/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_1/l1_3/l2_2'"'"'@'"'"'autosnap_2024-12-16_21:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 92872383872 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_3/l2_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_1/l1_3/l2_3@autosnap_2024-12-16_21:00:03_hourly (~ 77.5 GB) to new target filesystem:
77.5GiB 0:11:56 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_3/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_1/l1_3/l2_3'"'"'@'"'"'autosnap_2024-12-16_21:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 83167635272 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_1/l1_3/l2_3'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_2@autosnap_2024-12-16_21:00:03_hourly (~ 89.7 GB) to new target filesystem:
89.7GiB 0:13:56 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_2'"'"'@'"'"'autosnap_2024-12-16_21:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 96316874152 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_2/l1_0@autosnap_2024-12-16_21:00:03_hourly (~ 54.0 GB) to new target filesystem:
54.1GiB 0:08:28 [ 108MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_2/l1_0'"'"'@'"'"'autosnap_2024-12-16_21:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 58017171128 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_2/l1_0/l2_0@autosnap_2024-12-16_22:00:04_hourly (~ 84.1 GB) to new target filesystem:
84.1GiB 0:13:05 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_0/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_2/l1_0/l2_0'"'"'@'"'"'autosnap_2024-12-16_22:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 90300836800 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_0/l2_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_2/l1_0/l2_1@autosnap_2024-12-16_22:00:04_hourly (~ 71.7 GB) to new target filesystem:
71.8GiB 0:11:06 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_0/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_2/l1_0/l2_1'"'"'@'"'"'autosnap_2024-12-16_22:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 77019276000 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_0/l2_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_2/l1_0/l2_2@autosnap_2024-12-16_22:00:04_hourly (~ 78.2 GB) to new target filesystem:
78.2GiB 0:12:11 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_0/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_2/l1_0/l2_2'"'"'@'"'"'autosnap_2024-12-16_22:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 83979392008 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_0/l2_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_2/l1_0/l2_3@autosnap_2024-12-16_22:00:04_hourly (~ 74.7 GB) to new target filesystem:
74.8GiB 0:11:38 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_0/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_2/l1_0/l2_3'"'"'@'"'"'autosnap_2024-12-16_22:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 80261856992 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_0/l2_3'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_2/l1_1@autosnap_2024-12-16_22:00:04_hourly (~ 74.8 GB) to new target filesystem:
74.8GiB 0:11:40 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_2/l1_1'"'"'@'"'"'autosnap_2024-12-16_22:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 80327056408 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_2/l1_1/l2_0@autosnap_2024-12-16_22:00:04_hourly (~ 64.3 GB) to new target filesystem:
64.4GiB 0:10:04 [ 108MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_1/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_2/l1_1/l2_0'"'"'@'"'"'autosnap_2024-12-16_22:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 69067853240 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_1/l2_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_2/l1_1/l2_1@autosnap_2024-12-16_22:00:04_hourly (~ 72.2 GB) to new target filesystem:
72.2GiB 0:11:09 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_1/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_2/l1_1/l2_1'"'"'@'"'"'autosnap_2024-12-16_22:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 77486383336 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_1/l2_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_2/l1_1/l2_2@autosnap_2024-12-16_22:00:04_hourly (~ 93.6 GB) to new target filesystem:
93.6GiB 0:14:35 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_1/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_2/l1_1/l2_2'"'"'@'"'"'autosnap_2024-12-16_22:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 100504953224 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_1/l2_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_2/l1_1/l2_3@autosnap_2024-12-16_22:00:04_hourly (~ 45.1 GB) to new target filesystem:
45.1GiB 0:07:05 [ 108MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_1/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_2/l1_1/l2_3'"'"'@'"'"'autosnap_2024-12-16_22:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 48399304600 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_1/l2_3'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_2/l1_2@autosnap_2024-12-16_23:00:04_hourly (~ 66.7 GB) to new target filesystem:
66.7GiB 0:10:17 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_2/l1_2'"'"'@'"'"'autosnap_2024-12-16_23:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 71575144264 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_2/l1_2/l2_0@autosnap_2024-12-16_23:00:04_hourly (~ 78.5 GB) to new target filesystem:
78.5GiB 0:12:15 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_2/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_2/l1_2/l2_0'"'"'@'"'"'autosnap_2024-12-16_23:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 84258257760 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_2/l2_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_2/l1_2/l2_1@autosnap_2024-12-16_23:00:04_hourly (~ 77.0 GB) to new target filesystem:
77.1GiB 0:12:05 [ 108MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_2/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_2/l1_2/l2_1'"'"'@'"'"'autosnap_2024-12-16_23:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 82717455864 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_2/l2_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_2/l1_2/l2_2@autosnap_2024-12-16_23:00:04_hourly (~ 73.0 GB) to new target filesystem:
73.0GiB 0:11:26 [ 108MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_2/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_2/l1_2/l2_2'"'"'@'"'"'autosnap_2024-12-16_23:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 78391418032 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_2/l2_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_2/l1_2/l2_3@autosnap_2024-12-16_23:00:04_hourly (~ 69.6 GB) to new target filesystem:
69.7GiB 0:10:55 [ 108MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_2/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_2/l1_2/l2_3'"'"'@'"'"'autosnap_2024-12-16_23:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 74764084744 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_2/l2_3'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_2/l1_3@autosnap_2024-12-16_23:00:04_hourly (~ 79.8 GB) to new target filesystem:
79.8GiB 0:12:18 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_2/l1_3'"'"'@'"'"'autosnap_2024-12-16_23:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 85679815024 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_3'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_2/l1_3/l2_0@autosnap_2024-12-16_23:00:04_hourly (~ 84.3 GB) to new target filesystem:
84.4GiB 0:13:09 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_3/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_2/l1_3/l2_0'"'"'@'"'"'autosnap_2024-12-16_23:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 90550953392 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_3/l2_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_2/l1_3/l2_1@autosnap_2024-12-16_23:00:04_hourly (~ 86.8 GB) to new target filesystem:
86.8GiB 0:13:33 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_3/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_2/l1_3/l2_1'"'"'@'"'"'autosnap_2024-12-16_23:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 93170334992 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_3/l2_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_2/l1_3/l2_2@autosnap_2024-12-16_23:00:04_hourly (~ 41.3 GB) to new target filesystem:
41.3GiB 0:06:30 [ 108MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_3/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_2/l1_3/l2_2'"'"'@'"'"'autosnap_2024-12-16_23:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 44349445448 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_3/l2_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_2/l1_3/l2_3@autosnap_2024-12-17_00:00:03_daily (~ 71.6 GB) to new target filesystem:
71.7GiB 0:11:01 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_3/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_2/l1_3/l2_3'"'"'@'"'"'autosnap_2024-12-17_00:00:03_daily'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 76910140824 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_2/l1_3/l2_3'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_3@autosnap_2024-12-17_00:00:03_daily (~ 78.3 GB) to new target filesystem:
78.3GiB 0:12:13 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_3'"'"'@'"'"'autosnap_2024-12-17_00:00:03_daily'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 84029381088 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_3/l1_0@autosnap_2024-12-17_00:00:03_daily (~ 71.6 GB) to new target filesystem:
71.7GiB 0:11:11 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_3/l1_0'"'"'@'"'"'autosnap_2024-12-17_00:00:03_daily'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 76909449544 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_3/l1_0/l2_0@autosnap_2024-12-17_00:00:03_daily (~ 81.8 GB) to new target filesystem:
81.9GiB 0:12:51 [ 108MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_0/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_3/l1_0/l2_0'"'"'@'"'"'autosnap_2024-12-17_00:00:03_daily'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 87862469512 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_0/l2_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_3/l1_0/l2_1@autosnap_2024-12-17_00:00:03_daily (~ 85.2 GB) to new target filesystem:
85.2GiB 0:13:21 [ 108MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_0/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_3/l1_0/l2_1'"'"'@'"'"'autosnap_2024-12-17_00:00:03_daily'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 91481661016 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_0/l2_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_3/l1_0/l2_2@autosnap_2024-12-17_00:00:03_daily (~ 83.3 GB) to new target filesystem:
83.3GiB 0:12:59 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_0/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_3/l1_0/l2_2'"'"'@'"'"'autosnap_2024-12-17_00:00:03_daily'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 89397356696 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_0/l2_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_3/l1_0/l2_3@autosnap_2024-12-17_00:00:03_daily (~ 92.2 GB) to new target filesystem:
92.3GiB 0:14:26 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_0/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_3/l1_0/l2_3'"'"'@'"'"'autosnap_2024-12-17_00:00:03_daily'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 99045501192 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_0/l2_3'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_3/l1_1@autosnap_2024-12-17_00:00:03_daily (~ 83.0 GB) to new target filesystem:
83.1GiB 0:13:04 [ 108MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_3/l1_1'"'"'@'"'"'autosnap_2024-12-17_00:00:03_daily'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 89142616960 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_3/l1_1/l2_0@autosnap_2024-12-17_01:00:04_hourly (~ 72.4 GB) to new target filesystem:
72.5GiB 0:11:24 [ 108MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_1/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_3/l1_1/l2_0'"'"'@'"'"'autosnap_2024-12-17_01:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 77792111328 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_1/l2_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_3/l1_1/l2_1@autosnap_2024-12-17_01:00:04_hourly (~ 87.8 GB) to new target filesystem:
87.9GiB 0:13:43 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_1/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_3/l1_1/l2_1'"'"'@'"'"'autosnap_2024-12-17_01:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 94298636144 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_1/l2_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_3/l1_1/l2_2@autosnap_2024-12-17_01:00:04_hourly (~ 87.9 GB) to new target filesystem:
87.9GiB 0:13:51 [ 108MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_1/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_3/l1_1/l2_2'"'"'@'"'"'autosnap_2024-12-17_01:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 94347475848 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_1/l2_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_3/l1_1/l2_3@autosnap_2024-12-17_01:00:04_hourly (~ 81.7 GB) to new target filesystem:
81.8GiB 0:12:53 [ 108MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_1/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_3/l1_1/l2_3'"'"'@'"'"'autosnap_2024-12-17_01:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 87768834832 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_1/l2_3'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_3/l1_2@autosnap_2024-12-17_01:00:04_hourly (~ 77.2 GB) to new target filesystem:
77.2GiB 0:12:06 [ 108MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_3/l1_2'"'"'@'"'"'autosnap_2024-12-17_01:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 82864714856 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_3/l1_2/l2_0@autosnap_2024-12-17_01:00:04_hourly (~ 68.2 GB) to new target filesystem:
68.2GiB 0:10:31 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_2/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_3/l1_2/l2_0'"'"'@'"'"'autosnap_2024-12-17_01:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 73179791872 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_2/l2_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_3/l1_2/l2_1@autosnap_2024-12-17_01:00:04_hourly (~ 75.4 GB) to new target filesystem:
75.5GiB 0:11:51 [ 108MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_2/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_3/l1_2/l2_1'"'"'@'"'"'autosnap_2024-12-17_01:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 81000656056 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_2/l2_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_3/l1_2/l2_2@autosnap_2024-12-17_01:00:04_hourly (~ 75.2 GB) to new target filesystem:
75.3GiB 0:11:43 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_2/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_3/l1_2/l2_2'"'"'@'"'"'autosnap_2024-12-17_01:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 80795552264 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_2/l2_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_3/l1_2/l2_3@autosnap_2024-12-17_01:00:04_hourly (~ 48.8 GB) to new target filesystem:
48.8GiB 0:07:32 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_2/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_3/l1_2/l2_3'"'"'@'"'"'autosnap_2024-12-17_01:00:04_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 52418486384 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_2/l2_3'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_3/l1_3@autosnap_2024-12-17_02:00:03_hourly (~ 86.9 GB) to new target filesystem:
86.9GiB 0:13:31 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_3/l1_3'"'"'@'"'"'autosnap_2024-12-17_02:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 93291962200 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_3'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_3/l1_3/l2_0@autosnap_2024-12-17_02:00:03_hourly (~ 90.3 GB) to new target filesystem:
90.3GiB 0:14:07 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_3/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_3/l1_3/l2_0'"'"'@'"'"'autosnap_2024-12-17_02:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 96924839144 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_3/l2_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_3/l1_3/l2_1@autosnap_2024-12-17_02:00:03_hourly (~ 75.8 GB) to new target filesystem:
75.9GiB 0:11:50 [ 109MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_3/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_3/l1_3/l2_1'"'"'@'"'"'autosnap_2024-12-17_02:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 81423710528 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_3/l2_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_3/l1_3/l2_2@autosnap_2024-12-17_02:00:03_hourly (~ 68.0 GB) to new target filesystem:
68.0GiB 0:10:39 [ 108MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_3/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_3/l1_3/l2_2'"'"'@'"'"'autosnap_2024-12-17_02:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 73021706400 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_3/l2_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_3/l1_3/l2_3@autosnap_2024-12-17_02:00:03_hourly (~ 87.7 GB) to new target filesystem:
87.8GiB 0:13:33 [ 110MiB/s] [================================================================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_3/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734400919 io ' zfs send  '"'"'io_tank/test/l0_3/l1_3/l2_3'"'"'@'"'"'autosnap_2024-12-17_02:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 94189722520 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734400920 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_3/l2_3'"'"'' failed: 256 at /sbin/syncoid line 492.
real 49523.14
user 26444.00
sys 28233.57

  pool: io_tank
 state: ONLINE
config:

        NAME                                               STATE     READ WRITE CKSUM
        io_tank                                            ONLINE       0     0     0
          nvme-eui.0000000001000000e4d25c8051695501-part3  ONLINE       0     0     0

errors: No known data errors
```

Repeating the `syncoid` run repets the "no snapshots matching" warning, copying here for convenience:

```text
CRITICAL ERROR: Target ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_0 exists but has no snapshots matching with io_tank/test/l0_0/l1_0/l2_0!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.


CRITICAL ERROR: Target ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_1 exists but has no snapshots matching with io_tank/test/l0_0/l1_0/l2_1!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.


CRITICAL ERROR: Target ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_2 exists but has no snapshots matching with io_tank/test/l0_0/l1_0/l2_2!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.


CRITICAL ERROR: Target ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_3 exists but has no snapshots matching with io_tank/test/l0_0/l1_0/l2_3!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.


CRITICAL ERROR: Target ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1 exists but has no snapshots matching with io_tank/test/l0_0/l1_1!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.


CRITICAL ERROR: Target ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1/l2_0 exists but has no snapshots matching with io_tank/test/l0_0/l1_1/l2_0!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.
```

I see no obvious reason for the issue. I will try sending just  `io_tank/test/l0_0/l1_0` to see how to force it. At present a repeat run is taking surprisingly long considering nothing should have been modified in `io_tank/test`.

```text
hbarta@io:~/Programming/provoke_ZFS_corruption$ /bin/time -p /sbin/syncoid --recursive --no-privilege-elevation io:io_tank olive:ST8TB-ZA20HR7B/io-backup/io_tank
Sending incremental io_tank@syncoid_io_2024-12-16:20:02:01-GMT-06:00 ... syncoid_io_2024-12-17:10:13:42-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [61.6KiB/s] [===================================================================================================] 106%            
Sending incremental io_tank/Programming@syncoid_io_2024-12-16:20:02:12-GMT-06:00 ... syncoid_io_2024-12-17:10:13:52-GMT-06:00 (~ 452 KB):
 307KiB 0:00:00 [ 953KiB/s] [==================================================================>                                 ] 67%            
Sending incremental io_tank/test@syncoid_io_2024-12-16:20:02:22-GMT-06:00 ... syncoid_io_2024-12-17:10:14:03-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [57.3KiB/s] [===================================================================================================] 106%            
Sending incremental io_tank/test/l0_0@syncoid_io_2024-12-16:20:02:33-GMT-06:00 ... syncoid_io_2024-12-17:10:14:13-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [55.4KiB/s] [===================================================================================================] 106%            
Sending incremental io_tank/test/l0_0/l1_0@syncoid_io_2024-12-16:20:02:43-GMT-06:00 ... syncoid_io_2024-12-17:10:14:23-GMT-06:00 (~ 15 KB):
16.1KiB 0:00:00 [51.7KiB/s] [===================================================================================================] 106%            

CRITICAL ERROR: Target ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_0 exists but has no snapshots matching with io_tank/test/l0_0/l1_0/l2_0!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.


CRITICAL ERROR: Target ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_1 exists but has no snapshots matching with io_tank/test/l0_0/l1_0/l2_1!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.


CRITICAL ERROR: Target ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_2 exists but has no snapshots matching with io_tank/test/l0_0/l1_0/l2_2!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.


CRITICAL ERROR: Target ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_3 exists but has no snapshots matching with io_tank/test/l0_0/l1_0/l2_3!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.


CRITICAL ERROR: Target ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1 exists but has no snapshots matching with io_tank/test/l0_0/l1_1!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.


CRITICAL ERROR: Target ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1/l2_0 exists but has no snapshots matching with io_tank/test/l0_0/l1_1/l2_0!
                Replication to target would require destroying existing
                target. Cowardly refusing to destroy your existing target.

Sending incremental io_tank/test/l0_0/l1_1/l2_1@autosnap_2024-12-16_17:00:12_hourly ... syncoid_io_2024-12-17:10:14:37-GMT-06:00 (~ 81 KB):
32.9KiB 0:00:00 [70.6KiB/s] [=======================================>                                                            ] 40%            
Sending incremental io_tank/test/l0_0/l1_1/l2_2@autosnap_2024-12-16_17:00:12_hourly ... syncoid_io_2024-12-17:10:14:51-GMT-06:00 (~ 81 KB):
28.2KiB 0:00:00 [63.9KiB/s] [=================================>                                                                  ] 34%            
Sending incremental io_tank/test/l0_0/l1_1/l2_3@autosnap_2024-12-16_17:00:12_hourly ... syncoid_io_2024-12-17:10:15:06-GMT-06:00 (~ 38.2 GB):
38.2GiB 0:05:35 [ 116MiB/s] [==================================================================================================>] 100%            
Sending incremental io_tank/test/l0_0/l1_2@autosnap_2024-12-16_18:00:04_hourly ... syncoid_io_2024-12-17:10:20:55-GMT-06:00 (~ 81 KB):
36.8KiB 0:00:00 [86.7KiB/s] [===========================================>                                                        ] 44%            
Sending incremental io_tank/test/l0_0/l1_2/l2_0@autosnap_2024-12-16_18:00:04_hourly ... syncoid_io_2024-12-17:10:21:09-GMT-06:00 (~ 81 KB):
38.4KiB 0:00:00 [87.2KiB/s] [=============================================>                                                      ] 46%            
Sending incremental io_tank/test/l0_0/l1_2/l2_1@autosnap_2024-12-16_18:00:04_hourly ... syncoid_io_2024-12-17:10:21:24-GMT-06:00 (~ 81 KB):
30.5KiB 0:00:00 [66.0KiB/s] [====================================>                                                               ] 37%            
Sending incremental io_tank/test/l0_0/l1_2/l2_2@autosnap_2024-12-16_18:00:04_hourly ... syncoid_io_2024-12-17:10:21:38-GMT-06:00 (~ 81 KB):
34.5KiB 0:00:00 [76.7KiB/s] [=========================================>                                                          ] 42%            
Sending incremental io_tank/test/l0_0/l1_2/l2_3@autosnap_2024-12-16_18:00:04_hourly ... syncoid_io_2024-12-17:10:21:52-GMT-06:00 (~ 81 KB):
32.9KiB 0:00:00 [73.8KiB/s] [=======================================>                                                            ] 40%            
Sending incremental io_tank/test/l0_0/l1_3@autosnap_2024-12-16_18:00:04_hourly ... syncoid_io_2024-12-17:10:22:06-GMT-06:00 (~ 165 KB):
47.2KiB 0:00:00 [ 106KiB/s] [===========================>                                                                        ] 28%            
Sending incremental io_tank/test/l0_0/l1_3/l2_0@autosnap_2024-12-16_18:00:04_hourly ... syncoid_io_2024-12-17:10:22:20-GMT-06:00 (~ 81 KB):
36.8KiB 0:00:00 [77.4KiB/s] [===========================================>                                                        ] 44%            
Sending incremental io_tank/test/l0_0/l1_3/l2_1@autosnap_2024-12-16_18:00:04_hourly ... syncoid_io_2024-12-17:10:22:34-GMT-06:00 (~ 18.0 GB):
18.0GiB 0:02:43 [ 112MiB/s] [==================================================================================================>] 100%            
Sending incremental io_tank/test/l0_0/l1_3/l2_2@autosnap_2024-12-16_19:00:03_hourly ... syncoid_io_2024-12-17:10:25:31-GMT-06:00 (~ 81 KB):
35.4KiB 0:00:00 [81.1KiB/s] [==========================================>                                                         ] 43%            
Sending incremental io_tank/test/l0_0/l1_3/l2_3@autosnap_2024-12-16_19:00:03_hourly ... syncoid_io_2024-12-17:10:25:45-GMT-06:00 (~ 81 KB):
28.4KiB 0:00:00 [64.2KiB/s] [=================================>                                                                  ] 34%            
Sending incremental io_tank/test/l0_1@autosnap_2024-12-16_19:00:03_hourly ... syncoid_io_2024-12-17:10:25:59-GMT-06:00 (~ 264 KB):
69.0KiB 0:00:00 [ 169KiB/s] [=========================>                                                                          ] 26%            
Sending incremental io_tank/test/l0_1/l1_0@autosnap_2024-12-16_19:00:03_hourly ... syncoid_io_2024-12-17:10:26:13-GMT-06:00 (~ 81 KB):
32.3KiB 0:00:00 [72.8KiB/s] [======================================>                                                             ] 39%            
Sending incremental io_tank/test/l0_1/l1_0/l2_0@autosnap_2024-12-16_19:00:03_hourly ... syncoid_io_2024-12-17:10:26:27-GMT-06:00 (~ 81 KB):
31.5KiB 0:00:00 [71.1KiB/s] [=====================================>                                                              ] 38%            
Sending incremental io_tank/test/l0_1/l1_0/l2_1@autosnap_2024-12-16_19:00:03_hourly ... syncoid_io_2024-12-17:10:26:41-GMT-06:00 (~ 81 KB):
34.6KiB 0:00:00 [78.7KiB/s] [=========================================>                                                          ] 42%            
Sending incremental io_tank/test/l0_1/l1_0/l2_2@autosnap_2024-12-16_19:00:03_hourly ... syncoid_io_2024-12-17:10:26:55-GMT-06:00 (~ 81 KB):
33.1KiB 0:00:00 [73.0KiB/s] [=======================================>                                                            ] 40%            
Sending incremental io_tank/test/l0_1/l1_0/l2_3@autosnap_2024-12-16_19:00:03_hourly ... syncoid_io_2024-12-17:10:27:09-GMT-06:00 (~ 27.4 GB):
27.4GiB 0:04:23 [ 106MiB/s] [==================================================================================================>] 100%            
Sending incremental io_tank/test/l0_1/l1_1@autosnap_2024-12-16_20:00:04_hourly ... syncoid_io_2024-12-17:10:31:47-GMT-06:00 (~ 80 KB):
35.0KiB 0:00:00 [87.5KiB/s] [==========================================>                                                         ] 43%            
Sending incremental io_tank/test/l0_1/l1_1/l2_0@autosnap_2024-12-16_20:00:04_hourly ... syncoid_io_2024-12-17:10:32:00-GMT-06:00 (~ 80 KB):
33.4KiB 0:00:00 [79.5KiB/s] [========================================>                                                           ] 41%            
Sending incremental io_tank/test/l0_1/l1_1/l2_1@autosnap_2024-12-16_20:00:04_hourly ... syncoid_io_2024-12-17:10:32:13-GMT-06:00 (~ 80 KB):
33.4KiB 0:00:00 [76.6KiB/s] [========================================>                                                           ] 41%            
Sending incremental io_tank/test/l0_1/l1_1/l2_2@autosnap_2024-12-16_20:00:04_hourly ... syncoid_io_2024-12-17:10:32:27-GMT-06:00 (~ 80 KB):
32.6KiB 0:00:00 [79.1KiB/s] [=======================================>                                                            ] 40%            
Sending incremental io_tank/test/l0_1/l1_1/l2_3@autosnap_2024-12-16_20:00:04_hourly ... syncoid_io_2024-12-17:10:32:40-GMT-06:00 (~ 80 KB):
31.8KiB 0:00:00 [77.9KiB/s] [======================================>                                                             ] 39%            
Sending incremental io_tank/test/l0_1/l1_2@autosnap_2024-12-16_20:00:04_hourly ... syncoid_io_2024-12-17:10:32:53-GMT-06:00 (~ 163 KB):
65.2KiB 0:00:00 [ 157KiB/s] [======================================>                                                             ] 39%            
Sending incremental io_tank/test/l0_1/l1_2/l2_0@autosnap_2024-12-16_20:00:04_hourly ... syncoid_io_2024-12-17:10:33:06-GMT-06:00 (~ 80 KB):
35.0KiB 0:00:00 [85.0KiB/s] [==========================================>                                                         ] 43%            
Sending incremental io_tank/test/l0_1/l1_2/l2_1@autosnap_2024-12-16_20:00:04_hourly ... syncoid_io_2024-12-17:10:33:19-GMT-06:00 (~ 80 KB):
27.9KiB 0:00:00 [67.5KiB/s] [=================================>                                                                  ] 34%            
Sending incremental io_tank/test/l0_1/l1_2/l2_2@autosnap_2024-12-16_20:00:04_hourly ... syncoid_io_2024-12-17:10:33:32-GMT-06:00 (~ 54.7 GB):
54.7GiB 0:08:25 [ 110MiB/s] [==================================================================================================>] 100%            
Sending incremental io_tank/test/l0_1/l1_2/l2_3@autosnap_2024-12-16_21:00:03_hourly ... syncoid_io_2024-12-17:10:42:11-GMT-06:00 (~ 79 KB):
28.9KiB 0:00:00 [71.0KiB/s] [===================================>                                                                ] 36%            
Sending incremental io_tank/test/l0_1/l1_3@autosnap_2024-12-16_21:00:03_hourly ... syncoid_io_2024-12-17:10:42:24-GMT-06:00 (~ 79 KB):
25.8KiB 0:00:00 [67.0KiB/s] [===============================>                                                                    ] 32%            
Sending incremental io_tank/test/l0_1/l1_3/l2_0@autosnap_2024-12-16_21:00:03_hourly ... syncoid_io_2024-12-17:10:42:36-GMT-06:00 (~ 79 KB):
32.8KiB 0:00:00 [79.0KiB/s] [========================================>                                                           ] 41%            
Sending incremental io_tank/test/l0_1/l1_3/l2_1@autosnap_2024-12-16_21:00:03_hourly ... syncoid_io_2024-12-17:10:42:49-GMT-06:00 (~ 79 KB):
25.8KiB 0:00:00 [63.4KiB/s] [===============================>                                                                    ] 32%            
Sending incremental io_tank/test/l0_1/l1_3/l2_2@autosnap_2024-12-16_21:00:03_hourly ... syncoid_io_2024-12-17:10:43:03-GMT-06:00 (~ 79 KB):
28.9KiB 0:00:00 [69.2KiB/s] [===================================>                                                                ] 36%            
Sending incremental io_tank/test/l0_1/l1_3/l2_3@autosnap_2024-12-16_21:00:03_hourly ... syncoid_io_2024-12-17:10:43:16-GMT-06:00 (~ 79 KB):
31.2KiB 0:00:00 [75.9KiB/s] [======================================>                                                             ] 39%            
Sending incremental io_tank/test/l0_2@autosnap_2024-12-16_21:00:03_hourly ... syncoid_io_2024-12-17:10:43:29-GMT-06:00 (~ 171 KB):
62.3KiB 0:00:00 [ 168KiB/s] [===================================>                                                                ] 36%            
Sending incremental io_tank/test/l0_2/l1_0@autosnap_2024-12-16_21:00:03_hourly ... syncoid_io_2024-12-17:10:43:41-GMT-06:00 (~ 20.8 GB):
20.8GiB 0:03:19 [ 106MiB/s] [==================================================================================================>] 100%            
Sending incremental io_tank/test/l0_2/l1_0/l2_0@autosnap_2024-12-16_22:00:04_hourly ... syncoid_io_2024-12-17:10:47:13-GMT-06:00 (~ 18 KB):
19.8KiB 0:00:00 [48.5KiB/s] [===================================================================================================] 104%            
Sending incremental io_tank/test/l0_2/l1_0/l2_1@autosnap_2024-12-16_22:00:04_hourly ... syncoid_io_2024-12-17:10:47:25-GMT-06:00 (~ 18 KB):
19.8KiB 0:00:00 [50.7KiB/s] [===================================================================================================] 104%            
Sending incremental io_tank/test/l0_2/l1_0/l2_2@autosnap_2024-12-16_22:00:04_hourly ... syncoid_io_2024-12-17:10:47:37-GMT-06:00 (~ 18 KB):
19.8KiB 0:00:00 [50.3KiB/s] [===================================================================================================] 104%            
Sending incremental io_tank/test/l0_2/l1_0/l2_3@autosnap_2024-12-16_22:00:04_hourly ... syncoid_io_2024-12-17:10:47:49-GMT-06:00 (~ 18 KB):
19.8KiB 0:00:00 [50.2KiB/s] [===================================================================================================] 104%            
Sending incremental io_tank/test/l0_2/l1_1@autosnap_2024-12-16_22:00:04_hourly ... syncoid_io_2024-12-17:10:48:02-GMT-06:00 (~ 18 KB):
19.8KiB 0:00:00 [54.6KiB/s] [===================================================================================================] 104%            
Sending incremental io_tank/test/l0_2/l1_1/l2_0@autosnap_2024-12-16_22:00:04_hourly ... syncoid_io_2024-12-17:10:48:14-GMT-06:00 (~ 18 KB):
19.8KiB 0:00:00 [50.2KiB/s] [===================================================================================================] 104%            
Sending incremental io_tank/test/l0_2/l1_1/l2_1@autosnap_2024-12-16_22:00:04_hourly ... syncoid_io_2024-12-17:10:48:26-GMT-06:00 (~ 18 KB):
19.8KiB 0:00:00 [48.5KiB/s] [===================================================================================================] 104%            
Sending incremental io_tank/test/l0_2/l1_1/l2_2@autosnap_2024-12-16_22:00:04_hourly ... syncoid_io_2024-12-17:10:48:38-GMT-06:00 (~ 18 KB):
19.8KiB 0:00:00 [50.1KiB/s] [===================================================================================================] 104%            
Sending incremental io_tank/test/l0_2/l1_1/l2_3@autosnap_2024-12-16_22:00:04_hourly ... syncoid_io_2024-12-17:10:48:50-GMT-06:00 (~ 30.0 GB):
30.0GiB 0:04:41 [ 108MiB/s] [==================================================================================================>] 100%            
Sending incremental io_tank/test/l0_2/l1_2@autosnap_2024-12-16_23:00:04_hourly ... syncoid_io_2024-12-17:10:53:44-GMT-06:00 (~ 18 KB):
19.2KiB 0:00:00 [51.0KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_2/l1_2/l2_0@autosnap_2024-12-16_23:00:04_hourly ... syncoid_io_2024-12-17:10:53:56-GMT-06:00 (~ 18 KB):
19.2KiB 0:00:00 [49.9KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_2/l1_2/l2_1@autosnap_2024-12-16_23:00:04_hourly ... syncoid_io_2024-12-17:10:54:08-GMT-06:00 (~ 18 KB):
19.2KiB 0:00:00 [49.2KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_2/l1_2/l2_2@autosnap_2024-12-16_23:00:04_hourly ... syncoid_io_2024-12-17:10:54:20-GMT-06:00 (~ 18 KB):
19.2KiB 0:00:00 [47.9KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_2/l1_2/l2_3@autosnap_2024-12-16_23:00:04_hourly ... syncoid_io_2024-12-17:10:54:32-GMT-06:00 (~ 18 KB):
19.2KiB 0:00:00 [50.8KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_2/l1_3@autosnap_2024-12-16_23:00:04_hourly ... syncoid_io_2024-12-17:10:54:43-GMT-06:00 (~ 101 KB):
35.1KiB 0:00:00 [95.7KiB/s] [=================================>                                                                  ] 34%            
Sending incremental io_tank/test/l0_2/l1_3/l2_0@autosnap_2024-12-16_23:00:04_hourly ... syncoid_io_2024-12-17:10:54:55-GMT-06:00 (~ 18 KB):
19.2KiB 0:00:00 [49.4KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_2/l1_3/l2_1@autosnap_2024-12-16_23:00:04_hourly ... syncoid_io_2024-12-17:10:55:09-GMT-06:00 (~ 18 KB):
19.2KiB 0:00:00 [50.1KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_2/l1_3/l2_2@autosnap_2024-12-16_23:00:04_hourly ... syncoid_io_2024-12-17:10:55:30-GMT-06:00 (~ 38.9 GB):
38.9GiB 0:06:08 [ 108MiB/s] [==================================================================================================>] 100%            
Sending incremental io_tank/test/l0_2/l1_3/l2_3@autosnap_2024-12-17_00:00:03_daily ... syncoid_io_2024-12-17:11:01:50-GMT-06:00 (~ 18 KB):
19.2KiB 0:00:00 [50.7KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_3@autosnap_2024-12-17_00:00:03_daily ... syncoid_io_2024-12-17:11:02:02-GMT-06:00 (~ 185 KB):
63.7KiB 0:00:00 [ 174KiB/s] [=================================>                                                                  ] 34%            
Sending incremental io_tank/test/l0_3/l1_0@autosnap_2024-12-17_00:00:03_daily ... syncoid_io_2024-12-17:11:02:14-GMT-06:00 (~ 18 KB):
19.2KiB 0:00:00 [53.9KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_3/l1_0/l2_0@autosnap_2024-12-17_00:00:03_daily ... syncoid_io_2024-12-17:11:02:25-GMT-06:00 (~ 18 KB):
19.2KiB 0:00:00 [48.8KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_3/l1_0/l2_1@autosnap_2024-12-17_00:00:03_daily ... syncoid_io_2024-12-17:11:02:38-GMT-06:00 (~ 18 KB):
19.2KiB 0:00:00 [49.2KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_3/l1_0/l2_2@autosnap_2024-12-17_00:00:03_daily ... syncoid_io_2024-12-17:11:02:50-GMT-06:00 (~ 18 KB):
19.2KiB 0:00:00 [53.4KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_3/l1_0/l2_3@autosnap_2024-12-17_00:00:03_daily ... syncoid_io_2024-12-17:11:03:03-GMT-06:00 (~ 18 KB):
19.2KiB 0:00:00 [51.1KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_3/l1_1@autosnap_2024-12-17_00:00:03_daily ... syncoid_io_2024-12-17:11:03:15-GMT-06:00 (~ 4.0 GB):
3.99GiB 0:00:37 [ 108MiB/s] [==================================================================================================>] 100%            
Sending incremental io_tank/test/l0_3/l1_1/l2_0@autosnap_2024-12-17_01:00:04_hourly ... syncoid_io_2024-12-17:11:04:04-GMT-06:00 (~ 17 KB):
18.0KiB 0:00:00 [50.7KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_3/l1_1/l2_1@autosnap_2024-12-17_01:00:04_hourly ... syncoid_io_2024-12-17:11:04:16-GMT-06:00 (~ 17 KB):
18.0KiB 0:00:00 [48.3KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_3/l1_1/l2_2@autosnap_2024-12-17_01:00:04_hourly ... syncoid_io_2024-12-17:11:04:27-GMT-06:00 (~ 17 KB):
18.0KiB 0:00:00 [46.5KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_3/l1_1/l2_3@autosnap_2024-12-17_01:00:04_hourly ... syncoid_io_2024-12-17:11:04:38-GMT-06:00 (~ 17 KB):
18.0KiB 0:00:00 [50.3KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_3/l1_2@autosnap_2024-12-17_01:00:04_hourly ... syncoid_io_2024-12-17:11:04:49-GMT-06:00 (~ 17 KB):
18.0KiB 0:00:00 [51.2KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_3/l1_2/l2_0@autosnap_2024-12-17_01:00:04_hourly ... syncoid_io_2024-12-17:11:05:00-GMT-06:00 (~ 17 KB):
18.0KiB 0:00:00 [49.5KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_3/l1_2/l2_1@autosnap_2024-12-17_01:00:04_hourly ... syncoid_io_2024-12-17:11:05:12-GMT-06:00 (~ 17 KB):
18.0KiB 0:00:00 [48.9KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_3/l1_2/l2_2@autosnap_2024-12-17_01:00:04_hourly ... syncoid_io_2024-12-17:11:05:23-GMT-06:00 (~ 17 KB):
18.0KiB 0:00:00 [48.7KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_3/l1_2/l2_3@autosnap_2024-12-17_01:00:04_hourly ... syncoid_io_2024-12-17:11:05:34-GMT-06:00 (~ 46.9 GB):
46.9GiB 0:07:14 [ 110MiB/s] [==================================================================================================>] 100%            
Sending incremental io_tank/test/l0_3/l1_3@autosnap_2024-12-17_02:00:03_hourly ... syncoid_io_2024-12-17:11:12:59-GMT-06:00 (~ 16 KB):
17.4KiB 0:00:00 [52.4KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_3/l1_3/l2_0@autosnap_2024-12-17_02:00:03_hourly ... syncoid_io_2024-12-17:11:13:10-GMT-06:00 (~ 16 KB):
17.4KiB 0:00:00 [49.1KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_3/l1_3/l2_1@autosnap_2024-12-17_02:00:03_hourly ... syncoid_io_2024-12-17:11:13:21-GMT-06:00 (~ 16 KB):
17.4KiB 0:00:00 [49.1KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_3/l1_3/l2_2@autosnap_2024-12-17_02:00:03_hourly ... syncoid_io_2024-12-17:11:13:31-GMT-06:00 (~ 16 KB):
17.4KiB 0:00:00 [50.2KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_3/l1_3/l2_3@autosnap_2024-12-17_02:00:03_hourly ... syncoid_io_2024-12-17:11:13:42-GMT-06:00 (~ 16 KB):
17.4KiB 0:00:00 [46.8KiB/s] [===================================================================================================] 105%            
real 3612.09
user 1394.66
sys 1472.35
hbarta@io:~/Programming/provoke_ZFS_corruption$ 
```

Command for a subset of the pool should be (with the addition of `--force`)

```text
/bin/time -p /sbin/syncoid --recursive --no-privilege-elevation --force io:io_tank/test/l0_0/l1_0 olive:ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0
```

```text
hbarta@io:~/Programming/provoke_ZFS_corruption$ /bin/time -p /sbin/syncoid --recursive --no-privilege-elevation --force io:io_tank/test/l0_0/l1_0 olive:ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0
Sending incremental io_tank/test/l0_0/l1_0@syncoid_io_2024-12-17:11:35:23-GMT-06:00 ... syncoid_io_2024-12-17:11:35:46-GMT-06:00 (~ 4 KB):
1.52KiB 0:00:00 [13.3KiB/s] [=====================================>                                                              ] 38%            
Removing ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_0 because no matching snapshots were found
NEWEST SNAPSHOT: syncoid_io_2024-12-17:11:35:48-GMT-06:00
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_0/l2_0@syncoid_io_2024-12-16:10:50:05-GMT-06:00 (~ 40.4 GB) to new target filesystem:
40.4GiB 0:05:55 [ 116MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734456945 io ' zfs send  '"'"'io_tank/test/l0_0/l1_0/l2_0'"'"'@'"'"'syncoid_io_2024-12-16:10:50:05-GMT-06:00'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 43407854840 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734456945 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_0'"'"'' failed: 256 at /sbin/syncoid line 492.
Removing ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_1 because no matching snapshots were found
NEWEST SNAPSHOT: syncoid_io_2024-12-17:11:41:45-GMT-06:00
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_0/l2_1@syncoid_io_2024-12-16:10:59:34-GMT-06:00 (~ 66.8 GB) to new target filesystem:
66.8GiB 0:10:24 [ 109MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734456945 io ' zfs send  '"'"'io_tank/test/l0_0/l1_0/l2_1'"'"'@'"'"'syncoid_io_2024-12-16:10:59:34-GMT-06:00'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 71677394736 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734456945 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_1'"'"'' failed: 256 at /sbin/syncoid line 492.
Removing ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_2 because no matching snapshots were found
NEWEST SNAPSHOT: syncoid_io_2024-12-17:11:52:11-GMT-06:00
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_0/l2_2@autosnap_2024-12-16_17:00:12_hourly (~ 83.8 GB) to new target filesystem:
83.8GiB 0:13:00 [ 109MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734456945 io ' zfs send  '"'"'io_tank/test/l0_0/l1_0/l2_2'"'"'@'"'"'autosnap_2024-12-16_17:00:12_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 89932524272 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734456945 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_2'"'"'' failed: 256 at /sbin/syncoid line 492.
Removing ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_3 because no matching snapshots were found
NEWEST SNAPSHOT: syncoid_io_2024-12-17:12:05:13-GMT-06:00
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_0/l2_3@autosnap_2024-12-16_17:00:12_hourly (~ 78.9 GB) to new target filesystem:
79.0GiB 0:12:20 [ 109MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734456945 io ' zfs send  '"'"'io_tank/test/l0_0/l1_0/l2_3'"'"'@'"'"'autosnap_2024-12-16_17:00:12_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 84771173440 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734456945 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_3'"'"'' failed: 256 at /sbin/syncoid line 492.
real 2510.04
user 1343.95
sys 1415.57
hbarta@io:~/Programming/provoke_ZFS_corruption$
```

Now the rest.

```text
/bin/time -p /sbin/syncoid --recursive --no-privilege-elevation --force io:io_tank/test/l0_0/l1_1 olive:ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1
```

```text
hbarta@io:~$ /bin/time -p /sbin/syncoid --recursive --no-privilege-elevation --force io:io_tank/test/l0_0/l1_1 olive:ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1
Removing ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1 because no matching snapshots were found
NEWEST SNAPSHOT: syncoid_io_2024-12-17:12:33:22-GMT-06:00
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_1@autosnap_2024-12-16_17:00:12_hourly (~ 81.8 GB) to new target filesystem:
81.9GiB 0:12:44 [ 109MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734460400 io ' zfs send  '"'"'io_tank/test/l0_0/l1_1'"'"'@'"'"'autosnap_2024-12-16_17:00:12_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 87864526600 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734460401 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_1/l2_0@autosnap_2024-12-16_17:00:12_hourly (~ 74.5 GB) to new target filesystem:
74.5GiB 0:11:29 [ 110MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734460400 io ' zfs send  '"'"'io_tank/test/l0_0/l1_1/l2_0'"'"'@'"'"'autosnap_2024-12-16_17:00:12_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 79968036432 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734460401 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1/l2_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_1/l2_1@autosnap_2024-12-16_17:00:12_hourly (~ 45.1 GB) to new target filesystem:
45.1GiB 0:07:05 [ 108MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734460400 io ' zfs send  '"'"'io_tank/test/l0_0/l1_1/l2_1'"'"'@'"'"'autosnap_2024-12-16_17:00:12_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 48395566456 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734460401 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1/l2_1'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_1/l2_2@autosnap_2024-12-16_17:00:12_hourly (~ 43.6 GB) to new target filesystem:
43.7GiB 0:06:42 [ 110MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1/l2_2': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734460400 io ' zfs send  '"'"'io_tank/test/l0_0/l1_1/l2_2'"'"'@'"'"'autosnap_2024-12-16_17:00:12_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 46855248624 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734460401 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1/l2_2'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_1/l2_3@autosnap_2024-12-16_17:00:12_hourly (~ 1.3 GB) to new target filesystem:
1.31GiB 0:00:12 [ 108MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1/l2_3': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734460400 io ' zfs send  '"'"'io_tank/test/l0_0/l1_1/l2_3'"'"'@'"'"'autosnap_2024-12-16_17:00:12_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 1406056880 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734460401 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_1/l2_3'"'"'' failed: 256 at /sbin/syncoid line 492.
real 2303.90
user 1225.54
sys 1310.03
hbarta@io:~$ 
```

One last 'cleanup' before we start stirring the pool.

```text
hbarta@io:~/Programming/provoke_ZFS_corruption$ /bin/time -p /sbin/syncoid --recursive --no-privilege-elevation io:io_tank/test/l0_0/l1_0 olive:ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0
hbarta@io:~$ /bin/time -p /sbin/syncoid --recursive --no-privilege-elevation io:io_tank olive:ST8TB-ZA20HR7B/io-backup/io_tank
Sending incremental io_tank@syncoid_io_2024-12-17:10:13:42-GMT-06:00 ... syncoid_io_2024-12-17:14:18:20-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [49.3KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/Programming@syncoid_io_2024-12-17:10:13:52-GMT-06:00 ... syncoid_io_2024-12-17:14:18:27-GMT-06:00 (~ 1.2 MB):
 802KiB 0:00:00 [2.55MiB/s] [=================================================================>                                  ] 66%            
Sending incremental io_tank/test@syncoid_io_2024-12-17:10:14:03-GMT-06:00 ... syncoid_io_2024-12-17:14:18:33-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [47.1KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_0@syncoid_io_2024-12-17:10:14:13-GMT-06:00 ... syncoid_io_2024-12-17:14:18:39-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [45.8KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_0/l1_0@syncoid_io_2024-12-17:11:35:46-GMT-06:00 ... syncoid_io_2024-12-17:14:18:45-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [41.5KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_0/l1_0/l2_0@syncoid_io_2024-12-16:10:50:05-GMT-06:00 ... syncoid_io_2024-12-17:14:18:51-GMT-06:00 (~ 86 KB):
33.1KiB 0:00:00 [64.2KiB/s] [=====================================>                                                              ] 38%            
Sending incremental io_tank/test/l0_0/l1_0/l2_1@syncoid_io_2024-12-16:10:59:34-GMT-06:00 ... syncoid_io_2024-12-17:14:19:08-GMT-06:00 (~ 86 KB):
39.3KiB 0:00:00 [77.2KiB/s] [============================================>                                                       ] 45%            
Sending incremental io_tank/test/l0_0/l1_0/l2_2@autosnap_2024-12-16_17:00:12_hourly ... syncoid_io_2024-12-17:14:19:24-GMT-06:00 (~ 86 KB):
34.6KiB 0:00:00 [67.2KiB/s] [======================================>                                                             ] 39%            
Sending incremental io_tank/test/l0_0/l1_0/l2_3@autosnap_2024-12-16_17:00:12_hourly ... syncoid_io_2024-12-17:14:19:40-GMT-06:00 (~ 86 KB):
41.7KiB 0:00:00 [79.5KiB/s] [===============================================>                                                    ] 48%            
Sending incremental io_tank/test/l0_0/l1_1@autosnap_2024-12-16_17:00:12_hourly ... syncoid_io_2024-12-17:14:19:56-GMT-06:00 (~ 86 KB):
42.6KiB 0:00:00 [89.0KiB/s] [================================================>                                                   ] 49%            
Sending incremental io_tank/test/l0_0/l1_1/l2_0@autosnap_2024-12-16_17:00:12_hourly ... syncoid_io_2024-12-17:14:20:12-GMT-06:00 (~ 86 KB):
33.2KiB 0:00:00 [64.1KiB/s] [=====================================>                                                              ] 38%            
Sending incremental io_tank/test/l0_0/l1_1/l2_1@autosnap_2024-12-16_17:00:12_hourly ... syncoid_io_2024-12-17:14:20:27-GMT-06:00 (~ 84 KB):
35.9KiB 0:00:00 [70.8KiB/s] [=========================================>                                                          ] 42%            
Sending incremental io_tank/test/l0_0/l1_1/l2_2@autosnap_2024-12-16_17:00:12_hourly ... syncoid_io_2024-12-17:14:20:43-GMT-06:00 (~ 84 KB):
31.2KiB 0:00:00 [61.8KiB/s] [===================================>                                                                ] 36%            
Sending incremental io_tank/test/l0_0/l1_1/l2_3@autosnap_2024-12-16_17:00:12_hourly ... syncoid_io_2024-12-17:14:20:58-GMT-06:00 (~ 38.2 GB):
38.2GiB 0:05:54 [ 110MiB/s] [==================================================================================================>] 100%            
Sending incremental io_tank/test/l0_0/l1_2@syncoid_io_2024-12-17:10:20:55-GMT-06:00 ... syncoid_io_2024-12-17:14:27:07-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [42.8KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_0/l1_2/l2_0@syncoid_io_2024-12-17:10:21:09-GMT-06:00 ... syncoid_io_2024-12-17:14:27:13-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [40.9KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_0/l1_2/l2_1@syncoid_io_2024-12-17:10:21:24-GMT-06:00 ... syncoid_io_2024-12-17:14:27:19-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [41.0KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_0/l1_2/l2_2@syncoid_io_2024-12-17:10:21:38-GMT-06:00 ... syncoid_io_2024-12-17:14:27:26-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [40.9KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_0/l1_2/l2_3@syncoid_io_2024-12-17:10:21:52-GMT-06:00 ... syncoid_io_2024-12-17:14:27:32-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [39.3KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_0/l1_3@syncoid_io_2024-12-17:10:22:06-GMT-06:00 ... syncoid_io_2024-12-17:14:27:38-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [42.4KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_0/l1_3/l2_0@syncoid_io_2024-12-17:10:22:20-GMT-06:00 ... syncoid_io_2024-12-17:14:27:45-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [40.9KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_0/l1_3/l2_1@syncoid_io_2024-12-17:10:22:34-GMT-06:00 ... syncoid_io_2024-12-17:14:27:52-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [40.1KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_0/l1_3/l2_2@syncoid_io_2024-12-17:10:25:31-GMT-06:00 ... syncoid_io_2024-12-17:14:27:58-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [38.2KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_0/l1_3/l2_3@syncoid_io_2024-12-17:10:25:45-GMT-06:00 ... syncoid_io_2024-12-17:14:28:05-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [39.2KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_1@syncoid_io_2024-12-17:10:25:59-GMT-06:00 ... syncoid_io_2024-12-17:14:28:11-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [45.7KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_1/l1_0@syncoid_io_2024-12-17:10:26:13-GMT-06:00 ... syncoid_io_2024-12-17:14:28:17-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [41.4KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_1/l1_0/l2_0@syncoid_io_2024-12-17:10:26:27-GMT-06:00 ... syncoid_io_2024-12-17:14:28:23-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [40.2KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_1/l1_0/l2_1@syncoid_io_2024-12-17:10:26:41-GMT-06:00 ... syncoid_io_2024-12-17:14:28:30-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [41.2KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_1/l1_0/l2_2@syncoid_io_2024-12-17:10:26:55-GMT-06:00 ... syncoid_io_2024-12-17:14:28:36-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [40.3KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_1/l1_0/l2_3@syncoid_io_2024-12-17:10:27:09-GMT-06:00 ... syncoid_io_2024-12-17:14:28:42-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [40.0KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_1/l1_1@syncoid_io_2024-12-17:10:31:47-GMT-06:00 ... syncoid_io_2024-12-17:14:28:49-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [42.7KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_1/l1_1/l2_0@syncoid_io_2024-12-17:10:32:00-GMT-06:00 ... syncoid_io_2024-12-17:14:28:55-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [40.9KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_1/l1_1/l2_1@syncoid_io_2024-12-17:10:32:13-GMT-06:00 ... syncoid_io_2024-12-17:14:29:02-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [38.7KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_1/l1_1/l2_2@syncoid_io_2024-12-17:10:32:27-GMT-06:00 ... syncoid_io_2024-12-17:14:29:08-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [38.6KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_1/l1_1/l2_3@syncoid_io_2024-12-17:10:32:40-GMT-06:00 ... syncoid_io_2024-12-17:14:29:14-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [40.1KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_1/l1_2@syncoid_io_2024-12-17:10:32:53-GMT-06:00 ... syncoid_io_2024-12-17:14:29:21-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [42.9KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_1/l1_2/l2_0@syncoid_io_2024-12-17:10:33:06-GMT-06:00 ... syncoid_io_2024-12-17:14:29:27-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [39.7KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_1/l1_2/l2_1@syncoid_io_2024-12-17:10:33:19-GMT-06:00 ... syncoid_io_2024-12-17:14:29:33-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [40.3KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_1/l1_2/l2_2@syncoid_io_2024-12-17:10:33:32-GMT-06:00 ... syncoid_io_2024-12-17:14:29:40-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [40.7KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_1/l1_2/l2_3@syncoid_io_2024-12-17:10:42:11-GMT-06:00 ... syncoid_io_2024-12-17:14:29:47-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [39.7KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_1/l1_3@syncoid_io_2024-12-17:10:42:24-GMT-06:00 ... syncoid_io_2024-12-17:14:29:53-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [42.0KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_1/l1_3/l2_0@syncoid_io_2024-12-17:10:42:36-GMT-06:00 ... syncoid_io_2024-12-17:14:30:00-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [39.7KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_1/l1_3/l2_1@syncoid_io_2024-12-17:10:42:49-GMT-06:00 ... syncoid_io_2024-12-17:14:30:07-GMT-06:00 (~ 9 KB):
10.7KiB 0:00:00 [37.7KiB/s] [===================================================================================================] 109%            
Sending incremental io_tank/test/l0_1/l1_3/l2_2@syncoid_io_2024-12-17:10:43:03-GMT-06:00 ... syncoid_io_2024-12-17:14:30:14-GMT-06:00 (~ 9 KB):
10.7KiB 0:00:00 [36.2KiB/s] [===================================================================================================] 109%            
Sending incremental io_tank/test/l0_1/l1_3/l2_3@syncoid_io_2024-12-17:10:43:16-GMT-06:00 ... syncoid_io_2024-12-17:14:30:21-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [35.3KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_2@syncoid_io_2024-12-17:10:43:29-GMT-06:00 ... syncoid_io_2024-12-17:14:30:28-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [38.9KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_2/l1_0@syncoid_io_2024-12-17:10:43:41-GMT-06:00 ... syncoid_io_2024-12-17:14:30:35-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [41.4KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_2/l1_0/l2_0@syncoid_io_2024-12-17:10:47:13-GMT-06:00 ... syncoid_io_2024-12-17:14:30:46-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [41.2KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_2/l1_0/l2_1@syncoid_io_2024-12-17:10:47:25-GMT-06:00 ... syncoid_io_2024-12-17:14:30:58-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [39.7KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_2/l1_0/l2_2@syncoid_io_2024-12-17:10:47:37-GMT-06:00 ... syncoid_io_2024-12-17:14:31:09-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [39.1KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_2/l1_0/l2_3@syncoid_io_2024-12-17:10:47:49-GMT-06:00 ... syncoid_io_2024-12-17:14:31:21-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [39.9KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_2/l1_1@syncoid_io_2024-12-17:10:48:02-GMT-06:00 ... syncoid_io_2024-12-17:14:31:33-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [42.5KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_2/l1_1/l2_0@syncoid_io_2024-12-17:10:48:14-GMT-06:00 ... syncoid_io_2024-12-17:14:31:44-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [39.4KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_2/l1_1/l2_1@syncoid_io_2024-12-17:10:48:26-GMT-06:00 ... syncoid_io_2024-12-17:14:31:54-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [40.6KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_2/l1_1/l2_2@syncoid_io_2024-12-17:10:48:38-GMT-06:00 ... syncoid_io_2024-12-17:14:32:05-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [40.8KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_2/l1_1/l2_3@syncoid_io_2024-12-17:10:48:50-GMT-06:00 ... syncoid_io_2024-12-17:14:32:16-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [40.5KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_2/l1_2@syncoid_io_2024-12-17:10:53:44-GMT-06:00 ... syncoid_io_2024-12-17:14:32:27-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [42.3KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_2/l1_2/l2_0@syncoid_io_2024-12-17:10:53:56-GMT-06:00 ... syncoid_io_2024-12-17:14:32:38-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [39.8KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_2/l1_2/l2_1@syncoid_io_2024-12-17:10:54:08-GMT-06:00 ... syncoid_io_2024-12-17:14:32:48-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [38.9KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_2/l1_2/l2_2@syncoid_io_2024-12-17:10:54:20-GMT-06:00 ... syncoid_io_2024-12-17:14:32:55-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [40.7KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_2/l1_2/l2_3@syncoid_io_2024-12-17:10:54:32-GMT-06:00 ... syncoid_io_2024-12-17:14:33:01-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [37.9KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_2/l1_3@syncoid_io_2024-12-17:10:54:43-GMT-06:00 ... syncoid_io_2024-12-17:14:33:07-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [42.9KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_2/l1_3/l2_0@syncoid_io_2024-12-17:10:54:55-GMT-06:00 ... syncoid_io_2024-12-17:14:33:13-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [41.0KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_2/l1_3/l2_1@syncoid_io_2024-12-17:10:55:09-GMT-06:00 ... syncoid_io_2024-12-17:14:33:20-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [40.2KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_2/l1_3/l2_2@syncoid_io_2024-12-17:10:55:30-GMT-06:00 ... syncoid_io_2024-12-17:14:33:26-GMT-06:00 (~ 9 KB):
10.1KiB 0:00:00 [40.7KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_2/l1_3/l2_3@syncoid_io_2024-12-17:11:01:50-GMT-06:00 ... syncoid_io_2024-12-17:14:33:33-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [36.9KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_3@syncoid_io_2024-12-17:11:02:02-GMT-06:00 ... syncoid_io_2024-12-17:14:33:39-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [45.5KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_3/l1_0@syncoid_io_2024-12-17:11:02:14-GMT-06:00 ... syncoid_io_2024-12-17:14:33:45-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [41.2KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_3/l1_0/l2_0@syncoid_io_2024-12-17:11:02:25-GMT-06:00 ... syncoid_io_2024-12-17:14:33:51-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [38.1KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_3/l1_0/l2_1@syncoid_io_2024-12-17:11:02:38-GMT-06:00 ... syncoid_io_2024-12-17:14:33:57-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [38.6KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_3/l1_0/l2_2@syncoid_io_2024-12-17:11:02:50-GMT-06:00 ... syncoid_io_2024-12-17:14:34:03-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [39.2KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_3/l1_0/l2_3@syncoid_io_2024-12-17:11:03:03-GMT-06:00 ... syncoid_io_2024-12-17:14:34:09-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [38.5KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_3/l1_1@syncoid_io_2024-12-17:11:03:15-GMT-06:00 ... syncoid_io_2024-12-17:14:34:16-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [42.7KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_3/l1_1/l2_0@syncoid_io_2024-12-17:11:04:04-GMT-06:00 ... syncoid_io_2024-12-17:14:34:21-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [40.1KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_3/l1_1/l2_1@syncoid_io_2024-12-17:11:04:16-GMT-06:00 ... syncoid_io_2024-12-17:14:34:28-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [40.6KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_3/l1_1/l2_2@syncoid_io_2024-12-17:11:04:27-GMT-06:00 ... syncoid_io_2024-12-17:14:34:34-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [39.5KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_3/l1_1/l2_3@syncoid_io_2024-12-17:11:04:38-GMT-06:00 ... syncoid_io_2024-12-17:14:34:40-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [38.9KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_3/l1_2@syncoid_io_2024-12-17:11:04:49-GMT-06:00 ... syncoid_io_2024-12-17:14:34:46-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [41.5KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_3/l1_2/l2_0@syncoid_io_2024-12-17:11:05:00-GMT-06:00 ... syncoid_io_2024-12-17:14:34:52-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [38.7KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_3/l1_2/l2_1@syncoid_io_2024-12-17:11:05:12-GMT-06:00 ... syncoid_io_2024-12-17:14:34:58-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [39.0KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_3/l1_2/l2_2@syncoid_io_2024-12-17:11:05:23-GMT-06:00 ... syncoid_io_2024-12-17:14:35:04-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [36.2KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_3/l1_2/l2_3@syncoid_io_2024-12-17:11:05:34-GMT-06:00 ... syncoid_io_2024-12-17:14:35:10-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [39.6KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_3/l1_3@syncoid_io_2024-12-17:11:12:59-GMT-06:00 ... syncoid_io_2024-12-17:14:35:16-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [41.9KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_3/l1_3/l2_0@syncoid_io_2024-12-17:11:13:10-GMT-06:00 ... syncoid_io_2024-12-17:14:35:22-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [39.8KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_3/l1_3/l2_1@syncoid_io_2024-12-17:11:13:21-GMT-06:00 ... syncoid_io_2024-12-17:14:35:29-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [39.1KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_3/l1_3/l2_2@syncoid_io_2024-12-17:11:13:31-GMT-06:00 ... syncoid_io_2024-12-17:14:35:35-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [39.6KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/test/l0_3/l1_3/l2_3@syncoid_io_2024-12-17:11:13:42-GMT-06:00 ... syncoid_io_2024-12-17:14:35:41-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [38.9KiB/s] [===================================================================================================] 110%            
real 1048.56
user 210.03
sys 226.17
hbarta@io:~$ 
```

Still one "big" one.

```text
Sending incremental io_tank/test/l0_0/l1_1/l2_3@autosnap_2024-12-16_17:00:12_hourly ... syncoid_io_2024-12-17:14:20:58-GMT-06:00 (~ 38.2 GB):
38.2GiB 0:05:54 [ 110MiB/s] [==================================================================================================>] 100%            
```

Post stir result

```text
hbarta@io:~$ /bin/time -p /sbin/syncoid --recursive --no-privilege-elevation io:io_tank olive:ST8TB-ZA20HR7B/io-backup/io_tank
Sending incremental io_tank@syncoid_io_2024-12-17:14:18:20-GMT-06:00 ... syncoid_io_2024-12-17:17:37:10-GMT-06:00 (~ 8 KB):
9.45KiB 0:00:00 [50.7KiB/s] [===================================================================================================] 110%            
Sending incremental io_tank/Programming@syncoid_io_2024-12-17:14:18:27-GMT-06:00 ... syncoid_io_2024-12-17:17:37:16-GMT-06:00 (~ 68 KB):
22.0KiB 0:00:00 [ 107KiB/s] [===============================>                                                                    ] 32%            
Sending incremental io_tank/test@syncoid_io_2024-12-17:14:18:33-GMT-06:00 ... syncoid_io_2024-12-17:17:37:21-GMT-06:00 (~ 69 KB):
14.5KiB 0:00:00 [65.9KiB/s] [===================>                                                                                ] 20%            
Sending incremental io_tank/test/l0_0@syncoid_io_2024-12-17:14:18:39-GMT-06:00 ... syncoid_io_2024-12-17:17:37:27-GMT-06:00 (~ 1.1 MB):
 850KiB 0:00:00 [2.55MiB/s] [=======================================================================>                            ] 72%            
Sending incremental io_tank/test/l0_0/l1_0@syncoid_io_2024-12-17:14:18:45-GMT-06:00 ... syncoid_io_2024-12-17:17:37:33-GMT-06:00 (~ 1.1 MB):
 850KiB 0:00:00 [2.46MiB/s] [========================================================================>                           ] 73%            
Sending incremental io_tank/test/l0_0/l1_0/l2_0@syncoid_io_2024-12-17:14:18:51-GMT-06:00 ... syncoid_io_2024-12-17:17:37:40-GMT-06:00 (~ 1.4 MB):
 976KiB 0:00:00 [2.65MiB/s] [=====================================================================>                              ] 70%            
Sending incremental io_tank/test/l0_0/l1_0/l2_1@syncoid_io_2024-12-17:14:19:08-GMT-06:00 ... syncoid_io_2024-12-17:17:37:46-GMT-06:00 (~ 1.0 MB):
 892KiB 0:00:00 [2.20MiB/s] [==================================================================================>                 ] 83%            
Sending incremental io_tank/test/l0_0/l1_0/l2_2@syncoid_io_2024-12-17:14:19:24-GMT-06:00 ... syncoid_io_2024-12-17:17:37:53-GMT-06:00 (~ 3.2 MB):
2.33MiB 0:00:00 [5.21MiB/s] [=======================================================================>                            ] 72%            
Sending incremental io_tank/test/l0_0/l1_0/l2_3@syncoid_io_2024-12-17:14:19:40-GMT-06:00 ... syncoid_io_2024-12-17:17:38:00-GMT-06:00 (~ 1.6 MB):
1.08MiB 0:00:00 [3.38MiB/s] [===================================================================>                                ] 68%            
Sending incremental io_tank/test/l0_0/l1_1@syncoid_io_2024-12-17:14:19:56-GMT-06:00 ... syncoid_io_2024-12-17:17:38:06-GMT-06:00 (~ 1.6 MB):
1.18MiB 0:00:00 [3.26MiB/s] [=======================================================================>                            ] 72%            
Sending incremental io_tank/test/l0_0/l1_1/l2_0@syncoid_io_2024-12-17:14:20:12-GMT-06:00 ... syncoid_io_2024-12-17:17:38:13-GMT-06:00 (~ 2.3 MB):
1.55MiB 0:00:00 [4.46MiB/s] [==================================================================>                                 ] 67%            
Sending incremental io_tank/test/l0_0/l1_1/l2_1@syncoid_io_2024-12-17:14:20:27-GMT-06:00 ... syncoid_io_2024-12-17:17:38:20-GMT-06:00 (~ 1.6 MB):
1.08MiB 0:00:00 [3.21MiB/s] [====================================================================>                               ] 69%            
Sending incremental io_tank/test/l0_0/l1_1/l2_2@syncoid_io_2024-12-17:14:20:43-GMT-06:00 ... syncoid_io_2024-12-17:17:38:26-GMT-06:00 (~ 1.2 MB):
 948KiB 0:00:00 [2.53MiB/s] [=========================================================================>                          ] 74%            
Sending incremental io_tank/test/l0_0/l1_1/l2_3@syncoid_io_2024-12-17:14:20:58-GMT-06:00 ... syncoid_io_2024-12-17:17:38:32-GMT-06:00 (~ 1.5 MB):
1.08MiB 0:00:00 [3.18MiB/s] [=====================================================================>                              ] 70%            
Sending incremental io_tank/test/l0_0/l1_2@syncoid_io_2024-12-17:14:27:07-GMT-06:00 ... syncoid_io_2024-12-17:17:38:38-GMT-06:00 (~ 1.6 MB):
1.21MiB 0:00:00 [3.35MiB/s] [=========================================================================>                          ] 74%            
Sending incremental io_tank/test/l0_0/l1_2/l2_0@syncoid_io_2024-12-17:14:27:13-GMT-06:00 ... syncoid_io_2024-12-17:17:38:44-GMT-06:00 (~ 1.3 MB):
 976KiB 0:00:00 [2.78MiB/s] [=========================================================================>                          ] 74%            
Sending incremental io_tank/test/l0_0/l1_2/l2_1@syncoid_io_2024-12-17:14:27:19-GMT-06:00 ... syncoid_io_2024-12-17:17:38:50-GMT-06:00 (~ 1.8 MB):
1.30MiB 0:00:00 [3.60MiB/s] [=======================================================================>                            ] 72%            
Sending incremental io_tank/test/l0_0/l1_2/l2_2@syncoid_io_2024-12-17:14:27:26-GMT-06:00 ... syncoid_io_2024-12-17:17:38:56-GMT-06:00 (~ 1.3 MB):
 976KiB 0:00:00 [2.64MiB/s] [=========================================================================>                          ] 74%            
Sending incremental io_tank/test/l0_0/l1_2/l2_3@syncoid_io_2024-12-17:14:27:32-GMT-06:00 ... syncoid_io_2024-12-17:17:39:02-GMT-06:00 (~ 1.2 MB):
 848KiB 0:00:00 [2.66MiB/s] [===================================================================>                                ] 68%            
Sending incremental io_tank/test/l0_0/l1_3@syncoid_io_2024-12-17:14:27:38-GMT-06:00 ... syncoid_io_2024-12-17:17:39:08-GMT-06:00 (~ 1.1 MB):
 823KiB 0:00:00 [2.37MiB/s] [==========================================================================>                         ] 75%            
Sending incremental io_tank/test/l0_0/l1_3/l2_0@syncoid_io_2024-12-17:14:27:45-GMT-06:00 ... syncoid_io_2024-12-17:17:39:14-GMT-06:00 (~ 1.8 MB):
1.33MiB 0:00:00 [3.50MiB/s] [========================================================================>                           ] 73%            
Sending incremental io_tank/test/l0_0/l1_3/l2_1@syncoid_io_2024-12-17:14:27:52-GMT-06:00 ... syncoid_io_2024-12-17:17:39:20-GMT-06:00 (~ 1.7 MB):
1.20MiB 0:00:00 [3.33MiB/s] [====================================================================>                               ] 69%            
Sending incremental io_tank/test/l0_0/l1_3/l2_2@syncoid_io_2024-12-17:14:27:58-GMT-06:00 ... syncoid_io_2024-12-17:17:39:26-GMT-06:00 (~ 1.2 MB):
 848KiB 0:00:00 [2.34MiB/s] [======================================================================>                             ] 71%            
Sending incremental io_tank/test/l0_0/l1_3/l2_3@syncoid_io_2024-12-17:14:28:05-GMT-06:00 ... syncoid_io_2024-12-17:17:39:32-GMT-06:00 (~ 1.3 MB):
 976KiB 0:00:00 [2.54MiB/s] [========================================================================>                           ] 73%            
Sending incremental io_tank/test/l0_1@syncoid_io_2024-12-17:14:28:11-GMT-06:00 ... syncoid_io_2024-12-17:17:39:38-GMT-06:00 (~ 1.8 MB):
1.33MiB 0:00:00 [3.90MiB/s] [=========================================================================>                          ] 74%            
Sending incremental io_tank/test/l0_1/l1_0@syncoid_io_2024-12-17:14:28:17-GMT-06:00 ... syncoid_io_2024-12-17:17:39:44-GMT-06:00 (~ 1.4 MB):
1.08MiB 0:00:00 [3.14MiB/s] [==========================================================================>                         ] 75%            
Sending incremental io_tank/test/l0_1/l1_0/l2_0@syncoid_io_2024-12-17:14:28:23-GMT-06:00 ... syncoid_io_2024-12-17:17:39:50-GMT-06:00 (~ 1.4 MB):
1.08MiB 0:00:00 [3.04MiB/s] [===========================================================================>                        ] 76%            
Sending incremental io_tank/test/l0_1/l1_0/l2_1@syncoid_io_2024-12-17:14:28:30-GMT-06:00 ... syncoid_io_2024-12-17:17:39:56-GMT-06:00 (~ 1.2 MB):
 848KiB 0:00:00 [2.12MiB/s] [===================================================================>                                ] 68%            
Sending incremental io_tank/test/l0_1/l1_0/l2_2@syncoid_io_2024-12-17:14:28:36-GMT-06:00 ... syncoid_io_2024-12-17:17:40:02-GMT-06:00 (~ 1.9 MB):
1.45MiB 0:00:00 [3.64MiB/s] [============================================================================>                       ] 77%            
Sending incremental io_tank/test/l0_1/l1_0/l2_3@syncoid_io_2024-12-17:14:28:42-GMT-06:00 ... syncoid_io_2024-12-17:17:40:08-GMT-06:00 (~ 1.3 MB):
 976KiB 0:00:00 [2.61MiB/s] [=========================================================================>                          ] 74%            
Sending incremental io_tank/test/l0_1/l1_1@syncoid_io_2024-12-17:14:28:49-GMT-06:00 ... syncoid_io_2024-12-17:17:40:14-GMT-06:00 (~ 1.5 MB):
1.08MiB 0:00:00 [3.15MiB/s] [========================================================================>                           ] 73%            
Sending incremental io_tank/test/l0_1/l1_1/l2_0@syncoid_io_2024-12-17:14:28:55-GMT-06:00 ... syncoid_io_2024-12-17:17:40:20-GMT-06:00 (~ 1.4 MB):
 948KiB 0:00:00 [2.89MiB/s] [=================================================================>                                  ] 66%            
Sending incremental io_tank/test/l0_1/l1_1/l2_1@syncoid_io_2024-12-17:14:29:02-GMT-06:00 ... syncoid_io_2024-12-17:17:40:26-GMT-06:00 (~ 1.3 MB):
 976KiB 0:00:00 [2.87MiB/s] [======================================================================>                             ] 71%            
Sending incremental io_tank/test/l0_1/l1_1/l2_2@syncoid_io_2024-12-17:14:29:08-GMT-06:00 ... syncoid_io_2024-12-17:17:40:32-GMT-06:00 (~ 1021 KB):
 720KiB 0:00:00 [2.26MiB/s] [=====================================================================>                              ] 70%            
Sending incremental io_tank/test/l0_1/l1_1/l2_3@syncoid_io_2024-12-17:14:29:14-GMT-06:00 ... syncoid_io_2024-12-17:17:40:38-GMT-06:00 (~ 873 KB):
 692KiB 0:00:00 [1.97MiB/s] [==============================================================================>                     ] 79%            
Sending incremental io_tank/test/l0_1/l1_2@syncoid_io_2024-12-17:14:29:21-GMT-06:00 ... syncoid_io_2024-12-17:17:40:44-GMT-06:00 (~ 1.4 MB):
1.08MiB 0:00:00 [3.07MiB/s] [===========================================================================>                        ] 76%            
Sending incremental io_tank/test/l0_1/l1_2/l2_0@syncoid_io_2024-12-17:14:29:27-GMT-06:00 ... syncoid_io_2024-12-17:17:40:50-GMT-06:00 (~ 1.3 MB):
1.08MiB 0:00:00 [2.78MiB/s] [==============================================================================>                     ] 79%            
Sending incremental io_tank/test/l0_1/l1_2/l2_1@syncoid_io_2024-12-17:14:29:33-GMT-06:00 ... syncoid_io_2024-12-17:17:40:56-GMT-06:00 (~ 1.3 MB):
 948KiB 0:00:00 [2.72MiB/s] [=====================================================================>                              ] 70%            
Sending incremental io_tank/test/l0_1/l1_2/l2_2@syncoid_io_2024-12-17:14:29:40-GMT-06:00 ... syncoid_io_2024-12-17:17:41:02-GMT-06:00 (~ 1.1 MB):
 848KiB 0:00:00 [2.34MiB/s] [==========================================================================>                         ] 75%            
Sending incremental io_tank/test/l0_1/l1_2/l2_3@syncoid_io_2024-12-17:14:29:47-GMT-06:00 ... syncoid_io_2024-12-17:17:41:08-GMT-06:00 (~ 1.5 MB):
1.18MiB 0:00:00 [3.14MiB/s] [============================================================================>                       ] 77%            
Sending incremental io_tank/test/l0_1/l1_3@syncoid_io_2024-12-17:14:29:53-GMT-06:00 ... syncoid_io_2024-12-17:17:41:15-GMT-06:00 (~ 1.2 MB):
 851KiB 0:00:00 [2.59MiB/s] [==================================================================>                                 ] 67%            
Sending incremental io_tank/test/l0_1/l1_3/l2_0@syncoid_io_2024-12-17:14:30:00-GMT-06:00 ... syncoid_io_2024-12-17:17:41:21-GMT-06:00 (~ 1.5 MB):
1.08MiB 0:00:00 [2.85MiB/s] [========================================================================>                           ] 73%            
Sending incremental io_tank/test/l0_1/l1_3/l2_1@syncoid_io_2024-12-17:14:30:07-GMT-06:00 ... syncoid_io_2024-12-17:17:41:27-GMT-06:00 (~ 1.3 MB):
1.08MiB 0:00:00 [2.70MiB/s] [=================================================================================>                  ] 82%            
Sending incremental io_tank/test/l0_1/l1_3/l2_2@syncoid_io_2024-12-17:14:30:14-GMT-06:00 ... syncoid_io_2024-12-17:17:41:33-GMT-06:00 (~ 2.0 MB):
1.45MiB 0:00:00 [4.24MiB/s] [=======================================================================>                            ] 72%            
Sending incremental io_tank/test/l0_1/l1_3/l2_3@syncoid_io_2024-12-17:14:30:21-GMT-06:00 ... syncoid_io_2024-12-17:17:41:39-GMT-06:00 (~ 1.7 MB):
1.20MiB 0:00:00 [3.46MiB/s] [===================================================================>                                ] 68%            
Sending incremental io_tank/test/l0_2@syncoid_io_2024-12-17:14:30:28-GMT-06:00 ... syncoid_io_2024-12-17:17:41:46-GMT-06:00 (~ 726 KB):
 594KiB 0:00:00 [1.81MiB/s] [================================================================================>                   ] 81%            
Sending incremental io_tank/test/l0_2/l1_0@syncoid_io_2024-12-17:14:30:35-GMT-06:00 ... syncoid_io_2024-12-17:17:41:52-GMT-06:00 (~ 1.5 MB):
1.05MiB 0:00:00 [3.03MiB/s] [=======================================================================>                            ] 72%            
Sending incremental io_tank/test/l0_2/l1_0/l2_0@syncoid_io_2024-12-17:14:30:46-GMT-06:00 ... syncoid_io_2024-12-17:17:41:58-GMT-06:00 (~ 1.5 MB):
1.08MiB 0:00:00 [3.04MiB/s] [=======================================================================>                            ] 72%            
Sending incremental io_tank/test/l0_2/l1_0/l2_1@syncoid_io_2024-12-17:14:30:58-GMT-06:00 ... syncoid_io_2024-12-17:17:42:04-GMT-06:00 (~ 1.0 MB):
 848KiB 0:00:00 [2.22MiB/s] [==============================================================================>                     ] 79%            
Sending incremental io_tank/test/l0_2/l1_0/l2_2@syncoid_io_2024-12-17:14:31:09-GMT-06:00 ... syncoid_io_2024-12-17:17:42:10-GMT-06:00 (~ 1.9 MB):
1.33MiB 0:00:00 [3.84MiB/s] [======================================================================>                             ] 71%            
Sending incremental io_tank/test/l0_2/l1_0/l2_3@syncoid_io_2024-12-17:14:31:21-GMT-06:00 ... syncoid_io_2024-12-17:17:42:16-GMT-06:00 (~ 1.2 MB):
 848KiB 0:00:00 [2.77MiB/s] [===================================================================>                                ] 68%            
Sending incremental io_tank/test/l0_2/l1_1@syncoid_io_2024-12-17:14:31:33-GMT-06:00 ... syncoid_io_2024-12-17:17:42:22-GMT-06:00 (~ 1.5 MB):
1.08MiB 0:00:00 [3.30MiB/s] [=====================================================================>                              ] 70%            
Sending incremental io_tank/test/l0_2/l1_1/l2_0@syncoid_io_2024-12-17:14:31:44-GMT-06:00 ... syncoid_io_2024-12-17:17:42:28-GMT-06:00 (~ 1.9 MB):
1.33MiB 0:00:00 [3.90MiB/s] [=====================================================================>                              ] 70%            
Sending incremental io_tank/test/l0_2/l1_1/l2_1@syncoid_io_2024-12-17:14:31:54-GMT-06:00 ... syncoid_io_2024-12-17:17:42:34-GMT-06:00 (~ 1.7 MB):
1.08MiB 0:00:00 [3.83MiB/s] [=============================================================>                                      ] 62%            
Sending incremental io_tank/test/l0_2/l1_1/l2_2@syncoid_io_2024-12-17:14:32:05-GMT-06:00 ... syncoid_io_2024-12-17:17:42:39-GMT-06:00 (~ 1.8 MB):
1.33MiB 0:00:00 [3.67MiB/s] [========================================================================>                           ] 73%            
Sending incremental io_tank/test/l0_2/l1_1/l2_3@syncoid_io_2024-12-17:14:32:16-GMT-06:00 ... syncoid_io_2024-12-17:17:42:45-GMT-06:00 (~ 1.2 MB):
 848KiB 0:00:00 [2.60MiB/s] [===================================================================>                                ] 68%            
Sending incremental io_tank/test/l0_2/l1_2@syncoid_io_2024-12-17:14:32:27-GMT-06:00 ... syncoid_io_2024-12-17:17:42:51-GMT-06:00 (~ 1.2 MB):
 949KiB 0:00:00 [2.63MiB/s] [==============================================================================>                     ] 79%            
Sending incremental io_tank/test/l0_2/l1_2/l2_0@syncoid_io_2024-12-17:14:32:38-GMT-06:00 ... syncoid_io_2024-12-17:17:42:57-GMT-06:00 (~ 1.1 MB):
 848KiB 0:00:00 [2.39MiB/s] [===========================================================================>                        ] 76%            
Sending incremental io_tank/test/l0_2/l1_2/l2_1@syncoid_io_2024-12-17:14:32:48-GMT-06:00 ... syncoid_io_2024-12-17:17:43:02-GMT-06:00 (~ 1.6 MB):
1.05MiB 0:00:00 [3.25MiB/s] [==================================================================>                                 ] 67%            
Sending incremental io_tank/test/l0_2/l1_2/l2_2@syncoid_io_2024-12-17:14:32:55-GMT-06:00 ... syncoid_io_2024-12-17:17:43:08-GMT-06:00 (~ 1.4 MB):
1.08MiB 0:00:00 [2.95MiB/s] [==============================================================================>                     ] 79%            
Sending incremental io_tank/test/l0_2/l1_2/l2_3@syncoid_io_2024-12-17:14:33:01-GMT-06:00 ... syncoid_io_2024-12-17:17:43:14-GMT-06:00 (~ 2.2 MB):
1.58MiB 0:00:00 [4.30MiB/s] [======================================================================>                             ] 71%            
Sending incremental io_tank/test/l0_2/l1_3@syncoid_io_2024-12-17:14:33:07-GMT-06:00 ... syncoid_io_2024-12-17:17:43:19-GMT-06:00 (~ 1.3 MB):
 951KiB 0:00:00 [2.93MiB/s] [=====================================================================>                              ] 70%            
Sending incremental io_tank/test/l0_2/l1_3/l2_0@syncoid_io_2024-12-17:14:33:13-GMT-06:00 ... syncoid_io_2024-12-17:17:43:25-GMT-06:00 (~ 1.7 MB):
1.30MiB 0:00:00 [3.38MiB/s] [===========================================================================>                        ] 76%            
Sending incremental io_tank/test/l0_2/l1_3/l2_1@syncoid_io_2024-12-17:14:33:20-GMT-06:00 ... syncoid_io_2024-12-17:17:43:31-GMT-06:00 (~ 1.2 MB):
 848KiB 0:00:00 [2.49MiB/s] [======================================================================>                             ] 71%            
Sending incremental io_tank/test/l0_2/l1_3/l2_2@syncoid_io_2024-12-17:14:33:26-GMT-06:00 ... syncoid_io_2024-12-17:17:43:37-GMT-06:00 (~ 1.6 MB):
1.20MiB 0:00:00 [3.23MiB/s] [=========================================================================>                          ] 74%            
Sending incremental io_tank/test/l0_2/l1_3/l2_3@syncoid_io_2024-12-17:14:33:33-GMT-06:00 ... syncoid_io_2024-12-17:17:43:43-GMT-06:00 (~ 1.3 MB):
 976KiB 0:00:00 [2.70MiB/s] [======================================================================>                             ] 71%            
Sending incremental io_tank/test/l0_3@syncoid_io_2024-12-17:14:33:39-GMT-06:00 ... syncoid_io_2024-12-17:17:43:48-GMT-06:00 (~ 1.9 MB):
1.33MiB 0:00:00 [3.98MiB/s] [======================================================================>                             ] 71%            
Sending incremental io_tank/test/l0_3/l1_0@syncoid_io_2024-12-17:14:33:45-GMT-06:00 ... syncoid_io_2024-12-17:17:43:54-GMT-06:00 (~ 1.6 MB):
1.08MiB 0:00:00 [3.49MiB/s] [====================================================================>                               ] 69%            
Sending incremental io_tank/test/l0_3/l1_0/l2_0@syncoid_io_2024-12-17:14:33:51-GMT-06:00 ... syncoid_io_2024-12-17:17:44:00-GMT-06:00 (~ 1.2 MB):
 948KiB 0:00:00 [2.71MiB/s] [=========================================================================>                          ] 74%            
Sending incremental io_tank/test/l0_3/l1_0/l2_1@syncoid_io_2024-12-17:14:33:57-GMT-06:00 ... syncoid_io_2024-12-17:17:44:06-GMT-06:00 (~ 1.2 MB):
 976KiB 0:00:00 [2.74MiB/s] [=============================================================================>                      ] 78%            
Sending incremental io_tank/test/l0_3/l1_0/l2_2@syncoid_io_2024-12-17:14:34:03-GMT-06:00 ... syncoid_io_2024-12-17:17:44:11-GMT-06:00 (~ 1.3 MB):
 976KiB 0:00:00 [2.57MiB/s] [=========================================================================>                          ] 74%            
Sending incremental io_tank/test/l0_3/l1_0/l2_3@syncoid_io_2024-12-17:14:34:09-GMT-06:00 ... syncoid_io_2024-12-17:17:44:17-GMT-06:00 (~ 873 KB):
 692KiB 0:00:00 [1.97MiB/s] [==============================================================================>                     ] 79%            
Sending incremental io_tank/test/l0_3/l1_1@syncoid_io_2024-12-17:14:34:16-GMT-06:00 ... syncoid_io_2024-12-17:17:44:23-GMT-06:00 (~ 1.1 MB):
 723KiB 0:00:00 [2.43MiB/s] [================================================================>                                   ] 65%            
Sending incremental io_tank/test/l0_3/l1_1/l2_0@syncoid_io_2024-12-17:14:34:21-GMT-06:00 ... syncoid_io_2024-12-17:17:44:29-GMT-06:00 (~ 1.6 MB):
1.08MiB 0:00:00 [3.25MiB/s] [=================================================================>                                  ] 66%            
Sending incremental io_tank/test/l0_3/l1_1/l2_1@syncoid_io_2024-12-17:14:34:28-GMT-06:00 ... syncoid_io_2024-12-17:17:44:35-GMT-06:00 (~ 1.1 MB):
 848KiB 0:00:00 [2.32MiB/s] [==========================================================================>                         ] 75%            
Sending incremental io_tank/test/l0_3/l1_1/l2_2@syncoid_io_2024-12-17:14:34:34-GMT-06:00 ... syncoid_io_2024-12-17:17:44:41-GMT-06:00 (~ 1.4 MB):
1.08MiB 0:00:00 [3.10MiB/s] [===========================================================================>                        ] 76%            
Sending incremental io_tank/test/l0_3/l1_1/l2_3@syncoid_io_2024-12-17:14:34:40-GMT-06:00 ... syncoid_io_2024-12-17:17:44:47-GMT-06:00 (~ 1.5 MB):
1.08MiB 0:00:00 [3.19MiB/s] [========================================================================>                           ] 73%            
Sending incremental io_tank/test/l0_3/l1_2@syncoid_io_2024-12-17:14:34:46-GMT-06:00 ... syncoid_io_2024-12-17:17:44:53-GMT-06:00 (~ 1.7 MB):
1.21MiB 0:00:00 [3.45MiB/s] [=======================================================================>                            ] 72%            
Sending incremental io_tank/test/l0_3/l1_2/l2_0@syncoid_io_2024-12-17:14:34:52-GMT-06:00 ... syncoid_io_2024-12-17:17:44:59-GMT-06:00 (~ 1.5 MB):
1.18MiB 0:00:00 [3.17MiB/s] [============================================================================>                       ] 77%            
Sending incremental io_tank/test/l0_3/l1_2/l2_1@syncoid_io_2024-12-17:14:34:58-GMT-06:00 ... syncoid_io_2024-12-17:17:45:05-GMT-06:00 (~ 861 KB):
 720KiB 0:00:00 [1.87MiB/s] [==================================================================================>                 ] 83%            
Sending incremental io_tank/test/l0_3/l1_2/l2_2@syncoid_io_2024-12-17:14:35:04-GMT-06:00 ... syncoid_io_2024-12-17:17:45:11-GMT-06:00 (~ 1.5 MB):
1.08MiB 0:00:00 [3.10MiB/s] [========================================================================>                           ] 73%            
Sending incremental io_tank/test/l0_3/l1_2/l2_3@syncoid_io_2024-12-17:14:35:10-GMT-06:00 ... syncoid_io_2024-12-17:17:45:17-GMT-06:00 (~ 1.2 MB):
 977KiB 0:00:00 [2.70MiB/s] [=============================================================================>                      ] 78%            
Sending incremental io_tank/test/l0_3/l1_3@syncoid_io_2024-12-17:14:35:16-GMT-06:00 ... syncoid_io_2024-12-17:17:45:23-GMT-06:00 (~ 1.5 MB):
1.08MiB 0:00:00 [2.96MiB/s] [=======================================================================>                            ] 72%            
Sending incremental io_tank/test/l0_3/l1_3/l2_0@syncoid_io_2024-12-17:14:35:22-GMT-06:00 ... syncoid_io_2024-12-17:17:45:29-GMT-06:00 (~ 1.8 MB):
1.33MiB 0:00:00 [3.17MiB/s] [========================================================================>                           ] 73%            
Sending incremental io_tank/test/l0_3/l1_3/l2_1@syncoid_io_2024-12-17:14:35:29-GMT-06:00 ... syncoid_io_2024-12-17:17:45:36-GMT-06:00 (~ 1.5 MB):
 976KiB 0:00:00 [2.83MiB/s] [================================================================>                                   ] 65%            
Sending incremental io_tank/test/l0_3/l1_3/l2_2@syncoid_io_2024-12-17:14:35:35-GMT-06:00 ... syncoid_io_2024-12-17:17:45:47-GMT-06:00 (~ 1.9 MB):
1.33MiB 0:00:00 [3.87MiB/s] [=====================================================================>                              ] 70%            
Sending incremental io_tank/test/l0_3/l1_3/l2_3@syncoid_io_2024-12-17:14:35:41-GMT-06:00 ... syncoid_io_2024-12-17:17:45:57-GMT-06:00 (~ 1.1 MB):
 948KiB 0:00:00 [2.33MiB/s] [=================================================================================>                  ] 82%            
real 539.23
user 21.45
sys 23.72
hbarta@io:~$ 
```

Start looping and stir and syncoid, running them with 10 minute delays between and in separate terminals so they are not synchronized.

## 2024-12-18 success

```
hbarta@io:~$ zpool status
  pool: io_tank
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
  scan: scrub repaired 0B in 00:19:40 with 0 errors on Tue Dec 17 14:10:37 2024
config:

        NAME                                               STATE     READ WRITE CKSUM
        io_tank                                            ONLINE       0     0     0
          nvme-eui.0000000001000000e4d25c8051695501-part3  ONLINE       0     0     0

errors: 163 data errors, use '-v' for a list
hbarta@io:~$
```

A quick check of `dmesg` output and SMART stats for the drive does not reveal any obvious error conditions with the H/W. Scrolling back on the output of the repeated `syncoid` commands I see a number of errors reported. The entire screen buffer can be seen at [syncoid-errors](./syncoid-errors.md) and the buffer begins with a pool status with no errors. At this point in time I plan to stop the loops that stir the pool and send the pool as well as `sanoid` snapshots.
