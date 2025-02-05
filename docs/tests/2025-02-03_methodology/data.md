# data

* [Results](./results.md)

This file includes long listings that would only obscure some other descriptions.

## 2025-02-03 first syncoid

```text
root@orcus:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@autosnap_2025-02-03_19:46:23_monthly (~ 87 KB) to new target filesystem:
49.3KiB 0:00:00 [1.99MiB/s] [=====================================================>                                            ] 56%            
INFO: Updating new target filesystem with incremental send/test@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:19:52:17-GMT-06:00 (~ 4 KB):
3.35KiB 0:00:00 [80.6KiB/s] [================================================================================>                 ] 83%            
INFO: Sending oldest full snapshot send/test/l0_0@autosnap_2025-02-03_19:46:23_monthly (~ 15.3 GB) to new target filesystem:
15.3GiB 0:01:18 [ 199MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:19:52:17-GMT-06:00 (~ 4 KB):
3.35KiB 0:00:00 [78.1KiB/s] [================================================================================>                 ] 83%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@autosnap_2025-02-03_19:46:23_monthly (~ 14.9 GB) to new target filesystem:
14.9GiB 0:01:17 [ 196MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_0@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:19:53:36-GMT-06:00 (~ 4 KB):
3.35KiB 0:00:00 [74.2KiB/s] [================================================================================>                 ] 83%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@autosnap_2025-02-03_19:46:23_monthly (~ 15.4 GB) to new target filesystem:
15.4GiB 0:01:19 [ 197MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_0/l2_0@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:19:54:54-GMT-06:00 (~ 4 KB):
3.35KiB 0:00:00 [70.7KiB/s] [================================================================================>                 ] 83%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@autosnap_2025-02-03_19:46:23_monthly (~ 15.8 GB) to new target filesystem:
15.8GiB 0:01:21 [ 199MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_0/l2_1@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:19:56:15-GMT-06:00 (~ 4 KB):
3.35KiB 0:00:00 [75.5KiB/s] [================================================================================>                 ] 83%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@autosnap_2025-02-03_19:46:23_monthly (~ 15.1 GB) to new target filesystem:
15.1GiB 0:01:18 [ 196MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_0/l2_2@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:19:57:37-GMT-06:00 (~ 4 KB):
3.35KiB 0:00:00 [82.2KiB/s] [================================================================================>                 ] 83%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@autosnap_2025-02-03_19:46:23_monthly (~ 15.8 GB) to new target filesystem:
15.8GiB 0:01:21 [ 198MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_0/l2_3@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:19:58:57-GMT-06:00 (~ 4 KB):
3.35KiB 0:00:00 [75.9KiB/s] [================================================================================>                 ] 83%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@autosnap_2025-02-03_19:46:23_monthly (~ 15.2 GB) to new target filesystem:
15.2GiB 0:01:19 [ 195MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_1@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:00:19-GMT-06:00 (~ 4 KB):
4.57KiB 0:00:00 [90.1KiB/s] [=================================================================================================] 114%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@autosnap_2025-02-03_19:46:23_monthly (~ 15.6 GB) to new target filesystem:
15.6GiB 0:01:20 [ 197MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_1/l2_0@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:01:39-GMT-06:00 (~ 4 KB):
4.57KiB 0:00:00 [98.3KiB/s] [=================================================================================================] 114%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@autosnap_2025-02-03_19:46:23_monthly (~ 15.3 GB) to new target filesystem:
15.3GiB 0:01:18 [ 200MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_1/l2_1@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:03:00-GMT-06:00 (~ 4 KB):
4.57KiB 0:00:00 [80.6KiB/s] [=================================================================================================] 114%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@autosnap_2025-02-03_19:46:23_monthly (~ 15.9 GB) to new target filesystem:
15.9GiB 0:01:23 [ 194MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_1/l2_2@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:04:20-GMT-06:00 (~ 4 KB):
4.57KiB 0:00:00 [84.0KiB/s] [=================================================================================================] 114%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@autosnap_2025-02-03_19:46:23_monthly (~ 15.6 GB) to new target filesystem:
15.6GiB 0:01:22 [ 193MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_1/l2_3@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:05:44-GMT-06:00 (~ 4 KB):
4.57KiB 0:00:00 [71.6KiB/s] [=================================================================================================] 114%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@autosnap_2025-02-03_19:46:23_monthly (~ 16.0 GB) to new target filesystem:
16.0GiB 0:01:23 [ 195MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_2@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:07:07-GMT-06:00 (~ 4 KB):
4.57KiB 0:00:00 [81.3KiB/s] [=================================================================================================] 114%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@autosnap_2025-02-03_19:46:23_monthly (~ 15.5 GB) to new target filesystem:
15.5GiB 0:01:20 [ 197MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_2/l2_0@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:08:32-GMT-06:00 (~ 4 KB):
4.57KiB 0:00:00 [79.4KiB/s] [=================================================================================================] 114%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@autosnap_2025-02-03_19:46:23_monthly (~ 15.3 GB) to new target filesystem:
15.3GiB 0:01:19 [ 197MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_2/l2_1@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:09:53-GMT-06:00 (~ 4 KB):
4.57KiB 0:00:00 [97.0KiB/s] [=================================================================================================] 114%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@autosnap_2025-02-03_19:46:23_monthly (~ 15.5 GB) to new target filesystem:
15.5GiB 0:01:20 [ 196MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_2/l2_2@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:11:13-GMT-06:00 (~ 4 KB):
4.57KiB 0:00:00 [96.7KiB/s] [=================================================================================================] 114%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@autosnap_2025-02-03_19:46:23_monthly (~ 15.2 GB) to new target filesystem:
15.2GiB 0:01:20 [ 193MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_2/l2_3@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:12:34-GMT-06:00 (~ 4 KB):
4.57KiB 0:00:00 [80.8KiB/s] [=================================================================================================] 114%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@autosnap_2025-02-03_19:46:23_monthly (~ 15.6 GB) to new target filesystem:
15.6GiB 0:01:20 [ 197MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_3@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:13:56-GMT-06:00 (~ 4 KB):
4.57KiB 0:00:00 [ 111KiB/s] [=================================================================================================] 114%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@autosnap_2025-02-03_19:46:23_monthly (~ 15.6 GB) to new target filesystem:
15.6GiB 0:01:21 [ 194MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_3/l2_0@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:15:17-GMT-06:00 (~ 4 KB):
4.57KiB 0:00:00 [81.5KiB/s] [=================================================================================================] 114%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@autosnap_2025-02-03_19:46:23_monthly (~ 15.5 GB) to new target filesystem:
15.5GiB 0:01:21 [ 195MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_3/l2_1@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:16:40-GMT-06:00 (~ 4 KB):
5.18KiB 0:00:00 [94.8KiB/s] [=================================================================================================] 121%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@autosnap_2025-02-03_19:46:23_monthly (~ 15.5 GB) to new target filesystem:
15.5GiB 0:01:22 [ 192MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_3/l2_2@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:18:02-GMT-06:00 (~ 4 KB):
5.18KiB 0:00:00 [86.6KiB/s] [=================================================================================================] 121%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@autosnap_2025-02-03_19:46:23_monthly (~ 15.3 GB) to new target filesystem:
15.3GiB 0:01:19 [ 197MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_3/l2_3@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:19:25-GMT-06:00 (~ 4 KB):
5.18KiB 0:00:00 [84.7KiB/s] [=================================================================================================] 121%            
INFO: Sending oldest full snapshot send/test/l0_1@autosnap_2025-02-03_19:46:23_monthly (~ 15.1 GB) to new target filesystem:
15.2GiB 0:01:19 [ 194MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:20:45-GMT-06:00 (~ 4 KB):
5.18KiB 0:00:00 [ 127KiB/s] [=================================================================================================] 121%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@autosnap_2025-02-03_19:46:23_monthly (~ 15.0 GB) to new target filesystem:
15.0GiB 0:01:19 [ 193MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_0@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:22:06-GMT-06:00 (~ 4 KB):
5.18KiB 0:00:00 [96.0KiB/s] [=================================================================================================] 121%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@autosnap_2025-02-03_19:46:23_monthly (~ 15.2 GB) to new target filesystem:
15.2GiB 0:01:18 [ 198MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_0/l2_0@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:23:25-GMT-06:00 (~ 4 KB):
5.18KiB 0:00:00 [88.2KiB/s] [=================================================================================================] 121%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@autosnap_2025-02-03_19:46:23_monthly (~ 15.7 GB) to new target filesystem:
15.7GiB 0:01:22 [ 195MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_0/l2_1@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:24:45-GMT-06:00 (~ 4 KB):
5.18KiB 0:00:00 [84.8KiB/s] [=================================================================================================] 121%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@autosnap_2025-02-03_19:46:23_monthly (~ 15.4 GB) to new target filesystem:
15.4GiB 0:01:20 [ 196MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_0/l2_2@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:26:08-GMT-06:00 (~ 4 KB):
5.18KiB 0:00:00 [89.0KiB/s] [=================================================================================================] 121%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@autosnap_2025-02-03_19:46:23_monthly (~ 15.8 GB) to new target filesystem:
15.8GiB 0:01:22 [ 195MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_0/l2_3@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:27:29-GMT-06:00 (~ 4 KB):
5.18KiB 0:00:00 [77.5KiB/s] [=================================================================================================] 121%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@autosnap_2025-02-03_19:46:23_monthly (~ 15.2 GB) to new target filesystem:
15.2GiB 0:01:18 [ 197MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_1@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:28:52-GMT-06:00 (~ 4 KB):
5.18KiB 0:00:00 [  99KiB/s] [=================================================================================================] 121%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@autosnap_2025-02-03_19:46:23_monthly (~ 15.4 GB) to new target filesystem:
15.4GiB 0:01:19 [ 197MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_1/l2_0@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:30:12-GMT-06:00 (~ 4 KB):
5.79KiB 0:00:00 [98.3KiB/s] [=================================================================================================] 118%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@autosnap_2025-02-03_19:46:23_monthly (~ 15.1 GB) to new target filesystem:
15.1GiB 0:01:19 [ 194MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_1/l2_1@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:31:33-GMT-06:00 (~ 4 KB):
5.79KiB 0:00:00 [93.1KiB/s] [=================================================================================================] 118%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_2@autosnap_2025-02-03_19:46:23_monthly (~ 15.6 GB) to new target filesystem:
15.6GiB 0:01:20 [ 198MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_1/l2_2@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:32:53-GMT-06:00 (~ 4 KB):
5.79KiB 0:00:00 [92.2KiB/s] [=================================================================================================] 118%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_3@autosnap_2025-02-03_19:46:23_monthly (~ 15.4 GB) to new target filesystem:
15.4GiB 0:01:19 [ 198MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_1/l2_3@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:34:14-GMT-06:00 (~ 4 KB):
5.79KiB 0:00:00 [82.4KiB/s] [=================================================================================================] 118%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2@autosnap_2025-02-03_19:46:23_monthly (~ 15.2 GB) to new target filesystem:
15.2GiB 0:01:19 [ 194MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_2@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:35:34-GMT-06:00 (~ 4 KB):
5.79KiB 0:00:00 [86.6KiB/s] [=================================================================================================] 118%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_0@autosnap_2025-02-03_19:46:23_monthly (~ 15.5 GB) to new target filesystem:
15.5GiB 0:01:22 [ 193MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_2/l2_0@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:36:55-GMT-06:00 (~ 4 KB):
5.79KiB 0:00:00 [90.4KiB/s] [=================================================================================================] 118%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_1@autosnap_2025-02-03_19:46:23_monthly (~ 15.6 GB) to new target filesystem:
15.6GiB 0:01:19 [ 200MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_2/l2_1@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:38:18-GMT-06:00 (~ 4 KB):
5.79KiB 0:00:00 [88.1KiB/s] [=================================================================================================] 118%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_2@autosnap_2025-02-03_19:46:23_monthly (~ 15.2 GB) to new target filesystem:
15.2GiB 0:01:19 [ 195MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_2/l2_2@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:39:38-GMT-06:00 (~ 4 KB):
5.79KiB 0:00:00 [98.2KiB/s] [=================================================================================================] 118%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_3@autosnap_2025-02-03_19:46:23_monthly (~ 15.3 GB) to new target filesystem:
15.3GiB 0:01:19 [ 197MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_2/l2_3@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:40:58-GMT-06:00 (~ 4 KB):
5.79KiB 0:00:00 [ 100KiB/s] [=================================================================================================] 118%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3@autosnap_2025-02-03_19:46:23_monthly (~ 15.3 GB) to new target filesystem:
15.3GiB 0:01:19 [ 197MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_3@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:42:19-GMT-06:00 (~ 4 KB):
5.79KiB 0:00:00 [96.5KiB/s] [=================================================================================================] 118%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3/l2_0@autosnap_2025-02-03_19:46:23_monthly (~ 15.8 GB) to new target filesystem:
15.8GiB 0:01:22 [ 195MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_3/l2_0@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:43:39-GMT-06:00 (~ 4 KB):
5.79KiB 0:00:00 [99.2KiB/s] [=================================================================================================] 118%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3/l2_1@autosnap_2025-02-03_19:46:23_monthly (~ 15.2 GB) to new target filesystem:
15.2GiB 0:01:20 [ 193MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_3/l2_1@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:45:02-GMT-06:00 (~ 5 KB):
6.40KiB 0:00:00 [97.0KiB/s] [=================================================================================================] 116%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3/l2_2@autosnap_2025-02-03_19:46:23_monthly (~ 15.5 GB) to new target filesystem:
15.5GiB 0:01:20 [ 197MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_3/l2_2@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:46:24-GMT-06:00 (~ 5 KB):
6.40KiB 0:00:00 [98.7KiB/s] [=================================================================================================] 116%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3/l2_3@autosnap_2025-02-03_19:46:23_monthly (~ 15.7 GB) to new target filesystem:
15.7GiB 0:02:19 [ 115MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_3/l2_3@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:47:45-GMT-06:00 (~ 5 KB):
6.40KiB 0:00:00 [96.7KiB/s] [=================================================================================================] 116%            
INFO: Sending oldest full snapshot send/test/l0_2@autosnap_2025-02-03_19:46:23_monthly (~ 5.1 GB) to new target filesystem:
5.14GiB 0:02:48 [31.2MiB/s] [================================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_2@autosnap_2025-02-03_19:46:23_monthly ... syncoid_orcus_2025-02-03:20:50:05-GMT-06:00 (~ 5 KB):
6.40KiB 0:00:00 [ 113KiB/s] [=================================================================================================] 116%            
real 3638.23
user 50.31
sys 2515.21
root@orcus:~# 
```

## 2025-02-03 full log file list

Filenames are `<timestamp>.operation.<elapsed time>.txt` and earlier files did not include the elapsed time.


```text
hbarta@orcus:~/logs$ ls -l
total 86440
-rw-r--r-- 1 hbarta hbarta     86 Feb  3 21:40 2025-02-03-2140.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6413 Feb  3 21:41 2025-02-03-2141.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 490801 Feb  3 21:44 2025-02-03-2142.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta 492079 Feb  3 22:14 2025-02-03-2213.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6543 Feb  3 22:16 2025-02-03-2215.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 495119 Feb  3 22:22 2025-02-03-2221.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  3 22:24 2025-02-03-2224.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 495081 Feb  3 22:29 2025-02-03-2228.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  3 22:30 2025-02-03-2230.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 490055 Feb  3 22:36 2025-02-03-2235.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  3 22:36 2025-02-03-2236.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 495304 Feb  3 22:43 2025-02-03-2242.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6424 Feb  3 22:42 2025-02-03-2242.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6533 Feb  3 22:48 2025-02-03-2248.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 494613 Feb  3 22:50 2025-02-03-2249.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  3 22:54 2025-02-03-2254.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 492551 Feb  3 22:57 2025-02-03-2256.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta 491804 Feb  3 23:00 2025-02-03-2300.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6543 Feb  3 23:01 2025-02-03-2300.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6441 Feb  3 23:06 2025-02-03-2306.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 494521 Feb  3 23:08 2025-02-03-2307.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  3 23:12 2025-02-03-2312.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 489130 Feb  3 23:14 2025-02-03-2314.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  3 23:18 2025-02-03-2318.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 498757 Feb  3 23:22 2025-02-03-2321.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  3 23:24 2025-02-03-2324.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 495521 Feb  3 23:29 2025-02-03-2328.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  3 23:30 2025-02-03-2330.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 497212 Feb  3 23:36 2025-02-03-2335.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  3 23:36 2025-02-03-2336.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 498301 Feb  3 23:42 2025-02-03-2342.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6425 Feb  3 23:42 2025-02-03-2342.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6532 Feb  3 23:48 2025-02-03-2348.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 492328 Feb  3 23:49 2025-02-03-2349.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  3 23:54 2025-02-03-2354.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 498175 Feb  3 23:57 2025-02-03-2356.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta 499984 Feb  4 00:00 2025-02-04-0000.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6543 Feb  4 00:01 2025-02-04-0000.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6544 Feb  4 00:15 2025-02-04-0006.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 493091 Feb  4 00:07 2025-02-04-0007.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6517 Feb  4 00:16 2025-02-04-0012.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 494550 Feb  4 00:14 2025-02-04-0014.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6435 Feb  4 00:18 2025-02-04-0018.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 489895 Feb  4 00:22 2025-02-04-0021.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 00:24 2025-02-04-0024.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 502236 Feb  4 00:29 2025-02-04-0028.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 00:30 2025-02-04-0030.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 498237 Feb  4 00:36 2025-02-04-0035.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 00:36 2025-02-04-0036.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 496214 Feb  4 00:42 2025-02-04-0042.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6425 Feb  4 00:42 2025-02-04-0042.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6532 Feb  4 00:48 2025-02-04-0048.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 493343 Feb  4 00:50 2025-02-04-0049.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 00:54 2025-02-04-0054.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 491688 Feb  4 00:57 2025-02-04-0056.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta 497803 Feb  4 01:00 2025-02-04-0100.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6543 Feb  4 01:01 2025-02-04-0100.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6441 Feb  4 01:06 2025-02-04-0106.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 496358 Feb  4 01:08 2025-02-04-0107.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 01:12 2025-02-04-0112.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 496854 Feb  4 01:15 2025-02-04-0114.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 01:18 2025-02-04-0118.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 502926 Feb  4 01:22 2025-02-04-0121.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 01:24 2025-02-04-0124.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 498226 Feb  4 01:29 2025-02-04-0128.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 01:30 2025-02-04-0130.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 497646 Feb  4 01:36 2025-02-04-0135.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 01:36 2025-02-04-0136.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 504199 Feb  4 01:42 2025-02-04-0142.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6425 Feb  4 01:42 2025-02-04-0142.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6532 Feb  4 01:48 2025-02-04-0148.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 497236 Feb  4 01:50 2025-02-04-0149.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 01:54 2025-02-04-0154.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 498570 Feb  4 01:57 2025-02-04-0156.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta 496333 Feb  4 02:00 2025-02-04-0200.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6543 Feb  4 02:01 2025-02-04-0200.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6441 Feb  4 02:06 2025-02-04-0206.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 490652 Feb  4 02:08 2025-02-04-0207.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 02:12 2025-02-04-0212.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 501640 Feb  4 02:15 2025-02-04-0214.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 02:18 2025-02-04-0218.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 492749 Feb  4 02:21 2025-02-04-0221.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 02:24 2025-02-04-0224.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 499898 Feb  4 02:28 2025-02-04-0228.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 02:30 2025-02-04-0230.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 491811 Feb  4 02:35 2025-02-04-0235.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 02:36 2025-02-04-0236.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 501329 Feb  4 02:42 2025-02-04-0242.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6427 Feb  4 02:42 2025-02-04-0242.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6532 Feb  4 02:48 2025-02-04-0248.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 499294 Feb  4 02:49 2025-02-04-0249.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 02:54 2025-02-04-0254.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 493642 Feb  4 02:56 2025-02-04-0256.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta 498237 Feb  4 03:00 2025-02-04-0300.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6543 Feb  4 03:01 2025-02-04-0300.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6440 Feb  4 03:06 2025-02-04-0306.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 499609 Feb  4 03:07 2025-02-04-0307.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 03:12 2025-02-04-0312.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 499615 Feb  4 03:14 2025-02-04-0314.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 03:18 2025-02-04-0318.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 494356 Feb  4 03:21 2025-02-04-0321.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 03:24 2025-02-04-0324.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 497830 Feb  4 03:28 2025-02-04-0328.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 03:30 2025-02-04-0330.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 494583 Feb  4 03:35 2025-02-04-0335.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 03:36 2025-02-04-0336.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 492034 Feb  4 03:42 2025-02-04-0342.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6434 Feb  4 03:42 2025-02-04-0342.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6527 Feb  4 03:48 2025-02-04-0348.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 495179 Feb  4 03:49 2025-02-04-0349.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 03:54 2025-02-04-0354.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 495400 Feb  4 03:56 2025-02-04-0356.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta 494729 Feb  4 04:00 2025-02-04-0400.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6543 Feb  4 04:01 2025-02-04-0400.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6440 Feb  4 04:06 2025-02-04-0406.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 495059 Feb  4 04:07 2025-02-04-0407.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 04:12 2025-02-04-0412.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 497276 Feb  4 04:14 2025-02-04-0414.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 04:18 2025-02-04-0418.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 498312 Feb  4 04:21 2025-02-04-0421.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 04:24 2025-02-04-0424.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 501702 Feb  4 04:28 2025-02-04-0428.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 04:30 2025-02-04-0430.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 497602 Feb  4 04:35 2025-02-04-0435.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 04:36 2025-02-04-0436.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 490508 Feb  4 04:42 2025-02-04-0442.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6430 Feb  4 04:42 2025-02-04-0442.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6532 Feb  4 04:48 2025-02-04-0448.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 495610 Feb  4 04:49 2025-02-04-0449.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 04:54 2025-02-04-0454.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 496596 Feb  4 04:56 2025-02-04-0456.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta 497714 Feb  4 05:00 2025-02-04-0500.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6543 Feb  4 05:01 2025-02-04-0500.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6440 Feb  4 05:06 2025-02-04-0506.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 495730 Feb  4 05:07 2025-02-04-0507.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 05:12 2025-02-04-0512.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 493559 Feb  4 05:14 2025-02-04-0514.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 05:18 2025-02-04-0518.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 502577 Feb  4 05:22 2025-02-04-0521.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 05:24 2025-02-04-0524.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 494316 Feb  4 05:28 2025-02-04-0528.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 05:30 2025-02-04-0530.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 491378 Feb  4 05:35 2025-02-04-0535.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 05:36 2025-02-04-0536.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 499934 Feb  4 05:42 2025-02-04-0542.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6433 Feb  4 05:42 2025-02-04-0542.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6530 Feb  4 05:48 2025-02-04-0548.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 492115 Feb  4 05:49 2025-02-04-0549.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 05:54 2025-02-04-0554.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 494779 Feb  4 05:56 2025-02-04-0556.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta 495476 Feb  4 06:00 2025-02-04-0600.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6543 Feb  4 06:01 2025-02-04-0600.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6544 Feb  4 06:17 2025-02-04-0606.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 492662 Feb  4 06:08 2025-02-04-0607.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6516 Feb  4 06:18 2025-02-04-0612.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 491516 Feb  4 06:15 2025-02-04-0614.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6438 Feb  4 06:18 2025-02-04-0618.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 495397 Feb  4 06:22 2025-02-04-0621.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 06:24 2025-02-04-0624.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 501367 Feb  4 06:29 2025-02-04-0628.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 06:30 2025-02-04-0630.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 494778 Feb  4 06:36 2025-02-04-0635.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 06:36 2025-02-04-0636.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 493298 Feb  4 06:43 2025-02-04-0642.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6426 Feb  4 06:42 2025-02-04-0642.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6532 Feb  4 06:48 2025-02-04-0648.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 493108 Feb  4 06:50 2025-02-04-0649.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 06:54 2025-02-04-0654.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 491018 Feb  4 06:57 2025-02-04-0656.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta 497338 Feb  4 07:00 2025-02-04-0700.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6543 Feb  4 07:01 2025-02-04-0700.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6445 Feb  4 07:06 2025-02-04-0706.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 493648 Feb  4 07:08 2025-02-04-0707.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 07:12 2025-02-04-0712.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 490210 Feb  4 07:15 2025-02-04-0714.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 07:18 2025-02-04-0718.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 500815 Feb  4 07:22 2025-02-04-0721.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 07:24 2025-02-04-0724.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 490711 Feb  4 07:29 2025-02-04-0728.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 07:30 2025-02-04-0730.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 497772 Feb  4 07:36 2025-02-04-0735.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 07:36 2025-02-04-0736.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 490571 Feb  4 07:43 2025-02-04-0742.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6431 Feb  4 07:42 2025-02-04-0742.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6531 Feb  4 07:48 2025-02-04-0748.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 498083 Feb  4 07:50 2025-02-04-0749.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 07:54 2025-02-04-0754.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 489780 Feb  4 07:57 2025-02-04-0756.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta 498750 Feb  4 08:00 2025-02-04-0800.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6543 Feb  4 08:01 2025-02-04-0800.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6443 Feb  4 08:06 2025-02-04-0806.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 498453 Feb  4 08:08 2025-02-04-0807.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 08:12 2025-02-04-0812.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 497091 Feb  4 08:15 2025-02-04-0814.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 08:18 2025-02-04-0818.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 495633 Feb  4 08:22 2025-02-04-0821.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 08:24 2025-02-04-0824.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 494582 Feb  4 08:29 2025-02-04-0828.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 08:30 2025-02-04-0830.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 498163 Feb  4 08:36 2025-02-04-0835.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 08:36 2025-02-04-0836.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 492323 Feb  4 08:42 2025-02-04-0842.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6442 Feb  4 08:42 2025-02-04-0842.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6521 Feb  4 08:48 2025-02-04-0848.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 496476 Feb  4 08:49 2025-02-04-0849.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 08:54 2025-02-04-0854.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 495360 Feb  4 08:56 2025-02-04-0856.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta 489753 Feb  4 09:00 2025-02-04-0900.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6543 Feb  4 09:01 2025-02-04-0900.syncoid.txt
-rw-r--r-- 1 hbarta hbarta   6440 Feb  4 09:06 2025-02-04-0906.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 493047 Feb  4 09:08 2025-02-04-0907.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 09:12 2025-02-04-0912.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 500699 Feb  4 09:14 2025-02-04-0914.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 09:18 2025-02-04-0918.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 499698 Feb  4 09:21 2025-02-04-0921.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta   6542 Feb  4 09:24 2025-02-04-0924.syncoid.txt
-rw-r--r-- 1 hbarta hbarta      0 Feb  4 09:38 2025-02-04-0937.stir_pools.63.txt
-rw-r--r-- 1 hbarta hbarta      0 Feb  4 09:38 2025-02-04-0937.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta    309 Feb  4 09:48 2025-02-04-0948.stir_pools.0.txt
-rw-r--r-- 1 hbarta hbarta 495422 Feb  4 09:51 2025-02-04-0950.stir_pools.67.txt
-rw-r--r-- 1 hbarta hbarta   6853 Feb  4 09:54 2025-02-04-0952.syncoid.132.txt
-rw-r--r-- 1 hbarta hbarta   6723 Feb  4 10:24 2025-02-04-1024.syncoid.27.txt
-rw-r--r-- 1 hbarta hbarta 496534 Feb  4 10:29 2025-02-04-1028.stir_pools.59.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 10:30 2025-02-04-1030.syncoid.58.txt
-rw-r--r-- 1 hbarta hbarta 494766 Feb  4 10:35 2025-02-04-1035.stir_pools.58.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 10:36 2025-02-04-1036.syncoid.57.txt
-rw-r--r-- 1 hbarta hbarta 491628 Feb  4 10:42 2025-02-04-1042.stir_pools.51.txt
-rw-r--r-- 1 hbarta hbarta   6750 Feb  4 10:42 2025-02-04-1042.syncoid.30.txt
-rw-r--r-- 1 hbarta hbarta   6830 Feb  4 10:48 2025-02-04-1048.syncoid.52.txt
-rw-r--r-- 1 hbarta hbarta 487131 Feb  4 10:49 2025-02-04-1049.stir_pools.57.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 10:54 2025-02-04-1054.syncoid.57.txt
-rw-r--r-- 1 hbarta hbarta 495448 Feb  4 10:56 2025-02-04-1056.stir_pools.58.txt
-rw-r--r-- 1 hbarta hbarta 496467 Feb  4 11:00 2025-02-04-1100.stir_pools.50.txt
-rw-r--r-- 1 hbarta hbarta   6852 Feb  4 11:01 2025-02-04-1100.syncoid.87.txt
-rw-r--r-- 1 hbarta hbarta   6749 Feb  4 11:06 2025-02-04-1106.syncoid.29.txt
-rw-r--r-- 1 hbarta hbarta 498406 Feb  4 11:08 2025-02-04-1107.stir_pools.59.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 11:12 2025-02-04-1112.syncoid.58.txt
-rw-r--r-- 1 hbarta hbarta 495016 Feb  4 11:15 2025-02-04-1114.stir_pools.59.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 11:19 2025-02-04-1118.syncoid.59.txt
-rw-r--r-- 1 hbarta hbarta 502246 Feb  4 11:22 2025-02-04-1121.stir_pools.60.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 11:24 2025-02-04-1124.syncoid.58.txt
-rw-r--r-- 1 hbarta hbarta 489200 Feb  4 11:28 2025-02-04-1128.stir_pools.57.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 11:31 2025-02-04-1130.syncoid.59.txt
-rw-r--r-- 1 hbarta hbarta 498138 Feb  4 11:36 2025-02-04-1135.stir_pools.60.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 11:36 2025-02-04-1136.syncoid.58.txt
-rw-r--r-- 1 hbarta hbarta 488356 Feb  4 11:42 2025-02-04-1142.stir_pools.50.txt
-rw-r--r-- 1 hbarta hbarta   6743 Feb  4 11:42 2025-02-04-1142.syncoid.29.txt
-rw-r--r-- 1 hbarta hbarta   6833 Feb  4 11:48 2025-02-04-1148.syncoid.55.txt
-rw-r--r-- 1 hbarta hbarta 494631 Feb  4 11:49 2025-02-04-1149.stir_pools.57.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 11:54 2025-02-04-1154.syncoid.57.txt
-rw-r--r-- 1 hbarta hbarta 494335 Feb  4 11:56 2025-02-04-1156.stir_pools.58.txt
-rw-r--r-- 1 hbarta hbarta 497676 Feb  4 12:00 2025-02-04-1200.stir_pools.50.txt
-rw-r--r-- 1 hbarta hbarta   6852 Feb  4 12:01 2025-02-04-1200.syncoid.86.txt
-rw-r--r-- 1 hbarta hbarta   6931 Feb  4 12:18 2025-02-04-1206.syncoid.719.txt
-rw-r--r-- 1 hbarta hbarta 488320 Feb  4 12:08 2025-02-04-1207.stir_pools.65.txt
-rw-r--r-- 1 hbarta hbarta   7386 Feb  4 12:19 2025-02-04-1212.syncoid.457.txt
-rw-r--r-- 1 hbarta hbarta 488363 Feb  4 12:15 2025-02-04-1214.stir_pools.70.txt
-rw-r--r-- 1 hbarta hbarta   6962 Feb  4 12:19 2025-02-04-1218.syncoid.98.txt
-rw-r--r-- 1 hbarta hbarta 486248 Feb  4 12:22 2025-02-04-1221.stir_pools.76.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 12:24 2025-02-04-1224.syncoid.50.txt
-rw-r--r-- 1 hbarta hbarta 491640 Feb  4 12:29 2025-02-04-1228.stir_pools.76.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 12:30 2025-02-04-1230.syncoid.49.txt
-rw-r--r-- 1 hbarta hbarta 492441 Feb  4 12:36 2025-02-04-1235.stir_pools.74.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 12:36 2025-02-04-1236.syncoid.48.txt
-rw-r--r-- 1 hbarta hbarta 495998 Feb  4 12:43 2025-02-04-1242.stir_pools.71.txt
-rw-r--r-- 1 hbarta hbarta   6735 Feb  4 12:42 2025-02-04-1242.syncoid.27.txt
-rw-r--r-- 1 hbarta hbarta   6841 Feb  4 12:48 2025-02-04-1248.syncoid.46.txt
-rw-r--r-- 1 hbarta hbarta 492245 Feb  4 12:50 2025-02-04-1249.stir_pools.75.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 12:54 2025-02-04-1254.syncoid.47.txt
-rw-r--r-- 1 hbarta hbarta 494447 Feb  4 12:57 2025-02-04-1256.stir_pools.76.txt
-rw-r--r-- 1 hbarta hbarta 492142 Feb  4 13:01 2025-02-04-1300.stir_pools.64.txt
-rw-r--r-- 1 hbarta hbarta   6852 Feb  4 13:00 2025-02-04-1300.syncoid.54.txt
-rw-r--r-- 1 hbarta hbarta   6813 Feb  4 13:06 2025-02-04-1306.syncoid.36.txt
-rw-r--r-- 1 hbarta hbarta 495315 Feb  4 13:08 2025-02-04-1307.stir_pools.77.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 13:12 2025-02-04-1312.syncoid.49.txt
-rw-r--r-- 1 hbarta hbarta 485033 Feb  4 13:15 2025-02-04-1314.stir_pools.74.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 13:18 2025-02-04-1318.syncoid.51.txt
-rw-r--r-- 1 hbarta hbarta 493983 Feb  4 13:22 2025-02-04-1321.stir_pools.74.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 13:24 2025-02-04-1324.syncoid.48.txt
-rw-r--r-- 1 hbarta hbarta 491819 Feb  4 13:29 2025-02-04-1328.stir_pools.74.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 13:30 2025-02-04-1330.syncoid.50.txt
-rw-r--r-- 1 hbarta hbarta 495937 Feb  4 13:36 2025-02-04-1335.stir_pools.70.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 13:36 2025-02-04-1336.syncoid.51.txt
-rw-r--r-- 1 hbarta hbarta 497373 Feb  4 13:43 2025-02-04-1342.stir_pools.65.txt
-rw-r--r-- 1 hbarta hbarta   6735 Feb  4 13:42 2025-02-04-1342.syncoid.27.txt
-rw-r--r-- 1 hbarta hbarta   6841 Feb  4 13:48 2025-02-04-1348.syncoid.47.txt
-rw-r--r-- 1 hbarta hbarta 491351 Feb  4 13:50 2025-02-04-1349.stir_pools.69.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 13:54 2025-02-04-1354.syncoid.53.txt
-rw-r--r-- 1 hbarta hbarta 492278 Feb  4 13:57 2025-02-04-1356.stir_pools.68.txt
-rw-r--r-- 1 hbarta hbarta 492349 Feb  4 14:00 2025-02-04-1400.stir_pools.55.txt
-rw-r--r-- 1 hbarta hbarta   6852 Feb  4 14:01 2025-02-04-1400.syncoid.69.txt
-rw-r--r-- 1 hbarta hbarta   6754 Feb  4 14:06 2025-02-04-1406.syncoid.27.txt
-rw-r--r-- 1 hbarta hbarta 489821 Feb  4 14:08 2025-02-04-1407.stir_pools.66.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 14:12 2025-02-04-1412.syncoid.54.txt
-rw-r--r-- 1 hbarta hbarta 492028 Feb  4 14:15 2025-02-04-1414.stir_pools.66.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 14:18 2025-02-04-1418.syncoid.54.txt
-rw-r--r-- 1 hbarta hbarta 502471 Feb  4 14:22 2025-02-04-1421.stir_pools.65.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 14:24 2025-02-04-1424.syncoid.52.txt
-rw-r--r-- 1 hbarta hbarta 502536 Feb  4 14:29 2025-02-04-1428.stir_pools.65.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 14:30 2025-02-04-1430.syncoid.56.txt
-rw-r--r-- 1 hbarta hbarta 495387 Feb  4 14:36 2025-02-04-1435.stir_pools.62.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 14:36 2025-02-04-1436.syncoid.52.txt
-rw-r--r-- 1 hbarta hbarta 494067 Feb  4 14:42 2025-02-04-1442.stir_pools.57.txt
-rw-r--r-- 1 hbarta hbarta   6747 Feb  4 14:42 2025-02-04-1442.syncoid.31.txt
-rw-r--r-- 1 hbarta hbarta   6833 Feb  4 14:48 2025-02-04-1448.syncoid.49.txt
-rw-r--r-- 1 hbarta hbarta 496763 Feb  4 14:50 2025-02-04-1449.stir_pools.62.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 14:54 2025-02-04-1454.syncoid.56.txt
-rw-r--r-- 1 hbarta hbarta 496202 Feb  4 14:57 2025-02-04-1456.stir_pools.60.txt
-rw-r--r-- 1 hbarta hbarta 501648 Feb  4 15:00 2025-02-04-1500.stir_pools.52.txt
-rw-r--r-- 1 hbarta hbarta   6852 Feb  4 15:01 2025-02-04-1500.syncoid.78.txt
-rw-r--r-- 1 hbarta hbarta   6749 Feb  4 15:06 2025-02-04-1506.syncoid.26.txt
-rw-r--r-- 1 hbarta hbarta 499458 Feb  4 15:08 2025-02-04-1507.stir_pools.61.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 15:12 2025-02-04-1512.syncoid.55.txt
-rw-r--r-- 1 hbarta hbarta 496541 Feb  4 15:15 2025-02-04-1514.stir_pools.59.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 15:19 2025-02-04-1518.syncoid.60.txt
-rw-r--r-- 1 hbarta hbarta 497234 Feb  4 15:21 2025-02-04-1521.stir_pools.58.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 15:25 2025-02-04-1524.syncoid.59.txt
-rw-r--r-- 1 hbarta hbarta 494336 Feb  4 15:28 2025-02-04-1528.stir_pools.57.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 15:31 2025-02-04-1530.syncoid.60.txt
-rw-r--r-- 1 hbarta hbarta 492646 Feb  4 15:35 2025-02-04-1535.stir_pools.57.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 15:36 2025-02-04-1536.syncoid.58.txt
-rw-r--r-- 1 hbarta hbarta 498790 Feb  4 15:42 2025-02-04-1542.stir_pools.50.txt
-rw-r--r-- 1 hbarta hbarta   6754 Feb  4 15:42 2025-02-04-1542.syncoid.34.txt
-rw-r--r-- 1 hbarta hbarta   6822 Feb  4 15:48 2025-02-04-1548.syncoid.52.txt
-rw-r--r-- 1 hbarta hbarta 494462 Feb  4 15:49 2025-02-04-1549.stir_pools.57.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 15:55 2025-02-04-1554.syncoid.59.txt
-rw-r--r-- 1 hbarta hbarta 492728 Feb  4 15:56 2025-02-04-1556.stir_pools.57.txt
-rw-r--r-- 1 hbarta hbarta 500233 Feb  4 16:00 2025-02-04-1600.stir_pools.50.txt
-rw-r--r-- 1 hbarta hbarta   6852 Feb  4 16:01 2025-02-04-1600.syncoid.87.txt
-rw-r--r-- 1 hbarta hbarta   6749 Feb  4 16:06 2025-02-04-1606.syncoid.31.txt
-rw-r--r-- 1 hbarta hbarta 499171 Feb  4 16:07 2025-02-04-1607.stir_pools.57.txt
-rw-r--r-- 1 hbarta hbarta   6851 Feb  4 16:12 2025-02-04-1612.syncoid.58.txt
-rw-r--r-- 1 hbarta hbarta 491105 Feb  4 16:14 2025-02-04-1614.stir_pools.58.txt
-rw-r--r-- 1 hbarta hbarta   7762 Feb  4 16:19 2025-02-04-1618.syncoid.59.txt               <<< first corruption
-rw-r--r-- 1 hbarta hbarta 495515 Feb  4 16:22 2025-02-04-1621.stir_pools.59.txt
-rw-r--r-- 1 hbarta hbarta  10028 Feb  4 16:24 2025-02-04-1624.syncoid.53.txt
-rw-r--r-- 1 hbarta hbarta 493205 Feb  4 16:29 2025-02-04-1628.stir_pools.59.txt
-rw-r--r-- 1 hbarta hbarta  28601 Feb  4 16:30 2025-02-04-1630.syncoid.25.txt
-rw-r--r-- 1 hbarta hbarta 499555 Feb  4 16:36 2025-02-04-1635.stir_pools.61.txt
-rw-r--r-- 1 hbarta hbarta  30734 Feb  4 16:36 2025-02-04-1636.syncoid.28.txt
-rw-r--r-- 1 hbarta hbarta 503867 Feb  4 16:43 2025-02-04-1642.stir_pools.59.txt
-rw-r--r-- 1 hbarta hbarta  30969 Feb  4 16:42 2025-02-04-1642.syncoid.22.txt
-rw-r--r-- 1 hbarta hbarta  30601 Feb  4 16:48 2025-02-04-1648.syncoid.25.txt
-rw-r--r-- 1 hbarta hbarta 494881 Feb  4 16:50 2025-02-04-1649.stir_pools.65.txt
-rw-r--r-- 1 hbarta hbarta  30723 Feb  4 16:54 2025-02-04-1654.syncoid.25.txt
-rw-r--r-- 1 hbarta hbarta 498881 Feb  4 16:57 2025-02-04-1656.stir_pools.66.txt
-rw-r--r-- 1 hbarta hbarta 497148 Feb  4 17:01 2025-02-04-1700.stir_pools.64.txt
-rw-r--r-- 1 hbarta hbarta  30571 Feb  4 17:00 2025-02-04-1700.syncoid.26.txt
-rw-r--r-- 1 hbarta hbarta  30671 Feb  4 17:06 2025-02-04-1706.syncoid.24.txt
-rw-r--r-- 1 hbarta hbarta 487343 Feb  4 17:08 2025-02-04-1707.stir_pools.69.txt
-rw-r--r-- 1 hbarta hbarta  31727 Feb  4 17:12 2025-02-04-1712.syncoid.25.txt
-rw-r--r-- 1 hbarta hbarta 503935 Feb  4 17:15 2025-02-04-1714.stir_pools.72.txt
-rw-r--r-- 1 hbarta hbarta  32293 Feb  4 17:18 2025-02-04-1718.syncoid.24.txt
-rw-r--r-- 1 hbarta hbarta 490872 Feb  4 17:22 2025-02-04-1721.stir_pools.72.txt
-rw-r--r-- 1 hbarta hbarta  32403 Feb  4 17:24 2025-02-04-1724.syncoid.24.txt
-rw-r--r-- 1 hbarta hbarta 493714 Feb  4 17:29 2025-02-04-1728.stir_pools.74.txt
-rw-r--r-- 1 hbarta hbarta  32830 Feb  4 17:30 2025-02-04-1730.syncoid.23.txt
-rw-r--r-- 1 hbarta hbarta 491778 Feb  4 17:36 2025-02-04-1735.stir_pools.73.txt
-rw-r--r-- 1 hbarta hbarta  32805 Feb  4 17:36 2025-02-04-1736.syncoid.25.txt
-rw-r--r-- 1 hbarta hbarta 493865 Feb  4 17:43 2025-02-04-1742.stir_pools.73.txt
-rw-r--r-- 1 hbarta hbarta  32802 Feb  4 17:42 2025-02-04-1742.syncoid.24.txt
-rw-r--r-- 1 hbarta hbarta  32807 Feb  4 17:48 2025-02-04-1748.syncoid.25.txt
-rw-r--r-- 1 hbarta hbarta 487387 Feb  4 17:50 2025-02-04-1749.stir_pools.77.txt
-rw-r--r-- 1 hbarta hbarta  32834 Feb  4 17:54 2025-02-04-1754.syncoid.25.txt
-rw-r--r-- 1 hbarta hbarta 491565 Feb  4 17:57 2025-02-04-1756.stir_pools.79.txt
-rw-r--r-- 1 hbarta hbarta 495181 Feb  4 18:01 2025-02-04-1800.stir_pools.73.txt
-rw-r--r-- 1 hbarta hbarta  32809 Feb  4 18:00 2025-02-04-1800.syncoid.26.txt
-rw-r--r-- 1 hbarta hbarta  16850 Feb  4 18:09 2025-02-04-1806.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 489107 Feb  4 18:08 2025-02-04-1807.stir_pools.87.txt
-rw-r--r-- 1 hbarta hbarta      0 Feb  4 18:12 2025-02-04-1812.syncoid.txt
-rw-r--r-- 1 hbarta hbarta 438786 Feb  4 18:15 2025-02-04-1814.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta      0 Feb  4 18:18 2025-02-04-1818.syncoid.txt
-rw-r--r-- 1 hbarta hbarta     13 Feb  4 18:21 2025-02-04-1821.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta      0 Feb  4 18:24 2025-02-04-1824.syncoid.txt
-rw-r--r-- 1 hbarta hbarta     13 Feb  4 18:28 2025-02-04-1828.stir_pools.txt
-rw-r--r-- 1 hbarta hbarta      0 Feb  4 18:30 2025-02-04-1830.syncoid.txt
hbarta@orcus:~/logs$ 
```

## 2025-02-03 list of all syncoid logs

```text
hbarta@orcus:~/logs$ ls -l *syncoid*
-rw-r--r-- 1 hbarta hbarta    86 Feb  3 21:40 2025-02-03-2140.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6413 Feb  3 21:41 2025-02-03-2141.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6543 Feb  3 22:16 2025-02-03-2215.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  3 22:24 2025-02-03-2224.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  3 22:30 2025-02-03-2230.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  3 22:36 2025-02-03-2236.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6424 Feb  3 22:42 2025-02-03-2242.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6533 Feb  3 22:48 2025-02-03-2248.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  3 22:54 2025-02-03-2254.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6543 Feb  3 23:01 2025-02-03-2300.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6441 Feb  3 23:06 2025-02-03-2306.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  3 23:12 2025-02-03-2312.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  3 23:18 2025-02-03-2318.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  3 23:24 2025-02-03-2324.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  3 23:30 2025-02-03-2330.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  3 23:36 2025-02-03-2336.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6425 Feb  3 23:42 2025-02-03-2342.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6532 Feb  3 23:48 2025-02-03-2348.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  3 23:54 2025-02-03-2354.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6543 Feb  4 00:01 2025-02-04-0000.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6544 Feb  4 00:15 2025-02-04-0006.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6517 Feb  4 00:16 2025-02-04-0012.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6435 Feb  4 00:18 2025-02-04-0018.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 00:24 2025-02-04-0024.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 00:30 2025-02-04-0030.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 00:36 2025-02-04-0036.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6425 Feb  4 00:42 2025-02-04-0042.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6532 Feb  4 00:48 2025-02-04-0048.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 00:54 2025-02-04-0054.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6543 Feb  4 01:01 2025-02-04-0100.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6441 Feb  4 01:06 2025-02-04-0106.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 01:12 2025-02-04-0112.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 01:18 2025-02-04-0118.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 01:24 2025-02-04-0124.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 01:30 2025-02-04-0130.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 01:36 2025-02-04-0136.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6425 Feb  4 01:42 2025-02-04-0142.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6532 Feb  4 01:48 2025-02-04-0148.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 01:54 2025-02-04-0154.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6543 Feb  4 02:01 2025-02-04-0200.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6441 Feb  4 02:06 2025-02-04-0206.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 02:12 2025-02-04-0212.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 02:18 2025-02-04-0218.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 02:24 2025-02-04-0224.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 02:30 2025-02-04-0230.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 02:36 2025-02-04-0236.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6427 Feb  4 02:42 2025-02-04-0242.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6532 Feb  4 02:48 2025-02-04-0248.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 02:54 2025-02-04-0254.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6543 Feb  4 03:01 2025-02-04-0300.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6440 Feb  4 03:06 2025-02-04-0306.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 03:12 2025-02-04-0312.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 03:18 2025-02-04-0318.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 03:24 2025-02-04-0324.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 03:30 2025-02-04-0330.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 03:36 2025-02-04-0336.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6434 Feb  4 03:42 2025-02-04-0342.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6527 Feb  4 03:48 2025-02-04-0348.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 03:54 2025-02-04-0354.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6543 Feb  4 04:01 2025-02-04-0400.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6440 Feb  4 04:06 2025-02-04-0406.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 04:12 2025-02-04-0412.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 04:18 2025-02-04-0418.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 04:24 2025-02-04-0424.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 04:30 2025-02-04-0430.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 04:36 2025-02-04-0436.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6430 Feb  4 04:42 2025-02-04-0442.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6532 Feb  4 04:48 2025-02-04-0448.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 04:54 2025-02-04-0454.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6543 Feb  4 05:01 2025-02-04-0500.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6440 Feb  4 05:06 2025-02-04-0506.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 05:12 2025-02-04-0512.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 05:18 2025-02-04-0518.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 05:24 2025-02-04-0524.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 05:30 2025-02-04-0530.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 05:36 2025-02-04-0536.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6433 Feb  4 05:42 2025-02-04-0542.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6530 Feb  4 05:48 2025-02-04-0548.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 05:54 2025-02-04-0554.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6543 Feb  4 06:01 2025-02-04-0600.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6544 Feb  4 06:17 2025-02-04-0606.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6516 Feb  4 06:18 2025-02-04-0612.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6438 Feb  4 06:18 2025-02-04-0618.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 06:24 2025-02-04-0624.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 06:30 2025-02-04-0630.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 06:36 2025-02-04-0636.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6426 Feb  4 06:42 2025-02-04-0642.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6532 Feb  4 06:48 2025-02-04-0648.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 06:54 2025-02-04-0654.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6543 Feb  4 07:01 2025-02-04-0700.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6445 Feb  4 07:06 2025-02-04-0706.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 07:12 2025-02-04-0712.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 07:18 2025-02-04-0718.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 07:24 2025-02-04-0724.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 07:30 2025-02-04-0730.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 07:36 2025-02-04-0736.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6431 Feb  4 07:42 2025-02-04-0742.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6531 Feb  4 07:48 2025-02-04-0748.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 07:54 2025-02-04-0754.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6543 Feb  4 08:01 2025-02-04-0800.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6443 Feb  4 08:06 2025-02-04-0806.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 08:12 2025-02-04-0812.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 08:18 2025-02-04-0818.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 08:24 2025-02-04-0824.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 08:30 2025-02-04-0830.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 08:36 2025-02-04-0836.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6442 Feb  4 08:42 2025-02-04-0842.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6521 Feb  4 08:48 2025-02-04-0848.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 08:54 2025-02-04-0854.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6543 Feb  4 09:01 2025-02-04-0900.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6440 Feb  4 09:06 2025-02-04-0906.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 09:12 2025-02-04-0912.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 09:18 2025-02-04-0918.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6542 Feb  4 09:24 2025-02-04-0924.syncoid.txt
-rw-r--r-- 1 hbarta hbarta  6853 Feb  4 09:54 2025-02-04-0952.syncoid.132.txt
-rw-r--r-- 1 hbarta hbarta  6723 Feb  4 10:24 2025-02-04-1024.syncoid.27.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 10:30 2025-02-04-1030.syncoid.58.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 10:36 2025-02-04-1036.syncoid.57.txt
-rw-r--r-- 1 hbarta hbarta  6750 Feb  4 10:42 2025-02-04-1042.syncoid.30.txt
-rw-r--r-- 1 hbarta hbarta  6830 Feb  4 10:48 2025-02-04-1048.syncoid.52.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 10:54 2025-02-04-1054.syncoid.57.txt
-rw-r--r-- 1 hbarta hbarta  6852 Feb  4 11:01 2025-02-04-1100.syncoid.87.txt
-rw-r--r-- 1 hbarta hbarta  6749 Feb  4 11:06 2025-02-04-1106.syncoid.29.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 11:12 2025-02-04-1112.syncoid.58.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 11:19 2025-02-04-1118.syncoid.59.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 11:24 2025-02-04-1124.syncoid.58.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 11:31 2025-02-04-1130.syncoid.59.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 11:36 2025-02-04-1136.syncoid.58.txt
-rw-r--r-- 1 hbarta hbarta  6743 Feb  4 11:42 2025-02-04-1142.syncoid.29.txt
-rw-r--r-- 1 hbarta hbarta  6833 Feb  4 11:48 2025-02-04-1148.syncoid.55.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 11:54 2025-02-04-1154.syncoid.57.txt
-rw-r--r-- 1 hbarta hbarta  6852 Feb  4 12:01 2025-02-04-1200.syncoid.86.txt
-rw-r--r-- 1 hbarta hbarta  6931 Feb  4 12:18 2025-02-04-1206.syncoid.719.txt
-rw-r--r-- 1 hbarta hbarta  7386 Feb  4 12:19 2025-02-04-1212.syncoid.457.txt
-rw-r--r-- 1 hbarta hbarta  6962 Feb  4 12:19 2025-02-04-1218.syncoid.98.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 12:24 2025-02-04-1224.syncoid.50.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 12:30 2025-02-04-1230.syncoid.49.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 12:36 2025-02-04-1236.syncoid.48.txt
-rw-r--r-- 1 hbarta hbarta  6735 Feb  4 12:42 2025-02-04-1242.syncoid.27.txt
-rw-r--r-- 1 hbarta hbarta  6841 Feb  4 12:48 2025-02-04-1248.syncoid.46.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 12:54 2025-02-04-1254.syncoid.47.txt
-rw-r--r-- 1 hbarta hbarta  6852 Feb  4 13:00 2025-02-04-1300.syncoid.54.txt
-rw-r--r-- 1 hbarta hbarta  6813 Feb  4 13:06 2025-02-04-1306.syncoid.36.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 13:12 2025-02-04-1312.syncoid.49.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 13:18 2025-02-04-1318.syncoid.51.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 13:24 2025-02-04-1324.syncoid.48.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 13:30 2025-02-04-1330.syncoid.50.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 13:36 2025-02-04-1336.syncoid.51.txt
-rw-r--r-- 1 hbarta hbarta  6735 Feb  4 13:42 2025-02-04-1342.syncoid.27.txt
-rw-r--r-- 1 hbarta hbarta  6841 Feb  4 13:48 2025-02-04-1348.syncoid.47.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 13:54 2025-02-04-1354.syncoid.53.txt
-rw-r--r-- 1 hbarta hbarta  6852 Feb  4 14:01 2025-02-04-1400.syncoid.69.txt
-rw-r--r-- 1 hbarta hbarta  6754 Feb  4 14:06 2025-02-04-1406.syncoid.27.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 14:12 2025-02-04-1412.syncoid.54.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 14:18 2025-02-04-1418.syncoid.54.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 14:24 2025-02-04-1424.syncoid.52.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 14:30 2025-02-04-1430.syncoid.56.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 14:36 2025-02-04-1436.syncoid.52.txt
-rw-r--r-- 1 hbarta hbarta  6747 Feb  4 14:42 2025-02-04-1442.syncoid.31.txt
-rw-r--r-- 1 hbarta hbarta  6833 Feb  4 14:48 2025-02-04-1448.syncoid.49.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 14:54 2025-02-04-1454.syncoid.56.txt
-rw-r--r-- 1 hbarta hbarta  6852 Feb  4 15:01 2025-02-04-1500.syncoid.78.txt
-rw-r--r-- 1 hbarta hbarta  6749 Feb  4 15:06 2025-02-04-1506.syncoid.26.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 15:12 2025-02-04-1512.syncoid.55.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 15:19 2025-02-04-1518.syncoid.60.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 15:25 2025-02-04-1524.syncoid.59.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 15:31 2025-02-04-1530.syncoid.60.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 15:36 2025-02-04-1536.syncoid.58.txt
-rw-r--r-- 1 hbarta hbarta  6754 Feb  4 15:42 2025-02-04-1542.syncoid.34.txt
-rw-r--r-- 1 hbarta hbarta  6822 Feb  4 15:48 2025-02-04-1548.syncoid.52.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 15:55 2025-02-04-1554.syncoid.59.txt
-rw-r--r-- 1 hbarta hbarta  6852 Feb  4 16:01 2025-02-04-1600.syncoid.87.txt
-rw-r--r-- 1 hbarta hbarta  6749 Feb  4 16:06 2025-02-04-1606.syncoid.31.txt
-rw-r--r-- 1 hbarta hbarta  6851 Feb  4 16:12 2025-02-04-1612.syncoid.58.txt
-rw-r--r-- 1 hbarta hbarta  7762 Feb  4 16:19 2025-02-04-1618.syncoid.59.txt               <<< first corruption
-rw-r--r-- 1 hbarta hbarta 10028 Feb  4 16:24 2025-02-04-1624.syncoid.53.txt
-rw-r--r-- 1 hbarta hbarta 28601 Feb  4 16:30 2025-02-04-1630.syncoid.25.txt
-rw-r--r-- 1 hbarta hbarta 30734 Feb  4 16:36 2025-02-04-1636.syncoid.28.txt
-rw-r--r-- 1 hbarta hbarta 30969 Feb  4 16:42 2025-02-04-1642.syncoid.22.txt
-rw-r--r-- 1 hbarta hbarta 30601 Feb  4 16:48 2025-02-04-1648.syncoid.25.txt
-rw-r--r-- 1 hbarta hbarta 30723 Feb  4 16:54 2025-02-04-1654.syncoid.25.txt
-rw-r--r-- 1 hbarta hbarta 30571 Feb  4 17:00 2025-02-04-1700.syncoid.26.txt
-rw-r--r-- 1 hbarta hbarta 30671 Feb  4 17:06 2025-02-04-1706.syncoid.24.txt
-rw-r--r-- 1 hbarta hbarta 31727 Feb  4 17:12 2025-02-04-1712.syncoid.25.txt
-rw-r--r-- 1 hbarta hbarta 32293 Feb  4 17:18 2025-02-04-1718.syncoid.24.txt
-rw-r--r-- 1 hbarta hbarta 32403 Feb  4 17:24 2025-02-04-1724.syncoid.24.txt
-rw-r--r-- 1 hbarta hbarta 32830 Feb  4 17:30 2025-02-04-1730.syncoid.23.txt
-rw-r--r-- 1 hbarta hbarta 32805 Feb  4 17:36 2025-02-04-1736.syncoid.25.txt
-rw-r--r-- 1 hbarta hbarta 32802 Feb  4 17:42 2025-02-04-1742.syncoid.24.txt
-rw-r--r-- 1 hbarta hbarta 32807 Feb  4 17:48 2025-02-04-1748.syncoid.25.txt
-rw-r--r-- 1 hbarta hbarta 32834 Feb  4 17:54 2025-02-04-1754.syncoid.25.txt
-rw-r--r-- 1 hbarta hbarta 32809 Feb  4 18:00 2025-02-04-1800.syncoid.26.txt
-rw-r--r-- 1 hbarta hbarta 16850 Feb  4 18:09 2025-02-04-1806.syncoid.txt
-rw-r--r-- 1 hbarta hbarta     0 Feb  4 18:12 2025-02-04-1812.syncoid.txt
-rw-r--r-- 1 hbarta hbarta     0 Feb  4 18:18 2025-02-04-1818.syncoid.txt
-rw-r--r-- 1 hbarta hbarta     0 Feb  4 18:24 2025-02-04-1824.syncoid.txt
-rw-r--r-- 1 hbarta hbarta     0 Feb  4 18:30 2025-02-04-1830.syncoid.txt
hbarta@orcus:~/logs$ 
```

## 2025-02-04 snapshots for first corrupted data set

Snapshot time stamps are, I believe, GMT and other times are CST (GMT-6)

```text
hbarta@orcus:~/provoke_ZFS_corruption/scripts$ zfs list -t snap send/test/l0_1/l1_1/l2_1
NAME                                                                   USED  AVAIL     REFER  MOUNTPOINT
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-03_19:46:23_monthly            0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-03_19:46:23_daily              0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-03_19:46:23_hourly             0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_02:00:06_hourly             0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_03:00:00_hourly             0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_04:00:01_hourly          27.3M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_05:00:01_hourly          44.5M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_06:00:01_hourly          47.0M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_07:00:01_hourly          47.9M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_08:00:01_hourly          50.8M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_09:00:02_hourly          50.6M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_10:00:01_hourly          48.1M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_11:00:01_hourly          52.7M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_12:00:01_hourly          51.8M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_13:00:01_hourly          50.4M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_14:00:01_hourly          49.0M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_15:00:01_hourly          44.4M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_16:00:41_hourly          31.8M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_17:00:01_hourly          35.6M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_18:00:01_hourly          53.9M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_19:00:01_hourly          48.6M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_20:00:01_hourly          48.4M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_21:00:01_hourly          42.6M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_21:45:39_frequently      15.6M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_22:00:02_hourly             0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_22:00:02_frequently         0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-04:16:12:41-GMT-06:00  4.84M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_22:15:50_frequently         0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-04:16:18:43-GMT-06:00     0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-04:16:24:38-GMT-06:00  4.62M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_22:30:02_frequently         0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-04:16:30:16-GMT-06:00     0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-04:16:36:19-GMT-06:00     0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-04:16:42:16-GMT-06:00     0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_22:45:50_frequently         0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-04:16:48:16-GMT-06:00     0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-04:16:54:16-GMT-06:00  3.29M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_23:00:01_hourly             0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_23:00:01_frequently         0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-04:17:00:16-GMT-06:00     0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-04:17:06:16-GMT-06:00  2.83M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-04:17:12:16-GMT-06:00  3.77M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_23:15:13_frequently         0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-04:17:18:16-GMT-06:00     0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-04:17:24:17-GMT-06:00  3.26M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_23:30:01_frequently         0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-04:17:30:16-GMT-06:00     0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-04:17:36:18-GMT-06:00     0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-04:17:42:17-GMT-06:00     0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-04_23:45:31_frequently         0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-04:17:48:17-GMT-06:00     0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-04:17:54:18-GMT-06:00  3.33M      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-05_00:00:01_daily              0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-05_00:00:01_hourly             0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@autosnap_2025-02-05_00:00:01_frequently         0B      -     7.78G  -
send/test/l0_1/l1_1/l2_1@syncoid_orcus_2025-02-04:18:00:18-GMT-06:00     0B      -     7.78G  -
hbarta@orcus:~/provoke_ZFS_corruption/scripts$ 
```