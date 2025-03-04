# Built

```text
hbarta@orion:~/zfs$ git bisect reset
Previous HEAD position was 78fac8d92 Fix kstat state update during pool transition
HEAD is now at d2632f0cc Tag zfs-0.8.5
hbarta@orion:~/zfs$ git bisect start
hbarta@orion:~/zfs$ git bisect good 2bc6689
hbarta@orion:~/zfs$ git bisect bad dcbf847
Bisecting: a merge base must be tested
[78fac8d925fdd64584292fbda4ed9e3e2bbaae66] Fix kstat state update during pool transition
hbarta@orion:~/zfs$
```

```text
./configure
...
checking whether set_fs_pwd() requires const struct path *... configure: error: unknown
```
