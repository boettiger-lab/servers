.PHONY: network caddy rstudio rstudio2 monitor gitlab
HERE=$(shell pwd)
USER_HOME=/opt/rstudio/home
URAP_HOME=/opt/urap

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
    --restart always \
	--env-file private_env.sh \
	-p 0.0.0.0:2220:22 \
	-v ${HERE}/addusers.sh:/etc/cont-init.d/addusers \
	-v ${USER_HOME}:/home \
	-v /var/log/tensorboard:/var/log/tensorboard \
    --memory 35g \
	--network thelio-net \
	--gpus all \
	rocker/ml-verse:4.1.2-cuda10.1


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
	-v ${USER_HOME}/hash-archive.db:/hash-archive/hash-archive.db \
	--network thelio-net \
	-e URL=hash-archive.thelio.carlboettiger.info \
	cboettig/hash-archive

rstudio2: 
	docker run --name rstudio2 \
	--detach \
	--restart always \
	--env-file private_env.sh \
    --memory 15g \
  	-v /var/log/tensorboard:/var/log/tensorboard \
	-v ${URAP_HOME}:/home \
	-v ${HERE}/urap_users.sh:/etc/cont-init.d/addusers \
	--gpus all \
	--network thelio-net \
	rocker/ml-verse:4.1.2-cuda11.1

minio: 
	docker run --name minio \
	  --detach \
      --restart always \
	  --env-file minio_env.sh \
	  --network thelio-net \
      -v /mnt/disk1:/data1 \
      -v /mnt/disk2:/data2 \
      -v /mnt/disk3:/data3 \
      -v /mnt/disk4:/data4 \
      quay.io/minio/minio server /data{1...4} --console-address ":9001"	  

prometheus:
	docker run \
	  --name prometheus \
      --detach \
      --restart always \
	  --network thelio-net \
      -v ${HERE}/prometheus.yml:/etc/prometheus/prometheus.yml \
      prom/prometheus

#kes:
#	docker run \
#	  --name kes \
#	  --detach \
#	  --network thelio-net \
#	  -p 127.0.0.1:7373:7373 \
#	  -v ${HERE}/certs:/certs \
#	  -v ${HERE}/keys:/keys \
#	  -v ${HERE}/server-config.yml:/data/server-config.yml \
#	  -e MINIO_IDENTITY=f99b305aa6316fe2d89dec2056fa645e0fb808d9cd229816d0471e829cdcfc93 \
#	  minio/kes:v0.17.2 server --config=/data/server-config.yml --auth=off

## NOTE: after launching container, you will need to do: 
## docker exec -ti <container> bash
##  ./entrypoint.sh XXXX
## where XXXX is your GITHUB_ACCESS_TOKEN
github-runner:
	docker run \
      --restart always \
      --memory 5g \
	  --name github-runner \
	  --detach \
	  -e RUNNER_NAME=thelio1 \
	  -e RUNNER_ORGANIZATION_URL=https://github.com/espm-157 \
	  rocker/safe-runner

github-runner2:
	docker run \
      --restart always \
      --memory 5g \
	  --name github-runner2 \
	  --detach \
	  -e RUNNER_NAME=thelio2 \
	  -e RUNNER_ORGANIZATION_URL=https://github.com/espm-157 \
	  rocker/safe-runner

github-runner3:
	docker run \
      --restart always \
      --memory 5g \
	  --name github-runner3 \
	  --detach \
	  -e RUNNER_NAME=thelio3 \
	  -e RUNNER_ORGANIZATION_URL=https://github.com/espm-157 \
	  rocker/safe-runner


vscode: 
	docker run --name vscode \
	--detach \
	--restart always \
	-v ${HOME}/vscode:/home/rocker \
	 --memory 35g \
	--network thelio-net \
	-- rocker/vscode
#	-v "${HOME}/.config:/home/rocker/.config" \
#	-v "${HOME}/.local/share/code-server:/home/rocker/.local/share/code-server" \


## occassional use, internal only
mysql: 
	docker run --name mariadb \
		-d -e MYSQL_ROOT_PASSWORD=password \
		--network thelio-net \
		--restart always \
		mariadb:latest


## not currently active
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


