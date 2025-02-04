# 2025-02-03 Results

## First `syncoid` pass

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

### second pass

Without stirring and as a user:

```text
hbarta@orcus:~$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 22.10
user 4.05
sys 10.04
hbarta@orcus:~$ 
```

```text
hbarta@orcus:~$ time -p stir_pool.sh
...
real 89.62
user 36.15
sys 34.96
hbarta@orcus:~$ 
```

### post stir passes

```text
hbarta@orcus:~$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 50.18
user 4.37
sys 13.40
hbarta@orcus:~$ 
```

Stir twice, 2nd time with `stdout` and later, `stderr` redirected to a log file. (Note: dd puts a lot of stuff out to `stderr`)

```text
time -p stir_pool.sh >log/$(date +%Y-%m-%d-%H%M)_stir.txt
...
real 89.62
user 36.15
sys 34.96
hbarta@orcus:~$ 

hbarta@orcus:~$ time -p stir_pool.sh >log/$(date +%Y-%m-%d-%H%M)_stir.txt 2>&1
real 89.30
user 36.89
sys 41.47
hbarta@orcus:~$
```

Repeat `syncoid`

```text
hbarta@orcus:~$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 81.88
user 4.38
sys 18.49
hbarta@orcus:~$ 
```

Observations:

* It takes about 90s to stir the pool.
* `syncoid` takes about 50s following a single stir and 82s following two stir passes.


