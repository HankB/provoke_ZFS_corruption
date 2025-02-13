# Data Linux Buster 4.19 kernel with ZFS 0.8.6

## 20254-02-13 first syncoid

```text
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_orion_2025-02-13:11:06:46-GMT-06:00 to new target filesystem recv/test (~ 87 KB):
50.5KiB 0:00:00 [2.72MiB/s] [========================================================>                                           ] 57%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_orion_2025-02-13:11:06:46-GMT-06:00 to new target filesystem recv/test/l0_0 (~ 15.2 GB):
15.2GiB 0:01:03 [ 243MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_orion_2025-02-13:11:07:51-GMT-06:00 to new target filesystem recv/test/l0_0/l1_0 (~ 15.3 GB):
15.3GiB 0:01:04 [ 243MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-02-13:11:08:56-GMT-06:00 to new target filesystem recv/test/l0_0/l1_0/l2_0 (~ 15.8 GB):
15.8GiB 0:01:06 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-02-13:11:10:03-GMT-06:00 to new target filesystem recv/test/l0_0/l1_0/l2_1 (~ 15.7 GB):
15.7GiB 0:01:06 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-02-13:11:11:10-GMT-06:00 to new target filesystem recv/test/l0_0/l1_0/l2_2 (~ 14.9 GB):
15.0GiB 0:01:02 [ 245MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-02-13:11:12:13-GMT-06:00 to new target filesystem recv/test/l0_0/l1_0/l2_3 (~ 15.3 GB):
15.3GiB 0:01:04 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_orion_2025-02-13:11:13:18-GMT-06:00 to new target filesystem recv/test/l0_0/l1_1 (~ 15.5 GB):
15.5GiB 0:01:04 [ 244MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-02-13:11:14:23-GMT-06:00 to new target filesystem recv/test/l0_0/l1_1/l2_0 (~ 15.8 GB):
15.8GiB 0:01:06 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-02-13:11:15:30-GMT-06:00 to new target filesystem recv/test/l0_0/l1_1/l2_1 (~ 15.4 GB):
15.4GiB 0:01:05 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-02-13:11:16:36-GMT-06:00 to new target filesystem recv/test/l0_0/l1_1/l2_2 (~ 15.6 GB):
15.6GiB 0:01:06 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-02-13:11:17:43-GMT-06:00 to new target filesystem recv/test/l0_0/l1_1/l2_3 (~ 15.7 GB):
15.7GiB 0:01:05 [ 244MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_orion_2025-02-13:11:18:49-GMT-06:00 to new target filesystem recv/test/l0_0/l1_2 (~ 15.9 GB):
15.9GiB 0:01:07 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-02-13:11:19:57-GMT-06:00 to new target filesystem recv/test/l0_0/l1_2/l2_0 (~ 15.7 GB):
15.7GiB 0:01:06 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-02-13:11:21:04-GMT-06:00 to new target filesystem recv/test/l0_0/l1_2/l2_1 (~ 15.3 GB):
15.3GiB 0:01:04 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-02-13:11:22:09-GMT-06:00 to new target filesystem recv/test/l0_0/l1_2/l2_2 (~ 15.3 GB):
15.3GiB 0:01:04 [ 245MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-02-13:11:23:14-GMT-06:00 to new target filesystem recv/test/l0_0/l1_2/l2_3 (~ 15.3 GB):
15.3GiB 0:01:04 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_orion_2025-02-13:11:24:20-GMT-06:00 to new target filesystem recv/test/l0_0/l1_3 (~ 15.4 GB):
15.5GiB 0:01:04 [ 246MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-02-13:11:25:25-GMT-06:00 to new target filesystem recv/test/l0_0/l1_3/l2_0 (~ 15.2 GB):
15.2GiB 0:01:04 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-02-13:11:26:30-GMT-06:00 to new target filesystem recv/test/l0_0/l1_3/l2_1 (~ 15.5 GB):
15.5GiB 0:01:05 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-02-13:11:27:36-GMT-06:00 to new target filesystem recv/test/l0_0/l1_3/l2_2 (~ 15.5 GB):
15.5GiB 0:01:04 [ 247MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-02-13:11:28:41-GMT-06:00 to new target filesystem recv/test/l0_0/l1_3/l2_3 (~ 15.5 GB):
15.5GiB 0:01:05 [ 244MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_orion_2025-02-13:11:29:47-GMT-06:00 to new target filesystem recv/test/l0_1 (~ 15.8 GB):
15.8GiB 0:01:06 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_orion_2025-02-13:11:30:54-GMT-06:00 to new target filesystem recv/test/l0_1/l1_0 (~ 15.2 GB):
15.2GiB 0:01:04 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-02-13:11:31:59-GMT-06:00 to new target filesystem recv/test/l0_1/l1_0/l2_0 (~ 15.0 GB):
15.0GiB 0:01:03 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-02-13:11:33:03-GMT-06:00 to new target filesystem recv/test/l0_1/l1_0/l2_1 (~ 15.2 GB):
15.2GiB 0:01:03 [ 246MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-02-13:11:34:06-GMT-06:00 to new target filesystem recv/test/l0_1/l1_0/l2_2 (~ 15.4 GB):
15.4GiB 0:01:04 [ 245MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-02-13:11:35:11-GMT-06:00 to new target filesystem recv/test/l0_1/l1_0/l2_3 (~ 15.8 GB):
15.8GiB 0:01:06 [ 243MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_orion_2025-02-13:11:36:18-GMT-06:00 to new target filesystem recv/test/l0_1/l1_1 (~ 15.6 GB):
15.6GiB 0:01:06 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-02-13:11:37:25-GMT-06:00 to new target filesystem recv/test/l0_1/l1_1/l2_0 (~ 15.7 GB):
15.7GiB 0:01:06 [ 243MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-02-13:11:38:31-GMT-06:00 to new target filesystem recv/test/l0_1/l1_1/l2_1 (~ 15.5 GB):
15.5GiB 0:01:05 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_2@syncoid_orion_2025-02-13:11:39:37-GMT-06:00 to new target filesystem recv/test/l0_1/l1_1/l2_2 (~ 15.2 GB):
15.2GiB 0:01:03 [ 245MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_3@syncoid_orion_2025-02-13:11:40:41-GMT-06:00 to new target filesystem recv/test/l0_1/l1_1/l2_3 (~ 15.3 GB):
15.3GiB 0:01:04 [ 243MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2@syncoid_orion_2025-02-13:11:41:46-GMT-06:00 to new target filesystem recv/test/l0_1/l1_2 (~ 15.5 GB):
15.5GiB 0:01:04 [ 244MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_0@syncoid_orion_2025-02-13:11:42:51-GMT-06:00 to new target filesystem recv/test/l0_1/l1_2/l2_0 (~ 15.5 GB):
15.5GiB 0:01:04 [ 243MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_1@syncoid_orion_2025-02-13:11:43:57-GMT-06:00 to new target filesystem recv/test/l0_1/l1_2/l2_1 (~ 15.4 GB):
15.4GiB 0:01:05 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_2@syncoid_orion_2025-02-13:11:45:03-GMT-06:00 to new target filesystem recv/test/l0_1/l1_2/l2_2 (~ 15.7 GB):
15.7GiB 0:01:06 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_3@syncoid_orion_2025-02-13:11:46:10-GMT-06:00 to new target filesystem recv/test/l0_1/l1_2/l2_3 (~ 15.7 GB):
15.7GiB 0:01:05 [ 245MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3@syncoid_orion_2025-02-13:11:47:16-GMT-06:00 to new target filesystem recv/test/l0_1/l1_3 (~ 15.2 GB):
15.2GiB 0:01:04 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3/l2_0@syncoid_orion_2025-02-13:11:48:21-GMT-06:00 to new target filesystem recv/test/l0_1/l1_3/l2_0 (~ 15.7 GB):
15.7GiB 0:01:05 [ 245MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3/l2_1@syncoid_orion_2025-02-13:11:49:27-GMT-06:00 to new target filesystem recv/test/l0_1/l1_3/l2_1 (~ 15.5 GB):
15.5GiB 0:01:05 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3/l2_2@syncoid_orion_2025-02-13:11:50:33-GMT-06:00 to new target filesystem recv/test/l0_1/l1_3/l2_2 (~ 15.7 GB):
15.7GiB 0:01:05 [ 244MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3/l2_3@syncoid_orion_2025-02-13:11:51:39-GMT-06:00 to new target filesystem recv/test/l0_1/l1_3/l2_3 (~ 15.3 GB):
15.3GiB 0:01:04 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_2@syncoid_orion_2025-02-13:11:52:45-GMT-06:00 to new target filesystem recv/test/l0_2 (~ 15.3 GB):
15.3GiB 0:01:04 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_0@syncoid_orion_2025-02-13:11:53:50-GMT-06:00 to new target filesystem recv/test/l0_2/l1_0 (~ 15.5 GB):
15.5GiB 0:01:04 [ 246MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_2/l1_0/l2_0@syncoid_orion_2025-02-13:11:54:55-GMT-06:00 to new target filesystem recv/test/l0_2/l1_0/l2_0 (~ 5.4 GB):
5.39GiB 0:00:22 [ 242MiB/s] [==================================================================================================>] 100%            
real 2911.60
user 38.44
sys 2721.63
root@orion:~# 
```

## 2025-02-13 repeat syncoid as user

```text
hbarta@orion:~$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending incremental send/test@syncoid_orion_2025-02-13:11:06:46-GMT-06:00 ... syncoid_orion_2025-02-13:12:13:54-GMT-06:00 to recv/test (~ 41 KB):
7.18KiB 0:00:00 [ 194KiB/s] [================>                                                                                   ] 17%            
INFO: Sending incremental send/test/l0_0@syncoid_orion_2025-02-13:11:06:46-GMT-06:00 ... syncoid_orion_2025-02-13:12:13:55-GMT-06:00 to recv/test/l0_0 (~ 1.7 MB):
1.24MiB 0:00:00 [8.47MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_0/l1_0@syncoid_orion_2025-02-13:11:07:51-GMT-06:00 ... syncoid_orion_2025-02-13:12:13:55-GMT-06:00 to recv/test/l0_0/l1_0 (~ 1.7 MB):
1.23MiB 0:00:00 [8.31MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-02-13:11:08:56-GMT-06:00 ... syncoid_orion_2025-02-13:12:13:56-GMT-06:00 to recv/test/l0_0/l1_0/l2_0 (~ 1.7 MB):
1.23MiB 0:00:00 [8.57MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-02-13:11:10:03-GMT-06:00 ... syncoid_orion_2025-02-13:12:13:56-GMT-06:00 to recv/test/l0_0/l1_0/l2_1 (~ 1.8 MB):
1.23MiB 0:00:00 [8.30MiB/s] [====================================================================>                               ] 69%            
INFO: Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-02-13:11:11:10-GMT-06:00 ... syncoid_orion_2025-02-13:12:13:56-GMT-06:00 to recv/test/l0_0/l1_0/l2_2 (~ 1.7 MB):
1.23MiB 0:00:00 [8.27MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-02-13:11:12:13-GMT-06:00 ... syncoid_orion_2025-02-13:12:13:57-GMT-06:00 to recv/test/l0_0/l1_0/l2_3 (~ 1.7 MB):
1.23MiB 0:00:00 [8.92MiB/s] [========================================================================>                           ] 73%            
INFO: Sending incremental send/test/l0_0/l1_1@syncoid_orion_2025-02-13:11:13:18-GMT-06:00 ... syncoid_orion_2025-02-13:12:13:57-GMT-06:00 to recv/test/l0_0/l1_1 (~ 1.7 MB):
1.24MiB 0:00:00 [7.73MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-02-13:11:14:23-GMT-06:00 ... syncoid_orion_2025-02-13:12:13:58-GMT-06:00 to recv/test/l0_0/l1_1/l2_0 (~ 1.7 MB):
1.23MiB 0:00:00 [8.65MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-02-13:11:15:30-GMT-06:00 ... syncoid_orion_2025-02-13:12:13:58-GMT-06:00 to recv/test/l0_0/l1_1/l2_1 (~ 1.7 MB):
1.23MiB 0:00:00 [9.22MiB/s] [========================================================================>                           ] 73%            
INFO: Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-02-13:11:16:36-GMT-06:00 ... syncoid_orion_2025-02-13:12:13:58-GMT-06:00 to recv/test/l0_0/l1_1/l2_2 (~ 1.7 MB):
1.23MiB 0:00:00 [8.81MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-02-13:11:17:43-GMT-06:00 ... syncoid_orion_2025-02-13:12:13:59-GMT-06:00 to recv/test/l0_0/l1_1/l2_3 (~ 1.7 MB):
1.23MiB 0:00:00 [9.26MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_0/l1_2@syncoid_orion_2025-02-13:11:18:49-GMT-06:00 ... syncoid_orion_2025-02-13:12:13:59-GMT-06:00 to recv/test/l0_0/l1_2 (~ 1.7 MB):
1.24MiB 0:00:00 [9.30MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-02-13:11:19:57-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:00-GMT-06:00 to recv/test/l0_0/l1_2/l2_0 (~ 1.7 MB):
1.23MiB 0:00:00 [7.76MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-02-13:11:21:04-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:00-GMT-06:00 to recv/test/l0_0/l1_2/l2_1 (~ 1.7 MB):
1.23MiB 0:00:00 [8.83MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-02-13:11:22:09-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:01-GMT-06:00 to recv/test/l0_0/l1_2/l2_2 (~ 1.7 MB):
1.23MiB 0:00:00 [8.36MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-02-13:11:23:14-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:01-GMT-06:00 to recv/test/l0_0/l1_2/l2_3 (~ 1.7 MB):
1.23MiB 0:00:00 [8.57MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_0/l1_3@syncoid_orion_2025-02-13:11:24:20-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:01-GMT-06:00 to recv/test/l0_0/l1_3 (~ 1.7 MB):
1.24MiB 0:00:00 [8.53MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-02-13:11:25:25-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:02-GMT-06:00 to recv/test/l0_0/l1_3/l2_0 (~ 1.7 MB):
1.23MiB 0:00:00 [8.43MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-02-13:11:26:30-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:02-GMT-06:00 to recv/test/l0_0/l1_3/l2_1 (~ 1.7 MB):
1.23MiB 0:00:00 [8.60MiB/s] [========================================================================>                           ] 73%            
INFO: Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-02-13:11:27:36-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:03-GMT-06:00 to recv/test/l0_0/l1_3/l2_2 (~ 1.7 MB):
1.23MiB 0:00:00 [8.94MiB/s] [========================================================================>                           ] 73%            
INFO: Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-02-13:11:28:41-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:03-GMT-06:00 to recv/test/l0_0/l1_3/l2_3 (~ 1.7 MB):
1.23MiB 0:00:00 [8.47MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_1@syncoid_orion_2025-02-13:11:29:47-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:03-GMT-06:00 to recv/test/l0_1 (~ 1.7 MB):
1.24MiB 0:00:00 [8.04MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_1/l1_0@syncoid_orion_2025-02-13:11:30:54-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:04-GMT-06:00 to recv/test/l0_1/l1_0 (~ 1.7 MB):
1.24MiB 0:00:00 [8.65MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-02-13:11:31:59-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:04-GMT-06:00 to recv/test/l0_1/l1_0/l2_0 (~ 1.7 MB):
1.23MiB 0:00:00 [8.89MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-02-13:11:33:03-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:05-GMT-06:00 to recv/test/l0_1/l1_0/l2_1 (~ 1.7 MB):
1.23MiB 0:00:00 [8.56MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-02-13:11:34:06-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:05-GMT-06:00 to recv/test/l0_1/l1_0/l2_2 (~ 1.7 MB):
1.23MiB 0:00:00 [8.76MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-02-13:11:35:11-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:05-GMT-06:00 to recv/test/l0_1/l1_0/l2_3 (~ 1.7 MB):
1.23MiB 0:00:00 [8.59MiB/s] [========================================================================>                           ] 73%            
INFO: Sending incremental send/test/l0_1/l1_1@syncoid_orion_2025-02-13:11:36:18-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:06-GMT-06:00 to recv/test/l0_1/l1_1 (~ 1.7 MB):
1.24MiB 0:00:00 [8.84MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-02-13:11:37:25-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:06-GMT-06:00 to recv/test/l0_1/l1_1/l2_0 (~ 1.7 MB):
1.23MiB 0:00:00 [8.73MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-02-13:11:38:31-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:07-GMT-06:00 to recv/test/l0_1/l1_1/l2_1 (~ 1.7 MB):
1.23MiB 0:00:00 [8.78MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_orion_2025-02-13:11:39:37-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:07-GMT-06:00 to recv/test/l0_1/l1_1/l2_2 (~ 1.7 MB):
1.23MiB 0:00:00 [8.68MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_1/l1_1/l2_3@syncoid_orion_2025-02-13:11:40:41-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:07-GMT-06:00 to recv/test/l0_1/l1_1/l2_3 (~ 1.7 MB):
1.23MiB 0:00:00 [8.83MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_1/l1_2@syncoid_orion_2025-02-13:11:41:46-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:08-GMT-06:00 to recv/test/l0_1/l1_2 (~ 1.7 MB):
1.23MiB 0:00:00 [8.95MiB/s] [========================================================================>                           ] 73%            
INFO: Sending incremental send/test/l0_1/l1_2/l2_0@syncoid_orion_2025-02-13:11:42:51-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:08-GMT-06:00 to recv/test/l0_1/l1_2/l2_0 (~ 1.7 MB):
1.23MiB 0:00:00 [9.01MiB/s] [========================================================================>                           ] 73%            
INFO: Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_orion_2025-02-13:11:43:57-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:09-GMT-06:00 to recv/test/l0_1/l1_2/l2_1 (~ 1.7 MB):
1.23MiB 0:00:00 [8.63MiB/s] [========================================================================>                           ] 73%            
INFO: Sending incremental send/test/l0_1/l1_2/l2_2@syncoid_orion_2025-02-13:11:45:03-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:09-GMT-06:00 to recv/test/l0_1/l1_2/l2_2 (~ 1.7 MB):
1.23MiB 0:00:00 [8.62MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_1/l1_2/l2_3@syncoid_orion_2025-02-13:11:46:10-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:09-GMT-06:00 to recv/test/l0_1/l1_2/l2_3 (~ 1.7 MB):
1.23MiB 0:00:00 [8.55MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_1/l1_3@syncoid_orion_2025-02-13:11:47:16-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:10-GMT-06:00 to recv/test/l0_1/l1_3 (~ 1.7 MB):
1.24MiB 0:00:00 [8.88MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_1/l1_3/l2_0@syncoid_orion_2025-02-13:11:48:21-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:10-GMT-06:00 to recv/test/l0_1/l1_3/l2_0 (~ 1.7 MB):
1.23MiB 0:00:00 [8.79MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_1/l1_3/l2_1@syncoid_orion_2025-02-13:11:49:27-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:11-GMT-06:00 to recv/test/l0_1/l1_3/l2_1 (~ 1.7 MB):
1.23MiB 0:00:00 [9.21MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_1/l1_3/l2_2@syncoid_orion_2025-02-13:11:50:33-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:11-GMT-06:00 to recv/test/l0_1/l1_3/l2_2 (~ 1.7 MB):
1.23MiB 0:00:00 [9.00MiB/s] [========================================================================>                           ] 73%            
INFO: Sending incremental send/test/l0_1/l1_3/l2_3@syncoid_orion_2025-02-13:11:51:39-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:11-GMT-06:00 to recv/test/l0_1/l1_3/l2_3 (~ 1.7 MB):
1.23MiB 0:00:00 [8.87MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_2@syncoid_orion_2025-02-13:11:52:45-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:12-GMT-06:00 to recv/test/l0_2 (~ 1.7 MB):
1.23MiB 0:00:00 [7.70MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_2/l1_0@syncoid_orion_2025-02-13:11:53:50-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:12-GMT-06:00 to recv/test/l0_2/l1_0 (~ 1.7 MB):
1.23MiB 0:00:00 [8.98MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_2/l1_0/l2_0@syncoid_orion_2025-02-13:11:54:55-GMT-06:00 ... syncoid_orion_2025-02-13:12:14:13-GMT-06:00 to recv/test/l0_2/l1_0/l2_0 (~ 730 KB):
 446KiB 0:00:00 [5.57MiB/s] [============================================================>                                       ] 61%            
real 18.83
user 4.57
sys 11.36
hbarta@orion:~$ 
```
