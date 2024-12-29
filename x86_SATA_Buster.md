# X86 SATA testing with Buster

The purpose is to be able to test with older ZFS versi0ons (back to 0.8) The expectation is this test will not produce corruption for these test conditions (send from encrypted pool to non-encrypted pool.)

## 2024-12-26 install Buster

Prerequisite was to reproduce the error with a current Debian install. The previous (J1900) host was wonky and seems no longer useful. The "new" system is a proper server (X8DTL) with ECC RAM and an HBA to connect the SSDs but is not bootable. The Bookworm install took days to reproduce the error.

Install Buster usintg the Netinst ISO. NB, this board is too old to support EFI.

Add `contrib` to `/etc/apt/sources.list` and install dependencies

* `apt install -y build-essential libghc-zlib-dev uuid-dev libblkid-dev libssl-dev libnvpair1linux vim git`

Pull/extract the tarball and inside the project directory

```text
apt search linux-headers-$(uname -r)
sudo apt install linux-headers-4.19.0-27-amd64
wget https://github.com/openzfs/zfs/releases/download/zfs-0.8.6/zfs-0.8.6.tar.gz
tar xf zfs-0.8.6.tar.gz
cd zfs-0.8.6
./configure
make -j16
sudo make -j16 install
```

Seems to be working! Now to destroy the old pool (secure erase) and create the new pool. Repeating [commands from Bookworm](./x86_trial_3.md)

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

## 2024-12-27 re-install and restart

### Pull provoke_ZFS_corruption

```text
git clone https://github.com/HankB/provoke_ZFS_corruption.git
cd provoke_ZFS_corruption
vim populate_pool.sh # change pool name "pool=send"
sudo ./populate_pool.sh
```

No `sanoid` in repos so install following suggestions at <https://github.com/jimsalterjrs/sanoid/issues/975> ... But this won't configure the timer, setup config files etc. Instead, fork sanoid and remove the ZFS dependency, <https://github.com/HankB/sanoid> Build and install as instructed and have working `sanoid`. And also install `lzop`, `pv` and `mbuffer`.

```text
sudo apt install lzop pv mbuffer
...
```

First backup

```text
user=hbarta
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    send
sudo zfs allow -u $user \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    recv
time -p syncoid --recursive --no-privilege-elevation send/test recv/test
```

First pool stir

```text
vim stir_pool.sh # Fix start directory for find command
sudo chown -R $user:$user /mnt/test 
./stir_pool.sh
```

## 2024-12-28 start loops

Off site so using `tmux` and directing output to a disk file and adding time stamps.

```text
while(:)
do
    date +%Y-%m-%d-%H%M
    time -p syncoid --recursive --no-privilege-elevation send/test recv/test
    zpool status send
    echo
    sleep 750
done >>syncoid.txt 2>&1
```

```text
while(:)
do
    date +%Y-%m-%d-%H%M
    /home/$user/provoke_ZFS_corruption/stir_pool.sh
    sleep 750
done 2>/dev/null >>stir.txt
```
