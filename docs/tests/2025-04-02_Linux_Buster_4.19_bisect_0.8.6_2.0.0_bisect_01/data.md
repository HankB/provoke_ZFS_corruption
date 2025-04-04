# Data: Git bisect 0.8.6 to 2.0.0 - testing first bisect

First syncoid run as root.

```text
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_orion_2025-04-03:09:47:48-GMT-05:00 to new target filesystem recv/test (~ 86 KB):
48.9KiB 0:00:00 [3.87MiB/s] [=======================================================>                                            ] 56%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_orion_2025-04-03:09:47:49-GMT-05:00 to new target filesystem recv/test/l0_0 (~ 15.2 GB):
15.3GiB 0:01:05 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_orion_2025-04-03:09:48:54-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0 (~ 15.6 GB):
15.6GiB 0:01:06 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-03:09:50:02-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_0 (~ 15.7 GB):
15.7GiB 0:01:07 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-03:09:51:10-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_1 (~ 15.4 GB):
15.4GiB 0:01:04 [ 245MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-03:09:52:14-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_2 (~ 15.3 GB):
15.3GiB 0:01:06 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-03:09:53:22-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_3 (~ 15.5 GB):
15.5GiB 0:01:07 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_orion_2025-04-03:09:54:30-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1 (~ 15.0 GB):
15.0GiB 0:01:03 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-03:09:55:34-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_0 (~ 15.5 GB):
15.5GiB 0:01:06 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-03:09:56:41-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_1 (~ 15.7 GB):
15.7GiB 0:01:07 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-03:09:57:49-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_2 (~ 15.3 GB):
15.3GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-03:09:58:55-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_3 (~ 15.5 GB):
15.5GiB 0:01:06 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_orion_2025-04-03:10:00:02-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2 (~ 15.5 GB):
15.5GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-03:10:01:09-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_0 (~ 15.4 GB):
15.4GiB 0:01:06 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-03:10:02:17-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_1 (~ 15.7 GB):
15.7GiB 0:01:07 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-03:10:03:24-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_2 (~ 15.6 GB):
15.6GiB 0:01:07 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-03:10:04:32-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_3 (~ 15.0 GB):
15.0GiB 0:01:03 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_orion_2025-04-03:10:05:36-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3 (~ 15.7 GB):
15.7GiB 0:01:07 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-03:10:06:44-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_0 (~ 15.6 GB):
15.6GiB 0:01:06 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-03:10:07:51-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_1 (~ 15.5 GB):
15.5GiB 0:01:06 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-03:10:08:57-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_2 (~ 15.7 GB):
15.7GiB 0:01:06 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-03:10:10:04-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_3 (~ 15.5 GB):
15.5GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_orion_2025-04-03:10:11:11-GMT-05:00 to new target filesystem recv/test/l0_1 (~ 15.8 GB):
15.8GiB 0:01:07 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_orion_2025-04-03:10:12:19-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0 (~ 15.2 GB):
15.3GiB 0:01:04 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-03:10:13:24-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_0 (~ 15.7 GB):
15.7GiB 0:01:08 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-03:10:14:33-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_1 (~ 15.6 GB):
15.6GiB 0:01:07 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-03:10:15:40-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_2 (~ 15.6 GB):
15.6GiB 0:01:06 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-03:10:16:47-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_3 (~ 15.8 GB):
15.8GiB 0:01:07 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_orion_2025-04-03:10:17:55-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1 (~ 16.2 GB):
16.2GiB 0:01:09 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-03:10:19:05-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_0 (~ 15.3 GB):
15.3GiB 0:01:05 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-03:10:20:11-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_1 (~ 15.4 GB):
15.4GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
real 2010.04
user 27.06
sys 1963.08
root@orion:~# 
```
