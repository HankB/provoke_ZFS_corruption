# Data: Git bisect 0.8.6 to 2.0.0 - testing tenth bisect

* [Setup](./setup.md)
* [Results](./results.md)

## 2025-04-08 first syncoid

```text
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_orion_2025-04-07:21:00:09-GMT-05:00 to new target filesystem recv/test (~ 86 KB):
47.7KiB 0:00:00 [3.14MiB/s] [======================================================>                                             ] 55%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_orion_2025-04-07:21:00:09-GMT-05:00 to new target filesystem recv/test/l0_0 (~ 15.1 GB):
15.1GiB 0:01:05 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_orion_2025-04-07:21:01:15-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0 (~ 15.4 GB):
15.4GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-07:21:02:21-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_0 (~ 15.2 GB):
15.2GiB 0:01:05 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-07:21:03:28-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_1 (~ 15.7 GB):
15.7GiB 0:01:08 [ 234MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-07:21:04:37-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_2 (~ 15.6 GB):
15.6GiB 0:01:07 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-07:21:05:45-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_3 (~ 15.6 GB):
15.6GiB 0:01:07 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_orion_2025-04-07:21:06:52-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1 (~ 15.8 GB):
15.8GiB 0:01:07 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-07:21:08:01-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_0 (~ 15.7 GB):
15.7GiB 0:01:07 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-07:21:09:08-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_1 (~ 15.7 GB):
15.7GiB 0:01:07 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-07:21:10:16-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_2 (~ 15.4 GB):
15.4GiB 0:01:05 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-07:21:11:22-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_3 (~ 15.3 GB):
15.3GiB 0:01:05 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_orion_2025-04-07:21:12:28-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2 (~ 15.6 GB):
15.6GiB 0:01:07 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-07:21:13:36-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_0 (~ 15.6 GB):
15.6GiB 0:01:06 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-07:21:14:43-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_1 (~ 15.6 GB):
15.6GiB 0:01:07 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-07:21:15:51-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_2 (~ 15.4 GB):
15.4GiB 0:01:07 [ 234MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-07:21:16:58-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_3 (~ 15.3 GB):
15.3GiB 0:01:06 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_orion_2025-04-07:21:18:05-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3 (~ 15.5 GB):
15.5GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-07:21:19:12-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_0 (~ 15.6 GB):
15.6GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-07:21:20:20-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_1 (~ 15.4 GB):
15.4GiB 0:01:07 [ 234MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-07:21:21:28-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_2 (~ 14.9 GB):
14.9GiB 0:01:03 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-07:21:22:32-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_3 (~ 15.4 GB):
15.4GiB 0:01:05 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_orion_2025-04-07:21:23:38-GMT-05:00 to new target filesystem recv/test/l0_1 (~ 15.3 GB):
15.3GiB 0:01:05 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_orion_2025-04-07:21:24:44-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0 (~ 15.5 GB):
15.5GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-07:21:25:51-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_0 (~ 15.5 GB):
15.5GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-07:21:26:58-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_1 (~ 15.1 GB):
15.1GiB 0:01:05 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-07:21:28:04-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_2 (~ 15.4 GB):
15.4GiB 0:01:06 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-07:21:29:11-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_3 (~ 15.3 GB):
15.3GiB 0:01:06 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_orion_2025-04-07:21:30:18-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1 (~ 15.5 GB):
15.5GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-07:21:31:25-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_0 (~ 15.8 GB):
15.8GiB 0:01:08 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-07:21:32:34-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_1 (~ 15.3 GB):
15.4GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
real 2012.05
user 27.95
sys 1946.69
root@orion:~# 
```

## 2025-04-08 last syncoid

```text
hbarta@orion:~/logs$ cat 2025-04-08-002644.syncoid.119.txt
INFO: Sending incremental send/test@syncoid_orion_2025-04-08:00:24:46-GMT-05:00 ... syncoid_orion_2025-04-08:00:26:45-GMT-05:00 to recv/test (~ 4 KB):
INFO: Sending incremental send/test/l0_0@syncoid_orion_2025-04-08:00:24:48-GMT-05:00 ... syncoid_orion_2025-04-08:00:26:47-GMT-05:00 to recv/test/l0_0 (~ 67.7 MB):
INFO: Sending incremental send/test/l0_0/l1_0@syncoid_orion_2025-04-08:00:24:51-GMT-05:00 ... syncoid_orion_2025-04-08:00:26:51-GMT-05:00 to recv/test/l0_0/l1_0 (~ 69.5 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-08:00:24:55-GMT-05:00 ... syncoid_orion_2025-04-08:00:26:56-GMT-05:00 to recv/test/l0_0/l1_0/l2_0 (~ 65.8 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-08:00:24:58-GMT-05:00 ... syncoid_orion_2025-04-08:00:27:00-GMT-05:00 to recv/test/l0_0/l1_0/l2_1 (~ 64.2 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-08:00:25:02-GMT-05:00 ... syncoid_orion_2025-04-08:00:27:04-GMT-05:00 to recv/test/l0_0/l1_0/l2_2 (~ 43.8 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-08:00:25:06-GMT-05:00 ... syncoid_orion_2025-04-08:00:27:08-GMT-05:00 to recv/test/l0_0/l1_0/l2_3 (~ 58.0 MB):
INFO: Sending incremental send/test/l0_0/l1_1@syncoid_orion_2025-04-08:00:25:10-GMT-05:00 ... syncoid_orion_2025-04-08:00:27:11-GMT-05:00 to recv/test/l0_0/l1_1 (~ 63.5 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-08:00:25:14-GMT-05:00 ... syncoid_orion_2025-04-08:00:27:16-GMT-05:00 to recv/test/l0_0/l1_1/l2_0 (~ 44.8 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-08:00:25:18-GMT-05:00 ... syncoid_orion_2025-04-08:00:27:19-GMT-05:00 to recv/test/l0_0/l1_1/l2_1 (~ 44.2 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-08:00:25:22-GMT-05:00 ... syncoid_orion_2025-04-08:00:27:23-GMT-05:00 to recv/test/l0_0/l1_1/l2_2 (~ 45.6 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-08:00:25:27-GMT-05:00 ... syncoid_orion_2025-04-08:00:27:26-GMT-05:00 to recv/test/l0_0/l1_1/l2_3 (~ 69.6 MB):
INFO: Sending incremental send/test/l0_0/l1_2@syncoid_orion_2025-04-08:00:25:31-GMT-05:00 ... syncoid_orion_2025-04-08:00:27:30-GMT-05:00 to recv/test/l0_0/l1_2 (~ 68.8 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-08:00:25:35-GMT-05:00 ... syncoid_orion_2025-04-08:00:27:34-GMT-05:00 to recv/test/l0_0/l1_2/l2_0 (~ 67.9 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-08:00:25:39-GMT-05:00 ... syncoid_orion_2025-04-08:00:27:39-GMT-05:00 to recv/test/l0_0/l1_2/l2_1 (~ 65.5 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-08:00:25:42-GMT-05:00 ... syncoid_orion_2025-04-08:00:27:43-GMT-05:00 to recv/test/l0_0/l1_2/l2_2 (~ 66.4 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-08:00:25:46-GMT-05:00 ... syncoid_orion_2025-04-08:00:27:48-GMT-05:00 to recv/test/l0_0/l1_2/l2_3 (~ 68.1 MB):
INFO: Sending incremental send/test/l0_0/l1_3@syncoid_orion_2025-04-08:00:25:49-GMT-05:00 ... syncoid_orion_2025-04-08:00:27:52-GMT-05:00 to recv/test/l0_0/l1_3 (~ 65.5 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-08:00:25:53-GMT-05:00 ... syncoid_orion_2025-04-08:00:27:56-GMT-05:00 to recv/test/l0_0/l1_3/l2_0 (~ 67.4 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-08:00:25:57-GMT-05:00 ... syncoid_orion_2025-04-08:00:28:00-GMT-05:00 to recv/test/l0_0/l1_3/l2_1 (~ 69.5 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-08:00:26:02-GMT-05:00 ... syncoid_orion_2025-04-08:00:28:04-GMT-05:00 to recv/test/l0_0/l1_3/l2_2 (~ 66.1 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-08:00:26:06-GMT-05:00 ... syncoid_orion_2025-04-08:00:28:08-GMT-05:00 to recv/test/l0_0/l1_3/l2_3 (~ 66.3 MB):
INFO: Sending incremental send/test/l0_1@syncoid_orion_2025-04-08:00:26:09-GMT-05:00 ... syncoid_orion_2025-04-08:00:28:12-GMT-05:00 to recv/test/l0_1 (~ 50.5 MB):
INFO: Sending incremental send/test/l0_1/l1_0@syncoid_orion_2025-04-08:00:26:13-GMT-05:00 ... syncoid_orion_2025-04-08:00:28:16-GMT-05:00 to recv/test/l0_1/l1_0 (~ 53.2 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-08:00:26:17-GMT-05:00 ... syncoid_orion_2025-04-08:00:28:19-GMT-05:00 to recv/test/l0_1/l1_0/l2_0 (~ 45.7 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-08:00:26:21-GMT-05:00 ... syncoid_orion_2025-04-08:00:28:22-GMT-05:00 to recv/test/l0_1/l1_0/l2_1 (~ 42.4 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-08:00:26:26-GMT-05:00 ... syncoid_orion_2025-04-08:00:28:25-GMT-05:00 to recv/test/l0_1/l1_0/l2_2 (~ 67.5 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-08:00:26:30-GMT-05:00 ... syncoid_orion_2025-04-08:00:28:29-GMT-05:00 to recv/test/l0_1/l1_0/l2_3 (~ 69.6 MB):
INFO: Sending incremental send/test/l0_1/l1_1@syncoid_orion_2025-04-08:00:26:34-GMT-05:00 ... syncoid_orion_2025-04-08:00:28:33-GMT-05:00 to recv/test/l0_1/l1_1 (~ 66.6 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-08:00:26:38-GMT-05:00 ... syncoid_orion_2025-04-08:00:28:37-GMT-05:00 to recv/test/l0_1/l1_1/l2_0 (~ 64.9 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-08:00:26:42-GMT-05:00 ... syncoid_orion_2025-04-08:00:28:41-GMT-05:00 to recv/test/l0_1/l1_1/l2_1 (~ 65.5 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_1'@'syncoid_orion_2025-04-08:00:26:42-GMT-05:00' 'send/test/l0_1/l1_1/l2_1'@'syncoid_orion_2025-04-08:00:28:41-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 68661488 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_1' 2>&1 failed: 256
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

errors: 1 data errors, use '-v' for a list
hbarta@orion:~/logs$ 
```
