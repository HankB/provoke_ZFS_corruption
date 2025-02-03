# ARHM64 NVME ZFS 2.2.6

Continuation on the first test platform:

* Raspberry Pi CM4 wioth 8GB RAM
* 1TB NVME SSD in PCIe/NVME adapter in official IO board.
* Debian 12 (AKA STable, Bookworm)
* ZFS upgraded from backports

Prior to upgrading, processed the pool with `zfs scrub`, `zfs clear` and `zfs clear`. This cleared the errors and the test reused the pool rather than recreate it. When the test was repeated, restroring `sanoid` operation was overlooked so the test proceeded with loops that modify the pool and send the pool. [Uninteresting results ](./arm64_NVME_2.2.6-uninteresting.md) and [interestiong results](./arm64_NVME_2.2.6-interesting.md) are preserved and segregated.

```text
hbarta@io:~$ while(:)
do
    /bin/time -p /sbin/syncoid --recursive --no-privilege-elevation io:io_tank olive:ST8TB-ZA20HR7B/io-backup/io_tank
    zpool status 
    echo
    echo
    sleep 750
done
```

```text
while(:)
do
    /home/hbarta/Programming/provoke_ZFS_corruption/stir_pool.sh io_tank
    echo
    sleep 750
done
```

```test
  pool: io_tank
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
  scan: scrub repaired 0B in 00:20:57 with 0 errors on Mon Dec 23 11:08:15 2024
config:

        NAME                                               STATE     READ WRITE CKSUM
        io_tank                                            ONLINE       0     0     0
          nvme-eui.0000000001000000e4d25c8051695501-part3  ONLINE       0     0     0

errors: 4 data errors, use '-v' for a list
hbarta@io:~$ 
```

The first error reported by `syncoid` did not seem to cascade but the error count reported by `zpool status` increased to 4 on the next pass and remained there for four additional passes.

```text
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-11da694afc-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1e9abfec755e64d6c5200b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f91057bc7979e8b2eadb1ac90424794eb07c5e626e2a0343667e7c49625eb63ed0b412fd1c837863fd1cc37823fd1ca3782387e2cabce4fccc9478a01a230323135d43235d23632b430b2b53632b53735d77df105d03332b0303981b00f1f62e6e
CRITICAL ERROR: ssh     -S /tmp/syncoid-io-1735001499 io ' zfs send  -I '"'"'io_tank/test/l0_3/l1_2/l2_2'"'"'@'"'"'syncoid_io_2024-12-23:18:38:57-GMT-06:00'"'"' '"'"'io_tank/test/l0_3/l1_2/l2_2'"'"'@'"'"'syncoid_io_2024-12-23:18:53:57-GMT-06:00'"'"' | lzop  | mbuffer  -q -s 128k -m 16M 2>/dev/null' | lzop -dfc | pv -p -t -e -r -b -s 1108016 | lzop  | mbuffer -q -s 128k -m 16M 2>/dev/null | ssh     -S /tmp/syncoid-olive-1735001499 olive ' mbuffer  -q -s 128k -m 16M 2>/dev/null | lzop -dfc |  zfs receive  -s -F '"'"'ST8TB-ZA20HR7B/io-backup/io_tank/test/l0_3/l1_2/l2_2'"'"' 2>&1' failed: 256 at /sbin/syncoid line 817.
```

This completes testing on this configuration. This setup will be migrated to Debian Bullseye and an older kernel installed to support testing older ZFS versions.
