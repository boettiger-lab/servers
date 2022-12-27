sPHONY: network caddy rstudio rstudio2 monitor gitlab
HERE=$(shell pwd)
USER_HOME=/opt/rstudio/home
URAP_HOME=/opt/urap

network: 
	docker network create -d bridge minikube


caddy: 
	docker run --name caddy \
	--detach \
	--publish 0.0.0.0:80:80 \
	--publish 0.0.0.0:443:443 \
	--restart always \
	-v ${HERE}/Caddyfile:/etc/caddy/Caddyfile \
	-v ${HERE}/.caddy/:/data \
	--network minikube \
	caddy

shiny:
	docker run --name shiny \
	--detach \
	--pull always \
	--restart always \
	--network minikube \
	rocker/shiny-verse

rstudio:
	docker run --name rstudio \
	--detach \
	--pull always \
        --restart always \
	--env-file private_env.sh \
	-p 0.0.0.0:2220:22 \
	-v ${HERE}/services.d/cron:/etc/services.d/cron \
	-v ${HERE}/services.d/cron:/etc/services.d/tensorboard \
	-v ${HERE}/addusers.sh:/etc/cont-init.d/addusers \
	-v ${USER_HOME}:/home \
	-v /var/log/tensorboard:/var/log/tensorboard \
	--shm-size=20gb \
        --memory 48g \
	--network minikube \
	--gpus all \
	--device /dev/nvidiactl:/dev/nvidiactl --device /dev/nvidia-uvm:/dev/nvidia-uvm --device /dev/nvidia0:/dev/nvidia0 \
	rocker/ml-verse:4.2.1-cuda11.1

monitor: 
	docker run --name monitor \
	--detach \
	--pull always \
	--restart always \
	--cap-add SYS_PTRACE \
	-v /proc:/host/proc:ro \
	-v /sys:/host/sys:ro \
	-v /var/run/docker.sock:/var/run/docker.sock:ro \
	-v ${HERE}/netdata.conf:/etc/netdata/netdata.conf \
	--network minikube \
	netdata/netdata

hash-archive:
	docker run --name hash-archive \
	--detach \
	-v ${USER_HOME}/hash-archive.db:/hash-archive/hash-archive.db \
	--network minikube \
	-e URL=hash-archive.thelio.carlboettiger.info \
	cboettig/hash-archive

aqueduct:
	docker run --name aqueduct \
	--detach \
	--network minikube \
	aqueduct

urap: 
	docker volume create urap 

rstudio2: 
	docker run --name rstudio2 \
	--detach \
	--pull always \
	--restart always \
	--env-file private_env.sh \
	--memory 15g \
  	--shm-size=5.1gb \
	-v /var/log/tensorboard:/var/log/tensorboard \
	-v urap:/home \
	-v ${HERE}/urap_users.sh:/etc/cont-init.d/addusers \
	--network minikube \
	--device /dev/nvidiactl:/dev/nvidiactl --device /dev/nvidia-uvm:/dev/nvidia-uvm --device /dev/nvidia0:/dev/nvidia0 \
	--gpus all \
	rocker/ml-verse:4.2.1-cuda11.1

minio: 
	docker run --name minio \
	--detach \
	--restart always \
	--env-file minio_env.sh \
	--network minikube \
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
	--network minikube \
	-v ${HERE}/prometheus.yml:/etc/prometheus/prometheus.yml \
	prom/prometheus

#kes:
#	docker run \
#	  --name kes \
#	  --detach \
#	  --network minikube \
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
## 
## THEN RESTART the docker container to take effect!
## You will need to make a github access token with sufficient scopes.
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
	--network minikube \
	-- rocker/vscode
#	-v "${HOME}/.config:/home/rocker/.config" \
#	-v "${HOME}/.local/share/code-server:/home/rocker/.local/share/code-server" \


## occassional use, internal only
mysql: 
	docker run --name mariadb \
		-d -e MYSQL_ROOT_PASSWORD=password \
		--network minikube \
		--restart always \
		mariadb:latest

vault: 
	docker run --name vault \
		--detach \
		--network minikube \
		--cap-add=IPC_LOCK \
		-v /opt/vault/data:/vault/data \
		-v ${HERE}/vault.hcl:/vault/config/config.hcl \
		-e VAULT_ADDR=https://vault.thelio.carlboettiger.info \
		vault server


## not currently active
gitlab:
	docker run --name gitlab \
	--restart always \
	--detach \
	--network minikube \
	--hostname gitlab.carlboettiger.info \
	-v /data/gitlab/config:/etc/gitlab \
	-v /data/gitlab/logs:/var/log/gitlab \
	-v /data/gitlab/data:/var/opt/gitlab \
	--shm-size 256m \
	gitlab/gitlab-ee

