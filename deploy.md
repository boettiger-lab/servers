  # From-scratch deployment on a new server
  
- PopOS! 22.04
  
- Add my public key to ssh:
  
```
sudo apt update && sudo apt install gpg ssh
mkdir -p ~/.ssh
gpg --recv 3908E1CFD28B380C
gpg --export-ssh-key 3908E1CFD28B380C >> ~/.ssh/authorized_keys
```

- Clone this repo for Caddyfile and Makefile (docker container) server configurations

- Edit `/etc/hostname`

- install & configure `ufw`, `sshd`:

```
sudo apt update && sudo apt install ufw ssh
```

Configure `/etc/ssh/sshd_config` appropriately



- [install docker](https://docs.docker.com/engine/install/ubuntu/)
- install & configure nvidia container toolkit: 

```
sudo apt update && sudo apt install nvidia-container-toolkit
```

## MINIO 

Redundant multi-disk deploy should be on bare-metal, because the abstraction around volumes in docker prevents MINIO from detecting disk failure appropriately after reboot (i.e. if disk fails to mount to `/mnt/disk1` after reboot, docker will create a `/mnt/disk1` on OS drive instead, and MINIO will attempt to use it.

- [Single-node, multi-drive](https://min.io/docs/minio/linux/operations/install-deploy-manage/deploy-minio-single-node-multi-drive.html)

Notes: 
- disks must have correct permissions *and be empty* when first initializing `sudo systemctrl start minio.service`.  Otherwise MINIO throws erroneous error that MINIO_VOLUMES env var is undefined.  
- set MINIO_OPTS=" --console-address :45461" since console port is otherwise randomly assigned. 
