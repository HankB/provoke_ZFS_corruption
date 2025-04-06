# Results: Git bisect 0.8.6 to 2.0.0 - testing sixth bisect

* [Data](./data.md)
* [Results](./results.md)

## 2025-04-06 no corruption

No corruption after over 12 hours of thrashing and 313 complete sanoid runs. Status is

```text
hbarta@orion:~/logs$ zpool status send
  pool: send
 state: ONLINE
  scan: none requested
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: No known data errors
hbarta@orion:~/logs$ ls *syncoid*|wc -l
314
hbarta@orion:~/logs$ zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   311G   153G        -         -    44%    67%  1.00x    ONLINE  -
send   464G   328G   136G        -         -    52%    70%  1.00x    ONLINE  -
hbarta@orion:~/logs$ 
```

[Complete `sanoid` output](./data.md)
