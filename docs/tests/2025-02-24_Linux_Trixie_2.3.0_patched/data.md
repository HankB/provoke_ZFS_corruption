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

## 2025-02-24 second syncoid

```text
hbarta@orion:~$ time -p syncoid --recursive --no-privilege-elevation send/test recv/test
...
real 16.31
user 4.08
sys 8.22
hbarta@orion:~$ 
```

[full output](./data.md#2025-02-24-second-syncoid)

## 2025-02-24 start thrashing

```text
cd
mkdir /mnt/storage/logs.2025-02-24_Linux_Trixie_2.3.0_patched/
ln -s /mnt/storage/logs.2025-02-24_Linux_Trixie_2.3.0_patched/ /home/hbarta/logs
tmux new -D -s "stir" thrash_stir.sh
tmux new -D -s syncoid thrash_syncoid.sh
tmux new -D -s snaps manage_snaps.sh
```

Kicked off at 1943. 
