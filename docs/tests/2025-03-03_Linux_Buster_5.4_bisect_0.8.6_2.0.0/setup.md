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

Tried suggestion to modify `config/kernel.m4` and did not fix. Fix at ... helps `.configure` succeed.

```text
KBUILD_MODPOST_WARN=1 ./configure
```

## 2025-03-05 

Notes above are a bit scattershot. I was thrashing trying to figure out how to build older versions on ZFS and realized that I had inadvertently built and was using the 5.4.0 kernel which seems not wise. Now stepping back to build the 5.9.16 kernel.
