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

Using modified tunables in `populate_pool.sh`.