# provoke ZFS corruption

RE: <https://github.com/openzfs/zfs/issues/12014>

Use two Raspberry Pis to attempt to provoke corruption in a reproducible way.

## Hardware

* Pi 4B booting from SSD connected to LAN via Ethernet. (backup destination)
* Pi CM4 on official IO Board booting from NVME SSD (backup source.)
* X86_64 host with non-encrypted single disk HDD pool. (backup destination)

## TODO

* Image and configure source.
    * Install Debian 12
    * Build ZFS
    * Install `sanoid`
* Produce a script to initially populate the source pool.
* Produce a script to manipulate some files on the source.
* Produce a script to send the pool to a backup destination.
* Produce a script to record pool status.

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
