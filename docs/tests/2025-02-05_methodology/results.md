# results

This test is with current Debian kernel and ZFS from the standard repos (e.g. no backports.)

```text
hbarta@orcus:~$ uname -a
Linux orcus 6.1.0-30-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.124-1 (2025-01-12) x86_64 GNU/Linux
hbarta@orcus:~$ zfs --version
zfs-2.1.11-1+deb12u1
zfs-kmod-2.1.11-1+deb12u1
hbarta@orcus:~$ 
```

[Setup](./setup.md)  
[Data](./data.md)

## 2025-02-06 corruption produced

Corruption was not produced in nearly a day with serial operations. Corruption *in about 15 minutes* with parallel operations. This is a vast improvement over previous tests that tool days to produce corruption.

Great Success! Corruption produced before I finished lunch, about 15 minutes after the test started. Unfortunately the logic to terminate the test when the first error occurred failed. (That takes nothing away from the results.) The error was recognized following a `syncoid` run and the log contained the following lines:

```text
Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orcus_2025-02-06:13:49:51-GMT-06:00 ... syncoid_orcus_2025-02-06:13:51:21-GMT-06:00 (~ 42.9 MB):
warning: cannot send 'send/test/l0_0/l1_1/l2_2@1738871469.2025-02-06-1351': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_1/l2_2 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_2'@'syncoid_orcus_2025-02-06:13:49:51-GMT-06:00' 'send/test/l0_0/l1_1/l2_2'@'syncoid_orcus_2025-02-06:13:51:21-GMT-06:00' | mbuffer  -q -s 128k -m 16M 2>/dev/null | pv -p -t -e -r -b -s 44959120 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_2' 2>&1 failed: 256 at /sbin/syncoid line 817.
Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orcus_2025-02-06:13:49:53-GMT-06:00 ... syncoid_orcus_2025-02-06:13:51:23-GMT-06:00 (~ 49.2 MB):
```

There were no indications in `dmesg` outout of any problems nor did anything in SMART stats hint at a problem (CRC error counters remained unchanged.)

There was a minor issue in that the test that was supposed to halt further testing when the first corruption was discovered did not work. That will be addressed before the next test.
