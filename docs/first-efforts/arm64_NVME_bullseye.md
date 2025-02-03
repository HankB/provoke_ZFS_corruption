# ARM64 Pi CM4 test with older kernel

Testing with an older distro, trying Bullseye.

First try, Bullseye did not boot from NVME. Now installing to SD to see if that boots on a CM4.

## 2024-12-12 build data source

Use the Ansible playbooks in <https://github.com/HankB/polana-ansible>.

```text
ansible-playbook provision-Debian.yml -b -K --extra-vars "ssd_dev=/dev/sdc \
    os_image=/home/hbarta/Downloads/Pi/Debian/20230102_raspi_4_bullseye.img.xz \
    new_host_name=io poolname=io_tank part_prefix=""\
    eth_mac=dc:a6:32:bf:65:b1 wifi_mac=dc:a6:32:bf:65:b2"
```

1. The playbook failed because resize of the root fs fails on a 32GB SD card.
1. No Bullseye image I have can boot a CM4.

End of this investigation for now.
