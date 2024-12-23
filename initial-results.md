# ARM64 Pi CM4 Initial Results

## 2024-12-12 build data source

Use the Ansible playbooks in <https://github.com/HankB/polana-ansible>.

```text
ansible-playbook provision-Debian.yml -b -K --extra-vars "ssd_dev=/dev/sdb \
    os_image=/home/hbarta/Downloads/Pi/Debian/20231109_raspi_4_bookworm.img.xz \
    new_host_name=io poolname=io_tank part_prefix=""\
    eth_mac=dc:a6:32:bf:65:b1 wifi_mac=dc:a6:32:bf:65:b2"
```

`blkdisk` failed on USB connected SSD but other commands succeeded. ZFS version for pool creation is `zfs-2.1.11-1` (on Debian Bookworm.)

```text
PLAY RECAP *******************************************************************************************************
localhost                  : ok=28   changed=19   unreachable=0    failed=0    skipped=1    rescued=0    ignored=1   
```

Failed to boot. `start4.elf is not compatible` Repeating playbook on the target host (booting RpiOS form SD card) and using a newer Debian image. ZFS version is `zfs-2.2.3-1~bpo12+1~rpt1` (module version matches.)

```text
ansible-playbook provision-Debian.yml -b -K --extra-vars "ssd_dev=/dev/nvme0n1 \
    os_image=/home/hbarta/Downloads/Pi/Debian/20231109_raspi_4_bookworm.img.xz \
    new_host_name=io poolname=io_tank part_prefix="p"\
    eth_mac=dc:a6:32:bf:65:b1 wifi_mac=dc:a6:32:bf:65:b2"
```

Copy authorized_keys from other host (to permit passwordless login for further Ansible operations.)

```text
ansible-playbook first-boot-Debian.yml -i inventory -l 192.168.1.197 -u root
```
Note: Playbook hangs on the upgrade and has to be killed and the upgrade completed manually whereupon the playbook can be rerun.

Remap the MAC/IP address (to get a static IP and DNS - local requirement) and reboot to launch the most recent kernel and new IP address/.

```text
ansible-playbook second-boot-bookworm-Debian.yml -i inventory -l io -u root \
     --extra-vars "poolname=io_tank" --skip-tags "docker"
```

## 2024-12-12 populate storage

Recreate pool using encryption.

```text
zpool destroy io_tank
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
```

Note: Still need to load the key and mount `io_tank` following reboot. Can this be automated?

## 2024-12-12 populate storage

Using a combination of compressed and uncompressible data. This task performed by `populate_pool.sh` which creates a three level tier of filesystems and populates with some compressible and incompressible files. Because it creates and mounts directories, it needs to be run as root. It takes no command line arguments but there are some parameters that can be used for tuning operation.


## 2024-12-13 sanoid and syncoid

`populate_pool.sh` can run for a while so while that's going, install `sanoid` from the repo and configure snapshots.

```text
sudo apt install sanoid lsof mbuffer # lsof and mbuffer were already installed.
sudo mkdir /etc/sanoid
sudo cp /usr/share/doc/sanoid/examples/sanoid.conf /etc/sanoid/sanoid.conf # per /usr/share/doc/sanoid/README.Debian
sudo vim /etc/sanoid/sanoid.conf
diff /usr/share/doc/sanoid/examples/sanoid.conf /etc/sanoid/sanoid.conf
```

```text
hbarta@io:~$ diff /usr/share/doc/sanoid/examples/sanoid.conf /etc/sanoid/sanoid.conf
35a36,39
> [io_tank]
>       use_template = production
>       recursive = zfs
>       frequently = 10
hbarta@io:~$ 
```

Check operation

```text
sudo sanoid --cron --verbose # test config
```

Need to delete the example for `parent2`. Othewwrwise seems to be working as desired. Next task is to `syncoid` to send the entire pool recursively to another host with space on a single drive HDD pool. The prototype command (which eventually results in "permanent errors") is

```text
/bin/time -p /sbin/syncoid --recursive --no-privilege-elevation rocinante:rpool olive:ST8TB-ZA20HR7B/rocinante-backup/rpool
```

And the actual command (planned to run on the sending server) will be

```text
/bin/time -p /sbin/syncoid --recursive --no-privilege-elevation io:io_tank olive:ST8TB-ZA20HR7B/io-backup/io_tank
```

But first must create the destination filesystem on the destination host. (Question: Could the bug be provoked by sending to a filesystem on the same host?)

```text
sudo zfs create ST8TB-ZA20HR7B/io-backup
```

The `syncoid` command can be run as a normal user when the appropriate `zfs allow` command is run. On the first run it will complain abnout not being able to mount directories but those can be ignored and if desired, the destination filesystems can be mounted manually.

```text
user=hbarta
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    io_tank
```

At this instant the `syncoid` command is executing while the `populate_pool.sh` is executing and the pool is at 18% of capacity. The desire is to have the pool at about 40% of capacity. It will be necessary to kill `populate_pool.sh` at that point.

## 2024-12-13 stir the pool

Once the pool is fully populated it will be necessary to alter some of the files in the pool to simulate normal operation. `stir_pool.sh` will randomly regenerate files in the target dataset. Initially this will be approximately 1 in 10.

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

## 2024-12-14 rerunning syncoid

```text
hbarta@io:~$ /bin/time -p /sbin/syncoid --recursive --no-privilege-elevation io:io_tank olive:ST8TB-ZA20HR7B/io-backup/io_tank
Sending incremental io_tank@syncoid_io_2024-12-13:19:23:02-GMT-06:00 ... syncoid_io_2024-12-14:10:25:16-GMT-06:00 (~ 15 KB):
16.8KiB 0:00:00 [61.9KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/Programming@syncoid_io_2024-12-13:19:23:11-GMT-06:00 ... syncoid_io_2024-12-14:10:25:28-GMT-06:00 (~ 483 KB):
 211KiB 0:00:00 [ 641KiB/s] [==========================================>                                                         ] 43%            
Sending incremental io_tank/test@syncoid_io_2024-12-13:19:23:19-GMT-06:00 ... syncoid_io_2024-12-14:10:25:41-GMT-06:00 (~ 15 KB):
16.8KiB 0:00:00 [60.2KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_0@syncoid_io_2024-12-13:19:23:28-GMT-06:00 ... syncoid_io_2024-12-14:10:25:52-GMT-06:00 (~ 15 KB):
16.8KiB 0:00:00 [55.4KiB/s] [===================================================================================================] 105%            
Sending incremental io_tank/test/l0_0/l1_0@syncoid_io_2024-12-13:19:23:36-GMT-06:00 ... syncoid_io_2024-12-14:10:26:04-GMT-06:00 (~ 75 KB):
22.1KiB 0:00:00 [64.5KiB/s] [============================>                                                                       ] 29%            
Sending incremental io_tank/test/l0_0/l1_0/l2_0@syncoid_io_2024-12-13:19:23:44-GMT-06:00 ... syncoid_io_2024-12-14:10:26:16-GMT-06:00 (~ 75 KB):
28.4KiB 0:00:00 [76.1KiB/s] [====================================>                                                               ] 37%            
Sending incremental io_tank/test/l0_0/l1_0/l2_1@syncoid_io_2024-12-13:19:41:33-GMT-06:00 ... syncoid_io_2024-12-14:10:26:28-GMT-06:00 (~ 75 KB):
22.1KiB 0:00:00 [61.4KiB/s] [============================>                                                                       ] 29%            
real 86.04
user 2.58
sys 2.09
hbarta@io:~$ 
```

Loop with ~10 minute delays.

```text
hbarta@io:~$ while(:)
> do
> /bin/time -p /sbin/syncoid --recursive --no-privilege-elevation io:io_tank olive:ST8TB-ZA20HR7B/io-backup/io_tank
> echo
> echo
> sleep 750
> done
```

After running overnight (nearly 24 hours, no errors reported and `syncoid` is taking 16-20 seconds to complete.)

## 2024-12-15 modify files

`stir_pool.sh` is intended to do this. In order to run as an ordinary user, it is necessary to change perms or ownership of all files in the pool. For now...

```text
user=hbarta
pool=io_tank
sudo chown -R $user:$user /mnt/$pool/test/
./stir_pool.sh
```
Observation: Running `stir_pool.sh` concurrently with `syncoid` seems to have an impact on performance beyond the extra blocks that need to be transferred.

## 2024-12-15 things to do differently

* Need more files and filesystems. 140 and 5 respectively - smaller files!
* Use a .txt or .rnd file extension for easier matching later.
* Set perms/ownership on files and directories during creation.
* Put tunables in an ini file of some sort in order to share between scripts. (defer)
* Provide more efficient ways to modify the files.
    * `sed -i s/../abcd/ file` replaces first two chars with "abcd"
    * `echo x | dd of=file bs=1 count=1 seek=<rnd> conv=notrunc` replaces byte at 0 with 'x' 
* Base text file size on size, not time. On `iox86` the text files are larger than the binary packages.
* provide a command line argument for the sending pool name.

## 2024-12-22 bringing back up

`scrub`, `clear`, `scrub` cleared the errors. Building ZFS from backports and repeating test.