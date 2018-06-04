# RStudio server deployment

Setup `docker-compose` includes: 

- RStudio server using [rocker-project.org](https://rocker-project.org)
- Reverse proxy with automatic https using [Caddy](https://caddyserver.com) 
- Server monitoring using [netdata](https://github.com/firehol/netdata/)


## Deploy Instructions:

- Put a password  in format `PASSWORD=mypasswordhere` in a `private_env.sh` file (or edit the `docker-compose.yml`
- Edit `site/Caddyfile` to use your own registered domain names (in place of `44-core.carlboettiger.info`) and email (in place of `tls cboettig@gmail.com`)

***Note:*** This setup requires you have a domain name.  If you just want to deploy the RStudio environment without the https proxy and monitoring, just deploy as a standard rocker image,
e.g. 

```
docker run -e PASSWORD=mypasswordhere -p 8787:80 -d rocker/geospatial
```

See <https://rocker-project.org> for details.  

