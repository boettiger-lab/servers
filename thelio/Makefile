.PHONY: network caddy rstudio rstudio2 monitor gitlab
HERE=$(shell pwd)
MINIO=/zpool/minio
USER_HOME=/var/rstudio/data

network: 
	docker network create -d bridge thelio-net

caddy: 
	docker run --name caddy \
	--detach \
	--publish 0.0.0.0:80:80 \
	--publish 0.0.0.0:443:443 \
	--restart always \
	-v ${HERE}/Caddyfile:/etc/caddy/Caddyfile \
	-v ${HERE}/.caddy/:/data \
	--network thelio-net \
	caddy

rstudio:
	docker run --name rstudio \
	--detach \
	--env-file private_env.sh \
	-v ${HERE}/addusers.sh:/etc/cont-init.d/addusers \
	-v ${USER_HOME}:/home \
        -v ${MINIO}:/minio \
	--gpus all \
	--network thelio-net \
	rocker/ml-verse:4.0.2-cuda10.1

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

hash-archive:
	docker run --name hash-archive \
	--detach \
	-v /zpool/hash-archive.db:/hash-archive/hash-archive.db \
	--network thelio-net \
	-e URL=hash-archive.thelio.carlboettiger.info \
	cboettig/hash-archive

rstudio2: 
	docker run --name rstudio2 \
	--detach \
	--env-file private_env.sh \
	-v ${HERE}/addusers.sh:/etc/cont-init.d/addusers \
	-v ${USER_HOME}:/home \
        -v ${MINIO}:/minio \
	--network thelio-net \
	rocker/ml-verse:4.0.2-cuda10.1

gitlab:
	docker run --name gitlab \
	--detach \
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
	  --env-file minio_env.sh \
	  --network thelio-net \
	  -v ${MINIO}:/data \
	  minio/minio server /data

## minio client for making edits
minio-mc:
	docker run --name minio-mc \
		--rm -t -i \
		--network thelio-net \
		-v ${HERE}/minio-mc-config.json:/root/.mc/config.json \
		--entrypoint /bin/sh \
		minio/mc

