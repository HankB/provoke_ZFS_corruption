# Data: Git bisect 0.8.6 to 2.0.0 - testing 0.8.6

* [Results](./results.md)
* [Setup](./setup.md)

## 2025-04-02 first syncoid

```text
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_orion_2025-04-02:19:34:44-GMT-05:00 to new target filesystem recv/test (~ 86 KB):
48.9KiB 0:00:00 [4.00MiB/s] [=======================================================>                                            ] 56%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_orion_2025-04-02:19:34:44-GMT-05:00 to new target filesystem recv/test/l0_0 (~ 15.3 GB):
15.3GiB 0:01:03 [ 245MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_orion_2025-04-02:19:35:49-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0 (~ 15.5 GB):
15.5GiB 0:01:04 [ 245MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-02:19:36:54-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_0 (~ 15.4 GB):
15.4GiB 0:01:03 [ 247MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-02:19:37:58-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_1 (~ 15.3 GB):
15.3GiB 0:01:04 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-02:19:39:03-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_2 (~ 16.0 GB):
16.0GiB 0:01:07 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-02:19:40:11-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_3 (~ 15.6 GB):
15.6GiB 0:01:06 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_orion_2025-04-02:19:41:18-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1 (~ 14.9 GB):
14.9GiB 0:01:02 [ 243MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-02:19:42:21-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_0 (~ 15.3 GB):
15.3GiB 0:01:03 [ 246MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-02:19:43:25-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_1 (~ 15.5 GB):
15.5GiB 0:01:05 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-02:19:44:31-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_2 (~ 15.6 GB):
15.6GiB 0:01:05 [ 244MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-02:19:45:37-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_3 (~ 15.5 GB):
15.5GiB 0:01:06 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_orion_2025-04-02:19:46:43-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2 (~ 15.6 GB):
15.7GiB 0:01:04 [ 248MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-02:19:47:48-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_0 (~ 15.9 GB):
15.9GiB 0:01:07 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-02:19:48:57-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_1 (~ 15.3 GB):
15.3GiB 0:01:04 [ 243MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-02:19:50:01-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_2 (~ 15.5 GB):
15.5GiB 0:01:04 [ 246MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-02:19:51:06-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_3 (~ 15.8 GB):
15.8GiB 0:01:06 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_orion_2025-04-02:19:52:13-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3 (~ 15.6 GB):
15.6GiB 0:01:06 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-02:19:53:20-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_0 (~ 15.5 GB):
15.6GiB 0:01:04 [ 245MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-02:19:54:25-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_1 (~ 15.7 GB):
15.7GiB 0:01:04 [ 249MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-02:19:55:30-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_2 (~ 15.5 GB):
15.5GiB 0:01:05 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-02:19:56:36-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_3 (~ 15.8 GB):
15.8GiB 0:01:06 [ 243MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_orion_2025-04-02:19:57:43-GMT-05:00 to new target filesystem recv/test/l0_1 (~ 15.3 GB):
15.3GiB 0:01:04 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_orion_2025-04-02:19:58:48-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0 (~ 15.1 GB):
15.1GiB 0:01:03 [ 244MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-02:19:59:52-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_0 (~ 15.2 GB):
15.2GiB 0:01:03 [ 244MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-02:20:00:57-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_1 (~ 15.2 GB):
15.2GiB 0:01:06 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-02:20:02:03-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_2 (~ 15.7 GB):
15.7GiB 0:01:06 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-02:20:03:10-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_3 (~ 15.2 GB):
15.2GiB 0:01:03 [ 244MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_orion_2025-04-02:20:04:14-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1 (~ 15.3 GB):
15.3GiB 0:01:04 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-02:20:05:19-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_0 (~ 15.6 GB):
15.6GiB 0:01:06 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-02:20:06:26-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_1 (~ 15.3 GB):
15.3GiB 0:01:04 [ 244MiB/s] [==================================================================================================>] 100%            
real 1966.58
user 25.71
sys 1834.88
root@orion:~# 
```
