# data

## 2025-02-24 first syncoid

```text
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_orion_2025-02-24:17:47:02-GMT-06:00 (~ 86 KB) to new target filesystem:
47.7KiB 0:00:00 [1.66MiB/s] [=====================================================>                                             ]  55%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_orion_2025-02-24:17:47:02-GMT-06:00 (~ 15.8 GB) to new target filesystem:
15.8GiB 0:01:12 [ 222MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_orion_2025-02-24:17:48:15-GMT-06:00 (~ 15.9 GB) to new target filesystem:
15.9GiB 0:01:14 [ 218MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-02-24:17:49:30-GMT-06:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:01:12 [ 217MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-02-24:17:50:44-GMT-06:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:01:11 [ 220MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-02-24:17:51:56-GMT-06:00 (~ 15.6 GB) to new target filesystem:
15.6GiB 0:01:13 [ 216MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-02-24:17:53:10-GMT-06:00 (~ 15.1 GB) to new target filesystem:
15.1GiB 0:01:09 [ 222MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_orion_2025-02-24:17:54:20-GMT-06:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:01:09 [ 227MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-02-24:17:55:31-GMT-06:00 (~ 15.9 GB) to new target filesystem:
15.9GiB 0:01:12 [ 223MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-02-24:17:56:44-GMT-06:00 (~ 15.2 GB) to new target filesystem:
15.2GiB 0:01:10 [ 219MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-02-24:17:57:55-GMT-06:00 (~ 15.9 GB) to new target filesystem:
15.9GiB 0:01:13 [ 220MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-02-24:17:59:10-GMT-06:00 (~ 15.3 GB) to new target filesystem:
15.3GiB 0:01:09 [ 224MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_orion_2025-02-24:18:00:20-GMT-06:00 (~ 15.1 GB) to new target filesystem:
15.1GiB 0:01:09 [ 223MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-02-24:18:01:29-GMT-06:00 (~ 15.6 GB) to new target filesystem:
15.6GiB 0:01:12 [ 218MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-02-24:18:02:42-GMT-06:00 (~ 15.4 GB) to new target filesystem:
15.4GiB 0:01:11 [ 219MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-02-24:18:03:55-GMT-06:00 (~ 15.3 GB) to new target filesystem:
15.3GiB 0:01:10 [ 221MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-02-24:18:05:06-GMT-06:00 (~ 15.7 GB) to new target filesystem:
15.7GiB 0:01:13 [ 218MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_orion_2025-02-24:18:06:20-GMT-06:00 (~ 15.4 GB) to new target filesystem:
15.4GiB 0:01:09 [ 225MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-02-24:18:07:31-GMT-06:00 (~ 15.1 GB) to new target filesystem:
15.1GiB 0:01:08 [ 226MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-02-24:18:08:39-GMT-06:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:01:12 [ 219MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-02-24:18:09:52-GMT-06:00 (~ 15.1 GB) to new target filesystem:
15.2GiB 0:01:09 [ 221MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-02-24:18:11:03-GMT-06:00 (~ 16.0 GB) to new target filesystem:
16.0GiB 0:01:14 [ 218MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_orion_2025-02-24:18:12:18-GMT-06:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:01:12 [ 218MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_orion_2025-02-24:18:13:31-GMT-06:00 (~ 15.6 GB) to new target filesystem:
15.6GiB 0:01:11 [ 223MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-02-24:18:14:43-GMT-06:00 (~ 15.6 GB) to new target filesystem:
15.6GiB 0:01:12 [ 220MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-02-24:18:15:56-GMT-06:00 (~ 15.2 GB) to new target filesystem:
15.2GiB 0:01:10 [ 219MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-02-24:18:17:07-GMT-06:00 (~ 15.2 GB) to new target filesystem:
15.2GiB 0:01:11 [ 219MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-02-24:18:18:19-GMT-06:00 (~ 15.7 GB) to new target filesystem:
15.7GiB 0:01:12 [ 221MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_orion_2025-02-24:18:19:32-GMT-06:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:01:12 [ 218MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-02-24:18:20:45-GMT-06:00 (~ 15.4 GB) to new target filesystem:
15.4GiB 0:01:12 [ 217MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-02-24:18:21:58-GMT-06:00 (~ 15.8 GB) to new target filesystem:
15.8GiB 0:05:34 [48.2MiB/s] [==================================================================================================>] 100%            
real 2432.08
user 40.82
sys 2020.74
root@orion:~# 
```
## 2025-02-24 last several log files before termination

```text
hbarta@orion:~/logs$ ls -lrt | tail -20
-rw-rw-r-- 1 hbarta hbarta 2247309 Feb 24 21:38 2025-02-24-213818.stir_pools.30.txt
-rw-rw-r-- 1 hbarta hbarta   11585 Feb 24 21:39 2025-02-24-213901.trim_snaps.16.txt
-rw-rw-r-- 1 hbarta hbarta 2261506 Feb 24 21:39 2025-02-24-213848.stir_pools.32.txt
-rw-rw-r-- 1 hbarta hbarta 2190831 Feb 24 21:39 2025-02-24-213920.stir_pools.29.txt
-rw-rw-r-- 1 hbarta hbarta    4811 Feb 24 21:40 2025-02-24-213844.syncoid.94.txt
-rw-rw-r-- 1 hbarta hbarta 2214730 Feb 24 21:40 2025-02-24-213950.stir_pools.29.txt
-rw-rw-r-- 1 hbarta hbarta   12093 Feb 24 21:40 2025-02-24-214017.trim_snaps.15.txt
-rw-rw-r-- 1 hbarta hbarta 2189595 Feb 24 21:40 2025-02-24-214019.stir_pools.31.txt
-rw-rw-r-- 1 hbarta hbarta 2215078 Feb 24 21:41 2025-02-24-214050.stir_pools.29.txt
-rw-rw-r-- 1 hbarta hbarta 2197139 Feb 24 21:41 2025-02-24-214120.stir_pools.28.txt
-rw-rw-r-- 1 hbarta hbarta    4811 Feb 24 21:41 2025-02-24-214018.syncoid.90.txt
-rw-rw-r-- 1 hbarta hbarta   12076 Feb 24 21:41 2025-02-24-214132.trim_snaps.17.txt
-rw-rw-r-- 1 hbarta hbarta 2235358 Feb 24 21:42 2025-02-24-214148.stir_pools.32.txt
-rw-rw-r-- 1 hbarta hbarta 2213211 Feb 24 21:42 2025-02-24-214220.stir_pools.29.txt
-rw-rw-r-- 1 hbarta hbarta   13019 Feb 24 21:43 2025-02-24-214249.trim_snaps.17.txt
-rw-rw-r-- 1 hbarta hbarta 2263430 Feb 24 21:43 2025-02-24-214249.stir_pools.30.txt
-rw-rw-r-- 1 hbarta hbarta    4811 Feb 24 21:43 2025-02-24-214148.syncoid.91.txt
-rw-rw-r-- 1 hbarta hbarta 2222921 Feb 24 21:43 2025-02-24-214319.stir_pools.31.txt
-rw-rw-r-- 1 hbarta hbarta    6277 Feb 24 21:44 2025-02-24-214319.syncoid.74.txt
-rw-rw-r-- 1 hbarta hbarta      36 Feb 24 21:44 halt_test.txt
hbarta@orion:~/logs$
```

## 2025-02-24 syncoid with errors reported

```text
hbarta@orion:~/logs$ cat 2025-02-24-214319.syncoid.74.txt
Sending incremental send/test@syncoid_orion_2025-02-24:21:41:49-GMT-06:00 ... syncoid_orion_2025-02-24:21:43:20-GMT-06:00 (~ 4 KB):
Sending incremental send/test/l0_0@syncoid_orion_2025-02-24:21:41:49-GMT-06:00 ... syncoid_orion_2025-02-24:21:43:20-GMT-06:00 (~ 68.3 MB):
Sending incremental send/test/l0_0/l1_0@syncoid_orion_2025-02-24:21:41:52-GMT-06:00 ... syncoid_orion_2025-02-24:21:43:23-GMT-06:00 (~ 70.4 MB):
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-02-24:21:41:55-GMT-06:00 ... syncoid_orion_2025-02-24:21:43:27-GMT-06:00 (~ 67.1 MB):
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-02-24:21:41:58-GMT-06:00 ... syncoid_orion_2025-02-24:21:43:30-GMT-06:00 (~ 66.4 MB):
Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-02-24:21:42:02-GMT-06:00 ... syncoid_orion_2025-02-24:21:43:33-GMT-06:00 (~ 66.5 MB):
Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-02-24:21:42:05-GMT-06:00 ... syncoid_orion_2025-02-24:21:43:36-GMT-06:00 (~ 65.9 MB):
Sending incremental send/test/l0_0/l1_1@syncoid_orion_2025-02-24:21:42:08-GMT-06:00 ... syncoid_orion_2025-02-24:21:43:39-GMT-06:00 (~ 68.0 MB):
warning: cannot send 'send/test/l0_0/l1_1@1740454999.2025-02-24-2143': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_1 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1'@'syncoid_orion_2025-02-24:21:42:08-GMT-06:00' 'send/test/l0_0/l1_1'@'syncoid_orion_2025-02-24:21:43:39-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 71339856 |  zfs receive  -s -F 'recv/test/l0_0/l1_1' 2>&1 failed: 256 at /usr/sbin/syncoid line 889.
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-02-24:21:42:11-GMT-06:00 ... syncoid_orion_2025-02-24:21:43:40-GMT-06:00 (~ 67.3 MB):
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-02-24:21:42:14-GMT-06:00 ... syncoid_orion_2025-02-24:21:43:43-GMT-06:00 (~ 66.5 MB):
Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-02-24:21:42:17-GMT-06:00 ... syncoid_orion_2025-02-24:21:43:46-GMT-06:00 (~ 67.4 MB):
warning: cannot send 'send/test/l0_0/l1_1/l2_2@1740454999.2025-02-24-2143': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_0/l1_1/l2_2 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_2'@'syncoid_orion_2025-02-24:21:42:17-GMT-06:00' 'send/test/l0_0/l1_1/l2_2'@'syncoid_orion_2025-02-24:21:43:46-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 70724720 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_2' 2>&1 failed: 256 at /usr/sbin/syncoid line 889.
Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-02-24:21:42:19-GMT-06:00 ... syncoid_orion_2025-02-24:21:43:48-GMT-06:00 (~ 67.3 MB):
Sending incremental send/test/l0_0/l1_2@syncoid_orion_2025-02-24:21:42:22-GMT-06:00 ... syncoid_orion_2025-02-24:21:43:51-GMT-06:00 (~ 67.9 MB):
Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-02-24:21:42:25-GMT-06:00 ... syncoid_orion_2025-02-24:21:43:54-GMT-06:00 (~ 69.9 MB):
Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-02-24:21:42:28-GMT-06:00 ... syncoid_orion_2025-02-24:21:43:56-GMT-06:00 (~ 65.6 MB):
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-02-24:21:42:31-GMT-06:00 ... syncoid_orion_2025-02-24:21:43:59-GMT-06:00 (~ 68.0 MB):
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-02-24:21:42:34-GMT-06:00 ... syncoid_orion_2025-02-24:21:44:02-GMT-06:00 (~ 67.7 MB):
Sending incremental send/test/l0_0/l1_3@syncoid_orion_2025-02-24:21:42:37-GMT-06:00 ... syncoid_orion_2025-02-24:21:44:04-GMT-06:00 (~ 47.8 MB):
Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-02-24:21:42:41-GMT-06:00 ... syncoid_orion_2025-02-24:21:44:07-GMT-06:00 (~ 43.2 MB):
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-02-24:21:42:44-GMT-06:00 ... syncoid_orion_2025-02-24:21:44:09-GMT-06:00 (~ 45.2 MB):
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-02-24:21:42:47-GMT-06:00 ... syncoid_orion_2025-02-24:21:44:11-GMT-06:00 (~ 46.2 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-02-24:21:44:11-GMT-06:00': Invalid argument
Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-02-24:21:42:50-GMT-06:00 ... syncoid_orion_2025-02-24:21:44:13-GMT-06:00 (~ 46.4 MB):
Sending incremental send/test/l0_1@syncoid_orion_2025-02-24:21:42:52-GMT-06:00 ... syncoid_orion_2025-02-24:21:44:15-GMT-06:00 (~ 45.5 MB):
Sending incremental send/test/l0_1/l1_0@syncoid_orion_2025-02-24:21:42:55-GMT-06:00 ... syncoid_orion_2025-02-24:21:44:17-GMT-06:00 (~ 45.2 MB):
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-02-24:21:42:58-GMT-06:00 ... syncoid_orion_2025-02-24:21:44:19-GMT-06:00 (~ 44.5 MB):
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-02-24:21:43:01-GMT-06:00 ... syncoid_orion_2025-02-24:21:44:21-GMT-06:00 (~ 44.3 MB):
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-02-24:21:43:05-GMT-06:00 ... syncoid_orion_2025-02-24:21:44:23-GMT-06:00 (~ 44.3 MB):
Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-02-24:21:43:08-GMT-06:00 ... syncoid_orion_2025-02-24:21:44:25-GMT-06:00 (~ 47.2 MB):
Sending incremental send/test/l0_1/l1_1@syncoid_orion_2025-02-24:21:43:11-GMT-06:00 ... syncoid_orion_2025-02-24:21:44:28-GMT-06:00 (~ 45.7 MB):
Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-02-24:21:43:14-GMT-06:00 ... syncoid_orion_2025-02-24:21:44:30-GMT-06:00 (~ 44.9 MB):
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-02-24:21:43:17-GMT-06:00 ... syncoid_orion_2025-02-24:21:44:32-GMT-06:00 (~ 33.4 MB):
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: 3 data errors, use '-v' for a list
hbarta@orion:~/logs$ 
```

## 2025-02-25 context diff dbuf.c

Comparing the patched copy with a copy from another host running Trixie.

```text
hbarta@olive:~/Programming/provoke_ZFS_corruption/logs$ diff -c rocinante/dbuf.c orion/
*** rocinante/dbuf.c    2025-02-25 08:02:04.269027623 -0600
--- orion/dbuf.c        2025-02-25 08:01:06.501468238 -0600
***************
*** 1539,1544 ****
--- 1539,1545 ----
                return (0);
  
        mutex_enter(&dndb->db_mtx);
+       dnbuf = dndb->db_buf;
  
        /*
         * Since dnode buffer is modified by sync process, there can be only
***************
*** 1556,1561 ****
--- 1557,1563 ----
                if (dr == NULL || dr->dt.dl.dr_data != dnbuf)
                        break;
                cv_wait(&dndb->db_changed, &dndb->db_mtx);
+               dnbuf = dndb->db_buf;
        };
  
        SET_BOOKMARK(&zb, dmu_objset_id(os),
hbarta@olive:~/Programming/provoke_ZFS_corruption/logs$ 
```

