# Additional information

[Setup](./setup.md)

## 2025-02-03 storage

```text
root@orcus:~# ls -l /dev/disk/by-id
total 0
lrwxrwxrwx 1 root root  9 Feb  3 16:05 ata-Patriot_Burst_Elite_240GB_PBEIICB22121504882 -> ../../sdc
lrwxrwxrwx 1 root root 10 Feb  3 16:05 ata-Patriot_Burst_Elite_240GB_PBEIICB22121504882-part1 -> ../../sdc1
lrwxrwxrwx 1 root root 10 Feb  3 16:05 ata-Patriot_Burst_Elite_240GB_PBEIICB22121504882-part2 -> ../../sdc2
lrwxrwxrwx 1 root root 10 Feb  3 16:05 ata-Patriot_Burst_Elite_240GB_PBEIICB22121504882-part5 -> ../../sdc5
lrwxrwxrwx 1 root root  9 Feb  3 16:07 ata-Samsung_SSD_850_EVO_500GB_S21HNXAGC35770F -> ../../sda
lrwxrwxrwx 1 root root 10 Feb  3 16:07 ata-Samsung_SSD_850_EVO_500GB_S21HNXAGC35770F-part1 -> ../../sda1
lrwxrwxrwx 1 root root 10 Feb  3 16:07 ata-Samsung_SSD_850_EVO_500GB_S21HNXAGC35770F-part9 -> ../../sda9
lrwxrwxrwx 1 root root  9 Feb  3 19:50 ata-Samsung_SSD_850_EVO_500GB_S2RANB0HA37864N -> ../../sdb
lrwxrwxrwx 1 root root 10 Feb  3 19:50 ata-Samsung_SSD_850_EVO_500GB_S2RANB0HA37864N-part1 -> ../../sdb1
lrwxrwxrwx 1 root root 10 Feb  3 19:50 ata-Samsung_SSD_850_EVO_500GB_S2RANB0HA37864N-part9 -> ../../sdb9
lrwxrwxrwx 1 root root  9 Feb  3 16:07 wwn-0x5002538d40878f8e -> ../../sda
lrwxrwxrwx 1 root root 10 Feb  3 16:07 wwn-0x5002538d40878f8e-part1 -> ../../sda1
lrwxrwxrwx 1 root root 10 Feb  3 16:07 wwn-0x5002538d40878f8e-part9 -> ../../sda9
lrwxrwxrwx 1 root root  9 Feb  3 19:50 wwn-0x5002538d41628a33 -> ../../sdb
lrwxrwxrwx 1 root root 10 Feb  3 19:50 wwn-0x5002538d41628a33-part1 -> ../../sdb1
lrwxrwxrwx 1 root root 10 Feb  3 19:50 wwn-0x5002538d41628a33-part9 -> ../../sdb9
root@orcus:~# 
```

```text
root@orcus:~# smartctl -a /dev/sda
smartctl 7.3 2022-02-28 r5338 [x86_64-linux-6.1.0-30-amd64] (local build)
Copyright (C) 2002-22, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Samsung based SSDs
Device Model:     Samsung SSD 850 EVO 500GB
Serial Number:    S21HNXAGC35770F
LU WWN Device Id: 5 002538 d40878f8e
Firmware Version: EMT02B6Q
User Capacity:    500,107,862,016 bytes [500 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
TRIM Command:     Available
Device is:        In smartctl database 7.3/5319
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4c
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Feb  3 22:06:13 2025 CST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever 
                                        been run.
Total time to complete Offline 
data collection:                (    0) seconds.
Offline data collection
capabilities:                    (0x53) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        No Offline surface scan supported.
                                        Self-test supported.
                                        No Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine 
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 265) minutes.
SCT capabilities:              (0x003d) SCT Status supported.
                                        SCT Error Recovery Control supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always       -       0
  9 Power_On_Hours          0x0032   087   087   000    Old_age   Always       -       63339
 12 Power_Cycle_Count       0x0032   099   099   000    Old_age   Always       -       605
177 Wear_Leveling_Count     0x0013   088   088   000    Pre-fail  Always       -       248
179 Used_Rsvd_Blk_Cnt_Tot   0x0013   100   100   010    Pre-fail  Always       -       0
181 Program_Fail_Cnt_Total  0x0032   100   100   010    Old_age   Always       -       0
182 Erase_Fail_Count_Total  0x0032   100   100   010    Old_age   Always       -       0
183 Runtime_Bad_Block       0x0013   100   099   010    Pre-fail  Always       -       0
187 Uncorrectable_Error_Cnt 0x0032   100   100   000    Old_age   Always       -       0
190 Airflow_Temperature_Cel 0x0032   077   037   000    Old_age   Always       -       23
195 ECC_Error_Rate          0x001a   200   200   000    Old_age   Always       -       0
199 CRC_Error_Count         0x003e   099   099   000    Old_age   Always       -       48
235 POR_Recovery_Count      0x0012   099   099   000    Old_age   Always       -       185
241 Total_LBAs_Written      0x0032   099   099   000    Old_age   Always       -       72009581801

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]

Warning! SMART Selective Self-Test Log Structure error: invalid SMART checksum.
SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
  255        0    65535  Read_scanning was never started
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

root@orcus:~# 
root@orcus:~# 
root@orcus:~# 
root@orcus:~# smartctl -a /dev/sdb
smartctl 7.3 2022-02-28 r5338 [x86_64-linux-6.1.0-30-amd64] (local build)
Copyright (C) 2002-22, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Samsung based SSDs
Device Model:     Samsung SSD 850 EVO 500GB
Serial Number:    S2RANB0HA37864N
LU WWN Device Id: 5 002538 d41628a33
Firmware Version: EMT02B6Q
User Capacity:    500,107,862,016 bytes [500 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Form Factor:      2.5 inches
TRIM Command:     Available
Device is:        In smartctl database 7.3/5319
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 4c
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Feb  3 22:06:23 2025 CST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever 
                                        been run.
Total time to complete Offline 
data collection:                (    0) seconds.
Offline data collection
capabilities:                    (0x53) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        No Offline surface scan supported.
                                        Self-test supported.
                                        No Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine 
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 265) minutes.
SCT capabilities:              (0x003d) SCT Status supported.
                                        SCT Error Recovery Control supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always       -       0
  9 Power_On_Hours          0x0032   089   089   000    Old_age   Always       -       54413
 12 Power_Cycle_Count       0x0032   099   099   000    Old_age   Always       -       471
177 Wear_Leveling_Count     0x0013   094   094   000    Pre-fail  Always       -       125
179 Used_Rsvd_Blk_Cnt_Tot   0x0013   100   100   010    Pre-fail  Always       -       0
181 Program_Fail_Cnt_Total  0x0032   100   100   010    Old_age   Always       -       0
182 Erase_Fail_Count_Total  0x0032   100   100   010    Old_age   Always       -       0
183 Runtime_Bad_Block       0x0013   100   099   010    Pre-fail  Always       -       0
187 Uncorrectable_Error_Cnt 0x0032   100   100   000    Old_age   Always       -       0
190 Airflow_Temperature_Cel 0x0032   077   037   000    Old_age   Always       -       23
195 ECC_Error_Rate          0x001a   200   200   000    Old_age   Always       -       0
199 CRC_Error_Count         0x003e   099   099   000    Old_age   Always       -       56
235 POR_Recovery_Count      0x0012   099   099   000    Old_age   Always       -       113
241 Total_LBAs_Written      0x0032   099   099   000    Old_age   Always       -       53353901373

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     32925         -
# 2  Short offline       Completed without error       00%     32921         -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
  255        0    65535  Read_scanning was never started
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

root@orcus:~# 
root@orcus:~# 
root@orcus:~# 
root@orcus:~# smartctl -a /dev/sdc
smartctl 7.3 2022-02-28 r5338 [x86_64-linux-6.1.0-30-amd64] (local build)
Copyright (C) 2002-22, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     Patriot Burst Elite  240GB
Serial Number:    PBEIICB22121504882
LU WWN Device Id: 0 000000 000000000
Firmware Version: HCS1A25E
User Capacity:    240,057,409,536 bytes [240 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Form Factor:      2.5 inches
TRIM Command:     Available
Device is:        Not in smartctl database 7.3/5319
ATA Version is:   ACS-2 T13/2015-D revision 3
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Mon Feb  3 22:06:27 2025 CST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever 
                                        been run.
Total time to complete Offline 
data collection:                (  120) seconds.
Offline data collection
capabilities:                    (0x5d) SMART execute Offline immediate.
                                        No Auto Offline data collection support.
                                        Abort Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        No Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0002) Does not save SMART data before
                                        entering power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine 
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        (   4) minutes.

SMART Attributes Data Structure revision number: 1
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x0032   100   100   050    Old_age   Always       -       0
  5 Reallocated_Sector_Ct   0x0032   100   100   050    Old_age   Always       -       0
  9 Power_On_Hours          0x0032   100   100   050    Old_age   Always       -       1339
 12 Power_Cycle_Count       0x0032   100   100   050    Old_age   Always       -       157
160 Unknown_Attribute       0x0032   100   100   050    Old_age   Always       -       3
161 Unknown_Attribute       0x0032   100   100   050    Old_age   Always       -       100
163 Unknown_Attribute       0x0032   100   100   050    Old_age   Always       -       124
164 Unknown_Attribute       0x0032   100   100   050    Old_age   Always       -       9
165 Unknown_Attribute       0x0032   100   100   050    Old_age   Always       -       29
166 Unknown_Attribute       0x0032   100   100   050    Old_age   Always       -       6
167 Unknown_Attribute       0x0032   100   100   050    Old_age   Always       -       13
168 Unknown_Attribute       0x0032   100   100   050    Old_age   Always       -       0
169 Unknown_Attribute       0x0032   100   100   050    Old_age   Always       -       100
175 Program_Fail_Count_Chip 0x0032   100   100   050    Old_age   Always       -       118423553
176 Erase_Fail_Count_Chip   0x0032   100   100   050    Old_age   Always       -       3289
177 Wear_Leveling_Count     0x0032   100   100   050    Old_age   Always       -       442909
178 Used_Rsvd_Blk_Cnt_Chip  0x0032   100   100   050    Old_age   Always       -       0
181 Program_Fail_Cnt_Total  0x0032   100   100   050    Old_age   Always       -       0
182 Erase_Fail_Count_Total  0x0032   100   100   050    Old_age   Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   050    Old_age   Always       -       85
194 Temperature_Celsius     0x0032   100   100   050    Old_age   Always       -       40
195 Hardware_ECC_Recovered  0x0032   100   100   050    Old_age   Always       -       0
196 Reallocated_Event_Count 0x0032   100   100   050    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   100   100   050    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0032   100   100   050    Old_age   Always       -       0
199 UDMA_CRC_Error_Count    0x0032   100   100   050    Old_age   Always       -       1
232 Available_Reservd_Space 0x0032   100   100   050    Old_age   Always       -       100
241 Total_LBAs_Written      0x0032   100   100   050    Old_age   Always       -       30639
242 Total_LBAs_Read         0x0032   100   100   050    Old_age   Always       -       24154
245 Unknown_Attribute       0x0032   100   100   050    Old_age   Always       -       54769

SMART Error Log Version: 1
ATA Error Count: 1
        CR = Command Register [HEX]
        FR = Features Register [HEX]
        SC = Sector Count Register [HEX]
        SN = Sector Number Register [HEX]
        CL = Cylinder Low Register [HEX]
        CH = Cylinder High Register [HEX]
        DH = Device/Head Register [HEX]
        DC = Device Command Register [HEX]
        ER = Error register [HEX]
        ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 1 occurred at disk power-on lifetime: 129 hours (5 days + 9 hours)
  When the command that caused the error occurred, the device was in an unknown state.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  04 40 01 00 00 00 51

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  f1 00 01 00 00 00 40 08      00:00:57.250  SECURITY SET PASSWORD

SMART Self-test log structure revision number 0
Warning: ATA Specification requires self-test log structure revision number = 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]

SMART Selective self-test log data structure revision number 0
Note: revision number not 1 implies that no selective self-test has ever been run
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

root@orcus:~# 
```

## 2025-02-03 processors (lscpu)

```text
root@orcus:~# lscpu
Architecture:             x86_64
  CPU op-mode(s):         32-bit, 64-bit
  Address sizes:          40 bits physical, 48 bits virtual
  Byte Order:             Little Endian
CPU(s):                   16
  On-line CPU(s) list:    0-15
Vendor ID:                GenuineIntel
  BIOS Vendor ID:         Intel            
  Model name:             Intel(R) Xeon(R) CPU           E5620  @ 2.40GHz
    BIOS Model name:      Intel(R) Xeon(R) CPU           E5620  @ 2.40GHz      To Be Filled By O.E.M. CPU @ 2.4GHz
    BIOS CPU family:      179
    CPU family:           6
    Model:                44
    Thread(s) per core:   2
    Core(s) per socket:   4
    Socket(s):            2
    Stepping:             2
    Frequency boost:      enabled
    CPU(s) scaling MHz:   67%
    CPU max MHz:          2401.0000
    CPU min MHz:          1600.0000
    BogoMIPS:             4800.12
    Flags:                fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ht tm pbe s
                          yscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pn
                          i dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid dca sse4_1 sse4_2 popcnt lahf_lm epb pti ssbd ibrs i
                          bpb stibp tpr_shadow vnmi flexpriority ept vpid dtherm ida arat flush_l1d
Virtualization features:  
  Virtualization:         VT-x
Caches (sum of all):      
  L1d:                    256 KiB (8 instances)
  L1i:                    256 KiB (8 instances)
  L2:                     2 MiB (8 instances)
  L3:                     24 MiB (2 instances)
NUMA:                     
  NUMA node(s):           2
  NUMA node0 CPU(s):      0-3,8-11
  NUMA node1 CPU(s):      4-7,12-15
Vulnerabilities:          
  Gather data sampling:   Not affected
  Itlb multihit:          KVM: Mitigation: VMX disabled
  L1tf:                   Mitigation; PTE Inversion; VMX conditional cache flushes, SMT vulnerable
  Mds:                    Vulnerable: Clear CPU buffers attempted, no microcode; SMT vulnerable
  Meltdown:               Mitigation; PTI
  Mmio stale data:        Unknown: No mitigations
  Reg file data sampling: Not affected
  Retbleed:               Not affected
  Spec rstack overflow:   Not affected
  Spec store bypass:      Mitigation; Speculative Store Bypass disabled via prctl
  Spectre v1:             Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  Spectre v2:             Mitigation; Retpolines; IBPB conditional; IBRS_FW; STIBP conditional; RSB filling; PBRSB-eIBRS Not affected; BHI Not a
                          ffected
  Srbds:                  Not affected
  Tsx async abort:        Not affected
root@orcus:~# 
```

## 2025-02-03 host information (lshw)

```text
root@orcus:~# lshw
orcus                       
    description: System
    product: X8DTL (To Be Filled By O.E.M.)
    vendor: Supermicro
    version: 1234567890
    serial: 1234567890
    width: 64 bits
    capabilities: smbios-2.6 dmi-2.6 smp vsyscall32
    configuration: boot=normal chassis=server family=Server sku=To Be Filled By O.E.M. uuid=49434d53-0200-9006-2500-06902500bddf
  *-core
       description: Motherboard
       product: X8DTL
       vendor: Supermicro
       physical id: 0
       version: 1234567890
       serial: 1234567890
       slot: To Be Filled By O.E.M.
     *-firmware
          description: BIOS
          vendor: American Megatrends Inc.
          physical id: 0
          version: 2.1b
          date: 11/16/2012
          size: 64KiB
          capacity: 4MiB
          capabilities: isa pci pnp upgrade shadowing escd cdboot bootselect socketedrom edd int13floppy1200 int13floppy720 int13floppy2880 int5printscreen int9keyboard int14serial int17printer int10video acpi usb ls120boot zipboot biosbootspecification
     *-cpu:0
          description: CPU
          product: Intel(R) Xeon(R) CPU           E5620  @ 2.40GHz
          vendor: Intel Corp.
          physical id: 4
          bus info: cpu@0
          version: 6.44.2
          serial: To Be Filled By O.E.M.
          slot: CPU 1
          size: 1600MHz
          capacity: 2401MHz
          width: 64 bits
          clock: 133MHz
          capabilities: lm fpu fpu_exception wp vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ht tm pbe syscall nx pdpe1gb rdtscp x86-64 constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid dca sse4_1 sse4_2 popcnt lahf_lm epb pti ssbd ibrs ibpb stibp tpr_shadow vnmi flexpriority ept vpid dtherm ida arat flush_l1d cpufreq
          configuration: cores=4 enabledcores=4 microcode=31 threads=8
        *-cache:0
             description: L1 cache
             physical id: 5
             slot: L1-Cache
             size: 256KiB
             capacity: 256KiB
             capabilities: internal write-through instruction
             configuration: level=1
        *-cache:1
             description: L2 cache
             physical id: 6
             slot: L2-Cache
             size: 1MiB
             capacity: 1MiB
             capabilities: internal write-through unified
             configuration: level=2
        *-cache:2
             description: L3 cache
             physical id: 7
             slot: L3-Cache
             size: 12MiB
             capacity: 12MiB
             capabilities: internal write-back unified
             configuration: level=3
     *-cpu:1
          description: CPU
          product: Intel(R) Xeon(R) CPU           E5620  @ 2.40GHz
          vendor: Intel Corp.
          physical id: 8
          bus info: cpu@1
          version: 6.44.2
          serial: To Be Filled By O.E.M.
          slot: CPU 2
          size: 1600MHz
          capacity: 2401MHz
          width: 64 bits
          clock: 133MHz
          capabilities: lm fpu fpu_exception wp vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ht tm pbe syscall nx pdpe1gb rdtscp x86-64 constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid dca sse4_1 sse4_2 popcnt lahf_lm epb pti ssbd ibrs ibpb stibp tpr_shadow vnmi flexpriority ept vpid dtherm ida arat flush_l1d cpufreq
          configuration: cores=4 enabledcores=4 microcode=31 threads=8
        *-cache:0
             description: L1 cache
             physical id: 9
             slot: L1-Cache
             size: 256KiB
             capacity: 256KiB
             capabilities: internal write-through instruction
             configuration: level=1
        *-cache:1
             description: L2 cache
             physical id: a
             slot: L2-Cache
             size: 1MiB
             capacity: 1MiB
             capabilities: internal write-through unified
             configuration: level=2
        *-cache:2
             description: L3 cache
             physical id: b
             slot: L3-Cache
             size: 12MiB
             capacity: 12MiB
             capabilities: internal write-back unified
             configuration: level=3
     *-memory
          description: System Memory
          physical id: 2d
          slot: System board or motherboard
          size: 16GiB
          capabilities: ecc
          configuration: errordetection=multi-bit-ecc
        *-bank:0
             description: DIMM 1066 MHz (0.9 ns)
             product: M393B1K70BH1-CF8
             vendor: Samsung
             physical id: 0
             serial: EA090E06
             slot: P2_DIMM1A
             size: 8GiB
             width: 64 bits
             clock: 1066MHz (0.9ns)
        *-bank:1
             description: DIMM [empty]
             product: ModulePartNumber01
             vendor: Manufacturer01
             physical id: 1
             serial: SerNum01
             slot: P2_DIMM2A
             width: 64 bits
        *-bank:2
             description: DIMM [empty]
             product: ModulePartNumber02
             vendor: Manufacturer02
             physical id: 2
             serial: SerNum02
             slot: P2_DIMM3A
             width: 64 bits
        *-bank:3
             description: DIMM 1066 MHz (0.9 ns)
             product: M393B1K70BH1-CF8
             vendor: Samsung
             physical id: 3
             serial: 6EDA1046
             slot: P1_DIMM1A
             size: 8GiB
             width: 64 bits
             clock: 1066MHz (0.9ns)
        *-bank:4
             description: DIMM [empty]
             product: ModulePartNumber04
             vendor: Manufacturer04
             physical id: 4
             serial: SerNum04
             slot: P1_DIMM2A
             width: 64 bits
        *-bank:5
             description: DIMM [empty]
             product: ModulePartNumber05
             vendor: Manufacturer05
             physical id: 5
             serial: SerNum05
             slot: P1_DIMM3A
             width: 64 bits
     *-flash UNCLAIMED
          description: Flash Memory
          physical id: 3d
          slot: System board or motherboard
          capacity: 4MiB
        *-bank UNCLAIMED
             description: FLASH Non-volatile 33 MHz (30.3 ns)
             product: 25L3205
             vendor: MXIC
             physical id: 0
             slot: BIOS
             size: 4MiB
             width: 8 bits
             clock: 33MHz (30.3ns)
     *-pci:0
          description: Host bridge
          product: 5500 I/O Hub to ESI Port
          vendor: Intel Corporation
          physical id: 100
          bus info: pci@0000:00:00.0
          version: 22
          width: 32 bits
          clock: 33MHz
        *-pci:0
             description: PCI bridge
             product: 5520/5500/X58 I/O Hub PCI Express Root Port 1
             vendor: Intel Corporation
             physical id: 1
             bus info: pci@0000:00:01.0
             version: 22
             width: 32 bits
             clock: 33MHz
             capabilities: pci msi pciexpress pm normal_decode bus_master cap_list
             configuration: driver=pcieport
             resources: irq:24
        *-pci:1
             description: PCI bridge
             product: 5520/5500/X58 I/O Hub PCI Express Root Port 3
             vendor: Intel Corporation
             physical id: 3
             bus info: pci@0000:00:03.0
             version: 22
             width: 32 bits
             clock: 33MHz
             capabilities: pci msi pciexpress pm normal_decode bus_master cap_list
             configuration: driver=pcieport
             resources: irq:25
        *-pci:2
             description: PCI bridge
             product: 5520/5500/X58 I/O Hub PCI Express Root Port 7
             vendor: Intel Corporation
             physical id: 7
             bus info: pci@0000:00:07.0
             version: 22
             width: 32 bits
             clock: 33MHz
             capabilities: pci msi pciexpress pm normal_decode bus_master cap_list
             configuration: driver=pcieport
             resources: irq:26
        *-pci:3
             description: PCI bridge
             product: 7500/5520/5500/X58 I/O Hub PCI Express Root Port 9
             vendor: Intel Corporation
             physical id: 9
             bus info: pci@0000:00:09.0
             version: 22
             width: 32 bits
             clock: 33MHz
             capabilities: pci msi pciexpress pm normal_decode bus_master cap_list
             configuration: driver=pcieport
             resources: irq:27 ioport:c000(size=4096) memory:fba00000-fbbfffff
           *-sas
                description: Serial Attached SCSI controller
                product: SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon]
                vendor: Broadcom / LSI
                physical id: 0
                bus info: pci@0000:04:00.0
                logical name: scsi0
                version: 03
                width: 64 bits
                clock: 33MHz
                capabilities: sas pm pciexpress vpd msi msix bus_master cap_list rom
                configuration: driver=mpt3sas latency=0
                resources: irq:34 ioport:c000(size=256) memory:fbab0000-fbabffff memory:fbac0000-fbafffff memory:fbb00000-fbbfffff
              *-disk:0
                   description: ATA Disk
                   product: Samsung SSD 850
                   physical id: 0.0.0
                   bus info: scsi@0:0.0.0
                   logical name: /dev/sdb
                   version: 2B6Q
                   serial: S2RANB0HA37864N
                   size: 465GiB (500GB)
                   capacity: 465GiB (500GB)
                   capabilities: 15000rpm gpt-1.00 partitioned partitioned:gpt
                   configuration: ansiversion=6 guid=a45d994c-ca10-fe41-8dc7-89718d08370e logicalsectorsize=512 sectorsize=512
                 *-volume:0
                      description: OS X ZFS partition or Solaris /usr partition
                      vendor: Solaris
                      physical id: 1
                      bus info: scsi@0:0.0.0,1
                      logical name: /dev/sdb1
                      serial: 0f94c7c0-9310-1c4b-85b8-304cfe2a4ddd
                      capacity: 465GiB
                      configuration: name=zfs-a0222a51520237d6
                 *-volume:1
                      description: reserved partition
                      vendor: Solaris
                      physical id: 9
                      bus info: scsi@0:0.0.0,9
                      logical name: /dev/sdb9
                      serial: 28c1fbde-2cba-fc4f-be4e-81f645433a96
                      capacity: 8191KiB
              *-disk:1
                   description: ATA Disk
                   product: Samsung SSD 850
                   physical id: 0.1.0
                   bus info: scsi@0:0.1.0
                   logical name: /dev/sda
                   version: 2B6Q
                   serial: S21HNXAGC35770F
                   size: 465GiB (500GB)
                   capacity: 465GiB (500GB)
                   capabilities: 15000rpm gpt-1.00 partitioned partitioned:gpt
                   configuration: ansiversion=6 guid=0ae7bddf-2a53-6f41-b432-be89546e7c64 logicalsectorsize=512 sectorsize=512
                 *-volume:0
                      description: OS X ZFS partition or Solaris /usr partition
                      vendor: Solaris
                      physical id: 1
                      bus info: scsi@0:0.1.0,1
                      logical name: /dev/sda1
                      serial: 4f102630-d566-2c48-a775-2ce81e6e1e5f
                      capacity: 465GiB
                      configuration: name=zfs-f2f46b2c943c8e51
                 *-volume:1
                      description: reserved partition
                      vendor: Solaris
                      physical id: 9
                      bus info: scsi@0:0.1.0,9
                      logical name: /dev/sda9
                      serial: 3e772f8f-7927-ac47-aaa3-437be6ed9305
                      capacity: 8191KiB
        *-generic:0 UNCLAIMED
             description: PIC
             product: 7500/5520/5500/X58 I/O Hub I/OxAPIC Interrupt Controller
             vendor: Intel Corporation
             physical id: 13
             bus info: pci@0000:00:13.0
             version: 22
             width: 32 bits
             clock: 33MHz
             capabilities: pm io_x_-apic bus_master cap_list
             configuration: latency=0
             resources: memory:fec8a000-fec8afff
        *-generic:1
             description: PIC
             product: 7500/5520/5500/X58 I/O Hub System Management Registers
             vendor: Intel Corporation
             physical id: 14
             bus info: pci@0000:00:14.0
             version: 22
             width: 32 bits
             clock: 33MHz
             capabilities: pciexpress 8259 cap_list
             configuration: driver=i7core_edac latency=0
             resources: irq:0
        *-generic:2 UNCLAIMED
             description: PIC
             product: 7500/5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers
             vendor: Intel Corporation
             physical id: 14.1
             bus info: pci@0000:00:14.1
             version: 22
             width: 32 bits
             clock: 33MHz
             capabilities: pciexpress 8259 cap_list
             configuration: latency=0
        *-generic:3 UNCLAIMED
             description: PIC
             product: 7500/5520/5500/X58 I/O Hub Control Status and RAS Registers
             vendor: Intel Corporation
             physical id: 14.2
             bus info: pci@0000:00:14.2
             version: 22
             width: 32 bits
             clock: 33MHz
             capabilities: pciexpress 8259 cap_list
             configuration: latency=0
        *-generic:4
             description: PIC
             product: 7500/5520/5500/X58 I/O Hub Throttle Registers
             vendor: Intel Corporation
             physical id: 14.3
             bus info: pci@0000:00:14.3
             version: 22
             width: 32 bits
             clock: 33MHz
             capabilities: 8259
             configuration: driver=i5500_temp latency=0
             resources: irq:0
        *-generic:5
             description: System peripheral
             product: 5520/5500/X58 Chipset QuickData Technology Device
             vendor: Intel Corporation
             physical id: 16
             bus info: pci@0000:00:16.0
             version: 22
             width: 64 bits
             clock: 33MHz
             capabilities: msix pciexpress pm bus_master cap_list
             configuration: driver=ioatdma latency=0
             resources: irq:39 memory:fbef8000-fbefbfff
        *-generic:6
             description: System peripheral
             product: 5520/5500/X58 Chipset QuickData Technology Device
             vendor: Intel Corporation
             physical id: 16.1
             bus info: pci@0000:00:16.1
             version: 22
             width: 64 bits
             clock: 33MHz
             capabilities: msix pciexpress pm bus_master cap_list
             configuration: driver=ioatdma latency=0
             resources: irq:41 memory:fbef4000-fbef7fff
        *-generic:7
             description: System peripheral
             product: 5520/5500/X58 Chipset QuickData Technology Device
             vendor: Intel Corporation
             physical id: 16.2
             bus info: pci@0000:00:16.2
             version: 22
             width: 64 bits
             clock: 33MHz
             capabilities: msix pciexpress pm bus_master cap_list
             configuration: driver=ioatdma latency=0
             resources: irq:43 memory:fbef0000-fbef3fff
        *-generic:8
             description: System peripheral
             product: 5520/5500/X58 Chipset QuickData Technology Device
             vendor: Intel Corporation
             physical id: 16.3
             bus info: pci@0000:00:16.3
             version: 22
             width: 64 bits
             clock: 33MHz
             capabilities: msix pciexpress pm bus_master cap_list
             configuration: driver=ioatdma latency=0
             resources: irq:45 memory:fbeec000-fbeeffff
        *-generic:9
             description: System peripheral
             product: 5520/5500/X58 Chipset QuickData Technology Device
             vendor: Intel Corporation
             physical id: 16.4
             bus info: pci@0000:00:16.4
             version: 22
             width: 64 bits
             clock: 33MHz
             capabilities: msix pciexpress pm bus_master cap_list
             configuration: driver=ioatdma latency=0
             resources: irq:39 memory:fbee8000-fbeebfff
        *-generic:10
             description: System peripheral
             product: 5520/5500/X58 Chipset QuickData Technology Device
             vendor: Intel Corporation
             physical id: 16.5
             bus info: pci@0000:00:16.5
             version: 22
             width: 64 bits
             clock: 33MHz
             capabilities: msix pciexpress pm bus_master cap_list
             configuration: driver=ioatdma latency=0
             resources: irq:41 memory:fbee4000-fbee7fff
        *-generic:11
             description: System peripheral
             product: 5520/5500/X58 Chipset QuickData Technology Device
             vendor: Intel Corporation
             physical id: 16.6
             bus info: pci@0000:00:16.6
             version: 22
             width: 64 bits
             clock: 33MHz
             capabilities: msix pciexpress pm bus_master cap_list
             configuration: driver=ioatdma latency=0
             resources: irq:43 memory:fbee0000-fbee3fff
        *-generic:12
             description: System peripheral
             product: 5520/5500/X58 Chipset QuickData Technology Device
             vendor: Intel Corporation
             physical id: 16.7
             bus info: pci@0000:00:16.7
             version: 22
             width: 64 bits
             clock: 33MHz
             capabilities: msix pciexpress pm bus_master cap_list
             configuration: driver=ioatdma latency=0
             resources: irq:45 memory:fbedc000-fbedffff
        *-usb:0
             description: USB controller
             product: 82801JI (ICH10 Family) USB UHCI Controller #4
             vendor: Intel Corporation
             physical id: 1a
             bus info: pci@0000:00:1a.0
             version: 00
             width: 32 bits
             clock: 33MHz
             capabilities: uhci bus_master cap_list
             configuration: driver=uhci_hcd latency=0
             resources: irq:16 ioport:bc00(size=32)
           *-usbhost
                product: UHCI Host Controller
                vendor: Linux 6.1.0-30-amd64 uhci_hcd
                physical id: 1
                bus info: usb@2
                logical name: usb2
                version: 6.01
                capabilities: usb-1.10
                configuration: driver=hub slots=2 speed=12Mbit/s
        *-usb:1
             description: USB controller
             product: 82801JI (ICH10 Family) USB UHCI Controller #5
             vendor: Intel Corporation
             physical id: 1a.1
             bus info: pci@0000:00:1a.1
             version: 00
             width: 32 bits
             clock: 33MHz
             capabilities: uhci bus_master cap_list
             configuration: driver=uhci_hcd latency=0
             resources: irq:21 ioport:b880(size=32)
           *-usbhost
                product: UHCI Host Controller
                vendor: Linux 6.1.0-30-amd64 uhci_hcd
                physical id: 1
                bus info: usb@4
                logical name: usb4
                version: 6.01
                capabilities: usb-1.10
                configuration: driver=hub slots=2 speed=12Mbit/s
        *-usb:2
             description: USB controller
             product: 82801JI (ICH10 Family) USB UHCI Controller #6
             vendor: Intel Corporation
             physical id: 1a.2
             bus info: pci@0000:00:1a.2
             version: 00
             width: 32 bits
             clock: 33MHz
             capabilities: uhci bus_master cap_list
             configuration: driver=uhci_hcd latency=0
             resources: irq:19 ioport:b800(size=32)
           *-usbhost
                product: UHCI Host Controller
                vendor: Linux 6.1.0-30-amd64 uhci_hcd
                physical id: 1
                bus info: usb@5
                logical name: usb5
                version: 6.01
                capabilities: usb-1.10
                configuration: driver=hub slots=2 speed=12Mbit/s
        *-usb:3
             description: USB controller
             product: 82801JI (ICH10 Family) USB2 EHCI Controller #2
             vendor: Intel Corporation
             physical id: 1a.7
             bus info: pci@0000:00:1a.7
             version: 00
             width: 32 bits
             clock: 33MHz
             capabilities: pm debug ehci bus_master cap_list
             configuration: driver=ehci-pci latency=0
             resources: irq:18 memory:fbeda000-fbeda3ff
           *-usbhost
                product: EHCI Host Controller
                vendor: Linux 6.1.0-30-amd64 ehci_hcd
                physical id: 1
                bus info: usb@1
                logical name: usb1
                version: 6.01
                capabilities: usb-2.00
                configuration: driver=hub slots=6 speed=480Mbit/s
        *-pci:4
             description: PCI bridge
             product: 82801JI (ICH10 Family) PCI Express Root Port 1
             vendor: Intel Corporation
             physical id: 1c
             bus info: pci@0000:00:1c.0
             version: 00
             width: 32 bits
             clock: 33MHz
             capabilities: pci pciexpress msi pm normal_decode bus_master cap_list
             configuration: driver=pcieport
             resources: irq:28 ioport:1000(size=4096) memory:c0000000-c01fffff ioport:c0200000(size=2097152)
        *-pci:5
             description: PCI bridge
             product: 82801JI (ICH10 Family) PCI Express Root Port 5
             vendor: Intel Corporation
             physical id: 1c.4
             bus info: pci@0000:00:1c.4
             version: 00
             width: 32 bits
             clock: 33MHz
             capabilities: pci pciexpress msi pm normal_decode bus_master cap_list
             configuration: driver=pcieport
             resources: irq:29 ioport:d000(size=4096) memory:fbc00000-fbcfffff ioport:c0400000(size=2097152)
           *-network DISABLED
                description: Ethernet interface
                product: 82574L Gigabit Network Connection
                vendor: Intel Corporation
                physical id: 0
                bus info: pci@0000:06:00.0
                logical name: enp6s0
                version: 00
                serial: 00:25:90:06:df:be
                capacity: 1Gbit/s
                width: 32 bits
                clock: 33MHz
                capabilities: pm msi pciexpress msix bus_master cap_list ethernet physical tp 10bt 10bt-fd 100bt 100bt-fd 1000bt-fd autonegotiation
                configuration: autonegotiation=on broadcast=yes driver=e1000e driverversion=6.1.0-30-amd64 firmware=1.8-0 latency=0 link=no multicast=yes port=twisted pair
                resources: irq:16 memory:fbce0000-fbcfffff ioport:dc00(size=32) memory:fbcdc000-fbcdffff
        *-pci:6
             description: PCI bridge
             product: 82801JI (ICH10 Family) PCI Express Root Port 6
             vendor: Intel Corporation
             physical id: 1c.5
             bus info: pci@0000:00:1c.5
             version: 00
             width: 32 bits
             clock: 33MHz
             capabilities: pci pciexpress msi pm normal_decode bus_master cap_list
             configuration: driver=pcieport
             resources: irq:30 ioport:e000(size=4096) memory:fbd00000-fbdfffff ioport:c0600000(size=2097152)
           *-network
                description: Ethernet interface
                product: 82574L Gigabit Network Connection
                vendor: Intel Corporation
                physical id: 0
                bus info: pci@0000:07:00.0
                logical name: enp7s0
                version: 00
                serial: 00:25:90:06:df:be
                size: 1Gbit/s
                capacity: 1Gbit/s
                width: 32 bits
                clock: 33MHz
                capabilities: pm msi pciexpress msix bus_master cap_list ethernet physical tp 10bt 10bt-fd 100bt 100bt-fd 1000bt-fd autonegotiation
                configuration: autonegotiation=on broadcast=yes driver=e1000e driverversion=6.1.0-30-amd64 duplex=full firmware=1.8-0 ip=192.168.1.107 latency=0 link=yes multicast=yes port=twisted pair speed=1Gbit/s
                resources: irq:17 memory:fbde0000-fbdfffff ioport:ec00(size=32) memory:fbddc000-fbddffff
        *-usb:4
             description: USB controller
             product: 82801JI (ICH10 Family) USB UHCI Controller #1
             vendor: Intel Corporation
             physical id: 1d
             bus info: pci@0000:00:1d.0
             version: 00
             width: 32 bits
             clock: 33MHz
             capabilities: uhci bus_master cap_list
             configuration: driver=uhci_hcd latency=0
             resources: irq:23 ioport:b480(size=32)
           *-usbhost
                product: UHCI Host Controller
                vendor: Linux 6.1.0-30-amd64 uhci_hcd
                physical id: 1
                bus info: usb@6
                logical name: usb6
                version: 6.01
                capabilities: usb-1.10
                configuration: driver=hub slots=2 speed=12Mbit/s
        *-usb:5
             description: USB controller
             product: 82801JI (ICH10 Family) USB UHCI Controller #2
             vendor: Intel Corporation
             physical id: 1d.1
             bus info: pci@0000:00:1d.1
             version: 00
             width: 32 bits
             clock: 33MHz
             capabilities: uhci bus_master cap_list
             configuration: driver=uhci_hcd latency=0
             resources: irq:19 ioport:b400(size=32)
           *-usbhost
                product: UHCI Host Controller
                vendor: Linux 6.1.0-30-amd64 uhci_hcd
                physical id: 1
                bus info: usb@7
                logical name: usb7
                version: 6.01
                capabilities: usb-1.10
                configuration: driver=hub slots=2 speed=12Mbit/s
        *-usb:6
             description: USB controller
             product: 82801JI (ICH10 Family) USB UHCI Controller #3
             vendor: Intel Corporation
             physical id: 1d.2
             bus info: pci@0000:00:1d.2
             version: 00
             width: 32 bits
             clock: 33MHz
             capabilities: uhci bus_master cap_list
             configuration: driver=uhci_hcd latency=0
             resources: irq:18 ioport:b080(size=32)
           *-usbhost
                product: UHCI Host Controller
                vendor: Linux 6.1.0-30-amd64 uhci_hcd
                physical id: 1
                bus info: usb@8
                logical name: usb8
                version: 6.01
                capabilities: usb-1.10
                configuration: driver=hub slots=2 speed=12Mbit/s
        *-usb:7
             description: USB controller
             product: 82801JI (ICH10 Family) USB2 EHCI Controller #1
             vendor: Intel Corporation
             physical id: 1d.7
             bus info: pci@0000:00:1d.7
             version: 00
             width: 32 bits
             clock: 33MHz
             capabilities: pm debug ehci bus_master cap_list
             configuration: driver=ehci-pci latency=0
             resources: irq:23 memory:fbed8000-fbed83ff
           *-usbhost
                product: EHCI Host Controller
                vendor: Linux 6.1.0-30-amd64 ehci_hcd
                physical id: 1
                bus info: usb@3
                logical name: usb3
                version: 6.01
                capabilities: usb-2.00
                configuration: driver=hub slots=6 speed=480Mbit/s
        *-pci:7
             description: PCI bridge
             product: 82801 PCI Bridge
             vendor: Intel Corporation
             physical id: 1e
             bus info: pci@0000:00:1e.0
             version: 90
             width: 32 bits
             clock: 33MHz
             capabilities: pci subtractive_decode bus_master cap_list
             resources: memory:faf00000-fb7fffff ioport:f9000000(size=16777216)
           *-display
                description: VGA compatible controller
                product: MGA G200eW WPCM450
                vendor: Matrox Electronics Systems Ltd.
                physical id: 1
                bus info: pci@0000:08:01.0
                logical name: /dev/fb0
                version: 0a
                width: 32 bits
                clock: 33MHz
                capabilities: pm vga_controller bus_master cap_list rom fb
                configuration: depth=32 driver=mgag200 latency=64 maxlatency=32 mingnt=16 resolution=1280,1024
                resources: irq:18 memory:f9000000-f9ffffff memory:faffc000-faffffff memory:fb000000-fb7fffff memory:c0000-dffff
        *-isa
             description: ISA bridge
             product: 82801JIR (ICH10R) LPC Interface Controller
             vendor: Intel Corporation
             physical id: 1f
             bus info: pci@0000:00:1f.0
             version: 00
             width: 32 bits
             clock: 33MHz
             capabilities: isa bus_master cap_list
             configuration: driver=lpc_ich latency=0
             resources: irq:0
           *-pnp00:00
                product: PnP device PNP0c01
                physical id: 0
                capabilities: pnp
                configuration: driver=system
           *-pnp00:01
                product: PnP device PNP0b00
                physical id: 1
                capabilities: pnp
                configuration: driver=rtc_cmos
           *-pnp00:02
                product: PnP device PNP0c02
                physical id: 2
                capabilities: pnp
                configuration: driver=system
           *-pnp00:03
                product: PnP device PNP0501
                physical id: 3
                capabilities: pnp
                configuration: driver=serial
           *-pnp00:04
                product: PnP device PNP0501
                physical id: 4
                capabilities: pnp
                configuration: driver=serial
           *-pnp00:05
                product: PnP device PNP0c02
                physical id: 5
                capabilities: pnp
                configuration: driver=system
           *-pnp00:06
                product: PnP device PNP0c02
                physical id: 6
                capabilities: pnp
                configuration: driver=system
           *-pnp00:07
                product: PnP device PNP0c02
                physical id: 7
                capabilities: pnp
                configuration: driver=system
           *-pnp00:08
                product: PnP device PNP0c01
                physical id: 8
                capabilities: pnp
                configuration: driver=system
        *-sata
             description: SATA controller
             product: 82801JI (ICH10 Family) SATA AHCI Controller
             vendor: Intel Corporation
             physical id: 1f.2
             bus info: pci@0000:00:1f.2
             logical name: scsi5
             version: 00
             width: 32 bits
             clock: 66MHz
             capabilities: sata msi pm ahci_1.0 bus_master cap_list emulated
             configuration: driver=ahci latency=0
             resources: irq:49 ioport:a480(size=8) ioport:b000(size=4) ioport:ac00(size=8) ioport:a880(size=4) ioport:a800(size=32) memory:fbed6000-fbed67ff
           *-disk
                description: ATA Disk
                product: Patriot Burst El
                physical id: 0.0.0
                bus info: scsi@5:0.0.0
                logical name: /dev/sdc
                version: A25E
                serial: PBEIICB22121504882
                size: 223GiB (240GB)
                capabilities: partitioned partitioned:dos
                configuration: ansiversion=5 logicalsectorsize=512 sectorsize=512 signature=de3a8f2a
              *-volume:0
                   description: EXT4 volume
                   vendor: Linux
                   physical id: 1
                   bus info: scsi@5:0.0.0,1
                   logical name: /dev/sdc1
                   logical name: /
                   version: 1.0
                   serial: 2df84dec-d54b-4a2c-925f-e543865c13be
                   size: 222GiB
                   capacity: 222GiB
                   capabilities: primary bootable journaled extended_attributes large_files huge_files dir_nlink recover 64bit extents ext4 ext2 initialized
                   configuration: created=2025-02-03 14:44:46 filesystem=ext4 lastmountpoint=/ modified=2025-02-03 15:06:03 mount.fstype=ext4 mount.options=rw,relatime,errors=remount-ro mounted=2025-02-03 15:06:04 state=mounted
              *-volume:1
                   description: Extended partition
                   physical id: 2
                   bus info: scsi@5:0.0.0,2
                   logical name: /dev/sdc2
                   size: 975MiB
                   capacity: 975MiB
                   capabilities: primary extended partitioned partitioned:extended
                 *-logicalvolume
                      description: Linux swap volume
                      physical id: 5
                      logical name: /dev/sdc5
                      version: 1
                      serial: 82848bb2-f177-4d76-ba83-09bb2189e274
                      size: 975MiB
                      capacity: 975MiB
                      capabilities: nofs swap initialized
                      configuration: filesystem=swap pagesize=4096
        *-serial
             description: SMBus
             product: 82801JI (ICH10 Family) SMBus Controller
             vendor: Intel Corporation
             physical id: 1f.3
             bus info: pci@0000:00:1f.3
             version: 00
             width: 64 bits
             clock: 33MHz
             configuration: driver=i801_smbus latency=0
             resources: irq:18 memory:fbed4000-fbed40ff ioport:400(size=32)
     *-pci:1
          description: Host bridge
          product: Xeon 5600 Series QuickPath Architecture Generic Non-core Registers
          vendor: Intel Corporation
          physical id: 101
          bus info: pci@0000:fe:00.0
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:2
          description: Host bridge
          product: Xeon 5600 Series QuickPath Architecture System Address Decoder
          vendor: Intel Corporation
          physical id: 102
          bus info: pci@0000:fe:00.1
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:3
          description: Host bridge
          product: Xeon 5600 Series QPI Link 0
          vendor: Intel Corporation
          physical id: 103
          bus info: pci@0000:fe:02.0
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:4
          description: Host bridge
          product: Xeon 5600 Series QPI Physical 0
          vendor: Intel Corporation
          physical id: 104
          bus info: pci@0000:fe:02.1
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:5
          description: Host bridge
          product: Xeon 5600 Series Mirror Port Link 0
          vendor: Intel Corporation
          physical id: 105
          bus info: pci@0000:fe:02.2
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:6
          description: Host bridge
          product: Xeon 5600 Series Mirror Port Link 1
          vendor: Intel Corporation
          physical id: 106
          bus info: pci@0000:fe:02.3
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:7
          description: Host bridge
          product: Xeon 5600 Series QPI Link 1
          vendor: Intel Corporation
          physical id: 107
          bus info: pci@0000:fe:02.4
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:8
          description: Host bridge
          product: Xeon 5600 Series QPI Physical 1
          vendor: Intel Corporation
          physical id: 108
          bus info: pci@0000:fe:02.5
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:9
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Registers
          vendor: Intel Corporation
          physical id: 109
          bus info: pci@0000:fe:03.0
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:10
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Target Address Decoder
          vendor: Intel Corporation
          physical id: 10a
          bus info: pci@0000:fe:03.1
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:11
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller RAS Registers
          vendor: Intel Corporation
          physical id: 10b
          bus info: pci@0000:fe:03.2
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:12
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Test Registers
          vendor: Intel Corporation
          physical id: 10c
          bus info: pci@0000:fe:03.4
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:13
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 0 Control
          vendor: Intel Corporation
          physical id: 10d
          bus info: pci@0000:fe:04.0
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:14
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 0 Address
          vendor: Intel Corporation
          physical id: 10e
          bus info: pci@0000:fe:04.1
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:15
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 0 Rank
          vendor: Intel Corporation
          physical id: 10f
          bus info: pci@0000:fe:04.2
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:16
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 0 Thermal Control
          vendor: Intel Corporation
          physical id: 110
          bus info: pci@0000:fe:04.3
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:17
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 1 Control
          vendor: Intel Corporation
          physical id: 111
          bus info: pci@0000:fe:05.0
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:18
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 1 Address
          vendor: Intel Corporation
          physical id: 112
          bus info: pci@0000:fe:05.1
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:19
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 1 Rank
          vendor: Intel Corporation
          physical id: 113
          bus info: pci@0000:fe:05.2
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:20
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 1 Thermal Control
          vendor: Intel Corporation
          physical id: 114
          bus info: pci@0000:fe:05.3
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:21
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 2 Control
          vendor: Intel Corporation
          physical id: 115
          bus info: pci@0000:fe:06.0
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:22
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 2 Address
          vendor: Intel Corporation
          physical id: 116
          bus info: pci@0000:fe:06.1
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:23
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 2 Rank
          vendor: Intel Corporation
          physical id: 117
          bus info: pci@0000:fe:06.2
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:24
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 2 Thermal Control
          vendor: Intel Corporation
          physical id: 118
          bus info: pci@0000:fe:06.3
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:25
          description: Host bridge
          product: Xeon 5600 Series QuickPath Architecture Generic Non-core Registers
          vendor: Intel Corporation
          physical id: 119
          bus info: pci@0000:ff:00.0
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:26
          description: Host bridge
          product: Xeon 5600 Series QuickPath Architecture System Address Decoder
          vendor: Intel Corporation
          physical id: 11a
          bus info: pci@0000:ff:00.1
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:27
          description: Host bridge
          product: Xeon 5600 Series QPI Link 0
          vendor: Intel Corporation
          physical id: 11b
          bus info: pci@0000:ff:02.0
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:28
          description: Host bridge
          product: Xeon 5600 Series QPI Physical 0
          vendor: Intel Corporation
          physical id: 11c
          bus info: pci@0000:ff:02.1
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:29
          description: Host bridge
          product: Xeon 5600 Series Mirror Port Link 0
          vendor: Intel Corporation
          physical id: 11d
          bus info: pci@0000:ff:02.2
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:30
          description: Host bridge
          product: Xeon 5600 Series Mirror Port Link 1
          vendor: Intel Corporation
          physical id: 11e
          bus info: pci@0000:ff:02.3
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:31
          description: Host bridge
          product: Xeon 5600 Series QPI Link 1
          vendor: Intel Corporation
          physical id: 11f
          bus info: pci@0000:ff:02.4
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:32
          description: Host bridge
          product: Xeon 5600 Series QPI Physical 1
          vendor: Intel Corporation
          physical id: 120
          bus info: pci@0000:ff:02.5
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:33
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Registers
          vendor: Intel Corporation
          physical id: 121
          bus info: pci@0000:ff:03.0
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:34
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Target Address Decoder
          vendor: Intel Corporation
          physical id: 122
          bus info: pci@0000:ff:03.1
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:35
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller RAS Registers
          vendor: Intel Corporation
          physical id: 123
          bus info: pci@0000:ff:03.2
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:36
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Test Registers
          vendor: Intel Corporation
          physical id: 124
          bus info: pci@0000:ff:03.4
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:37
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 0 Control
          vendor: Intel Corporation
          physical id: 125
          bus info: pci@0000:ff:04.0
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:38
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 0 Address
          vendor: Intel Corporation
          physical id: 126
          bus info: pci@0000:ff:04.1
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:39
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 0 Rank
          vendor: Intel Corporation
          physical id: 127
          bus info: pci@0000:ff:04.2
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:40
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 0 Thermal Control
          vendor: Intel Corporation
          physical id: 128
          bus info: pci@0000:ff:04.3
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:41
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 1 Control
          vendor: Intel Corporation
          physical id: 129
          bus info: pci@0000:ff:05.0
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:42
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 1 Address
          vendor: Intel Corporation
          physical id: 12a
          bus info: pci@0000:ff:05.1
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:43
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 1 Rank
          vendor: Intel Corporation
          physical id: 12b
          bus info: pci@0000:ff:05.2
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:44
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 1 Thermal Control
          vendor: Intel Corporation
          physical id: 12c
          bus info: pci@0000:ff:05.3
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:45
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 2 Control
          vendor: Intel Corporation
          physical id: 12d
          bus info: pci@0000:ff:06.0
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:46
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 2 Address
          vendor: Intel Corporation
          physical id: 12e
          bus info: pci@0000:ff:06.1
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:47
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 2 Rank
          vendor: Intel Corporation
          physical id: 12f
          bus info: pci@0000:ff:06.2
          version: 02
          width: 32 bits
          clock: 33MHz
     *-pci:48
          description: Host bridge
          product: Xeon 5600 Series Integrated Memory Controller Channel 2 Thermal Control
          vendor: Intel Corporation
          physical id: 130
          bus info: pci@0000:ff:06.3
          version: 02
          width: 32 bits
          clock: 33MHz
  *-input:0
       product: Power Button
       physical id: 1
       logical name: input18
       logical name: /dev/input/event6
       capabilities: platform
  *-input:1
       product: Power Button
       physical id: 2
       logical name: input19
       logical name: /dev/input/event7
       capabilities: platform
  *-input:2
       product: PC Speaker
       physical id: 3
       logical name: input20
       logical name: /dev/input/event8
       capabilities: isa
root@orcus:~# 
```

## 2025-02-03 PCI info (lspci)

```text
hbarta@orcus:~$ lspci
00:00.0 Host bridge: Intel Corporation 5500 I/O Hub to ESI Port (rev 22)
00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 1 (rev 22)
00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 3 (rev 22)
00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 7 (rev 22)
00:09.0 PCI bridge: Intel Corporation 7500/5520/5500/X58 I/O Hub PCI Express Root Port 9 (rev 22)
00:13.0 PIC: Intel Corporation 7500/5520/5500/X58 I/O Hub I/OxAPIC Interrupt Controller (rev 22)
00:14.0 PIC: Intel Corporation 7500/5520/5500/X58 I/O Hub System Management Registers (rev 22)
00:14.1 PIC: Intel Corporation 7500/5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers (rev 22)
00:14.2 PIC: Intel Corporation 7500/5520/5500/X58 I/O Hub Control Status and RAS Registers (rev 22)
00:14.3 PIC: Intel Corporation 7500/5520/5500/X58 I/O Hub Throttle Registers (rev 22)
00:16.0 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
00:16.1 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
00:16.2 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
00:16.3 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
00:16.4 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
00:16.5 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
00:16.6 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
00:16.7 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 22)
00:1a.0 USB controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #4
00:1a.1 USB controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #5
00:1a.2 USB controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #6
00:1a.7 USB controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2
00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 1
00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 5
00:1c.5 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 6
00:1d.0 USB controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #1
00:1d.1 USB controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #2
00:1d.2 USB controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #3
00:1d.7 USB controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA AHCI Controller
00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
04:00.0 Serial Attached SCSI controller: Broadcom / LSI SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 03)
06:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
07:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
08:01.0 VGA compatible controller: Matrox Electronics Systems Ltd. MGA G200eW WPCM450 (rev 0a)
fe:00.0 Host bridge: Intel Corporation Xeon 5600 Series QuickPath Architecture Generic Non-core Registers (rev 02)
fe:00.1 Host bridge: Intel Corporation Xeon 5600 Series QuickPath Architecture System Address Decoder (rev 02)
fe:02.0 Host bridge: Intel Corporation Xeon 5600 Series QPI Link 0 (rev 02)
fe:02.1 Host bridge: Intel Corporation Xeon 5600 Series QPI Physical 0 (rev 02)
fe:02.2 Host bridge: Intel Corporation Xeon 5600 Series Mirror Port Link 0 (rev 02)
fe:02.3 Host bridge: Intel Corporation Xeon 5600 Series Mirror Port Link 1 (rev 02)
fe:02.4 Host bridge: Intel Corporation Xeon 5600 Series QPI Link 1 (rev 02)
fe:02.5 Host bridge: Intel Corporation Xeon 5600 Series QPI Physical 1 (rev 02)
fe:03.0 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Registers (rev 02)
fe:03.1 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Target Address Decoder (rev 02)
fe:03.2 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller RAS Registers (rev 02)
fe:03.4 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Test Registers (rev 02)
fe:04.0 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 0 Control (rev 02)
fe:04.1 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 0 Address (rev 02)
fe:04.2 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 0 Rank (rev 02)
fe:04.3 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 0 Thermal Control (rev 02)
fe:05.0 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 1 Control (rev 02)
fe:05.1 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 1 Address (rev 02)
fe:05.2 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 1 Rank (rev 02)
fe:05.3 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 1 Thermal Control (rev 02)
fe:06.0 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 2 Control (rev 02)
fe:06.1 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 2 Address (rev 02)
fe:06.2 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 2 Rank (rev 02)
fe:06.3 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 2 Thermal Control (rev 02)
ff:00.0 Host bridge: Intel Corporation Xeon 5600 Series QuickPath Architecture Generic Non-core Registers (rev 02)
ff:00.1 Host bridge: Intel Corporation Xeon 5600 Series QuickPath Architecture System Address Decoder (rev 02)
ff:02.0 Host bridge: Intel Corporation Xeon 5600 Series QPI Link 0 (rev 02)
ff:02.1 Host bridge: Intel Corporation Xeon 5600 Series QPI Physical 0 (rev 02)
ff:02.2 Host bridge: Intel Corporation Xeon 5600 Series Mirror Port Link 0 (rev 02)
ff:02.3 Host bridge: Intel Corporation Xeon 5600 Series Mirror Port Link 1 (rev 02)
ff:02.4 Host bridge: Intel Corporation Xeon 5600 Series QPI Link 1 (rev 02)
ff:02.5 Host bridge: Intel Corporation Xeon 5600 Series QPI Physical 1 (rev 02)
ff:03.0 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Registers (rev 02)
ff:03.1 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Target Address Decoder (rev 02)
ff:03.2 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller RAS Registers (rev 02)
ff:03.4 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Test Registers (rev 02)
ff:04.0 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 0 Control (rev 02)
ff:04.1 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 0 Address (rev 02)
ff:04.2 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 0 Rank (rev 02)
ff:04.3 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 0 Thermal Control (rev 02)
ff:05.0 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 1 Control (rev 02)
ff:05.1 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 1 Address (rev 02)
ff:05.2 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 1 Rank (rev 02)
ff:05.3 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 1 Thermal Control (rev 02)
ff:06.0 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 2 Control (rev 02)
ff:06.1 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 2 Address (rev 02)
ff:06.2 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 2 Rank (rev 02)
ff:06.3 Host bridge: Intel Corporation Xeon 5600 Series Integrated Memory Controller Channel 2 Thermal Control (rev 02)
hbarta@orcus:~$ 
```