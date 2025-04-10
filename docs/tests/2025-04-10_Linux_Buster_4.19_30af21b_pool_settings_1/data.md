# Setup: Commit 30af21b test with modified pool settings

* [Setup](./setup.md)
* [Results](./results.md)
* [home/index](./../../index.md)

## 2025-04-10 all pool send settings

```text
root@orion:~# zpool get all send
NAME  PROPERTY                       VALUE                          SOURCE
send  size                           464G                           -
send  capacity                       0%                             -
send  altroot                        -                              default
send  health                         ONLINE                         -
send  guid                           9407823330334650076            -
send  version                        -                              default
send  bootfs                         -                              default
send  delegation                     on                             default
send  autoreplace                    off                            default
send  cachefile                      -                              default
send  failmode                       wait                           default
send  listsnapshots                  off                            default
send  autoexpand                     off                            default
send  dedupditto                     0                              default
send  dedupratio                     1.00x                          -
send  free                           464G                           -
send  allocated                      684K                           -
send  readonly                       off                            -
send  ashift                         12                             local
send  comment                        -                              default
send  expandsize                     -                              -
send  freeing                        0                              -
send  fragmentation                  0%                             -
send  leaked                         0                              -
send  multihost                      off                            default
send  checkpoint                     -                              -
send  load_guid                      15530980568527709931           -
send  autotrim                       off                            default
send  feature@async_destroy          enabled                        local
send  feature@empty_bpobj            enabled                        local
send  feature@lz4_compress           active                         local
send  feature@multi_vdev_crash_dump  enabled                        local
send  feature@spacemap_histogram     active                         local
send  feature@enabled_txg            active                         local
send  feature@hole_birth             active                         local
send  feature@extensible_dataset     active                         local
send  feature@embedded_data          active                         local
send  feature@bookmarks              enabled                        local
send  feature@filesystem_limits      enabled                        local
send  feature@large_blocks           enabled                        local
send  feature@large_dnode            enabled                        local
send  feature@sha512                 enabled                        local
send  feature@skein                  enabled                        local
send  feature@edonr                  enabled                        local
send  feature@userobj_accounting     active                         local
send  feature@encryption             active                         local
send  feature@project_quota          active                         local
send  feature@device_removal         enabled                        local
send  feature@obsolete_counts        enabled                        local
send  feature@zpool_checkpoint       enabled                        local
send  feature@spacemap_v2            active                         local
send  feature@allocation_classes     enabled                        local
send  feature@resilver_defer         enabled                        local
send  feature@bookmark_v2            enabled                        local
send  feature@redaction_bookmarks    disabled                       local
send  feature@redacted_datasets      disabled                       local
send  feature@bookmark_written       disabled                       local
root@orion:~# 
```

## 2025-04-10 first syncoid

```text
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   564K   464G        -         -     0%     0%  1.00x    ONLINE  -
send   464G   239G   225G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# time -p syncoid --recursive --no-privilege-elevation send/test recv/test
INFO: Sending oldest full snapshot send/test@syncoid_orion_2025-04-10:11:13:16-GMT-05:00 to new target filesystem recv/test (~ 86 KB):
47.7KiB 0:00:00 [3.28MiB/s] [======================================================>                                             ] 55%            
INFO: Sending oldest full snapshot send/test/l0_0@syncoid_orion_2025-04-10:11:13:17-GMT-05:00 to new target filesystem recv/test/l0_0 (~ 15.6 GB):
15.6GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0@syncoid_orion_2025-04-10:11:14:25-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0 (~ 15.9 GB):
15.9GiB 0:01:08 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-10:11:15:34-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_0 (~ 15.3 GB):
15.3GiB 0:01:06 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-10:11:16:41-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_1 (~ 15.3 GB):
15.3GiB 0:01:05 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-10:11:17:46-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_2 (~ 15.6 GB):
15.7GiB 0:01:08 [ 233MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-10:11:18:55-GMT-05:00 to new target filesystem recv/test/l0_0/l1_0/l2_3 (~ 15.1 GB):
15.1GiB 0:01:05 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1@syncoid_orion_2025-04-10:11:20:01-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1 (~ 15.5 GB):
15.5GiB 0:01:07 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-10:11:21:10-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_0 (~ 15.5 GB):
15.5GiB 0:01:07 [ 234MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-10:11:22:18-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_1 (~ 15.5 GB):
15.5GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-10:11:23:25-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_2 (~ 15.3 GB):
15.3GiB 0:01:05 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-10:11:24:31-GMT-05:00 to new target filesystem recv/test/l0_0/l1_1/l2_3 (~ 15.7 GB):
15.7GiB 0:01:07 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2@syncoid_orion_2025-04-10:11:25:39-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2 (~ 15.6 GB):
15.6GiB 0:01:08 [ 234MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-10:11:26:48-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_0 (~ 15.4 GB):
15.4GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-10:11:27:55-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_1 (~ 15.5 GB):
15.5GiB 0:01:07 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-10:11:29:03-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_2 (~ 14.9 GB):
14.9GiB 0:01:04 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-10:11:30:08-GMT-05:00 to new target filesystem recv/test/l0_0/l1_2/l2_3 (~ 15.8 GB):
15.8GiB 0:01:08 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3@syncoid_orion_2025-04-10:11:31:17-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3 (~ 15.3 GB):
15.3GiB 0:01:05 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-10:11:32:23-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_0 (~ 15.6 GB):
15.6GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-10:11:33:31-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_1 (~ 15.9 GB):
15.9GiB 0:01:08 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-10:11:34:40-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_2 (~ 15.6 GB):
15.6GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-10:11:35:47-GMT-05:00 to new target filesystem recv/test/l0_0/l1_3/l2_3 (~ 15.0 GB):
15.0GiB 0:01:03 [ 241MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1@syncoid_orion_2025-04-10:11:36:52-GMT-05:00 to new target filesystem recv/test/l0_1 (~ 14.8 GB):
14.8GiB 0:01:04 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0@syncoid_orion_2025-04-10:11:37:57-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0 (~ 15.6 GB):
15.6GiB 0:01:07 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-10:11:39:05-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_0 (~ 15.5 GB):
15.5GiB 0:01:06 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-10:11:40:12-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_1 (~ 15.8 GB):
15.8GiB 0:01:07 [ 238MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-10:11:41:20-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_2 (~ 15.6 GB):
15.6GiB 0:01:07 [ 235MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-10:11:42:29-GMT-05:00 to new target filesystem recv/test/l0_1/l1_0/l2_3 (~ 15.3 GB):
15.3GiB 0:01:05 [ 237MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1@syncoid_orion_2025-04-10:11:43:35-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1 (~ 15.7 GB):
15.7GiB 0:01:06 [ 240MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-10:11:44:42-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_0 (~ 15.5 GB):
15.5GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
INFO: Sending oldest full snapshot send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-10:11:45:50-GMT-05:00 to new target filesystem recv/test/l0_1/l1_1/l2_1 (~ 15.6 GB):
15.6GiB 0:01:07 [ 236MiB/s] [==================================================================================================>] 100%            
real 2021.14
user 28.73
sys 1952.83
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   239G   225G        -         -     0%    51%  1.00x    ONLINE  -
send   464G   239G   225G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# 
```

## 2025-04-10 last syncoid

```text
hbarta@orion:~/logs$ cat 2025-04-10-151811.syncoid.94.txt
INFO: Sending incremental send/test@syncoid_orion_2025-04-10:15:16:14-GMT-05:00 ... syncoid_orion_2025-04-10:15:18:11-GMT-05:00 to recv/test (~ 4 KB):
INFO: Sending incremental send/test/l0_0@syncoid_orion_2025-04-10:15:16:16-GMT-05:00 ... syncoid_orion_2025-04-10:15:18:13-GMT-05:00 to recv/test/l0_0 (~ 62.6 MB):
INFO: Sending incremental send/test/l0_0/l1_0@syncoid_orion_2025-04-10:15:16:19-GMT-05:00 ... syncoid_orion_2025-04-10:15:18:17-GMT-05:00 to recv/test/l0_0/l1_0 (~ 43.9 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_0@syncoid_orion_2025-04-10:15:16:23-GMT-05:00 ... syncoid_orion_2025-04-10:15:18:20-GMT-05:00 to recv/test/l0_0/l1_0/l2_0 (~ 60.7 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-10:15:16:27-GMT-05:00 ... syncoid_orion_2025-04-10:15:18:24-GMT-05:00 to recv/test/l0_0/l1_0/l2_1 (~ 64.1 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_1'@'syncoid_orion_2025-04-10:15:16:27-GMT-05:00' 'send/test/l0_0/l1_0/l2_1'@'syncoid_orion_2025-04-10:15:18:24-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 67164240 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_1' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_0/l2_2@syncoid_orion_2025-04-10:15:16:31-GMT-05:00 ... syncoid_orion_2025-04-10:15:18:27-GMT-05:00 to recv/test/l0_0/l1_0/l2_2 (~ 66.4 MB):
INFO: Sending incremental send/test/l0_0/l1_0/l2_3@syncoid_orion_2025-04-10:15:16:36-GMT-05:00 ... syncoid_orion_2025-04-10:15:18:31-GMT-05:00 to recv/test/l0_0/l1_0/l2_3 (~ 66.7 MB):
INFO: Sending incremental send/test/l0_0/l1_1@syncoid_orion_2025-04-10:15:16:40-GMT-05:00 ... syncoid_orion_2025-04-10:15:18:35-GMT-05:00 to recv/test/l0_0/l1_1 (~ 50.8 MB):
warning: cannot send 'send/test/l0_0/l1_1@syncoid_orion_2025-04-10:15:18:35-GMT-05:00': Input/output error
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-10ad752853-110-789c636064000310a501c49c50360710a715e5e7a69766a6304001eb9e4f6b59d9163f5500b2d991d4e52765a5269740f82080219f96569c5ac2000720793624f9a4ca92d46206547964fd25f9105794c9dc9c50cc2b251c8124cf0996cf4bcc4d6560284ecd4bd1071a55a29f63106fa09f63186fe8505c99979c9f99129f5f94999f176f646064aa6b60a26b686065686a656861656caaebee1ba26b606a656000b61b0000d22a0e
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1'@'syncoid_orion_2025-04-10:15:16:40-GMT-05:00' 'send/test/l0_0/l1_1'@'syncoid_orion_2025-04-10:15:18:35-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 53292248 |  zfs receive  -s -F 'recv/test/l0_0/l1_1' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_1/l2_0@syncoid_orion_2025-04-10:15:16:44-GMT-05:00 ... syncoid_orion_2025-04-10:15:18:39-GMT-05:00 to recv/test/l0_0/l1_1/l2_0 (~ 46.5 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_1@syncoid_orion_2025-04-10:15:16:48-GMT-05:00 ... syncoid_orion_2025-04-10:15:18:42-GMT-05:00 to recv/test/l0_0/l1_1/l2_1 (~ 67.3 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_2@syncoid_orion_2025-04-10:15:16:52-GMT-05:00 ... syncoid_orion_2025-04-10:15:18:46-GMT-05:00 to recv/test/l0_0/l1_1/l2_2 (~ 67.3 MB):
INFO: Sending incremental send/test/l0_0/l1_1/l2_3@syncoid_orion_2025-04-10:15:16:56-GMT-05:00 ... syncoid_orion_2025-04-10:15:18:50-GMT-05:00 to recv/test/l0_0/l1_1/l2_3 (~ 64.8 MB):
INFO: Sending incremental send/test/l0_0/l1_2@syncoid_orion_2025-04-10:15:17:01-GMT-05:00 ... syncoid_orion_2025-04-10:15:18:54-GMT-05:00 to recv/test/l0_0/l1_2 (~ 68.2 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_0@syncoid_orion_2025-04-10:15:17:04-GMT-05:00 ... syncoid_orion_2025-04-10:15:18:58-GMT-05:00 to recv/test/l0_0/l1_2/l2_0 (~ 66.7 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_1@syncoid_orion_2025-04-10:15:17:08-GMT-05:00 ... syncoid_orion_2025-04-10:15:19:01-GMT-05:00 to recv/test/l0_0/l1_2/l2_1 (~ 44.6 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_2@syncoid_orion_2025-04-10:15:17:11-GMT-05:00 ... syncoid_orion_2025-04-10:15:19:04-GMT-05:00 to recv/test/l0_0/l1_2/l2_2 (~ 44.8 MB):
INFO: Sending incremental send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-10:15:17:15-GMT-05:00 ... syncoid_orion_2025-04-10:15:19:06-GMT-05:00 to recv/test/l0_0/l1_2/l2_3 (~ 45.8 MB):
warning: cannot send 'send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-10:15:19:06-GMT-05:00': Input/output error
cannot receive incremental stream: checksum mismatch or incomplete stream.
Partially received snapshot is saved.
A resuming stream can be generated on the sending system by running:
    zfs send -t 1-1230122a1d-118-789c636064000310a501c49c50360710a715e5e7a69766a63040c14ecd70d9ead5a57b14806c762475f94959a9c925103e0860c8a7a515a79630c001489e0d493ea9b224b59801551e597f493ec415a5cfccff75fc614e4b4092e704cbe725e6a6323014a7e6a5e8038d2ad1cf318837d0cf318c37d2cf318a377628aecc4bcecf4c89cf2fcacccf8b37323032d53530d13534b03234b532b4b43230d375f70dd13530b5323080b90100e18f2d04
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_3'@'syncoid_orion_2025-04-10:15:17:15-GMT-05:00' 'send/test/l0_0/l1_2/l2_3'@'syncoid_orion_2025-04-10:15:19:06-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 48045480 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_3' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_3@syncoid_orion_2025-04-10:15:17:20-GMT-05:00 ... syncoid_orion_2025-04-10:15:19:08-GMT-05:00 to recv/test/l0_0/l1_3 (~ 43.5 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-10:15:17:23-GMT-05:00 ... syncoid_orion_2025-04-10:15:19:11-GMT-05:00 to recv/test/l0_0/l1_3/l2_0 (~ 46.3 MB):
internal error: Invalid argument
Aborted
cannot receive: failed to read from stream
CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_0'@'syncoid_orion_2025-04-10:15:17:23-GMT-05:00' 'send/test/l0_0/l1_3/l2_0'@'syncoid_orion_2025-04-10:15:19:11-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 48496776 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_0' 2>&1 failed: 256
INFO: Sending incremental send/test/l0_0/l1_3/l2_1@syncoid_orion_2025-04-10:15:17:27-GMT-05:00 ... syncoid_orion_2025-04-10:15:19:13-GMT-05:00 to recv/test/l0_0/l1_3/l2_1 (~ 44.0 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_2@syncoid_orion_2025-04-10:15:17:30-GMT-05:00 ... syncoid_orion_2025-04-10:15:19:16-GMT-05:00 to recv/test/l0_0/l1_3/l2_2 (~ 43.4 MB):
INFO: Sending incremental send/test/l0_0/l1_3/l2_3@syncoid_orion_2025-04-10:15:17:33-GMT-05:00 ... syncoid_orion_2025-04-10:15:19:19-GMT-05:00 to recv/test/l0_0/l1_3/l2_3 (~ 26.8 MB):
INFO: Sending incremental send/test/l0_1@syncoid_orion_2025-04-10:15:17:36-GMT-05:00 ... syncoid_orion_2025-04-10:15:19:22-GMT-05:00 to recv/test/l0_1 (~ 47.7 MB):
INFO: Sending incremental send/test/l0_1/l1_0@syncoid_orion_2025-04-10:15:17:40-GMT-05:00 ... syncoid_orion_2025-04-10:15:19:25-GMT-05:00 to recv/test/l0_1/l1_0 (~ 45.4 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_0@syncoid_orion_2025-04-10:15:17:44-GMT-05:00 ... syncoid_orion_2025-04-10:15:19:28-GMT-05:00 to recv/test/l0_1/l1_0/l2_0 (~ 43.5 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_1@syncoid_orion_2025-04-10:15:17:48-GMT-05:00 ... syncoid_orion_2025-04-10:15:19:31-GMT-05:00 to recv/test/l0_1/l1_0/l2_1 (~ 46.1 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_2@syncoid_orion_2025-04-10:15:17:52-GMT-05:00 ... syncoid_orion_2025-04-10:15:19:34-GMT-05:00 to recv/test/l0_1/l1_0/l2_2 (~ 44.9 MB):
INFO: Sending incremental send/test/l0_1/l1_0/l2_3@syncoid_orion_2025-04-10:15:17:56-GMT-05:00 ... syncoid_orion_2025-04-10:15:19:36-GMT-05:00 to recv/test/l0_1/l1_0/l2_3 (~ 44.6 MB):
INFO: Sending incremental send/test/l0_1/l1_1@syncoid_orion_2025-04-10:15:18:00-GMT-05:00 ... syncoid_orion_2025-04-10:15:19:38-GMT-05:00 to recv/test/l0_1/l1_1 (~ 31.6 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_0@syncoid_orion_2025-04-10:15:18:04-GMT-05:00 ... syncoid_orion_2025-04-10:15:19:41-GMT-05:00 to recv/test/l0_1/l1_1/l2_0 (~ 21.1 MB):
INFO: Sending incremental send/test/l0_1/l1_1/l2_1@syncoid_orion_2025-04-10:15:18:08-GMT-05:00 ... syncoid_orion_2025-04-10:15:19:44-GMT-05:00 to recv/test/l0_1/l1_1/l2_1 (~ 22.0 MB):
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

errors: 4 data errors, use '-v' for a list
hbarta@orion:~/logs$
```

## 2025-04-10 various zpool status

```text
hbarta@orion:~/logs$ zpool status send
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
errors: List of errors unavailable: permission denied

errors: 4 data errors, use '-v' for a list
hbarta@orion:~/logs$ sudo zpool status send
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

errors: 4 data errors, use '-v' for a list
hbarta@orion:~/logs$ sudo zpool status send -v
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

        send/test/l0_0/l1_0/l2_1@syncoid_orion_2025-04-10:15:18:24-GMT-05:00:<0x0>
        send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-10:15:19:06-GMT-05:00:<0x0>
        send/test/l0_0/l1_3/l2_0@syncoid_orion_2025-04-10:15:19:11-GMT-05:00:<0x0>
        send/test/l0_0/l1_1@syncoid_orion_2025-04-10:15:18:35-GMT-05:00:<0x0>
hbarta@orion:~/logs$ 
```

## 2025-04-10 errors reported in logs

```text
hbarta@orion:~/logs$ grep -i err *.txt |grep -v "No known"
2025-04-10-151810.stir_pools.44.txt:errors: List of errors unavailable: permission denied
2025-04-10-151810.stir_pools.44.txt:status: One or more devices has experienced an error resulting in data
2025-04-10-151810.stir_pools.44.txt:errors: 2 data errors, use '-v' for a list
2025-04-10-151811.syncoid.94.txt:internal error: Invalid argument
2025-04-10-151811.syncoid.94.txt:CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_0/l2_1'@'syncoid_orion_2025-04-10:15:16:27-GMT-05:00' 'send/test/l0_0/l1_0/l2_1'@'syncoid_orion_2025-04-10:15:18:24-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 67164240 |  zfs receive  -s -F 'recv/test/l0_0/l1_0/l2_1' 2>&1 failed: 256
2025-04-10-151811.syncoid.94.txt:warning: cannot send 'send/test/l0_0/l1_1@syncoid_orion_2025-04-10:15:18:35-GMT-05:00': Input/output error
2025-04-10-151811.syncoid.94.txt:CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_1'@'syncoid_orion_2025-04-10:15:16:40-GMT-05:00' 'send/test/l0_0/l1_1'@'syncoid_orion_2025-04-10:15:18:35-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 53292248 |  zfs receive  -s -F 'recv/test/l0_0/l1_1' 2>&1 failed: 256
2025-04-10-151811.syncoid.94.txt:warning: cannot send 'send/test/l0_0/l1_2/l2_3@syncoid_orion_2025-04-10:15:19:06-GMT-05:00': Input/output error
2025-04-10-151811.syncoid.94.txt:CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_2/l2_3'@'syncoid_orion_2025-04-10:15:17:15-GMT-05:00' 'send/test/l0_0/l1_2/l2_3'@'syncoid_orion_2025-04-10:15:19:06-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 48045480 |  zfs receive  -s -F 'recv/test/l0_0/l1_2/l2_3' 2>&1 failed: 256
2025-04-10-151811.syncoid.94.txt:internal error: Invalid argument
2025-04-10-151811.syncoid.94.txt:CRITICAL ERROR:  zfs send  -I 'send/test/l0_0/l1_3/l2_0'@'syncoid_orion_2025-04-10:15:17:23-GMT-05:00' 'send/test/l0_0/l1_3/l2_0'@'syncoid_orion_2025-04-10:15:19:11-GMT-05:00' | mbuffer  -q -s 128k -m 16M | pv -p -t -e -r -b -s 48496776 |  zfs receive  -s -F 'recv/test/l0_0/l1_3/l2_0' 2>&1 failed: 256
2025-04-10-151811.syncoid.94.txt:errors: List of errors unavailable: permission denied
2025-04-10-151811.syncoid.94.txt:status: One or more devices has experienced an error resulting in data
2025-04-10-151811.syncoid.94.txt:errors: 4 data errors, use '-v' for a list
hbarta@orion:~/logs$ 
```