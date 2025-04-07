# Data: Git bisect 0.8.6 to 2.0.0 - testing sixth bisect

* [Results](./results.md)
* [Setup](./setup.md)

```text
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   564K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   239G   225G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_orion_2025-04-06:08:51:24-GMT-05:00 to new target filesystem recv/test (~ 86 KB):
48.9KiB 0:00:00 [5.20MiB/s] [=======================================================>                                            ] 56%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_orion_2025-04-06:08:51:24-GMT-05:00 to new target filesystem recv/test/l0_0 (~ 15.1 GB):
15.1GiB 0:01:05 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_orion_2025-04-06:08:52:30-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0 (~ 15.3 GB):
15.3GiB 0:01:04 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-06:08:53:35-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_0 (~ 15.1 GB):
15.1GiB 0:01:04 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-06:08:54:40-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_1 (~ 15.9 GB):
16.0GiB 0:01:08 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-06:08:55:49-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_2 (~ 15.5 GB):
15.5GiB 0:01:05 [ 243MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-06:08:56:54-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_3 (~ 15.3 GB):
15.3GiB 0:01:05 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_orion_2025-04-06:08:58:00-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1 (~ 15.4 GB):
15.4GiB 0:01:05 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-06:08:59:06-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_0 (~ 15.7 GB):
15.7GiB 0:01:06 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-06:09:00:14-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_1 (~ 15.7 GB):
15.7GiB 0:01:06 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-06:09:01:20-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_2 (~ 15.4 GB):
15.4GiB 0:01:05 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-06:09:02:27-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_3 (~ 15.7 GB):
15.7GiB 0:01:08 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_orion_2025-04-06:09:03:36-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2 (~ 15.4 GB):
15.4GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-06:09:04:42-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_0 (~ 15.4 GB):
15.4GiB 0:01:05 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-06:09:05:48-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_1 (~ 15.8 GB):
15.8GiB 0:01:07 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-06:09:06:56-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_2 (~ 15.3 GB):
15.3GiB 0:01:05 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-06:09:08:02-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_3 (~ 15.8 GB):
15.8GiB 0:01:07 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_orion_2025-04-06:09:09:10-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3 (~ 15.6 GB):
15.6GiB 0:01:06 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-06:09:10:17-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_0 (~ 15.8 GB):
15.8GiB 0:01:06 [ 243MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-06:09:11:23-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_1 (~ 15.5 GB):
15.5GiB 0:01:05 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-06:09:12:29-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_2 (~ 15.6 GB):
15.6GiB 0:01:07 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-06:09:13:37-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_3 (~ 16.1 GB):
16.1GiB 0:01:09 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_orion_2025-04-06:09:14:47-GMT-05:00 to new target filesystem recv/test/l0_1 (~ 15.6 GB):
15.6GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_orion_2025-04-06:09:15:55-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0 (~ 15.6 GB):
15.6GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-06:09:17:02-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_0 (~ 15.3 GB):
15.3GiB 0:01:05 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-06:09:18:08-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_1 (~ 15.1 GB):
15.1GiB 0:01:04 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-06:09:19:13-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_2 (~ 15.1 GB):
15.1GiB 0:01:04 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-06:09:20:18-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_3 (~ 15.2 GB):
15.2GiB 0:01:05 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_orion_2025-04-06:09:21:23-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1 (~ 15.4 GB):
15.4GiB 0:01:07 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-06:09:22:31-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_0 (~ 15.4 GB):
15.4GiB 0:01:05 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-06:09:23:37-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_1 (~ 15.3 GB):
15.3GiB 0:01:05 [ 238MiB/s] [==================================================================================================>] 100%            
real 1999.56
user 26.95
sys 1937.11
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   239G   225G        -         -     0%    51%  1.00x    ONLINE  -
send   464G   239G   225G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# 
```