# data

## 2025-04-02 4.19 kernel, 2.0.0-1 ZFS

### 2025-04-02:1333 first syncoid

```text
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_orion_2025-04-02:12:58:26-GMT-05:00 to new target filesystem recv/test (~ 86 KB):
47.7KiB 0:00:00 [3.16MiB/s] [======================================================>                                             ] 55%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_orion_2025-04-02:12:58:27-GMT-05:00 to new target filesystem recv/test/l0_0 (~ 15.2 GB):
15.2GiB 0:01:02 [ 249MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_orion_2025-04-02:12:59:29-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0 (~ 15.5 GB):
15.5GiB 0:01:04 [ 248MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-02:13:00:34-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_0 (~ 15.6 GB):
15.6GiB 0:01:03 [ 249MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-02:13:01:38-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_1 (~ 15.0 GB):
15.0GiB 0:01:02 [ 246MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-02:13:02:41-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_2 (~ 15.6 GB):
15.6GiB 0:01:03 [ 252MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-02:13:03:45-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_3 (~ 15.3 GB):
15.3GiB 0:01:03 [ 247MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_orion_2025-04-02:13:04:49-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1 (~ 15.4 GB):
15.4GiB 0:01:04 [ 246MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-02:13:05:53-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_0 (~ 15.8 GB):
15.8GiB 0:01:04 [ 248MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-02:13:06:59-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_1 (~ 15.3 GB):
15.4GiB 0:01:04 [ 244MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-02:13:08:03-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_2 (~ 15.5 GB):
15.5GiB 0:01:03 [ 249MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-02:13:09:08-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_3 (~ 15.4 GB):
15.4GiB 0:01:04 [ 245MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_orion_2025-04-02:13:10:12-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2 (~ 15.3 GB):
15.3GiB 0:01:03 [ 246MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-02:13:11:17-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_0 (~ 15.4 GB):
15.4GiB 0:01:03 [ 249MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-02:13:12:20-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_1 (~ 15.3 GB):
15.3GiB 0:01:03 [ 246MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-02:13:13:24-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_2 (~ 15.5 GB):
15.5GiB 0:01:03 [ 252MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-02:13:14:28-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_3 (~ 14.9 GB):
14.9GiB 0:01:01 [ 249MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_orion_2025-04-02:13:15:30-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3 (~ 15.6 GB):
15.6GiB 0:01:03 [ 249MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-02:13:16:34-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_0 (~ 15.0 GB):
15.0GiB 0:01:02 [ 246MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-02:13:17:37-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_1 (~ 15.1 GB):
15.1GiB 0:01:01 [ 252MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-02:13:18:39-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_2 (~ 15.8 GB):
15.8GiB 0:01:05 [ 248MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-02:13:19:44-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_3 (~ 15.8 GB):
15.8GiB 0:01:05 [ 246MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_orion_2025-04-02:13:20:50-GMT-05:00 to new target filesystem recv/test/l0_1 (~ 15.7 GB):
15.7GiB 0:01:04 [ 249MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_orion_2025-04-02:13:21:55-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0 (~ 15.8 GB):
15.8GiB 0:01:05 [ 246MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-02:13:23:01-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_0 (~ 15.7 GB):
15.7GiB 0:01:04 [ 248MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-02:13:24:06-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_1 (~ 15.7 GB):
15.7GiB 0:01:04 [ 247MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-02:13:25:11-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_2 (~ 15.2 GB):
15.2GiB 0:01:02 [ 249MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-02:13:26:14-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_3 (~ 15.4 GB):
15.4GiB 0:01:02 [ 252MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_orion_2025-04-02:13:27:17-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1 (~ 15.8 GB):
15.8GiB 0:01:03 [ 252MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-02:13:28:21-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_0 (~ 15.5 GB):
15.5GiB 0:01:03 [ 250MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-02:13:29:25-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_1 (~ 15.1 GB):
15.1GiB 0:01:03 [ 245MiB/s] [==================================================================================================>] 100%            
real 1922.11
user 25.14
sys 1652.43
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   238G   226G        -         -     0%    51%  1.00x    ONLINE  -
send   464G   238G   226G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# 
```

## 2025-04-02-1551 last syncoid

Output from the last `syncoid` run:

```text
hbarta@orion:~/logs$ cat 2025-04-02-155133.syncoid.112.txt
INFO: Sending incremental send/test@syncoid_orion_2025-04-02:15:49:25-GMT-05:00 ... syncoid_orion_2025-04-02:15:51:34-GMT-05:00 to recv/test (~ 4 KB):
INFO: Sending incremental send/test/l0_0@syncoid_orion_2025-04-02:15:49:26-GMT-05:00 ... syncoid_orion_2025-04-02:15:51:36-GMT-05:00 to recv/test/l0_0 (~ 97.9 MB):
INFO: Sending incremental send/test/l0_0/l1_0@syncoid_orion_2025-04-02:15:49:30-GMT-05:00 ... syncoid_orion_2025-04-02:15:51:40-GMT-05:00 to recv/test/l0_0/l1_0 (~ 105.7 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-02:15:49:34-GMT-05:00 ... syncoid_orion_2025-04-02:15:51:44-GMT-05:00 to recv/test/l0_0/l1_0/l2_0 (~ 91.4 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-02:15:49:39-GMT-05:00 ... syncoid_orion_2025-04-02:15:51:49-GMT-05:00 to recv/test/l0_0/l1_0/l2_1 (~ 89.8 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-02:15:49:43-GMT-05:00 ... syncoid_orion_2025-04-02:15:51:53-GMT-05:00 to recv/test/l0_0/l1_0/l2_2 (~ 89.5 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-02:15:49:48-GMT-05:00 ... syncoid_orion_2025-04-02:15:51:58-GMT-05:00 to recv/test/l0_0/l1_0/l2_3 (~ 88.6 MB):
INFO: Sending incremental send/test/l0_0/l1_1@syncoid_orion_2025-04-02:15:49:51-GMT-05:00 ... syncoid_orion_2025-04-02:15:52:02-GMT-05:00 to recv/test/l0_0/l1_1 (~ 104.0 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-02:15:49:56-GMT-05:00 ... syncoid_orion_2025-04-02:15:52:06-GMT-05:00 to recv/test/l0_0/l1_1/l2_0 (~ 90.4 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-02:15:50:01-GMT-05:00 ... syncoid_orion_2025-04-02:15:52:10-GMT-05:00 to recv/test/l0_0/l1_1/l2_1 (~ 90.7 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-02:15:50:05-GMT-05:00 ... syncoid_orion_2025-04-02:15:52:15-GMT-05:00 to recv/test/l0_0/l1_1/l2_2 (~ 84.8 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-02:15:50:09-GMT-05:00 ... syncoid_orion_2025-04-02:15:52:19-GMT-05:00 to recv/test/l0_0/l1_1/l2_3 (~ 92.3 MB):
INFO: Sending incremental send/test/l0_0/l1_2@syncoid_orion_2025-04-02:15:50:13-GMT-05:00 ... syncoid_orion_2025-04-02:15:52:23-GMT-05:00 to recv/test/l0_0/l1_2 (~ 111.3 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-02:15:50:17-GMT-05:00 ... syncoid_orion_2025-04-02:15:52:28-GMT-05:00 to recv/test/l0_0/l1_2/l2_0 (~ 108.9 MB):
internal error: warning: cannot send 'send/test/l0_0/l1_2/l2_0@1743627129.2025-04-02-1552': Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_0'@'syncoid_orion_2025-04-02:15:50:17-GMT-05:00' 'send/test/l0_0/l1_2/l2_0'@'syncoid_orion_2025-04-02:15:52:28-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 114217672 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_0' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-02:15:50:21-GMT-05:00 ... syncoid_orion_2025-04-02:15:52:31-GMT-05:00 to recv/test/l0_0/l1_2/l2_1 (~ 88.2 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-02:15:50:26-GMT-05:00 ... syncoid_orion_2025-04-02:15:52:35-GMT-05:00 to recv/test/l0_0/l1_2/l2_2 (~ 89.0 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-02:15:50:31-GMT-05:00 ... syncoid_orion_2025-04-02:15:52:39-GMT-05:00 to recv/test/l0_0/l1_2/l2_3 (~ 89.0 MB):
INFO: Sending incremental send/test/l0_0/l1_3@syncoid_orion_2025-04-02:15:50:35-GMT-05:00 ... syncoid_orion_2025-04-02:15:52:43-GMT-05:00 to recv/test/l0_0/l1_3 (~ 90.3 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-02:15:50:39-GMT-05:00 ... syncoid_orion_2025-04-02:15:52:47-GMT-05:00 to recv/test/l0_0/l1_3/l2_0 (~ 89.5 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-02:15:50:43-GMT-05:00 ... syncoid_orion_2025-04-02:15:52:51-GMT-05:00 to recv/test/l0_0/l1_3/l2_1 (~ 89.6 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-02:15:50:48-GMT-05:00 ... syncoid_orion_2025-04-02:15:52:55-GMT-05:00 to recv/test/l0_0/l1_3/l2_2 (~ 88.0 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-02:15:50:52-GMT-05:00 ... syncoid_orion_2025-04-02:15:52:58-GMT-05:00 to recv/test/l0_0/l1_3/l2_3 (~ 90.9 MB):
INFO: Sending incremental send/test/l0_1@syncoid_orion_2025-04-02:15:50:56-GMT-05:00 ... syncoid_orion_2025-04-02:15:53:02-GMT-05:00 to recv/test/l0_1 (~ 66.2 MB):
INFO: Sending incremental send/test/l0_1/l1_0@syncoid_orion_2025-04-02:15:51:00-GMT-05:00 ... syncoid_orion_2025-04-02:15:53:05-GMT-05:00 to recv/test/l0_1/l1_0 (~ 67.9 MB):
internal error: warning: cannot send 'send/test/l0_1/l1_0@syncoid_orion_2025-04-02:15:53:05-GMT-05:00': Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0'@'syncoid_orion_2025-04-02:15:51:00-GMT-05:00' 'send/test/l0_1/l1_0'@'syncoid_orion_2025-04-02:15:53:05-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 71187096 |  zfs receive  -s -F 'recv/test/l0_1/l1_0' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-02:15:51:04-GMT-05:00 ... syncoid_orion_2025-04-02:15:53:07-GMT-05:00 to recv/test/l0_1/l1_0/l2_0 (~ 69.2 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-02:15:51:08-GMT-05:00 ... syncoid_orion_2025-04-02:15:53:10-GMT-05:00 to recv/test/l0_1/l1_0/l2_1 (~ 65.5 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-02:15:51:12-GMT-05:00 ... syncoid_orion_2025-04-02:15:53:12-GMT-05:00 to recv/test/l0_1/l1_0/l2_2 (~ 46.1 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-02:15:51:17-GMT-05:00 ... syncoid_orion_2025-04-02:15:53:15-GMT-05:00 to recv/test/l0_1/l1_0/l2_3 (~ 43.5 MB):
INFO: Sending incremental send/test/l0_1/l1_1@syncoid_orion_2025-04-02:15:51:21-GMT-05:00 ... syncoid_orion_2025-04-02:15:53:18-GMT-05:00 to recv/test/l0_1/l1_1 (~ 44.9 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-02:15:51:25-GMT-05:00 ... syncoid_orion_2025-04-02:15:53:20-GMT-05:00 to recv/test/l0_1/l1_1/l2_0 (~ 45.0 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-02:15:51:30-GMT-05:00 ... syncoid_orion_2025-04-02:15:53:23-GMT-05:00 to recv/test/l0_1/l1_1/l2_1 (~ 45.2 MB):
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

errors: 2 data errors, use '-v' for a list
hbarta@orion:~/logs$ 
```