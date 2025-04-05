# Data: Git bisect 0.8.6 to 2.0.0 - testing second bisect

* [Setup](./setup.md)
* [Results](./results.md)

## 2025-04-04 first syncoid as root

```text
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_orion_2025-04-04:15:20:26-GMT-05:00 to new target filesystem recv/test (~ 70 KB):
47.4KiB 0:00:00 [3.26MiB/s] [==================================================================>                                 ] 67%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_orion_2025-04-04:15:20:26-GMT-05:00 to new target filesystem recv/test/l0_0 (~ 15.3 GB):
15.4GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_orion_2025-04-04:15:21:33-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0 (~ 15.5 GB):
15.5GiB 0:01:06 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-04:15:22:40-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_0 (~ 15.7 GB):
15.7GiB 0:01:07 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-04:15:23:48-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_1 (~ 15.6 GB):
15.6GiB 0:01:07 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-04:15:24:55-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_2 (~ 15.5 GB):
15.5GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-04:15:26:03-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_3 (~ 15.6 GB):
15.7GiB 0:01:07 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_orion_2025-04-04:15:27:11-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1 (~ 15.5 GB):
15.5GiB 0:01:05 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-04:15:28:17-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_0 (~ 15.7 GB):
15.7GiB 0:01:07 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-04:15:29:25-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_1 (~ 15.3 GB):
15.3GiB 0:01:05 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-04:15:30:31-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_2 (~ 15.2 GB):
15.2GiB 0:01:04 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-04:15:31:35-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_3 (~ 15.5 GB):
15.5GiB 0:01:06 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_orion_2025-04-04:15:32:42-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2 (~ 15.9 GB):
15.9GiB 0:01:08 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-04:15:33:51-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_0 (~ 15.8 GB):
15.8GiB 0:01:07 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-04:15:34:59-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_1 (~ 15.4 GB):
15.4GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-04:15:36:06-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_2 (~ 15.5 GB):
15.6GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-04:15:37:14-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_3 (~ 15.5 GB):
15.5GiB 0:01:06 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_orion_2025-04-04:15:38:20-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3 (~ 15.4 GB):
15.4GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-04:15:39:27-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_0 (~ 15.7 GB):
15.7GiB 0:01:07 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-04:15:40:35-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_1 (~ 15.7 GB):
15.7GiB 0:01:07 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-04:15:41:42-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_2 (~ 15.4 GB):
15.4GiB 0:01:07 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-04:15:42:50-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_3 (~ 15.7 GB):
15.8GiB 0:01:08 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_orion_2025-04-04:15:43:59-GMT-05:00 to new target filesystem recv/test/l0_1 (~ 15.7 GB):
15.7GiB 0:01:06 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_orion_2025-04-04:15:45:05-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0 (~ 15.4 GB):
15.4GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-04:15:46:12-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_0 (~ 15.7 GB):
15.7GiB 0:01:06 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-04:15:47:19-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_1 (~ 15.5 GB):
15.5GiB 0:01:06 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-04:15:48:26-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_2 (~ 15.5 GB):
15.5GiB 0:01:06 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-04:15:49:32-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_3 (~ 15.5 GB):
15.5GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_orion_2025-04-04:15:50:40-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1 (~ 15.7 GB):
15.7GiB 0:01:08 [ 233MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-04:15:51:49-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_0 (~ 15.5 GB):
15.5GiB 0:01:05 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-04:15:52:55-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_1 (~ 15.7 GB):
15.7GiB 0:01:07 [ 237MiB/s] [==================================================================================================>] 100%            
real 2017.74
user 28.42
sys 1914.40
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   239G   225G        -         -     0%    51%  1.00x    ONLINE  -
send   464G   240G   224G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~#
```

## 2025-04-04 syncoid when corruption detected.

```text
hbarta@orion:~/logs$ cat halt_test.txt
2025-04-04-190223
2025-04-04-190304
hbarta@orion:~/logs$ cat 2025-04-04-190105.syncoid.119.txt
INFO: Sending incremental send/test@syncoid_orion_2025-04-04:18:58:57-GMT-05:00 ... syncoid_orion_2025-04-04:19:01:05-GMT-05:00 to recv/test (~ 4 KB):
INFO: Sending incremental send/test/l0_0@syncoid_orion_2025-04-04:18:58:59-GMT-05:00 ... syncoid_orion_2025-04-04:19:01:07-GMT-05:00 to recv/test/l0_0 (~ 62.5 MB):
INFO: Sending incremental send/test/l0_0/l1_0@syncoid_orion_2025-04-04:18:59:03-GMT-05:00 ... syncoid_orion_2025-04-04:19:01:12-GMT-05:00 to recv/test/l0_0/l1_0 (~ 69.2 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-04:18:59:07-GMT-05:00 ... syncoid_orion_2025-04-04:19:01:16-GMT-05:00 to recv/test/l0_0/l1_0/l2_0 (~ 67.5 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-04:18:59:11-GMT-05:00 ... syncoid_orion_2025-04-04:19:01:20-GMT-05:00 to recv/test/l0_0/l1_0/l2_1 (~ 66.1 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-04:18:59:16-GMT-05:00 ... syncoid_orion_2025-04-04:19:01:25-GMT-05:00 to recv/test/l0_0/l1_0/l2_2 (~ 66.3 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-04:18:59:20-GMT-05:00 ... syncoid_orion_2025-04-04:19:01:29-GMT-05:00 to recv/test/l0_0/l1_0/l2_3 (~ 68.3 MB):
INFO: Sending incremental send/test/l0_0/l1_1@syncoid_orion_2025-04-04:18:59:24-GMT-05:00 ... syncoid_orion_2025-04-04:19:01:34-GMT-05:00 to recv/test/l0_0/l1_1 (~ 69.1 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-04:18:59:29-GMT-05:00 ... syncoid_orion_2025-04-04:19:01:38-GMT-05:00 to recv/test/l0_0/l1_1/l2_0 (~ 67.0 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-04:18:59:33-GMT-05:00 ... syncoid_orion_2025-04-04:19:01:42-GMT-05:00 to recv/test/l0_0/l1_1/l2_1 (~ 69.2 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-04:18:59:37-GMT-05:00 ... syncoid_orion_2025-04-04:19:01:47-GMT-05:00 to recv/test/l0_0/l1_1/l2_2 (~ 65.5 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-04:18:59:42-GMT-05:00 ... syncoid_orion_2025-04-04:19:01:51-GMT-05:00 to recv/test/l0_0/l1_1/l2_3 (~ 66.3 MB):
INFO: Sending incremental send/test/l0_0/l1_2@syncoid_orion_2025-04-04:18:59:46-GMT-05:00 ... syncoid_orion_2025-04-04:19:01:55-GMT-05:00 to recv/test/l0_0/l1_2 (~ 57.0 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-04:18:59:50-GMT-05:00 ... syncoid_orion_2025-04-04:19:01:59-GMT-05:00 to recv/test/l0_0/l1_2/l2_0 (~ 67.0 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-04:18:59:54-GMT-05:00 ... syncoid_orion_2025-04-04:19:02:03-GMT-05:00 to recv/test/l0_0/l1_2/l2_1 (~ 65.6 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-04:18:59:59-GMT-05:00 ... syncoid_orion_2025-04-04:19:02:08-GMT-05:00 to recv/test/l0_0/l1_2/l2_2 (~ 67.8 MB):
warning: cannot send 'send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-04:19:02:08-GMT-05:00': Input/output error
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-12d8a81572-118-789c636064000310a501c49c50360710a715e5e7a69766a63040412473cd1603ffb4490a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a09493a9fdd1e16322420c97382e5f312735319188a53f352f4814695e8e718c41be8e718c61be9e718c51b391457e625e767a6c4e71765e6e7c51b191899ea1a98009195a1a5958191958185aebb6f88ae81a9958101cc0d00f05e2b86
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_2'@'syncoid_orion_2025-04-04:18:59:59-GMT-05:00' 'send/test/l0_0/l1_2/l2_2'@'syncoid_orion_2025-04-04:19:02:08-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 71054016 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_2' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-04:19:00:03-GMT-05:00 ... syncoid_orion_2025-04-04:19:02:11-GMT-05:00 to recv/test/l0_0/l1_2/l2_3 (~ 64.4 MB):
INFO: Sending incremental send/test/l0_0/l1_3@syncoid_orion_2025-04-04:19:00:07-GMT-05:00 ... syncoid_orion_2025-04-04:19:02:15-GMT-05:00 to recv/test/l0_0/l1_3 (~ 65.8 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-04:19:00:12-GMT-05:00 ... syncoid_orion_2025-04-04:19:02:20-GMT-05:00 to recv/test/l0_0/l1_3/l2_0 (~ 67.5 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-04:19:00:15-GMT-05:00 ... syncoid_orion_2025-04-04:19:02:24-GMT-05:00 to recv/test/l0_0/l1_3/l2_1 (~ 67.0 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-04:19:00:19-GMT-05:00 ... syncoid_orion_2025-04-04:19:02:28-GMT-05:00 to recv/test/l0_0/l1_3/l2_2 (~ 50.7 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_2'@'syncoid_orion_2025-04-04:19:00:19-GMT-05:00' 'send/test/l0_0/l1_3/l2_2'@'syncoid_orion_2025-04-04:19:02:28-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 53120472 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_2' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-04:19:00:23-GMT-05:00 ... syncoid_orion_2025-04-04:19:02:31-GMT-05:00 to recv/test/l0_0/l1_3/l2_3 (~ 45.8 MB):
INFO: Sending incremental send/test/l0_1@syncoid_orion_2025-04-04:19:00:27-GMT-05:00 ... syncoid_orion_2025-04-04:19:02:34-GMT-05:00 to recv/test/l0_1 (~ 67.4 MB):
INFO: Sending incremental send/test/l0_1/l1_0@syncoid_orion_2025-04-04:19:00:31-GMT-05:00 ... syncoid_orion_2025-04-04:19:02:38-GMT-05:00 to recv/test/l0_1/l1_0 (~ 67.9 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-04:19:00:36-GMT-05:00 ... syncoid_orion_2025-04-04:19:02:42-GMT-05:00 to recv/test/l0_1/l1_0/l2_0 (~ 65.9 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-04:19:00:40-GMT-05:00 ... syncoid_orion_2025-04-04:19:02:46-GMT-05:00 to recv/test/l0_1/l1_0/l2_1 (~ 67.6 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-04:19:00:45-GMT-05:00 ... syncoid_orion_2025-04-04:19:02:50-GMT-05:00 to recv/test/l0_1/l1_0/l2_2 (~ 69.6 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_2'@'syncoid_orion_2025-04-04:19:00:45-GMT-05:00' 'send/test/l0_1/l1_0/l2_2'@'syncoid_orion_2025-04-04:19:02:50-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 72975744 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_2' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-04:19:00:49-GMT-05:00 ... syncoid_orion_2025-04-04:19:02:52-GMT-05:00 to recv/test/l0_1/l1_0/l2_3 (~ 61.5 MB):
INFO: Sending incremental send/test/l0_1/l1_1@syncoid_orion_2025-04-04:19:00:53-GMT-05:00 ... syncoid_orion_2025-04-04:19:02:56-GMT-05:00 to recv/test/l0_1/l1_1 (~ 44.2 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-04:19:00:57-GMT-05:00 ... syncoid_orion_2025-04-04:19:02:59-GMT-05:00 to recv/test/l0_1/l1_1/l2_0 (~ 44.2 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-04:19:01:02-GMT-05:00 ... syncoid_orion_2025-04-04:19:03:02-GMT-05:00 to recv/test/l0_1/l1_1/l2_1 (~ 43.9 MB):
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
hbarta@orion:~/logs$ 
```