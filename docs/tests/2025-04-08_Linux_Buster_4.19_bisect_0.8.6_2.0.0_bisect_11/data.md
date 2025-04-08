# Data: Git bisect 0.8.6 to 2.0.0 - testing tenth bisect

* [Setup](./setup.md)
* [Results](./results.md)

## 2025-04-08 first syncoid

```text
...
Capacity target 50 met
real 2284.89
user 68.56
sys 2266.59
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_orion_2025-04-08:08:51:48-GMT-05:00 to new target filesystem recv/test (~ 86 KB):
48.9KiB 0:00:00 [2.97MiB/s] [=======================================================>                                            ] 56%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_orion_2025-04-08:08:51:48-GMT-05:00 to new target filesystem recv/test/l0_0 (~ 15.6 GB):
15.6GiB 0:01:06 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_orion_2025-04-08:08:52:55-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0 (~ 15.4 GB):
15.4GiB 0:01:05 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-08:08:54:01-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_0 (~ 15.4 GB):
15.4GiB 0:01:05 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-08:08:55:07-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_1 (~ 15.2 GB):
15.2GiB 0:01:04 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-08:08:56:12-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_2 (~ 15.6 GB):
15.6GiB 0:01:07 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-08:08:57:19-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_3 (~ 15.5 GB):
15.5GiB 0:01:05 [ 243MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_orion_2025-04-08:08:58:25-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1 (~ 15.2 GB):
15.2GiB 0:01:04 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-08:08:59:30-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_0 (~ 15.5 GB):
15.5GiB 0:01:06 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-08:09:00:36-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_1 (~ 15.7 GB):
15.7GiB 0:01:07 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-08:09:01:45-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_2 (~ 15.8 GB):
15.8GiB 0:01:06 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-08:09:02:52-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_3 (~ 15.2 GB):
15.2GiB 0:01:04 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_orion_2025-04-08:09:03:57-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2 (~ 15.5 GB):
15.5GiB 0:01:05 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-08:09:05:04-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_0 (~ 15.7 GB):
15.7GiB 0:01:06 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-08:09:06:11-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_1 (~ 15.5 GB):
15.5GiB 0:01:06 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-08:09:07:18-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_2 (~ 15.2 GB):
15.2GiB 0:01:05 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-08:09:08:23-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_3 (~ 15.4 GB):
15.4GiB 0:01:04 [ 243MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_orion_2025-04-08:09:09:28-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3 (~ 15.2 GB):
15.2GiB 0:01:05 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-08:09:10:35-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_0 (~ 15.3 GB):
15.3GiB 0:01:05 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-08:09:11:41-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_1 (~ 15.6 GB):
15.6GiB 0:01:06 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-08:09:12:48-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_2 (~ 15.2 GB):
15.2GiB 0:01:05 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-08:09:13:54-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_3 (~ 15.4 GB):
15.4GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_orion_2025-04-08:09:15:01-GMT-05:00 to new target filesystem recv/test/l0_1 (~ 15.6 GB):
15.6GiB 0:01:06 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_orion_2025-04-08:09:16:07-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0 (~ 14.5 GB):
14.5GiB 0:01:02 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-08:09:17:10-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_0 (~ 15.3 GB):
15.3GiB 0:01:05 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-08:09:18:16-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_1 (~ 15.7 GB):
15.7GiB 0:01:07 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-08:09:19:23-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_2 (~ 15.0 GB):
15.0GiB 0:01:03 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-08:09:20:28-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_3 (~ 15.4 GB):
15.4GiB 0:01:05 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_orion_2025-04-08:09:21:33-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1 (~ 15.8 GB):
15.8GiB 0:01:06 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-08:09:22:40-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_0 (~ 15.5 GB):
15.5GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-08:09:23:48-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_1 (~ 15.3 GB):
15.3GiB 0:01:05 [ 239MiB/s] [==================================================================================================>] 100%            
real 1986.16
user 27.15
sys 1929.05
root@orion:~# 
```
