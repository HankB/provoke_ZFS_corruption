# 2025-02-11 Setup

[Results](./results.md)
[Data](./data.md)

Purpose: Repeat the test from [2025-02-05 methodology](./../2025-02-05_methodology/setup.md) following modificatin of scripts to work on FreeBSD to see if they still work on Linux. Secondarily, test to see if the "corruption in 15 minutes" was a fluke or is typical.

## 2025-02-11 Plan

Refer to the previous iteration for specifics. This is just a repeat of that.

Time to complete first sync:

```text
real 3468.47
user 42.80
sys 2188.07
root@orcus:~#
```

Second `syncoid` took 20s. All looks good. Kicking off in separate terminals.

```text
thrash_stir.sh
thrash_syncoid.sh
manage_snaps.sh
```

Testing in full at 1525. `top` shows I/O wait at 2.5 t0 4.6%, idle over 72%. Test finished with corruption at 1727. Not as good as 15 minutes previously but still reasonable.
