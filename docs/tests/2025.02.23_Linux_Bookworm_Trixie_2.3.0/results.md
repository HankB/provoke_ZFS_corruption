# Linux Trixie 2.3.0 results

* [Setup](./setup.md)
* [Data](./data.md)


Kicked off at 1218. First corruption at 1416. Once again the process did not terminate when the first error was detected. There were several stir operations that reported before the syncoid operation reported corruption. Seconds will be added to the log file timestamps to help sort overlap between operations. (e.g. `2025-02-24-1416NN.stir_pools.30.txt` vs. `2025-02-24-1416.stir_pools.30.txt`)

There were no errors in recorded output of the stir operation. Scripts will be reviewed to insure that both normal and error output are being recorded. (And `set -x` can also be turned off.) The first `syncoid` log that reported errors had similar errors including `Input/output error` and `Invalid argument`

```text
Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-02-24:14:15:07-GMT-06:00 ... syncoid_orion_2025-02-24:14:16:39-GMT-06:00 (~ 89.4 MB):
warning: cannot send 'send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-02-24:14:16:39-GMT-06:00': Input/output error
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-12160b1454-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081743457d44629f3530a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28acba2afa6fe89f9c39a8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fa89f63146fec505c99979c9f99129f5f94999f176f646064aa6b60a46b64626508446656c696baeebe21ba0666560606303700000d212c45
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_3'@'syncoid_orion_2025-02-24:14:15:07-GMT-06:00' 'send/test/l0_0/l1_1/l2_3'@'syncoid_orion_2025-02-24:14:16:39-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 93735480 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_3' 2>&1 failed: 256 at /usr/sbin/syncoid line 889.

...

Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-02-24:14:15:38-GMT-06:00 ... syncoid_orion_2025-02-24:14:17:09-GMT-06:00 (~ 66.1 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-02-24:14:17:09-GMT-06:00': Invalid argument
```

[Full text of the log](./data.md#2025-02-24-syncoid-log-with-errors)

Status when processing was manually interrupted:

```text
Every 15.0s: monitor.sh                                                                                            orion: Mon Feb 24 14:58:22 2025

status
  pool: recv
 state: ONLINE
config:

        NAME                      STATE     READ WRITE CKSUM
        recv                      ONLINE       0     0     0
          wwn-0x5002538d40878f8e  ONLINE       0     0     0

errors: No known data errors

  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: 88 data errors, use '-v' for a list

list

NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   275G   189G        -         -    15%    59%  1.00x    ONLINE  -
send   464G   283G   181G        -         -    25%    60%  1.00x    ONLINE  -

send snapshot count
3201

recv snapshot count
3070
```