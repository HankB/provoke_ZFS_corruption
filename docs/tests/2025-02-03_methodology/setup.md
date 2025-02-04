# 2025-02-03 Setup

* [Results](./results.md)
* [Additional information](./additional.md)

## 2025-02-03 initial setup

1. Install using Netinst media for Debian 12.7.0.
1. Remap MAC address.
1. Add `contrib` to `sources.list`
1. Update/upgrade: "All packages are up to date." (Netinst benefit)
1. Reboot.
1. Install useful utilities

```text
apt install -y vim git linux-headers-$(uname -r) lzop pv mbuffer sanoid tree smartmontools lm-sensors parted shellcheck tmux time mkdocs lshw
```

7. Install ZFS per instructions at <https://openzfs.github.io/openzfs-docs/Getting%20Started/Debian/index.html> (except no `backports`)

```text
apt install dpkg-dev linux-headers-generic linux-image-generic
apt install zfs-dkms zfsutils-linux
```

Resulting versions

```text
root@orcus:~# zfs --version
zfs-2.1.11-1+deb12u1
zfs-kmod-2.1.11-1+deb12u1
root@orcus:~# uname -a
Linux orcus 6.1.0-30-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.124-1 (2025-01-12) x86_64 GNU/Linux
root@orcus:~# 
```

8. Generate SSH key and add to my Githgub account. Clone `git@github.com:HankB/provoke_ZFS_corruption.git` in HOME dir.
1. Use `hdparm` to secure erase Samsung SSDs (`/dev/sda`, `/dev/sdb`). 
1. Run `partprobe` and ID the WWN for `/dev/sda`

```text
root@orcus:~# ls -l /dev/disk/by-id|grep sda
lrwxrwxrwx 1 root root  9 Feb  3 16:05 ata-Samsung_SSD_850_EVO_500GB_S21HNXAGC35770F -> ../../sda
lrwxrwxrwx 1 root root  9 Feb  3 16:05 wwn-0x5002538d40878f8e -> ../../sda
root@orcus:~# 
```

11. Create the 'send' pool.

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
root@orcus:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
send   464G   564K   464G        -         -     0%     0%  1.00x    ONLINE  -
root@orcus:~# 
```

From Google AI - random printable character (To use in `stir_pool.sh`)

```text
tr -dc '[:print:]' < /dev/urandom | head -c 1
```

```text
root@orcus:~# /home/hbarta/provoke_ZFS_corruption/scripts/populate_pool.sh
```

Killed with pool at 73%. 

```text
hbarta@orcus:~$ find /mnt/send/ -type f | wc -l
7003
hbarta@orcus:~$ find /mnt/send/ -type d | wc -l
46
hbarta@orcus:~$ zfs list -rH send|wc -l
46
hbarta@orcus:~$ 
```

Compared to my "problem child" - it has a *lot* more files. Let's rework this to produce more smaller files.

```text
hbarta@rocinante:~$ zfs list -r rpool | wc -l
26
hbarta@rocinante:~$ sudo find / -type f | wc -l
[sudo] password for hbarta: 
find: ‘/run/user/1000/doc’: Permission denied
2318567
hbarta@rocinante:~$ 
```

NB: Host is emitting an overtemperature alarm with the processor that does not have a fan hitting 95°C. OPening the case and placing a small desk fan directed toward it is keeping it within limits. Result after some tweaking (and killing the process) is

```text
hbarta@orcus:~/provoke_ZFS_corruption/scripts$ zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
send   464G   335G   129G        -         -     1%    72%  1.00x    ONLINE  -
hbarta@orcus:~/provoke_ZFS_corruption/scripts$ find /mnt/send -type f | wc -l
67738
hbarta@orcus:~/provoke_ZFS_corruption/scripts$ find /mnt/send -type d | wc -l
45
hbarta@orcus:~/provoke_ZFS_corruption/scripts$ 
```

That seems more appropriate for further testing. Next set up `sanoid` (as root).

```text
mkdir /etc/sanoid
cp /usr/share/doc/sanoid/examples/sanoid.conf /etc/sanoid/
vim /etc/sanoid/sanoid.conf
sanoid --cron --verbose # test config
```

```text
[send/test]
        use_template = production
        frequently = 10
        recursive = zfs
```

Result:

```text
root@orcus:~# zfs list -t snap -r|wc -l
177
root@orcus:~# 
```

Create the `recv` pool, set `allow` and run the first `syncoid` as root to allow filesystems to be mounted.

```text
root@orcus:~# ls -l /dev/disk/by-id|grep sdb
lrwxrwxrwx 1 root root  9 Feb  3 16:05 ata-Samsung_SSD_850_EVO_500GB_S2RANB0HA37864N -> ../../sdb
lrwxrwxrwx 1 root root  9 Feb  3 16:05 wwn-0x5002538d41628a33 -> ../../sdb
root@orcus:~# 
```

```text
zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O mountpoint=/mnt/recv \
      recv wwn-0x5002538d41628a33
chmod a+rwx /mnt/recv/

user=hbarta
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    send
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    recv

time -p syncoid --recursive --no-privilege-elevation send/test recv/test
```

Part way through the first `syncoid` run

```text
hbarta@orcus:~$ zpool status
  pool: recv
 state: ONLINE
config:

        NAME                      STATE     READ WRITE CKSUM
        recv                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: No known data errors

  pool: send
 state: ONLINE
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d40878f8e  ONLINE       0     0     0

errors: No known data errors
hbarta@orcus:~$ zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   193G   271G        -         -     0%    41%  1.00x    ONLINE  -
send   464G   335G   129G        -         -     1%    72%  1.00x    ONLINE  -
hbarta@orcus:~$ 
```

Thoughts on speeding up results.

* Probably need less time between executions than 750s.
* `sanoid` and `syncoid` should be run at slightly different intervals so the 'overlap' shifts around and there are times where there is no overlay. Can `sanoid` be scheduled more often?
* The pool should be stirred more often - perhaps continuously.
* Daily (or more often) scrubs should be automated.

After the first syncoid pass, times will be taken for a stir and `syncoid` runs to establish basic timing.

Also need to add the `sbin` directories to the user path. And link the script `stir_pool.sh` to `~/bin/stir_pool.sh`

```text
ln provoke_ZFS_corruption/scripts/stir_pool.sh bin
```

Therre is not an order of magnitude between the time it takes to stir the pool and the resulting time for the `syncoid` pass to complete, but they are sufficiently different to introduce skew between them. Rather than scheduling at fixed interval;s (e.g. `cron`) it seems to make more sense to allow a matching delay between and allow the difference in execution time to provide the skew. Or is that a good idea. Could some effect between the stir and the `syncoid` operation cause them to sync up? With that thought it seems to make more sense to schedule them using `cron` and make the skew intentional. Output will be redirected to time stamp named files in `~/logs`. The `syncoid` process will run every 6 minutes and the `stir_pool.sh` every 7. These intervals will allow these processes to skew with `sanoid` which runs every 15 minutes.

```text
/bin/time -p /sbin/syncoid --recursive --no-privilege-elevation send/test recv/test >/home/hbarta/logs/$(/bin/date  +%Y-%m-%d-%H%M).syncoid.txt 2>&1
```

```text
/bin/time -p /home/hbarta/bin/stir_pool.sh >/home/hbarta/logs/$(/bin/date  +%Y-%m-%d-%H%M).stir_pools.txt 2>&1
```

Perhaps an enhancement would be to create another dataset. Crontab for now is

```text
# m h  dom mon dow   command
*/6 * * * * /bin/time -p /sbin/syncoid --recursive --no-privilege-elevation send/test recv/test >/home/hbarta/logs/$(/bin/date  +%Y-%m-%d-%H%M).syncoid.txt 2>&1
*/7 * * * * /bin/time -p /home/hbarta/bin/stir_pool.sh >/home/hbarta/logs/$(/bin/date  +%Y-%m-%d-%H%M).stir_pools.txt 2>&1
```

`cron` entries seem not to be running. Encapsulate in `bash` scripts and link to `~/bin`. After they are confirmed to work, edit `crontab` accorcingly.

```text
hbarta@orcus:~$ ln provoke_ZFS_corruption/scripts/do_stir.sh bin
hbarta@orcus:~$ ln provoke_ZFS_corruption/scripts/do_syncoid.sh bin
hbarta@orcus:~$ chmod +x provoke_ZFS_corruption/scripts/do_syncoid.sh provoke_ZFS_corruption/scripts/do_stir.sh
hbarta@orcus:~$ ls -l bin
total 12
-rwxr-xr-x 2 hbarta hbarta  124 Feb  3 22:11 do_stir.sh
-rwxr-xr-x 2 hbarta hbarta  162 Feb  3 22:12 do_syncoid.sh
-rwxr-xr-x 2 hbarta hbarta 1186 Feb  3 19:00 stir_pool.sh
hbarta@orcus:~$ do_stir.sh
hbarta@orcus:~$ do_syncoid.sh
hbarta@orcus:~$ 
```


