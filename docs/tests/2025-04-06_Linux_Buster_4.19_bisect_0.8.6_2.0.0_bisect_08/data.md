# Results: Git bisect 0.8.6 to 2.0.0 - testing eighth bisect

## 2025-04-06 First syncoid

```text
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   576K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   238G   226G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_orion_2025-04-06:22:27:16-GMT-05:00 to new target filesystem recv/test (~ 86 KB):
48.9KiB 0:00:00 [2.79MiB/s] [=======================================================>                                            ] 56%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_orion_2025-04-06:22:27:17-GMT-05:00 to new target filesystem recv/test/l0_0 (~ 15.3 GB):
15.3GiB 0:01:05 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_orion_2025-04-06:22:28:22-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0 (~ 15.6 GB):
15.6GiB 0:01:05 [ 243MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-06:22:29:28-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_0 (~ 15.3 GB):
15.3GiB 0:01:05 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-06:22:30:35-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_1 (~ 15.4 GB):
15.4GiB 0:01:06 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-06:22:31:42-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_2 (~ 15.5 GB):
15.5GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-06:22:32:50-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_3 (~ 15.8 GB):
15.9GiB 0:01:07 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_orion_2025-04-06:22:33:58-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1 (~ 15.4 GB):
15.4GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-06:22:35:04-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_0 (~ 15.5 GB):
15.5GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-06:22:36:11-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_1 (~ 15.7 GB):
15.7GiB 0:01:07 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-06:22:37:20-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_2 (~ 15.5 GB):
15.5GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-06:22:38:27-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_3 (~ 15.1 GB):
15.1GiB 0:01:04 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_orion_2025-04-06:22:39:32-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2 (~ 15.4 GB):
15.4GiB 0:01:05 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-06:22:40:39-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_0 (~ 15.5 GB):
15.5GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-06:22:41:46-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_1 (~ 15.6 GB):
15.6GiB 0:01:06 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-06:22:42:53-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_2 (~ 15.2 GB):
15.2GiB 0:01:05 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-06:22:43:59-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_3 (~ 15.3 GB):
15.3GiB 0:01:05 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_orion_2025-04-06:22:45:04-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3 (~ 15.6 GB):
15.6GiB 0:01:05 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-06:22:46:11-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_0 (~ 15.4 GB):
15.4GiB 0:01:06 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-06:22:47:18-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_1 (~ 15.3 GB):
15.4GiB 0:01:05 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-06:22:48:24-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_2 (~ 15.3 GB):
15.3GiB 0:01:05 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-06:22:49:30-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_3 (~ 15.4 GB):
15.4GiB 0:01:05 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_orion_2025-04-06:22:50:36-GMT-05:00 to new target filesystem recv/test/l0_1 (~ 15.3 GB):
15.3GiB 0:01:05 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_orion_2025-04-06:22:51:41-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0 (~ 15.3 GB):
15.3GiB 0:01:04 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-06:22:52:47-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_0 (~ 15.7 GB):
15.7GiB 0:01:07 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-06:22:53:55-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_1 (~ 15.5 GB):
15.5GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-06:22:55:02-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_2 (~ 15.0 GB):
15.0GiB 0:01:04 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-06:22:56:07-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_3 (~ 15.3 GB):
15.3GiB 0:01:04 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_orion_2025-04-06:22:57:12-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1 (~ 15.3 GB):
15.3GiB 0:01:05 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-06:22:58:18-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_0 (~ 15.3 GB):
15.3GiB 0:01:04 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-06:22:59:23-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_1 (~ 15.2 GB):
15.2GiB 0:01:05 [ 238MiB/s] [==================================================================================================>] 100%            
real 1992.24
user 27.12
sys 1924.31
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   238G   226G        -         -     0%    51%  1.00x    ONLINE  -
send   464G   238G   226G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# 
```

## 2024-04-07 final pool status

```text
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   304G   160G        -         -    41%    65%  1.00x    ONLINE  -
send   464G   323G   141G        -         -    60%    69%  1.00x    ONLINE  -
root@orion:~# zpool status
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
  scan: none requested
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: No known data errors
root@orion:~# 
```
