  # From scratch deployment on a new server
  
  - Ubuntu 20.04 LTS, or PopOS! 20.04 / 20.10
  
  - Add my public key to ssh:
  
```
sudo apt update && sudo apt install gpg ssh
gpg --recv 3908E1CFD28B380C
gpg --export-ssh-key 3908E1CFD28B380C >> ~/.ssh/authorized_keys
```


- configure `ufw`, `fail2ban`, `tripwire`, `sshd`


- install docker (ubuntu-packaged one is new enough now)

```
sudo apt install docker.io
```

- install nividia-docker2 for GPU use:

(Docker and NVIDIA install scripts don't recongize popOS, and support only back to Ubuntu 20.04 (which actually points to 18.04 build anyway):

```
distribution=ubuntu20.04 \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
```
may need to manually correct `$(ARCH)` to `amd64` in sources.  
