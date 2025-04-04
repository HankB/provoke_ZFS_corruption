# Data: Git bisect 0.8.6 to 2.0.0 - testing second bisect

* [Setup](./setup.md)
* [Results](./results.md)

## 2025-04-04 first syncoid

As `root`. And time to complete populating the `send` pool.

```text
...
Capacity target 50 met
+ exit
real 2295.27
user 69.71
sys 2278.50
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_orion_2025-04-04:09:02:00-GMT-05:00 to new target filesystem recv/test (~ 86 KB):
47.7KiB 0:00:00 [11.9MiB/s] [======================================================>                                             ] 55%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_orion_2025-04-04:09:02:00-GMT-05:00 to new target filesystem recv/test/l0_0 (~ 15.6 GB):
15.6GiB 0:01:05 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_orion_2025-04-04:09:03:06-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0 (~ 15.3 GB):
15.3GiB 0:01:05 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-04:09:04:12-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_0 (~ 15.5 GB):
15.5GiB 0:01:06 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-04:09:05:20-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_1 (~ 15.8 GB):
15.8GiB 0:01:07 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-04:09:06:27-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_2 (~ 15.2 GB):
15.2GiB 0:01:03 [ 246MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-04:09:07:31-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_3 (~ 15.4 GB):
15.4GiB 0:01:04 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_orion_2025-04-04:09:08:36-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1 (~ 15.7 GB):
15.7GiB 0:01:07 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-04:09:09:45-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_0 (~ 15.5 GB):
15.5GiB 0:01:05 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-04:09:10:51-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_1 (~ 15.4 GB):
15.4GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-04:09:11:58-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_2 (~ 15.8 GB):
15.8GiB 0:01:07 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-04:09:13:06-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_3 (~ 15.5 GB):
15.5GiB 0:01:06 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_orion_2025-04-04:09:14:13-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2 (~ 15.5 GB):
15.6GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-04:09:15:20-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_0 (~ 15.2 GB):
15.2GiB 0:01:05 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-04:09:16:26-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_1 (~ 15.5 GB):
15.5GiB 0:01:05 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-04:09:17:32-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_2 (~ 15.4 GB):
15.4GiB 0:01:05 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-04:09:18:37-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_3 (~ 15.7 GB):
15.7GiB 0:01:06 [ 243MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_orion_2025-04-04:09:19:44-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3 (~ 15.0 GB):
15.0GiB 0:01:04 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-04:09:20:49-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_0 (~ 15.5 GB):
15.5GiB 0:01:05 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-04:09:21:55-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_1 (~ 15.5 GB):
15.5GiB 0:01:05 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-04:09:23:01-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_2 (~ 15.6 GB):
15.6GiB 0:01:06 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-04:09:24:08-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_3 (~ 15.4 GB):
15.4GiB 0:01:05 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_orion_2025-04-04:09:25:14-GMT-05:00 to new target filesystem recv/test/l0_1 (~ 15.7 GB):
15.7GiB 0:01:08 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_orion_2025-04-04:09:26:22-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0 (~ 15.5 GB):
15.5GiB 0:01:06 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-04:09:27:29-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_0 (~ 15.8 GB):
15.8GiB 0:01:08 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-04:09:28:38-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_1 (~ 15.9 GB):
15.9GiB 0:01:07 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-04:09:29:46-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_2 (~ 15.8 GB):
15.8GiB 0:01:07 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-04:09:30:54-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_3 (~ 15.6 GB):
15.6GiB 0:01:06 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_orion_2025-04-04:09:32:01-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1 (~ 15.4 GB):
15.4GiB 0:01:05 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-04:09:33:07-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_0 (~ 15.4 GB):
15.4GiB 0:01:05 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-04:09:34:13-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_1 (~ 15.3 GB):
15.3GiB 0:01:04 [ 241MiB/s] [==================================================================================================>] 100%            
real 1998.43
user 27.06
sys 1830.51
root@orion:~# 
```

## 2025-04-04 last syncoid

With errors

```text
hbarta@orion:~$ cat logs/2025-04-04-121731.syncoid.115.txt
INFO: Sending incremental send/test@syncoid_orion_2025-04-04:12:15:19-GMT-05:00 ... syncoid_orion_2025-04-04:12:17:32-GMT-05:00 to recv/test (~ 4 KB):
INFO: Sending incremental send/test/l0_0@syncoid_orion_2025-04-04:12:15:21-GMT-05:00 ... syncoid_orion_2025-04-04:12:17:34-GMT-05:00 to recv/test/l0_0 (~ 69.9 MB):
INFO: Sending incremental send/test/l0_0/l1_0@syncoid_orion_2025-04-04:12:15:26-GMT-05:00 ... syncoid_orion_2025-04-04:12:17:38-GMT-05:00 to recv/test/l0_0/l1_0 (~ 65.9 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-04:12:15:30-GMT-05:00 ... syncoid_orion_2025-04-04:12:17:42-GMT-05:00 to recv/test/l0_0/l1_0/l2_0 (~ 66.2 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-04:12:15:35-GMT-05:00 ... syncoid_orion_2025-04-04:12:17:47-GMT-05:00 to recv/test/l0_0/l1_0/l2_1 (~ 68.1 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-04:12:15:39-GMT-05:00 ... syncoid_orion_2025-04-04:12:17:51-GMT-05:00 to recv/test/l0_0/l1_0/l2_2 (~ 66.1 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-04:12:15:44-GMT-05:00 ... syncoid_orion_2025-04-04:12:17:56-GMT-05:00 to recv/test/l0_0/l1_0/l2_3 (~ 65.9 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_3'@'syncoid_orion_2025-04-04:12:15:44-GMT-05:00' 'send/test/l0_0/l1_0/l2_3'@'syncoid_orion_2025-04-04:12:17:56-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 69105944 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_3' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_1@syncoid_orion_2025-04-04:12:15:48-GMT-05:00 ... syncoid_orion_2025-04-04:12:17:59-GMT-05:00 to recv/test/l0_0/l1_1 (~ 67.9 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-04:12:15:53-GMT-05:00 ... syncoid_orion_2025-04-04:12:18:03-GMT-05:00 to recv/test/l0_0/l1_1/l2_0 (~ 69.0 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-04:12:15:57-GMT-05:00 ... syncoid_orion_2025-04-04:12:18:08-GMT-05:00 to recv/test/l0_0/l1_1/l2_1 (~ 64.7 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_1'@'syncoid_orion_2025-04-04:12:15:57-GMT-05:00' 'send/test/l0_0/l1_1/l2_1'@'syncoid_orion_2025-04-04:12:18:08-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 67804136 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_1' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-04:12:16:02-GMT-05:00 ... syncoid_orion_2025-04-04:12:18:12-GMT-05:00 to recv/test/l0_0/l1_1/l2_2 (~ 64.9 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-04:12:16:06-GMT-05:00 ... syncoid_orion_2025-04-04:12:18:16-GMT-05:00 to recv/test/l0_0/l1_1/l2_3 (~ 69.2 MB):
INFO: Sending incremental send/test/l0_0/l1_2@syncoid_orion_2025-04-04:12:16:10-GMT-05:00 ... syncoid_orion_2025-04-04:12:18:21-GMT-05:00 to recv/test/l0_0/l1_2 (~ 68.5 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-04:12:16:15-GMT-05:00 ... syncoid_orion_2025-04-04:12:18:25-GMT-05:00 to recv/test/l0_0/l1_2/l2_0 (~ 67.8 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-04:12:16:19-GMT-05:00 ... syncoid_orion_2025-04-04:12:18:30-GMT-05:00 to recv/test/l0_0/l1_2/l2_1 (~ 64.9 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-04:12:16:24-GMT-05:00 ... syncoid_orion_2025-04-04:12:18:34-GMT-05:00 to recv/test/l0_0/l1_2/l2_2 (~ 66.2 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_2'@'syncoid_orion_2025-04-04:12:16:24-GMT-05:00' 'send/test/l0_0/l1_2/l2_2'@'syncoid_orion_2025-04-04:12:18:34-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 69461312 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_2' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-04:12:16:28-GMT-05:00 ... syncoid_orion_2025-04-04:12:18:37-GMT-05:00 to recv/test/l0_0/l1_2/l2_3 (~ 65.5 MB):
INFO: Sending incremental send/test/l0_0/l1_3@syncoid_orion_2025-04-04:12:16:32-GMT-05:00 ... syncoid_orion_2025-04-04:12:18:41-GMT-05:00 to recv/test/l0_0/l1_3 (~ 67.0 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-04:12:16:36-GMT-05:00 ... syncoid_orion_2025-04-04:12:18:46-GMT-05:00 to recv/test/l0_0/l1_3/l2_0 (~ 64.4 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-04:12:18:46-GMT-05:00': Input/output error
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-fdf224ef6-118-789c636064000310a501c49c50360710a715e5e7a69766a63040813ad3441bf6a5e1db15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415972c3f3f2b7cba5d2e01499e132c9f97989bcac0509c9a97a20f34aa443fc720de403fc730de583fc728dec0a1b8322f393f33253ebf28333f2fdec8c0c854d7c00488ac0c8dac0c2dac4ccc74dd7d43740d4cad0c0c606e000035ef2c9a
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_0'@'syncoid_orion_2025-04-04:12:16:36-GMT-05:00' 'send/test/l0_0/l1_3/l2_0'@'syncoid_orion_2025-04-04:12:18:46-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 67557384 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_0' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-04:12:16:41-GMT-05:00 ... syncoid_orion_2025-04-04:12:18:49-GMT-05:00 to recv/test/l0_0/l1_3/l2_1 (~ 68.0 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-04:12:16:45-GMT-05:00 ... syncoid_orion_2025-04-04:12:18:53-GMT-05:00 to recv/test/l0_0/l1_3/l2_2 (~ 66.9 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-04:12:16:49-GMT-05:00 ... syncoid_orion_2025-04-04:12:18:57-GMT-05:00 to recv/test/l0_0/l1_3/l2_3 (~ 66.6 MB):
INFO: Sending incremental send/test/l0_1@syncoid_orion_2025-04-04:12:16:54-GMT-05:00 ... syncoid_orion_2025-04-04:12:19:01-GMT-05:00 to recv/test/l0_1 (~ 45.8 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1'@'syncoid_orion_2025-04-04:12:16:54-GMT-05:00' 'send/test/l0_1'@'syncoid_orion_2025-04-04:12:19:01-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 48004520 |  zfs receive  -s -F 'recv/test/l0_1' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1/l1_0@syncoid_orion_2025-04-04:12:16:58-GMT-05:00 ... syncoid_orion_2025-04-04:12:19:03-GMT-05:00 to recv/test/l0_1/l1_0 (~ 44.8 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-04:12:17:02-GMT-05:00 ... syncoid_orion_2025-04-04:12:19:07-GMT-05:00 to recv/test/l0_1/l1_0/l2_0 (~ 44.6 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-04:12:17:07-GMT-05:00 ... syncoid_orion_2025-04-04:12:19:11-GMT-05:00 to recv/test/l0_1/l1_0/l2_1 (~ 45.4 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-04:12:17:11-GMT-05:00 ... syncoid_orion_2025-04-04:12:19:14-GMT-05:00 to recv/test/l0_1/l1_0/l2_2 (~ 44.2 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-04:12:17:15-GMT-05:00 ... syncoid_orion_2025-04-04:12:19:17-GMT-05:00 to recv/test/l0_1/l1_0/l2_3 (~ 46.4 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_3'@'syncoid_orion_2025-04-04:12:17:15-GMT-05:00' 'send/test/l0_1/l1_0/l2_3'@'syncoid_orion_2025-04-04:12:19:17-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 48692944 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_3' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1/l1_1@syncoid_orion_2025-04-04:12:17:19-GMT-05:00 ... syncoid_orion_2025-04-04:12:19:20-GMT-05:00 to recv/test/l0_1/l1_1 (~ 22.6 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-04:12:17:24-GMT-05:00 ... syncoid_orion_2025-04-04:12:19:23-GMT-05:00 to recv/test/l0_1/l1_1/l2_0 (~ 20.6 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-04:12:17:29-GMT-05:00 ... syncoid_orion_2025-04-04:12:19:25-GMT-05:00 to recv/test/l0_1/l1_1/l2_1 (~ 21.5 MB):
errors: List of errors unavailable: permission denied
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://zfsonlinux.org/msg/ZFS-8000-8A
  scan: none requested
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: 6 data errors, use '-v' for a list
hbarta@orion:~$ 
```