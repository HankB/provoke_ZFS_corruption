# Results: Git bisect 0.8.6 to 2.0.0 - testing 0.8.6

* [Setup](./setup.md)
* [Data](./data.md)

## 2025-02-02 test start

Thrashing began about 2020 local time.

## 2025-02-02 test concluding

At 0800 the following morning no corruption had been detected (as expected.) Previous testing with this same setup went much longer with no corruption so this test will be comncluded. Monitor output is:

```text
hbarta@orion:~$ monitor.sh 
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
recv   464G   308G   156G        -         -    45%    66%  1.00x    ONLINE  -
send   464G   329G   135G        -         -    54%    70%  1.00x    ONLINE  -

send snapshot count
3177

recv snapshot count
3107
hbarta@orion:~$ 
```
