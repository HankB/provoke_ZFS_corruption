# Bisect 0.8.6 to 2.0.0 on Debian Buster running a user built 5.9.16 kernel

And will re-clone the Github repo to insure a clean slate. Insuring that ZFS is not installed:

```text
hbarta@orion:~$ zfs
-bash: zfs: command not found
hbarta@orion:~$ find /lib|grep zfs
hbarta@orion:~$ 
```

Starting points for bisecting.

* <https://github.com/openzfs/zfs/releases/tag/zfs-2.0.0> hash `dcbf847`
* <https://github.com/openzfs/zfs/releases/tag/zfs-0.8.6> hash `2bc6689`

Note: 0.8.6 released 2020-12-14 and 2.0.0 released prior on 2020-11-20.

## 2025-03-06 clone and build ZFS

Before starting bisect, verify that 0.8.6 and 2.0.0 can build.

Following instructions at <https://openzfs.github.io/openzfs-docs/Developer%20Resources/Building%20ZFS.html>

```text
git clone https://github.com/openzfs/zfs
cd zfs
git checkout master
git checkout 2bc6689
```

```text
hbarta@orion:~/zfs$ git checkout 2bc6689
Note: checking out '2bc6689'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b <new-branch-name>

HEAD is now at 2bc66898b Tag zfs-0.8.6
hbarta@orion:~/zfs$ 
```

```text
sh autogen.sh
./configure
make -s -j$(nproc)
```

`autogen.sh` and `configure` scripts complete w/out errors or warnings and `make` likewise completes. 

Now to build 2.0.0.

```text
make clean
git checkout dcbf847
```

```text
hbarta@orion:~/zfs$ git checkout dcbf847
Previous HEAD position was 2bc66898b Tag zfs-0.8.6
HEAD is now at dcbf84749 Tag 2.0.0
hbarta@orion:~/zfs$ 
```

```text
sh autogen.sh
./configure

```

The scripts complete w/out error and the make fails with

```text
Making all in libzfs
...
make[3]: *** No rule to make target '../../module/zfs/cityhash.c', needed by 'cityhash.lo'.  Stop.
make[3]: *** Waiting for unfinished jobs....
  CC       bqueue.lo
make[2]: *** [Makefile:678: all-recursive] Error 1
make[1]: *** [Makefile:883: all-recursive] Error 1
make: *** [Makefile:744: all] Error 2
hbarta@orion:~/zfs$ find . -name cityhash.c
./module/zcommon/cityhash.c
hbarta@orion:~/zfs$ 
```

From <https://github.com/openzfs/zfs/issues/10907>

```text
make distclean
sh autogen.sh
./configure
make -s -j$(nproc)
```

And the build completed.

## 2025-03-06 start bisect

```text
hbarta@orion:~/zfs$ git bisect start
hbarta@orion:~/zfs$ git bisect good 2bc6689
hbarta@orion:~/zfs$ git bisect bad dcbf847
Bisecting: a merge base must be tested
[78fac8d925fdd64584292fbda4ed9e3e2bbaae66] Fix kstat state update during pool transition
hbarta@orion:~/zfs$
```

`autogen.sh` completed w/out errors. `configure` threw

```text
checking whether set_fs_pwd() requires const struct path *... configure: error: unknown
```

Fix possibly from <https://github.com/openzfs/zfs/issues/8799>

```text
KBUILD_MODPOST_WARN=1 ./configure
```

Now throwing:

```text
checking whether make_request_fn() returns blk_qc_t... configure: error: no - Please file a bug report at
                                    https://github.com/zfsonlinux/zfs/issues/new
hbarta@orion:~/zfs$
```

## 2025-03-06 set aside

Unable to build ZFS and 5.9 is likely not a good choice for building older releases. Returning to 4.19.
