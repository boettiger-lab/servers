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
	-v ${HERE}/urap_users.sh:/etc/cont-init.d/addusers \
	--network thelio-net \
	rocker/ml-verse:4.0.2-cuda10.1

gitlab:
	docker run --name gitlab \
	-ti \
	--network thelio-net \
	--hostname gitlab.carlboettiger.info \
	-e GITLAB_OMNIBUS_CONFIG="external_url 'http://gitlab.carlboettiger.info'; nginx['listen_port'] = 8081; gitlab_rails['lfs_embedded'] = true; gitlab_rails['gitlab_shell_ssh_port'] = 2224" \
	-v /data/gitlab/config:/etc/gitlab \
	-v /data/gitlab/logs:/var/log/gitlab \
	-v /data/gitlab/data:/var/opt/gitlab \
	gitlab/gitlab-ce:13.3.5-ce.0

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

mysql: 
	docker run --name mariadb \
		-d -e MYSQL_ROOT_PASSWORD=password \
		--network thelio-net \
		--restart always \
		mariadb:10.5


## NOTE: after launching container, you will need to do: 
## docker exec -ti <container> bash
## GITHUB_ACCESS_TOKEN=XXXX ./entrypoint.sh
github-runner:
	docker run \
	  --name github-runner \
	  --detach \
	  -e RUNNER_NAME=thelio1 \
	  -e RUNNER_ORGANIZATION_URL=https://github.com/espm-157 \
	 rocker/safe-runner

github-runner2:
	docker run \
	  --name github-runner2 \
	  --detach \
	  -e RUNNER_NAME=thelio2 \
	  -e RUNNER_ORGANIZATION_URL=https://github.com/espm-157 \
	 rocker/safe-runner

github-runner3:
	docker run \
	  --name github-runner3 \
	  --detach \
	  -e RUNNER_NAME=thelio3 \
	  -e RUNNER_ORGANIZATION_URL=https://github.com/espm-157 \
	 rocker/safe-runner

github-runner4:
	docker run \
	  --name github-runner4 \
	  --detach \
	  -e RUNNER_NAME=thelio4 \
	  -e RUNNER_ORGANIZATION_URL=https://github.com/espm-157 \
	 rocker/safe-runner

github-runner5:
	docker run \
	  --name github-runner5 \
	  --detach \
	  -e RUNNER_NAME=thelio5 \
	  -e RUNNER_ORGANIZATION_URL=https://github.com/espm-157 \
	 rocker/safe-runner


github-runner6:
	docker run \
	  --name github-runner6 \
	  --detach \
	  -e RUNNER_NAME=thelio6 \
	  -e RUNNER_ORGANIZATION_URL=https://github.com/espm-157 \
	 rocker/safe-runner


