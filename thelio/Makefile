.PHONY: network caddy rstudio rstudio2 monitor gitlab


network: 
	docker network create -d bridge thelio-net

oldcaddy: 
	docker run --name caddy \
	-d -p 0.0.0.0:80:80 \
	-d -p 0.0.0.0:443:443 \
	--restart always \
	-e ACME_AGREE=true \
	-v $(pwd)/site/Caddyfile:/etc/Caddyfile \
	-v $(pwd)/.caddy/:/root/caddy \
    -v /zpool/content-store:/www/data.carlboettiger.info \
	--network thelio-net \
	abiosoft/caddy

caddy: 
	docker run --name caddy \
	-d -p 0.0.0.0:80:80 \
	-d -p 0.0.0.0:443:443 \
	--restart always \
	-v $(pwd)/site/Caddyfile:/etc/caddy/Caddyfile \
	-v $(pwd)/.caddy/:/data \
    -v /zpool/content-store:/usr/share/caddy/data.carlboettiger.info \
	--network thelio-net \
	caddy/caddy


rstudio:
	docker run --name rstudio \
	-d \
	--env-file private_env.sh \
	-v $(pwd)/addusers.sh:/etc/cont-init.d/addusers \
	-v /var/rstudio/data:/home \
    -v /zpool/content-store:/zpool/content-store \
	-v /zpool/scratch:/zpool/scratch \
	--restart always \
	--gpus all \
	--network thelio-net \
	rocker/ml:3.6.3-gpu

monitor: 
	docker run --name monitor \
    -d \
    --restart always \
    --cap-add SYS_PTRACE \
    -v /proc:/host/proc:ro \
    -v /sys:/host/sys:ro \
	-v /var/run/docker.sock:/var/run/docker.sock:ro \
	-v $(pwd)/netdata.conf:/etc/netdata/netdata.conf \
    --network thelio-net \
    netdata/netdata


rstudio2: 
	docker run --name rstudio2 \
	-d \
	--env-file private_env.sh \
	-v /var/rstudio/data:/home \
    -v /zpool/content-store:/zpool/content-store \
	-v /zpool/scratch:/zpool/scratch \
	--restart always \
	--gpus all \
	--network thelio-net \
	rocker/ml:3.6.3-gpu

gitlab:
	docker run --name gitlab \
	--detach \
	--restart always \
	--network thelio-net \
	--hostname gitlab.carlboettiger.info \
	-e GITLAB_OMNIBUS_CONFIG="external_url 'http://gitlab.carlboettiger.info'; nginx['listen_port'] = 8081; gitlab_rails['lfs_embedded'] = true; gitlab_rails['gitlab_shell_ssh_port'] = 2224" \
    -v /srv/gitlab/config:/etc/gitlab \
    -v /srv/gitlab/logs:/var/log/gitlab \
    -v /zpool/gitlab/data:/var/opt/gitlab \
	gitlab/gitlab-ce:latest


