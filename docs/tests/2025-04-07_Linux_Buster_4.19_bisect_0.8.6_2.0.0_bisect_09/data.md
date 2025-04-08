# Data: Git bisect 0.8.6 to 2.0.0 - testing ninth bisect

* [Setup](./setup.md)
* [Results](./results.md)

## 2025-04-07 first syncoid

```text
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_orion_2025-04-07:13:09:42-GMT-05:00 to new target filesystem recv/test (~ 70 KB):
47.4KiB 0:00:00 [5.91MiB/s] [==================================================================>                                 ] 67%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_orion_2025-04-07:13:09:42-GMT-05:00 to new target filesystem recv/test/l0_0 (~ 15.1 GB):
15.1GiB 0:01:03 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_orion_2025-04-07:13:10:46-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0 (~ 15.5 GB):
15.5GiB 0:01:07 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-07:13:11:54-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_0 (~ 15.3 GB):
15.3GiB 0:01:06 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-07:13:13:01-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_1 (~ 15.3 GB):
15.3GiB 0:01:06 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-07:13:14:08-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_2 (~ 15.5 GB):
15.5GiB 0:01:06 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-07:13:15:15-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_3 (~ 15.2 GB):
15.2GiB 0:01:05 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_orion_2025-04-07:13:16:21-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1 (~ 15.7 GB):
15.7GiB 0:01:08 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-07:13:17:30-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_0 (~ 15.7 GB):
15.7GiB 0:01:07 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-07:13:18:38-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_1 (~ 15.3 GB):
15.3GiB 0:01:04 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-07:13:19:44-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_2 (~ 15.1 GB):
15.1GiB 0:01:04 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-07:13:20:49-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_3 (~ 15.8 GB):
15.8GiB 0:01:07 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_orion_2025-04-07:13:21:57-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2 (~ 15.4 GB):
15.4GiB 0:01:05 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-07:13:23:03-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_0 (~ 15.6 GB):
15.6GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-07:13:24:11-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_1 (~ 15.2 GB):
15.2GiB 0:01:06 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-07:13:25:18-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_2 (~ 15.6 GB):
15.6GiB 0:01:08 [ 234MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-07:13:26:27-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_3 (~ 15.5 GB):
15.5GiB 0:01:06 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_orion_2025-04-07:13:27:34-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3 (~ 15.4 GB):
15.4GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-07:13:28:40-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_0 (~ 15.4 GB):
15.4GiB 0:01:07 [ 234MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-07:13:29:48-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_1 (~ 15.8 GB):
15.8GiB 0:01:08 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-07:13:30:57-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_2 (~ 15.4 GB):
15.4GiB 0:01:06 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-07:13:32:05-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_3 (~ 15.3 GB):
15.3GiB 0:01:05 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_orion_2025-04-07:13:33:11-GMT-05:00 to new target filesystem recv/test/l0_1 (~ 15.5 GB):
15.5GiB 0:01:06 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_orion_2025-04-07:13:34:18-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0 (~ 15.3 GB):
15.3GiB 0:01:05 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-07:13:35:23-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_0 (~ 15.4 GB):
15.4GiB 0:01:05 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-07:13:36:29-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_1 (~ 15.5 GB):
15.5GiB 0:01:06 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-07:13:37:37-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_2 (~ 15.4 GB):
15.4GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-07:13:38:44-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_3 (~ 15.3 GB):
15.4GiB 0:01:06 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_orion_2025-04-07:13:39:50-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1 (~ 15.5 GB):
15.5GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-07:13:40:58-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_0 (~ 16.0 GB):
16.0GiB 0:01:09 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-07:13:42:07-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_1 (~ 15.5 GB):
15.5GiB 0:01:05 [ 240MiB/s] [==================================================================================================>] 100%            
real 2012.30
user 28.80
sys 1948.26
root@orion:~# 
```

## 2025-04-07 last syncoid

```text
hbarta@orion:~/logs$ cat 2025-04-07-173423.syncoid.104.txt
INFO: Sending incremental send/test@syncoid_orion_2025-04-07:17:32:32-GMT-05:00 ... syncoid_orion_2025-04-07:17:34:24-GMT-05:00 to recv/test (~ 4 KB):
INFO: Sending incremental send/test/l0_0@syncoid_orion_2025-04-07:17:32:34-GMT-05:00 ... syncoid_orion_2025-04-07:17:34:25-GMT-05:00 to recv/test/l0_0 (~ 53.8 MB):
INFO: Sending incremental send/test/l0_0/l1_0@syncoid_orion_2025-04-07:17:32:38-GMT-05:00 ... syncoid_orion_2025-04-07:17:34:28-GMT-05:00 to recv/test/l0_0/l1_0 (~ 46.0 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-07:17:32:42-GMT-05:00 ... syncoid_orion_2025-04-07:17:34:31-GMT-05:00 to recv/test/l0_0/l1_0/l2_0 (~ 47.5 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-07:17:32:46-GMT-05:00 ... syncoid_orion_2025-04-07:17:34:34-GMT-05:00 to recv/test/l0_0/l1_0/l2_1 (~ 45.2 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-07:17:32:51-GMT-05:00 ... syncoid_orion_2025-04-07:17:34:37-GMT-05:00 to recv/test/l0_0/l1_0/l2_2 (~ 44.6 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-07:17:32:54-GMT-05:00 ... syncoid_orion_2025-04-07:17:34:40-GMT-05:00 to recv/test/l0_0/l1_0/l2_3 (~ 66.4 MB):
INFO: Sending incremental send/test/l0_0/l1_1@syncoid_orion_2025-04-07:17:32:58-GMT-05:00 ... syncoid_orion_2025-04-07:17:34:43-GMT-05:00 to recv/test/l0_0/l1_1 (~ 45.8 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-07:17:33:01-GMT-05:00 ... syncoid_orion_2025-04-07:17:34:46-GMT-05:00 to recv/test/l0_0/l1_1/l2_0 (~ 44.6 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-07:17:33:05-GMT-05:00 ... syncoid_orion_2025-04-07:17:34:49-GMT-05:00 to recv/test/l0_0/l1_1/l2_1 (~ 46.5 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-07:17:33:09-GMT-05:00 ... syncoid_orion_2025-04-07:17:34:53-GMT-05:00 to recv/test/l0_0/l1_1/l2_2 (~ 66.8 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-07:17:33:13-GMT-05:00 ... syncoid_orion_2025-04-07:17:34:57-GMT-05:00 to recv/test/l0_0/l1_1/l2_3 (~ 67.1 MB):
INFO: Sending incremental send/test/l0_0/l1_2@syncoid_orion_2025-04-07:17:33:16-GMT-05:00 ... syncoid_orion_2025-04-07:17:35:01-GMT-05:00 to recv/test/l0_0/l1_2 (~ 62.2 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-07:17:33:20-GMT-05:00 ... syncoid_orion_2025-04-07:17:35:06-GMT-05:00 to recv/test/l0_0/l1_2/l2_0 (~ 66.8 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-07:17:33:23-GMT-05:00 ... syncoid_orion_2025-04-07:17:35:10-GMT-05:00 to recv/test/l0_0/l1_2/l2_1 (~ 67.3 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-07:17:33:27-GMT-05:00 ... syncoid_orion_2025-04-07:17:35:14-GMT-05:00 to recv/test/l0_0/l1_2/l2_2 (~ 68.5 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-07:17:33:30-GMT-05:00 ... syncoid_orion_2025-04-07:17:35:18-GMT-05:00 to recv/test/l0_0/l1_2/l2_3 (~ 66.4 MB):
INFO: Sending incremental send/test/l0_0/l1_3@syncoid_orion_2025-04-07:17:33:34-GMT-05:00 ... syncoid_orion_2025-04-07:17:35:22-GMT-05:00 to recv/test/l0_0/l1_3 (~ 48.2 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-07:17:33:38-GMT-05:00 ... syncoid_orion_2025-04-07:17:35:25-GMT-05:00 to recv/test/l0_0/l1_3/l2_0 (~ 50.1 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-07:17:33:41-GMT-05:00 ... syncoid_orion_2025-04-07:17:35:28-GMT-05:00 to recv/test/l0_0/l1_3/l2_1 (~ 43.9 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-07:17:33:45-GMT-05:00 ... syncoid_orion_2025-04-07:17:35:31-GMT-05:00 to recv/test/l0_0/l1_3/l2_2 (~ 45.1 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-07:17:33:49-GMT-05:00 ... syncoid_orion_2025-04-07:17:35:34-GMT-05:00 to recv/test/l0_0/l1_3/l2_3 (~ 67.5 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_3'@'syncoid_orion_2025-04-07:17:33:49-GMT-05:00' 'send/test/l0_0/l1_3/l2_3'@'syncoid_orion_2025-04-07:17:35:34-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 70806200 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_3' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1@syncoid_orion_2025-04-07:17:33:52-GMT-05:00 ... syncoid_orion_2025-04-07:17:35:37-GMT-05:00 to recv/test/l0_1 (~ 44.2 MB):
INFO: Sending incremental send/test/l0_1/l1_0@syncoid_orion_2025-04-07:17:33:56-GMT-05:00 ... syncoid_orion_2025-04-07:17:35:40-GMT-05:00 to recv/test/l0_1/l1_0 (~ 43.0 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-07:17:34:00-GMT-05:00 ... syncoid_orion_2025-04-07:17:35:44-GMT-05:00 to recv/test/l0_1/l1_0/l2_0 (~ 44.7 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-07:17:34:03-GMT-05:00 ... syncoid_orion_2025-04-07:17:35:47-GMT-05:00 to recv/test/l0_1/l1_0/l2_1 (~ 45.6 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-07:17:34:07-GMT-05:00 ... syncoid_orion_2025-04-07:17:35:51-GMT-05:00 to recv/test/l0_1/l1_0/l2_2 (~ 48.0 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-07:17:34:11-GMT-05:00 ... syncoid_orion_2025-04-07:17:35:54-GMT-05:00 to recv/test/l0_1/l1_0/l2_3 (~ 69.0 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_3'@'syncoid_orion_2025-04-07:17:34:11-GMT-05:00' 'send/test/l0_1/l1_0/l2_3'@'syncoid_orion_2025-04-07:17:35:54-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 72376992 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_3' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1/l1_1@syncoid_orion_2025-04-07:17:34:14-GMT-05:00 ... syncoid_orion_2025-04-07:17:35:57-GMT-05:00 to recv/test/l0_1/l1_1 (~ 66.4 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-07:17:34:18-GMT-05:00 ... syncoid_orion_2025-04-07:17:36:02-GMT-05:00 to recv/test/l0_1/l1_1/l2_0 (~ 66.5 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-07:17:34:21-GMT-05:00 ... syncoid_orion_2025-04-07:17:36:05-GMT-05:00 to recv/test/l0_1/l1_1/l2_1 (~ 68.3 MB):
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

errors: 2 data errors, use '-v' for a list
hbarta@orion:~/logs$ 
```