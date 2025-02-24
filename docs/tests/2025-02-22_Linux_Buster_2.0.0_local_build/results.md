# Results

* [Data](./data.md)
* [Setup](./setup.md)

## issues

* Results noticed about 1655 - about 2 1/2 hourts after start of test. First log file reporting an error was at 1637. Apparently the scripts did not include the "exit on first error" code.
* `sanoid` was not configured.
* Pool scrubs were not configured.

Apparently `sanoid` snapshots and scrubs are not required to provoke the bug and can be safely left off future tests.

The first log to report errors was `2025-02-23-1637.stir_pools.34.txt`

```text
errors: List of errors unavailable: permission denied
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

errors: 63 data errors, use '-v' for a list
```

Errors reported during this syncoid run include

```text
INFO: Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-02-23:16:35:49-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:34-GMT-06:00 to recv/test/l0_0/l1_1/l2_2 (~ 66.2 MB):
warning: cannot send 'send/test/l0_0/l1_1/l2_2@1740350230.2025-02-23-1637': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_2'@'syncoid_orion_2025-02-23:16:35:49-GMT-06:00' 'send/test/l0_0/l1_1/l2_2'@'syncoid_orion_2025-02-23:16:37:34-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 69395776 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_2' 2>&1 failed: 256

...

INFO: Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-02-23:16:36:00-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:42-GMT-06:00 to recv/test/l0_0/l1_2/l2_0 (~ 65.6 MB):
internal error: warning: cannot send 'send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-02-23:16:37:42-GMT-06:00': Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_0'@'syncoid_orion_2025-02-23:16:36:00-GMT-06:00' 'send/test/l0_0/l1_2/l2_0'@'syncoid_orion_2025-02-23:16:37:42-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 68804848 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_0' 2>&1 failed: 256

...

INFO: Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-02-23:16:36:45-GMT-06:00 ... syncoid_orion_2025-02-23:16:38:20-GMT-06:00 to recv/test/l0_1/l1_0/l2_2 (~ 68.4 MB):
warning: cannot send 'send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-02-23:16:38:20-GMT-06:00': Input/output error
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1379a801cc-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1ddf48fab1ff809c72a00d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882be6bfd04ccafb9ba3958024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa89f63186fa09f63146fe4505c99979c9f99129f5f94999f176f646064aa6b60a46b646c656866656c616564a0ebee1ba26b606665600073030078d32d6a
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_2'@'syncoid_orion_2025-02-23:16:36:45-GMT-06:00' 'send/test/l0_1/l1_0/l2_2'@'syncoid_orion_2025-02-23:16:38:20-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 71769864 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_2' 2>&1 failed: 256
```

The [full `syncoid` output](./data.md#2025-02-23-first-syncoid-with-errors).
