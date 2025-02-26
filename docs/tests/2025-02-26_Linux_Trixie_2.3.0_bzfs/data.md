# data

[Setup](./setup.md)

## 2025-02-26 first bzfs excecution

```text
root@orion:~# time -p /home/hbarta/bin/bzfs --recursive send/test recv/test
2025-02-26 12:53:35 [I] Log file is: /root/bzfs-logs/2025-02-26/zrun_2025-02-26_12:53:35-o9dqje5z.log
2025-02-26 12:53:35 [I] CLI arguments:                /home/hbarta/bin/bzfs --recursive send/test recv/test [euid: 0]
2025-02-26 12:53:35 [I] Starting replication task:    send/test -r --> recv/test ... [31 datasets]                                                
2025-02-26 12:53:36 [I] 1/31 Already up-to-date:      recv/test                                                                                   
cannot open 'recv/test/l0_1': dataset does not exist                                                                                              
cannot open 'recv/test/l0_0': dataset does not exist                                                                                              
2025-02-26 12:53:36 [I] 3/31 Full send:               send/test/l0_1@2025-02-26-1252 --> recv/test/l0_1 (7.74GiB) ...                             
2025-02-26 12:53:36 [I] 2/31 Full send:               send/test/l0_0@2025-02-26-1252 --> recv/test/l0_0 (7.6GiB) ...                              
cannot open 'recv/test/l0_0/l1_0': dataset does not exist                                                                                         
cannot open 'recv/test/l0_0/l1_2': dataset does not exist                                                                                         
cannot open 'recv/test/l0_0/l1_1': dataset does not exist                                                                                         
cannot open 'recv/test/l0_0/l1_3': dataset does not exist                                                                                         
2025-02-26 12:54:18 [I] 5/31 Full send:               send/test/l0_0/l1_1@2025-02-26-1252 --> recv/test/l0_0/l1_1 (8.22GiB) ...                   
2025-02-26 12:54:18 [I] 4/31 Full send:               send/test/l0_0/l1_0@2025-02-26-1252 --> recv/test/l0_0/l1_0 (8.14GiB) ...                   
2025-02-26 12:54:18 [I] 6/31 Full send:               send/test/l0_0/l1_2@2025-02-26-1252 --> recv/test/l0_0/l1_2 (8.13GiB) ...                   
2025-02-26 12:54:18 [I] 7/31 Full send:               send/test/l0_0/l1_3@2025-02-26-1252 --> recv/test/l0_0/l1_3 (7.98GiB) ...                   
cannot open 'recv/test/l0_1/l1_0': dataset does not exist                                                                                         
cannot open 'recv/test/l0_1/l1_1': dataset does not exist                                                                                         
2025-02-26 12:54:18 [I] 9/31 Full send:               send/test/l0_1/l1_1@2025-02-26-1252 --> recv/test/l0_1/l1_1 (8.03GiB) ...                   
2025-02-26 12:54:18 [I] 8/31 Full send:               send/test/l0_1/l1_0@2025-02-26-1252 --> recv/test/l0_1/l1_0 (8.07GiB) ...                   
cannot open 'recv/test/l0_0/l1_3/l2_3': dataset does not exist                                                                                    
cannot open 'recv/test/l0_0/l1_3/l2_0': dataset does not exist                                                                                    
cannot open 'recv/test/l0_0/l1_3/l2_2': dataset does not exist                                                                                    
cannot open 'recv/test/l0_0/l1_3/l2_1': dataset does not exist                                                                                    
2025-02-26 12:56:04 [I] 10/31 Full send:              send/test/l0_0/l1_3/l2_0@2025-02-26-1252 --> recv/test/l0_0/l1_3/l2_0 (8.18GiB) ...         
2025-02-26 12:56:04 [I] 12/31 Full send:              send/test/l0_0/l1_3/l2_2@2025-02-26-1252 --> recv/test/l0_0/l1_3/l2_2 (8.15GiB) ...         
2025-02-26 12:56:04 [I] 13/31 Full send:              send/test/l0_0/l1_3/l2_3@2025-02-26-1252 --> recv/test/l0_0/l1_3/l2_3 (8GiB) ...            
2025-02-26 12:56:04 [I] 11/31 Full send:              send/test/l0_0/l1_3/l2_1@2025-02-26-1252 --> recv/test/l0_0/l1_3/l2_1 (7.71GiB) ...         
cannot open 'recv/test/l0_0/l1_2/l2_2': dataset does not exist                                                                                    
cannot open 'recv/test/l0_0/l1_2/l2_3': dataset does not exist                                                                                    
cannot open 'recv/test/l0_0/l1_2/l2_1': dataset does not exist                                                                                    
cannot open 'recv/test/l0_0/l1_2/l2_0': dataset does not exist                                                                                    
2025-02-26 12:56:06 [I] 14/31 Full send:              send/test/l0_0/l1_2/l2_0@2025-02-26-1252 --> recv/test/l0_0/l1_2/l2_0 (7.86GiB) ...         
2025-02-26 12:56:06 [I] 16/31 Full send:              send/test/l0_0/l1_2/l2_2@2025-02-26-1252 --> recv/test/l0_0/l1_2/l2_2 (7.97GiB) ...         
2025-02-26 12:56:06 [I] 17/31 Full send:              send/test/l0_0/l1_2/l2_3@2025-02-26-1252 --> recv/test/l0_0/l1_2/l2_3 (7.86GiB) ...         
2025-02-26 12:56:06 [I] 15/31 Full send:              send/test/l0_0/l1_2/l2_1@2025-02-26-1252 --> recv/test/l0_0/l1_2/l2_1 (8.06GiB) ...         
cannot open 'recv/test/l0_1/l1_0/l2_2': dataset does not exist                                                                                    
cannot open 'recv/test/l0_1/l1_0/l2_0': dataset does not exist                                                                                    
cannot open 'recv/test/l0_1/l1_0/l2_3': dataset does not exist                                                                                    
cannot open 'recv/test/l0_1/l1_0/l2_1': dataset does not exist                                                                                    
2025-02-26 12:56:07 [I] 21/31 Full send:              send/test/l0_1/l1_0/l2_3@2025-02-26-1252 --> recv/test/l0_1/l1_0/l2_3 (7.66GiB) ...         
cannot open 'recv/test/l0_0/l1_0/l2_1': dataset does not exist                                                                                    
cannot open 'recv/test/l0_0/l1_0/l2_0': dataset does not exist                                                                                    
2025-02-26 12:56:07 [I] 19/31 Full send:              send/test/l0_1/l1_0/l2_1@2025-02-26-1252 --> recv/test/l0_1/l1_0/l2_1 (7.72GiB) ...         
2025-02-26 12:56:07 [I] 20/31 Full send:              send/test/l0_1/l1_0/l2_2@2025-02-26-1252 --> recv/test/l0_1/l1_0/l2_2 (7.88GiB) ...         
2025-02-26 12:56:07 [I] 18/31 Full send:              send/test/l0_1/l1_0/l2_0@2025-02-26-1252 --> recv/test/l0_1/l1_0/l2_0 (7.83GiB) ...         
2025-02-26 12:56:07 [I] 22/31 Full send:              send/test/l0_0/l1_0/l2_0@2025-02-26-1252 --> recv/test/l0_0/l1_0/l2_0 (7.79GiB) ...         
2025-02-26 12:56:07 [I] 23/31 Full send:              send/test/l0_0/l1_0/l2_1@2025-02-26-1252 --> recv/test/l0_0/l1_0/l2_1 (7.65GiB) ...         
cannot open 'recv/test/l0_0/l1_0/l2_2': dataset does not exist                                                                                    
2025-02-26 12:56:08 [I] 24/31 Full send:              send/test/l0_0/l1_0/l2_2@2025-02-26-1252 --> recv/test/l0_0/l1_0/l2_2 (7.68GiB) ...         
cannot open 'recv/test/l0_0/l1_0/l2_3': dataset does not exist                                                                                    
2025-02-26 12:56:08 [I] 25/31 Full send:              send/test/l0_0/l1_0/l2_3@2025-02-26-1252 --> recv/test/l0_0/l1_0/l2_3 (8.06GiB) ...         
2025-02-26 12:58:15 [E] ERROR: ProgressReporter::39 [457.05 MiB/s] [441.49 MiB/s] [=========>             ]  44% ETA 0:03:24 FIN 13:01:39
Traceback (most recent call last):
  File "/home/hbarta/bin/bzfs", line 5080, in _run
    self._run_internal(fds, selector)
    ~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^
  File "/home/hbarta/bin/bzfs", line 5154, in _run_internal
    sent_bytes += self.update_transfer_stat(line, s, curr_time_nanos)
                  ~~~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/hbarta/bin/bzfs", line 5186, in update_transfer_stat
    num_bytes, s.eta.timestamp_nanos, s.eta.line_tail = self.parse_pv_line(line, curr_time_nanos)
                                                        ~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/hbarta/bin/bzfs", line 5200, in parse_pv_line
    sent_bytes, line = pv_size_to_bytes(line)
                       ~~~~~~~~~~~~~~~~^^^^^^
  File "/home/hbarta/bin/bzfs", line 5900, in pv_size_to_bytes
    raise ValueError("Invalid pv_size: " + size)
ValueError: Invalid pv_size: 48

cannot open 'recv/test/l0_0/l1_1/l2_0': dataset does not exist                                                                                    
2025-02-26 13:00:41 [I] 26/31 Full send:              send/test/l0_0/l1_1/l2_0@2025-02-26-1252 --> recv/test/l0_0/l1_1/l2_0 (7.87GiB) ...         
cannot open 'recv/test/l0_0/l1_1/l2_1': dataset does not exist                                                                                    
2025-02-26 13:00:41 [I] 27/31 Full send:              send/test/l0_0/l1_1/l2_1@2025-02-26-1252 --> recv/test/l0_0/l1_1/l2_1 (7.94GiB) ...         
cannot open 'recv/test/l0_0/l1_1/l2_2': dataset does not exist                                                                                    
2025-02-26 13:00:44 [I] 28/31 Full send:              send/test/l0_0/l1_1/l2_2@2025-02-26-1252 --> recv/test/l0_0/l1_1/l2_2 (7.8GiB) ...          
cannot open 'recv/test/l0_0/l1_1/l2_3': dataset does not exist                                                                                    
2025-02-26 13:00:45 [I] 29/31 Full send:              send/test/l0_0/l1_1/l2_3@2025-02-26-1252 --> recv/test/l0_0/l1_1/l2_3 (7.78GiB) ...         
cannot open 'recv/test/l0_1/l1_1/l2_0': dataset does not exist                                                                                    
2025-02-26 13:00:48 [I] 30/31 Full send:              send/test/l0_1/l1_1/l2_0@2025-02-26-1252 --> recv/test/l0_1/l1_1/l2_0 (8.03GiB) ...         
cannot open 'recv/test/l0_1/l1_1/l2_1': dataset does not exist                                                                                    
2025-02-26 13:00:49 [I] 31/31 Full send:              send/test/l0_1/l1_1/l2_1@2025-02-26-1252 --> recv/test/l0_1/l1_1/l2_1 (7.83GiB) ...         
2025-02-26 13:02:39 [I] Replication done:             send/test -r --> recv/test ... [Replicated 30 out of 31 snapshots within 31 datasets; took 9.05 m]
2025-02-26 13:02:39 [I] Log file was: /root/bzfs-logs/2025-02-26/zrun_2025-02-26_12:53:35-o9dqje5z.log                                            
Traceback (most recent call last):
  File "/home/hbarta/bin/bzfs", line 6908, in <module>
    main()
    ~~~~^^
  File "/home/hbarta/bin/bzfs", line 1971, in main
    run_main(argument_parser().parse_args(), sys.argv)
    ~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/hbarta/bin/bzfs", line 1978, in run_main
    Job().run_main(args, sys_argv, log)
    ~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^
  File "/home/hbarta/bin/bzfs", line 2070, in run_main
    raise e
  File "/home/hbarta/bin/bzfs", line 2067, in run_main
    self.run_tasks()
    ~~~~~~~~~~~~~~^^
  File "/home/hbarta/bin/bzfs", line 2121, in run_tasks
    self.progress_reporter.stop()
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~^^
  File "/home/hbarta/bin/bzfs", line 5057, in stop
    raise e  # reraise exception in current thread
    ^^^^^^^
  File "/home/hbarta/bin/bzfs", line 5080, in _run
    self._run_internal(fds, selector)
    ~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^
  File "/home/hbarta/bin/bzfs", line 5154, in _run_internal
    sent_bytes += self.update_transfer_stat(line, s, curr_time_nanos)
                  ~~~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/hbarta/bin/bzfs", line 5186, in update_transfer_stat
    num_bytes, s.eta.timestamp_nanos, s.eta.line_tail = self.parse_pv_line(line, curr_time_nanos)
                                                        ~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^
  File "/home/hbarta/bin/bzfs", line 5200, in parse_pv_line
    sent_bytes, line = pv_size_to_bytes(line)
                       ~~~~~~~~~~~~~~~~^^^^^^
  File "/home/hbarta/bin/bzfs", line 5900, in pv_size_to_bytes
    raise ValueError("Invalid pv_size: " + size)
ValueError: Invalid pv_size: 48
real 543.38
user 77.09
sys 2182.14
root@orion:~# 
```

## 2025-02-26 results

```text
root@orion:~# zfs list -t snap -r send
NAME                                       USED  AVAIL  REFER  MOUNTPOINT
send@2025-02-26-1252                         0B      -   200K  -
send/test@2025-02-26-1252                    0B      -   240K  -
send/test/l0_0@2025-02-26-1252               0B      -  7.59G  -
send/test/l0_0/l1_0@2025-02-26-1252          0B      -  8.13G  -
send/test/l0_0/l1_0/l2_0@2025-02-26-1252     0B      -  7.78G  -
send/test/l0_0/l1_0/l2_1@2025-02-26-1252     0B      -  7.64G  -
send/test/l0_0/l1_0/l2_2@2025-02-26-1252     0B      -  7.67G  -
send/test/l0_0/l1_0/l2_3@2025-02-26-1252     0B      -  8.05G  -
send/test/l0_0/l1_1@2025-02-26-1252          0B      -  8.21G  -
send/test/l0_0/l1_1/l2_0@2025-02-26-1252     0B      -  7.86G  -
send/test/l0_0/l1_1/l2_1@2025-02-26-1252     0B      -  7.93G  -
send/test/l0_0/l1_1/l2_2@2025-02-26-1252     0B      -  7.79G  -
send/test/l0_0/l1_1/l2_3@2025-02-26-1252     0B      -  7.77G  -
send/test/l0_0/l1_2@2025-02-26-1252          0B      -  8.12G  -
send/test/l0_0/l1_2/l2_0@2025-02-26-1252     0B      -  7.86G  -
send/test/l0_0/l1_2/l2_1@2025-02-26-1252     0B      -  8.05G  -
send/test/l0_0/l1_2/l2_2@2025-02-26-1252     0B      -  7.96G  -
send/test/l0_0/l1_2/l2_3@2025-02-26-1252     0B      -  7.85G  -
send/test/l0_0/l1_3@2025-02-26-1252          0B      -  7.97G  -
send/test/l0_0/l1_3/l2_0@2025-02-26-1252     0B      -  8.18G  -
send/test/l0_0/l1_3/l2_1@2025-02-26-1252     0B      -  7.70G  -
send/test/l0_0/l1_3/l2_2@2025-02-26-1252     0B      -  8.14G  -
send/test/l0_0/l1_3/l2_3@2025-02-26-1252     0B      -  7.99G  -
send/test/l0_1@2025-02-26-1252               0B      -  7.73G  -
send/test/l0_1/l1_0@2025-02-26-1252          0B      -  8.06G  -
send/test/l0_1/l1_0/l2_0@2025-02-26-1252     0B      -  7.82G  -
send/test/l0_1/l1_0/l2_1@2025-02-26-1252     0B      -  7.71G  -
send/test/l0_1/l1_0/l2_2@2025-02-26-1252     0B      -  7.87G  -
send/test/l0_1/l1_0/l2_3@2025-02-26-1252     0B      -  7.65G  -
send/test/l0_1/l1_1@2025-02-26-1252          0B      -  8.02G  -
send/test/l0_1/l1_1/l2_0@2025-02-26-1252     0B      -  8.02G  -
send/test/l0_1/l1_1/l2_1@2025-02-26-1252     0B      -  7.82G  -
root@orion:~# zfs list -t snap -r recv
NAME                                       USED  AVAIL  REFER  MOUNTPOINT
recv/test@2025-02-26-1252                    0B      -   216K  -
recv/test/l0_0@2025-02-26-1252               0B      -  7.59G  -
recv/test/l0_0/l1_0@2025-02-26-1252          0B      -  8.13G  -
recv/test/l0_0/l1_0/l2_0@2025-02-26-1252     0B      -  7.78G  -
recv/test/l0_0/l1_0/l2_1@2025-02-26-1252     0B      -  7.64G  -
recv/test/l0_0/l1_0/l2_2@2025-02-26-1252     0B      -  7.67G  -
recv/test/l0_0/l1_0/l2_3@2025-02-26-1252     0B      -  8.05G  -
recv/test/l0_0/l1_1@2025-02-26-1252          0B      -  8.21G  -
recv/test/l0_0/l1_1/l2_0@2025-02-26-1252     0B      -  7.86G  -
recv/test/l0_0/l1_1/l2_1@2025-02-26-1252     0B      -  7.93G  -
recv/test/l0_0/l1_1/l2_2@2025-02-26-1252     0B      -  7.79G  -
recv/test/l0_0/l1_1/l2_3@2025-02-26-1252     0B      -  7.77G  -
recv/test/l0_0/l1_2@2025-02-26-1252          0B      -  8.12G  -
recv/test/l0_0/l1_2/l2_0@2025-02-26-1252     0B      -  7.86G  -
recv/test/l0_0/l1_2/l2_1@2025-02-26-1252     0B      -  8.05G  -
recv/test/l0_0/l1_2/l2_2@2025-02-26-1252     0B      -  7.96G  -
recv/test/l0_0/l1_2/l2_3@2025-02-26-1252     0B      -  7.85G  -
recv/test/l0_0/l1_3@2025-02-26-1252          0B      -  7.97G  -
recv/test/l0_0/l1_3/l2_0@2025-02-26-1252     0B      -  8.18G  -
recv/test/l0_0/l1_3/l2_1@2025-02-26-1252     0B      -  7.70G  -
recv/test/l0_0/l1_3/l2_2@2025-02-26-1252     0B      -  8.14G  -
recv/test/l0_0/l1_3/l2_3@2025-02-26-1252     0B      -  7.99G  -
recv/test/l0_1@2025-02-26-1252               0B      -  7.73G  -
recv/test/l0_1/l1_0@2025-02-26-1252          0B      -  8.06G  -
recv/test/l0_1/l1_0/l2_0@2025-02-26-1252     0B      -  7.82G  -
recv/test/l0_1/l1_0/l2_1@2025-02-26-1252     0B      -  7.71G  -
recv/test/l0_1/l1_0/l2_2@2025-02-26-1252     0B      -  7.87G  -
recv/test/l0_1/l1_0/l2_3@2025-02-26-1252     0B      -  7.65G  -
recv/test/l0_1/l1_1@2025-02-26-1252          0B      -  8.02G  -
recv/test/l0_1/l1_1/l2_0@2025-02-26-1252     0B      -  8.02G  -
recv/test/l0_1/l1_1/l2_1@2025-02-26-1252     0B      -  7.82G  -
root@orion:~# zpool list
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
recv   464G   237G   227G        -         -     0%    51%  1.00x    ONLINE  -
send   464G   237G   227G        -         -     0%    51%  1.00x    ONLINE  -
root@orion:~# 
```

