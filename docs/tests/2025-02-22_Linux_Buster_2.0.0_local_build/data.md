# Setup

## 2025-02-23 first syncoid

```text
root@orion:/home/hbarta# cd
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_orion_2025-02-23:13:05:51-GMT-06:00 to new target filesystem recv/test (~ 86 KB):
47.7KiB 0:00:00 [4.06MiB/s] [======================================================>                                             ] 55%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_orion_2025-02-23:13:05:51-GMT-06:00 to new target filesystem recv/test/l0_0 (~ 15.4 GB):
15.4GiB 0:01:02 [ 250MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_orion_2025-02-23:13:06:54-GMT-06:00 to new target filesystem recv/test/l0_0/l1_0 (~ 15.8 GB):
15.8GiB 0:01:05 [ 247MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-02-23:13:08:00-GMT-06:00 to new target filesystem recv/test/l0_0/l1_0/l2_0 (~ 15.8 GB):
15.9GiB 0:01:05 [ 249MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-02-23:13:09:05-GMT-06:00 to new target filesystem recv/test/l0_0/l1_0/l2_1 (~ 15.3 GB):
15.3GiB 0:01:02 [ 248MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-02-23:13:10:09-GMT-06:00 to new target filesystem recv/test/l0_0/l1_0/l2_2 (~ 15.4 GB):
15.4GiB 0:01:02 [ 251MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-02-23:13:11:12-GMT-06:00 to new target filesystem recv/test/l0_0/l1_0/l2_3 (~ 15.5 GB):
15.5GiB 0:01:04 [ 247MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_orion_2025-02-23:13:12:16-GMT-06:00 to new target filesystem recv/test/l0_0/l1_1 (~ 15.3 GB):
15.3GiB 0:01:02 [ 250MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-02-23:13:13:19-GMT-06:00 to new target filesystem recv/test/l0_0/l1_1/l2_0 (~ 15.3 GB):
15.3GiB 0:01:03 [ 247MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-02-23:13:14:23-GMT-06:00 to new target filesystem recv/test/l0_0/l1_1/l2_1 (~ 15.5 GB):
15.5GiB 0:01:03 [ 247MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-02-23:13:15:27-GMT-06:00 to new target filesystem recv/test/l0_0/l1_1/l2_2 (~ 15.3 GB):
15.3GiB 0:01:02 [ 251MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-02-23:13:16:30-GMT-06:00 to new target filesystem recv/test/l0_0/l1_1/l2_3 (~ 15.2 GB):
15.2GiB 0:01:02 [ 249MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_orion_2025-02-23:13:17:33-GMT-06:00 to new target filesystem recv/test/l0_0/l1_2 (~ 15.6 GB):
15.6GiB 0:01:03 [ 250MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-02-23:13:18:37-GMT-06:00 to new target filesystem recv/test/l0_0/l1_2/l2_0 (~ 15.5 GB):
15.5GiB 0:01:04 [ 247MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-02-23:13:19:42-GMT-06:00 to new target filesystem recv/test/l0_0/l1_2/l2_1 (~ 15.5 GB):
15.5GiB 0:01:03 [ 249MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-02-23:13:20:46-GMT-06:00 to new target filesystem recv/test/l0_0/l1_2/l2_2 (~ 15.2 GB):
15.2GiB 0:01:02 [ 249MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-02-23:13:21:49-GMT-06:00 to new target filesystem recv/test/l0_0/l1_2/l2_3 (~ 15.4 GB):
15.4GiB 0:01:03 [ 247MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_orion_2025-02-23:13:22:53-GMT-06:00 to new target filesystem recv/test/l0_0/l1_3 (~ 15.4 GB):
15.4GiB 0:01:04 [ 244MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-02-23:13:23:58-GMT-06:00 to new target filesystem recv/test/l0_0/l1_3/l2_0 (~ 15.5 GB):
15.5GiB 0:01:03 [ 249MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-02-23:13:25:02-GMT-06:00 to new target filesystem recv/test/l0_0/l1_3/l2_1 (~ 15.3 GB):
15.3GiB 0:01:02 [ 249MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-02-23:13:26:05-GMT-06:00 to new target filesystem recv/test/l0_0/l1_3/l2_2 (~ 15.1 GB):
15.1GiB 0:01:02 [ 246MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-02-23:13:27:09-GMT-06:00 to new target filesystem recv/test/l0_0/l1_3/l2_3 (~ 15.4 GB):
15.4GiB 0:01:02 [ 253MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_orion_2025-02-23:13:28:11-GMT-06:00 to new target filesystem recv/test/l0_1 (~ 15.3 GB):
15.3GiB 0:01:03 [ 247MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_orion_2025-02-23:13:29:15-GMT-06:00 to new target filesystem recv/test/l0_1/l1_0 (~ 16.1 GB):
16.1GiB 0:01:05 [ 253MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-02-23:13:30:20-GMT-06:00 to new target filesystem recv/test/l0_1/l1_0/l2_0 (~ 15.5 GB):
15.5GiB 0:01:03 [ 251MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-02-23:13:31:24-GMT-06:00 to new target filesystem recv/test/l0_1/l1_0/l2_1 (~ 15.3 GB):
15.3GiB 0:01:03 [ 248MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-02-23:13:32:27-GMT-06:00 to new target filesystem recv/test/l0_1/l1_0/l2_2 (~ 15.8 GB):
15.8GiB 0:01:04 [ 251MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-02-23:13:33:32-GMT-06:00 to new target filesystem recv/test/l0_1/l1_0/l2_3 (~ 15.5 GB):
15.5GiB 0:01:04 [ 247MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_orion_2025-02-23:13:34:37-GMT-06:00 to new target filesystem recv/test/l0_1/l1_1 (~ 15.2 GB):
15.2GiB 0:01:02 [ 249MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-02-23:13:35:40-GMT-06:00 to new target filesystem recv/test/l0_1/l1_1/l2_0 (~ 15.1 GB):
15.1GiB 0:01:01 [ 251MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-02-23:13:36:42-GMT-06:00 to new target filesystem recv/test/l0_1/l1_1/l2_1 (~ 15.3 GB):
15.3GiB 0:01:02 [ 250MiB/s] [==================================================================================================>] 100%            
real 1914.29
user 25.18
sys 1656.45
root@orion:~# 
```

## 2025-02-23 second syncoid

```text
hbarta@orion:~$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending incremental send/test@syncoid_orion_2025-02-23:13:05:51-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:16-GMT-06:00 to recv/test (~ 42 KB):
6.88KiB 0:00:00 [ 196KiB/s] [===============>                                                                                    ] 16%            
INFO: Sending incremental send/test/l0_0@syncoid_orion_2025-02-23:13:05:51-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:16-GMT-06:00 to recv/test/l0_0 (~ 1.7 MB):
1.24MiB 0:00:00 [26.0MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_0/l1_0@syncoid_orion_2025-02-23:13:06:54-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:16-GMT-06:00 to recv/test/l0_0/l1_0 (~ 1.7 MB):
1.24MiB 0:00:00 [24.4MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-02-23:13:08:00-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:17-GMT-06:00 to recv/test/l0_0/l1_0/l2_0 (~ 1.7 MB):
1.23MiB 0:00:00 [23.9MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-02-23:13:09:05-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:17-GMT-06:00 to recv/test/l0_0/l1_0/l2_1 (~ 1.7 MB):
1.23MiB 0:00:00 [26.1MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-02-23:13:10:09-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:18-GMT-06:00 to recv/test/l0_0/l1_0/l2_2 (~ 1.7 MB):
1.23MiB 0:00:00 [25.1MiB/s] [========================================================================>                           ] 73%            
INFO: Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-02-23:13:11:12-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:18-GMT-06:00 to recv/test/l0_0/l1_0/l2_3 (~ 1.7 MB):
1.23MiB 0:00:00 [24.7MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_0/l1_1@syncoid_orion_2025-02-23:13:12:16-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:18-GMT-06:00 to recv/test/l0_0/l1_1 (~ 1.7 MB):
1.24MiB 0:00:00 [26.3MiB/s] [========================================================================>                           ] 73%            
INFO: Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-02-23:13:13:19-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:19-GMT-06:00 to recv/test/l0_0/l1_1/l2_0 (~ 1.7 MB):
1.23MiB 0:00:00 [25.8MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-02-23:13:14:23-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:19-GMT-06:00 to recv/test/l0_0/l1_1/l2_1 (~ 1.7 MB):
1.23MiB 0:00:00 [24.2MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-02-23:13:15:27-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:19-GMT-06:00 to recv/test/l0_0/l1_1/l2_2 (~ 1.8 MB):
1.23MiB 0:00:00 [24.6MiB/s] [=====================================================================>                              ] 70%            
INFO: Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-02-23:13:16:30-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:20-GMT-06:00 to recv/test/l0_0/l1_1/l2_3 (~ 1.7 MB):
1.23MiB 0:00:00 [25.1MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_0/l1_2@syncoid_orion_2025-02-23:13:17:33-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:20-GMT-06:00 to recv/test/l0_0/l1_2 (~ 1.7 MB):
1.24MiB 0:00:00 [25.1MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-02-23:13:18:37-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:21-GMT-06:00 to recv/test/l0_0/l1_2/l2_0 (~ 1.7 MB):
1.23MiB 0:00:00 [25.0MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-02-23:13:19:42-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:21-GMT-06:00 to recv/test/l0_0/l1_2/l2_1 (~ 1.7 MB):
1.23MiB 0:00:00 [24.0MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-02-23:13:20:46-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:21-GMT-06:00 to recv/test/l0_0/l1_2/l2_2 (~ 1.7 MB):
1.23MiB 0:00:00 [25.1MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-02-23:13:21:49-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:22-GMT-06:00 to recv/test/l0_0/l1_2/l2_3 (~ 1.8 MB):
1.23MiB 0:00:00 [25.3MiB/s] [=====================================================================>                              ] 70%            
INFO: Sending incremental send/test/l0_0/l1_3@syncoid_orion_2025-02-23:13:22:53-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:22-GMT-06:00 to recv/test/l0_0/l1_3 (~ 1.7 MB):
1.24MiB 0:00:00 [26.5MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-02-23:13:23:58-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:22-GMT-06:00 to recv/test/l0_0/l1_3/l2_0 (~ 1.7 MB):
1.23MiB 0:00:00 [26.2MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-02-23:13:25:02-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:23-GMT-06:00 to recv/test/l0_0/l1_3/l2_1 (~ 1.7 MB):
1.23MiB 0:00:00 [26.7MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-02-23:13:26:05-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:23-GMT-06:00 to recv/test/l0_0/l1_3/l2_2 (~ 1.8 MB):
1.23MiB 0:00:00 [25.8MiB/s] [=====================================================================>                              ] 70%            
INFO: Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-02-23:13:27:09-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:24-GMT-06:00 to recv/test/l0_0/l1_3/l2_3 (~ 1.7 MB):
1.23MiB 0:00:00 [26.1MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_1@syncoid_orion_2025-02-23:13:28:11-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:24-GMT-06:00 to recv/test/l0_1 (~ 1.7 MB):
1.23MiB 0:00:00 [29.3MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_1/l1_0@syncoid_orion_2025-02-23:13:29:15-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:24-GMT-06:00 to recv/test/l0_1/l1_0 (~ 1.7 MB):
1.24MiB 0:00:00 [25.4MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-02-23:13:30:20-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:25-GMT-06:00 to recv/test/l0_1/l1_0/l2_0 (~ 1.7 MB):
1.23MiB 0:00:00 [26.2MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-02-23:13:31:24-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:25-GMT-06:00 to recv/test/l0_1/l1_0/l2_1 (~ 1.7 MB):
1.23MiB 0:00:00 [26.4MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-02-23:13:32:27-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:25-GMT-06:00 to recv/test/l0_1/l1_0/l2_2 (~ 1.7 MB):
1.23MiB 0:00:00 [22.3MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-02-23:13:33:32-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:26-GMT-06:00 to recv/test/l0_1/l1_0/l2_3 (~ 1.7 MB):
1.23MiB 0:00:00 [26.1MiB/s] [=======================================================================>                            ] 72%            
INFO: Sending incremental send/test/l0_1/l1_1@syncoid_orion_2025-02-23:13:34:37-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:26-GMT-06:00 to recv/test/l0_1/l1_1 (~ 1.7 MB):
1.23MiB 0:00:00 [25.8MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-02-23:13:35:40-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:27-GMT-06:00 to recv/test/l0_1/l1_1/l2_0 (~ 1.7 MB):
1.23MiB 0:00:00 [25.4MiB/s] [======================================================================>                             ] 71%            
INFO: Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-02-23:13:36:42-GMT-06:00 ... syncoid_orion_2025-02-23:14:16:27-GMT-06:00 to recv/test/l0_1/l1_1/l2_1 (~ 1.8 MB):
1.23MiB 0:00:00 [25.6MiB/s] [====================================================================>                               ] 69%            
real 11.86
user 2.71
sys 6.00
hbarta@orion:~$ 
```
