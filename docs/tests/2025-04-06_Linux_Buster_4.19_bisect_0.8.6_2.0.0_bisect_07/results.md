# Results: Git bisect 0.8.6 to 2.0.0 - testing sixth bisect

* [Data](./data.md)
* [Setup](./setup.md)

No curruption after 11 1/2 hours.

`monitor.sh` output.

```text
hbarta@orion:~/logs$ monitor.sh
status
  pool: recv
 state: ONLINE
  scan: none requested
config:

        NAME                      STATE     READ WRITE CKSUM
        recv                      ONLINE       0     0     0
          wwn-0x5002538d40878f8e  ONLINE       0     0     0

errors: No known data errors

  pool: send
 state: ONLINE
  scan: none requested
config:

        NAME                      STATE     READ WRITE CKSUM
        send                      ONLINE       0     0     0
          wwn-0x5002538d41628a33  ONLINE       0     0     0

errors: No known data errors

list

NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   308G   156G        -         -    41%    66%  1.00x    ONLINE  -
send   464G   325G   139G        -         -    53%    70%  1.00x    ONLINE  -

send snapshot count
3201

recv snapshot count
3079
hbarta@orion:~/logs$ 
```
