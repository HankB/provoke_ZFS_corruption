# Initial Results

## 2024-12-13

### Conditions

#### Sender

* Raspberry Pi CM4
    * 8GB RAM 
    * mounted in an official IO Board 
    * passive cooling
    * Not overclocked (1.5 GHz - RpiOS defaults to 1.8 GHz.)
    * Ethernet LAN (WiFi not working on Debian.)
* Intel 670p 1TB SSD operating in a PCIe 2.0 x1 slot. (Boot device and pool.)
* Debian 12 (not RpiOS) fully updated.
* ZFS 2.1.11

```text
hbarta@io:~$ zfs --version
zfs-2.1.11-1
zfs-kmod-2.1.11-1
hbarta@io:~$ 
```

The first "complete" run with `populate_pool.sh` was interrupted when the pool hit about 40%. At this point it had created six filesystems (many less than planned) for a total of eight filesystems. Local development is taking place in `io_tank/Programming` mounted at `/home/hbarta/Programming` to take advantage of ZFS backups (in addition to pushing to Github.)

```text
hbarta@io:~$ zfs list -r io_tank
NAME                          USED  AVAIL     REFER  MOUNTPOINT
io_tank                       374G   518G      368K  /mnt/io_tank
io_tank/Programming          3.19M   518G     1.73M  /home/hbarta/Programming
io_tank/test                  374G   518G      336K  /mnt/io_tank/test
io_tank/test/l0_0             374G   518G     94.2G  /mnt/io_tank/test/l0_0
io_tank/test/l0_0/l1_0        279G   518G      113G  /mnt/io_tank/test/l0_0/l1_0
io_tank/test/l0_0/l1_0/l2_0   111G   518G      111G  /mnt/io_tank/test/l0_0/l1_0/l2_0
io_tank/test/l0_0/l1_0/l2_1  55.1G   518G     55.1G  /mnt/io_tank/test/l0_0/l1_0/l2_1
hbarta@io:~$ 
```
Time to get to 40% was

```text
hbarta@io:~/Programming/provoke_ZFS_corruption$ time -p sudo ./populate_pool.sh 
...
Terminated
real 13981.71
user 0.01
sys 0.10
hbarta@io:~/Programming/provoke_ZFS_corruption$
```

While `populate_pool.sh` was still running, `sanoid` was installed, configured and started taking snapshots. At present there are 125 snapshots including 8 created by `syncoid` (which at present is still running.)

As mentioned `syncoid` was started using

```text
/bin/time -p /sbin/syncoid --recursive --no-privilege-elevation io:io_tank olive:ST8TB-ZA20HR7B/io-backup/io_tank
```

Temperature of the SSD peaked at 51°C while `populate_pool.sh` and `syncoid` were running. With only `syncoid` it has dropped to 47°C. The SSD is in an adapter card in the PCIe slot in an IO Board and the result is it is vertical (with the 2280 length horizontal) which provides reasonable convective cooling.

Full record of the first run was

```text
hbarta@io:~$ /bin/time -p /sbin/syncoid --recursive --no-privilege-elevation io:io_tank olive:ST8TB-ZA20HR7B/io-backup/io_tank
INFO: Sending oldest full snapshot io_tank@autosnap_2024-12-13_11:09:03_monthly (~ 114 KB) to new target filesystem:
46.1KiB 0:00:00 [ 297KiB/s] [=======================================>                                                            ] 40%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734111191 io ' zfs send  '"'"'io_tank'"'"'@'"'"'autosnap_2024-12-13_11:09:03_monthly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 116848 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734111192 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/Programming@autosnap_2024-12-13_11:09:03_monthly (~ 366 KB) to new target filesystem:
 274KiB 0:00:00 [1.42MiB/s] [=========================================================================>                          ] 74%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/Programming': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734111191 io ' zfs send  '"'"'io_tank/Programming'"'"'@'"'"'autosnap_2024-12-13_11:09:03_monthly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 375776 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734111192 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/Programming'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test@autosnap_2024-12-13_11:09:03_monthly (~ 98 KB) to new target filesystem:
45.8KiB 0:00:00 [ 280KiB/s] [=============================================>                                                      ] 46%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734111191 io ' zfs send  '"'"'io_tank/test'"'"'@'"'"'autosnap_2024-12-13_11:09:03_monthly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 100464 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734111192 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0@autosnap_2024-12-13_11:09:03_monthly (~ 96.1 GB) to new target filesystem:
96.1GiB 2:56:51 [9.28MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734111191 io ' zfs send  '"'"'io_tank/test/l0_0'"'"'@'"'"'autosnap_2024-12-13_11:09:03_monthly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 103159673408 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734111192 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_0@autosnap_2024-12-13_11:09:03_monthly (~ 29.2 GB) to new target filesystem:
29.2GiB 0:25:00 [19.9MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734111191 io ' zfs send  '"'"'io_tank/test/l0_0/l1_0'"'"'@'"'"'autosnap_2024-12-13_11:09:03_monthly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 31347889024 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734111192 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0'"'"'' failed: 256 at /sbin/syncoid line 492.
real 12298.22
user 459.28
sys 1292.74
hbarta@io:~$ 
```

Performance was not spectacular. Hopefully that's not important to revealing the corruption bug. Immediately restarted to capture the rest of the filesystems/files that were created. That actually bumped SSD temperature to 60°C briefly.

```text
hbarta@io:~$ /bin/time -p /sbin/syncoid --recursive --no-privilege-elevation io:io_tank olive:ST8TB-ZA20HR7B/io-backup/io_tank
Sending incremental io_tank@autosnap_2024-12-13_11:09:03_monthly ... syncoid_io_2024-12-13:14:59:22-GMT-06:00 (~ 14 KB):
15.5KiB 0:00:00 [63.6KiB/s] [===================================================================================================] 106%            
Sending incremental io_tank/Programming@autosnap_2024-12-13_11:09:03_monthly ... syncoid_io_2024-12-13:14:59:38-GMT-06:00 (~ 738 KB):
 192KiB 0:00:00 [ 538KiB/s] [========================>                                                                           ] 25%            
Sending incremental io_tank/test@autosnap_2024-12-13_11:09:03_monthly ... syncoid_io_2024-12-13:14:59:50-GMT-06:00 (~ 74 KB):
20.3KiB 0:00:00 [69.3KiB/s] [==========================>                                                                         ] 27%            
Sending incremental io_tank/test/l0_0@autosnap_2024-12-13_11:09:03_monthly ... syncoid_io_2024-12-13:15:00:01-GMT-06:00 (~ 74 KB):
20.3KiB 0:00:00 [68.9KiB/s] [==========================>                                                                         ] 27%            
Sending incremental io_tank/test/l0_0/l1_0@autosnap_2024-12-13_11:09:03_monthly ... syncoid_io_2024-12-13:15:00:12-GMT-06:00 (~ 84.9 GB):
84.9GiB 1:12:02 [20.1MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_0/l2_0@autosnap_2024-12-13_19:00:03_hourly (~ 91.0 GB) to new target filesystem:
91.1GiB 1:17:48 [20.0MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_0': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734123560 io ' zfs send  '"'"'io_tank/test/l0_0/l1_0/l2_0'"'"'@'"'"'autosnap_2024-12-13_19:00:03_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 97735681696 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734123561 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_0'"'"'' failed: 256 at /sbin/syncoid line 492.
INFO: Sending oldest full snapshot io_tank/test/l0_0/l1_0/l2_1@autosnap_2024-12-13_20:00:02_hourly (~ 55.4 GB) to new target filesystem:
55.4GiB 0:48:28 [19.5MiB/s] [==================================================================================================>] 100%            
cannot mount '/mnt/ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_1': failed to create mountpoint: Permission denied
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1734123560 io ' zfs send  '"'"'io_tank/test/l0_0/l1_0/l2_1'"'"'@'"'"'autosnap_2024-12-13_20:00:02_hourly'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 59457559624 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1734123561 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_0/l1_0/l2_1'"'"'' failed: 256 at /sbin/syncoid line 492.
real 11961.31
user 872.08
sys 2639.39
hbarta@io:~$ 
```

One more time for now. Virtually no files changed (except in `~/Programming`.)

```text
hbarta@io:~$ /bin/time -p /sbin/syncoid --recursive --no-privilege-elevation io:io_tank olive:ST8TB-ZA20HR7B/io-backup/io_tank
Sending incremental io_tank@syncoid_io_2024-12-13:14:59:22-GMT-06:00 ... syncoid_io_2024-12-13:19:23:02-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [55.4KiB/s] [===================================================================================================] 108%            
Sending incremental io_tank/Programming@syncoid_io_2024-12-13:14:59:38-GMT-06:00 ... syncoid_io_2024-12-13:19:23:11-GMT-06:00 (~ 300 KB):
97.2KiB 0:00:00 [ 369KiB/s] [===============================>                                                                    ] 32%            
Sending incremental io_tank/test@syncoid_io_2024-12-13:14:59:50-GMT-06:00 ... syncoid_io_2024-12-13:19:23:19-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [49.5KiB/s] [===================================================================================================] 108%            
Sending incremental io_tank/test/l0_0@syncoid_io_2024-12-13:15:00:01-GMT-06:00 ... syncoid_io_2024-12-13:19:23:28-GMT-06:00 (~ 10 KB):
11.3KiB 0:00:00 [48.1KiB/s] [===================================================================================================] 108%            
Sending incremental io_tank/test/l0_0/l1_0@syncoid_io_2024-12-13:15:00:12-GMT-06:00 ... syncoid_io_2024-12-13:19:23:36-GMT-06:00 (~ 9 KB):
10.7KiB 0:00:00 [43.6KiB/s] [===================================================================================================] 109%            
Sending incremental io_tank/test/l0_0/l1_0/l2_0@autosnap_2024-12-13_19:00:03_hourly ... syncoid_io_2024-12-13:19:23:44-GMT-06:00 (~ 20.9 GB):
21.0GiB 0:17:39 [20.3MiB/s] [==================================================================================================>] 100%            
Sending incremental io_tank/test/l0_0/l1_0/l2_1@autosnap_2024-12-13_20:00:02_hourly ... syncoid_io_2024-12-13:19:41:33-GMT-06:00 (~ 10 KB):
11.9KiB 0:00:00 [43.8KiB/s] [===================================================================================================] 108%            
real 1121.05
user 79.85
sys 234.76
hbarta@io:~$ 
```
