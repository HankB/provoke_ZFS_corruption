# data

* [Results](./results.md)

This file includes long listings that would only obscure some other descriptions.

## 2025-02-05 first syncoid

NB: Unnoticed at the time, the date and time on the FreeBSD host were not correct.

```text
root@vulcan:~ # pwd
/root
you have mail
root@vulcan:~ # time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_vulcan_2025-02-01:06:25:14-GMT00:00 (~ 71 KB) to new target filesystem:
49.4KiB 0:00:00 [ 514KiB/s] [===================================================================>                               ]  69%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_vulcan_2025-02-01:06:25:15-GMT00:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:02:48 [94.3MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_vulcan_2025-02-01:06:28:04-GMT00:00 (~ 15.0 GB) to new target filesystem:
15.0GiB 0:02:51 [89.6MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_vulcan_2025-02-01:06:30:57-GMT00:00 (~ 15.4 GB) to new target filesystem:
15.4GiB 0:02:56 [89.6MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_vulcan_2025-02-01:06:33:55-GMT00:00 (~ 15.7 GB) to new target filesystem:
15.7GiB 0:03:02 [87.7MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_vulcan_2025-02-01:06:36:59-GMT00:00 (~ 15.2 GB) to new target filesystem:
15.2GiB 0:02:55 [88.7MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_vulcan_2025-02-01:06:39:56-GMT00:00 (~ 15.2 GB) to new target filesystem:
15.2GiB 0:02:54 [89.6MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_vulcan_2025-02-01:06:42:51-GMT00:00 (~ 15.2 GB) to new target filesystem:
15.2GiB 0:02:53 [89.6MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_vulcan_2025-02-01:06:45:46-GMT00:00 (~ 15.6 GB) to new target filesystem:
15.6GiB 0:02:58 [89.5MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_vulcan_2025-02-01:06:48:46-GMT00:00 (~ 15.2 GB) to new target filesystem:
15.2GiB 0:02:53 [89.8MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_vulcan_2025-02-01:06:51:41-GMT00:00 (~ 15.3 GB) to new target filesystem:
15.3GiB 0:02:56 [88.8MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_vulcan_2025-02-01:06:54:38-GMT00:00 (~ 15.3 GB) to new target filesystem:
15.3GiB 0:02:55 [89.1MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_vulcan_2025-02-01:06:57:35-GMT00:00 (~ 15.4 GB) to new target filesystem:
15.4GiB 0:02:54 [90.5MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_vulcan_2025-02-01:07:00:30-GMT00:00 (~ 15.5 GB) to new target filesystem:
15.6GiB 0:02:58 [89.5MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_vulcan_2025-02-01:07:03:30-GMT00:00 (~ 15.3 GB) to new target filesystem:
15.3GiB 0:02:55 [89.3MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_vulcan_2025-02-01:07:06:26-GMT00:00 (~ 15.6 GB) to new target filesystem:
15.6GiB 0:02:55 [90.9MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_vulcan_2025-02-01:07:09:23-GMT00:00 (~ 15.6 GB) to new target filesystem:
15.6GiB 0:02:57 [90.2MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_vulcan_2025-02-01:07:12:22-GMT00:00 (~ 15.7 GB) to new target filesystem:
15.7GiB 0:02:58 [90.4MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_vulcan_2025-02-01:07:15:21-GMT00:00 (~ 15.4 GB) to new target filesystem:
15.4GiB 0:02:57 [89.1MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_vulcan_2025-02-01:07:18:20-GMT00:00 (~ 15.3 GB) to new target filesystem:
15.3GiB 0:02:55 [89.2MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_vulcan_2025-02-01:07:21:16-GMT00:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:02:57 [89.4MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_vulcan_2025-02-01:07:24:14-GMT00:00 (~ 15.7 GB) to new target filesystem:
15.7GiB 0:02:57 [90.4MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_vulcan_2025-02-01:07:27:13-GMT00:00 (~ 15.8 GB) to new target filesystem:
15.8GiB 0:02:59 [90.1MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_vulcan_2025-02-01:07:30:13-GMT00:00 (~ 15.5 GB) to new target filesystem:
6.51GiB 0:01:14 [89.5MiB/s] [========================================>                                                          ]  42%            
warning: cannot send 'send/test/l0_1/l1_0@syncoid_vulcan_2025-02-01:07:30:13-GMT00:00': signal received
cannot receive new filesystem stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1216bff9fd-e8-789c636064000310a500c4ec50360710e72765a526973030f8b042d460c8a7a515a79680646ce0f26c48f2499525a9c5403ac16ce6026ce697e4a79766a630309cccb0600e37b07b108124cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa89f63186fe0505c99979c9f99125f569a939c98176f646064aa6b60a46b606865606e656c606568acebee1b626060656000761b00a09c256e
Killed
CRITICAL ERROR:  zfs send  'send/test/l0_1/l1_0'@'syncoid_vulcan_2025-02-01:07:30:13-GMT00:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 16632464968 |  zfs receive  -s -F 'recv/test/l0_1/l1_0' failed: 256 at /usr/local/bin/syncoid line 549.
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_vulcan_2025-02-01:07:31:29-GMT00:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:02:55 [90.5MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_vulcan_2025-02-01:07:34:26-GMT00:00 (~ 15.7 GB) to new target filesystem:
15.7GiB 0:02:57 [90.6MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_vulcan_2025-02-01:07:37:25-GMT00:00 (~ 15.2 GB) to new target filesystem:
15.2GiB 0:02:52 [90.4MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_vulcan_2025-02-01:07:40:18-GMT00:00 (~ 15.8 GB) to new target filesystem:
15.8GiB 0:03:01 [89.2MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_vulcan_2025-02-01:07:43:20-GMT00:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:02:57 [89.0MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_vulcan_2025-02-01:07:46:19-GMT00:00 (~ 15.3 GB) to new target filesystem:
15.3GiB 0:02:54 [89.9MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_vulcan_2025-02-01:07:49:15-GMT00:00 (~ 15.2 GB) to new target filesystem:
15.2GiB 0:02:52 [90.2MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_2@syncoid_vulcan_2025-02-01:07:52:08-GMT00:00 (~ 4.0 GB) to new target filesystem:
3.97GiB 0:01:02 [65.0MiB/s] [==================================================================================================>] 100%            
real 5278.26
user 358.07
sys 4771.12
root@vulcan:~ # 
```

## 2025-02-05 second syncoid

```text
[hbarta@vulcan ~]$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
Sending incremental send/test@syncoid_vulcan_2025-02-01:09:23:08-GMT00:00 ... syncoid_vulcan_2025-02-01:10:09:53-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 324  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0@syncoid_vulcan_2025-02-01:09:23:09-GMT00:00 ... syncoid_vulcan_2025-02-01:10:10:10-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 319  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_0@syncoid_vulcan_2025-02-01:09:23:10-GMT00:00 ... syncoid_vulcan_2025-02-01:10:10:27-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 320  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_vulcan_2025-02-01:09:23:11-GMT00:00 ... syncoid_vulcan_2025-02-01:10:10:44-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 321  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_vulcan_2025-02-01:09:23:11-GMT00:00 ... syncoid_vulcan_2025-02-01:10:11:01-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 320  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_vulcan_2025-02-01:09:23:12-GMT00:00 ... syncoid_vulcan_2025-02-01:10:11:18-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 321  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_vulcan_2025-02-01:09:23:13-GMT00:00 ... syncoid_vulcan_2025-02-01:10:11:35-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 319  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_1@syncoid_vulcan_2025-02-01:09:23:14-GMT00:00 ... syncoid_vulcan_2025-02-01:10:11:52-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 320  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_vulcan_2025-02-01:09:23:15-GMT00:00 ... syncoid_vulcan_2025-02-01:10:12:09-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 320  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_vulcan_2025-02-01:09:23:16-GMT00:00 ... syncoid_vulcan_2025-02-01:10:12:26-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 320  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_vulcan_2025-02-01:09:23:17-GMT00:00 ... syncoid_vulcan_2025-02-01:10:12:43-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 319  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_vulcan_2025-02-01:09:23:17-GMT00:00 ... syncoid_vulcan_2025-02-01:10:13:00-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 320  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_2@syncoid_vulcan_2025-02-01:09:23:18-GMT00:00 ... syncoid_vulcan_2025-02-01:10:13:17-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 320  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_vulcan_2025-02-01:09:23:19-GMT00:00 ... syncoid_vulcan_2025-02-01:10:13:34-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 320  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_vulcan_2025-02-01:09:23:20-GMT00:00 ... syncoid_vulcan_2025-02-01:10:13:51-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 320  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_vulcan_2025-02-01:09:23:21-GMT00:00 ... syncoid_vulcan_2025-02-01:10:14:08-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 320  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_vulcan_2025-02-01:09:23:22-GMT00:00 ... syncoid_vulcan_2025-02-01:10:14:25-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 321  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_3@syncoid_vulcan_2025-02-01:09:23:22-GMT00:00 ... syncoid_vulcan_2025-02-01:10:14:42-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 320  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_vulcan_2025-02-01:09:23:23-GMT00:00 ... syncoid_vulcan_2025-02-01:10:14:59-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 320  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_vulcan_2025-02-01:09:23:24-GMT00:00 ... syncoid_vulcan_2025-02-01:10:15:17-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 319  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_vulcan_2025-02-01:09:23:25-GMT00:00 ... syncoid_vulcan_2025-02-01:10:15:34-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 321  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_vulcan_2025-02-01:09:23:26-GMT00:00 ... syncoid_vulcan_2025-02-01:10:15:51-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 321  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_1@syncoid_vulcan_2025-02-01:09:23:26-GMT00:00 ... syncoid_vulcan_2025-02-01:10:16:08-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 319  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_1/l1_0@syncoid_vulcan_2025-02-01:09:25:08-GMT00:00 ... syncoid_vulcan_2025-02-01:10:16:25-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 320  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_vulcan_2025-02-01:09:25:09-GMT00:00 ... syncoid_vulcan_2025-02-01:10:16:42-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 333  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_vulcan_2025-02-01:09:25:10-GMT00:00 ... syncoid_vulcan_2025-02-01:10:17:00-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 319  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_vulcan_2025-02-01:09:25:10-GMT00:00 ... syncoid_vulcan_2025-02-01:10:17:17-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 320  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_vulcan_2025-02-01:09:25:11-GMT00:00 ... syncoid_vulcan_2025-02-01:10:17:34-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 320  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_1/l1_1@syncoid_vulcan_2025-02-01:09:25:12-GMT00:00 ... syncoid_vulcan_2025-02-01:10:17:51-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 320  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_vulcan_2025-02-01:09:25:13-GMT00:00 ... syncoid_vulcan_2025-02-01:10:18:08-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 321  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_vulcan_2025-02-01:09:25:14-GMT00:00 ... syncoid_vulcan_2025-02-01:10:18:25-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 321  B/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_vulcan_2025-02-01:09:25:14-GMT00:00 ... syncoid_vulcan_2025-02-01:10:18:42-GMT00:00 (~ 4 KB):
1.52KiB 0:00:04 [ 319  B/s] [====================================>                                                              ]  38%            
real 545.85
user 6.15
sys 22.34
[hbarta@vulcan ~]$
```

## 2025-02-05 third syncoid

```text
[hbarta@vulcan ~/Programming/provoke_ZFS_corruption/scripts]$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
Sending incremental send/test@syncoid_vulcan_2025-02-01:10:09:53-GMT00:00 ... syncoid_vulcan_2025-02-01:11:10:44-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [15.4KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0@syncoid_vulcan_2025-02-01:10:10:10-GMT00:00 ... syncoid_vulcan_2025-02-01:11:10:45-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [15.0KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_0@syncoid_vulcan_2025-02-01:10:10:27-GMT00:00 ... syncoid_vulcan_2025-02-01:11:10:45-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.8KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_vulcan_2025-02-01:10:10:44-GMT00:00 ... syncoid_vulcan_2025-02-01:11:10:46-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.8KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_vulcan_2025-02-01:10:11:01-GMT00:00 ... syncoid_vulcan_2025-02-01:11:10:47-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [14.1KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_vulcan_2025-02-01:10:11:18-GMT00:00 ... syncoid_vulcan_2025-02-01:11:10:48-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.3KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_vulcan_2025-02-01:10:11:35-GMT00:00 ... syncoid_vulcan_2025-02-01:11:10:49-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.5KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_1@syncoid_vulcan_2025-02-01:10:11:52-GMT00:00 ... syncoid_vulcan_2025-02-01:11:10:50-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [14.5KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_vulcan_2025-02-01:10:12:09-GMT00:00 ... syncoid_vulcan_2025-02-01:11:10:50-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.0KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_vulcan_2025-02-01:10:12:26-GMT00:00 ... syncoid_vulcan_2025-02-01:11:10:51-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.9KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_vulcan_2025-02-01:10:12:43-GMT00:00 ... syncoid_vulcan_2025-02-01:11:10:52-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [14.0KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_vulcan_2025-02-01:10:13:00-GMT00:00 ... syncoid_vulcan_2025-02-01:11:10:53-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.4KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_2@syncoid_vulcan_2025-02-01:10:13:17-GMT00:00 ... syncoid_vulcan_2025-02-01:11:10:54-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.4KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_vulcan_2025-02-01:10:13:34-GMT00:00 ... syncoid_vulcan_2025-02-01:11:10:55-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [14.1KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_vulcan_2025-02-01:10:13:51-GMT00:00 ... syncoid_vulcan_2025-02-01:11:10:55-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.1KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_vulcan_2025-02-01:10:14:08-GMT00:00 ... syncoid_vulcan_2025-02-01:11:10:56-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.0KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_vulcan_2025-02-01:10:14:25-GMT00:00 ... syncoid_vulcan_2025-02-01:11:10:57-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.8KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_3@syncoid_vulcan_2025-02-01:10:14:42-GMT00:00 ... syncoid_vulcan_2025-02-01:11:10:58-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.5KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_vulcan_2025-02-01:10:14:59-GMT00:00 ... syncoid_vulcan_2025-02-01:11:10:59-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.2KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_vulcan_2025-02-01:10:15:17-GMT00:00 ... syncoid_vulcan_2025-02-01:11:11:00-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.5KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_vulcan_2025-02-01:10:15:34-GMT00:00 ... syncoid_vulcan_2025-02-01:11:11:00-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.7KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_vulcan_2025-02-01:10:15:51-GMT00:00 ... syncoid_vulcan_2025-02-01:11:11:01-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.1KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_1@syncoid_vulcan_2025-02-01:10:16:08-GMT00:00 ... syncoid_vulcan_2025-02-01:11:11:02-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [15.0KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_1/l1_0@syncoid_vulcan_2025-02-01:10:16:25-GMT00:00 ... syncoid_vulcan_2025-02-01:11:11:03-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.0KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_vulcan_2025-02-01:10:16:42-GMT00:00 ... syncoid_vulcan_2025-02-01:11:11:04-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.9KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_vulcan_2025-02-01:10:17:00-GMT00:00 ... syncoid_vulcan_2025-02-01:11:11:05-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [14.0KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_vulcan_2025-02-01:10:17:17-GMT00:00 ... syncoid_vulcan_2025-02-01:11:11:05-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.6KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_vulcan_2025-02-01:10:17:34-GMT00:00 ... syncoid_vulcan_2025-02-01:11:11:06-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.0KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_1/l1_1@syncoid_vulcan_2025-02-01:10:17:51-GMT00:00 ... syncoid_vulcan_2025-02-01:11:11:07-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [15.0KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_vulcan_2025-02-01:10:18:08-GMT00:00 ... syncoid_vulcan_2025-02-01:11:11:08-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.5KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_vulcan_2025-02-01:10:18:25-GMT00:00 ... syncoid_vulcan_2025-02-01:11:11:09-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.9KiB/s] [====================================>                                                              ]  38%            
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_vulcan_2025-02-01:10:18:42-GMT00:00 ... syncoid_vulcan_2025-02-01:11:11:10-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.7KiB/s] [====================================>                                                              ]  38%            
real 27.20
user 4.53
sys 17.64
[hbarta@vulcan ~/Programming/provoke_ZFS_corruption/scripts]$
```

## 2025-02-08 log file list

```text
[hbarta@vulcan ~/logs]$ ls -lrt
total 83704
-rw-r--r--  1 hbarta hbarta 430915 Feb  1 16:32 2025-02-01-1629.stir_pools.159.txt
-rw-r--r--  1 hbarta hbarta  92711 Feb  1 16:35 2025-02-01-1634.stir_pools.txt
-rw-r--r--  1 hbarta hbarta 423135 Feb  1 16:38 2025-02-01-1635.stir_pools.160.txt
-rw-r--r--  1 hbarta hbarta 423834 Feb  1 16:41 2025-02-01-1638.stir_pools.159.txt
-rw-r--r--  1 hbarta hbarta 221314 Feb  1 16:42 2025-02-01-1641.stir_pools.txt
-rw-r--r--  1 hbarta hbarta    329 Feb  1 16:46 2025-02-01-1646.syncoid.1.txt
-rw-r--r--  1 hbarta hbarta    329 Feb  1 16:46 2025-02-01-1646.syncoid.0.txt
-rw-r--r--  1 hbarta hbarta   5015 Feb  1 16:51 2025-02-01-1649.syncoid.136.txt
-rw-r--r--  1 hbarta hbarta   4906 Feb  4 10:06 2025-02-04-1005.syncoid.30.txt
-rw-r--r--  1 hbarta hbarta   4906 Feb  4 10:26 2025-02-04-1025.syncoid.29.txt
-rw-r--r--  1 hbarta hbarta   2336 Feb  4 10:26 2025-02-04-1026.syncoid.txt
-rw-r--r--  1 hbarta hbarta 427750 Feb  4 10:30 2025-02-04-1027.stir_pools.163.txt
-rw-r--r--  1 hbarta hbarta   5104 Feb  4 10:30 2025-02-04-1030.syncoid.54.txt
-rw-r--r--  1 hbarta hbarta 433255 Feb  4 10:33 2025-02-04-1030.stir_pools.164.txt
-rw-r--r--  1 hbarta hbarta   4998 Feb  4 10:34 2025-02-04-1033.syncoid.53.txt
-rw-r--r--  1 hbarta hbarta 436107 Feb  4 10:37 2025-02-04-1034.stir_pools.165.txt
-rw-r--r--  1 hbarta hbarta   4998 Feb  4 10:38 2025-02-04-1037.syncoid.55.txt
-rw-r--r--  1 hbarta hbarta 435529 Feb  4 10:40 2025-02-04-1038.stir_pools.165.txt
-rw-r--r--  1 hbarta hbarta   4998 Feb  4 10:41 2025-02-04-1040.syncoid.55.txt
-rw-r--r--  1 hbarta hbarta 429377 Feb  4 10:44 2025-02-04-1041.stir_pools.162.txt
-rw-r--r--  1 hbarta hbarta   4998 Feb  4 10:45 2025-02-04-1044.syncoid.55.txt
-rw-r--r--  1 hbarta hbarta 424656 Feb  4 10:48 2025-02-04-1045.stir_pools.161.txt
-rw-r--r--  1 hbarta hbarta   4998 Feb  4 10:49 2025-02-04-1048.syncoid.55.txt
-rw-r--r--  1 hbarta hbarta 435800 Feb  4 10:51 2025-02-04-1049.stir_pools.164.txt
-rw-r--r--  1 hbarta hbarta   4998 Feb  4 10:52 2025-02-04-1051.syncoid.55.txt
-rw-r--r--  1 hbarta hbarta 426128 Feb  4 10:55 2025-02-04-1052.stir_pools.162.txt
-rw-r--r--  1 hbarta hbarta   4998 Feb  4 10:56 2025-02-04-1055.syncoid.56.txt
-rw-r--r--  1 hbarta hbarta 433167 Feb  4 10:59 2025-02-04-1056.stir_pools.164.txt
-rw-r--r--  1 hbarta hbarta   4998 Feb  4 11:00 2025-02-04-1059.syncoid.57.txt
-rw-r--r--  1 hbarta hbarta 429474 Feb  4 11:02 2025-02-04-1100.stir_pools.163.txt
-rw-r--r--  1 hbarta hbarta   4998 Feb  4 11:03 2025-02-04-1102.syncoid.57.txt
-rw-r--r--  1 hbarta hbarta 428392 Feb  4 11:06 2025-02-04-1103.stir_pools.162.txt
-rw-r--r--  1 hbarta hbarta   4998 Feb  4 11:07 2025-02-04-1106.syncoid.59.txt
-rw-r--r--  1 hbarta hbarta 427443 Feb  4 11:10 2025-02-04-1107.stir_pools.162.txt
-rw-r--r--  1 hbarta hbarta   4998 Feb  4 11:11 2025-02-04-1110.syncoid.58.txt
-rw-r--r--  1 hbarta hbarta 434623 Feb  4 11:13 2025-02-04-1111.stir_pools.165.txt
-rw-r--r--  1 hbarta hbarta   4998 Feb  4 11:14 2025-02-04-1113.syncoid.59.txt
-rw-r--r--  1 hbarta hbarta 427746 Feb  4 11:17 2025-02-04-1114.stir_pools.162.txt
-rw-r--r--  1 hbarta hbarta   4998 Feb  4 11:18 2025-02-04-1117.syncoid.59.txt
-rw-r--r--  1 hbarta hbarta     65 Feb  4 11:18 2025-02-04-1118.stir_pools.txt
-rw-r--r--  1 hbarta hbarta     80 Feb  4 11:20 2025-02-04-1120.trim_snaps.0.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:21 2025-02-04-1121.trim_snaps.4.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:26 2025-02-04-1126.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta   4935 Feb  4 11:26 2025-02-04-1125.syncoid.51.txt
-rw-r--r--  1 hbarta hbarta   4925 Feb  4 11:27 2025-02-04-1126.syncoid.47.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:27 2025-02-04-1127.trim_snaps.5.txt
-rw-r--r--  1 hbarta hbarta   4931 Feb  4 11:28 2025-02-04-1127.syncoid.50.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:28 2025-02-04-1128.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta 427620 Feb  4 11:28 2025-02-04-1125.stir_pools.192.txt
-rw-r--r--  1 hbarta hbarta   4943 Feb  4 11:29 2025-02-04-1128.syncoid.53.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:29 2025-02-04-1129.trim_snaps.5.txt
-rw-r--r--  1 hbarta hbarta   4939 Feb  4 11:29 2025-02-04-1129.syncoid.54.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:30 2025-02-04-1130.trim_snaps.5.txt
-rw-r--r--  1 hbarta hbarta   4923 Feb  4 11:30 2025-02-04-1129.syncoid.48.txt
-rw-r--r--  1 hbarta hbarta   4935 Feb  4 11:31 2025-02-04-1130.syncoid.51.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:31 2025-02-04-1131.trim_snaps.5.txt
-rw-r--r--  1 hbarta hbarta 427374 Feb  4 11:31 2025-02-04-1128.stir_pools.193.txt
-rw-r--r--  1 hbarta hbarta   4942 Feb  4 11:32 2025-02-04-1131.syncoid.56.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:32 2025-02-04-1132.trim_snaps.5.txt
-rw-r--r--  1 hbarta hbarta   4937 Feb  4 11:33 2025-02-04-1132.syncoid.52.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:33 2025-02-04-1133.trim_snaps.5.txt
-rw-r--r--  1 hbarta hbarta   4927 Feb  4 11:34 2025-02-04-1133.syncoid.49.txt
-rw-r--r--  1 hbarta hbarta   4938 Feb  4 11:35 2025-02-04-1134.syncoid.52.txt
-rw-r--r--  1 hbarta hbarta 426221 Feb  4 11:35 2025-02-04-1131.stir_pools.194.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:35 2025-02-04-1135.trim_snaps.5.txt
-rw-r--r--  1 hbarta hbarta   4949 Feb  4 11:36 2025-02-04-1135.syncoid.58.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:36 2025-02-04-1136.trim_snaps.5.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:37 2025-02-04-1137.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta   4928 Feb  4 11:37 2025-02-04-1136.syncoid.48.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:38 2025-02-04-1138.trim_snaps.5.txt
-rw-r--r--  1 hbarta hbarta 428067 Feb  4 11:38 2025-02-04-1135.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   4937 Feb  4 11:38 2025-02-04-1137.syncoid.53.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:39 2025-02-04-1139.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta   4950 Feb  4 11:39 2025-02-04-1138.syncoid.60.txt
-rw-r--r--  1 hbarta hbarta   4925 Feb  4 11:40 2025-02-04-1139.syncoid.51.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:40 2025-02-04-1140.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta   4933 Feb  4 11:41 2025-02-04-1140.syncoid.53.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:41 2025-02-04-1141.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta 426428 Feb  4 11:41 2025-02-04-1138.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   4947 Feb  4 11:42 2025-02-04-1141.syncoid.57.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:42 2025-02-04-1142.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta   4940 Feb  4 11:43 2025-02-04-1142.syncoid.56.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:43 2025-02-04-1143.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta   4923 Feb  4 11:44 2025-02-04-1143.syncoid.50.txt
-rw-r--r--  1 hbarta hbarta   4938 Feb  4 11:44 2025-02-04-1144.syncoid.54.txt
-rw-r--r--  1 hbarta hbarta 427628 Feb  4 11:44 2025-02-04-1141.stir_pools.194.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:44 2025-02-04-1144.trim_snaps.5.txt
-rw-r--r--  1 hbarta hbarta   4953 Feb  4 11:45 2025-02-04-1144.syncoid.63.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:46 2025-02-04-1145.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta   4930 Feb  4 11:46 2025-02-04-1145.syncoid.52.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:47 2025-02-04-1147.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta   4929 Feb  4 11:47 2025-02-04-1146.syncoid.52.txt
-rw-r--r--  1 hbarta hbarta 427476 Feb  4 11:48 2025-02-04-1144.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:48 2025-02-04-1148.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta   4946 Feb  4 11:48 2025-02-04-1147.syncoid.57.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:49 2025-02-04-1149.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta   4942 Feb  4 11:49 2025-02-04-1148.syncoid.58.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:50 2025-02-04-1150.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta   4923 Feb  4 11:50 2025-02-04-1149.syncoid.51.txt
-rw-r--r--  1 hbarta hbarta   4938 Feb  4 11:51 2025-02-04-1150.syncoid.55.txt
-rw-r--r--  1 hbarta hbarta 432007 Feb  4 11:51 2025-02-04-1148.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:51 2025-02-04-1151.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta   4950 Feb  4 11:52 2025-02-04-1151.syncoid.62.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:52 2025-02-04-1152.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta   4931 Feb  4 11:53 2025-02-04-1152.syncoid.54.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:53 2025-02-04-1153.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta   4929 Feb  4 11:54 2025-02-04-1153.syncoid.53.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:54 2025-02-04-1154.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta 432288 Feb  4 11:54 2025-02-04-1151.stir_pools.200.txt
-rw-r--r--  1 hbarta hbarta   4942 Feb  4 11:55 2025-02-04-1154.syncoid.57.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:55 2025-02-04-1155.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta   4948 Feb  4 11:56 2025-02-04-1155.syncoid.61.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:57 2025-02-04-1156.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta   4925 Feb  4 11:57 2025-02-04-1156.syncoid.53.txt
-rw-r--r--  1 hbarta hbarta   4938 Feb  4 11:58 2025-02-04-1157.syncoid.57.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:58 2025-02-04-1158.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta 430371 Feb  4 11:58 2025-02-04-1154.stir_pools.198.txt
-rw-r--r--  1 hbarta hbarta   4952 Feb  4 11:59 2025-02-04-1158.syncoid.62.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 11:59 2025-02-04-1159.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta   4933 Feb  4 12:00 2025-02-04-1159.syncoid.55.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:00 2025-02-04-1200.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta   4929 Feb  4 12:00 2025-02-04-1200.syncoid.53.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:01 2025-02-04-1201.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta 431047 Feb  4 12:01 2025-02-04-1158.stir_pools.200.txt
-rw-r--r--  1 hbarta hbarta   4949 Feb  4 12:01 2025-02-04-1200.syncoid.59.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:02 2025-02-04-1202.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta   4945 Feb  4 12:02 2025-02-04-1201.syncoid.62.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:03 2025-02-04-1203.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta   4923 Feb  4 12:03 2025-02-04-1202.syncoid.53.txt
-rw-r--r--  1 hbarta hbarta   4938 Feb  4 12:04 2025-02-04-1203.syncoid.57.txt
-rw-r--r--  1 hbarta hbarta 422996 Feb  4 12:04 2025-02-04-1201.stir_pools.195.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:04 2025-02-04-1204.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta   4953 Feb  4 12:05 2025-02-04-1204.syncoid.65.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:05 2025-02-04-1205.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta   4930 Feb  4 12:06 2025-02-04-1205.syncoid.55.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:07 2025-02-04-1206.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta   4932 Feb  4 12:07 2025-02-04-1206.syncoid.54.txt
-rw-r--r--  1 hbarta hbarta 435615 Feb  4 12:08 2025-02-04-1204.stir_pools.202.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:08 2025-02-04-1208.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta   4949 Feb  4 12:08 2025-02-04-1207.syncoid.61.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:09 2025-02-04-1209.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta   4942 Feb  4 12:09 2025-02-04-1208.syncoid.60.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:10 2025-02-04-1210.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta   4927 Feb  4 12:10 2025-02-04-1209.syncoid.54.txt
-rw-r--r--  1 hbarta hbarta 427572 Feb  4 12:11 2025-02-04-1208.stir_pools.196.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:11 2025-02-04-1211.trim_snaps.6.txt
-rw-r--r--  1 hbarta hbarta   4943 Feb  4 12:11 2025-02-04-1210.syncoid.59.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:12 2025-02-04-1212.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta   4952 Feb  4 12:12 2025-02-04-1211.syncoid.65.txt
-rw-r--r--  1 hbarta hbarta   4925 Feb  4 12:13 2025-02-04-1212.syncoid.54.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:13 2025-02-04-1213.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta   4937 Feb  4 12:14 2025-02-04-1213.syncoid.57.txt
-rw-r--r--  1 hbarta hbarta 422023 Feb  4 12:14 2025-02-04-1211.stir_pools.194.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:14 2025-02-04-1214.trim_snaps.8.txt
-rw-r--r--  1 hbarta hbarta   4953 Feb  4 12:15 2025-02-04-1214.syncoid.65.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:16 2025-02-04-1215.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta   4935 Feb  4 12:16 2025-02-04-1215.syncoid.57.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:17 2025-02-04-1217.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta   4933 Feb  4 12:17 2025-02-04-1216.syncoid.55.txt
-rw-r--r--  1 hbarta hbarta 422838 Feb  4 12:17 2025-02-04-1214.stir_pools.195.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:18 2025-02-04-1218.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta   4951 Feb  4 12:18 2025-02-04-1217.syncoid.62.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:19 2025-02-04-1219.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta   4942 Feb  4 12:19 2025-02-04-1218.syncoid.60.txt
-rw-r--r--  1 hbarta hbarta   4927 Feb  4 12:20 2025-02-04-1219.syncoid.54.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:20 2025-02-04-1220.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta 428938 Feb  4 12:21 2025-02-04-1217.stir_pools.195.txt
-rw-r--r--  1 hbarta hbarta   4945 Feb  4 12:21 2025-02-04-1220.syncoid.61.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:21 2025-02-04-1221.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta   4950 Feb  4 12:22 2025-02-04-1221.syncoid.66.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:22 2025-02-04-1222.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta   4925 Feb  4 12:23 2025-02-04-1222.syncoid.55.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:23 2025-02-04-1223.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta   4938 Feb  4 12:24 2025-02-04-1223.syncoid.59.txt
-rw-r--r--  1 hbarta hbarta 427898 Feb  4 12:24 2025-02-04-1221.stir_pools.196.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:25 2025-02-04-1224.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta   4955 Feb  4 12:25 2025-02-04-1224.syncoid.66.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:26 2025-02-04-1226.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta   4929 Feb  4 12:26 2025-02-04-1225.syncoid.57.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:27 2025-02-04-1227.trim_snaps.8.txt
-rw-r--r--  1 hbarta hbarta   4937 Feb  4 12:27 2025-02-04-1226.syncoid.58.txt
-rw-r--r--  1 hbarta hbarta 423900 Feb  4 12:27 2025-02-04-1224.stir_pools.196.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:28 2025-02-04-1228.trim_snaps.8.txt
-rw-r--r--  1 hbarta hbarta   4949 Feb  4 12:28 2025-02-04-1227.syncoid.64.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:29 2025-02-04-1229.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta   4937 Feb  4 12:29 2025-02-04-1228.syncoid.60.txt
-rw-r--r--  1 hbarta hbarta   4929 Feb  4 12:30 2025-02-04-1229.syncoid.56.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:30 2025-02-04-1230.trim_snaps.8.txt
-rw-r--r--  1 hbarta hbarta 426265 Feb  4 12:31 2025-02-04-1227.stir_pools.198.txt
-rw-r--r--  1 hbarta hbarta   4951 Feb  4 12:31 2025-02-04-1230.syncoid.63.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:31 2025-02-04-1231.trim_snaps.8.txt
-rw-r--r--  1 hbarta hbarta   4945 Feb  4 12:32 2025-02-04-1231.syncoid.63.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:32 2025-02-04-1232.trim_snaps.8.txt
-rw-r--r--  1 hbarta hbarta   4925 Feb  4 12:33 2025-02-04-1232.syncoid.56.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:34 2025-02-04-1233.trim_snaps.8.txt
-rw-r--r--  1 hbarta hbarta 431896 Feb  4 12:34 2025-02-04-1231.stir_pools.199.txt
-rw-r--r--  1 hbarta hbarta   4943 Feb  4 12:34 2025-02-04-1233.syncoid.62.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:35 2025-02-04-1235.trim_snaps.7.txt
-rw-r--r--  1 hbarta hbarta   4952 Feb  4 12:35 2025-02-04-1234.syncoid.67.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:36 2025-02-04-1236.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta   4925 Feb  4 12:36 2025-02-04-1235.syncoid.57.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:37 2025-02-04-1237.trim_snaps.8.txt
-rw-r--r--  1 hbarta hbarta   4938 Feb  4 12:37 2025-02-04-1236.syncoid.60.txt
-rw-r--r--  1 hbarta hbarta 429475 Feb  4 12:37 2025-02-04-1234.stir_pools.199.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:38 2025-02-04-1238.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta   4954 Feb  4 12:38 2025-02-04-1237.syncoid.68.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:39 2025-02-04-1239.trim_snaps.8.txt
-rw-r--r--  1 hbarta hbarta   4929 Feb  4 12:39 2025-02-04-1238.syncoid.58.txt
-rw-r--r--  1 hbarta hbarta   4937 Feb  4 12:40 2025-02-04-1239.syncoid.59.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:40 2025-02-04-1240.trim_snaps.8.txt
-rw-r--r--  1 hbarta hbarta 426097 Feb  4 12:41 2025-02-04-1237.stir_pools.198.txt
-rw-r--r--  1 hbarta hbarta   4954 Feb  4 12:41 2025-02-04-1240.syncoid.68.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:42 2025-02-04-1241.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta   4938 Feb  4 12:42 2025-02-04-1241.syncoid.62.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:43 2025-02-04-1243.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta   4933 Feb  4 12:43 2025-02-04-1242.syncoid.59.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:44 2025-02-04-1244.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta 433236 Feb  4 12:44 2025-02-04-1241.stir_pools.200.txt
-rw-r--r--  1 hbarta hbarta   4953 Feb  4 12:45 2025-02-04-1243.syncoid.67.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:45 2025-02-04-1245.trim_snaps.8.txt
-rw-r--r--  1 hbarta hbarta   4943 Feb  4 12:46 2025-02-04-1245.syncoid.64.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:46 2025-02-04-1246.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta   4929 Feb  4 12:47 2025-02-04-1246.syncoid.59.txt
-rw-r--r--  1 hbarta hbarta 426474 Feb  4 12:47 2025-02-04-1244.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:47 2025-02-04-1247.trim_snaps.8.txt
-rw-r--r--  1 hbarta hbarta   4953 Feb  4 12:48 2025-02-04-1247.syncoid.66.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:48 2025-02-04-1248.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta   4948 Feb  4 12:49 2025-02-04-1248.syncoid.66.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:50 2025-02-04-1249.trim_snaps.8.txt
-rw-r--r--  1 hbarta hbarta   4931 Feb  4 12:50 2025-02-04-1249.syncoid.59.txt
-rw-r--r--  1 hbarta hbarta 428137 Feb  4 12:51 2025-02-04-1247.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:51 2025-02-04-1251.trim_snaps.8.txt
-rw-r--r--  1 hbarta hbarta   4951 Feb  4 12:51 2025-02-04-1250.syncoid.66.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:52 2025-02-04-1252.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta   4946 Feb  4 12:52 2025-02-04-1251.syncoid.68.txt
-rw-r--r--  1 hbarta hbarta   4923 Feb  4 12:53 2025-02-04-1252.syncoid.58.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:53 2025-02-04-1253.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta 429780 Feb  4 12:54 2025-02-04-1251.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   4946 Feb  4 12:54 2025-02-04-1253.syncoid.64.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:54 2025-02-04-1254.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta   4950 Feb  4 12:55 2025-02-04-1254.syncoid.68.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:55 2025-02-04-1255.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta   4923 Feb  4 12:56 2025-02-04-1255.syncoid.58.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:56 2025-02-04-1256.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta 429708 Feb  4 12:57 2025-02-04-1254.stir_pools.198.txt
-rw-r--r--  1 hbarta hbarta   4941 Feb  4 12:57 2025-02-04-1256.syncoid.63.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:58 2025-02-04-1257.trim_snaps.10.txt
-rw-r--r--  1 hbarta hbarta   4953 Feb  4 12:58 2025-02-04-1257.syncoid.70.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 12:59 2025-02-04-1259.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta   4925 Feb  4 12:59 2025-02-04-1258.syncoid.59.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:00 2025-02-04-1300.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta 424971 Feb  4 13:00 2025-02-04-1257.stir_pools.196.txt
-rw-r--r--  1 hbarta hbarta   4940 Feb  4 13:00 2025-02-04-1259.syncoid.63.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:01 2025-02-04-1301.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta   4953 Feb  4 13:02 2025-02-04-1300.syncoid.71.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:02 2025-02-04-1302.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta   4925 Feb  4 13:03 2025-02-04-1302.syncoid.60.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:03 2025-02-04-1303.trim_snaps.8.txt
-rw-r--r--  1 hbarta hbarta   4938 Feb  4 13:04 2025-02-04-1303.syncoid.63.txt
-rw-r--r--  1 hbarta hbarta 434327 Feb  4 13:04 2025-02-04-1300.stir_pools.201.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:05 2025-02-04-1304.trim_snaps.10.txt
-rw-r--r--  1 hbarta hbarta   4955 Feb  4 13:05 2025-02-04-1304.syncoid.72.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:06 2025-02-04-1306.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta   4927 Feb  4 13:06 2025-02-04-1305.syncoid.60.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:07 2025-02-04-1307.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta   4938 Feb  4 13:07 2025-02-04-1306.syncoid.63.txt
-rw-r--r--  1 hbarta hbarta 434095 Feb  4 13:07 2025-02-04-1304.stir_pools.200.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:08 2025-02-04-1308.trim_snaps.10.txt
-rw-r--r--  1 hbarta hbarta   4956 Feb  4 13:08 2025-02-04-1307.syncoid.71.txt
-rw-r--r--  1 hbarta hbarta   4929 Feb  4 13:09 2025-02-04-1308.syncoid.61.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:09 2025-02-04-1309.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta   4937 Feb  4 13:10 2025-02-04-1309.syncoid.63.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:10 2025-02-04-1310.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta 428877 Feb  4 13:10 2025-02-04-1307.stir_pools.199.txt
-rw-r--r--  1 hbarta hbarta   4955 Feb  4 13:11 2025-02-04-1310.syncoid.72.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:12 2025-02-04-1311.trim_snaps.10.txt
-rw-r--r--  1 hbarta hbarta   4931 Feb  4 13:12 2025-02-04-1311.syncoid.63.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:13 2025-02-04-1313.trim_snaps.10.txt
-rw-r--r--  1 hbarta hbarta   4937 Feb  4 13:14 2025-02-04-1312.syncoid.64.txt
-rw-r--r--  1 hbarta hbarta 435377 Feb  4 13:14 2025-02-04-1310.stir_pools.199.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:14 2025-02-04-1314.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta   4955 Feb  4 13:15 2025-02-04-1314.syncoid.71.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:15 2025-02-04-1315.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta   4931 Feb  4 13:16 2025-02-04-1315.syncoid.63.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:16 2025-02-04-1316.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta   4939 Feb  4 13:17 2025-02-04-1316.syncoid.63.txt
-rw-r--r--  1 hbarta hbarta 428358 Feb  4 13:17 2025-02-04-1314.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:17 2025-02-04-1317.trim_snaps.10.txt
-rw-r--r--  1 hbarta hbarta   4955 Feb  4 13:18 2025-02-04-1317.syncoid.72.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:19 2025-02-04-1318.trim_snaps.10.txt
-rw-r--r--  1 hbarta hbarta   4932 Feb  4 13:19 2025-02-04-1318.syncoid.63.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:20 2025-02-04-1320.trim_snaps.10.txt
-rw-r--r--  1 hbarta hbarta   4939 Feb  4 13:20 2025-02-04-1319.syncoid.64.txt
-rw-r--r--  1 hbarta hbarta 429514 Feb  4 13:20 2025-02-04-1317.stir_pools.199.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:21 2025-02-04-1321.trim_snaps.10.txt
-rw-r--r--  1 hbarta hbarta   4957 Feb  4 13:21 2025-02-04-1320.syncoid.73.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:22 2025-02-04-1322.trim_snaps.10.txt
-rw-r--r--  1 hbarta hbarta   4931 Feb  4 13:22 2025-02-04-1321.syncoid.63.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:23 2025-02-04-1323.trim_snaps.10.txt
-rw-r--r--  1 hbarta hbarta   4938 Feb  4 13:24 2025-02-04-1322.syncoid.64.txt
-rw-r--r--  1 hbarta hbarta 426945 Feb  4 13:24 2025-02-04-1320.stir_pools.196.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:24 2025-02-04-1324.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta   4956 Feb  4 13:25 2025-02-04-1324.syncoid.73.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:26 2025-02-04-1325.trim_snaps.10.txt
-rw-r--r--  1 hbarta hbarta   4927 Feb  4 13:26 2025-02-04-1325.syncoid.62.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:27 2025-02-04-1327.trim_snaps.9.txt
-rw-r--r--  1 hbarta hbarta 425624 Feb  4 13:27 2025-02-04-1324.stir_pools.196.txt
-rw-r--r--  1 hbarta hbarta   4938 Feb  4 13:27 2025-02-04-1326.syncoid.65.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:28 2025-02-04-1328.trim_snaps.11.txt
-rw-r--r--  1 hbarta hbarta   4955 Feb  4 13:28 2025-02-04-1327.syncoid.74.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:29 2025-02-04-1329.trim_snaps.10.txt
-rw-r--r--  1 hbarta hbarta   4925 Feb  4 13:29 2025-02-04-1328.syncoid.62.txt
-rw-r--r--  1 hbarta hbarta 426555 Feb  4 13:30 2025-02-04-1327.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:30 2025-02-04-1330.trim_snaps.10.txt
-rw-r--r--  1 hbarta hbarta   4938 Feb  4 13:30 2025-02-04-1329.syncoid.65.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:31 2025-02-04-1331.trim_snaps.11.txt
-rw-r--r--  1 hbarta hbarta   4954 Feb  4 13:32 2025-02-04-1330.syncoid.75.txt
-rw-r--r--  1 hbarta hbarta   4925 Feb  4 13:33 2025-02-04-1332.syncoid.63.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:33 2025-02-04-1332.trim_snaps.10.txt
-rw-r--r--  1 hbarta hbarta 427045 Feb  4 13:33 2025-02-04-1330.stir_pools.196.txt
-rw-r--r--  1 hbarta hbarta   4940 Feb  4 13:34 2025-02-04-1333.syncoid.67.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:34 2025-02-04-1334.trim_snaps.11.txt
-rw-r--r--  1 hbarta hbarta   4953 Feb  4 13:35 2025-02-04-1334.syncoid.75.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:35 2025-02-04-1335.trim_snaps.11.txt
-rw-r--r--  1 hbarta hbarta   4925 Feb  4 13:36 2025-02-04-1335.syncoid.62.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:36 2025-02-04-1336.trim_snaps.10.txt
-rw-r--r--  1 hbarta hbarta 429757 Feb  4 13:37 2025-02-04-1333.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   4946 Feb  4 13:37 2025-02-04-1336.syncoid.70.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:37 2025-02-04-1337.trim_snaps.11.txt
-rw-r--r--  1 hbarta hbarta   4947 Feb  4 13:38 2025-02-04-1337.syncoid.72.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:38 2025-02-04-1338.trim_snaps.11.txt
-rw-r--r--  1 hbarta hbarta   4931 Feb  4 13:39 2025-02-04-1338.syncoid.63.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:40 2025-02-04-1339.trim_snaps.11.txt
-rw-r--r--  1 hbarta hbarta 432062 Feb  4 13:40 2025-02-04-1337.stir_pools.199.txt
-rw-r--r--  1 hbarta hbarta   4956 Feb  4 13:41 2025-02-04-1339.syncoid.72.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:41 2025-02-04-1341.trim_snaps.11.txt
-rw-r--r--  1 hbarta hbarta   4954 Feb  4 13:42 2025-02-04-1341.syncoid.73.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:42 2025-02-04-1342.trim_snaps.11.txt
-rw-r--r--  1 hbarta hbarta   4933 Feb  4 13:43 2025-02-04-1342.syncoid.64.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:43 2025-02-04-1343.trim_snaps.11.txt
-rw-r--r--  1 hbarta hbarta 425303 Feb  4 13:43 2025-02-04-1340.stir_pools.195.txt
-rw-r--r--  1 hbarta hbarta   4966 Feb  4 13:44 2025-02-04-1343.syncoid.75.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:44 2025-02-04-1344.trim_snaps.11.txt
-rw-r--r--  1 hbarta hbarta   4945 Feb  4 13:45 2025-02-04-1344.syncoid.71.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:46 2025-02-04-1345.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta   4940 Feb  4 13:46 2025-02-04-1345.syncoid.67.txt
-rw-r--r--  1 hbarta hbarta 427677 Feb  4 13:47 2025-02-04-1343.stir_pools.194.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:47 2025-02-04-1347.trim_snaps.11.txt
-rw-r--r--  1 hbarta hbarta   4959 Feb  4 13:48 2025-02-04-1346.syncoid.76.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:48 2025-02-04-1348.trim_snaps.11.txt
-rw-r--r--  1 hbarta hbarta   4930 Feb  4 13:49 2025-02-04-1348.syncoid.66.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:49 2025-02-04-1349.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta 434368 Feb  4 13:50 2025-02-04-1347.stir_pools.200.txt
-rw-r--r--  1 hbarta hbarta   4938 Feb  4 13:50 2025-02-04-1349.syncoid.68.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:50 2025-02-04-1350.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta   4954 Feb  4 13:51 2025-02-04-1350.syncoid.77.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:52 2025-02-04-1351.trim_snaps.11.txt
-rw-r--r--  1 hbarta hbarta   4925 Feb  4 13:52 2025-02-04-1351.syncoid.64.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:53 2025-02-04-1353.trim_snaps.11.txt
-rw-r--r--  1 hbarta hbarta 424964 Feb  4 13:53 2025-02-04-1350.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   4941 Feb  4 13:53 2025-02-04-1352.syncoid.69.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:54 2025-02-04-1354.trim_snaps.13.txt
-rw-r--r--  1 hbarta hbarta   4953 Feb  4 13:55 2025-02-04-1353.syncoid.76.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:55 2025-02-04-1355.trim_snaps.11.txt
-rw-r--r--  1 hbarta hbarta   4923 Feb  4 13:56 2025-02-04-1355.syncoid.64.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:56 2025-02-04-1356.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta 426123 Feb  4 13:57 2025-02-04-1353.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   4957 Feb  4 13:57 2025-02-04-1356.syncoid.74.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:58 2025-02-04-1357.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta   4954 Feb  4 13:58 2025-02-04-1357.syncoid.74.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 13:59 2025-02-04-1359.trim_snaps.11.txt
-rw-r--r--  1 hbarta hbarta   4935 Feb  4 13:59 2025-02-04-1358.syncoid.66.txt
-rw-r--r--  1 hbarta hbarta 429792 Feb  4 14:00 2025-02-04-1357.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:00 2025-02-04-1400.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta   4968 Feb  4 14:01 2025-02-04-1359.syncoid.78.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:01 2025-02-04-1401.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta   4943 Feb  4 14:02 2025-02-04-1401.syncoid.69.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:02 2025-02-04-1402.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta   4938 Feb  4 14:03 2025-02-04-1402.syncoid.68.txt
-rw-r--r--  1 hbarta hbarta 429923 Feb  4 14:03 2025-02-04-1400.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:04 2025-02-04-1403.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta   4959 Feb  4 14:04 2025-02-04-1403.syncoid.77.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:05 2025-02-04-1405.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta   4927 Feb  4 14:05 2025-02-04-1404.syncoid.67.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:06 2025-02-04-1406.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta 425941 Feb  4 14:06 2025-02-04-1403.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   4938 Feb  4 14:07 2025-02-04-1405.syncoid.69.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:07 2025-02-04-1407.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta   4953 Feb  4 14:08 2025-02-04-1407.syncoid.78.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:08 2025-02-04-1408.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta   4926 Feb  4 14:09 2025-02-04-1408.syncoid.66.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:10 2025-02-04-1409.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta 431836 Feb  4 14:10 2025-02-04-1406.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   4950 Feb  4 14:10 2025-02-04-1409.syncoid.74.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:11 2025-02-04-1411.trim_snaps.13.txt
-rw-r--r--  1 hbarta hbarta   4954 Feb  4 14:11 2025-02-04-1410.syncoid.78.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:12 2025-02-04-1412.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta   4935 Feb  4 14:13 2025-02-04-1411.syncoid.68.txt
-rw-r--r--  1 hbarta hbarta 429222 Feb  4 14:13 2025-02-04-1410.stir_pools.195.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:13 2025-02-04-1413.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta   4968 Feb  4 14:14 2025-02-04-1413.syncoid.81.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:14 2025-02-04-1414.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta   4936 Feb  4 14:15 2025-02-04-1414.syncoid.70.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:16 2025-02-04-1415.trim_snaps.13.txt
-rw-r--r--  1 hbarta hbarta 431331 Feb  4 14:16 2025-02-04-1413.stir_pools.195.txt
-rw-r--r--  1 hbarta hbarta   4941 Feb  4 14:16 2025-02-04-1415.syncoid.70.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:17 2025-02-04-1417.trim_snaps.13.txt
-rw-r--r--  1 hbarta hbarta   4955 Feb  4 14:18 2025-02-04-1416.syncoid.80.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:18 2025-02-04-1418.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta   4925 Feb  4 14:19 2025-02-04-1418.syncoid.68.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:19 2025-02-04-1419.trim_snaps.13.txt
-rw-r--r--  1 hbarta hbarta 428628 Feb  4 14:20 2025-02-04-1416.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   4950 Feb  4 14:20 2025-02-04-1419.syncoid.75.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:20 2025-02-04-1420.trim_snaps.13.txt
-rw-r--r--  1 hbarta hbarta   4955 Feb  4 14:21 2025-02-04-1420.syncoid.78.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:22 2025-02-04-1421.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta   4937 Feb  4 14:23 2025-02-04-1421.syncoid.69.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:23 2025-02-04-1423.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta 432717 Feb  4 14:23 2025-02-04-1420.stir_pools.199.txt
-rw-r--r--  1 hbarta hbarta   4969 Feb  4 14:24 2025-02-04-1423.syncoid.81.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:24 2025-02-04-1424.trim_snaps.13.txt
-rw-r--r--  1 hbarta hbarta   4936 Feb  4 14:25 2025-02-04-1424.syncoid.71.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:25 2025-02-04-1425.trim_snaps.13.txt
-rw-r--r--  1 hbarta hbarta 428579 Feb  4 14:26 2025-02-04-1423.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   4941 Feb  4 14:26 2025-02-04-1425.syncoid.72.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:26 2025-02-04-1426.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta   4955 Feb  4 14:28 2025-02-04-1426.syncoid.81.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:28 2025-02-04-1427.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta   4925 Feb  4 14:29 2025-02-04-1428.syncoid.68.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:29 2025-02-04-1429.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta 425982 Feb  4 14:30 2025-02-04-1426.stir_pools.198.txt
-rw-r--r--  1 hbarta hbarta   4954 Feb  4 14:30 2025-02-04-1429.syncoid.77.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:30 2025-02-04-1430.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:31 2025-02-04-1431.trim_snaps.14.txt
-rw-r--r--  1 hbarta hbarta   4955 Feb  4 14:31 2025-02-04-1430.syncoid.80.txt
-rw-r--r--  1 hbarta hbarta   4939 Feb  4 14:33 2025-02-04-1431.syncoid.71.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:33 2025-02-04-1432.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta 429269 Feb  4 14:33 2025-02-04-1430.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:34 2025-02-04-1434.trim_snaps.14.txt
-rw-r--r--  1 hbarta hbarta   4971 Feb  4 14:34 2025-02-04-1433.syncoid.83.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:35 2025-02-04-1435.trim_snaps.13.txt
-rw-r--r--  1 hbarta hbarta   4929 Feb  4 14:35 2025-02-04-1434.syncoid.70.txt
-rw-r--r--  1 hbarta hbarta 431211 Feb  4 14:36 2025-02-04-1433.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:36 2025-02-04-1436.trim_snaps.12.txt
-rw-r--r--  1 hbarta hbarta   4940 Feb  4 14:36 2025-02-04-1435.syncoid.73.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:37 2025-02-04-1437.trim_snaps.14.txt
-rw-r--r--  1 hbarta hbarta   4953 Feb  4 14:38 2025-02-04-1436.syncoid.80.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:39 2025-02-04-1438.trim_snaps.13.txt
-rw-r--r--  1 hbarta hbarta   4931 Feb  4 14:39 2025-02-04-1438.syncoid.70.txt
-rw-r--r--  1 hbarta hbarta 426882 Feb  4 14:39 2025-02-04-1436.stir_pools.195.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:40 2025-02-04-1440.trim_snaps.13.txt
-rw-r--r--  1 hbarta hbarta   4973 Feb  4 14:40 2025-02-04-1439.syncoid.82.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:41 2025-02-04-1441.trim_snaps.14.txt
-rw-r--r--  1 hbarta hbarta   4944 Feb  4 14:41 2025-02-04-1440.syncoid.75.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:42 2025-02-04-1442.trim_snaps.13.txt
-rw-r--r--  1 hbarta hbarta 425902 Feb  4 14:43 2025-02-04-1439.stir_pools.199.txt
-rw-r--r--  1 hbarta hbarta   4940 Feb  4 14:43 2025-02-04-1441.syncoid.73.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:44 2025-02-04-1443.trim_snaps.13.txt
-rw-r--r--  1 hbarta hbarta   4955 Feb  4 14:44 2025-02-04-1443.syncoid.82.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:45 2025-02-04-1445.trim_snaps.13.txt
-rw-r--r--  1 hbarta hbarta   4925 Feb  4 14:45 2025-02-04-1444.syncoid.69.txt
-rw-r--r--  1 hbarta hbarta 430198 Feb  4 14:46 2025-02-04-1443.stir_pools.200.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:46 2025-02-04-1446.trim_snaps.13.txt
-rw-r--r--  1 hbarta hbarta   4950 Feb  4 14:46 2025-02-04-1445.syncoid.76.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:47 2025-02-04-1447.trim_snaps.13.txt
-rw-r--r--  1 hbarta hbarta   4954 Feb  4 14:48 2025-02-04-1446.syncoid.81.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:48 2025-02-04-1448.trim_snaps.13.txt
-rw-r--r--  1 hbarta hbarta   4939 Feb  4 14:49 2025-02-04-1448.syncoid.72.txt
-rw-r--r--  1 hbarta hbarta 428531 Feb  4 14:49 2025-02-04-1446.stir_pools.195.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:50 2025-02-04-1449.trim_snaps.14.txt
-rw-r--r--  1 hbarta hbarta   4971 Feb  4 14:50 2025-02-04-1449.syncoid.85.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:51 2025-02-04-1451.trim_snaps.13.txt
-rw-r--r--  1 hbarta hbarta   4930 Feb  4 14:52 2025-02-04-1450.syncoid.71.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:52 2025-02-04-1452.trim_snaps.14.txt
-rw-r--r--  1 hbarta hbarta 435001 Feb  4 14:53 2025-02-04-1449.stir_pools.201.txt
-rw-r--r--  1 hbarta hbarta   4942 Feb  4 14:53 2025-02-04-1452.syncoid.74.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:53 2025-02-04-1453.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4952 Feb  4 14:54 2025-02-04-1453.syncoid.81.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:55 2025-02-04-1454.trim_snaps.14.txt
-rw-r--r--  1 hbarta hbarta   4935 Feb  4 14:55 2025-02-04-1454.syncoid.72.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:56 2025-02-04-1456.trim_snaps.14.txt
-rw-r--r--  1 hbarta hbarta 431059 Feb  4 14:56 2025-02-04-1453.stir_pools.198.txt
-rw-r--r--  1 hbarta hbarta   4970 Feb  4 14:57 2025-02-04-1455.syncoid.86.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:57 2025-02-04-1457.trim_snaps.14.txt
-rw-r--r--  1 hbarta hbarta   4938 Feb  4 14:58 2025-02-04-1457.syncoid.75.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 14:58 2025-02-04-1458.trim_snaps.14.txt
-rw-r--r--  1 hbarta hbarta 431688 Feb  4 14:59 2025-02-04-1456.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   4939 Feb  4 14:59 2025-02-04-1458.syncoid.74.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 15:00 2025-02-04-1459.trim_snaps.14.txt
-rw-r--r--  1 hbarta hbarta   4955 Feb  4 15:01 2025-02-04-1459.syncoid.84.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 15:01 2025-02-04-1501.trim_snaps.14.txt
-rw-r--r--  1 hbarta hbarta   4927 Feb  4 15:02 2025-02-04-1501.syncoid.71.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 15:02 2025-02-04-1502.trim_snaps.14.txt
-rw-r--r--  1 hbarta hbarta 427986 Feb  4 15:03 2025-02-04-1459.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 15:03 2025-02-04-1503.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4976 Feb  4 15:03 2025-02-04-1502.syncoid.85.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 15:05 2025-02-04-1504.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4944 Feb  4 15:05 2025-02-04-1503.syncoid.78.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 15:06 2025-02-04-1506.trim_snaps.14.txt
-rw-r--r--  1 hbarta hbarta 427063 Feb  4 15:06 2025-02-04-1503.stir_pools.196.txt
-rw-r--r--  1 hbarta hbarta   4941 Feb  4 15:06 2025-02-04-1505.syncoid.75.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 15:07 2025-02-04-1507.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4954 Feb  4 15:07 2025-02-04-1506.syncoid.83.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 15:08 2025-02-04-1508.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4929 Feb  4 15:09 2025-02-04-1507.syncoid.74.txt
-rw-r--r--  1 hbarta hbarta 436573 Feb  4 15:09 2025-02-04-1506.stir_pools.202.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 15:10 2025-02-04-1509.trim_snaps.14.txt
-rw-r--r--  1 hbarta hbarta   4971 Feb  4 15:10 2025-02-04-1509.syncoid.85.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 15:11 2025-02-04-1511.trim_snaps.14.txt
-rw-r--r--  1 hbarta hbarta   4946 Feb  4 15:11 2025-02-04-1510.syncoid.81.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 15:12 2025-02-04-1512.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta 433660 Feb  4 15:13 2025-02-04-1509.stir_pools.199.txt
-rw-r--r--  1 hbarta hbarta   4941 Feb  4 15:13 2025-02-04-1511.syncoid.76.txt
-rw-r--r--  1 hbarta hbarta   1717 Feb  4 15:13 2025-02-04-1513.trim_snaps.23.txt
-rw-r--r--  1 hbarta hbarta   1716 Feb  4 15:15 2025-02-04-1514.trim_snaps.18.txt
-rw-r--r--  1 hbarta hbarta   1716 Feb  4 15:16 2025-02-04-1516.trim_snaps.18.txt
-rw-r--r--  1 hbarta hbarta 425023 Feb  4 15:17 2025-02-04-1513.stir_pools.252.txt
-rw-r--r--  1 hbarta hbarta   1716 Feb  4 15:17 2025-02-04-1517.trim_snaps.19.txt
-rw-r--r--  1 hbarta hbarta   1716 Feb  4 15:19 2025-02-04-1518.trim_snaps.18.txt
-rw-r--r--  1 hbarta hbarta   1716 Feb  4 15:20 2025-02-04-1520.trim_snaps.19.txt
-rw-r--r--  1 hbarta hbarta 426969 Feb  4 15:21 2025-02-04-1517.stir_pools.253.txt
-rw-r--r--  1 hbarta hbarta   1716 Feb  4 15:21 2025-02-04-1521.trim_snaps.17.txt
-rw-r--r--  1 hbarta hbarta   1716 Feb  4 15:23 2025-02-04-1522.trim_snaps.18.txt
-rw-r--r--  1 hbarta hbarta   1716 Feb  4 15:24 2025-02-04-1524.trim_snaps.18.txt
-rw-r--r--  1 hbarta hbarta   1716 Feb  4 15:25 2025-02-04-1525.trim_snaps.19.txt
-rw-r--r--  1 hbarta hbarta 432678 Feb  4 15:25 2025-02-04-1521.stir_pools.261.txt
-rw-r--r--  1 hbarta hbarta   1716 Feb  4 15:27 2025-02-04-1526.trim_snaps.19.txt
-rw-r--r--  1 hbarta hbarta   5059 Feb  4 15:27 2025-02-04-1513.syncoid.838.txt
-rw-r--r--  1 hbarta hbarta   1716 Feb  4 15:28 2025-02-04-1528.trim_snaps.20.txt
-rw-r--r--  1 hbarta hbarta   1716 Feb  4 15:29 2025-02-04-1529.trim_snaps.19.txt
-rw-r--r--  1 hbarta hbarta 429605 Feb  4 15:30 2025-02-04-1525.stir_pools.255.txt
-rw-r--r--  1 hbarta hbarta   1716 Feb  4 15:31 2025-02-04-1530.trim_snaps.20.txt
-rw-r--r--  1 hbarta hbarta   1774 Feb  4 15:32 2025-02-04-1532.trim_snaps.22.txt
-rw-r--r--  1 hbarta hbarta   1774 Feb  4 15:33 2025-02-04-1533.trim_snaps.21.txt
-rw-r--r--  1 hbarta hbarta 426707 Feb  4 15:34 2025-02-04-1530.stir_pools.257.txt
-rw-r--r--  1 hbarta hbarta   3391 Feb  4 15:36 2025-02-04-1534.trim_snaps.90.txt
-rw-r--r--  1 hbarta hbarta   1769 Feb  4 15:37 2025-02-04-1537.trim_snaps.22.txt
-rw-r--r--  1 hbarta hbarta 426045 Feb  4 15:38 2025-02-04-1534.stir_pools.257.txt
-rw-r--r--  1 hbarta hbarta   2567 Feb  4 15:39 2025-02-04-1538.trim_snaps.55.txt
-rw-r--r--  1 hbarta hbarta   2704 Feb  4 15:41 2025-02-04-1540.trim_snaps.63.txt
-rw-r--r--  1 hbarta hbarta   1770 Feb  4 15:43 2025-02-04-1542.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta 427855 Feb  4 15:43 2025-02-04-1538.stir_pools.257.txt
-rw-r--r--  1 hbarta hbarta   3496 Feb  4 15:45 2025-02-04-1544.trim_snaps.95.txt
-rw-r--r--  1 hbarta hbarta   1775 Feb  4 15:46 2025-02-04-1546.trim_snaps.22.txt
-rw-r--r--  1 hbarta hbarta 426461 Feb  4 15:47 2025-02-04-1543.stir_pools.256.txt
-rw-r--r--  1 hbarta hbarta   3480 Feb  4 15:49 2025-02-04-1547.trim_snaps.96.txt
-rw-r--r--  1 hbarta hbarta   1716 Feb  4 15:50 2025-02-04-1550.trim_snaps.20.txt
-rw-r--r--  1 hbarta hbarta 424145 Feb  4 15:51 2025-02-04-1547.stir_pools.257.txt
-rw-r--r--  1 hbarta hbarta   3558 Feb  4 15:53 2025-02-04-1551.trim_snaps.98.txt
-rw-r--r--  1 hbarta hbarta   1774 Feb  4 15:54 2025-02-04-1554.trim_snaps.22.txt
-rw-r--r--  1 hbarta hbarta 425253 Feb  4 15:56 2025-02-04-1551.stir_pools.259.txt
-rw-r--r--  1 hbarta hbarta   1999 Feb  4 15:56 2025-02-04-1555.trim_snaps.30.txt
-rw-r--r--  1 hbarta hbarta   3260 Feb  4 15:58 2025-02-04-1557.trim_snaps.89.txt
-rw-r--r--  1 hbarta hbarta   1774 Feb  4 16:00 2025-02-04-1559.trim_snaps.23.txt
-rw-r--r--  1 hbarta hbarta 419332 Feb  4 16:00 2025-02-04-1556.stir_pools.259.txt
-rw-r--r--  1 hbarta hbarta   5102 Feb  4 16:01 2025-02-04-1527.syncoid.2034.txt
-rw-r--r--  1 hbarta hbarta   3422 Feb  4 16:02 2025-02-04-1601.trim_snaps.92.txt
-rw-r--r--  1 hbarta hbarta   1769 Feb  4 16:04 2025-02-04-1603.trim_snaps.22.txt
-rw-r--r--  1 hbarta hbarta 426561 Feb  4 16:04 2025-02-04-1600.stir_pools.262.txt
-rw-r--r--  1 hbarta hbarta   3510 Feb  4 16:06 2025-02-04-1605.trim_snaps.95.txt
-rw-r--r--  1 hbarta hbarta   1774 Feb  4 16:08 2025-02-04-1607.trim_snaps.23.txt
-rw-r--r--  1 hbarta hbarta   1774 Feb  4 16:09 2025-02-04-1609.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta 429765 Feb  4 16:09 2025-02-04-1604.stir_pools.278.txt
-rw-r--r--  1 hbarta hbarta   3371 Feb  4 16:11 2025-02-04-1610.trim_snaps.82.txt
-rw-r--r--  1 hbarta hbarta   1774 Feb  4 16:13 2025-02-04-1612.trim_snaps.29.txt
-rw-r--r--  1 hbarta hbarta 433678 Feb  4 16:14 2025-02-04-1609.stir_pools.306.txt
-rw-r--r--  1 hbarta hbarta   2175 Feb  4 16:15 2025-02-04-1614.trim_snaps.40.txt
-rw-r--r--  1 hbarta hbarta   3089 Feb  4 16:17 2025-02-04-1616.trim_snaps.81.txt
-rw-r--r--  1 hbarta hbarta   1769 Feb  4 16:18 2025-02-04-1618.trim_snaps.23.txt
-rw-r--r--  1 hbarta hbarta 425704 Feb  4 16:19 2025-02-04-1614.stir_pools.286.txt
-rw-r--r--  1 hbarta hbarta   3495 Feb  4 16:21 2025-02-04-1619.trim_snaps.93.txt
-rw-r--r--  1 hbarta hbarta   1774 Feb  4 16:22 2025-02-04-1622.trim_snaps.25.txt
-rw-r--r--  1 hbarta hbarta   1774 Feb  4 16:24 2025-02-04-1623.trim_snaps.22.txt
-rw-r--r--  1 hbarta hbarta 425769 Feb  4 16:24 2025-02-04-1619.stir_pools.288.txt
-rw-r--r--  1 hbarta hbarta   3432 Feb  4 16:26 2025-02-04-1625.trim_snaps.98.txt
-rw-r--r--  1 hbarta hbarta   1774 Feb  4 16:28 2025-02-04-1627.trim_snaps.26.txt
-rw-r--r--  1 hbarta hbarta 429479 Feb  4 16:29 2025-02-04-1624.stir_pools.306.txt
-rw-r--r--  1 hbarta hbarta   2554 Feb  4 16:30 2025-02-04-1629.trim_snaps.59.txt
-rw-r--r--  1 hbarta hbarta   2695 Feb  4 16:32 2025-02-04-1631.trim_snaps.60.txt
-rw-r--r--  1 hbarta hbarta   5111 Feb  4 16:33 2025-02-04-1601.syncoid.1922.txt
-rw-r--r--  1 hbarta hbarta   1759 Feb  4 16:33 2025-02-04-1633.trim_snaps.25.txt
-rw-r--r--  1 hbarta hbarta 423131 Feb  4 16:34 2025-02-04-1629.stir_pools.317.txt
-rw-r--r--  1 hbarta hbarta   2460 Feb  4 16:35 2025-02-04-1634.trim_snaps.49.txt
-rw-r--r--  1 hbarta hbarta   2718 Feb  4 16:37 2025-02-04-1636.trim_snaps.57.txt
-rw-r--r--  1 hbarta hbarta   1705 Feb  4 16:38 2025-02-04-1638.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta 428246 Feb  4 16:39 2025-02-04-1634.stir_pools.301.txt
-rw-r--r--  1 hbarta hbarta   5078 Feb  4 16:40 2025-02-04-1633.syncoid.450.txt
-rw-r--r--  1 hbarta hbarta   3120 Feb  4 16:41 2025-02-04-1639.trim_snaps.78.txt
-rw-r--r--  1 hbarta hbarta   2119 Feb  4 16:42 2025-02-04-1642.trim_snaps.46.txt
-rw-r--r--  1 hbarta hbarta   1758 Feb  4 16:44 2025-02-04-1643.trim_snaps.27.txt
-rw-r--r--  1 hbarta hbarta 429890 Feb  4 16:45 2025-02-04-1639.stir_pools.306.txt
-rw-r--r--  1 hbarta hbarta   3413 Feb  4 16:46 2025-02-04-1645.trim_snaps.51.txt
-rw-r--r--  1 hbarta hbarta   4999 Feb  4 16:46 2025-02-04-1640.syncoid.346.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 16:47 2025-02-04-1647.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4983 Feb  4 16:47 2025-02-04-1646.syncoid.99.txt
-rw-r--r--  1 hbarta hbarta 434970 Feb  4 16:48 2025-02-04-1645.stir_pools.221.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 16:48 2025-02-04-1648.trim_snaps.17.txt
-rw-r--r--  1 hbarta hbarta   4959 Feb  4 16:49 2025-02-04-1647.syncoid.87.txt
-rw-r--r--  1 hbarta hbarta   3289 Feb  4 16:50 2025-02-04-1649.trim_snaps.23.txt
-rw-r--r--  1 hbarta hbarta   4957 Feb  4 16:50 2025-02-04-1649.syncoid.89.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 16:51 2025-02-04-1651.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta 428955 Feb  4 16:52 2025-02-04-1648.stir_pools.200.txt
-rw-r--r--  1 hbarta hbarta   4942 Feb  4 16:52 2025-02-04-1650.syncoid.83.txt
-rw-r--r--  1 hbarta hbarta   3463 Feb  4 16:52 2025-02-04-1652.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   4955 Feb  4 16:53 2025-02-04-1652.syncoid.91.txt
-rw-r--r--  1 hbarta hbarta   1677 Feb  4 16:54 2025-02-04-1653.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4935 Feb  4 16:55 2025-02-04-1653.syncoid.80.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 16:55 2025-02-04-1655.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta 432220 Feb  4 16:55 2025-02-04-1652.stir_pools.204.txt
-rw-r--r--  1 hbarta hbarta   4975 Feb  4 16:56 2025-02-04-1655.syncoid.96.txt
-rw-r--r--  1 hbarta hbarta   3420 Feb  4 16:56 2025-02-04-1656.trim_snaps.25.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 16:58 2025-02-04-1657.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4930 Feb  4 16:58 2025-02-04-1656.syncoid.80.txt
-rw-r--r--  1 hbarta hbarta 428330 Feb  4 16:58 2025-02-04-1655.stir_pools.200.txt
-rw-r--r--  1 hbarta hbarta   3524 Feb  4 16:59 2025-02-04-1659.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   4957 Feb  4 16:59 2025-02-04-1658.syncoid.88.txt
-rw-r--r--  1 hbarta hbarta   1687 Feb  4 17:00 2025-02-04-1700.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4960 Feb  4 17:01 2025-02-04-1659.syncoid.89.txt
-rw-r--r--  1 hbarta hbarta   1687 Feb  4 17:01 2025-02-04-1701.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta 429211 Feb  4 17:02 2025-02-04-1658.stir_pools.204.txt
-rw-r--r--  1 hbarta hbarta   4944 Feb  4 17:02 2025-02-04-1701.syncoid.82.txt
-rw-r--r--  1 hbarta hbarta   3360 Feb  4 17:03 2025-02-04-1702.trim_snaps.23.txt
-rw-r--r--  1 hbarta hbarta   4955 Feb  4 17:03 2025-02-04-1702.syncoid.93.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 17:04 2025-02-04-1704.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4935 Feb  4 17:05 2025-02-04-1703.syncoid.80.txt
-rw-r--r--  1 hbarta hbarta 429085 Feb  4 17:05 2025-02-04-1702.stir_pools.201.txt
-rw-r--r--  1 hbarta hbarta   3226 Feb  4 17:06 2025-02-04-1705.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   4977 Feb  4 17:06 2025-02-04-1705.syncoid.96.txt
-rw-r--r--  1 hbarta hbarta   1935 Feb  4 17:07 2025-02-04-1707.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4928 Feb  4 17:08 2025-02-04-1706.syncoid.80.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 17:08 2025-02-04-1708.trim_snaps.17.txt
-rw-r--r--  1 hbarta hbarta 429872 Feb  4 17:09 2025-02-04-1705.stir_pools.203.txt
-rw-r--r--  1 hbarta hbarta   4958 Feb  4 17:09 2025-02-04-1708.syncoid.89.txt
-rw-r--r--  1 hbarta hbarta   3347 Feb  4 17:09 2025-02-04-1709.trim_snaps.23.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 17:11 2025-02-04-1710.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4957 Feb  4 17:11 2025-02-04-1709.syncoid.91.txt
-rw-r--r--  1 hbarta hbarta 425863 Feb  4 17:12 2025-02-04-1709.stir_pools.201.txt
-rw-r--r--  1 hbarta hbarta   2038 Feb  4 17:12 2025-02-04-1712.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4941 Feb  4 17:12 2025-02-04-1711.syncoid.82.txt
-rw-r--r--  1 hbarta hbarta   3062 Feb  4 17:13 2025-02-04-1713.trim_snaps.23.txt
-rw-r--r--  1 hbarta hbarta   4959 Feb  4 17:14 2025-02-04-1712.syncoid.92.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 17:15 2025-02-04-1714.trim_snaps.17.txt
-rw-r--r--  1 hbarta hbarta   4939 Feb  4 17:15 2025-02-04-1714.syncoid.82.txt
-rw-r--r--  1 hbarta hbarta 425126 Feb  4 17:15 2025-02-04-1712.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   3405 Feb  4 17:16 2025-02-04-1716.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   4973 Feb  4 17:17 2025-02-04-1715.syncoid.96.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 17:17 2025-02-04-1717.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4926 Feb  4 17:18 2025-02-04-1717.syncoid.80.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 17:19 2025-02-04-1718.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta 428582 Feb  4 17:19 2025-02-04-1715.stir_pools.205.txt
-rw-r--r--  1 hbarta hbarta   4975 Feb  4 17:20 2025-02-04-1718.syncoid.93.txt
-rw-r--r--  1 hbarta hbarta   3514 Feb  4 17:20 2025-02-04-1720.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   4946 Feb  4 17:21 2025-02-04-1720.syncoid.87.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 17:21 2025-02-04-1721.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta 425435 Feb  4 17:22 2025-02-04-1719.stir_pools.201.txt
-rw-r--r--  1 hbarta hbarta   4944 Feb  4 17:22 2025-02-04-1721.syncoid.85.txt
-rw-r--r--  1 hbarta hbarta   3415 Feb  4 17:23 2025-02-04-1722.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 17:24 2025-02-04-1724.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4959 Feb  4 17:24 2025-02-04-1722.syncoid.93.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 17:25 2025-02-04-1725.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4946 Feb  4 17:25 2025-02-04-1724.syncoid.82.txt
-rw-r--r--  1 hbarta hbarta 427723 Feb  4 17:25 2025-02-04-1722.stir_pools.202.txt
-rw-r--r--  1 hbarta hbarta   3347 Feb  4 17:27 2025-02-04-1726.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   4970 Feb  4 17:27 2025-02-04-1725.syncoid.95.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 17:28 2025-02-04-1728.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4926 Feb  4 17:28 2025-02-04-1727.syncoid.79.txt
-rw-r--r--  1 hbarta hbarta 429571 Feb  4 17:29 2025-02-04-1725.stir_pools.202.txt
-rw-r--r--  1 hbarta hbarta   3463 Feb  4 17:29 2025-02-04-1729.trim_snaps.25.txt
-rw-r--r--  1 hbarta hbarta   4978 Feb  4 17:30 2025-02-04-1728.syncoid.95.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 17:31 2025-02-04-1730.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4939 Feb  4 17:31 2025-02-04-1730.syncoid.84.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 17:32 2025-02-04-1732.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta 428353 Feb  4 17:32 2025-02-04-1729.stir_pools.202.txt
-rw-r--r--  1 hbarta hbarta   4950 Feb  4 17:33 2025-02-04-1731.syncoid.86.txt
-rw-r--r--  1 hbarta hbarta   3405 Feb  4 17:33 2025-02-04-1733.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   4957 Feb  4 17:34 2025-02-04-1733.syncoid.92.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 17:34 2025-02-04-1734.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta 431514 Feb  4 17:36 2025-02-04-1732.stir_pools.204.txt
-rw-r--r--  1 hbarta hbarta   4948 Feb  4 17:36 2025-02-04-1734.syncoid.84.txt
-rw-r--r--  1 hbarta hbarta   2537 Feb  4 17:36 2025-02-04-1735.trim_snaps.19.txt
-rw-r--r--  1 hbarta hbarta   2560 Feb  4 17:37 2025-02-04-1737.trim_snaps.22.txt
-rw-r--r--  1 hbarta hbarta   4961 Feb  4 17:37 2025-02-04-1736.syncoid.94.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 17:38 2025-02-04-1738.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4934 Feb  4 17:39 2025-02-04-1737.syncoid.80.txt
-rw-r--r--  1 hbarta hbarta 421285 Feb  4 17:39 2025-02-04-1736.stir_pools.197.txt
-rw-r--r--  1 hbarta hbarta   3514 Feb  4 17:40 2025-02-04-1739.trim_snaps.25.txt
-rw-r--r--  1 hbarta hbarta   4983 Feb  4 17:40 2025-02-04-1739.syncoid.98.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 17:41 2025-02-04-1741.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4925 Feb  4 17:41 2025-02-04-1740.syncoid.81.txt
-rw-r--r--  1 hbarta hbarta 430405 Feb  4 17:42 2025-02-04-1739.stir_pools.204.txt
-rw-r--r--  1 hbarta hbarta   1919 Feb  4 17:42 2025-02-04-1742.trim_snaps.17.txt
-rw-r--r--  1 hbarta hbarta   4965 Feb  4 17:43 2025-02-04-1741.syncoid.91.txt
-rw-r--r--  1 hbarta hbarta   3133 Feb  4 17:44 2025-02-04-1743.trim_snaps.22.txt
-rw-r--r--  1 hbarta hbarta   4953 Feb  4 17:45 2025-02-04-1743.syncoid.90.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 17:45 2025-02-04-1745.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta 423493 Feb  4 17:46 2025-02-04-1742.stir_pools.198.txt
-rw-r--r--  1 hbarta hbarta   4944 Feb  4 17:46 2025-02-04-1745.syncoid.85.txt
-rw-r--r--  1 hbarta hbarta   3405 Feb  4 17:46 2025-02-04-1746.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   4961 Feb  4 17:48 2025-02-04-1746.syncoid.94.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 17:48 2025-02-04-1747.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 17:49 2025-02-04-1749.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4947 Feb  4 17:49 2025-02-04-1748.syncoid.84.txt
-rw-r--r--  1 hbarta hbarta 429705 Feb  4 17:49 2025-02-04-1746.stir_pools.203.txt
-rw-r--r--  1 hbarta hbarta   3405 Feb  4 17:50 2025-02-04-1750.trim_snaps.25.txt
-rw-r--r--  1 hbarta hbarta   4970 Feb  4 17:51 2025-02-04-1749.syncoid.97.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 17:52 2025-02-04-1751.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4925 Feb  4 17:52 2025-02-04-1751.syncoid.80.txt
-rw-r--r--  1 hbarta hbarta 428449 Feb  4 17:52 2025-02-04-1749.stir_pools.200.txt
-rw-r--r--  1 hbarta hbarta   3524 Feb  4 17:53 2025-02-04-1753.trim_snaps.25.txt
-rw-r--r--  1 hbarta hbarta   4982 Feb  4 17:54 2025-02-04-1752.syncoid.98.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 17:54 2025-02-04-1754.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4934 Feb  4 17:55 2025-02-04-1754.syncoid.84.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 17:56 2025-02-04-1755.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta 431216 Feb  4 17:56 2025-02-04-1752.stir_pools.203.txt
-rw-r--r--  1 hbarta hbarta   4958 Feb  4 17:56 2025-02-04-1755.syncoid.89.txt
-rw-r--r--  1 hbarta hbarta   3408 Feb  4 17:57 2025-02-04-1757.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   4959 Feb  4 17:58 2025-02-04-1756.syncoid.92.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 17:58 2025-02-04-1758.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta 425925 Feb  4 17:59 2025-02-04-1756.stir_pools.199.txt
-rw-r--r--  1 hbarta hbarta   4943 Feb  4 17:59 2025-02-04-1758.syncoid.87.txt
-rw-r--r--  1 hbarta hbarta   3405 Feb  4 18:00 2025-02-04-1759.trim_snaps.23.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 18:01 2025-02-04-1801.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4961 Feb  4 18:01 2025-02-04-1759.syncoid.95.txt
-rw-r--r--  1 hbarta hbarta   1687 Feb  4 18:02 2025-02-04-1802.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4946 Feb  4 18:02 2025-02-04-1801.syncoid.85.txt
-rw-r--r--  1 hbarta hbarta 427774 Feb  4 18:02 2025-02-04-1759.stir_pools.202.txt
-rw-r--r--  1 hbarta hbarta   3410 Feb  4 18:04 2025-02-04-1803.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   4966 Feb  4 18:04 2025-02-04-1802.syncoid.96.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 18:05 2025-02-04-1805.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4925 Feb  4 18:05 2025-02-04-1804.syncoid.81.txt
-rw-r--r--  1 hbarta hbarta 432588 Feb  4 18:06 2025-02-04-1802.stir_pools.201.txt
-rw-r--r--  1 hbarta hbarta   3342 Feb  4 18:06 2025-02-04-1806.trim_snaps.25.txt
-rw-r--r--  1 hbarta hbarta   4983 Feb  4 18:07 2025-02-04-1805.syncoid.100.txt
-rw-r--r--  1 hbarta hbarta   1874 Feb  4 18:07 2025-02-04-1807.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4931 Feb  4 18:08 2025-02-04-1807.syncoid.84.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 18:09 2025-02-04-1808.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta 427130 Feb  4 18:09 2025-02-04-1806.stir_pools.201.txt
-rw-r--r--  1 hbarta hbarta   4964 Feb  4 18:10 2025-02-04-1808.syncoid.94.txt
-rw-r--r--  1 hbarta hbarta   3347 Feb  4 18:10 2025-02-04-1810.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   1687 Feb  4 18:11 2025-02-04-1811.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4952 Feb  4 18:12 2025-02-04-1810.syncoid.91.txt
-rw-r--r--  1 hbarta hbarta 429050 Feb  4 18:13 2025-02-04-1809.stir_pools.199.txt
-rw-r--r--  1 hbarta hbarta   2542 Feb  4 18:13 2025-02-04-1812.trim_snaps.19.txt
-rw-r--r--  1 hbarta hbarta   4947 Feb  4 18:13 2025-02-04-1812.syncoid.90.txt
-rw-r--r--  1 hbarta hbarta   2502 Feb  4 18:14 2025-02-04-1814.trim_snaps.20.txt
-rw-r--r--  1 hbarta hbarta   4959 Feb  4 18:15 2025-02-04-1813.syncoid.95.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 18:15 2025-02-04-1815.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta 430731 Feb  4 18:16 2025-02-04-1813.stir_pools.201.txt
-rw-r--r--  1 hbarta hbarta   4947 Feb  4 18:16 2025-02-04-1815.syncoid.86.txt
-rw-r--r--  1 hbarta hbarta   3461 Feb  4 18:17 2025-02-04-1816.trim_snaps.25.txt
-rw-r--r--  1 hbarta hbarta   4957 Feb  4 18:18 2025-02-04-1816.syncoid.95.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 18:18 2025-02-04-1818.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4935 Feb  4 18:19 2025-02-04-1818.syncoid.84.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 18:19 2025-02-04-1819.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta 438888 Feb  4 18:19 2025-02-04-1816.stir_pools.206.txt
-rw-r--r--  1 hbarta hbarta   3471 Feb  4 18:21 2025-02-04-1820.trim_snaps.26.txt
-rw-r--r--  1 hbarta hbarta   4973 Feb  4 18:21 2025-02-04-1819.syncoid.100.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 18:22 2025-02-04-1822.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4925 Feb  4 18:22 2025-02-04-1821.syncoid.83.txt
-rw-r--r--  1 hbarta hbarta 424744 Feb  4 18:23 2025-02-04-1819.stir_pools.201.txt
-rw-r--r--  1 hbarta hbarta   3405 Feb  4 18:23 2025-02-04-1823.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   4979 Feb  4 18:24 2025-02-04-1822.syncoid.99.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 18:25 2025-02-04-1824.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4938 Feb  4 18:25 2025-02-04-1824.syncoid.87.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 18:26 2025-02-04-1826.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta 435513 Feb  4 18:26 2025-02-04-1823.stir_pools.205.txt
-rw-r--r--  1 hbarta hbarta   4955 Feb  4 18:27 2025-02-04-1825.syncoid.91.txt
-rw-r--r--  1 hbarta hbarta   3405 Feb  4 18:27 2025-02-04-1827.trim_snaps.25.txt
-rw-r--r--  1 hbarta hbarta   4961 Feb  4 18:28 2025-02-04-1827.syncoid.96.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 18:29 2025-02-04-1828.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta 428411 Feb  4 18:29 2025-02-04-1826.stir_pools.200.txt
-rw-r--r--  1 hbarta hbarta   4944 Feb  4 18:30 2025-02-04-1828.syncoid.90.txt
-rw-r--r--  1 hbarta hbarta   3463 Feb  4 18:30 2025-02-04-1830.trim_snaps.25.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 18:31 2025-02-04-1831.trim_snaps.17.txt
-rw-r--r--  1 hbarta hbarta   4960 Feb  4 18:31 2025-02-04-1830.syncoid.97.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 18:32 2025-02-04-1832.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta 424744 Feb  4 18:33 2025-02-04-1829.stir_pools.202.txt
-rw-r--r--  1 hbarta hbarta   4945 Feb  4 18:33 2025-02-04-1831.syncoid.87.txt
-rw-r--r--  1 hbarta hbarta   3347 Feb  4 18:34 2025-02-04-1833.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   4962 Feb  4 18:35 2025-02-04-1833.syncoid.99.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 18:35 2025-02-04-1835.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4937 Feb  4 18:36 2025-02-04-1835.syncoid.86.txt
-rw-r--r--  1 hbarta hbarta 424469 Feb  4 18:36 2025-02-04-1833.stir_pools.198.txt
-rw-r--r--  1 hbarta hbarta   3524 Feb  4 18:37 2025-02-04-1836.trim_snaps.25.txt
-rw-r--r--  1 hbarta hbarta   4973 Feb  4 18:38 2025-02-04-1836.syncoid.102.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 18:38 2025-02-04-1838.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 18:39 2025-02-04-1839.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4927 Feb  4 18:39 2025-02-04-1838.syncoid.84.txt
-rw-r--r--  1 hbarta hbarta 421965 Feb  4 18:39 2025-02-04-1836.stir_pools.200.txt
-rw-r--r--  1 hbarta hbarta   3408 Feb  4 18:40 2025-02-04-1840.trim_snaps.25.txt
-rw-r--r--  1 hbarta hbarta   4983 Feb  4 18:41 2025-02-04-1839.syncoid.103.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 18:42 2025-02-04-1841.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4926 Feb  4 18:42 2025-02-04-1841.syncoid.85.txt
-rw-r--r--  1 hbarta hbarta 426916 Feb  4 18:43 2025-02-04-1839.stir_pools.201.txt
-rw-r--r--  1 hbarta hbarta   2878 Feb  4 18:43 2025-02-04-1843.trim_snaps.22.txt
-rw-r--r--  1 hbarta hbarta   4978 Feb  4 18:44 2025-02-04-1842.syncoid.100.txt
-rw-r--r--  1 hbarta hbarta   2220 Feb  4 18:44 2025-02-04-1844.trim_snaps.18.txt
-rw-r--r--  1 hbarta hbarta   4940 Feb  4 18:45 2025-02-04-1844.syncoid.89.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 18:46 2025-02-04-1845.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta 430051 Feb  4 18:46 2025-02-04-1843.stir_pools.204.txt
-rw-r--r--  1 hbarta hbarta   4956 Feb  4 18:47 2025-02-04-1845.syncoid.94.txt
-rw-r--r--  1 hbarta hbarta   3352 Feb  4 18:47 2025-02-04-1847.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 18:48 2025-02-04-1848.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4958 Feb  4 18:49 2025-02-04-1847.syncoid.96.txt
-rw-r--r--  1 hbarta hbarta 424074 Feb  4 18:50 2025-02-04-1846.stir_pools.201.txt
-rw-r--r--  1 hbarta hbarta   1861 Feb  4 18:50 2025-02-04-1849.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4947 Feb  4 18:50 2025-02-04-1849.syncoid.89.txt
-rw-r--r--  1 hbarta hbarta   3239 Feb  4 18:51 2025-02-04-1851.trim_snaps.23.txt
-rw-r--r--  1 hbarta hbarta   4960 Feb  4 18:52 2025-02-04-1850.syncoid.97.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 18:52 2025-02-04-1852.trim_snaps.14.txt
-rw-r--r--  1 hbarta hbarta 435315 Feb  4 18:53 2025-02-04-1850.stir_pools.203.txt
-rw-r--r--  1 hbarta hbarta   4948 Feb  4 18:53 2025-02-04-1852.syncoid.89.txt
-rw-r--r--  1 hbarta hbarta   3466 Feb  4 18:54 2025-02-04-1853.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   4957 Feb  4 18:55 2025-02-04-1853.syncoid.98.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 18:55 2025-02-04-1855.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 18:56 2025-02-04-1856.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4937 Feb  4 18:56 2025-02-04-1855.syncoid.86.txt
-rw-r--r--  1 hbarta hbarta 434787 Feb  4 18:56 2025-02-04-1853.stir_pools.204.txt
-rw-r--r--  1 hbarta hbarta   3466 Feb  4 18:58 2025-02-04-1857.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   4973 Feb  4 18:58 2025-02-04-1856.syncoid.101.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 18:59 2025-02-04-1859.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4929 Feb  4 18:59 2025-02-04-1858.syncoid.85.txt
-rw-r--r--  1 hbarta hbarta 435136 Feb  4 19:00 2025-02-04-1856.stir_pools.202.txt
-rw-r--r--  1 hbarta hbarta   3403 Feb  4 19:00 2025-02-04-1900.trim_snaps.25.txt
-rw-r--r--  1 hbarta hbarta   4983 Feb  4 19:01 2025-02-04-1859.syncoid.104.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 19:02 2025-02-04-1901.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4926 Feb  4 19:03 2025-02-04-1901.syncoid.86.txt
-rw-r--r--  1 hbarta hbarta   1677 Feb  4 19:03 2025-02-04-1903.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta 426759 Feb  4 19:03 2025-02-04-1900.stir_pools.201.txt
-rw-r--r--  1 hbarta hbarta   4980 Feb  4 19:04 2025-02-04-1903.syncoid.102.txt
-rw-r--r--  1 hbarta hbarta   3370 Feb  4 19:04 2025-02-04-1904.trim_snaps.25.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 19:06 2025-02-04-1905.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4937 Feb  4 19:06 2025-02-04-1904.syncoid.89.txt
-rw-r--r--  1 hbarta hbarta 431416 Feb  4 19:07 2025-02-04-1903.stir_pools.201.txt
-rw-r--r--  1 hbarta hbarta   3347 Feb  4 19:07 2025-02-04-1907.trim_snaps.23.txt
-rw-r--r--  1 hbarta hbarta   4964 Feb  4 19:07 2025-02-04-1906.syncoid.97.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 19:08 2025-02-04-1908.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4952 Feb  4 19:09 2025-02-04-1907.syncoid.94.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 19:09 2025-02-04-1909.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta 430067 Feb  4 19:10 2025-02-04-1907.stir_pools.203.txt
-rw-r--r--  1 hbarta hbarta   4951 Feb  4 19:10 2025-02-04-1909.syncoid.92.txt
-rw-r--r--  1 hbarta hbarta   3347 Feb  4 19:11 2025-02-04-1910.trim_snaps.23.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 19:12 2025-02-04-1912.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4962 Feb  4 19:12 2025-02-04-1910.syncoid.99.txt
-rw-r--r--  1 hbarta hbarta 430388 Feb  4 19:13 2025-02-04-1910.stir_pools.202.txt
-rw-r--r--  1 hbarta hbarta   1977 Feb  4 19:13 2025-02-04-1913.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4945 Feb  4 19:14 2025-02-04-1912.syncoid.90.txt
-rw-r--r--  1 hbarta hbarta   3181 Feb  4 19:15 2025-02-04-1914.trim_snaps.23.txt
-rw-r--r--  1 hbarta hbarta   4960 Feb  4 19:15 2025-02-04-1914.syncoid.99.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 19:16 2025-02-04-1916.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta 433118 Feb  4 19:17 2025-02-04-1913.stir_pools.202.txt
-rw-r--r--  1 hbarta hbarta   4947 Feb  4 19:17 2025-02-04-1915.syncoid.89.txt
-rw-r--r--  1 hbarta hbarta   3408 Feb  4 19:17 2025-02-04-1917.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   4960 Feb  4 19:18 2025-02-04-1917.syncoid.101.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 19:19 2025-02-04-1918.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4937 Feb  4 19:20 2025-02-04-1918.syncoid.88.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 19:20 2025-02-04-1920.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta 427654 Feb  4 19:20 2025-02-04-1917.stir_pools.202.txt
-rw-r--r--  1 hbarta hbarta   3405 Feb  4 19:21 2025-02-04-1921.trim_snaps.26.txt
-rw-r--r--  1 hbarta hbarta   4973 Feb  4 19:22 2025-02-04-1920.syncoid.103.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 19:23 2025-02-04-1922.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4934 Feb  4 19:23 2025-02-04-1922.syncoid.88.txt
-rw-r--r--  1 hbarta hbarta 429962 Feb  4 19:23 2025-02-04-1920.stir_pools.199.txt
-rw-r--r--  1 hbarta hbarta   3461 Feb  4 19:24 2025-02-04-1924.trim_snaps.25.txt
-rw-r--r--  1 hbarta hbarta   4978 Feb  4 19:25 2025-02-04-1923.syncoid.106.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 19:25 2025-02-04-1925.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4926 Feb  4 19:26 2025-02-04-1925.syncoid.86.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 19:27 2025-02-04-1926.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta 429616 Feb  4 19:27 2025-02-04-1923.stir_pools.202.txt
-rw-r--r--  1 hbarta hbarta   3352 Feb  4 19:28 2025-02-04-1928.trim_snaps.25.txt
-rw-r--r--  1 hbarta hbarta   4983 Feb  4 19:28 2025-02-04-1926.syncoid.107.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 19:29 2025-02-04-1929.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4928 Feb  4 19:30 2025-02-04-1928.syncoid.87.txt
-rw-r--r--  1 hbarta hbarta 426804 Feb  4 19:30 2025-02-04-1927.stir_pools.199.txt
-rw-r--r--  1 hbarta hbarta   3524 Feb  4 19:31 2025-02-04-1930.trim_snaps.25.txt
-rw-r--r--  1 hbarta hbarta   4982 Feb  4 19:31 2025-02-04-1930.syncoid.104.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 19:32 2025-02-04-1932.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4933 Feb  4 19:33 2025-02-04-1931.syncoid.89.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 19:33 2025-02-04-1933.trim_snaps.17.txt
-rw-r--r--  1 hbarta hbarta 425837 Feb  4 19:33 2025-02-04-1930.stir_pools.201.txt
-rw-r--r--  1 hbarta hbarta   4978 Feb  4 19:35 2025-02-04-1933.syncoid.102.txt
-rw-r--r--  1 hbarta hbarta   3347 Feb  4 19:35 2025-02-04-1934.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 19:36 2025-02-04-1936.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4940 Feb  4 19:36 2025-02-04-1935.syncoid.92.txt
-rw-r--r--  1 hbarta hbarta 425843 Feb  4 19:37 2025-02-04-1933.stir_pools.198.txt
-rw-r--r--  1 hbarta hbarta   3463 Feb  4 19:37 2025-02-04-1937.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   4973 Feb  4 19:38 2025-02-04-1936.syncoid.101.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 19:39 2025-02-04-1938.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta   4948 Feb  4 19:39 2025-02-04-1938.syncoid.93.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 19:40 2025-02-04-1940.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta 428890 Feb  4 19:40 2025-02-04-1937.stir_pools.202.txt
-rw-r--r--  1 hbarta hbarta   4959 Feb  4 19:41 2025-02-04-1939.syncoid.96.txt
-rw-r--r--  1 hbarta hbarta   3463 Feb  4 19:41 2025-02-04-1941.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 19:42 2025-02-04-1942.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4955 Feb  4 19:43 2025-02-04-1941.syncoid.100.txt
-rw-r--r--  1 hbarta hbarta 430227 Feb  4 19:44 2025-02-04-1940.stir_pools.202.txt
-rw-r--r--  1 hbarta hbarta   3049 Feb  4 19:44 2025-02-04-1943.trim_snaps.22.txt
-rw-r--r--  1 hbarta hbarta   4953 Feb  4 19:44 2025-02-04-1943.syncoid.95.txt
-rw-r--r--  1 hbarta hbarta   2043 Feb  4 19:45 2025-02-04-1945.trim_snaps.18.txt
-rw-r--r--  1 hbarta hbarta   4962 Feb  4 19:46 2025-02-04-1944.syncoid.100.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 19:46 2025-02-04-1946.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta 433284 Feb  4 19:47 2025-02-04-1944.stir_pools.204.txt
-rw-r--r--  1 hbarta hbarta   4946 Feb  4 19:47 2025-02-04-1946.syncoid.92.txt
-rw-r--r--  1 hbarta hbarta   3461 Feb  4 19:48 2025-02-04-1947.trim_snaps.25.txt
-rw-r--r--  1 hbarta hbarta   4961 Feb  4 19:49 2025-02-04-1947.syncoid.102.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 19:49 2025-02-04-1949.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 19:50 2025-02-04-1950.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta 429053 Feb  4 19:50 2025-02-04-1947.stir_pools.205.txt
-rw-r--r--  1 hbarta hbarta   4948 Feb  4 19:51 2025-02-04-1949.syncoid.93.txt
-rw-r--r--  1 hbarta hbarta   3415 Feb  4 19:52 2025-02-04-1951.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   4965 Feb  4 19:52 2025-02-04-1951.syncoid.101.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 19:53 2025-02-04-1953.trim_snaps.15.txt
-rw-r--r--  1 hbarta hbarta 427205 Feb  4 19:54 2025-02-04-1950.stir_pools.200.txt
-rw-r--r--  1 hbarta hbarta   4951 Feb  4 19:54 2025-02-04-1952.syncoid.91.txt
-rw-r--r--  1 hbarta hbarta   3466 Feb  4 19:54 2025-02-04-1954.trim_snaps.25.txt
-rw-r--r--  1 hbarta hbarta   4962 Feb  4 19:56 2025-02-04-1954.syncoid.103.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 19:56 2025-02-04-1955.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   1634 Feb  4 19:57 2025-02-04-1957.trim_snaps.14.txt
-rw-r--r--  1 hbarta hbarta   4937 Feb  4 19:57 2025-02-04-1956.syncoid.89.txt
-rw-r--r--  1 hbarta hbarta 431319 Feb  4 19:57 2025-02-04-1954.stir_pools.204.txt
-rw-r--r--  1 hbarta hbarta   3405 Feb  4 19:58 2025-02-04-1958.trim_snaps.24.txt
-rw-r--r--  1 hbarta hbarta   4973 Feb  4 19:59 2025-02-04-1957.syncoid.104.txt
-rw-r--r--  1 hbarta hbarta   1692 Feb  4 20:00 2025-02-04-1959.trim_snaps.16.txt
-rw-r--r--  1 hbarta hbarta   4937 Feb  4 20:00 2025-02-04-1959.syncoid.89.txt
-rw-r--r--  1 hbarta hbarta 421467 Feb  4 20:00 2025-02-04-1957.stir_pools.196.txt
-rw-r--r--  1 hbarta hbarta   3466 Feb  4 20:01 2025-02-04-2001.trim_snaps.25.txt
-rw-r--r--  1 hbarta hbarta   5374 Feb  4 20:02 2025-02-04-2000.syncoid.104.txt
-rw-r--r--  1 hbarta hbarta   1925 Feb  4 20:02 2025-02-04-2002.trim_snaps.13.txt
-rw-r--r--  1 hbarta hbarta 426908 Feb  4 20:03 2025-02-04-2000.stir_pools.183.txt
-rw-r--r--  1 hbarta hbarta     32 Feb  4 20:03 halt_test.txt
-rw-r--r--  1 hbarta hbarta   1925 Feb  4 20:03 2025-02-04-2003.trim_snaps.13.txt
... (meaningless trim logs removed)
-rw-r--r--  1 hbarta hbarta   1925 Feb  5 00:08 2025-02-05-0008.trim_snaps.10.txt
[hbarta@vulcan ~/logs]$ 
```

## 2025-02-08 last syncoid log

```text
Sending incremental send/test@syncoid_vulcan_2025-02-04:19:59:15-GMT00:00 ... syncoid_vulcan_2025-02-04:20:00:45-GMT00:00 (~ 4 KB):
Sending incremental send/test/l0_0@syncoid_vulcan_2025-02-04:19:59:18-GMT00:00 ... syncoid_vulcan_2025-02-04:20:00:47-GMT00:00 (~ 7.5 MB):
Sending incremental send/test/l0_0/l1_0@syncoid_vulcan_2025-02-04:19:59:21-GMT00:00 ... syncoid_vulcan_2025-02-04:20:00:50-GMT00:00 (~ 21.3 MB):
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_vulcan_2025-02-04:19:59:24-GMT00:00 ... syncoid_vulcan_2025-02-04:20:00:53-GMT00:00 (~ 4 KB):
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_vulcan_2025-02-04:19:59:27-GMT00:00 ... syncoid_vulcan_2025-02-04:20:00:56-GMT00:00 (~ 23.1 M
B):
Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_vulcan_2025-02-04:19:59:30-GMT00:00 ... syncoid_vulcan_2025-02-04:20:00:59-GMT00:00 (~ 21.6 M
B):
Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_vulcan_2025-02-04:19:59:32-GMT00:00 ... syncoid_vulcan_2025-02-04:20:01:02-GMT00:00 (~ 4 KB):
Sending incremental send/test/l0_0/l1_1@syncoid_vulcan_2025-02-04:19:59:36-GMT00:00 ... syncoid_vulcan_2025-02-04:20:01:05-GMT00:00 (~ 23.0 MB):
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_vulcan_2025-02-04:19:59:38-GMT00:00 ... syncoid_vulcan_2025-02-04:20:01:08-GMT00:00 (~ 23.0 M
B):
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_vulcan_2025-02-04:19:59:41-GMT00:00 ... syncoid_vulcan_2025-02-04:20:01:12-GMT00:00 (~ 22.8 M
B):
Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_vulcan_2025-02-04:19:59:43-GMT00:00 ... syncoid_vulcan_2025-02-04:20:01:17-GMT00:00 (~ 23.4 M
B):
Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_vulcan_2025-02-04:19:59:46-GMT00:00 ... syncoid_vulcan_2025-02-04:20:01:20-GMT00:00 (~ 22.6 M
B):
Sending incremental send/test/l0_0/l1_2@syncoid_vulcan_2025-02-04:19:59:48-GMT00:00 ... syncoid_vulcan_2025-02-04:20:01:24-GMT00:00 (~ 18.3 MB):
Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_vulcan_2025-02-04:19:59:51-GMT00:00 ... syncoid_vulcan_2025-02-04:20:01:28-GMT00:00 (~ 23.3 M
B):
Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_vulcan_2025-02-04:19:59:54-GMT00:00 ... syncoid_vulcan_2025-02-04:20:01:32-GMT00:00 (~ 22.1 M
B):
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_vulcan_2025-02-04:19:59:56-GMT00:00 ... syncoid_vulcan_2025-02-04:20:01:35-GMT00:00 (~ 22.3 M
B):
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_vulcan_2025-02-04:19:59:59-GMT00:00 ... syncoid_vulcan_2025-02-04:20:01:39-GMT00:00 (~ 4 KB):
Sending incremental send/test/l0_0/l1_3@syncoid_vulcan_2025-02-04:20:00:03-GMT00:00 ... syncoid_vulcan_2025-02-04:20:01:42-GMT00:00 (~ 4 KB):
Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_vulcan_2025-02-04:20:00:06-GMT00:00 ... syncoid_vulcan_2025-02-04:20:01:44-GMT00:00 (~ 4 KB):
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_vulcan_2025-02-04:20:00:09-GMT00:00 ... syncoid_vulcan_2025-02-04:20:01:47-GMT00:00 (~ 4 KB):
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_vulcan_2025-02-04:20:00:13-GMT00:00 ... syncoid_vulcan_2025-02-04:20:01:50-GMT00:00 (~ 4 KB):
Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_vulcan_2025-02-04:20:00:16-GMT00:00 ... syncoid_vulcan_2025-02-04:20:01:53-GMT00:00 (~ 4 KB):
Sending incremental send/test/l0_1@syncoid_vulcan_2025-02-04:20:00:19-GMT00:00 ... syncoid_vulcan_2025-02-04:20:01:55-GMT00:00 (~ 14.0 MB):
Sending incremental send/test/l0_1/l1_0@syncoid_vulcan_2025-02-04:20:00:21-GMT00:00 ... syncoid_vulcan_2025-02-04:20:01:58-GMT00:00 (~ 22.8 MB):
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_vulcan_2025-02-04:20:00:24-GMT00:00 ... syncoid_vulcan_2025-02-04:20:02:02-GMT00:00 (~ 22.2 M
B):
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_vulcan_2025-02-04:20:00:27-GMT00:00 ... syncoid_vulcan_2025-02-04:20:02:05-GMT00:00 (~ 22.5 M
B):
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_vulcan_2025-02-04:20:00:29-GMT00:00 ... syncoid_vulcan_2025-02-04:20:02:09-GMT00:00 (~ 21.9 M
B):
Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_vulcan_2025-02-04:20:00:32-GMT00:00 ... syncoid_vulcan_2025-02-04:20:02:12-GMT00:00 (~ 24.5 M
B):
warning: cannot send 'send/test/l0_1/l1_0/l2_3@syncoid_vulcan_2025-02-04:20:02:12-GMT00:00': Invalid argument
Sending incremental send/test/l0_1/l1_1@syncoid_vulcan_2025-02-04:20:00:34-GMT00:00 ... syncoid_vulcan_2025-02-04:20:02:15-GMT00:00 (~ 22.5 MB):
Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_vulcan_2025-02-04:20:00:37-GMT00:00 ... syncoid_vulcan_2025-02-04:20:02:18-GMT00:00 (~ 21.1 MB):
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_vulcan_2025-02-04:20:00:39-GMT00:00 ... syncoid_vulcan_2025-02-04:20:02:22-GMT00:00 (~ 21.7 MB):
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_vulcan_2025-02-04:20:00:42-GMT00:00 ... syncoid_vulcan_2025-02-04:20:02:25-GMT00:00 (~ 5.8 MB):
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
  scan: scrub repaired 0B in 01:32:28 with 0 errors on Tue Feb  4 16:46:00 2025
config:

        NAME        STATE     READ WRITE CKSUM
        send        ONLINE       0     0     0
          da1p1     ONLINE       0     0     0

errors: 1 data errors, use '-v' for a list
```