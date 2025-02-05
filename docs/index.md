# Blog version of provoke_ZFS_corruption

* Github: <https://github.com/HankB/provoke_ZFS_corruption/tree/main>
* Blog: <https://HankB.github.io/provoke_ZFS_corruption/>
* [Update on methodology](./methodology.md)

Directory of tests starting with preliminary exploration.

|started|completed|results|ZFS ver|OS|kernel ver|notes|
|---|---|---|---|---|---|---|
|2025-02-03|2025-02-04|[corruption](./tests/2025-02-03_methodology/results.md)|zfs-2.1.11-1+deb12u1|Debian 12|6.1.0-30-amd64|methodology exploration|
|2025-02-05||[in progress](./tests/2025-02-05_methodology/setup.md)|zfs-2.1.11-1+deb12u1|Debian 12|6.1.0-30-amd64|methodology exploration|


## 2025-02-04 process improvements

These have worked, producing corruption in less than a day. This should shorten testing time and also proves that the H/W in use will produce corruption using current Debian kernel and ZFS. [More details](./tests/2025-02-03_methodology/results.md)
