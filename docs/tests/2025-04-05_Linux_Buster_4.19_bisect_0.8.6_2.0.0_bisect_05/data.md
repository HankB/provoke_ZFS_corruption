# Results: Git bisect 0.8.6 to 2.0.0 - testing fifth bisect

* [Results](./results.md)
* [Setup](./setup.md)

## 2025-04-05 first syncoid

```text
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   576K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   239G   225G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_orion_2025-04-05:09:35:45-GMT-05:00 to new target filesystem recv/test (~ 86 KB):
47.7KiB 0:00:00 [8.40MiB/s] [======================================================>                                             ] 55%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_orion_2025-04-05:09:35:45-GMT-05:00 to new target filesystem recv/test/l0_0 (~ 15.6 GB):
15.6GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_orion_2025-04-05:09:36:53-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0 (~ 15.5 GB):
15.5GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-05:09:38:00-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_0 (~ 15.6 GB):
15.6GiB 0:01:07 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-05:09:39:08-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_1 (~ 15.6 GB):
15.6GiB 0:01:06 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-05:09:40:14-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_2 (~ 15.7 GB):
15.7GiB 0:01:08 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-05:09:41:23-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_3 (~ 15.8 GB):
15.8GiB 0:01:08 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_orion_2025-04-05:09:42:32-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1 (~ 15.3 GB):
15.3GiB 0:01:07 [ 231MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-05:09:43:40-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_0 (~ 15.7 GB):
15.7GiB 0:01:07 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-05:09:44:49-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_1 (~ 15.5 GB):
15.5GiB 0:01:04 [ 244MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-05:09:45:54-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_2 (~ 15.5 GB):
15.5GiB 0:01:07 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-05:09:47:02-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_3 (~ 15.3 GB):
15.3GiB 0:01:04 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_orion_2025-04-05:09:48:07-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2 (~ 15.2 GB):
15.2GiB 0:01:05 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-05:09:49:13-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_0 (~ 15.2 GB):
15.2GiB 0:01:05 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-05:09:50:19-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_1 (~ 15.5 GB):
15.5GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-05:09:51:27-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_2 (~ 15.2 GB):
15.2GiB 0:01:04 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-05:09:52:32-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_3 (~ 15.6 GB):
15.6GiB 0:01:07 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_orion_2025-04-05:09:53:39-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3 (~ 15.4 GB):
15.4GiB 0:01:05 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-05:09:54:45-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_0 (~ 15.5 GB):
15.5GiB 0:01:07 [ 234MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-05:09:55:53-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_1 (~ 15.3 GB):
15.3GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-05:09:57:00-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_2 (~ 15.6 GB):
15.6GiB 0:01:07 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-05:09:58:08-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_3 (~ 15.6 GB):
15.6GiB 0:01:07 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_orion_2025-04-05:09:59:15-GMT-05:00 to new target filesystem recv/test/l0_1 (~ 15.4 GB):
15.4GiB 0:01:06 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_orion_2025-04-05:10:00:22-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0 (~ 15.3 GB):
15.3GiB 0:01:05 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-05:10:01:28-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_0 (~ 15.8 GB):
15.8GiB 0:01:08 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-05:10:02:37-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_1 (~ 15.5 GB):
15.5GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-05:10:03:44-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_2 (~ 15.3 GB):
15.3GiB 0:01:06 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-05:10:04:51-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_3 (~ 15.8 GB):
15.8GiB 0:01:08 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_orion_2025-04-05:10:05:59-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1 (~ 15.4 GB):
15.4GiB 0:01:06 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-05:10:07:06-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_0 (~ 15.8 GB):
15.8GiB 0:01:07 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-05:10:08:15-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_1 (~ 15.7 GB):
15.7GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
real 2018.36
user 28.44
sys 1949.88
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   239G   225G        -         -     0%    51%  1.00x    ONLINE  -
send   464G   239G   225G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# 
```

## 2025-04-05 last syncoid

```text
hbarta@orion:~/logs$ cat 2025-04-05-131717.syncoid.100.txt
INFO: Sending incremental send/test@syncoid_orion_2025-04-05:13:15:23-GMT-05:00 ... syncoid_orion_2025-04-05:13:17:17-GMT-05:00 to recv/test (~ 4 KB):
INFO: Sending incremental send/test/l0_0@syncoid_orion_2025-04-05:13:15:24-GMT-05:00 ... syncoid_orion_2025-04-05:13:17:19-GMT-05:00 to recv/test/l0_0 (~ 57.6 MB):
INFO: Sending incremental send/test/l0_0/l1_0@syncoid_orion_2025-04-05:13:15:28-GMT-05:00 ... syncoid_orion_2025-04-05:13:17:23-GMT-05:00 to recv/test/l0_0/l1_0 (~ 44.3 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-05:13:15:32-GMT-05:00 ... syncoid_orion_2025-04-05:13:17:26-GMT-05:00 to recv/test/l0_0/l1_0/l2_0 (~ 45.1 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-05:13:15:36-GMT-05:00 ... syncoid_orion_2025-04-05:13:17:30-GMT-05:00 to recv/test/l0_0/l1_0/l2_1 (~ 46.3 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-05:13:15:40-GMT-05:00 ... syncoid_orion_2025-04-05:13:17:34-GMT-05:00 to recv/test/l0_0/l1_0/l2_2 (~ 46.1 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-05:13:15:44-GMT-05:00 ... syncoid_orion_2025-04-05:13:17:37-GMT-05:00 to recv/test/l0_0/l1_0/l2_3 (~ 64.8 MB):
INFO: Sending incremental send/test/l0_0/l1_1@syncoid_orion_2025-04-05:13:15:48-GMT-05:00 ... syncoid_orion_2025-04-05:13:17:40-GMT-05:00 to recv/test/l0_0/l1_1 (~ 45.2 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-05:13:15:53-GMT-05:00 ... syncoid_orion_2025-04-05:13:17:43-GMT-05:00 to recv/test/l0_0/l1_1/l2_0 (~ 45.1 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-05:13:15:57-GMT-05:00 ... syncoid_orion_2025-04-05:13:17:47-GMT-05:00 to recv/test/l0_0/l1_1/l2_1 (~ 45.1 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-05:13:16:01-GMT-05:00 ... syncoid_orion_2025-04-05:13:17:50-GMT-05:00 to recv/test/l0_0/l1_1/l2_2 (~ 42.5 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-05:13:16:05-GMT-05:00 ... syncoid_orion_2025-04-05:13:17:54-GMT-05:00 to recv/test/l0_0/l1_1/l2_3 (~ 66.5 MB):
INFO: Sending incremental send/test/l0_0/l1_2@syncoid_orion_2025-04-05:13:16:08-GMT-05:00 ... syncoid_orion_2025-04-05:13:17:58-GMT-05:00 to recv/test/l0_0/l1_2 (~ 67.8 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-05:13:16:11-GMT-05:00 ... syncoid_orion_2025-04-05:13:18:02-GMT-05:00 to recv/test/l0_0/l1_2/l2_0 (~ 67.8 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-05:13:16:14-GMT-05:00 ... syncoid_orion_2025-04-05:13:18:06-GMT-05:00 to recv/test/l0_0/l1_2/l2_1 (~ 43.6 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-05:13:16:19-GMT-05:00 ... syncoid_orion_2025-04-05:13:18:10-GMT-05:00 to recv/test/l0_0/l1_2/l2_2 (~ 43.0 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-05:13:16:23-GMT-05:00 ... syncoid_orion_2025-04-05:13:18:13-GMT-05:00 to recv/test/l0_0/l1_2/l2_3 (~ 46.6 MB):
INFO: Sending incremental send/test/l0_0/l1_3@syncoid_orion_2025-04-05:13:16:26-GMT-05:00 ... syncoid_orion_2025-04-05:13:18:16-GMT-05:00 to recv/test/l0_0/l1_3 (~ 66.2 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-05:13:16:30-GMT-05:00 ... syncoid_orion_2025-04-05:13:18:20-GMT-05:00 to recv/test/l0_0/l1_3/l2_0 (~ 64.1 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-05:13:16:34-GMT-05:00 ... syncoid_orion_2025-04-05:13:18:24-GMT-05:00 to recv/test/l0_0/l1_3/l2_1 (~ 66.9 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-05:13:16:37-GMT-05:00 ... syncoid_orion_2025-04-05:13:18:28-GMT-05:00 to recv/test/l0_0/l1_3/l2_2 (~ 67.3 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-05:13:16:41-GMT-05:00 ... syncoid_orion_2025-04-05:13:18:32-GMT-05:00 to recv/test/l0_0/l1_3/l2_3 (~ 68.3 MB):
INFO: Sending incremental send/test/l0_1@syncoid_orion_2025-04-05:13:16:44-GMT-05:00 ... syncoid_orion_2025-04-05:13:18:36-GMT-05:00 to recv/test/l0_1 (~ 44.4 MB):
INFO: Sending incremental send/test/l0_1/l1_0@syncoid_orion_2025-04-05:13:16:48-GMT-05:00 ... syncoid_orion_2025-04-05:13:18:40-GMT-05:00 to recv/test/l0_1/l1_0 (~ 43.2 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-05:13:16:52-GMT-05:00 ... syncoid_orion_2025-04-05:13:18:43-GMT-05:00 to recv/test/l0_1/l1_0/l2_0 (~ 66.6 MB):
warning: cannot send 'send/test/l0_1/l1_0/l2_0@1743877074.2025-04-05-1317': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_0'@'syncoid_orion_2025-04-05:13:16:52-GMT-05:00' 'send/test/l0_1/l1_0/l2_0'@'syncoid_orion_2025-04-05:13:18:43-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 69879656 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_0' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-05:13:16:56-GMT-05:00 ... syncoid_orion_2025-04-05:13:18:44-GMT-05:00 to recv/test/l0_1/l1_0/l2_1 (~ 44.5 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-05:13:17:00-GMT-05:00 ... syncoid_orion_2025-04-05:13:18:47-GMT-05:00 to recv/test/l0_1/l1_0/l2_2 (~ 63.3 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-05:13:17:04-GMT-05:00 ... syncoid_orion_2025-04-05:13:18:50-GMT-05:00 to recv/test/l0_1/l1_0/l2_3 (~ 64.8 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_3'@'syncoid_orion_2025-04-05:13:17:04-GMT-05:00' 'send/test/l0_1/l1_0/l2_3'@'syncoid_orion_2025-04-05:13:18:50-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 67960152 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_3' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1/l1_1@syncoid_orion_2025-04-05:13:17:08-GMT-05:00 ... syncoid_orion_2025-04-05:13:18:51-GMT-05:00 to recv/test/l0_1/l1_1 (~ 62.4 MB):
warning: cannot send 'send/test/l0_1/l1_1@syncoid_orion_2025-04-05:13:18:51-GMT-05:00': Input/output error
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-119087fb0a-110-789c636064000310a501c49c50360710a715e5e7a69766a63040c1abfe351e5f6305a214806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415c7f82ebff434ba7f2e02499e132c9f97989bcac0509c9a97a20f34aa443fc720de503fc730ded0a1b8322f393f33253ebf28333f2fdec8c0c854d7c044d7c0d4cad0d8cad0c2cad450d7dd3704c4373000db0d00f8712c55
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1'@'syncoid_orion_2025-04-05:13:17:08-GMT-05:00' 'send/test/l0_1/l1_1'@'syncoid_orion_2025-04-05:13:18:51-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 65392192 |  zfs receive  -s -F 'recv/test/l0_1/l1_1' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-05:13:17:11-GMT-05:00 ... syncoid_orion_2025-04-05:13:18:53-GMT-05:00 to recv/test/l0_1/l1_1/l2_0 (~ 66.9 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_0'@'syncoid_orion_2025-04-05:13:17:11-GMT-05:00' 'send/test/l0_1/l1_1/l2_0'@'syncoid_orion_2025-04-05:13:18:53-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 70129072 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_0' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-05:13:17:14-GMT-05:00 ... syncoid_orion_2025-04-05:13:18:56-GMT-05:00 to recv/test/l0_1/l1_1/l2_1 (~ 69.6 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_1@1743877119.2025-04-05-1318': Input/output error
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_1/l2_1 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_1'@'syncoid_orion_2025-04-05:13:17:14-GMT-05:00' 'send/test/l0_1/l1_1/l2_1'@'syncoid_orion_2025-04-05:13:18:56-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 73029176 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_1' 2>&1 failed: 256
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

errors: 83 data errors, use '-v' for a list
hbarta@orion:~/logs$ 
```
