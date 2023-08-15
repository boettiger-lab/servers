## nvidia driver mismatch

Restart NVIDIA drivers without rebooting machine: 

https://stackoverflow.com/a/45319156/258662

Stop all GPU-binding tasks:

```
sudo lsof /dev/nvidia*
```

Then remove all nvidia modules:

```
lsmod | grep nvidia
```

e.g.

```
sudo rmmod nvidia_drm
sudo rmmod nvidia_modeset
sudo rmmod nvidia_uvm
sudo rmmod nvidia
```

confirm `nvidia-smi` now works.

## hot-swap harddisk

confirm hot-swap supported by kernel / bios

```
lspci -k | grep ahci
```

should show 

```
    Kernel driver in use: ahci
```

may be necessary to activate if not active already:

```
sudo partprobe
```


Check hardware list:

```
sudo lshw | less
```

ATA drives section should list all hardware.  e.g. here we see the newly swapped in drive (`/dev/sdc` is not yet mounted:

```
  *-disk:0
                   description: ATA Disk
                   product: ST5000LM000-2AN1
                   physical id: 0
                   bus info: scsi@0:0.0.0
                   logical name: /dev/sda
                   logical name: /mnt/disk1
                   version: 0001
                   serial: WCJ159M5
                   size: 4657GiB (5TB)
                   configuration: ansiversion=5 logicalsectorsize=512 mount.fstype=xfs mount.options=rw,nosuid,nodev,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota sectorsize=4096 state=mounted
              *-disk:1
                   description: ATA Disk
                   product: ST5000LM000-2AN1
                   physical id: 1
                   bus info: scsi@1:0.0.0
                   logical name: /dev/sdb
                   logical name: /mnt/disk2
                   version: 0001
                   serial: WCJ4GMQY
                   size: 4657GiB (5TB)
                   configuration: ansiversion=5 logicalsectorsize=512 mount.fstype=xfs mount.options=rw,nosuid,nodev,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota sectorsize=4096 state=mounted
              *-disk:2
                   description: ATA Disk
                   product: ST5000LM000-2AN1
                   physical id: 2
                   bus info: scsi@4:0.0.0
                   logical name: /dev/sdc
                   version: 0001
                   serial: WCJ72DLM
                   size: 4657GiB (5TB)
                   configuration: ansiversion=5 logicalsectorsize=512 sectorsize=4096
              *-disk:3
                   description: ATA Disk
                   product: ST5000LM000-2AN1
                   physical id: 3
                   bus info: scsi@5:0.0.0
                   logical name: /dev/sdd
                   logical name: /mnt/disk4
                   version: 0001
                   serial: WCJ3389N
                   size: 4657GiB (5TB)
                   configuration: ansiversion=5 logicalsectorsize=512 mount.fstype=xfs mount.options=rw,nosuid,nodev,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota sectorsize=4096 state=mounted
```

Note bus number of the new dsik (disk 2) is "4".  

It may be necessary to format the new drive (we use `xfs` type, for best performance with MINIO).

```
sudo mkfs.xfs /dev/sdc
```

mount the new drive: 

```
mount /dev/sdc /mnt/disk3
```


(mount by uuid instead?)

```
blkid /dev/sdc
mount -o UUID=<paste-UUID-here> /mnt/disk3
```

Add drive to fstab to mount automatically on reboot.  

<https://serverfault.com/questions/5336/how-do-i-make-linux-recognize-a-new-sata-dev-sda-drive-i-hot-swapped-in-without>

