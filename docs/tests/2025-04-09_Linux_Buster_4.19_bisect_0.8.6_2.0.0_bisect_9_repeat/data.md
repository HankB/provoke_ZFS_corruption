# Data: Git bisect 0.8.6 to 2.0.0 - testing tenth bisect - repeat

* [Data](./data.md)
* [Setup](./setup.md)
* [home/index](./../../index.md)

## 2025-04-09 first syncoid

```text
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_orion_2025-04-09:08:47:26-GMT-05:00 to new target filesystem recv/test (~ 86 KB):
47.7KiB 0:00:00 [3.40MiB/s] [======================================================>                                             ] 55%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_orion_2025-04-09:08:47:27-GMT-05:00 to new target filesystem recv/test/l0_0 (~ 15.7 GB):
15.7GiB 0:01:07 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_orion_2025-04-09:08:48:35-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0 (~ 15.4 GB):
15.4GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-09:08:49:41-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_0 (~ 15.2 GB):
15.2GiB 0:01:04 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-09:08:50:47-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_1 (~ 15.5 GB):
15.5GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-09:08:51:54-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_2 (~ 15.7 GB):
15.7GiB 0:01:07 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-09:08:53:02-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_3 (~ 15.1 GB):
15.1GiB 0:01:05 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_orion_2025-04-09:08:54:08-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1 (~ 15.6 GB):
15.6GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-09:08:55:16-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_0 (~ 14.6 GB):
14.6GiB 0:01:02 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-09:08:56:19-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_1 (~ 15.3 GB):
15.3GiB 0:01:05 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-09:08:57:24-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_2 (~ 15.8 GB):
15.8GiB 0:01:08 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-09:08:58:33-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_3 (~ 15.4 GB):
15.4GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_orion_2025-04-09:08:59:40-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2 (~ 15.6 GB):
15.6GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-09:09:00:48-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_0 (~ 15.7 GB):
15.7GiB 0:01:06 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-09:09:01:55-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_1 (~ 15.4 GB):
15.4GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-09:09:03:02-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_2 (~ 15.7 GB):
15.7GiB 0:01:07 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-09:09:04:10-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_3 (~ 15.6 GB):
15.6GiB 0:01:07 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_orion_2025-04-09:09:05:17-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3 (~ 15.8 GB):
15.8GiB 0:01:07 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-09:09:06:25-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_0 (~ 15.8 GB):
15.8GiB 0:01:08 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-09:09:07:33-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_1 (~ 15.8 GB):
15.8GiB 0:01:08 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-09:09:08:43-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_2 (~ 15.4 GB):
15.4GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-09:09:09:49-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_3 (~ 15.6 GB):
15.6GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_orion_2025-04-09:09:10:57-GMT-05:00 to new target filesystem recv/test/l0_1 (~ 15.8 GB):
15.8GiB 0:01:08 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_orion_2025-04-09:09:12:06-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0 (~ 15.2 GB):
15.2GiB 0:01:06 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-09:09:13:13-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_0 (~ 15.5 GB):
15.5GiB 0:01:07 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-09:09:14:20-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_1 (~ 15.5 GB):
15.5GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-09:09:15:28-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_2 (~ 15.5 GB):
15.5GiB 0:01:07 [ 234MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-09:09:16:36-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_3 (~ 15.2 GB):
15.2GiB 0:01:06 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_orion_2025-04-09:09:17:42-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1 (~ 15.4 GB):
15.4GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-09:09:18:49-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_0 (~ 15.9 GB):
15.9GiB 0:01:08 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-09:09:19:57-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_1 (~ 15.7 GB):
15.7GiB 0:01:08 [ 235MiB/s] [==================================================================================================>] 100%            
real 2019.74
user 29.49
sys 1970.11
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   238G   226G        -         -     0%    51%  1.00x    ONLINE  -
send   464G   238G   226G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# 
```

## 2025-04-09 last syncoid

```text
hbarta@orion:~/logs$ cat 2025-04-09-124137.syncoid.111.txt
INFO: Sending incremental send/test@syncoid_orion_2025-04-09:12:39:42-GMT-05:00 ... syncoid_orion_2025-04-09:12:41:38-GMT-05:00 to recv/test (~ 4 KB):
INFO: Sending incremental send/test/l0_0@syncoid_orion_2025-04-09:12:39:44-GMT-05:00 ... syncoid_orion_2025-04-09:12:41:39-GMT-05:00 to recv/test/l0_0 (~ 62.6 MB):
INFO: Sending incremental send/test/l0_0/l1_0@syncoid_orion_2025-04-09:12:39:47-GMT-05:00 ... syncoid_orion_2025-04-09:12:41:43-GMT-05:00 to recv/test/l0_0/l1_0 (~ 43.8 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-09:12:39:52-GMT-05:00 ... syncoid_orion_2025-04-09:12:41:47-GMT-05:00 to recv/test/l0_0/l1_0/l2_0 (~ 44.2 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-09:12:39:56-GMT-05:00 ... syncoid_orion_2025-04-09:12:41:50-GMT-05:00 to recv/test/l0_0/l1_0/l2_1 (~ 46.0 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-09:12:40:00-GMT-05:00 ... syncoid_orion_2025-04-09:12:41:54-GMT-05:00 to recv/test/l0_0/l1_0/l2_2 (~ 44.9 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-09:12:40:04-GMT-05:00 ... syncoid_orion_2025-04-09:12:41:58-GMT-05:00 to recv/test/l0_0/l1_0/l2_3 (~ 66.1 MB):
INFO: Sending incremental send/test/l0_0/l1_1@syncoid_orion_2025-04-09:12:40:08-GMT-05:00 ... syncoid_orion_2025-04-09:12:42:02-GMT-05:00 to recv/test/l0_0/l1_1 (~ 68.6 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-09:12:40:12-GMT-05:00 ... syncoid_orion_2025-04-09:12:42:06-GMT-05:00 to recv/test/l0_0/l1_1/l2_0 (~ 49.7 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-09:12:40:16-GMT-05:00 ... syncoid_orion_2025-04-09:12:42:10-GMT-05:00 to recv/test/l0_0/l1_1/l2_1 (~ 46.5 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-09:12:40:20-GMT-05:00 ... syncoid_orion_2025-04-09:12:42:13-GMT-05:00 to recv/test/l0_0/l1_1/l2_2 (~ 44.1 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-09:12:40:24-GMT-05:00 ... syncoid_orion_2025-04-09:12:42:16-GMT-05:00 to recv/test/l0_0/l1_1/l2_3 (~ 43.2 MB):
INFO: Sending incremental send/test/l0_0/l1_2@syncoid_orion_2025-04-09:12:40:29-GMT-05:00 ... syncoid_orion_2025-04-09:12:42:19-GMT-05:00 to recv/test/l0_0/l1_2 (~ 58.1 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-09:12:40:33-GMT-05:00 ... syncoid_orion_2025-04-09:12:42:22-GMT-05:00 to recv/test/l0_0/l1_2/l2_0 (~ 66.2 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-09:12:40:37-GMT-05:00 ... syncoid_orion_2025-04-09:12:42:26-GMT-05:00 to recv/test/l0_0/l1_2/l2_1 (~ 68.7 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_1'@'syncoid_orion_2025-04-09:12:40:37-GMT-05:00' 'send/test/l0_0/l1_2/l2_1'@'syncoid_orion_2025-04-09:12:42:26-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 72004328 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_1' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-09:12:40:40-GMT-05:00 ... syncoid_orion_2025-04-09:12:42:29-GMT-05:00 to recv/test/l0_0/l1_2/l2_2 (~ 70.0 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-09:12:40:44-GMT-05:00 ... syncoid_orion_2025-04-09:12:42:34-GMT-05:00 to recv/test/l0_0/l1_2/l2_3 (~ 69.2 MB):
INFO: Sending incremental send/test/l0_0/l1_3@syncoid_orion_2025-04-09:12:40:47-GMT-05:00 ... syncoid_orion_2025-04-09:12:42:38-GMT-05:00 to recv/test/l0_0/l1_3 (~ 64.9 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-09:12:40:52-GMT-05:00 ... syncoid_orion_2025-04-09:12:42:42-GMT-05:00 to recv/test/l0_0/l1_3/l2_0 (~ 66.0 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-09:12:40:55-GMT-05:00 ... syncoid_orion_2025-04-09:12:42:47-GMT-05:00 to recv/test/l0_0/l1_3/l2_1 (~ 67.6 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-09:12:40:59-GMT-05:00 ... syncoid_orion_2025-04-09:12:42:51-GMT-05:00 to recv/test/l0_0/l1_3/l2_2 (~ 65.0 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-09:12:41:02-GMT-05:00 ... syncoid_orion_2025-04-09:12:42:55-GMT-05:00 to recv/test/l0_0/l1_3/l2_3 (~ 68.7 MB):
INFO: Sending incremental send/test/l0_1@syncoid_orion_2025-04-09:12:41:05-GMT-05:00 ... syncoid_orion_2025-04-09:12:42:59-GMT-05:00 to recv/test/l0_1 (~ 66.4 MB):
INFO: Sending incremental send/test/l0_1/l1_0@syncoid_orion_2025-04-09:12:41:09-GMT-05:00 ... syncoid_orion_2025-04-09:12:43:03-GMT-05:00 to recv/test/l0_1/l1_0 (~ 67.8 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-09:12:41:13-GMT-05:00 ... syncoid_orion_2025-04-09:12:43:06-GMT-05:00 to recv/test/l0_1/l1_0/l2_0 (~ 64.8 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-09:12:41:16-GMT-05:00 ... syncoid_orion_2025-04-09:12:43:10-GMT-05:00 to recv/test/l0_1/l1_0/l2_1 (~ 67.1 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_1'@'syncoid_orion_2025-04-09:12:41:16-GMT-05:00' 'send/test/l0_1/l1_0/l2_1'@'syncoid_orion_2025-04-09:12:43:10-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 70354904 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_1' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-09:12:41:20-GMT-05:00 ... syncoid_orion_2025-04-09:12:43:13-GMT-05:00 to recv/test/l0_1/l1_0/l2_2 (~ 68.1 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-09:12:41:24-GMT-05:00 ... syncoid_orion_2025-04-09:12:43:17-GMT-05:00 to recv/test/l0_1/l1_0/l2_3 (~ 67.9 MB):
INFO: Sending incremental send/test/l0_1/l1_1@syncoid_orion_2025-04-09:12:41:27-GMT-05:00 ... syncoid_orion_2025-04-09:12:43:20-GMT-05:00 to recv/test/l0_1/l1_1 (~ 43.2 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-09:12:41:31-GMT-05:00 ... syncoid_orion_2025-04-09:12:43:24-GMT-05:00 to recv/test/l0_1/l1_1/l2_0 (~ 45.8 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-09:12:41:34-GMT-05:00 ... syncoid_orion_2025-04-09:12:43:27-GMT-05:00 to recv/test/l0_1/l1_1/l2_1 (~ 44.9 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_1'@'syncoid_orion_2025-04-09:12:41:34-GMT-05:00' 'send/test/l0_1/l1_1/l2_1'@'syncoid_orion_2025-04-09:12:43:27-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 47064624 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_1' 2>&1 failed: 256
errors: List of errors unavailable: permission denied
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: http://zfsonlinux.org/msg/ZFS-8000-8A
  scan: none requested
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: 3 data errors, use '-v' for a list
```

## 2025-04-09 various pool status

```text
hbarta@orion:~/logs$ zpool status
  pool: recv
 state: ONLINE
  scan: none requested
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
   see: http://zfsonlinux.org/msg/ZFS-8000-8A
  scan: none requested
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0
errors: List of errors unavailable: permission denied

errors: 3 data errors, use '-v' for a list
hbarta@orion:~/logs$ sudo zpool status
  pool: recv
 state: ONLINE
  scan: none requested
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
   see: http://zfsonlinux.org/msg/ZFS-8000-8A
  scan: none requested
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: 3 data errors, use '-v' for a list
hbarta@orion:~/logs$ sudo zpool status -v
  pool: recv
 state: ONLINE
  scan: none requested
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
   see: http://zfsonlinux.org/msg/ZFS-8000-8A
  scan: none requested
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: Permanent errors have been detected in the following files:

        send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-09:12:42:26-GMT-05:00:<0x0>
        send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-09:12:43:10-GMT-05:00:<0x0>
        send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-09:12:43:27-GMT-05:00:<0x0>
hbarta@orion:~/logs$ 
```