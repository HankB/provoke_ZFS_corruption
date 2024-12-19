# provoke ZFS corruption

RE: <https://github.com/openzfs/zfs/issues/12014>

Use two Raspberry Pis to attempt to provoke corruption in a reproducible way.

## Status

## Hardware

Testing has expanded to several H/W platforms.

### ARM64 - Pi CM4/8GB io

* Pi CM4 on official IO Board booting from NVME SSD (sending host)
* X86_64 host with non-encrypted single disk HDD pool. (receiving host)

### X86_64 - J1900 host iox86

* 1TB SATA SSD connected via ASMedia (on board) controller
* Partitioned for OS (minimal) and remaining space divided between two partitions.
* Send and receive operations are on the same host (as opposed to sending to a remote host.)

### ARM64 - Pi 4B/4GB namtarri

* 120GB SSD repartitioned to allow 90+GB for a ZFS pool.
* Sending to the same X86_64 host as `io`.

## TODO

* Continue polishing the scripts.
* Try different ZFS versions.
* Expand testing to more H/W variations.
