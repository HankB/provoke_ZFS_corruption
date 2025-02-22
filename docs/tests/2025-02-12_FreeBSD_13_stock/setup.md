

```text
zfs allow -u hbarta \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    send
zfs allow -u hbarta \
    compression,create,destroy,hold,mount,mountpoint,receive,send,snapshot,destroy,rollback \
    recv
```

## 2025-02-13 start thrashing

Running in seperate (`tmux`) windows.

* `cd`
* `ln provoke_ZFS_corruption/scripts/*.sh bin/`
* `mkdir logs`
* `tmux new -s stir` and `thrash_stir.sh`
* `tmux new -s syncoid` and `thrash_syncoid.sh`
* `tmux new -s snaps` and `manage_snaps.sh` (After tweaking to manage both pools)
