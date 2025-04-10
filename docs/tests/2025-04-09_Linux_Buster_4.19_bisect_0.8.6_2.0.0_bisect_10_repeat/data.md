# Data: Git bisect 0.8.6 to 2.0.0 - testing tenth bisect - repeat

* [Results](./data.md)
* [Setup](./setup.md)
* [home/index](./../../index.md)

```text
Capacity target 50 met
real 2290.76
user 68.82
sys 2275.56
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_orion_2025-04-09:17:42:42-GMT-05:00 to new target filesystem recv/test (~ 86 KB):
47.7KiB 0:00:00 [10.7MiB/s] [======================================================>                                             ] 55%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_orion_2025-04-09:17:42:43-GMT-05:00 to new target filesystem recv/test/l0_0 (~ 15.0 GB):
15.0GiB 0:01:04 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_orion_2025-04-09:17:43:47-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0 (~ 15.6 GB):
15.6GiB 0:01:07 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-09:17:44:55-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_0 (~ 15.3 GB):
15.3GiB 0:01:05 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-09:17:46:01-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_1 (~ 15.5 GB):
15.5GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-09:17:47:08-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_2 (~ 15.6 GB):
15.6GiB 0:01:06 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-09:17:48:15-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_3 (~ 15.6 GB):
15.6GiB 0:01:06 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_orion_2025-04-09:17:49:22-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1 (~ 15.6 GB):
15.6GiB 0:01:07 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-09:17:50:29-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_0 (~ 15.2 GB):
15.2GiB 0:01:05 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-09:17:51:35-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_1 (~ 15.0 GB):
15.0GiB 0:01:04 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-09:17:52:39-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_2 (~ 15.5 GB):
15.5GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-09:17:53:47-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_3 (~ 15.4 GB):
15.4GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_orion_2025-04-09:17:54:53-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2 (~ 15.4 GB):
15.4GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-09:17:56:00-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_0 (~ 15.5 GB):
15.5GiB 0:01:06 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-09:17:57:07-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_1 (~ 15.1 GB):
15.1GiB 0:01:05 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-09:17:58:13-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_2 (~ 15.6 GB):
15.6GiB 0:01:07 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-09:17:59:21-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_3 (~ 15.5 GB):
15.5GiB 0:01:07 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_orion_2025-04-09:18:00:29-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3 (~ 15.5 GB):
15.5GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-09:18:01:36-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_0 (~ 15.4 GB):
15.4GiB 0:01:06 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-09:18:02:43-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_1 (~ 15.4 GB):
15.4GiB 0:01:05 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-09:18:03:50-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_2 (~ 15.5 GB):
15.5GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-09:18:04:57-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_3 (~ 15.5 GB):
15.5GiB 0:01:07 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_orion_2025-04-09:18:06:05-GMT-05:00 to new target filesystem recv/test/l0_1 (~ 15.6 GB):
15.6GiB 0:01:05 [ 243MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_orion_2025-04-09:18:07:11-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0 (~ 15.7 GB):
15.7GiB 0:01:06 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-09:18:08:17-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_0 (~ 15.5 GB):
15.5GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-09:18:09:25-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_1 (~ 15.8 GB):
15.9GiB 0:01:09 [ 234MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-09:18:10:34-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_2 (~ 15.3 GB):
15.3GiB 0:01:07 [ 233MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-09:18:11:42-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_3 (~ 15.7 GB):
15.7GiB 0:01:07 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_orion_2025-04-09:18:12:50-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1 (~ 15.6 GB):
15.6GiB 0:01:06 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-09:18:13:57-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_0 (~ 15.7 GB):
15.7GiB 0:01:08 [ 234MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-09:18:15:05-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_1 (~ 15.5 GB):
15.5GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
real 2010.42
user 29.00
sys 1944.35
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   238G   226G        -         -     0%    51%  1.00x    ONLINE  -
send   464G   238G   226G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# 
```

## 2025-04-09 last syncoid

```text
hbarta@orion:~/logs$ cat 2025-04-09-213057.syncoid.93.txt
INFO: Sending incremental send/test@syncoid_orion_2025-04-09:21:28:55-GMT-05:00 ... syncoid_orion_2025-04-09:21:30:58-GMT-05:00 to recv/test (~ 4 KB):
INFO: Sending incremental send/test/l0_0@syncoid_orion_2025-04-09:21:28:57-GMT-05:00 ... syncoid_orion_2025-04-09:21:30:59-GMT-05:00 to recv/test/l0_0 (~ 62.7 MB):
INFO: Sending incremental send/test/l0_0/l1_0@syncoid_orion_2025-04-09:21:29:00-GMT-05:00 ... syncoid_orion_2025-04-09:21:31:03-GMT-05:00 to recv/test/l0_0/l1_0 (~ 57.8 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-09:21:29:04-GMT-05:00 ... syncoid_orion_2025-04-09:21:31:08-GMT-05:00 to recv/test/l0_0/l1_0/l2_0 (~ 43.8 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-09:21:29:08-GMT-05:00 ... syncoid_orion_2025-04-09:21:31:11-GMT-05:00 to recv/test/l0_0/l1_0/l2_1 (~ 44.7 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-09:21:29:13-GMT-05:00 ... syncoid_orion_2025-04-09:21:31:15-GMT-05:00 to recv/test/l0_0/l1_0/l2_2 (~ 58.5 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_2'@'syncoid_orion_2025-04-09:21:29:13-GMT-05:00' 'send/test/l0_0/l1_0/l2_2'@'syncoid_orion_2025-04-09:21:31:15-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 61328160 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_2' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-09:21:29:17-GMT-05:00 ... syncoid_orion_2025-04-09:21:31:18-GMT-05:00 to recv/test/l0_0/l1_0/l2_3 (~ 67.2 MB):
INFO: Sending incremental send/test/l0_0/l1_1@syncoid_orion_2025-04-09:21:29:21-GMT-05:00 ... syncoid_orion_2025-04-09:21:31:22-GMT-05:00 to recv/test/l0_0/l1_1 (~ 68.6 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-09:21:29:25-GMT-05:00 ... syncoid_orion_2025-04-09:21:31:26-GMT-05:00 to recv/test/l0_0/l1_1/l2_0 (~ 66.7 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_0'@'syncoid_orion_2025-04-09:21:29:25-GMT-05:00' 'send/test/l0_0/l1_1/l2_0'@'syncoid_orion_2025-04-09:21:31:26-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 69892568 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_0' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-09:21:29:28-GMT-05:00 ... syncoid_orion_2025-04-09:21:31:29-GMT-05:00 to recv/test/l0_0/l1_1/l2_1 (~ 46.3 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-09:21:29:32-GMT-05:00 ... syncoid_orion_2025-04-09:21:31:32-GMT-05:00 to recv/test/l0_0/l1_1/l2_2 (~ 46.4 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-09:21:29:36-GMT-05:00 ... syncoid_orion_2025-04-09:21:31:36-GMT-05:00 to recv/test/l0_0/l1_1/l2_3 (~ 45.2 MB):
INFO: Sending incremental send/test/l0_0/l1_2@syncoid_orion_2025-04-09:21:29:40-GMT-05:00 ... syncoid_orion_2025-04-09:21:31:40-GMT-05:00 to recv/test/l0_0/l1_2 (~ 45.1 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-09:21:29:44-GMT-05:00 ... syncoid_orion_2025-04-09:21:31:43-GMT-05:00 to recv/test/l0_0/l1_2/l2_0 (~ 45.0 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-09:21:29:48-GMT-05:00 ... syncoid_orion_2025-04-09:21:31:46-GMT-05:00 to recv/test/l0_0/l1_2/l2_1 (~ 44.5 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-09:21:29:52-GMT-05:00 ... syncoid_orion_2025-04-09:21:31:49-GMT-05:00 to recv/test/l0_0/l1_2/l2_2 (~ 44.7 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-09:21:29:56-GMT-05:00 ... syncoid_orion_2025-04-09:21:31:52-GMT-05:00 to recv/test/l0_0/l1_2/l2_3 (~ 44.9 MB):
INFO: Sending incremental send/test/l0_0/l1_3@syncoid_orion_2025-04-09:21:30:00-GMT-05:00 ... syncoid_orion_2025-04-09:21:31:55-GMT-05:00 to recv/test/l0_0/l1_3 (~ 44.5 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-09:21:30:04-GMT-05:00 ... syncoid_orion_2025-04-09:21:31:59-GMT-05:00 to recv/test/l0_0/l1_3/l2_0 (~ 46.6 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_0'@'syncoid_orion_2025-04-09:21:30:04-GMT-05:00' 'send/test/l0_0/l1_3/l2_0'@'syncoid_orion_2025-04-09:21:31:59-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 48899176 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_0' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-09:21:30:09-GMT-05:00 ... syncoid_orion_2025-04-09:21:32:00-GMT-05:00 to recv/test/l0_0/l1_3/l2_1 (~ 46.9 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-09:21:30:12-GMT-05:00 ... syncoid_orion_2025-04-09:21:32:03-GMT-05:00 to recv/test/l0_0/l1_3/l2_2 (~ 43.5 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-09:21:30:17-GMT-05:00 ... syncoid_orion_2025-04-09:21:32:06-GMT-05:00 to recv/test/l0_0/l1_3/l2_3 (~ 42.9 MB):
INFO: Sending incremental send/test/l0_1@syncoid_orion_2025-04-09:21:30:20-GMT-05:00 ... syncoid_orion_2025-04-09:21:32:08-GMT-05:00 to recv/test/l0_1 (~ 45.2 MB):
INFO: Sending incremental send/test/l0_1/l1_0@syncoid_orion_2025-04-09:21:30:25-GMT-05:00 ... syncoid_orion_2025-04-09:21:32:11-GMT-05:00 to recv/test/l0_1/l1_0 (~ 46.0 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-09:21:30:29-GMT-05:00 ... syncoid_orion_2025-04-09:21:32:14-GMT-05:00 to recv/test/l0_1/l1_0/l2_0 (~ 44.3 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-09:21:30:34-GMT-05:00 ... syncoid_orion_2025-04-09:21:32:17-GMT-05:00 to recv/test/l0_1/l1_0/l2_1 (~ 44.7 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-09:21:30:38-GMT-05:00 ... syncoid_orion_2025-04-09:21:32:20-GMT-05:00 to recv/test/l0_1/l1_0/l2_2 (~ 45.3 MB):
warning: cannot send 'send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-09:21:32:20-GMT-05:00': Input/output error
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1409a14a70-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081d08407ee962639b314806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415bdda5c62fdf17c3e0948f29c60f9bcc4dc540686e2d4bc147da05125fa3906f186fa3986f106fa3946f1460ec59579c9f99929f1f94599f979f1460646a6ba0626ba069656468656c646564606baeebe21ba06a656060630370000834b2a30
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_2'@'syncoid_orion_2025-04-09:21:30:38-GMT-05:00' 'send/test/l0_1/l1_0/l2_2'@'syncoid_orion_2025-04-09:21:32:20-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 47487688 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_2' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-09:21:30:42-GMT-05:00 ... syncoid_orion_2025-04-09:21:32:23-GMT-05:00 to recv/test/l0_1/l1_0/l2_3 (~ 45.1 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_3'@'syncoid_orion_2025-04-09:21:30:42-GMT-05:00' 'send/test/l0_1/l1_0/l2_3'@'syncoid_orion_2025-04-09:21:32:23-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 47340048 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_3' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1/l1_1@syncoid_orion_2025-04-09:21:30:46-GMT-05:00 ... syncoid_orion_2025-04-09:21:32:25-GMT-05:00 to recv/test/l0_1/l1_1 (~ 24.5 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-09:21:30:50-GMT-05:00 ... syncoid_orion_2025-04-09:21:32:28-GMT-05:00 to recv/test/l0_1/l1_1/l2_0 (~ 22.7 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-09:21:32:28-GMT-05:00': Input/output error
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1133f75cf2-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1db5e91d2c0d2ac730a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28a4357764fba75dc735602923c27583e2f31379581a138352f451f6854897e8e41bca17e8e2188308a377028aecc4bcecf4c89cf2fcacccf8b37323032d53530d135b0b43232b43236b232b2d075f70dd13530b5323080b901008f362e43
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_0'@'syncoid_orion_2025-04-09:21:30:50-GMT-05:00' 'send/test/l0_1/l1_1/l2_0'@'syncoid_orion_2025-04-09:21:32:28-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 23750832 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_0' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-09:21:30:54-GMT-05:00 ... syncoid_orion_2025-04-09:21:32:29-GMT-05:00 to recv/test/l0_1/l1_1/l2_1 (~ 23.4 MB):
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

errors: 9 data errors, use '-v' for a list
hbarta@orion:~/logs$
```

## 2025-04-09 various zpool status

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

errors: 9 data errors, use '-v' for a list
hbarta@orion:~/logs$ sudo zpool status
[sudo] password for hbarta: 
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

errors: 9 data errors, use '-v' for a list
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

        send/test/l0_0/l1_3/l2_0@autosnap_2025-04-09_21:30:57_frequently:<0x0>
        send/test/l0_0/l1_0/l2_0@autosnap_2025-04-09_21:30:57_frequently:<0x0>
        send/test/l0_0/l1_0/l2_2@autosnap_2025-04-09_21:30:57_frequently:<0x0>
        send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-09:21:31:26-GMT-05:00:<0x0>
        send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-09:21:32:20-GMT-05:00:<0x0>
        send/test/l0_0/l1_3/l2_0@1744252255.2025-04-09-2130:<0x0>
        send/test/l0_0/l1_0/l2_2@1744252255.2025-04-09-2130:<0x0>
        send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-09:21:32:23-GMT-05:00:<0x0>
        send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-09:21:32:28-GMT-05:00:<0x0>
hbarta@orion:~/logs$ 
```
