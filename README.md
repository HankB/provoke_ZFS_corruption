# provoke ZFS corruption

RE: <https://github.com/openzfs/zfs/issues/12014>

Use two Raspberry Pis to attempt to provoke corruption in a reproducible way.

## Status

*  `ARM64 - Pi CM4/8GB io` On the third startup it took about one day to produce corruption. The processes that resulted in corruption have been stopped and further snapshots disabled. That host has been shut down pending a decision for further action. Detail at [second try](./second-try.md#2024-12-18-success).
* `X86_64 - J1900 host iox86` Host has been running smoothly for over a day with no curruption reported. [progress](./X86_trial_1.md).
* `ARM64 - Pi 4B/4GB namtarri` Still in prep - pool at 33% capacity. [progress](./arm64_SATA_USB_trial.md)

## Hardware

Testing has expanded to several H/W platforms.

### ARM64 - Pi CM4/8GB io

* Pi CM4 on official IO Board booting from NVME SSD (sending host)
* X86_64 host with non-encrypted single disk HDD pool. (receiving host)

Corruption was produced with about a day of testing.

### X86_64 - J1900 host iox86

* 1TB SATA SSD connected via ASMedia (on board) controller
* Partitioned for OS (minimal) and remaining space divided between two partitions.
* Send and receive operations are on the same host (as opposed to sending to a remote host.)

Corruption has not yet been produced. If this continues for another day, the test will be modified to send to a remote host (as used with `io`.)

### ARM64 - Pi 4B/4GB namtarri

* 120GB SSD repartitioned to allow 90+GB for a ZFS pool.
* Sending to the same X86_64 host as `io`.

## TODO

* Continue polishing the scripts.
* Try different ZFS versions.
* Expand testing to more H/W variations and configurations.
