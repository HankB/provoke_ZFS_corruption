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
