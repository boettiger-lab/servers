.PHONY: network caddy rstudio rstudio2 monitor gitlab
#HERE=$(pwd)

HERE=/home/cboettig/Documents/servers/thelio

network: 
	docker network create -d bridge thelio-net

oldcaddy: 
	docker run --name caddy \
	--detach \
	--publish 0.0.0.0:80:80 \
	--publish 0.0.0.0:443:443 \
	--restart always \
	-e ACME_AGREE=true \
	-v ${HERE}/site/Caddyfile:/etc/Caddyfile \
	-v ${HERE}/.caddy/:/root/caddy \
	-v /zpool/minio/content-store:/www/data.carlboettiger.info \
	--network thelio-net \
	abiosoft/caddy
## Needs very recent linux kernel, see:
## See: https://github.com/golang/go/wiki/LinuxKernelSignalVectorBug
caddy: 
	docker run --name caddy \
	--detach \
	--publish 0.0.0.0:80:80 \
	--publish 0.0.0.0:443:443 \
	--restart always \
	-v ${HERE}/site/Caddyfile_v2:/etc/caddy/Caddyfile \
	-v ${HERE}/.caddy/:/data \
	--network thelio-net \
	caddy



rstudio:
	docker run --name rstudio \
	--detach \
	--env-file private_env.sh \
	-v ${HERE}/addusers.sh:/etc/cont-init.d/addusers \
	-v /var/rstudio/data:/home \
	-v /zpool/minio/content-store:/zpool/content-store \
	-v /zpool/scratch:/zpool/scratch \
	--restart always \
	--gpus all \
	--network thelio-net \
	rockerdev/ml:4.0.0-cuda-10.0

monitor: 
	docker run --name monitor \
	--detach \
	--restart always \
	--cap-add SYS_PTRACE \
	-v /proc:/host/proc:ro \
	-v /sys:/host/sys:ro \
	-v /var/run/docker.sock:/var/run/docker.sock:ro \
	-v ${HERE}/netdata.conf:/etc/netdata/netdata.conf \
	--network thelio-net \
	netdata/netdata


rstudio2: 
	docker run --name rstudio2 \
	--detach \
	--env-file private_env.sh \
	-v ${HERE}/addusers.sh:/etc/cont-init.d/addusers \
	-v /var/rstudio/data:/home \
 	-v /zpool/minio/content-store:/zpool/content-store \
	-v /zpool/scratch:/zpool/scratch \
	--restart always \
	--gpus all \
	--network thelio-net \
	rockerdev/ml:4.0.0-cuda-10.2

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

minio: 
	docker run --name minio \
	  --detach \
	  --restart always \
	  --env-file minio_env.sh \
	  --network thelio-net \
	  -v /zpool/minio:/data \
	  minio/minio server /data

## minio client for making edits
minio-mc:
	docker run --name minio-mc \
		--rm -t -i \
		--network thelio-net \
		-v ${HERE}/minio-mc-config.json:/root/.mc/config.json \
		--entrypoint /bin/sh \
		minio/mc

