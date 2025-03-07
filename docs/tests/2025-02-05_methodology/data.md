# data

* [Results](./results.md)

This file includes long listings that would only obscure some other descriptions.

## 2025-02-05 pool attributes

```text
hbarta@orcus:~$ zpool get all
NAME  PROPERTY                       VALUE                          SOURCE
recv  size                           464G                           -
recv  capacity                       23%                            -
recv  altroot                        -                              default
recv  health                         ONLINE                         -
recv  guid                           922999215816486814             -
recv  version                        -                              default
recv  bootfs                         -                              default
recv  delegation                     on                             default
recv  autoreplace                    off                            default
recv  cachefile                      -                              default
recv  failmode                       wait                           default
recv  listsnapshots                  off                            default
recv  autoexpand                     off                            default
recv  dedupratio                     1.00x                          -
recv  free                           357G                           -
recv  allocated                      107G                           -
recv  readonly                       off                            -
recv  ashift                         12                             local
recv  comment                        -                              default
recv  expandsize                     -                              -
recv  freeing                        0                              -
recv  fragmentation                  0%                             -
recv  leaked                         0                              -
recv  multihost                      off                            default
recv  checkpoint                     -                              -
recv  load_guid                      4164237566347638476            -
recv  autotrim                       off                            default
recv  compatibility                  off                            default
recv  feature@async_destroy          enabled                        local
recv  feature@empty_bpobj            active                         local
recv  feature@lz4_compress           active                         local
recv  feature@multi_vdev_crash_dump  enabled                        local
recv  feature@spacemap_histogram     active                         local
recv  feature@enabled_txg            active                         local
recv  feature@hole_birth             active                         local
recv  feature@extensible_dataset     active                         local
recv  feature@embedded_data          active                         local
recv  feature@bookmarks              enabled                        local
recv  feature@filesystem_limits      enabled                        local
recv  feature@large_blocks           enabled                        local
recv  feature@large_dnode            active                         local
recv  feature@sha512                 enabled                        local
recv  feature@skein                  enabled                        local
recv  feature@edonr                  enabled                        local
recv  feature@userobj_accounting     active                         local
recv  feature@encryption             enabled                        local
recv  feature@project_quota          active                         local
recv  feature@device_removal         enabled                        local
recv  feature@obsolete_counts        enabled                        local
recv  feature@zpool_checkpoint       enabled                        local
recv  feature@spacemap_v2            active                         local
recv  feature@allocation_classes     enabled                        local
recv  feature@resilver_defer         enabled                        local
recv  feature@bookmark_v2            enabled                        local
recv  feature@redaction_bookmarks    enabled                        local
recv  feature@redacted_datasets      enabled                        local
recv  feature@bookmark_written       enabled                        local
recv  feature@log_spacemap           active                         local
recv  feature@livelist               enabled                        local
recv  feature@device_rebuild         enabled                        local
recv  feature@zstd_compress          enabled                        local
recv  feature@draid                  enabled                        local
send  size                           464G                           -
send  capacity                       61%                            -
send  altroot                        -                              default
send  health                         ONLINE                         -
send  guid                           329634532299283979             -
send  version                        -                              default
send  bootfs                         -                              default
send  delegation                     on                             default
send  autoreplace                    off                            default
send  cachefile                      -                              default
send  failmode                       wait                           default
send  listsnapshots                  off                            default
send  autoexpand                     off                            default
send  dedupratio                     1.00x                          -
send  free                           180G                           -
send  allocated                      284G                           -
send  readonly                       off                            -
send  ashift                         12                             local
send  comment                        -                              default
send  expandsize                     -                              -
send  freeing                        0                              -
send  fragmentation                  2%                             -
send  leaked                         0                              -
send  multihost                      off                            default
send  checkpoint                     -                              -
send  load_guid                      531729898646500106             -
send  autotrim                       off                            default
send  compatibility                  off                            default
send  feature@async_destroy          enabled                        local
send  feature@empty_bpobj            active                         local
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
send  feature@large_dnode            active                         local
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
send  feature@redaction_bookmarks    enabled                        local
send  feature@redacted_datasets      enabled                        local
send  feature@bookmark_written       enabled                        local
send  feature@log_spacemap           active                         local
send  feature@livelist               enabled                        local
send  feature@device_rebuild         enabled                        local
send  feature@zstd_compress          enabled                        local
send  feature@draid                  enabled                        local
hbarta@orcus:~$ 
```

## 2025-02-05 send Dataset attributes

```text
hbarta@orcus:~$ zfs get all send
NAME  PROPERTY              VALUE                  SOURCE
send  type                  filesystem             -
send  creation              Wed Feb  5 11:17 2025  -
send  used                  284G                   -
send  available             166G                   -
send  referenced            200K                   -
send  compressratio         1.94x                  -
send  mounted               yes                    -
send  quota                 none                   default
send  reservation           none                   default
send  recordsize            128K                   default
send  mountpoint            /mnt/send              local
send  sharenfs              off                    default
send  checksum              on                     default
send  compression           lz4                    local
send  atime                 on                     default
send  devices               on                     default
send  exec                  on                     default
send  setuid                on                     default
send  readonly              off                    default
send  zoned                 off                    default
send  snapdir               hidden                 default
send  aclmode               discard                default
send  aclinherit            restricted             default
send  createtxg             1                      -
send  canmount              on                     local
send  xattr                 sa                     local
send  copies                1                      default
send  version               5                      -
send  utf8only              on                     -
send  normalization         formD                  -
send  casesensitivity       sensitive              -
send  vscan                 off                    default
send  nbmand                off                    default
send  sharesmb              off                    default
send  refquota              none                   default
send  refreservation        none                   default
send  guid                  1302554668454984157    -
send  primarycache          all                    default
send  secondarycache        all                    default
send  usedbysnapshots       0B                     -
send  usedbydataset         200K                   -
send  usedbychildren        284G                   -
send  usedbyrefreservation  0B                     -
send  logbias               latency                default
send  objsetid              54                     -
send  dedup                 off                    default
send  mlslabel              none                   default
send  sync                  standard               default
send  dnodesize             auto                   local
send  refcompressratio      1.00x                  -
send  written               0                      -
send  logicalused           551G                   -
send  logicalreferenced     69.5K                  -
send  volmode               default                default
send  filesystem_limit      none                   default
send  snapshot_limit        none                   default
send  filesystem_count      none                   default
send  snapshot_count        none                   default
send  snapdev               hidden                 default
send  acltype               posix                  local
send  context               none                   default
send  fscontext             none                   default
send  defcontext            none                   default
send  rootcontext           none                   default
send  relatime              on                     local
send  redundant_metadata    all                    default
send  overlay               on                     default
send  encryption            aes-256-gcm            -
send  keylocation           file:///pool-key       local
send  keyformat             raw                    -
send  pbkdf2iters           0                      default
send  encryptionroot        send                   -
send  keystatus             available              -
send  special_small_blocks  0                      default
hbarta@orcus:~$ 
```

## 2025-02-05 send Dataset attributes

```text
barta@orcus:~$ zfs get all recv
NAME  PROPERTY              VALUE                  SOURCE
recv  type                  filesystem             -
recv  creation              Wed Feb  5 17:07 2025  -
recv  used                  117G                   -
recv  available             332G                   -
recv  referenced            96K                    -
recv  compressratio         1.94x                  -
recv  mounted               yes                    -
recv  quota                 none                   default
recv  reservation           none                   default
recv  recordsize            128K                   default
recv  mountpoint            /mnt/recv              local
recv  sharenfs              off                    default
recv  checksum              on                     default
recv  compression           lz4                    local
recv  atime                 on                     default
recv  devices               on                     default
recv  exec                  on                     default
recv  setuid                on                     default
recv  readonly              off                    default
recv  zoned                 off                    default
recv  snapdir               hidden                 default
recv  aclmode               discard                default
recv  aclinherit            restricted             default
recv  createtxg             1                      -
recv  canmount              on                     local
recv  xattr                 sa                     local
recv  copies                1                      default
recv  version               5                      -
recv  utf8only              on                     -
recv  normalization         formD                  -
recv  casesensitivity       sensitive              -
recv  vscan                 off                    default
recv  nbmand                off                    default
recv  sharesmb              off                    default
recv  refquota              none                   default
recv  refreservation        none                   default
recv  guid                  16434171670735112783   -
recv  primarycache          all                    default
recv  secondarycache        all                    default
recv  usedbysnapshots       0B                     -
recv  usedbydataset         96K                    -
recv  usedbychildren        117G                   -
recv  usedbyrefreservation  0B                     -
recv  logbias               latency                default
recv  objsetid              54                     -
recv  dedup                 off                    default
recv  mlslabel              none                   default
recv  sync                  standard               default
recv  dnodesize             auto                   local
recv  refcompressratio      1.00x                  -
recv  written               96K                    -
recv  logicalused           228G                   -
recv  logicalreferenced     42K                    -
recv  volmode               default                default
recv  filesystem_limit      none                   default
recv  snapshot_limit        none                   default
recv  filesystem_count      none                   default
recv  snapshot_count        none                   default
recv  snapdev               hidden                 default
recv  acltype               posix                  local
recv  context               none                   default
recv  fscontext             none                   default
recv  defcontext            none                   default
recv  rootcontext           none                   default
recv  relatime              on                     local
recv  redundant_metadata    all                    default
recv  overlay               on                     default
recv  encryption            off                    default
recv  keylocation           none                   default
recv  keyformat             none                   default
recv  pbkdf2iters           0                      default
recv  special_small_blocks  0                      default
hbarta@orcus:~$
```

## 2025-01-06 list of log files

```text
hbarta@orcus:~/logs$ ls -lrt
total 28308
-rw-r--r-- 1 hbarta hbarta   6144 Feb  6 13:37 2025-02-06-1336.syncoid.15.txt
-rw-r--r-- 1 hbarta hbarta 487671 Feb  6 13:37 2025-02-06-1337.stir_pools.31.txt
-rw-r--r-- 1 hbarta hbarta   6144 Feb  6 13:37 2025-02-06-1337.syncoid.13.txt
-rw-r--r-- 1 hbarta hbarta   6144 Feb  6 13:38 2025-02-06-1337.syncoid.14.txt
-rw-r--r-- 1 hbarta hbarta 489407 Feb  6 13:38 2025-02-06-1337.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta   2069 Feb  6 13:38 2025-02-06-1338.trim_snaps.0.txt
-rw-r--r-- 1 hbarta hbarta   6144 Feb  6 13:38 2025-02-06-1338.syncoid.15.txt
-rw-r--r-- 1 hbarta hbarta 490765 Feb  6 13:38 2025-02-06-1338.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta   6144 Feb  6 13:39 2025-02-06-1338.syncoid.14.txt
-rw-r--r-- 1 hbarta hbarta 491088 Feb  6 13:39 2025-02-06-1338.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   2069 Feb  6 13:39 2025-02-06-1339.trim_snaps.1.txt
-rw-r--r-- 1 hbarta hbarta 485320 Feb  6 13:39 2025-02-06-1339.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   6144 Feb  6 13:39 2025-02-06-1339.syncoid.15.txt
-rw-r--r-- 1 hbarta hbarta   6144 Feb  6 13:40 2025-02-06-1339.syncoid.16.txt
-rw-r--r-- 1 hbarta hbarta 493692 Feb  6 13:40 2025-02-06-1339.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta   2069 Feb  6 13:40 2025-02-06-1340.trim_snaps.1.txt
-rw-r--r-- 1 hbarta hbarta 484412 Feb  6 13:40 2025-02-06-1340.stir_pools.28.txt
-rw-r--r-- 1 hbarta hbarta   6144 Feb  6 13:40 2025-02-06-1340.syncoid.17.txt
-rw-r--r-- 1 hbarta hbarta   6144 Feb  6 13:41 2025-02-06-1340.syncoid.16.txt
-rw-r--r-- 1 hbarta hbarta 494201 Feb  6 13:41 2025-02-06-1340.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta   2069 Feb  6 13:41 2025-02-06-1341.trim_snaps.1.txt
-rw-r--r-- 1 hbarta hbarta   6144 Feb  6 13:41 2025-02-06-1341.syncoid.19.txt
-rw-r--r-- 1 hbarta hbarta   6144 Feb  6 13:42 2025-02-06-1341.syncoid.20.txt
-rw-r--r-- 1 hbarta hbarta 491279 Feb  6 13:42 2025-02-06-1341.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta   2069 Feb  6 13:42 2025-02-06-1342.trim_snaps.1.txt
-rw-r--r-- 1 hbarta hbarta 492090 Feb  6 13:42 2025-02-06-1342.stir_pools.29.txt
-rw-r--r-- 1 hbarta hbarta   6144 Feb  6 13:42 2025-02-06-1342.syncoid.21.txt
-rw-r--r-- 1 hbarta hbarta   6218 Feb  6 13:43 2025-02-06-1342.syncoid.31.txt
-rw-r--r-- 1 hbarta hbarta 462836 Feb  6 13:43 2025-02-06-1342.stir_pools.49.txt
-rw-r--r-- 1 hbarta hbarta   2069 Feb  6 13:43 2025-02-06-1343.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta   6255 Feb  6 13:44 2025-02-06-1343.syncoid.55.txt
-rw-r--r-- 1 hbarta hbarta 441434 Feb  6 13:44 2025-02-06-1343.stir_pools.67.txt
-rw-r--r-- 1 hbarta hbarta   2069 Feb  6 13:44 2025-02-06-1344.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta   6257 Feb  6 13:45 2025-02-06-1344.syncoid.57.txt
-rw-r--r-- 1 hbarta hbarta 444212 Feb  6 13:45 2025-02-06-1344.stir_pools.62.txt
-rw-r--r-- 1 hbarta hbarta   2047 Feb  6 13:45 2025-02-06-1345.trim_snaps.1.txt
-rw-r--r-- 1 hbarta hbarta   6260 Feb  6 13:46 2025-02-06-1345.syncoid.58.txt
-rw-r--r-- 1 hbarta hbarta 434548 Feb  6 13:46 2025-02-06-1345.stir_pools.58.txt
-rw-r--r-- 1 hbarta hbarta   2047 Feb  6 13:46 2025-02-06-1346.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta   6261 Feb  6 13:47 2025-02-06-1346.syncoid.62.txt
-rw-r--r-- 1 hbarta hbarta 441372 Feb  6 13:47 2025-02-06-1346.stir_pools.57.txt
-rw-r--r-- 1 hbarta hbarta   2047 Feb  6 13:47 2025-02-06-1347.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta   6261 Feb  6 13:48 2025-02-06-1347.syncoid.70.txt
-rw-r--r-- 1 hbarta hbarta 445175 Feb  6 13:48 2025-02-06-1347.stir_pools.57.txt
-rw-r--r-- 1 hbarta hbarta   2047 Feb  6 13:48 2025-02-06-1348.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta 441748 Feb  6 13:49 2025-02-06-1348.stir_pools.53.txt
-rw-r--r-- 1 hbarta hbarta   6261 Feb  6 13:49 2025-02-06-1348.syncoid.69.txt
-rw-r--r-- 1 hbarta hbarta   2047 Feb  6 13:49 2025-02-06-1349.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta 438972 Feb  6 13:50 2025-02-06-1349.stir_pools.54.txt
-rw-r--r-- 1 hbarta hbarta   2047 Feb  6 13:50 2025-02-06-1350.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta   6261 Feb  6 13:50 2025-02-06-1349.syncoid.85.txt
-rw-r--r-- 1 hbarta hbarta 446532 Feb  6 13:51 2025-02-06-1350.stir_pools.53.txt
-rw-r--r-- 1 hbarta hbarta   2392 Feb  6 13:51 2025-02-06-1351.trim_snaps.3.txt
-rw-r--r-- 1 hbarta hbarta 445641 Feb  6 13:51 2025-02-06-1351.stir_pools.50.txt
-rw-r--r-- 1 hbarta hbarta   7159 Feb  6 13:52 2025-02-06-1350.syncoid.98.txt              <<< first file reporting corruption
-rw-r--r-- 1 hbarta hbarta 437985 Feb  6 13:52 2025-02-06-1352.stir_pools.48.txt
-rw-r--r-- 1 hbarta hbarta   2392 Feb  6 13:52 2025-02-06-1352.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta 441649 Feb  6 13:53 2025-02-06-1352.stir_pools.47.txt
-rw-r--r-- 1 hbarta hbarta   2392 Feb  6 13:53 2025-02-06-1353.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta   7679 Feb  6 13:54 2025-02-06-1352.syncoid.102.txt
-rw-r--r-- 1 hbarta hbarta 447684 Feb  6 13:54 2025-02-06-1353.stir_pools.47.txt
-rw-r--r-- 1 hbarta hbarta   2393 Feb  6 13:54 2025-02-06-1354.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta 445480 Feb  6 13:55 2025-02-06-1354.stir_pools.45.txt
-rw-r--r-- 1 hbarta hbarta 448586 Feb  6 13:55 2025-02-06-1355.stir_pools.45.txt
-rw-r--r-- 1 hbarta hbarta   2393 Feb  6 13:55 2025-02-06-1355.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta   7623 Feb  6 13:56 2025-02-06-1354.syncoid.106.txt
-rw-r--r-- 1 hbarta hbarta 445377 Feb  6 13:56 2025-02-06-1355.stir_pools.43.txt
-rw-r--r-- 1 hbarta hbarta   2393 Feb  6 13:57 2025-02-06-1356.trim_snaps.3.txt
-rw-r--r-- 1 hbarta hbarta 443424 Feb  6 13:57 2025-02-06-1356.stir_pools.43.txt
-rw-r--r-- 1 hbarta hbarta   7600 Feb  6 13:57 2025-02-06-1356.syncoid.113.txt
-rw-r--r-- 1 hbarta hbarta   2393 Feb  6 13:58 2025-02-06-1358.trim_snaps.3.txt
-rw-r--r-- 1 hbarta hbarta 446579 Feb  6 13:58 2025-02-06-1357.stir_pools.44.txt
-rw-r--r-- 1 hbarta hbarta 446034 Feb  6 13:58 2025-02-06-1358.stir_pools.41.txt
-rw-r--r-- 1 hbarta hbarta   2393 Feb  6 13:59 2025-02-06-1359.trim_snaps.3.txt
-rw-r--r-- 1 hbarta hbarta 448344 Feb  6 13:59 2025-02-06-1358.stir_pools.43.txt
-rw-r--r-- 1 hbarta hbarta   7600 Feb  6 13:59 2025-02-06-1357.syncoid.121.txt
-rw-r--r-- 1 hbarta hbarta   2393 Feb  6 14:00 2025-02-06-1400.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta 443646 Feb  6 14:00 2025-02-06-1359.stir_pools.43.txt
-rw-r--r-- 1 hbarta hbarta 445132 Feb  6 14:00 2025-02-06-1400.stir_pools.41.txt
-rw-r--r-- 1 hbarta hbarta   2393 Feb  6 14:01 2025-02-06-1401.trim_snaps.2.txt
-rw-r--r-- 1 hbarta hbarta 443758 Feb  6 14:01 2025-02-06-1400.stir_pools.42.txt
-rw-r--r-- 1 hbarta hbarta   7600 Feb  6 14:02 2025-02-06-1359.syncoid.126.txt
-rw-r--r-- 1 hbarta hbarta   2393 Feb  6 14:02 2025-02-06-1402.trim_snaps.3.txt
-rw-r--r-- 1 hbarta hbarta 439579 Feb  6 14:02 2025-02-06-1401.stir_pools.43.txt
-rw-r--r-- 1 hbarta hbarta 445485 Feb  6 14:03 2025-02-06-1402.stir_pools.42.txt
-rw-r--r-- 1 hbarta hbarta   2393 Feb  6 14:03 2025-02-06-1403.trim_snaps.4.txt
-rw-r--r-- 1 hbarta hbarta 446867 Feb  6 14:03 2025-02-06-1403.stir_pools.43.txt
-rw-r--r-- 1 hbarta hbarta   7600 Feb  6 14:04 2025-02-06-1402.syncoid.120.txt
-rw-r--r-- 1 hbarta hbarta   2393 Feb  6 14:04 2025-02-06-1404.trim_snaps.3.txt
-rw-r--r-- 1 hbarta hbarta 445627 Feb  6 14:04 2025-02-06-1403.stir_pools.42.txt
-rw-r--r-- 1 hbarta hbarta 445590 Feb  6 14:05 2025-02-06-1404.stir_pools.42.txt
-rw-r--r-- 1 hbarta hbarta   2393 Feb  6 14:05 2025-02-06-1405.trim_snaps.3.txt
-rw-r--r-- 1 hbarta hbarta 449458 Feb  6 14:05 2025-02-06-1405.stir_pools.43.txt
-rw-r--r-- 1 hbarta hbarta   7600 Feb  6 14:06 2025-02-06-1404.syncoid.122.txt
-rw-r--r-- 1 hbarta hbarta   2393 Feb  6 14:06 2025-02-06-1406.trim_snaps.4.txt
-rw-r--r-- 1 hbarta hbarta 447554 Feb  6 14:06 2025-02-06-1405.stir_pools.44.txt
-rw-r--r-- 1 hbarta hbarta 441876 Feb  6 14:07 2025-02-06-1406.stir_pools.41.txt
-rw-r--r-- 1 hbarta hbarta   2393 Feb  6 14:07 2025-02-06-1407.trim_snaps.3.txt
-rw-r--r-- 1 hbarta hbarta 446256 Feb  6 14:08 2025-02-06-1407.stir_pools.43.txt
-rw-r--r-- 1 hbarta hbarta   7600 Feb  6 14:08 2025-02-06-1406.syncoid.124.txt
-rw-r--r-- 1 hbarta hbarta   2393 Feb  6 14:08 2025-02-06-1408.trim_snaps.4.txt
-rw-r--r-- 1 hbarta hbarta 441551 Feb  6 14:08 2025-02-06-1408.stir_pools.42.txt
-rw-r--r-- 1 hbarta hbarta 446465 Feb  6 14:09 2025-02-06-1408.stir_pools.41.txt
-rw-r--r-- 1 hbarta hbarta   2393 Feb  6 14:09 2025-02-06-1409.trim_snaps.3.txt
-rw-r--r-- 1 hbarta hbarta   7600 Feb  6 14:10 2025-02-06-1408.syncoid.120.txt
-rw-r--r-- 1 hbarta hbarta 446586 Feb  6 14:10 2025-02-06-1409.stir_pools.43.txt
-rw-r--r-- 1 hbarta hbarta   2393 Feb  6 14:10 2025-02-06-1410.trim_snaps.3.txt
-rw-r--r-- 1 hbarta hbarta 449031 Feb  6 14:10 2025-02-06-1410.stir_pools.41.txt
-rw-r--r-- 1 hbarta hbarta 446752 Feb  6 14:11 2025-02-06-1410.stir_pools.43.txt
-rw-r--r-- 1 hbarta hbarta   2393 Feb  6 14:11 2025-02-06-1411.trim_snaps.4.txt
-rw-r--r-- 1 hbarta hbarta   7600 Feb  6 14:12 2025-02-06-1410.syncoid.116.txt
-rw-r--r-- 1 hbarta hbarta 444533 Feb  6 14:12 2025-02-06-1411.stir_pools.44.txt
-rw-r--r-- 1 hbarta hbarta   2631 Feb  6 14:12 2025-02-06-1412.trim_snaps.4.txt
-rw-r--r-- 1 hbarta hbarta 445935 Feb  6 14:13 2025-02-06-1412.stir_pools.43.txt
-rw-r--r-- 1 hbarta hbarta 449100 Feb  6 14:13 2025-02-06-1413.stir_pools.44.txt
-rw-r--r-- 1 hbarta hbarta   2692 Feb  6 14:13 2025-02-06-1413.trim_snaps.4.txt
-rw-r--r-- 1 hbarta hbarta   7600 Feb  6 14:13 2025-02-06-1412.syncoid.111.txt
-rw-r--r-- 1 hbarta hbarta 436750 Feb  6 14:14 2025-02-06-1413.stir_pools.42.txt
-rw-r--r-- 1 hbarta hbarta   2753 Feb  6 14:14 2025-02-06-1414.trim_snaps.5.txt
-rw-r--r-- 1 hbarta hbarta 448718 Feb  6 14:15 2025-02-06-1414.stir_pools.43.txt
-rw-r--r-- 1 hbarta hbarta   7600 Feb  6 14:15 2025-02-06-1413.syncoid.120.txt
-rw-r--r-- 1 hbarta hbarta   2692 Feb  6 14:16 2025-02-06-1415.trim_snaps.4.txt
-rw-r--r-- 1 hbarta hbarta 448832 Feb  6 14:16 2025-02-06-1415.stir_pools.43.txt
-rw-r--r-- 1 hbarta hbarta   2692 Feb  6 14:17 2025-02-06-1417.trim_snaps.5.txt
-rw-r--r-- 1 hbarta hbarta 447915 Feb  6 14:17 2025-02-06-1416.stir_pools.44.txt
-rw-r--r-- 1 hbarta hbarta   7600 Feb  6 14:18 2025-02-06-1416.syncoid.123.txt
-rw-r--r-- 1 hbarta hbarta 449796 Feb  6 14:18 2025-02-06-1417.stir_pools.44.txt
-rw-r--r-- 1 hbarta hbarta   7126 Feb  6 14:18 2025-02-06-1418.trim_snaps.14.txt
-rw-r--r-- 1 hbarta hbarta 450277 Feb  6 14:18 2025-02-06-1418.stir_pools.44.txt
-rw-r--r-- 1 hbarta hbarta   4896 Feb  6 14:19 2025-02-06-1419.trim_snaps.12.txt
-rw-r--r-- 1 hbarta hbarta 446833 Feb  6 14:19 2025-02-06-1418.stir_pools.45.txt
-rw-r--r-- 1 hbarta hbarta   7600 Feb  6 14:20 2025-02-06-1418.syncoid.119.txt
-rw-r--r-- 1 hbarta hbarta 454262 Feb  6 14:20 2025-02-06-1419.stir_pools.45.txt
-rw-r--r-- 1 hbarta hbarta   9550 Feb  6 14:20 2025-02-06-1420.trim_snaps.17.txt
-rw-r--r-- 1 hbarta hbarta 447498 Feb  6 14:21 2025-02-06-1420.stir_pools.45.txt
-rw-r--r-- 1 hbarta hbarta   7600 Feb  6 14:21 2025-02-06-1420.syncoid.117.txt
-rw-r--r-- 1 hbarta hbarta   6950 Feb  6 14:22 2025-02-06-1421.trim_snaps.13.txt
-rw-r--r-- 1 hbarta hbarta 448079 Feb  6 14:22 2025-02-06-1421.stir_pools.45.txt
-rw-r--r-- 1 hbarta hbarta   7404 Feb  6 14:23 2025-02-06-1423.trim_snaps.14.txt
-rw-r--r-- 1 hbarta hbarta 441012 Feb  6 14:23 2025-02-06-1422.stir_pools.45.txt
-rw-r--r-- 1 hbarta hbarta   7601 Feb  6 14:24 2025-02-06-1422.syncoid.120.txt
-rw-r--r-- 1 hbarta hbarta 445051 Feb  6 14:24 2025-02-06-1423.stir_pools.45.txt
-rw-r--r-- 1 hbarta hbarta    470 Feb  6 14:24 2025-02-06-1424.trim_snaps.1.txt
-rw-r--r-- 1 hbarta hbarta   2769 Feb  6 14:24 2025-02-06-1424.syncoid.31.txt
-rw-r--r-- 1 hbarta hbarta 284628 Feb  6 14:24 2025-02-06-1424.stir_pools.28.txt
hbarta@orcus:~/logs$ 
```
