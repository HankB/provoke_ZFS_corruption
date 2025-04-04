# Setup - Buster 4.19 kernel bisect 0.8.6 through 2.0.0

## 2025-04-02 restart with 4.19 kernel

This is the stock kernel for Debian 10 and still installed on the test host. Confirm that ZFS is not installed.

```text
hbarta@orion:~$ uname -a
Linux orion 4.19.0-27-amd64 #1 SMP Debian 4.19.316-1 (2024-06-25) x86_64 GNU/Linux
hbarta@orion:~$ 
hbarta@orion:~$ sudo which zpool zfs
[sudo] password for hbarta: 
hbarta@orion:~$ 
hbarta@orion:~$ lsmod|grep zfs
hbarta@orion:~$ 
hbarta@orion:~$ find /lib/modules/4.19.0-27-amd64 -iname "*zfs*"
hbarta@orion:~$ 
```

### Reset bisect and build

```text
hbarta@orion:~/zfs$ git bisect reset
Previous HEAD position was 78fac8d92 Fix kstat state update during pool transition
HEAD is now at dcbf84749 Tag 2.0.0
hbarta@orion:~/zfs$
```

2.0.0 seems like a good start. Commands are:

```text
sh autogen.sh
./configure
make -s -j$(nproc)
```

All steps complete w/out issue. Just to be sure, repeat the test to provoke corruption.

```text
sudo make install
sudo ldconfig
sudo modprobe zfs
zfs --version
```

```text
hbarta@orion:~/zfs$ zfs --version
zfs-2.0.0-1
zfs-kmod-2.0.0-1
hbarta@orion:~/zfs$ 
hbarta@orion:~/zfs$ zpool list
no pools available
hbarta@orion:~/zfs$ sudo zpool import
   pool: recv
     id: 14207372401767681194
  state: UNAVAIL
status: The pool was last accessed by another system.
 action: The pool cannot be imported due to damaged devices or data.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-EY
 config:

        recv                      UNAVAIL  unsupported feature(s)
          wwn-0x5002538d40878f8e  ONLINE

   pool: send
     id: 14896024190411447892
  state: UNAVAIL
status: The pool was last accessed by another system.
 action: The pool cannot be imported due to damaged devices or data.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-EY
 config:

        send                      UNAVAIL  unsupported feature(s)
          wwn-0x5002538d41628a33  ONLINE
hbarta@orion:~/zfs$ 

```

`UNAVAIL  unsupported feature(s)` - Intreresting. But SSDs will be secure erased before proceeding anyway. Boot drive is `/dev/sdc` so `/dev/sd[ab]` will be erased.

```text
hdparm --user-master u --security-set-pass Eins /dev/sda
hdparm --security-erase Eins /dev/sda
hdparm --user-master u --security-set-pass Eins /dev/sdb
hdparm --security-erase Eins /dev/sdb
```

### Build pools

```text
dd if=/dev/urandom bs=32 count=1 of=/pool-key 
sudo zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O encryption=aes-256-gcm  -O keylocation=file:///pool-key -O keyformat=raw \
      -O mountpoint=/mnt/send \
      send wwn-0x5002538d41628a33
sudo zfs load-key -a

sudo zpool create -o ashift=12 \
      -O acltype=posixacl -O canmount=on -O compression=lz4 \
      -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
      -O mountpoint=/mnt/recv \
      recv wwn-0x5002538d40878f8e
```

```text
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   444K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   564K   464G        -         -     0%     0%  1.00x    ONLINE  -
root@orion:~#
```

### Prepare for testing

```text
/home/hbarta/provoke_ZFS_corruption/scripts/populate_pool.sh
```

```text
root@orion:~# time -p /home/hbarta/provoke_ZFS_corruption/scripts/populate_pool.sh
...
Capacity target 50 met
+ exit
real 2299.26
user 70.48
sys 2282.26
root@orion:~# 
```

```text
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   636K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   238G   226G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# 
```

```text
time -p syncoid --recursive --no-privilege-elevation send/test recv/test
```

```text
chown -R hbarta:hbarta /mnt/send/ /mnt/recv/
user=hbarta
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    send
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    recv
```

And repeat send as a user.

```text
hbarta@orion:~$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 13.30
user 2.69
sys 5.10
hbarta@orion:~$ 
```

### start thrashing

```text
cd
mkdir /mnt/storage/logs.2025-04-02_Linux_Buster_4.19_0.8.6/
rm /home/hbarta/logs
ln -s /mnt/storage/logs.2025-04-02_Linux_Buster_4.19_0.8.6 /home/hbarta/logs
mkdir -p bin
export PATH=/home/hbarta/bin:$PATH
tmux new -D -s "stir" thrash_stir.sh
tmux new -D -s syncoid thrash_syncoid.sh
tmux new -D -s snaps manage_snaps.sh
watch -n 30 monitor.sh
```

(Last 4 commands get their own SSH login.) Also running `sanoid` in a tight loop with the following configuration:

```text
[send/test]
        use_template = production
        frequently = 10
        recursive = zfs

[recv/test]
        use_template = production
        recursive = zfs
        autosnap = no
```

Disabling the timer and looping manually:

```text
systemctl disable sanoid.timer
while(:)
do
time -p sanoid --cron --verbose
sleep 60
done
```

This was later replaced by the script `thrash_sanoid.sh` which exits once corruption has been marked.
