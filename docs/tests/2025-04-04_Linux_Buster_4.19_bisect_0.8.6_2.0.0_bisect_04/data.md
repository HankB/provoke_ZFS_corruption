# Data: Git bisect 0.8.6 to 2.0.0 - testing fourth bisect

* [Setup](./setup.md)
* [Results](./results.md)



```text
> time -p syncoid --recursive --no-privilege-elevation send/test recv/test
> ```
bash: text: command not found
47.7KiB 0:00:00 [5.55MiB/s] [======================================================>                                             ] 55%            
15.6GiB 0:01:08 [ 233MiB/s] [==================================================================================================>] 100%            
15.4GiB 0:01:09 [ 227MiB/s] [==================================================================================================>] 100%            
15.4GiB 0:01:08 [ 228MiB/s] [==================================================================================================>] 100%            
15.5GiB 0:01:09 [ 228MiB/s] [==================================================================================================>] 100%            
15.3GiB 0:01:07 [ 231MiB/s] [==================================================================================================>] 100%            
15.7GiB 0:01:09 [ 233MiB/s] [==================================================================================================>] 100%            
15.3GiB 0:01:07 [ 230MiB/s] [==================================================================================================>] 100%            
15.2GiB 0:01:07 [ 230MiB/s] [==================================================================================================>] 100%            
15.6GiB 0:01:08 [ 232MiB/s] [==================================================================================================>] 100%            
15.5GiB 0:01:08 [ 229MiB/s] [==================================================================================================>] 100%            
15.8GiB 0:01:10 [ 230MiB/s] [==================================================================================================>] 100%            
15.5GiB 0:01:08 [ 229MiB/s] [==================================================================================================>] 100%            
15.4GiB 0:01:08 [ 229MiB/s] [==================================================================================================>] 100%            
15.3GiB 0:01:08 [ 229MiB/s] [==================================================================================================>] 100%            
15.3GiB 0:01:07 [ 230MiB/s] [==================================================================================================>] 100%            
15.2GiB 0:01:07 [ 231MiB/s] [==================================================================================================>] 100%            
15.5GiB 0:01:09 [ 229MiB/s] [==================================================================================================>] 100%            
15.7GiB 0:01:08 [ 234MiB/s] [==================================================================================================>] 100%            
15.6GiB 0:01:09 [ 231MiB/s] [==================================================================================================>] 100%            
15.5GiB 0:01:08 [ 231MiB/s] [==================================================================================================>] 100%            
15.3GiB 0:01:06 [ 234MiB/s] [==================================================================================================>] 100%            
15.6GiB 0:01:10 [ 227MiB/s] [==================================================================================================>] 100%            
15.8GiB 0:01:10 [ 230MiB/s] [==================================================================================================>] 100%            
15.3GiB 0:01:08 [ 227MiB/s] [==================================================================================================>] 100%            
15.2GiB 0:01:07 [ 230MiB/s] [==================================================================================================>] 100%            
15.7GiB 0:01:09 [ 231MiB/s] [==================================================================================================>] 100%            
15.5GiB 0:01:09 [ 227MiB/s] [==================================================================================================>] 100%            
15.3GiB 0:01:08 [ 227MiB/s] [==================================================================================================>] 100%            
15.8GiB 0:01:09 [ 231MiB/s] [==================================================================================================>] 100%            
15.3GiB 0:01:08 [ 229MiB/s] [==================================================================================================>] 100%            
real 2076.70
user 27.51
sys 1896.61
bash: INFO:: command not found
root@orion:~#
```

## 2025-04-05 last syncoid and pool status

```text
hbarta@orion:~/logs$ cat halt_test.txt
2025-04-05-011427
2025-04-05-011434
2025-04-05-011524
hbarta@orion:~/logs$ cat 2025-04-05-011349.syncoid.94.txt
INFO: Sending incremental send/test@syncoid_orion_2025-04-05:01:12:04-GMT-05:00 ... syncoid_orion_2025-04-05:01:13:49-GMT-05:00 to recv/test (~ 4 KB):
INFO: Sending incremental send/test/l0_0@syncoid_orion_2025-04-05:01:12:05-GMT-05:00 ... syncoid_orion_2025-04-05:01:13:51-GMT-05:00 to recv/test/l0_0 (~ 52.5 MB):
INFO: Sending incremental send/test/l0_0/l1_0@syncoid_orion_2025-04-05:01:12:08-GMT-05:00 ... syncoid_orion_2025-04-05:01:13:55-GMT-05:00 to recv/test/l0_0/l1_0 (~ 62.1 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-05:01:12:11-GMT-05:00 ... syncoid_orion_2025-04-05:01:13:59-GMT-05:00 to recv/test/l0_0/l1_0/l2_0 (~ 67.9 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-05:01:12:14-GMT-05:00 ... syncoid_orion_2025-04-05:01:14:03-GMT-05:00 to recv/test/l0_0/l1_0/l2_1 (~ 67.0 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-05:01:12:17-GMT-05:00 ... syncoid_orion_2025-04-05:01:14:07-GMT-05:00 to recv/test/l0_0/l1_0/l2_2 (~ 67.7 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-05:01:12:20-GMT-05:00 ... syncoid_orion_2025-04-05:01:14:12-GMT-05:00 to recv/test/l0_0/l1_0/l2_3 (~ 42.7 MB):
INFO: Sending incremental send/test/l0_0/l1_1@syncoid_orion_2025-04-05:01:12:23-GMT-05:00 ... syncoid_orion_2025-04-05:01:14:15-GMT-05:00 to recv/test/l0_0/l1_1 (~ 66.6 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-05:01:12:27-GMT-05:00 ... syncoid_orion_2025-04-05:01:14:19-GMT-05:00 to recv/test/l0_0/l1_1/l2_0 (~ 66.3 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-05:01:12:30-GMT-05:00 ... syncoid_orion_2025-04-05:01:14:24-GMT-05:00 to recv/test/l0_0/l1_1/l2_1 (~ 70.0 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1/l2_1'@'syncoid_orion_2025-04-05:01:12:30-GMT-05:00' 'send/test/l0_0/l1_1/l2_1'@'syncoid_orion_2025-04-05:01:14:24-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 73354664 |  zfs receive  -s -F 'recv/test/l0_0/l1_1/l2_1' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-05:01:12:34-GMT-05:00 ... syncoid_orion_2025-04-05:01:14:27-GMT-05:00 to recv/test/l0_0/l1_1/l2_2 (~ 68.6 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-05:01:12:37-GMT-05:00 ... syncoid_orion_2025-04-05:01:14:31-GMT-05:00 to recv/test/l0_0/l1_1/l2_3 (~ 43.9 MB):
INFO: Sending incremental send/test/l0_0/l1_2@syncoid_orion_2025-04-05:01:12:41-GMT-05:00 ... syncoid_orion_2025-04-05:01:14:34-GMT-05:00 to recv/test/l0_0/l1_2 (~ 45.2 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-05:01:12:46-GMT-05:00 ... syncoid_orion_2025-04-05:01:14:37-GMT-05:00 to recv/test/l0_0/l1_2/l2_0 (~ 44.6 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-05:01:12:49-GMT-05:00 ... syncoid_orion_2025-04-05:01:14:40-GMT-05:00 to recv/test/l0_0/l1_2/l2_1 (~ 46.4 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-05:01:12:53-GMT-05:00 ... syncoid_orion_2025-04-05:01:14:44-GMT-05:00 to recv/test/l0_0/l1_2/l2_2 (~ 46.3 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-05:01:12:56-GMT-05:00 ... syncoid_orion_2025-04-05:01:14:47-GMT-05:00 to recv/test/l0_0/l1_2/l2_3 (~ 45.5 MB):
INFO: Sending incremental send/test/l0_0/l1_3@syncoid_orion_2025-04-05:01:12:59-GMT-05:00 ... syncoid_orion_2025-04-05:01:14:50-GMT-05:00 to recv/test/l0_0/l1_3 (~ 28.1 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-05:01:13:02-GMT-05:00 ... syncoid_orion_2025-04-05:01:14:52-GMT-05:00 to recv/test/l0_0/l1_3/l2_0 (~ 23.6 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-05:01:13:06-GMT-05:00 ... syncoid_orion_2025-04-05:01:14:55-GMT-05:00 to recv/test/l0_0/l1_3/l2_1 (~ 23.2 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-05:01:13:10-GMT-05:00 ... syncoid_orion_2025-04-05:01:14:58-GMT-05:00 to recv/test/l0_0/l1_3/l2_2 (~ 21.1 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_2'@'syncoid_orion_2025-04-05:01:13:10-GMT-05:00' 'send/test/l0_0/l1_3/l2_2'@'syncoid_orion_2025-04-05:01:14:58-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 22154656 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_2' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-05:01:13:14-GMT-05:00 ... syncoid_orion_2025-04-05:01:14:59-GMT-05:00 to recv/test/l0_0/l1_3/l2_3 (~ 23.7 MB):
INFO: Sending incremental send/test/l0_1@syncoid_orion_2025-04-05:01:13:18-GMT-05:00 ... syncoid_orion_2025-04-05:01:15:01-GMT-05:00 to recv/test/l0_1 (~ 44.5 MB):
INFO: Sending incremental send/test/l0_1/l1_0@syncoid_orion_2025-04-05:01:13:21-GMT-05:00 ... syncoid_orion_2025-04-05:01:15:05-GMT-05:00 to recv/test/l0_1/l1_0 (~ 43.9 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-05:01:13:25-GMT-05:00 ... syncoid_orion_2025-04-05:01:15:08-GMT-05:00 to recv/test/l0_1/l1_0/l2_0 (~ 46.9 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-05:01:13:28-GMT-05:00 ... syncoid_orion_2025-04-05:01:15:11-GMT-05:00 to recv/test/l0_1/l1_0/l2_1 (~ 42.1 MB):
warning: cannot send 'send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-05:01:15:11-GMT-05:00': Input/output error
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-118b9b800c-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c1bcd7f76392ad75cc15806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415b1b9ee56ac2fb72f4c4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d4cf318c37d0cf318a377428aecc4bcecf4c89cf2fcacccf8b37323032d53530d13530b53230b43234b53234d475f70d01f30d606e000097632c24
CRITICAL ERROR:  zfs send  -I 'send/test/l0_1/l1_0/l2_1'@'syncoid_orion_2025-04-05:01:13:28-GMT-05:00' 'send/test/l0_1/l1_0/l2_1'@'syncoid_orion_2025-04-05:01:15:11-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 44144224 |  zfs receive  -s -F 'recv/test/l0_1/l1_0/l2_1' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-05:01:13:32-GMT-05:00 ... syncoid_orion_2025-04-05:01:15:12-GMT-05:00 to recv/test/l0_1/l1_0/l2_2 (~ 36.2 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-05:01:13:35-GMT-05:00 ... syncoid_orion_2025-04-05:01:15:15-GMT-05:00 to recv/test/l0_1/l1_0/l2_3 (~ 23.0 MB):
INFO: Sending incremental send/test/l0_1/l1_1@syncoid_orion_2025-04-05:01:13:39-GMT-05:00 ... syncoid_orion_2025-04-05:01:15:17-GMT-05:00 to recv/test/l0_1/l1_1 (~ 24.0 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-05:01:13:42-GMT-05:00 ... syncoid_orion_2025-04-05:01:15:20-GMT-05:00 to recv/test/l0_1/l1_1/l2_0 (~ 23.0 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-05:01:13:46-GMT-05:00 ... syncoid_orion_2025-04-05:01:15:22-GMT-05:00 to recv/test/l0_1/l1_1/l2_1 (~ 23.1 MB):
errors: List of errors unavailable: permission denied
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: http://zfsonlinux.org/msg/ZFS-8000-8A
  scan: none requested
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: 3 data errors, use '-v' for a list
hbarta@orion:~/logs$ sudo zpool status -v send
[sudo] password for hbarta: 
  pool: send
 state: ONLINE
status: One or more devices has experienced an error resulting in data
        corruption.  Applications may be affected.
action: Restore the file in question if possible.  Otherwise restore the
        entire pool from backup.
   see: http://zfsonlinux.org/msg/ZFS-8000-8A
  scan: none requested
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: Permanent errors have been detected in the following files:

        send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-05:01:14:58-GMT-05:00:<0x0>
        send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-05:01:15:11-GMT-05:00:<0x0>
        send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-05:01:14:24-GMT-05:00:<0x0>
hbarta@orion:~/logs$ 
```
