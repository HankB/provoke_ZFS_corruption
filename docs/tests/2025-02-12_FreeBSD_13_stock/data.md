# FreeBSD 13 stock ZFS 2.1.
## 2025-02-13 first syncoid

```text
root@pluto:~ # time syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_pluto_2025-02-13:18:37:41-GMT00:00 (~ 88 KB) to new target filesystem:
51.3KiB 0:00:00 [1.10MiB/s] [=================================================>                                     ]  58%            
INFO: Updating new target filesystem with incremental send/test@syncoid_pluto_2025-02-13:18:37:41-GMT00:00 ... syncoid_pluto_2025-02-13:18:38:46-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [17.3KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_pluto_2025-02-13:18:37:41-GMT00:00 (~ 15.4 GB) to new target filesystem:
15.5GiB 0:02:19 [ 113MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0@syncoid_pluto_2025-02-13:18:37:41-GMT00:00 ... syncoid_pluto_2025-02-13:18:38:46-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [16.1KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_pluto_2025-02-13:18:37:41-GMT00:00 (~ 15.6 GB) to new target filesystem:
15.6GiB 0:02:30 [ 106MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_0@syncoid_pluto_2025-02-13:18:37:41-GMT00:00 ... syncoid_pluto_2025-02-13:18:41:07-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.1KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_pluto_2025-02-13:18:37:41-GMT00:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:02:33 [ 103MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_0/l2_0@syncoid_pluto_2025-02-13:18:37:41-GMT00:00 ... syncoid_pluto_2025-02-13:18:43:38-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.7KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_pluto_2025-02-13:18:37:42-GMT00:00 (~ 15.6 GB) to new target filesystem:
15.6GiB 0:02:34 [ 103MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_0/l2_1@syncoid_pluto_2025-02-13:18:37:42-GMT00:00 ... syncoid_pluto_2025-02-13:18:46:12-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.7KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_pluto_2025-02-13:18:37:42-GMT00:00 (~ 16.0 GB) to new target filesystem:
16.0GiB 0:02:32 [ 107MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_0/l2_2@syncoid_pluto_2025-02-13:18:37:42-GMT00:00 ... syncoid_pluto_2025-02-13:18:48:48-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.8KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_pluto_2025-02-13:18:37:42-GMT00:00 (~ 15.4 GB) to new target filesystem:
15.4GiB 0:02:30 [ 104MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_0/l2_3@syncoid_pluto_2025-02-13:18:37:42-GMT00:00 ... syncoid_pluto_2025-02-13:18:51:21-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.3KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_pluto_2025-02-13:18:37:42-GMT00:00 (~ 15.2 GB) to new target filesystem:
15.2GiB 0:02:27 [ 105MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_1@syncoid_pluto_2025-02-13:18:37:42-GMT00:00 ... syncoid_pluto_2025-02-13:18:53:52-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.9KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_pluto_2025-02-13:18:37:42-GMT00:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:02:29 [ 105MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_1/l2_0@syncoid_pluto_2025-02-13:18:37:42-GMT00:00 ... syncoid_pluto_2025-02-13:18:56:21-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.7KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_pluto_2025-02-13:18:37:42-GMT00:00 (~ 15.4 GB) to new target filesystem:
15.4GiB 0:02:28 [ 106MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_1/l2_1@syncoid_pluto_2025-02-13:18:37:42-GMT00:00 ... syncoid_pluto_2025-02-13:18:58:52-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.0KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_pluto_2025-02-13:18:37:43-GMT00:00 (~ 15.3 GB) to new target filesystem:
15.3GiB 0:02:30 [ 104MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_1/l2_2@syncoid_pluto_2025-02-13:18:37:43-GMT00:00 ... syncoid_pluto_2025-02-13:19:01:21-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.8KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_pluto_2025-02-13:18:37:43-GMT00:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:02:32 [ 104MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_1/l2_3@syncoid_pluto_2025-02-13:18:37:43-GMT00:00 ... syncoid_pluto_2025-02-13:19:03:52-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.6KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_pluto_2025-02-13:18:37:43-GMT00:00 (~ 15.7 GB) to new target filesystem:
15.7GiB 0:02:34 [ 104MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_2@syncoid_pluto_2025-02-13:18:37:43-GMT00:00 ... syncoid_pluto_2025-02-13:19:06:26-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.3KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_pluto_2025-02-13:18:37:43-GMT00:00 (~ 15.6 GB) to new target filesystem:
15.6GiB 0:02:32 [ 104MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_2/l2_0@syncoid_pluto_2025-02-13:18:37:43-GMT00:00 ... syncoid_pluto_2025-02-13:19:09:01-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.3KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_pluto_2025-02-13:18:37:43-GMT00:00 (~ 15.3 GB) to new target filesystem:
15.3GiB 0:02:30 [ 103MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_2/l2_1@syncoid_pluto_2025-02-13:18:37:43-GMT00:00 ... syncoid_pluto_2025-02-13:19:11:35-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.3KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_pluto_2025-02-13:18:37:43-GMT00:00 (~ 15.7 GB) to new target filesystem:
15.7GiB 0:02:32 [ 105MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_2/l2_2@syncoid_pluto_2025-02-13:18:37:43-GMT00:00 ... syncoid_pluto_2025-02-13:19:14:07-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.3KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_pluto_2025-02-13:18:37:44-GMT00:00 (~ 15.7 GB) to new target filesystem:
15.7GiB 0:02:32 [ 105MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_2/l2_3@syncoid_pluto_2025-02-13:18:37:44-GMT00:00 ... syncoid_pluto_2025-02-13:19:16:40-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.5KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_pluto_2025-02-13:18:37:44-GMT00:00 (~ 15.1 GB) to new target filesystem:
15.1GiB 0:02:25 [ 106MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_3@syncoid_pluto_2025-02-13:18:37:44-GMT00:00 ... syncoid_pluto_2025-02-13:19:19:14-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.1KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_pluto_2025-02-13:18:37:44-GMT00:00 (~ 15.4 GB) to new target filesystem:
15.4GiB 0:02:31 [ 104MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_3/l2_0@syncoid_pluto_2025-02-13:18:37:44-GMT00:00 ... syncoid_pluto_2025-02-13:19:21:40-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [11.5KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_pluto_2025-02-13:18:37:44-GMT00:00 (~ 15.4 GB) to new target filesystem:
15.4GiB 0:02:30 [ 104MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_3/l2_1@syncoid_pluto_2025-02-13:18:37:44-GMT00:00 ... syncoid_pluto_2025-02-13:19:24:12-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [11.8KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_pluto_2025-02-13:18:37:44-GMT00:00 (~ 15.6 GB) to new target filesystem:
15.6GiB 0:02:30 [ 106MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_3/l2_2@syncoid_pluto_2025-02-13:18:37:44-GMT00:00 ... syncoid_pluto_2025-02-13:19:26:43-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.1KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_pluto_2025-02-13:18:37:44-GMT00:00 (~ 14.9 GB) to new target filesystem:
14.9GiB 0:02:25 [ 104MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_0/l1_3/l2_3@syncoid_pluto_2025-02-13:18:37:44-GMT00:00 ... syncoid_pluto_2025-02-13:19:29:15-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [11.9KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_pluto_2025-02-13:18:37:44-GMT00:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:02:29 [ 106MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1@syncoid_pluto_2025-02-13:18:37:44-GMT00:00 ... syncoid_pluto_2025-02-13:19:31:42-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [14.7KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_pluto_2025-02-13:18:37:45-GMT00:00 (~ 15.4 GB) to new target filesystem:
15.4GiB 0:02:28 [ 106MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_0@syncoid_pluto_2025-02-13:18:37:45-GMT00:00 ... syncoid_pluto_2025-02-13:19:34:12-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.2KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_pluto_2025-02-13:18:37:45-GMT00:00 (~ 15.2 GB) to new target filesystem:
15.2GiB 0:02:25 [ 106MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_0/l2_0@syncoid_pluto_2025-02-13:18:37:45-GMT00:00 ... syncoid_pluto_2025-02-13:19:36:42-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.3KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_pluto_2025-02-13:18:37:45-GMT00:00 (~ 15.3 GB) to new target filesystem:
15.3GiB 0:02:27 [ 106MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_0/l2_1@syncoid_pluto_2025-02-13:18:37:45-GMT00:00 ... syncoid_pluto_2025-02-13:19:39:09-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.4KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_pluto_2025-02-13:18:37:45-GMT00:00 (~ 15.3 GB) to new target filesystem:
15.3GiB 0:02:27 [ 106MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_0/l2_2@syncoid_pluto_2025-02-13:18:37:45-GMT00:00 ... syncoid_pluto_2025-02-13:19:41:38-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.2KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_pluto_2025-02-13:18:37:45-GMT00:00 (~ 15.7 GB) to new target filesystem:
15.7GiB 0:02:27 [ 109MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_0/l2_3@syncoid_pluto_2025-02-13:18:37:45-GMT00:00 ... syncoid_pluto_2025-02-13:19:44:06-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.0KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_pluto_2025-02-13:18:37:45-GMT00:00 (~ 15.1 GB) to new target filesystem:
15.1GiB 0:02:24 [ 106MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_1@syncoid_pluto_2025-02-13:18:37:45-GMT00:00 ... syncoid_pluto_2025-02-13:19:46:35-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.3KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_pluto_2025-02-13:18:37:46-GMT00:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:02:27 [ 107MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_1/l2_0@syncoid_pluto_2025-02-13:18:37:46-GMT00:00 ... syncoid_pluto_2025-02-13:19:49:01-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.3KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_pluto_2025-02-13:18:37:46-GMT00:00 (~ 15.7 GB) to new target filesystem:
15.7GiB 0:02:27 [ 109MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_1/l2_1@syncoid_pluto_2025-02-13:18:37:46-GMT00:00 ... syncoid_pluto_2025-02-13:19:51:29-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.2KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_2@syncoid_pluto_2025-02-13:18:37:46-GMT00:00 (~ 15.6 GB) to new target filesystem:
15.6GiB 0:02:31 [ 105MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_1/l2_2@syncoid_pluto_2025-02-13:18:37:46-GMT00:00 ... syncoid_pluto_2025-02-13:19:53:58-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [11.8KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_3@syncoid_pluto_2025-02-13:18:37:46-GMT00:00 (~ 15.4 GB) to new target filesystem:
15.4GiB 0:02:22 [ 110MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_1/l2_3@syncoid_pluto_2025-02-13:18:37:46-GMT00:00 ... syncoid_pluto_2025-02-13:19:56:30-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.4KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2@syncoid_pluto_2025-02-13:18:37:46-GMT00:00 (~ 16.0 GB) to new target filesystem:
16.0GiB 0:02:31 [ 107MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_2@syncoid_pluto_2025-02-13:18:37:46-GMT00:00 ... syncoid_pluto_2025-02-13:19:58:54-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.1KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_0@syncoid_pluto_2025-02-13:18:37:46-GMT00:00 (~ 15.6 GB) to new target filesystem:
15.6GiB 0:02:28 [ 107MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_2/l2_0@syncoid_pluto_2025-02-13:18:37:46-GMT00:00 ... syncoid_pluto_2025-02-13:20:01:27-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.5KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_1@syncoid_pluto_2025-02-13:18:37:47-GMT00:00 (~ 15.4 GB) to new target filesystem:
15.4GiB 0:02:25 [ 108MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_2/l2_1@syncoid_pluto_2025-02-13:18:37:47-GMT00:00 ... syncoid_pluto_2025-02-13:20:03:57-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [11.7KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_2@syncoid_pluto_2025-02-13:18:37:47-GMT00:00 (~ 15.6 GB) to new target filesystem:
15.6GiB 0:02:25 [ 109MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_2/l2_2@syncoid_pluto_2025-02-13:18:37:47-GMT00:00 ... syncoid_pluto_2025-02-13:20:06:23-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.2KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_2/l2_3@syncoid_pluto_2025-02-13:18:37:47-GMT00:00 (~ 15.6 GB) to new target filesystem:
15.6GiB 0:02:31 [ 105MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_2/l2_3@syncoid_pluto_2025-02-13:18:37:47-GMT00:00 ... syncoid_pluto_2025-02-13:20:08:50-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.2KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3@syncoid_pluto_2025-02-13:18:37:47-GMT00:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:02:29 [ 106MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_3@syncoid_pluto_2025-02-13:18:37:47-GMT00:00 ... syncoid_pluto_2025-02-13:20:11:22-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.8KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_3/l2_0@syncoid_pluto_2025-02-13:18:37:47-GMT00:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:02:27 [ 107MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_1/l1_3/l2_0@syncoid_pluto_2025-02-13:18:37:47-GMT00:00 ... syncoid_pluto_2025-02-13:20:13:53-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [12.3KiB/s] [================================>                                                      ]  38%            
INFO: Sending oldest full snapshot send/test/l0_2@syncoid_pluto_2025-02-13:18:37:47-GMT00:00 (~ 15.7 GB) to new target filesystem:
15.8GiB 0:02:33 [ 105MiB/s] [======================================================================================>] 100%            
INFO: Updating new target filesystem with incremental send/test/l0_2@syncoid_pluto_2025-02-13:18:37:47-GMT00:00 ... syncoid_pluto_2025-02-13:20:16:21-GMT00:00 (~ 4 KB):
1.52KiB 0:00:00 [13.9KiB/s] [================================>                                                      ]  38%            
272.190u 3370.203s 1:40:09.82 60.6%     74+173k 68169+0io 0pf+0w
root@pluto:~ # 
```

# 2025-02-13 second syncoid as user

```text
[hbarta@pluto ~]$ time syncoid --recursive --no-privilege-elevation send/test recv/test
Sending incremental send/test@syncoid_pluto_2025-02-13:18:38:46-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:05-GMT00:00 (~ 41 KB):
7.03KiB 0:00:00 [84.6KiB/s] [==============>                                                                                    ]  16%            
Sending incremental send/test/l0_0@syncoid_pluto_2025-02-13:18:38:46-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:06-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.55MiB/s] [=========================================================================>                         ]  75%            
Sending incremental send/test/l0_0/l1_0@syncoid_pluto_2025-02-13:18:41:07-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:07-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.60MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_pluto_2025-02-13:18:43:38-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:07-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.46MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_pluto_2025-02-13:18:46:12-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:08-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.37MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_pluto_2025-02-13:18:48:48-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:09-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.41MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_pluto_2025-02-13:18:51:21-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:10-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.39MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_0/l1_1@syncoid_pluto_2025-02-13:18:53:52-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:10-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.40MiB/s] [=========================================================================>                         ]  75%            
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_pluto_2025-02-13:18:56:21-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:11-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.47MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_pluto_2025-02-13:18:58:52-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:12-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.47MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_pluto_2025-02-13:19:01:21-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:12-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.59MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_pluto_2025-02-13:19:03:52-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:13-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.64MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_0/l1_2@syncoid_pluto_2025-02-13:19:06:26-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:14-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.58MiB/s] [=========================================================================>                         ]  75%            
Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_pluto_2025-02-13:19:09:01-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:15-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.64MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_pluto_2025-02-13:19:11:35-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:15-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.65MiB/s] [=========================================================================>                         ]  75%            
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_pluto_2025-02-13:19:14:07-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:16-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.57MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_pluto_2025-02-13:19:16:40-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:17-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.64MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_0/l1_3@syncoid_pluto_2025-02-13:19:19:14-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:17-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.79MiB/s] [=========================================================================>                         ]  75%            
Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_pluto_2025-02-13:19:21:40-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:18-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.68MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_pluto_2025-02-13:19:24:12-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:19-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.66MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_pluto_2025-02-13:19:26:43-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:19-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.50MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_pluto_2025-02-13:19:29:15-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:20-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.60MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_1@syncoid_pluto_2025-02-13:19:31:42-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:21-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.74MiB/s] [=========================================================================>                         ]  75%            
Sending incremental send/test/l0_1/l1_0@syncoid_pluto_2025-02-13:19:34:12-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:21-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.80MiB/s] [=========================================================================>                         ]  75%            
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_pluto_2025-02-13:19:36:42-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:22-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.60MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_pluto_2025-02-13:19:39:09-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:23-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.62MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_pluto_2025-02-13:19:41:38-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:23-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.54MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_pluto_2025-02-13:19:44:06-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:24-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.67MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_1/l1_1@syncoid_pluto_2025-02-13:19:46:35-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:25-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.59MiB/s] [=========================================================================>                         ]  75%            
Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_pluto_2025-02-13:19:49:01-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:26-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.58MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_pluto_2025-02-13:19:51:29-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:26-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.60MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_1/l1_1/l2_2@syncoid_pluto_2025-02-13:19:53:58-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:27-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.60MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_1/l1_1/l2_3@syncoid_pluto_2025-02-13:19:56:30-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:28-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.61MiB/s] [=========================================================================>                         ]  75%            
Sending incremental send/test/l0_1/l1_2@syncoid_pluto_2025-02-13:19:58:54-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:28-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.69MiB/s] [=========================================================================>                         ]  75%            
Sending incremental send/test/l0_1/l1_2/l2_0@syncoid_pluto_2025-02-13:20:01:27-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:29-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.73MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_1/l1_2/l2_1@syncoid_pluto_2025-02-13:20:03:57-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:30-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.63MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_1/l1_2/l2_2@syncoid_pluto_2025-02-13:20:06:23-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:30-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.67MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_1/l1_2/l2_3@syncoid_pluto_2025-02-13:20:08:50-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:31-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.67MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_1/l1_3@syncoid_pluto_2025-02-13:20:11:22-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:32-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.73MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_1/l1_3/l2_0@syncoid_pluto_2025-02-13:20:13:53-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:32-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.63MiB/s] [========================================================================>                          ]  74%            
Sending incremental send/test/l0_2@syncoid_pluto_2025-02-13:20:16:21-GMT00:00 ... syncoid_pluto_2025-02-13:22:17:33-GMT00:00 (~ 1.6 MB):
1.22MiB 0:00:00 [3.78MiB/s] [========================================================================>                          ]  74%            

real    0m28.820s
user    0m4.018s
sys     0m15.648s
[hbarta@pluto ~]$ 
```