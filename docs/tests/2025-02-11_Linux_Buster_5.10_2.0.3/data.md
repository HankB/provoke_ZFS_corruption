# Data - Buster 5.10 and 2.0.3 repeat

* [Results](./results.md)
* [Setup](./setup.md)

## 2025-02-11 first syncoid

```text
root@orcus:/home/hbarta/Downloads# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_orcus_2025-02-11:23:37:46-GMT-06:00 to new target filesystem recv/test (~ 86 KB):
47.7KiB 0:00:00 [3.03MiB/s] [====================================================>                                             ] 55%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_orcus_2025-02-11:23:37:46-GMT-06:00 to new target filesystem recv/test/l0_0 (~ 15.2 GB):
15.2GiB 0:01:06 [ 234MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_orcus_2025-02-11:23:38:53-GMT-06:00 to new target filesystem recv/test/l0_0/l1_0 (~ 15.3 GB):
15.3GiB 0:01:03 [ 246MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_orcus_2025-02-11:23:39:57-GMT-06:00 to new target filesystem recv/test/l0_0/l1_0/l2_0 (~ 15.7 GB):
15.7GiB 0:01:08 [ 235MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_orcus_2025-02-11:23:41:06-GMT-06:00 to new target filesystem recv/test/l0_0/l1_0/l2_1 (~ 15.6 GB):
15.6GiB 0:01:07 [ 237MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_orcus_2025-02-11:23:42:14-GMT-06:00 to new target filesystem recv/test/l0_0/l1_0/l2_2 (~ 15.5 GB):
15.5GiB 0:01:05 [ 240MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_orcus_2025-02-11:23:43:20-GMT-06:00 to new target filesystem recv/test/l0_0/l1_0/l2_3 (~ 15.3 GB):
15.3GiB 0:01:05 [ 240MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_orcus_2025-02-11:23:44:25-GMT-06:00 to new target filesystem recv/test/l0_0/l1_1 (~ 15.3 GB):
15.3GiB 0:01:06 [ 236MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_orcus_2025-02-11:23:45:32-GMT-06:00 to new target filesystem recv/test/l0_0/l1_1/l2_0 (~ 15.2 GB):
15.2GiB 0:01:05 [ 238MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_orcus_2025-02-11:23:46:38-GMT-06:00 to new target filesystem recv/test/l0_0/l1_1/l2_1 (~ 15.9 GB):
15.9GiB 0:01:06 [ 244MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_orcus_2025-02-11:23:47:45-GMT-06:00 to new target filesystem recv/test/l0_0/l1_1/l2_2 (~ 15.3 GB):
15.3GiB 0:01:06 [ 235MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_orcus_2025-02-11:23:48:52-GMT-06:00 to new target filesystem recv/test/l0_0/l1_1/l2_3 (~ 15.5 GB):
15.5GiB 0:01:06 [ 239MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_orcus_2025-02-11:23:49:59-GMT-06:00 to new target filesystem recv/test/l0_0/l1_2 (~ 15.6 GB):
15.6GiB 0:01:07 [ 238MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_orcus_2025-02-11:23:51:07-GMT-06:00 to new target filesystem recv/test/l0_0/l1_2/l2_0 (~ 15.7 GB):
15.7GiB 0:01:06 [ 241MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_orcus_2025-02-11:23:52:14-GMT-06:00 to new target filesystem recv/test/l0_0/l1_2/l2_1 (~ 15.4 GB):
15.4GiB 0:01:05 [ 240MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_orcus_2025-02-11:23:53:20-GMT-06:00 to new target filesystem recv/test/l0_0/l1_2/l2_2 (~ 15.8 GB):
15.8GiB 0:01:07 [ 239MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_orcus_2025-02-11:23:54:28-GMT-06:00 to new target filesystem recv/test/l0_0/l1_2/l2_3 (~ 15.4 GB):
15.4GiB 0:01:05 [ 242MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_orcus_2025-02-11:23:55:33-GMT-06:00 to new target filesystem recv/test/l0_0/l1_3 (~ 15.8 GB):
15.8GiB 0:01:07 [ 238MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_orcus_2025-02-11:23:56:41-GMT-06:00 to new target filesystem recv/test/l0_0/l1_3/l2_0 (~ 15.3 GB):
15.3GiB 0:01:05 [ 239MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_orcus_2025-02-11:23:57:47-GMT-06:00 to new target filesystem recv/test/l0_0/l1_3/l2_1 (~ 15.6 GB):
15.6GiB 0:01:06 [ 239MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_orcus_2025-02-11:23:58:54-GMT-06:00 to new target filesystem recv/test/l0_0/l1_3/l2_2 (~ 15.3 GB):
15.3GiB 0:01:04 [ 243MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_orcus_2025-02-11:23:59:59-GMT-06:00 to new target filesystem recv/test/l0_0/l1_3/l2_3 (~ 15.5 GB):
15.5GiB 0:01:08 [ 232MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_orcus_2025-02-12:00:01:08-GMT-06:00 to new target filesystem recv/test/l0_1 (~ 15.2 GB):
15.2GiB 0:01:05 [ 238MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_orcus_2025-02-12:00:02:14-GMT-06:00 to new target filesystem recv/test/l0_1/l1_0 (~ 15.4 GB):
15.4GiB 0:01:06 [ 237MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_orcus_2025-02-12:00:03:20-GMT-06:00 to new target filesystem recv/test/l0_1/l1_0/l2_0 (~ 15.3 GB):
15.3GiB 0:01:05 [ 239MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_orcus_2025-02-12:00:04:26-GMT-06:00 to new target filesystem recv/test/l0_1/l1_0/l2_1 (~ 15.3 GB):
15.3GiB 0:01:05 [ 238MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_orcus_2025-02-12:00:05:32-GMT-06:00 to new target filesystem recv/test/l0_1/l1_0/l2_2 (~ 15.3 GB):
15.3GiB 0:01:06 [ 236MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_orcus_2025-02-12:00:06:39-GMT-06:00 to new target filesystem recv/test/l0_1/l1_0/l2_3 (~ 15.3 GB):
15.3GiB 0:01:05 [ 239MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_orcus_2025-02-12:00:07:44-GMT-06:00 to new target filesystem recv/test/l0_1/l1_1 (~ 15.2 GB):
15.3GiB 0:01:05 [ 237MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_orcus_2025-02-12:00:08:51-GMT-06:00 to new target filesystem recv/test/l0_1/l1_1/l2_0 (~ 15.4 GB):
15.4GiB 0:01:06 [ 238MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-12:00:09:57-GMT-06:00 to new target filesystem recv/test/l0_1/l1_1/l2_1 (~ 15.2 GB):
15.2GiB 0:01:03 [ 244MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_2@syncoid_orcus_2025-02-12:00:11:01-GMT-06:00 to new target filesystem recv/test/l0_1/l1_1/l2_2 (~ 15.2 GB):
15.2GiB 0:01:04 [ 240MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_3@syncoid_orcus_2025-02-12:00:12:07-GMT-06:00 to new target filesystem recv/test/l0_1/l1_1/l2_3 (~ 15.9 GB):
15.9GiB 0:01:07 [ 241MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2@syncoid_orcus_2025-02-12:00:13:14-GMT-06:00 to new target filesystem recv/test/l0_1/l1_2 (~ 15.5 GB):
15.5GiB 0:01:05 [ 242MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_0@syncoid_orcus_2025-02-12:00:14:20-GMT-06:00 to new target filesystem recv/test/l0_1/l1_2/l2_0 (~ 15.7 GB):
15.7GiB 0:01:07 [ 240MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_1@syncoid_orcus_2025-02-12:00:15:27-GMT-06:00 to new target filesystem recv/test/l0_1/l1_2/l2_1 (~ 15.5 GB):
15.5GiB 0:01:06 [ 237MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_2@syncoid_orcus_2025-02-12:00:16:35-GMT-06:00 to new target filesystem recv/test/l0_1/l1_2/l2_2 (~ 15.5 GB):
15.5GiB 0:01:06 [ 237MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_3@syncoid_orcus_2025-02-12:00:17:42-GMT-06:00 to new target filesystem recv/test/l0_1/l1_2/l2_3 (~ 15.5 GB):
15.5GiB 0:01:07 [ 236MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3@syncoid_orcus_2025-02-12:00:18:49-GMT-06:00 to new target filesystem recv/test/l0_1/l1_3 (~ 15.5 GB):
15.5GiB 0:01:06 [ 239MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3/l2_0@syncoid_orcus_2025-02-12:00:19:56-GMT-06:00 to new target filesystem recv/test/l0_1/l1_3/l2_0 (~ 15.4 GB):
15.4GiB 0:01:05 [ 240MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3/l2_1@syncoid_orcus_2025-02-12:00:21:02-GMT-06:00 to new target filesystem recv/test/l0_1/l1_3/l2_1 (~ 15.6 GB):
15.6GiB 0:01:06 [ 240MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3/l2_2@syncoid_orcus_2025-02-12:00:22:09-GMT-06:00 to new target filesystem recv/test/l0_1/l1_3/l2_2 (~ 15.3 GB):
15.3GiB 0:01:05 [ 238MiB/s] [================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3/l2_3@syncoid_orcus_2025-02-12:00:23:15-GMT-06:00 to new target filesystem recv/test/l0_1/l1_3/l2_3 (~ 7.2 GB):
7.17GiB 0:00:30 [ 242MiB/s] [================================================================================================>] 100%            
real 2760.29
user 42.91
sys 2681.31
root@orcus:/home/hbarta/Downloads# 
root@orcus:/home/hbarta/Downloads# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   327G   137G        -         -     0%    70%  1.00x    ONLINE  -
send   464G   327G   137G        -         -     0%    70%  1.00x    ONLINE  -
root@orcus:/home/hbarta/Downloads# 
```

## 2025-02-12 2nd syncoid as user

```text
hbarta@orcus:~/provoke_ZFS_corruption$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending incremental send/test@syncoid_orcus_2025-02-11:23:37:46-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:28-GMT-06:00 to recv/test (~ 4 KB):
1.52KiB 0:00:00 [55.4KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_0@syncoid_orcus_2025-02-11:23:37:46-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:28-GMT-06:00 to recv/test/l0_0 (~ 4 KB):
1.52KiB 0:00:00 [46.1KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_0/l1_0@syncoid_orcus_2025-02-11:23:38:53-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:28-GMT-06:00 to recv/test/l0_0/l1_0 (~ 4 KB):
1.52KiB 0:00:00 [45.0KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_orcus_2025-02-11:23:39:57-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:29-GMT-06:00 to recv/test/l0_0/l1_0/l2_0 (~ 4 KB):
1.52KiB 0:00:00 [40.3KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_orcus_2025-02-11:23:41:06-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:29-GMT-06:00 to recv/test/l0_0/l1_0/l2_1 (~ 4 KB):
1.52KiB 0:00:00 [57.2KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_orcus_2025-02-11:23:42:14-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:29-GMT-06:00 to recv/test/l0_0/l1_0/l2_2 (~ 4 KB):
1.52KiB 0:00:00 [52.7KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_orcus_2025-02-11:23:43:20-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:29-GMT-06:00 to recv/test/l0_0/l1_0/l2_3 (~ 4 KB):
1.52KiB 0:00:00 [57.9KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_0/l1_1@syncoid_orcus_2025-02-11:23:44:25-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:30-GMT-06:00 to recv/test/l0_0/l1_1 (~ 4 KB):
1.52KiB 0:00:00 [53.9KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_orcus_2025-02-11:23:45:32-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:30-GMT-06:00 to recv/test/l0_0/l1_1/l2_0 (~ 4 KB):
1.52KiB 0:00:00 [46.8KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_orcus_2025-02-11:23:46:38-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:30-GMT-06:00 to recv/test/l0_0/l1_1/l2_1 (~ 4 KB):
1.52KiB 0:00:00 [56.3KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orcus_2025-02-11:23:47:45-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:30-GMT-06:00 to recv/test/l0_0/l1_1/l2_2 (~ 4 KB):
1.52KiB 0:00:00 [57.3KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orcus_2025-02-11:23:48:52-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:31-GMT-06:00 to recv/test/l0_0/l1_1/l2_3 (~ 4 KB):
1.52KiB 0:00:00 [55.4KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_0/l1_2@syncoid_orcus_2025-02-11:23:49:59-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:31-GMT-06:00 to recv/test/l0_0/l1_2 (~ 4 KB):
1.52KiB 0:00:00 [55.6KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_orcus_2025-02-11:23:51:07-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:31-GMT-06:00 to recv/test/l0_0/l1_2/l2_0 (~ 4 KB):
1.52KiB 0:00:00 [54.3KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_orcus_2025-02-11:23:52:14-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:31-GMT-06:00 to recv/test/l0_0/l1_2/l2_1 (~ 4 KB):
1.52KiB 0:00:00 [53.4KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_orcus_2025-02-11:23:53:20-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:32-GMT-06:00 to recv/test/l0_0/l1_2/l2_2 (~ 4 KB):
1.52KiB 0:00:00 [56.8KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_orcus_2025-02-11:23:54:28-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:32-GMT-06:00 to recv/test/l0_0/l1_2/l2_3 (~ 4 KB):
1.52KiB 0:00:00 [50.7KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_0/l1_3@syncoid_orcus_2025-02-11:23:55:33-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:32-GMT-06:00 to recv/test/l0_0/l1_3 (~ 4 KB):
1.52KiB 0:00:00 [54.5KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_orcus_2025-02-11:23:56:41-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:32-GMT-06:00 to recv/test/l0_0/l1_3/l2_0 (~ 4 KB):
1.52KiB 0:00:00 [53.3KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_orcus_2025-02-11:23:57:47-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:33-GMT-06:00 to recv/test/l0_0/l1_3/l2_1 (~ 4 KB):
1.52KiB 0:00:00 [54.0KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_orcus_2025-02-11:23:58:54-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:33-GMT-06:00 to recv/test/l0_0/l1_3/l2_2 (~ 4 KB):
1.52KiB 0:00:00 [57.6KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_orcus_2025-02-11:23:59:59-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:33-GMT-06:00 to recv/test/l0_0/l1_3/l2_3 (~ 4 KB):
1.52KiB 0:00:00 [56.0KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_1@syncoid_orcus_2025-02-12:00:01:08-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:33-GMT-06:00 to recv/test/l0_1 (~ 4 KB):
1.52KiB 0:00:00 [57.4KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_1/l1_0@syncoid_orcus_2025-02-12:00:02:14-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:34-GMT-06:00 to recv/test/l0_1/l1_0 (~ 4 KB):
1.52KiB 0:00:00 [53.6KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_orcus_2025-02-12:00:03:20-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:34-GMT-06:00 to recv/test/l0_1/l1_0/l2_0 (~ 4 KB):
1.52KiB 0:00:00 [54.6KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_orcus_2025-02-12:00:04:26-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:34-GMT-06:00 to recv/test/l0_1/l1_0/l2_1 (~ 4 KB):
1.52KiB 0:00:00 [52.7KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_orcus_2025-02-12:00:05:32-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:34-GMT-06:00 to recv/test/l0_1/l1_0/l2_2 (~ 4 KB):
1.52KiB 0:00:00 [49.0KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_orcus_2025-02-12:00:06:39-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:34-GMT-06:00 to recv/test/l0_1/l1_0/l2_3 (~ 4 KB):
1.52KiB 0:00:00 [54.4KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_1/l1_1@syncoid_orcus_2025-02-12:00:07:44-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:35-GMT-06:00 to recv/test/l0_1/l1_1 (~ 4 KB):
1.52KiB 0:00:00 [55.5KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_orcus_2025-02-12:00:08:51-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:35-GMT-06:00 to recv/test/l0_1/l1_1/l2_0 (~ 4 KB):
1.52KiB 0:00:00 [43.9KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-12:00:09:57-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:35-GMT-06:00 to recv/test/l0_1/l1_1/l2_1 (~ 4 KB):
1.52KiB 0:00:00 [43.0KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_orcus_2025-02-12:00:11:01-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:35-GMT-06:00 to recv/test/l0_1/l1_1/l2_2 (~ 4 KB):
1.52KiB 0:00:00 [41.4KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_1/l1_1/l2_3@syncoid_orcus_2025-02-12:00:12:07-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:36-GMT-06:00 to recv/test/l0_1/l1_1/l2_3 (~ 4 KB):
1.52KiB 0:00:00 [48.1KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_1/l1_2@syncoid_orcus_2025-02-12:00:13:14-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:36-GMT-06:00 to recv/test/l0_1/l1_2 (~ 4 KB):
1.52KiB 0:00:00 [51.1KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_1/l1_2/l2_0@syncoid_orcus_2025-02-12:00:14:20-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:36-GMT-06:00 to recv/test/l0_1/l1_2/l2_0 (~ 4 KB):
1.52KiB 0:00:00 [54.2KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_orcus_2025-02-12:00:15:27-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:36-GMT-06:00 to recv/test/l0_1/l1_2/l2_1 (~ 4 KB):
1.52KiB 0:00:00 [51.9KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_1/l1_2/l2_2@syncoid_orcus_2025-02-12:00:16:35-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:37-GMT-06:00 to recv/test/l0_1/l1_2/l2_2 (~ 4 KB):
1.52KiB 0:00:00 [53.2KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_1/l1_2/l2_3@syncoid_orcus_2025-02-12:00:17:42-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:37-GMT-06:00 to recv/test/l0_1/l1_2/l2_3 (~ 4 KB):
1.52KiB 0:00:00 [56.2KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_1/l1_3@syncoid_orcus_2025-02-12:00:18:49-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:37-GMT-06:00 to recv/test/l0_1/l1_3 (~ 4 KB):
1.52KiB 0:00:00 [54.1KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_1/l1_3/l2_0@syncoid_orcus_2025-02-12:00:19:56-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:37-GMT-06:00 to recv/test/l0_1/l1_3/l2_0 (~ 4 KB):
1.52KiB 0:00:00 [52.5KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_1/l1_3/l2_1@syncoid_orcus_2025-02-12:00:21:02-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:38-GMT-06:00 to recv/test/l0_1/l1_3/l2_1 (~ 4 KB):
1.52KiB 0:00:00 [51.3KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_1/l1_3/l2_2@syncoid_orcus_2025-02-12:00:22:09-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:38-GMT-06:00 to recv/test/l0_1/l1_3/l2_2 (~ 4 KB):
1.52KiB 0:00:00 [52.2KiB/s] [====================================>                                                             ] 38%            
INFO: Sending incremental send/test/l0_1/l1_3/l2_3@syncoid_orcus_2025-02-12:00:23:15-GMT-06:00 ... syncoid_orcus_2025-02-12:09:23:38-GMT-06:00 to recv/test/l0_1/l1_3/l2_3 (~ 4 KB):
1.52KiB 0:00:00 [58.5KiB/s] [====================================>                                                             ] 38%            
real 10.85
user 3.35
sys 5.17
hbarta@orcus:~/provoke_ZFS_corruption$ 
```

## 2025-02-12 list of logs

```text
hbarta@orcus:~/logs$ ls -lrt
total 307076
-rw-r--r-- 1 hbarta hbarta 536038 Feb 12 09:32 2025-02-12-0932.stir_pools.30.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:32 2025-02-12-0932.syncoid.12.txt
-rw-r--r-- 1 hbarta hbarta 531124 Feb 12 09:33 2025-02-12-0932.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:33 2025-02-12-0932.syncoid.11.txt
-rw-r--r-- 1 hbarta hbarta 529124 Feb 12 09:33 2025-02-12-0933.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:33 2025-02-12-0933.syncoid.12.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:33 2025-02-12-0933.syncoid.11.txt
-rw-r--r-- 1 hbarta hbarta 531365 Feb 12 09:33 2025-02-12-0933.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:34 2025-02-12-0934.trim_snaps.1.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:34 2025-02-12-0933.syncoid.13.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:34 2025-02-12-0934.syncoid.13.txt
-rw-r--r-- 1 hbarta hbarta 536446 Feb 12 09:34 2025-02-12-0934.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:35 2025-02-12-0934.syncoid.12.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:35 2025-02-12-0935.trim_snaps.1.txt
-rw-r--r-- 1 hbarta hbarta 538429 Feb 12 09:35 2025-02-12-0934.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 534375 Feb 12 09:35 2025-02-12-0935.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:35 2025-02-12-0935.syncoid.13.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:36 2025-02-12-0935.syncoid.14.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:36 2025-02-12-0936.trim_snaps.1.txt
-rw-r--r-- 1 hbarta hbarta 532805 Feb 12 09:36 2025-02-12-0935.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:36 2025-02-12-0936.syncoid.13.txt
-rw-r--r-- 1 hbarta hbarta 536291 Feb 12 09:36 2025-02-12-0936.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:36 2025-02-12-0936.syncoid.14.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:37 2025-02-12-0936.syncoid.15.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:37 2025-02-12-0937.trim_snaps.1.txt
-rw-r--r-- 1 hbarta hbarta 534224 Feb 12 09:37 2025-02-12-0936.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 534300 Feb 12 09:37 2025-02-12-0937.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:37 2025-02-12-0937.syncoid.14.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:38 2025-02-12-0937.syncoid.15.txt
-rw-r--r-- 1 hbarta hbarta 539063 Feb 12 09:38 2025-02-12-0937.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:38 2025-02-12-0938.trim_snaps.1.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:38 2025-02-12-0938.syncoid.16.txt
-rw-r--r-- 1 hbarta hbarta 543402 Feb 12 09:39 2025-02-12-0938.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:39 2025-02-12-0938.syncoid.15.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:39 2025-02-12-0939.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:39 2025-02-12-0939.syncoid.16.txt
-rw-r--r-- 1 hbarta hbarta 533544 Feb 12 09:39 2025-02-12-0939.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:40 2025-02-12-0939.syncoid.17.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:40 2025-02-12-0940.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta 534469 Feb 12 09:40 2025-02-12-0939.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:40 2025-02-12-0940.syncoid.18.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:41 2025-02-12-0940.syncoid.17.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:41 2025-02-12-0941.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:41 2025-02-12-0941.syncoid.18.txt
-rw-r--r-- 1 hbarta hbarta 539306 Feb 12 09:41 2025-02-12-0940.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 538764 Feb 12 09:41 2025-02-12-0941.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:41 2025-02-12-0941.syncoid.17.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:42 2025-02-12-0941.syncoid.19.txt
-rw-r--r-- 1 hbarta hbarta 537250 Feb 12 09:42 2025-02-12-0941.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:42 2025-02-12-0942.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:42 2025-02-12-0942.syncoid.19.txt
-rw-r--r-- 1 hbarta hbarta 536003 Feb 12 09:43 2025-02-12-0942.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:43 2025-02-12-0942.syncoid.20.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:43 2025-02-12-0943.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta 533856 Feb 12 09:43 2025-02-12-0943.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:43 2025-02-12-0943.syncoid.21.txt
-rw-r--r-- 1 hbarta hbarta 531680 Feb 12 09:44 2025-02-12-0943.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:44 2025-02-12-0943.syncoid.20.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:44 2025-02-12-0944.trim_snaps.3.txt
-rw-r--r-- 1 hbarta hbarta 530667 Feb 12 09:44 2025-02-12-0944.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:44 2025-02-12-0944.syncoid.22.txt
-rw-r--r-- 1 hbarta hbarta 530193 Feb 12 09:45 2025-02-12-0944.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:45 2025-02-12-0944.syncoid.21.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:45 2025-02-12-0945.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta 529587 Feb 12 09:45 2025-02-12-0945.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:46 2025-02-12-0945.syncoid.22.txt
-rw-r--r-- 1 hbarta hbarta 534529 Feb 12 09:46 2025-02-12-0945.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:46 2025-02-12-0946.trim_snaps.3.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:46 2025-02-12-0946.syncoid.22.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:47 2025-02-12-0946.syncoid.23.txt
-rw-r--r-- 1 hbarta hbarta 537727 Feb 12 09:47 2025-02-12-0946.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:47 2025-02-12-0947.trim_snaps.3.txt
-rw-r--r-- 1 hbarta hbarta 527311 Feb 12 09:47 2025-02-12-0947.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 534429 Feb 12 09:48 2025-02-12-0947.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:48 2025-02-12-0947.syncoid.23.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:48 2025-02-12-0948.trim_snaps.3.txt
-rw-r--r-- 1 hbarta hbarta 534023 Feb 12 09:48 2025-02-12-0948.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:49 2025-02-12-0948.syncoid.24.txt
-rw-r--r-- 1 hbarta hbarta 534757 Feb 12 09:49 2025-02-12-0948.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:49 2025-02-12-0949.trim_snaps.3.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:49 2025-02-12-0949.syncoid.25.txt
-rw-r--r-- 1 hbarta hbarta 538341 Feb 12 09:50 2025-02-12-0949.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:50 2025-02-12-0949.syncoid.24.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:50 2025-02-12-0950.trim_snaps.3.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:50 2025-02-12-0950.syncoid.25.txt
-rw-r--r-- 1 hbarta hbarta 538855 Feb 12 09:51 2025-02-12-0950.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:51 2025-02-12-0950.syncoid.26.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:51 2025-02-12-0951.trim_snaps.3.txt
-rw-r--r-- 1 hbarta hbarta 525352 Feb 12 09:51 2025-02-12-0951.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:52 2025-02-12-0951.syncoid.25.txt
-rw-r--r-- 1 hbarta hbarta 533026 Feb 12 09:52 2025-02-12-0951.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 531054 Feb 12 09:52 2025-02-12-0952.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:52 2025-02-12-0952.trim_snaps.3.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:52 2025-02-12-0952.syncoid.26.txt
-rw-r--r-- 1 hbarta hbarta 533776 Feb 12 09:53 2025-02-12-0952.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:53 2025-02-12-0952.syncoid.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:53 2025-02-12-0953.syncoid.26.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:53 2025-02-12-0953.trim_snaps.4.txt
-rw-r--r-- 1 hbarta hbarta 539046 Feb 12 09:54 2025-02-12-0953.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:54 2025-02-12-0953.syncoid.27.txt
-rw-r--r-- 1 hbarta hbarta 534203 Feb 12 09:54 2025-02-12-0954.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:54 2025-02-12-0954.trim_snaps.4.txt
-rw-r--r-- 1 hbarta hbarta 531290 Feb 12 09:55 2025-02-12-0954.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:55 2025-02-12-0954.syncoid.27.txt
-rw-r--r-- 1 hbarta hbarta 534189 Feb 12 09:55 2025-02-12-0955.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:55 2025-02-12-0955.syncoid.27.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:56 2025-02-12-0955.trim_snaps.3.txt
-rw-r--r-- 1 hbarta hbarta 540558 Feb 12 09:56 2025-02-12-0955.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:56 2025-02-12-0955.syncoid.29.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:56 2025-02-12-0956.syncoid.28.txt
-rw-r--r-- 1 hbarta hbarta 533488 Feb 12 09:56 2025-02-12-0956.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:57 2025-02-12-0956.syncoid.29.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:57 2025-02-12-0957.trim_snaps.5.txt
-rw-r--r-- 1 hbarta hbarta 532240 Feb 12 09:57 2025-02-12-0956.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:58 2025-02-12-0957.syncoid.29.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:58 2025-02-12-0958.trim_snaps.4.txt
-rw-r--r-- 1 hbarta hbarta 530847 Feb 12 09:58 2025-02-12-0957.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:59 2025-02-12-0958.syncoid.30.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 09:59 2025-02-12-0959.trim_snaps.4.txt
-rw-r--r-- 1 hbarta hbarta 535323 Feb 12 09:59 2025-02-12-0958.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 09:59 2025-02-12-0959.syncoid.31.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:00 2025-02-12-0959.syncoid.30.txt
-rw-r--r-- 1 hbarta hbarta 528491 Feb 12 10:00 2025-02-12-0959.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 10:00 2025-02-12-1000.trim_snaps.5.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:00 2025-02-12-1000.syncoid.31.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:01 2025-02-12-1000.syncoid.30.txt
-rw-r--r-- 1 hbarta hbarta 537454 Feb 12 10:01 2025-02-12-1000.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 10:01 2025-02-12-1001.trim_snaps.4.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:01 2025-02-12-1001.syncoid.31.txt
-rw-r--r-- 1 hbarta hbarta 538941 Feb 12 10:02 2025-02-12-1001.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:02 2025-02-12-1001.syncoid.32.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 10:02 2025-02-12-1002.trim_snaps.5.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:02 2025-02-12-1002.syncoid.33.txt
-rw-r--r-- 1 hbarta hbarta 532497 Feb 12 10:02 2025-02-12-1002.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:03 2025-02-12-1002.syncoid.32.txt
-rw-r--r-- 1 hbarta hbarta 534891 Feb 12 10:03 2025-02-12-1002.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 10:03 2025-02-12-1003.trim_snaps.5.txt
-rw-r--r-- 1 hbarta hbarta 530803 Feb 12 10:03 2025-02-12-1003.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:04 2025-02-12-1003.syncoid.33.txt
-rw-r--r-- 1 hbarta hbarta 540202 Feb 12 10:04 2025-02-12-1003.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 10:04 2025-02-12-1004.trim_snaps.5.txt
-rw-r--r-- 1 hbarta hbarta 535059 Feb 12 10:05 2025-02-12-1004.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:05 2025-02-12-1004.syncoid.34.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 10:05 2025-02-12-1005.trim_snaps.5.txt
-rw-r--r-- 1 hbarta hbarta 537273 Feb 12 10:05 2025-02-12-1005.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 535731 Feb 12 10:06 2025-02-12-1005.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:06 2025-02-12-1005.syncoid.34.txt
-rw-r--r-- 1 hbarta hbarta 527108 Feb 12 10:06 2025-02-12-1006.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 10:06 2025-02-12-1006.trim_snaps.6.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:07 2025-02-12-1006.syncoid.34.txt
-rw-r--r-- 1 hbarta hbarta 533734 Feb 12 10:07 2025-02-12-1006.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 538549 Feb 12 10:07 2025-02-12-1007.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:07 2025-02-12-1007.syncoid.35.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 10:07 2025-02-12-1007.trim_snaps.5.txt
-rw-r--r-- 1 hbarta hbarta 530760 Feb 12 10:08 2025-02-12-1007.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:08 2025-02-12-1007.syncoid.36.txt
-rw-r--r-- 1 hbarta hbarta 534332 Feb 12 10:08 2025-02-12-1008.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:08 2025-02-12-1008.syncoid.36.txt
-rw-r--r-- 1 hbarta hbarta 532204 Feb 12 10:08 2025-02-12-1008.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 10:09 2025-02-12-1008.trim_snaps.6.txt
-rw-r--r-- 1 hbarta hbarta 533686 Feb 12 10:09 2025-02-12-1008.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:09 2025-02-12-1008.syncoid.37.txt
-rw-r--r-- 1 hbarta hbarta 534430 Feb 12 10:09 2025-02-12-1009.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 10:10 2025-02-12-1010.trim_snaps.6.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:10 2025-02-12-1009.syncoid.37.txt
-rw-r--r-- 1 hbarta hbarta 533526 Feb 12 10:10 2025-02-12-1009.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:10 2025-02-12-1010.syncoid.36.txt
-rw-r--r-- 1 hbarta hbarta 535443 Feb 12 10:10 2025-02-12-1010.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 10:11 2025-02-12-1011.trim_snaps.6.txt
-rw-r--r-- 1 hbarta hbarta 537826 Feb 12 10:11 2025-02-12-1010.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:11 2025-02-12-1010.syncoid.37.txt
-rw-r--r-- 1 hbarta hbarta 527147 Feb 12 10:11 2025-02-12-1011.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 527444 Feb 12 10:12 2025-02-12-1011.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 10:12 2025-02-12-1012.trim_snaps.6.txt
-rw-r--r-- 1 hbarta hbarta 529014 Feb 12 10:12 2025-02-12-1012.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:12 2025-02-12-1011.syncoid.38.txt
-rw-r--r-- 1 hbarta hbarta 529059 Feb 12 10:13 2025-02-12-1012.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:13 2025-02-12-1012.syncoid.38.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 10:13 2025-02-12-1013.trim_snaps.6.txt
-rw-r--r-- 1 hbarta hbarta 530090 Feb 12 10:13 2025-02-12-1013.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta 537900 Feb 12 10:14 2025-02-12-1013.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 10:14 2025-02-12-1014.trim_snaps.7.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:14 2025-02-12-1013.syncoid.39.txt
-rw-r--r-- 1 hbarta hbarta 534354 Feb 12 10:14 2025-02-12-1014.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:15 2025-02-12-1014.syncoid.40.txt
-rw-r--r-- 1 hbarta hbarta 531197 Feb 12 10:15 2025-02-12-1014.stir_pools.25.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 10:15 2025-02-12-1015.trim_snaps.6.txt
-rw-r--r-- 1 hbarta hbarta 535321 Feb 12 10:15 2025-02-12-1015.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:15 2025-02-12-1015.syncoid.40.txt
-rw-r--r-- 1 hbarta hbarta 529296 Feb 12 10:16 2025-02-12-1015.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:16 2025-02-12-1015.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta   3933 Feb 12 10:16 2025-02-12-1016.trim_snaps.7.txt
-rw-r--r-- 1 hbarta hbarta 536494 Feb 12 10:16 2025-02-12-1016.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 532353 Feb 12 10:17 2025-02-12-1016.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:17 2025-02-12-1016.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 542840 Feb 12 10:17 2025-02-12-1017.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:17 2025-02-12-1017.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta   7265 Feb 12 10:17 2025-02-12-1017.trim_snaps.13.txt
-rw-r--r-- 1 hbarta hbarta 536288 Feb 12 10:18 2025-02-12-1017.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:18 2025-02-12-1017.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 533204 Feb 12 10:19 2025-02-12-1018.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  16860 Feb 12 10:19 2025-02-12-1018.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:19 2025-02-12-1018.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:20 2025-02-12-1019.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 534242 Feb 12 10:20 2025-02-12-1019.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18590 Feb 12 10:20 2025-02-12-1020.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:20 2025-02-12-1020.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 536759 Feb 12 10:21 2025-02-12-1020.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:21 2025-02-12-1020.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 537009 Feb 12 10:21 2025-02-12-1021.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta  17942 Feb 12 10:21 2025-02-12-1021.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:22 2025-02-12-1021.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 527886 Feb 12 10:22 2025-02-12-1021.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 538220 Feb 12 10:22 2025-02-12-1022.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 535338 Feb 12 10:23 2025-02-12-1022.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18445 Feb 12 10:23 2025-02-12-1022.trim_snaps.19.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:23 2025-02-12-1022.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 533428 Feb 12 10:23 2025-02-12-1023.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 528957 Feb 12 10:24 2025-02-12-1023.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:24 2025-02-12-1023.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18722 Feb 12 10:24 2025-02-12-1024.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:24 2025-02-12-1024.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 535105 Feb 12 10:25 2025-02-12-1024.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 538238 Feb 12 10:25 2025-02-12-1025.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:25 2025-02-12-1024.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18905 Feb 12 10:25 2025-02-12-1025.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:26 2025-02-12-1025.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 534953 Feb 12 10:26 2025-02-12-1025.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:27 2025-02-12-1026.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18605 Feb 12 10:27 2025-02-12-1026.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 530112 Feb 12 10:27 2025-02-12-1026.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:27 2025-02-12-1027.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 530062 Feb 12 10:27 2025-02-12-1027.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 532920 Feb 12 10:28 2025-02-12-1027.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:28 2025-02-12-1027.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18985 Feb 12 10:28 2025-02-12-1028.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 529254 Feb 12 10:28 2025-02-12-1028.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:29 2025-02-12-1028.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 534381 Feb 12 10:29 2025-02-12-1028.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:29 2025-02-12-1029.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  19124 Feb 12 10:29 2025-02-12-1029.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 530661 Feb 12 10:30 2025-02-12-1029.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:30 2025-02-12-1029.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 531660 Feb 12 10:31 2025-02-12-1030.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18366 Feb 12 10:31 2025-02-12-1030.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:31 2025-02-12-1030.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 530777 Feb 12 10:31 2025-02-12-1031.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:32 2025-02-12-1031.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 529179 Feb 12 10:32 2025-02-12-1031.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  17649 Feb 12 10:32 2025-02-12-1032.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:32 2025-02-12-1032.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 537247 Feb 12 10:32 2025-02-12-1032.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 536865 Feb 12 10:33 2025-02-12-1032.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:33 2025-02-12-1032.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  17934 Feb 12 10:33 2025-02-12-1033.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:34 2025-02-12-1033.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 527374 Feb 12 10:34 2025-02-12-1033.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 537583 Feb 12 10:34 2025-02-12-1034.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:34 2025-02-12-1034.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 532263 Feb 12 10:35 2025-02-12-1034.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18620 Feb 12 10:35 2025-02-12-1034.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:35 2025-02-12-1034.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 538293 Feb 12 10:35 2025-02-12-1035.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 541474 Feb 12 10:36 2025-02-12-1035.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:36 2025-02-12-1035.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 538109 Feb 12 10:36 2025-02-12-1036.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18773 Feb 12 10:36 2025-02-12-1036.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:36 2025-02-12-1036.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 535478 Feb 12 10:37 2025-02-12-1036.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:37 2025-02-12-1036.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 536887 Feb 12 10:37 2025-02-12-1037.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18732 Feb 12 10:37 2025-02-12-1037.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:38 2025-02-12-1037.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 533699 Feb 12 10:38 2025-02-12-1037.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:39 2025-02-12-1038.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18783 Feb 12 10:39 2025-02-12-1038.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 532044 Feb 12 10:39 2025-02-12-1038.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 528867 Feb 12 10:40 2025-02-12-1039.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:40 2025-02-12-1039.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18772 Feb 12 10:40 2025-02-12-1040.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:41 2025-02-12-1040.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 539852 Feb 12 10:41 2025-02-12-1040.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:41 2025-02-12-1041.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18889 Feb 12 10:41 2025-02-12-1041.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 528975 Feb 12 10:42 2025-02-12-1041.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:42 2025-02-12-1041.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 535993 Feb 12 10:42 2025-02-12-1042.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta 536427 Feb 12 10:43 2025-02-12-1042.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:43 2025-02-12-1042.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  17710 Feb 12 10:43 2025-02-12-1042.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 536367 Feb 12 10:43 2025-02-12-1043.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 530473 Feb 12 10:43 2025-02-12-1043.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta 530293 Feb 12 10:44 2025-02-12-1043.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18478 Feb 12 10:44 2025-02-12-1044.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:44 2025-02-12-1043.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 526375 Feb 12 10:44 2025-02-12-1044.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:45 2025-02-12-1044.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 535890 Feb 12 10:45 2025-02-12-1044.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 534420 Feb 12 10:45 2025-02-12-1045.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta  18056 Feb 12 10:45 2025-02-12-1045.trim_snaps.19.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:46 2025-02-12-1045.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 540008 Feb 12 10:46 2025-02-12-1045.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:46 2025-02-12-1046.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 534380 Feb 12 10:47 2025-02-12-1046.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18707 Feb 12 10:47 2025-02-12-1046.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:47 2025-02-12-1046.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 533229 Feb 12 10:48 2025-02-12-1047.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:48 2025-02-12-1047.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18605 Feb 12 10:48 2025-02-12-1048.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 540270 Feb 12 10:49 2025-02-12-1048.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 536472 Feb 12 10:49 2025-02-12-1049.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:49 2025-02-12-1048.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18905 Feb 12 10:49 2025-02-12-1049.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:50 2025-02-12-1049.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 534770 Feb 12 10:50 2025-02-12-1049.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:50 2025-02-12-1050.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 531091 Feb 12 10:51 2025-02-12-1050.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18849 Feb 12 10:51 2025-02-12-1050.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:51 2025-02-12-1050.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 534249 Feb 12 10:51 2025-02-12-1051.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 534226 Feb 12 10:52 2025-02-12-1051.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:52 2025-02-12-1051.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18961 Feb 12 10:52 2025-02-12-1052.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:53 2025-02-12-1052.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 535528 Feb 12 10:53 2025-02-12-1052.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 533856 Feb 12 10:53 2025-02-12-1053.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:53 2025-02-12-1053.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18783 Feb 12 10:54 2025-02-12-1053.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 533598 Feb 12 10:54 2025-02-12-1053.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:54 2025-02-12-1053.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:55 2025-02-12-1054.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18894 Feb 12 10:55 2025-02-12-1055.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 535855 Feb 12 10:55 2025-02-12-1054.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:55 2025-02-12-1055.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 532989 Feb 12 10:55 2025-02-12-1055.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 530511 Feb 12 10:56 2025-02-12-1055.stir_pools.25.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:56 2025-02-12-1055.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  19419 Feb 12 10:56 2025-02-12-1056.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 527347 Feb 12 10:56 2025-02-12-1056.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 528141 Feb 12 10:57 2025-02-12-1056.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:57 2025-02-12-1056.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 531210 Feb 12 10:57 2025-02-12-1057.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:58 2025-02-12-1057.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  19373 Feb 12 10:58 2025-02-12-1057.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 537766 Feb 12 10:58 2025-02-12-1057.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 536476 Feb 12 10:58 2025-02-12-1058.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:58 2025-02-12-1058.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 532733 Feb 12 10:59 2025-02-12-1058.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta  18528 Feb 12 10:59 2025-02-12-1059.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 10:59 2025-02-12-1058.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 526498 Feb 12 10:59 2025-02-12-1059.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:00 2025-02-12-1059.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 531331 Feb 12 11:00 2025-02-12-1059.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18305 Feb 12 11:00 2025-02-12-1100.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 538637 Feb 12 11:01 2025-02-12-1100.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:01 2025-02-12-1100.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  17227 Feb 12 11:02 2025-02-12-1101.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:02 2025-02-12-1101.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 534937 Feb 12 11:02 2025-02-12-1101.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 534600 Feb 12 11:03 2025-02-12-1102.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18264 Feb 12 11:03 2025-02-12-1103.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:03 2025-02-12-1102.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 532445 Feb 12 11:04 2025-02-12-1103.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:04 2025-02-12-1103.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 532816 Feb 12 11:04 2025-02-12-1104.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18361 Feb 12 11:04 2025-02-12-1104.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 529014 Feb 12 11:05 2025-02-12-1104.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:05 2025-02-12-1104.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 530941 Feb 12 11:05 2025-02-12-1105.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta  18844 Feb 12 11:06 2025-02-12-1105.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 531556 Feb 12 11:06 2025-02-12-1105.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:06 2025-02-12-1105.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:07 2025-02-12-1106.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 531476 Feb 12 11:07 2025-02-12-1106.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18915 Feb 12 11:07 2025-02-12-1107.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 533039 Feb 12 11:07 2025-02-12-1107.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta 532341 Feb 12 11:08 2025-02-12-1107.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:08 2025-02-12-1107.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 535027 Feb 12 11:08 2025-02-12-1108.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  19144 Feb 12 11:08 2025-02-12-1108.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 535015 Feb 12 11:09 2025-02-12-1108.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:09 2025-02-12-1108.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:10 2025-02-12-1109.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  19205 Feb 12 11:10 2025-02-12-1109.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 536279 Feb 12 11:10 2025-02-12-1109.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 535336 Feb 12 11:10 2025-02-12-1110.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 534520 Feb 12 11:11 2025-02-12-1110.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  19017 Feb 12 11:11 2025-02-12-1111.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:11 2025-02-12-1110.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 531207 Feb 12 11:11 2025-02-12-1111.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 536428 Feb 12 11:11 2025-02-12-1111.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:12 2025-02-12-1111.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 534622 Feb 12 11:12 2025-02-12-1111.stir_pools.25.txt
-rw-r--r-- 1 hbarta hbarta  18905 Feb 12 11:12 2025-02-12-1112.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:12 2025-02-12-1112.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 532096 Feb 12 11:13 2025-02-12-1112.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:13 2025-02-12-1112.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18966 Feb 12 11:14 2025-02-12-1113.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 535208 Feb 12 11:14 2025-02-12-1113.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:14 2025-02-12-1113.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 535715 Feb 12 11:14 2025-02-12-1114.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:14 2025-02-12-1114.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 541661 Feb 12 11:15 2025-02-12-1114.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18849 Feb 12 11:15 2025-02-12-1115.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 534793 Feb 12 11:15 2025-02-12-1115.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:15 2025-02-12-1114.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 536040 Feb 12 11:16 2025-02-12-1115.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:16 2025-02-12-1115.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18106 Feb 12 11:16 2025-02-12-1116.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 537229 Feb 12 11:16 2025-02-12-1116.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:17 2025-02-12-1116.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 537229 Feb 12 11:17 2025-02-12-1116.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 532779 Feb 12 11:17 2025-02-12-1117.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  17634 Feb 12 11:18 2025-02-12-1117.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 533093 Feb 12 11:18 2025-02-12-1117.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:18 2025-02-12-1117.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 536030 Feb 12 11:18 2025-02-12-1118.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 523119 Feb 12 11:19 2025-02-12-1118.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:19 2025-02-12-1118.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta  18935 Feb 12 11:19 2025-02-12-1119.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 532642 Feb 12 11:19 2025-02-12-1119.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:20 2025-02-12-1119.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 532864 Feb 12 11:20 2025-02-12-1119.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:20 2025-02-12-1120.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  19098 Feb 12 11:20 2025-02-12-1120.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 537657 Feb 12 11:21 2025-02-12-1120.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:21 2025-02-12-1120.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 528769 Feb 12 11:21 2025-02-12-1121.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 541443 Feb 12 11:22 2025-02-12-1121.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta  18300 Feb 12 11:22 2025-02-12-1121.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:22 2025-02-12-1121.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 529381 Feb 12 11:22 2025-02-12-1122.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:22 2025-02-12-1122.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 527969 Feb 12 11:23 2025-02-12-1122.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18900 Feb 12 11:23 2025-02-12-1123.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:23 2025-02-12-1122.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 529811 Feb 12 11:23 2025-02-12-1123.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:24 2025-02-12-1123.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 532431 Feb 12 11:24 2025-02-12-1123.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta 538586 Feb 12 11:24 2025-02-12-1124.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta  18354 Feb 12 11:24 2025-02-12-1124.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 533427 Feb 12 11:25 2025-02-12-1124.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:25 2025-02-12-1124.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 531723 Feb 12 11:26 2025-02-12-1125.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18773 Feb 12 11:26 2025-02-12-1125.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:26 2025-02-12-1125.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 542081 Feb 12 11:26 2025-02-12-1126.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 528953 Feb 12 11:27 2025-02-12-1126.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:27 2025-02-12-1126.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 530821 Feb 12 11:27 2025-02-12-1127.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18793 Feb 12 11:27 2025-02-12-1127.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:27 2025-02-12-1127.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 533207 Feb 12 11:27 2025-02-12-1127.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 536891 Feb 12 11:28 2025-02-12-1127.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:28 2025-02-12-1127.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18844 Feb 12 11:28 2025-02-12-1128.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 532912 Feb 12 11:28 2025-02-12-1128.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:29 2025-02-12-1128.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 532229 Feb 12 11:29 2025-02-12-1128.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 534255 Feb 12 11:29 2025-02-12-1129.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18661 Feb 12 11:30 2025-02-12-1129.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 534930 Feb 12 11:30 2025-02-12-1129.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:30 2025-02-12-1129.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 530702 Feb 12 11:30 2025-02-12-1130.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 528206 Feb 12 11:31 2025-02-12-1130.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:31 2025-02-12-1130.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18334 Feb 12 11:31 2025-02-12-1131.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 533997 Feb 12 11:31 2025-02-12-1131.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:32 2025-02-12-1131.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 535867 Feb 12 11:32 2025-02-12-1131.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:32 2025-02-12-1132.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18076 Feb 12 11:32 2025-02-12-1132.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 532198 Feb 12 11:33 2025-02-12-1132.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:33 2025-02-12-1132.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 530232 Feb 12 11:33 2025-02-12-1133.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:34 2025-02-12-1133.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18295 Feb 12 11:34 2025-02-12-1133.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 534244 Feb 12 11:34 2025-02-12-1133.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:34 2025-02-12-1134.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 536294 Feb 12 11:34 2025-02-12-1134.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta 533850 Feb 12 11:35 2025-02-12-1134.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  19007 Feb 12 11:35 2025-02-12-1135.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:35 2025-02-12-1134.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 531726 Feb 12 11:36 2025-02-12-1135.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:36 2025-02-12-1135.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 534990 Feb 12 11:36 2025-02-12-1136.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18959 Feb 12 11:36 2025-02-12-1136.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 535064 Feb 12 11:37 2025-02-12-1136.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 533555 Feb 12 11:37 2025-02-12-1137.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:37 2025-02-12-1136.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 534901 Feb 12 11:38 2025-02-12-1137.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18422 Feb 12 11:38 2025-02-12-1137.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:38 2025-02-12-1137.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 529489 Feb 12 11:38 2025-02-12-1138.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:39 2025-02-12-1138.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 535027 Feb 12 11:39 2025-02-12-1138.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18595 Feb 12 11:39 2025-02-12-1139.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:39 2025-02-12-1139.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 537720 Feb 12 11:39 2025-02-12-1139.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 532928 Feb 12 11:40 2025-02-12-1139.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:40 2025-02-12-1139.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta  18737 Feb 12 11:40 2025-02-12-1140.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:41 2025-02-12-1140.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 535057 Feb 12 11:41 2025-02-12-1140.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 538343 Feb 12 11:41 2025-02-12-1141.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:41 2025-02-12-1141.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 534936 Feb 12 11:42 2025-02-12-1141.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18905 Feb 12 11:42 2025-02-12-1141.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:42 2025-02-12-1141.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 537425 Feb 12 11:42 2025-02-12-1142.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 532260 Feb 12 11:43 2025-02-12-1142.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:43 2025-02-12-1142.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta  18783 Feb 12 11:43 2025-02-12-1143.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 530685 Feb 12 11:44 2025-02-12-1143.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:44 2025-02-12-1143.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18661 Feb 12 11:44 2025-02-12-1144.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 535608 Feb 12 11:44 2025-02-12-1144.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:45 2025-02-12-1144.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 530829 Feb 12 11:45 2025-02-12-1144.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:46 2025-02-12-1145.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18761 Feb 12 11:46 2025-02-12-1145.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 534397 Feb 12 11:46 2025-02-12-1145.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:46 2025-02-12-1146.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 531767 Feb 12 11:46 2025-02-12-1146.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta 527399 Feb 12 11:47 2025-02-12-1146.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:47 2025-02-12-1146.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18361 Feb 12 11:47 2025-02-12-1147.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:48 2025-02-12-1147.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 535441 Feb 12 11:48 2025-02-12-1147.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 531569 Feb 12 11:48 2025-02-12-1148.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:48 2025-02-12-1148.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18376 Feb 12 11:48 2025-02-12-1148.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 533722 Feb 12 11:49 2025-02-12-1148.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:49 2025-02-12-1148.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 534655 Feb 12 11:49 2025-02-12-1149.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 528231 Feb 12 11:50 2025-02-12-1149.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta  18585 Feb 12 11:50 2025-02-12-1149.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:50 2025-02-12-1149.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 538328 Feb 12 11:50 2025-02-12-1150.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:50 2025-02-12-1150.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 533210 Feb 12 11:51 2025-02-12-1150.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18112 Feb 12 11:51 2025-02-12-1151.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:51 2025-02-12-1150.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 534837 Feb 12 11:51 2025-02-12-1151.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 535704 Feb 12 11:52 2025-02-12-1151.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:52 2025-02-12-1151.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta  18727 Feb 12 11:52 2025-02-12-1152.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:53 2025-02-12-1152.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 538170 Feb 12 11:53 2025-02-12-1152.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 529127 Feb 12 11:53 2025-02-12-1153.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:53 2025-02-12-1153.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 535755 Feb 12 11:54 2025-02-12-1153.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18547 Feb 12 11:54 2025-02-12-1153.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:54 2025-02-12-1153.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 526136 Feb 12 11:55 2025-02-12-1154.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:55 2025-02-12-1154.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta  18839 Feb 12 11:55 2025-02-12-1155.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 533865 Feb 12 11:56 2025-02-12-1155.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 537014 Feb 12 11:56 2025-02-12-1156.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:56 2025-02-12-1155.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18788 Feb 12 11:56 2025-02-12-1156.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:57 2025-02-12-1156.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 536647 Feb 12 11:57 2025-02-12-1156.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:58 2025-02-12-1157.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 532478 Feb 12 11:58 2025-02-12-1157.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  19083 Feb 12 11:58 2025-02-12-1157.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 534607 Feb 12 11:58 2025-02-12-1158.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:58 2025-02-12-1158.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 545491 Feb 12 11:59 2025-02-12-1158.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 11:59 2025-02-12-1158.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  19047 Feb 12 11:59 2025-02-12-1159.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 537696 Feb 12 11:59 2025-02-12-1159.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 530114 Feb 12 12:00 2025-02-12-1159.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:00 2025-02-12-1159.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 536510 Feb 12 12:00 2025-02-12-1200.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:00 2025-02-12-1200.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta  19373 Feb 12 12:00 2025-02-12-1200.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 535046 Feb 12 12:01 2025-02-12-1200.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:01 2025-02-12-1200.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 538634 Feb 12 12:01 2025-02-12-1201.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  19022 Feb 12 12:02 2025-02-12-1201.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:02 2025-02-12-1201.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 533738 Feb 12 12:02 2025-02-12-1201.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 531740 Feb 12 12:02 2025-02-12-1202.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:03 2025-02-12-1202.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 534473 Feb 12 12:03 2025-02-12-1202.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18289 Feb 12 12:03 2025-02-12-1203.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:03 2025-02-12-1203.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 536312 Feb 12 12:03 2025-02-12-1203.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 528347 Feb 12 12:04 2025-02-12-1203.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:04 2025-02-12-1203.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  17761 Feb 12 12:04 2025-02-12-1204.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 533890 Feb 12 12:05 2025-02-12-1204.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:05 2025-02-12-1204.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:05 2025-02-12-1205.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 532130 Feb 12 12:06 2025-02-12-1205.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  17608 Feb 12 12:06 2025-02-12-1205.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 539462 Feb 12 12:06 2025-02-12-1206.stir_pools.30.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:06 2025-02-12-1205.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 538536 Feb 12 12:07 2025-02-12-1206.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:07 2025-02-12-1206.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  17944 Feb 12 12:07 2025-02-12-1207.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 532086 Feb 12 12:08 2025-02-12-1207.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:08 2025-02-12-1207.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:08 2025-02-12-1208.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18844 Feb 12 12:09 2025-02-12-1208.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 535653 Feb 12 12:09 2025-02-12-1208.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:09 2025-02-12-1208.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 537239 Feb 12 12:09 2025-02-12-1209.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:10 2025-02-12-1209.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 536985 Feb 12 12:10 2025-02-12-1209.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18930 Feb 12 12:10 2025-02-12-1210.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 530363 Feb 12 12:10 2025-02-12-1210.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta 533903 Feb 12 12:11 2025-02-12-1210.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:11 2025-02-12-1210.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  19312 Feb 12 12:11 2025-02-12-1211.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 522545 Feb 12 12:12 2025-02-12-1211.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:12 2025-02-12-1211.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:13 2025-02-12-1212.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 531123 Feb 12 12:13 2025-02-12-1212.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  19261 Feb 12 12:13 2025-02-12-1212.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:13 2025-02-12-1213.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 536079 Feb 12 12:13 2025-02-12-1213.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18966 Feb 12 12:14 2025-02-12-1214.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 538094 Feb 12 12:14 2025-02-12-1213.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:14 2025-02-12-1213.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 534933 Feb 12 12:14 2025-02-12-1214.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:15 2025-02-12-1214.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 535230 Feb 12 12:15 2025-02-12-1214.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18900 Feb 12 12:15 2025-02-12-1215.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 543222 Feb 12 12:15 2025-02-12-1215.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:15 2025-02-12-1215.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 534929 Feb 12 12:16 2025-02-12-1215.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:16 2025-02-12-1215.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18900 Feb 12 12:17 2025-02-12-1216.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 529061 Feb 12 12:17 2025-02-12-1216.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:17 2025-02-12-1216.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 539404 Feb 12 12:17 2025-02-12-1217.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 539120 Feb 12 12:18 2025-02-12-1217.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:18 2025-02-12-1217.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18890 Feb 12 12:18 2025-02-12-1218.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:18 2025-02-12-1218.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 535113 Feb 12 12:18 2025-02-12-1218.stir_pools.24.txt
-rw-r--r-- 1 hbarta hbarta 540526 Feb 12 12:19 2025-02-12-1218.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:19 2025-02-12-1218.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18961 Feb 12 12:19 2025-02-12-1219.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 536920 Feb 12 12:19 2025-02-12-1219.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:20 2025-02-12-1219.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 532028 Feb 12 12:20 2025-02-12-1219.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:20 2025-02-12-1220.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18686 Feb 12 12:21 2025-02-12-1220.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 528690 Feb 12 12:21 2025-02-12-1220.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:21 2025-02-12-1220.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 535804 Feb 12 12:21 2025-02-12-1221.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta 535613 Feb 12 12:22 2025-02-12-1221.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:22 2025-02-12-1221.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  19520 Feb 12 12:22 2025-02-12-1222.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 535575 Feb 12 12:23 2025-02-12-1222.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:23 2025-02-12-1222.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 532112 Feb 12 12:23 2025-02-12-1223.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:23 2025-02-12-1223.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18752 Feb 12 12:23 2025-02-12-1223.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 542592 Feb 12 12:24 2025-02-12-1223.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:24 2025-02-12-1223.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 537389 Feb 12 12:24 2025-02-12-1224.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18361 Feb 12 12:25 2025-02-12-1224.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:25 2025-02-12-1224.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 534796 Feb 12 12:25 2025-02-12-1224.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 536941 Feb 12 12:25 2025-02-12-1225.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:25 2025-02-12-1225.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 530292 Feb 12 12:26 2025-02-12-1225.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18066 Feb 12 12:26 2025-02-12-1226.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:26 2025-02-12-1225.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 530618 Feb 12 12:26 2025-02-12-1226.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 533436 Feb 12 12:27 2025-02-12-1226.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:27 2025-02-12-1226.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  17705 Feb 12 12:27 2025-02-12-1227.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:28 2025-02-12-1227.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 529696 Feb 12 12:28 2025-02-12-1227.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:28 2025-02-12-1228.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 539076 Feb 12 12:28 2025-02-12-1228.stir_pools.25.txt
-rw-r--r-- 1 hbarta hbarta  18737 Feb 12 12:29 2025-02-12-1228.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 532273 Feb 12 12:29 2025-02-12-1228.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:29 2025-02-12-1228.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 529696 Feb 12 12:29 2025-02-12-1229.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:30 2025-02-12-1229.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 534822 Feb 12 12:30 2025-02-12-1229.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18781 Feb 12 12:30 2025-02-12-1230.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 535322 Feb 12 12:30 2025-02-12-1230.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:30 2025-02-12-1230.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 530777 Feb 12 12:31 2025-02-12-1230.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:31 2025-02-12-1230.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 528549 Feb 12 12:31 2025-02-12-1231.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18671 Feb 12 12:31 2025-02-12-1231.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 532366 Feb 12 12:32 2025-02-12-1231.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:32 2025-02-12-1231.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 532769 Feb 12 12:32 2025-02-12-1232.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:33 2025-02-12-1232.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 533552 Feb 12 12:33 2025-02-12-1232.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18849 Feb 12 12:33 2025-02-12-1232.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 540819 Feb 12 12:33 2025-02-12-1233.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:33 2025-02-12-1233.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 535949 Feb 12 12:34 2025-02-12-1233.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:34 2025-02-12-1233.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 533045 Feb 12 12:34 2025-02-12-1234.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  19210 Feb 12 12:34 2025-02-12-1234.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:35 2025-02-12-1234.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 540288 Feb 12 12:35 2025-02-12-1234.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  19266 Feb 12 12:35 2025-02-12-1235.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 530249 Feb 12 12:36 2025-02-12-1235.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:36 2025-02-12-1235.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 534087 Feb 12 12:36 2025-02-12-1236.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  19017 Feb 12 12:37 2025-02-12-1236.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:37 2025-02-12-1236.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 534059 Feb 12 12:37 2025-02-12-1236.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 527374 Feb 12 12:37 2025-02-12-1237.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:37 2025-02-12-1237.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 529791 Feb 12 12:38 2025-02-12-1237.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18905 Feb 12 12:38 2025-02-12-1238.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 535445 Feb 12 12:38 2025-02-12-1238.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:38 2025-02-12-1237.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 532730 Feb 12 12:39 2025-02-12-1238.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:39 2025-02-12-1238.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18839 Feb 12 12:39 2025-02-12-1239.trim_snaps.19.txt
-rw-r--r-- 1 hbarta hbarta 534136 Feb 12 12:39 2025-02-12-1239.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:40 2025-02-12-1239.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 537120 Feb 12 12:40 2025-02-12-1239.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:40 2025-02-12-1240.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta  18050 Feb 12 12:41 2025-02-12-1240.trim_snaps.19.txt
-rw-r--r-- 1 hbarta hbarta 535629 Feb 12 12:41 2025-02-12-1240.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:41 2025-02-12-1240.syncoid.40.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:42 2025-02-12-1241.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 536440 Feb 12 12:42 2025-02-12-1241.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  16876 Feb 12 12:42 2025-02-12-1242.trim_snaps.19.txt
-rw-r--r-- 1 hbarta hbarta 530931 Feb 12 12:43 2025-02-12-1242.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:43 2025-02-12-1242.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18020 Feb 12 12:43 2025-02-12-1243.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 534907 Feb 12 12:44 2025-02-12-1243.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:44 2025-02-12-1243.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 530406 Feb 12 12:44 2025-02-12-1244.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:44 2025-02-12-1244.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 531747 Feb 12 12:45 2025-02-12-1244.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta  18778 Feb 12 12:45 2025-02-12-1244.trim_snaps.19.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:45 2025-02-12-1244.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 537555 Feb 12 12:45 2025-02-12-1245.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:46 2025-02-12-1245.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 531310 Feb 12 12:46 2025-02-12-1245.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18844 Feb 12 12:46 2025-02-12-1246.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 529882 Feb 12 12:46 2025-02-12-1246.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 536481 Feb 12 12:47 2025-02-12-1246.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:47 2025-02-12-1246.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta  18778 Feb 12 12:47 2025-02-12-1247.trim_snaps.19.txt
-rw-r--r-- 1 hbarta hbarta 533496 Feb 12 12:48 2025-02-12-1247.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:48 2025-02-12-1247.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:49 2025-02-12-1248.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18930 Feb 12 12:49 2025-02-12-1248.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 540909 Feb 12 12:49 2025-02-12-1248.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 535071 Feb 12 12:49 2025-02-12-1249.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:49 2025-02-12-1249.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 529685 Feb 12 12:50 2025-02-12-1249.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:50 2025-02-12-1249.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  19266 Feb 12 12:50 2025-02-12-1250.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 537137 Feb 12 12:50 2025-02-12-1250.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 535761 Feb 12 12:51 2025-02-12-1250.stir_pools.30.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:51 2025-02-12-1250.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 527015 Feb 12 12:51 2025-02-12-1251.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:51 2025-02-12-1251.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18162 Feb 12 12:51 2025-02-12-1251.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 521280 Feb 12 12:52 2025-02-12-1251.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 529022 Feb 12 12:52 2025-02-12-1252.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:52 2025-02-12-1251.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 538713 Feb 12 12:52 2025-02-12-1252.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18910 Feb 12 12:53 2025-02-12-1252.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:53 2025-02-12-1252.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 531020 Feb 12 12:53 2025-02-12-1252.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:53 2025-02-12-1253.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 542190 Feb 12 12:54 2025-02-12-1253.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  17878 Feb 12 12:54 2025-02-12-1254.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:54 2025-02-12-1253.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 533950 Feb 12 12:55 2025-02-12-1254.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:55 2025-02-12-1254.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 541936 Feb 12 12:55 2025-02-12-1255.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  17883 Feb 12 12:55 2025-02-12-1255.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:56 2025-02-12-1255.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 528141 Feb 12 12:56 2025-02-12-1255.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 531961 Feb 12 12:56 2025-02-12-1256.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:56 2025-02-12-1256.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 532200 Feb 12 12:57 2025-02-12-1256.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18254 Feb 12 12:57 2025-02-12-1256.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 535482 Feb 12 12:57 2025-02-12-1257.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:57 2025-02-12-1256.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:58 2025-02-12-1257.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 531590 Feb 12 12:58 2025-02-12-1257.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18849 Feb 12 12:58 2025-02-12-1258.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 531067 Feb 12 12:58 2025-02-12-1258.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 532925 Feb 12 12:59 2025-02-12-1258.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 12:59 2025-02-12-1258.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18839 Feb 12 12:59 2025-02-12-1259.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 534805 Feb 12 13:00 2025-02-12-1259.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:00 2025-02-12-1259.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 533419 Feb 12 13:00 2025-02-12-1300.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:01 2025-02-12-1300.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 538148 Feb 12 13:01 2025-02-12-1300.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  19164 Feb 12 13:01 2025-02-12-1300.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:01 2025-02-12-1301.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 536315 Feb 12 13:02 2025-02-12-1301.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:02 2025-02-12-1301.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  19322 Feb 12 13:02 2025-02-12-1302.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 525528 Feb 12 13:03 2025-02-12-1302.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:03 2025-02-12-1302.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 528353 Feb 12 13:03 2025-02-12-1303.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  19017 Feb 12 13:03 2025-02-12-1303.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:04 2025-02-12-1303.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 528376 Feb 12 13:04 2025-02-12-1303.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:04 2025-02-12-1304.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18727 Feb 12 13:05 2025-02-12-1304.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 533278 Feb 12 13:05 2025-02-12-1304.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:05 2025-02-12-1304.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 535140 Feb 12 13:05 2025-02-12-1305.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:06 2025-02-12-1305.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 537511 Feb 12 13:06 2025-02-12-1305.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18844 Feb 12 13:06 2025-02-12-1306.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 530462 Feb 12 13:06 2025-02-12-1306.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:06 2025-02-12-1306.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 540889 Feb 12 13:07 2025-02-12-1306.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:07 2025-02-12-1306.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 538184 Feb 12 13:07 2025-02-12-1307.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18711 Feb 12 13:08 2025-02-12-1307.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 540942 Feb 12 13:08 2025-02-12-1307.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:08 2025-02-12-1307.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:09 2025-02-12-1308.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 530914 Feb 12 13:09 2025-02-12-1308.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  17934 Feb 12 13:09 2025-02-12-1309.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 529527 Feb 12 13:09 2025-02-12-1309.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 534729 Feb 12 13:10 2025-02-12-1309.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:10 2025-02-12-1309.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  17868 Feb 12 13:10 2025-02-12-1310.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:11 2025-02-12-1310.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 536563 Feb 12 13:11 2025-02-12-1310.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 530981 Feb 12 13:11 2025-02-12-1311.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:11 2025-02-12-1311.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  17826 Feb 12 13:12 2025-02-12-1311.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 524066 Feb 12 13:12 2025-02-12-1311.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:12 2025-02-12-1311.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 532326 Feb 12 13:12 2025-02-12-1312.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 529230 Feb 12 13:13 2025-02-12-1312.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:13 2025-02-12-1312.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  19200 Feb 12 13:13 2025-02-12-1313.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 538909 Feb 12 13:13 2025-02-12-1313.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:14 2025-02-12-1313.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 533651 Feb 12 13:14 2025-02-12-1313.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  19317 Feb 12 13:14 2025-02-12-1314.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:14 2025-02-12-1314.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 537899 Feb 12 13:15 2025-02-12-1314.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:15 2025-02-12-1314.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 539508 Feb 12 13:15 2025-02-12-1315.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18829 Feb 12 13:16 2025-02-12-1315.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:16 2025-02-12-1315.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 533196 Feb 12 13:16 2025-02-12-1315.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 528977 Feb 12 13:16 2025-02-12-1316.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:16 2025-02-12-1316.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 538460 Feb 12 13:17 2025-02-12-1316.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18661 Feb 12 13:17 2025-02-12-1317.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:17 2025-02-12-1316.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 532023 Feb 12 13:17 2025-02-12-1317.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 534939 Feb 12 13:18 2025-02-12-1317.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:18 2025-02-12-1317.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 530086 Feb 12 13:18 2025-02-12-1318.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18610 Feb 12 13:18 2025-02-12-1318.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:19 2025-02-12-1318.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 535343 Feb 12 13:19 2025-02-12-1318.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta 534783 Feb 12 13:19 2025-02-12-1319.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:19 2025-02-12-1319.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 532771 Feb 12 13:20 2025-02-12-1319.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta  18844 Feb 12 13:20 2025-02-12-1319.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:20 2025-02-12-1319.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:21 2025-02-12-1320.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta  18961 Feb 12 13:21 2025-02-12-1321.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 533660 Feb 12 13:21 2025-02-12-1320.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:21 2025-02-12-1321.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 537677 Feb 12 13:22 2025-02-12-1321.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:22 2025-02-12-1321.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18930 Feb 12 13:22 2025-02-12-1322.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 527486 Feb 12 13:22 2025-02-12-1322.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 536395 Feb 12 13:23 2025-02-12-1322.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:23 2025-02-12-1322.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 532611 Feb 12 13:23 2025-02-12-1323.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:24 2025-02-12-1323.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta  19322 Feb 12 13:24 2025-02-12-1323.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 528260 Feb 12 13:24 2025-02-12-1323.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:24 2025-02-12-1324.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 531287 Feb 12 13:25 2025-02-12-1324.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18884 Feb 12 13:25 2025-02-12-1325.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:25 2025-02-12-1324.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 537375 Feb 12 13:26 2025-02-12-1325.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:26 2025-02-12-1325.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 530039 Feb 12 13:26 2025-02-12-1326.stir_pools.25.txt
-rw-r--r-- 1 hbarta hbarta  18641 Feb 12 13:26 2025-02-12-1326.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:26 2025-02-12-1326.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 538363 Feb 12 13:26 2025-02-12-1326.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 533909 Feb 12 13:27 2025-02-12-1326.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:27 2025-02-12-1326.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 534372 Feb 12 13:27 2025-02-12-1327.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18432 Feb 12 13:28 2025-02-12-1327.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:28 2025-02-12-1327.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 536334 Feb 12 13:28 2025-02-12-1327.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:29 2025-02-12-1328.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 534104 Feb 12 13:29 2025-02-12-1328.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18249 Feb 12 13:29 2025-02-12-1329.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 540904 Feb 12 13:29 2025-02-12-1329.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:29 2025-02-12-1329.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 539111 Feb 12 13:30 2025-02-12-1329.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:30 2025-02-12-1329.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 534776 Feb 12 13:30 2025-02-12-1330.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  17547 Feb 12 13:30 2025-02-12-1330.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 535914 Feb 12 13:31 2025-02-12-1330.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:31 2025-02-12-1330.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 537858 Feb 12 13:31 2025-02-12-1331.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta 529669 Feb 12 13:31 2025-02-12-1331.stir_pools.25.txt
-rw-r--r-- 1 hbarta hbarta  19012 Feb 12 13:32 2025-02-12-1331.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 536274 Feb 12 13:32 2025-02-12-1331.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:32 2025-02-12-1331.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 532647 Feb 12 13:32 2025-02-12-1332.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:33 2025-02-12-1332.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 531310 Feb 12 13:33 2025-02-12-1332.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta  18188 Feb 12 13:33 2025-02-12-1333.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:34 2025-02-12-1333.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 530594 Feb 12 13:34 2025-02-12-1333.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  19225 Feb 12 13:34 2025-02-12-1334.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 534348 Feb 12 13:35 2025-02-12-1334.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:35 2025-02-12-1334.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 526059 Feb 12 13:35 2025-02-12-1335.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 532454 Feb 12 13:36 2025-02-12-1335.stir_pools.25.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:36 2025-02-12-1335.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  19683 Feb 12 13:36 2025-02-12-1335.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 531814 Feb 12 13:36 2025-02-12-1336.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:36 2025-02-12-1336.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 537937 Feb 12 13:37 2025-02-12-1336.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta  18900 Feb 12 13:37 2025-02-12-1337.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:37 2025-02-12-1336.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 526273 Feb 12 13:37 2025-02-12-1337.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:38 2025-02-12-1337.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 531522 Feb 12 13:38 2025-02-12-1337.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18773 Feb 12 13:38 2025-02-12-1338.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 537723 Feb 12 13:39 2025-02-12-1338.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:39 2025-02-12-1338.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 534227 Feb 12 13:39 2025-02-12-1339.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18549 Feb 12 13:40 2025-02-12-1339.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 535995 Feb 12 13:40 2025-02-12-1339.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:40 2025-02-12-1339.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 536180 Feb 12 13:40 2025-02-12-1340.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:41 2025-02-12-1340.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 533535 Feb 12 13:41 2025-02-12-1340.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18966 Feb 12 13:41 2025-02-12-1341.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:41 2025-02-12-1341.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 536169 Feb 12 13:42 2025-02-12-1341.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:42 2025-02-12-1341.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18732 Feb 12 13:42 2025-02-12-1342.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 532117 Feb 12 13:43 2025-02-12-1342.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:43 2025-02-12-1342.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 534585 Feb 12 13:43 2025-02-12-1343.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:43 2025-02-12-1343.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18462 Feb 12 13:44 2025-02-12-1343.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 531899 Feb 12 13:44 2025-02-12-1343.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:44 2025-02-12-1343.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 537272 Feb 12 13:45 2025-02-12-1344.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:45 2025-02-12-1344.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18158 Feb 12 13:45 2025-02-12-1345.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 531387 Feb 12 13:45 2025-02-12-1345.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:46 2025-02-12-1345.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 535321 Feb 12 13:46 2025-02-12-1345.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  17664 Feb 12 13:46 2025-02-12-1346.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 540899 Feb 12 13:47 2025-02-12-1346.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:47 2025-02-12-1346.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 535583 Feb 12 13:47 2025-02-12-1347.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 534620 Feb 12 13:48 2025-02-12-1347.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:48 2025-02-12-1347.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18045 Feb 12 13:48 2025-02-12-1347.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 532840 Feb 12 13:49 2025-02-12-1348.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:49 2025-02-12-1348.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  19444 Feb 12 13:49 2025-02-12-1349.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 534643 Feb 12 13:49 2025-02-12-1349.stir_pools.25.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:50 2025-02-12-1349.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 524729 Feb 12 13:50 2025-02-12-1349.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 527602 Feb 12 13:50 2025-02-12-1350.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  19256 Feb 12 13:50 2025-02-12-1350.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:51 2025-02-12-1350.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 532077 Feb 12 13:51 2025-02-12-1350.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:51 2025-02-12-1351.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 533875 Feb 12 13:51 2025-02-12-1351.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta 532861 Feb 12 13:52 2025-02-12-1351.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18605 Feb 12 13:52 2025-02-12-1351.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:52 2025-02-12-1351.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 539096 Feb 12 13:53 2025-02-12-1352.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:53 2025-02-12-1352.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 526014 Feb 12 13:53 2025-02-12-1353.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18702 Feb 12 13:53 2025-02-12-1353.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 539259 Feb 12 13:54 2025-02-12-1353.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta 533688 Feb 12 13:54 2025-02-12-1354.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:54 2025-02-12-1353.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 532837 Feb 12 13:54 2025-02-12-1354.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18671 Feb 12 13:55 2025-02-12-1354.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:55 2025-02-12-1354.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 535706 Feb 12 13:55 2025-02-12-1355.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:56 2025-02-12-1355.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18895 Feb 12 13:56 2025-02-12-1356.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 534559 Feb 12 13:56 2025-02-12-1355.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 535074 Feb 12 13:57 2025-02-12-1356.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:57 2025-02-12-1356.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18671 Feb 12 13:57 2025-02-12-1357.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:58 2025-02-12-1357.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 526398 Feb 12 13:58 2025-02-12-1357.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18711 Feb 12 13:59 2025-02-12-1358.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 538302 Feb 12 13:59 2025-02-12-1358.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 13:59 2025-02-12-1358.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 537228 Feb 12 13:59 2025-02-12-1359.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 529343 Feb 12 14:00 2025-02-12-1359.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:00 2025-02-12-1359.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  19240 Feb 12 14:00 2025-02-12-1400.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 540113 Feb 12 14:00 2025-02-12-1400.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:01 2025-02-12-1400.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  17878 Feb 12 14:01 2025-02-12-1401.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:01 2025-02-12-1401.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 538081 Feb 12 14:02 2025-02-12-1401.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:02 2025-02-12-1401.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  17639 Feb 12 14:03 2025-02-12-1402.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:03 2025-02-12-1402.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 534009 Feb 12 14:03 2025-02-12-1402.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 533485 Feb 12 14:03 2025-02-12-1403.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:03 2025-02-12-1403.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 534443 Feb 12 14:04 2025-02-12-1403.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18300 Feb 12 14:04 2025-02-12-1404.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:04 2025-02-12-1403.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 531403 Feb 12 14:04 2025-02-12-1404.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 521838 Feb 12 14:05 2025-02-12-1404.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:05 2025-02-12-1404.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 538382 Feb 12 14:05 2025-02-12-1405.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta  18676 Feb 12 14:05 2025-02-12-1405.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:06 2025-02-12-1405.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 534376 Feb 12 14:06 2025-02-12-1405.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 530093 Feb 12 14:07 2025-02-12-1406.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18839 Feb 12 14:07 2025-02-12-1406.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:07 2025-02-12-1406.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 531875 Feb 12 14:07 2025-02-12-1407.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:08 2025-02-12-1407.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 538518 Feb 12 14:08 2025-02-12-1407.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18905 Feb 12 14:08 2025-02-12-1408.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 537967 Feb 12 14:08 2025-02-12-1408.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:08 2025-02-12-1408.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 543117 Feb 12 14:09 2025-02-12-1408.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:09 2025-02-12-1408.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 534949 Feb 12 14:09 2025-02-12-1409.stir_pools.25.txt
-rw-r--r-- 1 hbarta hbarta  18905 Feb 12 14:09 2025-02-12-1409.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 536419 Feb 12 14:10 2025-02-12-1409.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:10 2025-02-12-1409.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 535809 Feb 12 14:10 2025-02-12-1410.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:10 2025-02-12-1410.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 535436 Feb 12 14:11 2025-02-12-1410.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  19276 Feb 12 14:11 2025-02-12-1410.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 535757 Feb 12 14:11 2025-02-12-1411.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:11 2025-02-12-1410.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 534740 Feb 12 14:12 2025-02-12-1411.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:12 2025-02-12-1411.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  19144 Feb 12 14:12 2025-02-12-1412.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 540970 Feb 12 14:12 2025-02-12-1412.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:13 2025-02-12-1412.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 531831 Feb 12 14:13 2025-02-12-1412.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:13 2025-02-12-1413.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta  19205 Feb 12 14:13 2025-02-12-1413.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 531387 Feb 12 14:14 2025-02-12-1413.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:14 2025-02-12-1413.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta  18717 Feb 12 14:15 2025-02-12-1414.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:15 2025-02-12-1414.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 541856 Feb 12 14:15 2025-02-12-1414.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 534086 Feb 12 14:15 2025-02-12-1415.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:15 2025-02-12-1415.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 528107 Feb 12 14:16 2025-02-12-1415.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18528 Feb 12 14:16 2025-02-12-1416.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:16 2025-02-12-1415.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 538107 Feb 12 14:17 2025-02-12-1416.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:17 2025-02-12-1416.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 530079 Feb 12 14:17 2025-02-12-1417.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  17410 Feb 12 14:17 2025-02-12-1417.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 536424 Feb 12 14:18 2025-02-12-1417.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:18 2025-02-12-1417.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 534616 Feb 12 14:18 2025-02-12-1418.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:18 2025-02-12-1418.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  17776 Feb 12 14:19 2025-02-12-1418.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 538746 Feb 12 14:19 2025-02-12-1418.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:19 2025-02-12-1418.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 536071 Feb 12 14:19 2025-02-12-1419.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:20 2025-02-12-1419.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 532714 Feb 12 14:20 2025-02-12-1419.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18132 Feb 12 14:20 2025-02-12-1420.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:20 2025-02-12-1420.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 535741 Feb 12 14:21 2025-02-12-1420.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:21 2025-02-12-1420.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 527245 Feb 12 14:21 2025-02-12-1421.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta  19007 Feb 12 14:21 2025-02-12-1421.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 533390 Feb 12 14:22 2025-02-12-1421.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:22 2025-02-12-1421.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 537913 Feb 12 14:22 2025-02-12-1422.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 540185 Feb 12 14:23 2025-02-12-1422.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:23 2025-02-12-1422.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  19174 Feb 12 14:23 2025-02-12-1422.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 535845 Feb 12 14:23 2025-02-12-1423.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta 534810 Feb 12 14:23 2025-02-12-1423.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 541614 Feb 12 14:24 2025-02-12-1423.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:24 2025-02-12-1423.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  19322 Feb 12 14:24 2025-02-12-1424.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 536508 Feb 12 14:24 2025-02-12-1424.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:25 2025-02-12-1424.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 536376 Feb 12 14:25 2025-02-12-1424.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 529854 Feb 12 14:25 2025-02-12-1425.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  19495 Feb 12 14:25 2025-02-12-1425.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:25 2025-02-12-1425.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 532629 Feb 12 14:26 2025-02-12-1425.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:26 2025-02-12-1425.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 531430 Feb 12 14:26 2025-02-12-1426.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 534866 Feb 12 14:27 2025-02-12-1426.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18557 Feb 12 14:27 2025-02-12-1426.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:27 2025-02-12-1426.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 528418 Feb 12 14:28 2025-02-12-1427.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:28 2025-02-12-1427.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18692 Feb 12 14:28 2025-02-12-1428.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:28 2025-02-12-1428.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 537918 Feb 12 14:28 2025-02-12-1428.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 536411 Feb 12 14:29 2025-02-12-1428.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:29 2025-02-12-1428.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 533046 Feb 12 14:29 2025-02-12-1429.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18854 Feb 12 14:29 2025-02-12-1429.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:30 2025-02-12-1429.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 531557 Feb 12 14:30 2025-02-12-1429.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 530223 Feb 12 14:30 2025-02-12-1430.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:30 2025-02-12-1430.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 533726 Feb 12 14:31 2025-02-12-1430.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18844 Feb 12 14:31 2025-02-12-1430.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:31 2025-02-12-1430.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 536063 Feb 12 14:32 2025-02-12-1431.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:32 2025-02-12-1431.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18900 Feb 12 14:32 2025-02-12-1432.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 532353 Feb 12 14:32 2025-02-12-1432.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 537308 Feb 12 14:33 2025-02-12-1432.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:33 2025-02-12-1432.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:33 2025-02-12-1433.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  19047 Feb 12 14:33 2025-02-12-1433.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 534720 Feb 12 14:34 2025-02-12-1433.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 534798 Feb 12 14:34 2025-02-12-1434.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:34 2025-02-12-1433.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:35 2025-02-12-1434.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta  19266 Feb 12 14:35 2025-02-12-1434.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 537751 Feb 12 14:35 2025-02-12-1434.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:35 2025-02-12-1435.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 529226 Feb 12 14:36 2025-02-12-1435.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:36 2025-02-12-1435.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18528 Feb 12 14:36 2025-02-12-1436.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 535701 Feb 12 14:36 2025-02-12-1436.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 533914 Feb 12 14:37 2025-02-12-1436.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:37 2025-02-12-1436.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 536997 Feb 12 14:37 2025-02-12-1437.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  17715 Feb 12 14:38 2025-02-12-1437.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:38 2025-02-12-1437.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 537901 Feb 12 14:38 2025-02-12-1437.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 533586 Feb 12 14:38 2025-02-12-1438.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:38 2025-02-12-1438.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 534388 Feb 12 14:39 2025-02-12-1438.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18102 Feb 12 14:39 2025-02-12-1439.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:39 2025-02-12-1438.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 535257 Feb 12 14:40 2025-02-12-1439.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:40 2025-02-12-1439.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  17944 Feb 12 14:40 2025-02-12-1440.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:40 2025-02-12-1440.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 537880 Feb 12 14:40 2025-02-12-1440.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 537979 Feb 12 14:41 2025-02-12-1440.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:41 2025-02-12-1440.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 529339 Feb 12 14:41 2025-02-12-1441.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18737 Feb 12 14:42 2025-02-12-1441.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:42 2025-02-12-1441.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 538348 Feb 12 14:42 2025-02-12-1441.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 526557 Feb 12 14:42 2025-02-12-1442.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:43 2025-02-12-1442.syncoid.41.txt
-rw-r--r-- 1 hbarta hbarta 534427 Feb 12 14:43 2025-02-12-1442.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18834 Feb 12 14:43 2025-02-12-1443.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 530871 Feb 12 14:43 2025-02-12-1443.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 536307 Feb 12 14:44 2025-02-12-1443.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:44 2025-02-12-1443.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 537432 Feb 12 14:44 2025-02-12-1444.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18859 Feb 12 14:44 2025-02-12-1444.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 542774 Feb 12 14:45 2025-02-12-1444.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:45 2025-02-12-1444.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 534445 Feb 12 14:45 2025-02-12-1445.stir_pools.25.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:45 2025-02-12-1445.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 540805 Feb 12 14:45 2025-02-12-1445.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  19098 Feb 12 14:46 2025-02-12-1445.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 538177 Feb 12 14:46 2025-02-12-1445.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:46 2025-02-12-1445.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 539594 Feb 12 14:46 2025-02-12-1446.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:47 2025-02-12-1446.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 519569 Feb 12 14:47 2025-02-12-1446.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  19144 Feb 12 14:47 2025-02-12-1447.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 531291 Feb 12 14:47 2025-02-12-1447.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:48 2025-02-12-1447.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 532235 Feb 12 14:48 2025-02-12-1447.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 537913 Feb 12 14:48 2025-02-12-1448.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta  19200 Feb 12 14:48 2025-02-12-1448.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 528692 Feb 12 14:49 2025-02-12-1448.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:49 2025-02-12-1448.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 534132 Feb 12 14:49 2025-02-12-1449.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18966 Feb 12 14:50 2025-02-12-1449.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 534814 Feb 12 14:50 2025-02-12-1449.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:50 2025-02-12-1449.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 532770 Feb 12 14:50 2025-02-12-1450.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:50 2025-02-12-1450.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 532042 Feb 12 14:51 2025-02-12-1450.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18900 Feb 12 14:51 2025-02-12-1451.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:51 2025-02-12-1450.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:52 2025-02-12-1451.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 536807 Feb 12 14:52 2025-02-12-1451.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  18844 Feb 12 14:52 2025-02-12-1452.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:53 2025-02-12-1452.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 536022 Feb 12 14:53 2025-02-12-1452.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:53 2025-02-12-1453.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 532973 Feb 12 14:53 2025-02-12-1453.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18172 Feb 12 14:54 2025-02-12-1453.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 541545 Feb 12 14:54 2025-02-12-1453.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:54 2025-02-12-1453.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:55 2025-02-12-1454.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 533302 Feb 12 14:55 2025-02-12-1454.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18010 Feb 12 14:55 2025-02-12-1455.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 534583 Feb 12 14:55 2025-02-12-1455.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:55 2025-02-12-1455.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 537858 Feb 12 14:56 2025-02-12-1455.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta 535869 Feb 12 14:56 2025-02-12-1456.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:56 2025-02-12-1455.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta  18285 Feb 12 14:56 2025-02-12-1456.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 533348 Feb 12 14:57 2025-02-12-1456.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:57 2025-02-12-1456.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 535615 Feb 12 14:57 2025-02-12-1457.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:58 2025-02-12-1457.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18355 Feb 12 14:58 2025-02-12-1457.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta 534093 Feb 12 14:58 2025-02-12-1457.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 532954 Feb 12 14:59 2025-02-12-1458.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 14:59 2025-02-12-1458.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  18839 Feb 12 14:59 2025-02-12-1459.trim_snaps.20.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 15:00 2025-02-12-1459.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 535091 Feb 12 15:00 2025-02-12-1459.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 530259 Feb 12 15:00 2025-02-12-1500.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  19317 Feb 12 15:00 2025-02-12-1500.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 533073 Feb 12 15:01 2025-02-12-1500.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 15:01 2025-02-12-1500.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 544327 Feb 12 15:02 2025-02-12-1501.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18722 Feb 12 15:02 2025-02-12-1501.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 15:02 2025-02-12-1501.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 539802 Feb 12 15:02 2025-02-12-1502.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta 533100 Feb 12 15:03 2025-02-12-1502.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 15:03 2025-02-12-1502.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 535877 Feb 12 15:03 2025-02-12-1503.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta  18463 Feb 12 15:03 2025-02-12-1503.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 15:03 2025-02-12-1503.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 527413 Feb 12 15:04 2025-02-12-1503.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 15:04 2025-02-12-1503.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta 526025 Feb 12 15:04 2025-02-12-1504.stir_pools.24.txt
-rw-r--r-- 1 hbarta hbarta  18854 Feb 12 15:04 2025-02-12-1504.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 15:05 2025-02-12-1504.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 531791 Feb 12 15:05 2025-02-12-1504.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 15:05 2025-02-12-1505.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 530131 Feb 12 15:06 2025-02-12-1505.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta  19022 Feb 12 15:06 2025-02-12-1505.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 15:06 2025-02-12-1505.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 531149 Feb 12 15:06 2025-02-12-1506.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta 534548 Feb 12 15:07 2025-02-12-1506.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 15:07 2025-02-12-1506.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta 529904 Feb 12 15:07 2025-02-12-1507.stir_pools.26.txt
-rw-r--r-- 1 hbarta hbarta  18783 Feb 12 15:07 2025-02-12-1507.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 528966 Feb 12 15:08 2025-02-12-1507.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 15:08 2025-02-12-1507.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 15:08 2025-02-12-1508.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta  19169 Feb 12 15:08 2025-02-12-1508.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 531664 Feb 12 15:09 2025-02-12-1508.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 15:09 2025-02-12-1508.syncoid.42.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 15:10 2025-02-12-1509.syncoid.44.txt
-rw-r--r-- 1 hbarta hbarta  19190 Feb 12 15:10 2025-02-12-1509.trim_snaps.21.txt
-rw-r--r-- 1 hbarta hbarta 527350 Feb 12 15:10 2025-02-12-1509.stir_pools.27.txt
-rw-r--r-- 1 hbarta hbarta 540933 Feb 12 15:10 2025-02-12-1510.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   7862 Feb 12 15:10 2025-02-12-1510.syncoid.43.txt
-rw-r--r-- 1 hbarta hbarta 526555 Feb 12 15:11 2025-02-12-1510.stir_pools.38.txt
-rw-r--r-- 1 hbarta hbarta  15650 Feb 12 15:11 2025-02-12-1511.trim_snaps.34.txt
-rw-r--r-- 1 hbarta hbarta  10671 Feb 12 15:11 2025-02-12-1510.syncoid.60.txt
-rw-r--r-- 1 hbarta hbarta     48 Feb 12 15:11 halt_test.txt
hbarta@orcus:~/logs$ 
```

## 2025-02-12 suncoid run that produced corruption

```text
hbarta@orcus:~/logs$ cat 2025-02-12-1510.syncoid.60.txt
INFO: Sending incremental send/test@syncoid_orcus_2025-02-12:15:10:15-GMT-06:00 ... syncoid_orcus_2025-02-12:15:10:57-GMT-06:00 to recv/test (~ 4 KB):
INFO: Sending incremental send/test/l0_0@syncoid_orcus_2025-02-12:15:10:16-GMT-06:00 ... syncoid_orcus_2025-02-12:15:10:58-GMT-06:00 to recv/test/l0_0 (~ 4 KB):
INFO: Sending incremental send/test/l0_0/l1_0@syncoid_orcus_2025-02-12:15:10:17-GMT-06:00 ... syncoid_orcus_2025-02-12:15:10:59-GMT-06:00 to recv/test/l0_0/l1_0 (~ 4 KB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_orcus_2025-02-12:15:10:18-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:00-GMT-06:00 to recv/test/l0_0/l1_0/l2_0 (~ 4 KB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_orcus_2025-02-12:15:10:19-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:01-GMT-06:00 to recv/test/l0_0/l1_0/l2_1 (~ 4 KB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_orcus_2025-02-12:15:10:20-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:02-GMT-06:00 to recv/test/l0_0/l1_0/l2_2 (~ 4 KB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_orcus_2025-02-12:15:10:21-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:03-GMT-06:00 to recv/test/l0_0/l1_0/l2_3 (~ 4 KB):
INFO: Sending incremental send/test/l0_0/l1_1@syncoid_orcus_2025-02-12:15:10:22-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:04-GMT-06:00 to recv/test/l0_0/l1_1 (~ 4 KB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_orcus_2025-02-12:15:10:23-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:05-GMT-06:00 to recv/test/l0_0/l1_1/l2_0 (~ 4 KB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_orcus_2025-02-12:15:10:24-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:06-GMT-06:00 to recv/test/l0_0/l1_1/l2_1 (~ 4 KB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orcus_2025-02-12:15:10:25-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:07-GMT-06:00 to recv/test/l0_0/l1_1/l2_2 (~ 4 KB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orcus_2025-02-12:15:10:26-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:08-GMT-06:00 to recv/test/l0_0/l1_1/l2_3 (~ 4 KB):
INFO: Sending incremental send/test/l0_0/l1_2@syncoid_orcus_2025-02-12:15:10:27-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:09-GMT-06:00 to recv/test/l0_0/l1_2 (~ 4 KB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_orcus_2025-02-12:15:10:28-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:10-GMT-06:00 to recv/test/l0_0/l1_2/l2_0 (~ 4 KB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_orcus_2025-02-12:15:10:29-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:11-GMT-06:00 to recv/test/l0_0/l1_2/l2_1 (~ 1.7 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_orcus_2025-02-12:15:10:30-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:13-GMT-06:00 to recv/test/l0_0/l1_2/l2_2 (~ 1.8 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_orcus_2025-02-12:15:10:31-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:15-GMT-06:00 to recv/test/l0_0/l1_2/l2_3 (~ 1.8 MB):
INFO: Sending incremental send/test/l0_0/l1_3@syncoid_orcus_2025-02-12:15:10:32-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:16-GMT-06:00 to recv/test/l0_0/l1_3 (~ 1.7 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_orcus_2025-02-12:15:10:33-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:18-GMT-06:00 to recv/test/l0_0/l1_3/l2_0 (~ 1.7 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_orcus_2025-02-12:15:10:34-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:20-GMT-06:00 to recv/test/l0_0/l1_3/l2_1 (~ 1.7 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_orcus_2025-02-12:15:10:35-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:21-GMT-06:00 to recv/test/l0_0/l1_3/l2_2 (~ 1.7 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_orcus_2025-02-12:15:10:36-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:23-GMT-06:00 to recv/test/l0_0/l1_3/l2_3 (~ 1.7 MB):
internal error: warning: cannot send 'send/test/l0_0/l1_3/l2_3@syncoid_orcus_2025-02-12:15:11:23-GMT-06:00': Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_3'@'syncoid_orcus_2025-02-12:15:10:36-GMT-06:00' 'send/test/l0_0/l1_3/l2_3'@'syncoid_orcus_2025-02-12:15:11:23-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 1802808 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_3' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1@syncoid_orcus_2025-02-12:15:10:37-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:24-GMT-06:00 to recv/test/l0_1 (~ 8.2 MB):
INFO: Sending incremental send/test/l0_1/l1_0@syncoid_orcus_2025-02-12:15:10:38-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:26-GMT-06:00 to recv/test/l0_1/l1_0 (~ 22.4 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_orcus_2025-02-12:15:10:39-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:28-GMT-06:00 to recv/test/l0_1/l1_0/l2_0 (~ 23.3 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_orcus_2025-02-12:15:10:40-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:30-GMT-06:00 to recv/test/l0_1/l1_0/l2_1 (~ 22.2 MB):
internal error: warning: cannot send 'send/test/l0_1/l1_0/l2_1@syncoid_orcus_2025-02-12:15:11:30-GMT-06:00': Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_1'@'syncoid_orcus_2025-02-12:15:10:40-GMT-06:00' 'send/test/l0_1/l1_0/l2_1'@'syncoid_orcus_2025-02-12:15:11:30-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 23321112 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_1' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_orcus_2025-02-12:15:10:41-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:31-GMT-06:00 to recv/test/l0_1/l1_0/l2_2 (~ 24.6 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_orcus_2025-02-12:15:10:42-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:33-GMT-06:00 to recv/test/l0_1/l1_0/l2_3 (~ 22.2 MB):
INFO: Sending incremental send/test/l0_1/l1_1@syncoid_orcus_2025-02-12:15:10:43-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:35-GMT-06:00 to recv/test/l0_1/l1_1 (~ 1.7 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_orcus_2025-02-12:15:10:44-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:37-GMT-06:00 to recv/test/l0_1/l1_1/l2_0 (~ 1.7 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-12:15:10:45-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:38-GMT-06:00 to recv/test/l0_1/l1_1/l2_1 (~ 1.7 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_orcus_2025-02-12:15:10:45-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:40-GMT-06:00 to recv/test/l0_1/l1_1/l2_2 (~ 1.7 MB):
internal error: warning: cannot send 'send/test/l0_1/l1_1/l2_2@syncoid_orcus_2025-02-12:15:11:40-GMT-06:00': Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_2'@'syncoid_orcus_2025-02-12:15:10:45-GMT-06:00' 'send/test/l0_1/l1_1/l2_2'@'syncoid_orcus_2025-02-12:15:11:40-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 1819192 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_2' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1/l1_1/l2_3@syncoid_orcus_2025-02-12:15:10:46-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:41-GMT-06:00 to recv/test/l0_1/l1_1/l2_3 (~ 1.7 MB):
internal error: warning: cannot send 'send/test/l0_1/l1_1/l2_3@syncoid_orcus_2025-02-12:15:11:41-GMT-06:00': Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_3'@'syncoid_orcus_2025-02-12:15:10:46-GMT-06:00' 'send/test/l0_1/l1_1/l2_3'@'syncoid_orcus_2025-02-12:15:11:41-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 1819192 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_3' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1/l1_2@syncoid_orcus_2025-02-12:15:10:47-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:42-GMT-06:00 to recv/test/l0_1/l1_2 (~ 1.7 MB):
INFO: Sending incremental send/test/l0_1/l1_2/l2_0@syncoid_orcus_2025-02-12:15:10:48-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:44-GMT-06:00 to recv/test/l0_1/l1_2/l2_0 (~ 1.7 MB):
INFO: Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_orcus_2025-02-12:15:10:49-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:45-GMT-06:00 to recv/test/l0_1/l1_2/l2_1 (~ 1.7 MB):
INFO: Sending incremental send/test/l0_1/l1_2/l2_2@syncoid_orcus_2025-02-12:15:10:50-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:47-GMT-06:00 to recv/test/l0_1/l1_2/l2_2 (~ 1.7 MB):
INFO: Sending incremental send/test/l0_1/l1_2/l2_3@syncoid_orcus_2025-02-12:15:10:51-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:48-GMT-06:00 to recv/test/l0_1/l1_2/l2_3 (~ 1.7 MB):
internal error: warning: cannot send 'send/test/l0_1/l1_2/l2_3@syncoid_orcus_2025-02-12:15:11:48-GMT-06:00': Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_2/l2_3'@'syncoid_orcus_2025-02-12:15:10:51-GMT-06:00' 'send/test/l0_1/l1_2/l2_3'@'syncoid_orcus_2025-02-12:15:11:48-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 1802184 |  zfs receive  -s -F 'recv/test/l0_1/l1_2/l2_3' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1/l1_3@syncoid_orcus_2025-02-12:15:10:52-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:49-GMT-06:00 to recv/test/l0_1/l1_3 (~ 15.3 MB):
INFO: Sending incremental send/test/l0_1/l1_3/l2_0@syncoid_orcus_2025-02-12:15:10:53-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:51-GMT-06:00 to recv/test/l0_1/l1_3/l2_0 (~ 22.4 MB):
INFO: Sending incremental send/test/l0_1/l1_3/l2_1@syncoid_orcus_2025-02-12:15:10:54-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:53-GMT-06:00 to recv/test/l0_1/l1_3/l2_1 (~ 11.5 MB):
INFO: Sending incremental send/test/l0_1/l1_3/l2_2@syncoid_orcus_2025-02-12:15:10:55-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:55-GMT-06:00 to recv/test/l0_1/l1_3/l2_2 (~ 1.7 MB):
INFO: Sending incremental send/test/l0_1/l1_3/l2_3@syncoid_orcus_2025-02-12:15:10:56-GMT-06:00 ... syncoid_orcus_2025-02-12:15:11:56-GMT-06:00 to recv/test/l0_1/l1_3/l2_3 (~ 10.0 MB):
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
          wwn-0x5002538d40878f8e  ONLINE       0     0     0

errors: 13 data errors, use '-v' for a list
hbarta@orcus:~/logs$ 
```
