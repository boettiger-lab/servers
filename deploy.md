  # From scratch deployment on a new server
  
  - Ubuntu 20.04 LTS, or PopOS! 20.04 / 20.10
  
  - Add my public key to ssh:
  
```
sudo apt update && sudo apt install gpg ssh
gpg --recv 3908E1CFD28B380C
gpg --export-ssh-key 3908E1CFD28B380C >> ~/.ssh/authorized_keys
```

- install docker (ubuntu-packaged one is new enough now)

```
sudo apt install docker.io
```

- configure `ufw`, `fail2ban`, `tripwire`, `sshd`



