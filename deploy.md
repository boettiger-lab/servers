  # From scratch deployment on a new server
  
  - PopOS! 22.04
  
  - Add my public key to ssh:
  
```
sudo apt update && sudo apt install gpg ssh
mkdir -p ~/.ssh
gpg --recv 3908E1CFD28B380C
gpg --export-ssh-key 3908E1CFD28B380C >> ~/.ssh/authorized_keys
```


- Edit `/etc/hostname`

- install & configure `ufw`, `sshd`:

```
sudo apt update && sudo apt install ufw ssh
```


- [install docker](https://docs.docker.com/engine/install/ubuntu/)
- install & configure nvidia container toolkit: 

```
sudo apt update && sudo apt install nvidia-container-toolkit
```

