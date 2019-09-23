

## Setup for UPS (CyberPower)


Consider: 

- http://customlinux.blogspot.com/2013/07/setup-ups-daemon-for-cyberpower-ups.html
- https://www.pontikis.net/blog/ups-power-management-ubuntu-16.04

Get and install deb directly from: https://www.cyberpowersystems.com/products/software/power-panel-personal/
See the 2013 customlinux post for configuration details.  Short version:

After installing deb, as root, run:

```
pwrstat -status
```

Configure by editing `/etc/pwrstatd.conf`.  

