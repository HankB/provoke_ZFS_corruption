# data

* [Setup](./setup.md)
* [Results](./results.md)

## 2025-02-24 First `syncoid`

```text
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_orion_2025-02-24:11:07:35-GMT-06:00 (~ 86 KB) to new target filesystem:
47.7KiB 0:00:00 [1.69MiB/s] [=====================================================>                                             ]  55%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_orion_2025-02-24:11:07:35-GMT-06:00 (~ 15.7 GB) to new target filesystem:
15.7GiB 0:01:15 [ 214MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_orion_2025-02-24:11:08:51-GMT-06:00 (~ 15.1 GB) to new target filesystem:
15.1GiB 0:01:10 [ 219MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-02-24:11:10:02-GMT-06:00 (~ 15.4 GB) to new target filesystem:
15.4GiB 0:01:12 [ 217MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-02-24:11:11:14-GMT-06:00 (~ 15.3 GB) to new target filesystem:
15.3GiB 0:01:11 [ 220MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-02-24:11:12:26-GMT-06:00 (~ 16.0 GB) to new target filesystem:
16.0GiB 0:01:16 [ 214MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-02-24:11:13:43-GMT-06:00 (~ 15.6 GB) to new target filesystem:
15.6GiB 0:01:12 [ 220MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_orion_2025-02-24:11:14:56-GMT-06:00 (~ 15.0 GB) to new target filesystem:
15.1GiB 0:01:09 [ 221MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-02-24:11:16:06-GMT-06:00 (~ 15.6 GB) to new target filesystem:
15.6GiB 0:01:13 [ 218MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-02-24:11:17:20-GMT-06:00 (~ 15.6 GB) to new target filesystem:
15.6GiB 0:01:12 [ 220MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-02-24:11:18:32-GMT-06:00 (~ 15.3 GB) to new target filesystem:
15.3GiB 0:01:12 [ 216MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-02-24:11:19:45-GMT-06:00 (~ 15.3 GB) to new target filesystem:
15.3GiB 0:01:12 [ 215MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_orion_2025-02-24:11:20:58-GMT-06:00 (~ 15.2 GB) to new target filesystem:
15.2GiB 0:01:09 [ 223MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-02-24:11:22:08-GMT-06:00 (~ 15.6 GB) to new target filesystem:
15.6GiB 0:01:12 [ 220MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-02-24:11:23:21-GMT-06:00 (~ 15.7 GB) to new target filesystem:
15.7GiB 0:01:13 [ 218MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-02-24:11:24:35-GMT-06:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:01:12 [ 220MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-02-24:11:25:47-GMT-06:00 (~ 15.3 GB) to new target filesystem:
15.3GiB 0:01:12 [ 215MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_orion_2025-02-24:11:27:01-GMT-06:00 (~ 15.3 GB) to new target filesystem:
15.3GiB 0:01:12 [ 216MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-02-24:11:28:13-GMT-06:00 (~ 15.7 GB) to new target filesystem:
15.7GiB 0:01:12 [ 222MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-02-24:11:29:26-GMT-06:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:01:12 [ 218MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-02-24:11:30:39-GMT-06:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:01:13 [ 215MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-02-24:11:31:53-GMT-06:00 (~ 16.0 GB) to new target filesystem:
16.0GiB 0:01:15 [ 217MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_orion_2025-02-24:11:33:09-GMT-06:00 (~ 15.9 GB) to new target filesystem:
15.9GiB 0:01:14 [ 218MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_orion_2025-02-24:11:34:24-GMT-06:00 (~ 15.2 GB) to new target filesystem:
15.2GiB 0:01:10 [ 219MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-02-24:11:35:35-GMT-06:00 (~ 15.3 GB) to new target filesystem:
15.3GiB 0:01:10 [ 222MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-02-24:11:36:46-GMT-06:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:01:13 [ 215MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-02-24:11:38:00-GMT-06:00 (~ 15.4 GB) to new target filesystem:
15.4GiB 0:01:11 [ 219MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-02-24:11:39:12-GMT-06:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:01:12 [ 220MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_orion_2025-02-24:11:40:25-GMT-06:00 (~ 15.5 GB) to new target filesystem:
15.5GiB 0:01:12 [ 220MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-02-24:11:41:38-GMT-06:00 (~ 15.1 GB) to new target filesystem:
15.1GiB 0:01:38 [ 157MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-02-24:11:43:16-GMT-06:00 (~ 15.2 GB) to new target filesystem:
15.2GiB 0:03:45 [69.2MiB/s] [==================================================================================================>] 100%            
real 2367.12
user 39.88
sys 2118.01
root@orion:~# 
```

```text
root@orion:~# /home/hbarta/bin/monitor.sh 
status
  pool: recv
 state: ONLINE
config:

        NAME                      STATE     READ WRITE CKSUM
        recv                      ONLINE       0     0     0
          wwn-0x5002538d40878f8e  ONLINE       0     0     0

errors: No known data errors

  pool: send
 state: ONLINE
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: No known data errors

list

NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   238G   226G        -         -     0%    51%  1.00x    ONLINE  -
send   464G   239G   225G        -         -     0%    51%  1.00x    ONLINE  -

send snapshot count
32

recv snapshot count
32
root@orion:~# 
```

## 2025-02-24 Second `syncoid`

(As user)

```text
hbarta@orion:~$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
Sending incremental send/test@syncoid_orion_2025-02-24:11:07:35-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:46-GMT-06:00 (~ 41 KB):
6.27KiB 0:00:00 [82.5KiB/s] [=============>                                                                                     ]  15%            
Sending incremental send/test/l0_0@syncoid_orion_2025-02-24:11:07:35-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:47-GMT-06:00 (~ 1.7 MB):
1.24MiB 0:00:00 [4.71MiB/s] [======================================================================>                            ]  72%            
Sending incremental send/test/l0_0/l1_0@syncoid_orion_2025-02-24:11:08:51-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:47-GMT-06:00 (~ 1.7 MB):
1.24MiB 0:00:00 [4.56MiB/s] [=====================================================================>                             ]  71%            
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-02-24:11:10:02-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:48-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.51MiB/s] [======================================================================>                            ]  72%            
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-02-24:11:11:14-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:48-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.63MiB/s] [=======================================================================>                           ]  73%            
Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-02-24:11:12:26-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:49-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.59MiB/s] [=====================================================================>                             ]  71%            
Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-02-24:11:13:43-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:49-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.54MiB/s] [====================================================================>                              ]  70%            
Sending incremental send/test/l0_0/l1_1@syncoid_orion_2025-02-24:11:14:56-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:50-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.67MiB/s] [=======================================================================>                           ]  73%            
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-02-24:11:16:06-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:50-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.45MiB/s] [======================================================================>                            ]  72%            
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-02-24:11:17:20-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:51-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.75MiB/s] [======================================================================>                            ]  72%            
Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-02-24:11:18:32-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:51-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.50MiB/s] [======================================================================>                            ]  72%            
Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-02-24:11:19:45-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:52-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.81MiB/s] [=====================================================================>                             ]  71%            
Sending incremental send/test/l0_0/l1_2@syncoid_orion_2025-02-24:11:20:58-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:52-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.59MiB/s] [=====================================================================>                             ]  71%            
Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-02-24:11:22:08-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:53-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.49MiB/s] [======================================================================>                            ]  72%            
Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-02-24:11:23:21-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:54-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.68MiB/s] [=======================================================================>                           ]  73%            
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-02-24:11:24:35-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:54-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.53MiB/s] [=====================================================================>                             ]  71%            
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-02-24:11:25:47-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:55-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.44MiB/s] [====================================================================>                              ]  70%            
Sending incremental send/test/l0_0/l1_3@syncoid_orion_2025-02-24:11:27:01-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:55-GMT-06:00 (~ 1.7 MB):
1.24MiB 0:00:00 [4.63MiB/s] [======================================================================>                            ]  71%            
Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-02-24:11:28:13-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:56-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.53MiB/s] [=====================================================================>                             ]  71%            
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-02-24:11:29:26-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:56-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.25MiB/s] [======================================================================>                            ]  72%            
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-02-24:11:30:39-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:57-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.52MiB/s] [=======================================================================>                           ]  73%            
Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-02-24:11:31:53-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:57-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.51MiB/s] [======================================================================>                            ]  72%            
Sending incremental send/test/l0_1@syncoid_orion_2025-02-24:11:33:09-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:58-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.79MiB/s] [======================================================================>                            ]  71%            
Sending incremental send/test/l0_1/l1_0@syncoid_orion_2025-02-24:11:34:24-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:58-GMT-06:00 (~ 1.7 MB):
1.24MiB 0:00:00 [4.79MiB/s] [=====================================================================>                             ]  71%            
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-02-24:11:35:35-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:59-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.55MiB/s] [=======================================================================>                           ]  72%            
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-02-24:11:36:46-GMT-06:00 ... syncoid_orion_2025-02-24:11:52:59-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.55MiB/s] [=====================================================================>                             ]  71%            
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-02-24:11:38:00-GMT-06:00 ... syncoid_orion_2025-02-24:11:53:00-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.47MiB/s] [=======================================================================>                           ]  73%            
Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-02-24:11:39:12-GMT-06:00 ... syncoid_orion_2025-02-24:11:53:00-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.22MiB/s] [======================================================================>                            ]  72%            
Sending incremental send/test/l0_1/l1_1@syncoid_orion_2025-02-24:11:40:25-GMT-06:00 ... syncoid_orion_2025-02-24:11:53:01-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.58MiB/s] [======================================================================>                            ]  72%            
Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-02-24:11:41:38-GMT-06:00 ... syncoid_orion_2025-02-24:11:53:01-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.74MiB/s] [======================================================================>                            ]  72%            
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-02-24:11:43:16-GMT-06:00 ... syncoid_orion_2025-02-24:11:53:02-GMT-06:00 (~ 1.7 MB):
1.23MiB 0:00:00 [4.52MiB/s] [=====================================================================>                             ]  71%            
real 16.08
user 4.15
sys 8.16
hbarta@orion:~$ 
```

## 2025-02-24 syncoid log with errors

```text
hbarta@orion:~$ cat logs/2025-02-24-1416.syncoid.82.txt
Sending incremental send/test@syncoid_orion_2025-02-24:14:14:36-GMT-06:00 ... syncoid_orion_2025-02-24:14:16:08-GMT-06:00 (~ 4 KB):
Sending incremental send/test/l0_0@syncoid_orion_2025-02-24:14:14:37-GMT-06:00 ... syncoid_orion_2025-02-24:14:16:09-GMT-06:00 (~ 68.4 MB):
Sending incremental send/test/l0_0/l1_0@syncoid_orion_2025-02-24:14:14:40-GMT-06:00 ... syncoid_orion_2025-02-24:14:16:12-GMT-06:00 (~ 65.3 MB):
Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-02-24:14:14:43-GMT-06:00 ... syncoid_orion_2025-02-24:14:16:15-GMT-06:00 (~ 67.3 MB):
Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-02-24:14:14:46-GMT-06:00 ... syncoid_orion_2025-02-24:14:16:18-GMT-06:00 (~ 65.8 MB):
Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-02-24:14:14:49-GMT-06:00 ... syncoid_orion_2025-02-24:14:16:21-GMT-06:00 (~ 66.1 MB):
Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-02-24:14:14:52-GMT-06:00 ... syncoid_orion_2025-02-24:14:16:24-GMT-06:00 (~ 66.0 MB):
Sending incremental send/test/l0_0/l1_1@syncoid_orion_2025-02-24:14:14:55-GMT-06:00 ... syncoid_orion_2025-02-24:14:16:26-GMT-06:00 (~ 65.3 MB):
Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-02-24:14:14:58-GMT-06:00 ... syncoid_orion_2025-02-24:14:16:30-GMT-06:00 (~ 65.1 MB):
Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-02-24:14:15:01-GMT-06:00 ... syncoid_orion_2025-02-24:14:16:33-GMT-06:00 (~ 68.8 MB):
Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-02-24:14:15:04-GMT-06:00 ... syncoid_orion_2025-02-24:14:16:36-GMT-06:00 (~ 90.3 MB):
Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-02-24:14:15:07-GMT-06:00 ... syncoid_orion_2025-02-24:14:16:39-GMT-06:00 (~ 89.4 MB):
warning: cannot send 'send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-02-24:14:16:39-GMT-06:00': Input/output error
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-12160b1454-118-789c636064000310a501c49c50360710a715e5e7a69766a6304081743457d44629f3530a40363b92bafca4acd4e412081f0430e4d3d28a534b18e00024cf86249f5459925acc802a8facbf241fe28acba2afa6fe89f9c39a8024cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fa89f63146fec505c99979c9f99129f5f94999f176f646064aa6b60a46b64626508446656c696baeebe21ba0666560606303700000d212c45
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_3'@'syncoid_orion_2025-02-24:14:15:07-GMT-06:00' 'send/test/l0_0/l1_1/l2_3'@'syncoid_orion_2025-02-24:14:16:39-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 93735480 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_3' 2>&1 failed: 256 at /usr/sbin/syncoid line 889.
Sending incremental send/test/l0_0/l1_2@syncoid_orion_2025-02-24:14:15:10-GMT-06:00 ... syncoid_orion_2025-02-24:14:16:42-GMT-06:00 (~ 81.4 MB):
warning: cannot send 'send/test/l0_0/l1_2@syncoid_orion_2025-02-24:14:16:42-GMT-06:00': Input/output error
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-13444e7732-110-789c636064000310a501c49c50360710a715e5e7a69766a6304081a2e2bde3fe5b445e2b00d9ec48eaf293b252934b207c10c0904f4b2b4e2d618003903c1b927c5265496a3103aa3cb2fe927c882bbeb1c7f8cc3d1e7e3702499e132c9f97989bcac0509c9a97a20f34aa443fc720de403fc730dec8a1b8322f393f33253ebf28333f2fdec8c0c854d7c048d7c8c4ca1088ccac4c8c74dd7d43740dccac0c0cc07603008bf82b99
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2'@'syncoid_orion_2025-02-24:14:15:10-GMT-06:00' 'send/test/l0_0/l1_2'@'syncoid_orion_2025-02-24:14:16:42-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 85331000 |  zfs receive  -s -F 'recv/test/l0_0/l1_2' 2>&1 failed: 256 at /usr/sbin/syncoid line 889.
Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-02-24:14:15:13-GMT-06:00 ... syncoid_orion_2025-02-24:14:16:45-GMT-06:00 (~ 66.9 MB):
Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-02-24:14:15:16-GMT-06:00 ... syncoid_orion_2025-02-24:14:16:48-GMT-06:00 (~ 66.5 MB):
Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-02-24:14:15:19-GMT-06:00 ... syncoid_orion_2025-02-24:14:16:51-GMT-06:00 (~ 67.4 MB):
Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-02-24:14:15:22-GMT-06:00 ... syncoid_orion_2025-02-24:14:16:54-GMT-06:00 (~ 65.0 MB):
Sending incremental send/test/l0_0/l1_3@syncoid_orion_2025-02-24:14:15:25-GMT-06:00 ... syncoid_orion_2025-02-24:14:16:57-GMT-06:00 (~ 65.5 MB):
Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-02-24:14:15:28-GMT-06:00 ... syncoid_orion_2025-02-24:14:17:00-GMT-06:00 (~ 68.8 MB):
Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-02-24:14:15:31-GMT-06:00 ... syncoid_orion_2025-02-24:14:17:03-GMT-06:00 (~ 67.0 MB):
Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-02-24:14:15:34-GMT-06:00 ... syncoid_orion_2025-02-24:14:17:06-GMT-06:00 (~ 69.4 MB):
Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-02-24:14:15:38-GMT-06:00 ... syncoid_orion_2025-02-24:14:17:09-GMT-06:00 (~ 66.1 MB):
warning: cannot send 'send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-02-24:14:17:09-GMT-06:00': Invalid argument
Sending incremental send/test/l0_1@syncoid_orion_2025-02-24:14:15:40-GMT-06:00 ... syncoid_orion_2025-02-24:14:17:11-GMT-06:00 (~ 63.4 MB):
warning: cannot send 'send/test/l0_1@1740428175.2025-02-24-1416': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1'@'syncoid_orion_2025-02-24:14:15:40-GMT-06:00' 'send/test/l0_1'@'syncoid_orion_2025-02-24:14:17:11-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 66494648 |  zfs receive  -s -F 'recv/test/l0_1' 2>&1 failed: 256 at /usr/sbin/syncoid line 889.
Sending incremental send/test/l0_1/l1_0@syncoid_orion_2025-02-24:14:15:43-GMT-06:00 ... syncoid_orion_2025-02-24:14:17:12-GMT-06:00 (~ 66.3 MB):
Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-02-24:14:15:46-GMT-06:00 ... syncoid_orion_2025-02-24:14:17:15-GMT-06:00 (~ 66.9 MB):
warning: cannot send 'send/test/l0_1/l1_0/l2_0@1740428204.2025-02-24-1416': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_0/l2_0 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_0'@'syncoid_orion_2025-02-24:14:15:46-GMT-06:00' 'send/test/l0_1/l1_0/l2_0'@'syncoid_orion_2025-02-24:14:17:15-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 70145240 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_0' 2>&1 failed: 256 at /usr/sbin/syncoid line 889.
Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-02-24:14:15:49-GMT-06:00 ... syncoid_orion_2025-02-24:14:17:16-GMT-06:00 (~ 43.9 MB):
Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-02-24:14:15:53-GMT-06:00 ... syncoid_orion_2025-02-24:14:17:19-GMT-06:00 (~ 67.3 MB):
warning: cannot send 'send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-02-24:14:17:19-GMT-06:00': Invalid argument
Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-02-24:14:15:56-GMT-06:00 ... syncoid_orion_2025-02-24:14:17:21-GMT-06:00 (~ 69.7 MB):
Sending incremental send/test/l0_1/l1_1@syncoid_orion_2025-02-24:14:15:59-GMT-06:00 ... syncoid_orion_2025-02-24:14:17:24-GMT-06:00 (~ 56.5 MB):
Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-02-24:14:16:02-GMT-06:00 ... syncoid_orion_2025-02-24:14:17:26-GMT-06:00 (~ 66.9 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-02-24:14:17:26-GMT-06:00': Invalid argument
Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-02-24:14:16:05-GMT-06:00 ... syncoid_orion_2025-02-24:14:17:28-GMT-06:00 (~ 67.7 MB):
warning: cannot send 'send/test/l0_1/l1_1/l2_1@1740428175.2025-02-24-1416': Invalid argument
cannot receive incremental stream: most recent snapshot of recv/test/l0_1/l1_1/l2_1 does not
match incremental source
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_1/l2_1'@'syncoid_orion_2025-02-24:14:16:05-GMT-06:00' 'send/test/l0_1/l1_1/l2_1'@'syncoid_orion_2025-02-24:14:17:28-GMT-06:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 70974944 |  zfs receive  -s -F 'recv/test/l0_1/l1_1/l2_1' 2>&1 failed: 256 at /usr/sbin/syncoid line 889.
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

errors: 23 data errors, use '-v' for a list
hbarta@orion:~$ 
```