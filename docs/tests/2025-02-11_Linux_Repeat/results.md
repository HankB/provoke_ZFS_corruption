# Linux Repeat Results

This is with the same configuration used for the two methodology studies - Current Debian and (not from backports) ZFS.

```text
hbarta@orcus:~$ uname -a
Linux orcus 6.1.0-30-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.124-1 (2025-01-12) x86_64 GNU/Linux
hbarta@orcus:~$ zfs --version
zfs-2.1.11-1+deb12u1
zfs-kmod-2.1.11-1+deb12u1
hbarta@orcus:~$ 
```

There were two goals for this test. First see if the scripts modified to work for FreeBSD still worked with Linux. They did. Second was to see if the previous 15 minute result was a fluke. It was, a bit. Test ran from 1525 to 1727 for about 2 hours to provoke corruption - still not too bad. Much improved over a couple days.

Conditions at the end of the test were

```text
root@orcus:~# zpool status -v
  pool: recv
 state: ONLINE
  scan: scrub repaired 0B in 00:16:09 with 0 errors on Tue Feb 11 18:19:10 2025
config:

        NAME                      STATE     READ WRITE CKSUM
        recv                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: No known data errors

  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
  scan: scrub repaired 0B in 00:14:20 with 0 errors on Tue Feb 11 18:17:22 2025
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d40878f8e  ONLINE       0     0     0

errors: Permanent errors have been detected in the following files:

        send/test/l0_1/l1_1/l2_1@1739318230.2025-02-11-1757:<0x0>
root@orcus:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   372G  92.0G        -         -     9%    80%  1.00x    ONLINE  -
send   464G   339G   125G        -         -    28%    73%  1.00x    ONLINE  -
root@orcus:~# zfs list -t snap -r send | wc -l
3901
root@orcus:~# zfs list -t snap -r recv | wc -l
7720
root@orcus:~# 
```

It will be necessary to manage snapshots in `recv` to avoid disk full during long running texts.

The error as reported ny syncoid:

```text
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-11:17:55:57-GMT-06:00 ... syncoid_orcus_2025-02-11:17:57:12-GMT-06:00 (~ 21.7 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_1@1739318230.2025-02-11-1757': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_1/l2_1 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_1'@'syncoid_orcus_2025-02-11:17:55:57-GMT-06:00' 'send/test/l0_1/l1_1/l2_1'@'syncoid_orcus_2025-02-11:17:57:12-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 22772136 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_1' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_orcus_2025-02-11:17:56:00-GMT-06:00 ... syncoid_orcus_2025-02-11:17:57:13-GMT-06:00 (~ 22.5 MB):
```

The previous syncoid run appeared to complete w/out issue. The full log can be viewed in [Data](./data.md#2025-02-11-syncoid-that-produced-the-error).
