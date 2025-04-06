# Data: Git bisect 0.8.6 to 2.0.0 - testing sixth bisect

## 2025-04-05 first syncoid run as root

```text
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   576K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   239G   225G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_orion_2025-04-05:17:32:55-GMT-05:00 to new target filesystem recv/test (~ 86 KB):
48.9KiB 0:00:00 [3.40MiB/s] [=======================================================>                                            ] 56%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_orion_2025-04-05:17:32:55-GMT-05:00 to new target filesystem recv/test/l0_0 (~ 15.6 GB):
15.6GiB 0:01:05 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_orion_2025-04-05:17:34:02-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0 (~ 15.7 GB):
15.7GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-05:17:35:10-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_0 (~ 15.6 GB):
15.6GiB 0:01:06 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-05:17:36:17-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_1 (~ 15.3 GB):
15.3GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-05:17:37:23-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_2 (~ 15.6 GB):
15.6GiB 0:01:07 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-05:17:38:31-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_3 (~ 15.2 GB):
15.2GiB 0:01:04 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_orion_2025-04-05:17:39:35-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1 (~ 15.6 GB):
15.6GiB 0:01:06 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-05:17:40:42-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_0 (~ 15.4 GB):
15.4GiB 0:01:05 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-05:17:41:48-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_1 (~ 15.7 GB):
15.7GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-05:17:42:56-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_2 (~ 15.6 GB):
15.6GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-05:17:44:04-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_3 (~ 15.4 GB):
15.4GiB 0:01:05 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_orion_2025-04-05:17:45:10-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2 (~ 15.5 GB):
15.5GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-05:17:46:18-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_0 (~ 15.3 GB):
15.3GiB 0:01:05 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-05:17:47:24-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_1 (~ 15.6 GB):
15.6GiB 0:01:06 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-05:17:48:31-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_2 (~ 15.8 GB):
15.8GiB 0:01:07 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-05:17:49:40-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_3 (~ 15.5 GB):
15.5GiB 0:01:05 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_orion_2025-04-05:17:50:46-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3 (~ 16.0 GB):
16.0GiB 0:01:08 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-05:17:51:55-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_0 (~ 15.9 GB):
15.9GiB 0:01:08 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-05:17:53:04-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_1 (~ 15.5 GB):
15.5GiB 0:01:06 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-05:17:54:11-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_2 (~ 15.1 GB):
15.1GiB 0:01:04 [ 239MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-05:17:55:16-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_3 (~ 15.3 GB):
15.3GiB 0:01:05 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_orion_2025-04-05:17:56:21-GMT-05:00 to new target filesystem recv/test/l0_1 (~ 15.5 GB):
15.5GiB 0:01:05 [ 242MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_orion_2025-04-05:17:57:27-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0 (~ 15.4 GB):
15.4GiB 0:01:05 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-05:17:58:34-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_0 (~ 15.5 GB):
15.5GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-05:17:59:41-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_1 (~ 15.1 GB):
15.1GiB 0:01:05 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-05:18:00:47-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_2 (~ 15.5 GB):
15.5GiB 0:01:06 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-05:18:01:53-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_3 (~ 15.6 GB):
15.6GiB 0:01:07 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_orion_2025-04-05:18:03:01-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1 (~ 15.1 GB):
15.1GiB 0:01:04 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-05:18:04:06-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_0 (~ 15.6 GB):
15.6GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-05:18:05:14-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_1 (~ 15.6 GB):
15.6GiB 0:01:06 [ 242MiB/s] [==================================================================================================>] 100%            
real 2005.02
user 27.20
sys 1948.02
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   238G   226G        -         -     0%    51%  1.00x    ONLINE  -
send   464G   239G   225G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# 
```

# 2025-04-06 last complete syncoid

```text
hbarta@orion:~/logs$ cat 2025-04-06-071642.syncoid.249.txt
INFO: Sending incremental send/test@syncoid_orion_2025-04-06:07:12:41-GMT-05:00 ... syncoid_orion_2025-04-06:07:16:43-GMT-05:00 to recv/test (~ 4 KB):
INFO: Sending incremental send/test/l0_0@syncoid_orion_2025-04-06:07:12:45-GMT-05:00 ... syncoid_orion_2025-04-06:07:16:46-GMT-05:00 to recv/test/l0_0 (~ 96.8 MB):
INFO: Sending incremental send/test/l0_0/l1_0@syncoid_orion_2025-04-06:07:12:52-GMT-05:00 ... syncoid_orion_2025-04-06:07:16:53-GMT-05:00 to recv/test/l0_0/l1_0 (~ 91.8 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-06:07:13:01-GMT-05:00 ... syncoid_orion_2025-04-06:07:17:03-GMT-05:00 to recv/test/l0_0/l1_0/l2_0 (~ 90.0 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-06:07:13:09-GMT-05:00 ... syncoid_orion_2025-04-06:07:17:10-GMT-05:00 to recv/test/l0_0/l1_0/l2_1 (~ 89.9 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-06:07:13:16-GMT-05:00 ... syncoid_orion_2025-04-06:07:17:18-GMT-05:00 to recv/test/l0_0/l1_0/l2_2 (~ 88.0 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-06:07:13:23-GMT-05:00 ... syncoid_orion_2025-04-06:07:17:26-GMT-05:00 to recv/test/l0_0/l1_0/l2_3 (~ 112.5 MB):
INFO: Sending incremental send/test/l0_0/l1_1@syncoid_orion_2025-04-06:07:13:31-GMT-05:00 ... syncoid_orion_2025-04-06:07:17:35-GMT-05:00 to recv/test/l0_0/l1_1 (~ 89.0 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-06:07:13:40-GMT-05:00 ... syncoid_orion_2025-04-06:07:17:42-GMT-05:00 to recv/test/l0_0/l1_1/l2_0 (~ 89.7 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-06:07:13:48-GMT-05:00 ... syncoid_orion_2025-04-06:07:17:49-GMT-05:00 to recv/test/l0_0/l1_1/l2_1 (~ 91.2 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-06:07:13:55-GMT-05:00 ... syncoid_orion_2025-04-06:07:17:57-GMT-05:00 to recv/test/l0_0/l1_1/l2_2 (~ 92.4 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-06:07:14:03-GMT-05:00 ... syncoid_orion_2025-04-06:07:18:06-GMT-05:00 to recv/test/l0_0/l1_1/l2_3 (~ 111.0 MB):
INFO: Sending incremental send/test/l0_0/l1_2@syncoid_orion_2025-04-06:07:14:10-GMT-05:00 ... syncoid_orion_2025-04-06:07:18:13-GMT-05:00 to recv/test/l0_0/l1_2 (~ 96.6 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-06:07:14:19-GMT-05:00 ... syncoid_orion_2025-04-06:07:18:21-GMT-05:00 to recv/test/l0_0/l1_2/l2_0 (~ 87.7 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-06:07:14:27-GMT-05:00 ... syncoid_orion_2025-04-06:07:18:32-GMT-05:00 to recv/test/l0_0/l1_2/l2_1 (~ 88.6 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-06:07:14:37-GMT-05:00 ... syncoid_orion_2025-04-06:07:18:40-GMT-05:00 to recv/test/l0_0/l1_2/l2_2 (~ 90.8 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-06:07:14:45-GMT-05:00 ... syncoid_orion_2025-04-06:07:18:46-GMT-05:00 to recv/test/l0_0/l1_2/l2_3 (~ 116.0 MB):
INFO: Sending incremental send/test/l0_0/l1_3@syncoid_orion_2025-04-06:07:14:52-GMT-05:00 ... syncoid_orion_2025-04-06:07:18:54-GMT-05:00 to recv/test/l0_0/l1_3 (~ 90.8 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-06:07:14:58-GMT-05:00 ... syncoid_orion_2025-04-06:07:19:02-GMT-05:00 to recv/test/l0_0/l1_3/l2_0 (~ 89.8 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-06:07:15:06-GMT-05:00 ... syncoid_orion_2025-04-06:07:19:10-GMT-05:00 to recv/test/l0_0/l1_3/l2_1 (~ 111.6 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-06:07:15:13-GMT-05:00 ... syncoid_orion_2025-04-06:07:19:18-GMT-05:00 to recv/test/l0_0/l1_3/l2_2 (~ 114.7 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-06:07:15:21-GMT-05:00 ... syncoid_orion_2025-04-06:07:19:27-GMT-05:00 to recv/test/l0_0/l1_3/l2_3 (~ 88.1 MB):
INFO: Sending incremental send/test/l0_1@syncoid_orion_2025-04-06:07:15:31-GMT-05:00 ... syncoid_orion_2025-04-06:07:19:34-GMT-05:00 to recv/test/l0_1 (~ 105.3 MB):
INFO: Sending incremental send/test/l0_1/l1_0@syncoid_orion_2025-04-06:07:15:40-GMT-05:00 ... syncoid_orion_2025-04-06:07:19:42-GMT-05:00 to recv/test/l0_1/l1_0 (~ 101.4 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-06:07:15:48-GMT-05:00 ... syncoid_orion_2025-04-06:07:19:49-GMT-05:00 to recv/test/l0_1/l1_0/l2_0 (~ 88.2 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-06:07:15:56-GMT-05:00 ... syncoid_orion_2025-04-06:07:19:59-GMT-05:00 to recv/test/l0_1/l1_0/l2_1 (~ 91.4 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-06:07:16:04-GMT-05:00 ... syncoid_orion_2025-04-06:07:20:12-GMT-05:00 to recv/test/l0_1/l1_0/l2_2 (~ 90.4 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-06:07:16:12-GMT-05:00 ... syncoid_orion_2025-04-06:07:20:19-GMT-05:00 to recv/test/l0_1/l1_0/l2_3 (~ 91.8 MB):
INFO: Sending incremental send/test/l0_1/l1_1@syncoid_orion_2025-04-06:07:16:20-GMT-05:00 ... syncoid_orion_2025-04-06:07:20:27-GMT-05:00 to recv/test/l0_1/l1_1 (~ 103.3 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-06:07:16:29-GMT-05:00 ... syncoid_orion_2025-04-06:07:20:34-GMT-05:00 to recv/test/l0_1/l1_1/l2_0 (~ 108.9 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-06:07:16:35-GMT-05:00 ... syncoid_orion_2025-04-06:07:20:43-GMT-05:00 to recv/test/l0_1/l1_1/l2_1 (~ 114.2 MB):
  pool: send
 state: ONLINE
  scan: none requested
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: No known data errors
hbarta@orion:~/logs$ zpool status send
  pool: send
 state: ONLINE
  scan: none requested
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: No known data errors
hbarta@orion:~/logs$ ls *syncoid*|wc -l
314
hbarta@orion:~/logs$ 
```