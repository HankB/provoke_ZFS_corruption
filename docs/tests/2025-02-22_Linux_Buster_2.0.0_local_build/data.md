# Setup

* [Results](./results.md)
* [Setup](./setup.md)

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

## 2025-02-23 first syncoid with errors

```text
hbarta@orion:~/logs$ cat 2025-02-23-1637.syncoid.92.txt
INFO: Sending incremental send/test@syncoid_orion_2025-02-23:16:35:16-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:02-GMT-06:00 to recv/test (~ 4 KB):
INFO: Sending incremental send/test/l0_0@syncoid_orion_2025-02-23:16:35:17-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:03-GMT-06:00 to recv/test/l0_0 (~ 68.1 MB):
INFO: Sending incremental send/test/l0_0/l1_0@syncoid_orion_2025-02-23:16:35:21-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:07-GMT-06:00 to recv/test/l0_0/l1_0 (~ 64.7 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-02-23:16:35:24-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:10-GMT-06:00 to recv/test/l0_0/l1_0/l2_0 (~ 68.9 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-02-23:16:35:28-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:13-GMT-06:00 to recv/test/l0_0/l1_0/l2_1 (~ 68.9 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-02-23:16:35:31-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:17-GMT-06:00 to recv/test/l0_0/l1_0/l2_2 (~ 67.6 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-02-23:16:35:35-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:20-GMT-06:00 to recv/test/l0_0/l1_0/l2_3 (~ 77.8 MB):
warning: cannot send 'send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-02-23:16:37:20-GMT-06:00': Input/output error
INFO: Sending incremental send/test/l0_0/l1_1@syncoid_orion_2025-02-23:16:35:38-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:23-GMT-06:00 to recv/test/l0_0/l1_1 (~ 66.9 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-02-23:16:35:42-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:27-GMT-06:00 to recv/test/l0_0/l1_1/l2_0 (~ 67.3 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-02-23:16:35:45-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:30-GMT-06:00 to recv/test/l0_0/l1_1/l2_1 (~ 66.7 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-02-23:16:35:49-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:34-GMT-06:00 to recv/test/l0_0/l1_1/l2_2 (~ 66.2 MB):
warning: cannot send 'send/test/l0_0/l1_1/l2_2@1740350230.2025-02-23-1637': Input/output error
cannot receive incremental stream: kernel modules must be upgraded to receive this stream.
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_2'@'syncoid_orion_2025-02-23:16:35:49-GMT-06:00' 'send/test/l0_0/l1_1/l2_2'@'syncoid_orion_2025-02-23:16:37:34-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 69395776 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_2' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-02-23:16:35:53-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:36-GMT-06:00 to recv/test/l0_0/l1_1/l2_3 (~ 66.7 MB):
INFO: Sending incremental send/test/l0_0/l1_2@syncoid_orion_2025-02-23:16:35:57-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:39-GMT-06:00 to recv/test/l0_0/l1_2 (~ 66.5 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-02-23:16:36:00-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:42-GMT-06:00 to recv/test/l0_0/l1_2/l2_0 (~ 65.6 MB):
internal error: warning: cannot send 'send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-02-23:16:37:42-GMT-06:00': Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_0'@'syncoid_orion_2025-02-23:16:36:00-GMT-06:00' 'send/test/l0_0/l1_2/l2_0'@'syncoid_orion_2025-02-23:16:37:42-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 68804848 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_0' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-02-23:16:36:03-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:45-GMT-06:00 to recv/test/l0_0/l1_2/l2_1 (~ 68.1 MB):
internal error: warning: cannot send 'send/test/l0_0/l1_2/l2_1@1740350230.2025-02-23-1637': Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_1'@'syncoid_orion_2025-02-23:16:36:03-GMT-06:00' 'send/test/l0_0/l1_2/l2_1'@'syncoid_orion_2025-02-23:16:37:45-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 71376096 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_1' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-02-23:16:36:07-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:47-GMT-06:00 to recv/test/l0_0/l1_2/l2_2 (~ 66.1 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-02-23:16:36:10-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:50-GMT-06:00 to recv/test/l0_0/l1_2/l2_3 (~ 67.2 MB):
INFO: Sending incremental send/test/l0_0/l1_3@syncoid_orion_2025-02-23:16:36:14-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:53-GMT-06:00 to recv/test/l0_0/l1_3 (~ 69.3 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-02-23:16:36:17-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:57-GMT-06:00 to recv/test/l0_0/l1_3/l2_0 (~ 68.6 MB):
internal error: warning: cannot send 'send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-02-23:16:37:57-GMT-06:00': Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_0'@'syncoid_orion_2025-02-23:16:36:17-GMT-06:00' 'send/test/l0_0/l1_3/l2_0'@'syncoid_orion_2025-02-23:16:37:57-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 71918128 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_0' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-02-23:16:36:21-GMT-06:00 ... syncoid_orion_2025-02-23:16:37:59-GMT-06:00 to recv/test/l0_0/l1_3/l2_1 (~ 66.3 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-02-23:16:36:24-GMT-06:00 ... syncoid_orion_2025-02-23:16:38:03-GMT-06:00 to recv/test/l0_0/l1_3/l2_2 (~ 66.3 MB):
internal error: warning: cannot send 'send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-02-23:16:38:03-GMT-06:00': Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_2'@'syncoid_orion_2025-02-23:16:36:24-GMT-06:00' 'send/test/l0_0/l1_3/l2_2'@'syncoid_orion_2025-02-23:16:38:03-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 69547328 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_2' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-02-23:16:36:28-GMT-06:00 ... syncoid_orion_2025-02-23:16:38:05-GMT-06:00 to recv/test/l0_0/l1_3/l2_3 (~ 68.4 MB):
internal error: warning: cannot send 'send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-02-23:16:38:05-GMT-06:00': Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_3'@'syncoid_orion_2025-02-23:16:36:28-GMT-06:00' 'send/test/l0_0/l1_3/l2_3'@'syncoid_orion_2025-02-23:16:38:05-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 71747448 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_3' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1@syncoid_orion_2025-02-23:16:36:31-GMT-06:00 ... syncoid_orion_2025-02-23:16:38:08-GMT-06:00 to recv/test/l0_1 (~ 56.4 MB):
INFO: Sending incremental send/test/l0_1/l1_0@syncoid_orion_2025-02-23:16:36:34-GMT-06:00 ... syncoid_orion_2025-02-23:16:38:11-GMT-06:00 to recv/test/l0_1/l1_0 (~ 44.6 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-02-23:16:36:38-GMT-06:00 ... syncoid_orion_2025-02-23:16:38:14-GMT-06:00 to recv/test/l0_1/l1_0/l2_0 (~ 68.7 MB):
internal error: warning: cannot send 'send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-02-23:16:38:14-GMT-06:00': Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_0'@'syncoid_orion_2025-02-23:16:36:38-GMT-06:00' 'send/test/l0_1/l1_0/l2_0'@'syncoid_orion_2025-02-23:16:38:14-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 72024184 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_0' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-02-23:16:36:41-GMT-06:00 ... syncoid_orion_2025-02-23:16:38:16-GMT-06:00 to recv/test/l0_1/l1_0/l2_1 (~ 67.1 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-02-23:16:36:45-GMT-06:00 ... syncoid_orion_2025-02-23:16:38:20-GMT-06:00 to recv/test/l0_1/l1_0/l2_2 (~ 68.4 MB):
warning: cannot send 'send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-02-23:16:38:20-GMT-06:00': Input/output error
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1379a801cc-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1ddf48fab1ff809c72a00d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882be6bfd04ccafb9ba3958024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa89f63186fa09f63146fe4505c99979c9f99129f5f94999f176f646064aa6b60a46b646c656866656c616564a0ebee1ba26b606665600073030078d32d6a
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_2'@'syncoid_orion_2025-02-23:16:36:45-GMT-06:00' 'send/test/l0_1/l1_0/l2_2'@'syncoid_orion_2025-02-23:16:38:20-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 71769864 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_2' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-02-23:16:36:48-GMT-06:00 ... syncoid_orion_2025-02-23:16:38:22-GMT-06:00 to recv/test/l0_1/l1_0/l2_3 (~ 65.4 MB):
internal error: warning: cannot send 'send/test/l0_1/l1_0/l2_3@1740350302.2025-02-23-1638': Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_3'@'syncoid_orion_2025-02-23:16:36:48-GMT-06:00' 'send/test/l0_1/l1_0/l2_3'@'syncoid_orion_2025-02-23:16:38:22-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 68609592 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_3' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1/l1_1@syncoid_orion_2025-02-23:16:36:52-GMT-06:00 ... syncoid_orion_2025-02-23:16:38:25-GMT-06:00 to recv/test/l0_1/l1_1 (~ 69.6 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-02-23:16:36:55-GMT-06:00 ... syncoid_orion_2025-02-23:16:38:29-GMT-06:00 to recv/test/l0_1/l1_1/l2_0 (~ 68.3 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-02-23:16:36:59-GMT-06:00 ... syncoid_orion_2025-02-23:16:38:32-GMT-06:00 to recv/test/l0_1/l1_1/l2_1 (~ 69.5 MB):
internal error: warning: cannot send 'send/test/l0_1/l1_1/l2_1@1740350302.2025-02-23-1638': Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_1'@'syncoid_orion_2025-02-23:16:36:59-GMT-06:00' 'send/test/l0_1/l1_1/l2_1'@'syncoid_orion_2025-02-23:16:38:32-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 72873968 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_1' 2>&1 failed: 256
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
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: 70 data errors, use '-v' for a list
hbarta@orion:~/logs$ 
```