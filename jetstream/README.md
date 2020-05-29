# RStudio server deployment

Setup `docker-compose` includes: 

- RStudio server using [rocker-project.org](https://rocker-project.org)
- Reverse proxy with automatic https using [Caddy](https://caddyserver.com) 
- Server monitoring using [netdata](https://github.com/firehol/netdata/)
- GitLab server
- Databases (MonetDB)

## Deploy Instructions:

- Put a password  in format `PASSWORD=mypasswordhere` in a `private_env.sh` file (or edit the `docker-compose.yml`
- Edit `site/Caddyfile` to use your own registered domain names (in place of `*.carlboettiger.info`) and email 

Bring up the system with `./docker.sh` (or run any part individually).  Use of `docker-compose` is deprecated now due to lack of support for GPU. 


***Note:*** This setup requires you have a domain name.  If you just want to deploy the RStudio environment without the https proxy and monitoring, just deploy as a standard rocker image,
e.g. 

```
docker run -e PASSWORD=mypasswordhere -p 8787:80 -d rocker/geospatial
```

See <https://rocker-project.org> for details.  

