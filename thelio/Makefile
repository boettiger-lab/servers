PHONY: network caddy rstudio rstudio2 monitor gitlab
HERE=$(shell pwd)
USER_HOME=/home/cboettig/rstudio

nvidia_stable:
	sudo nvidia-ctk system create-dev-char-symlinks --create-all

#network: 
#	docker network create -d bridge host


caddy: 
	docker run --name caddy \
	--detach \
	--publish 0.0.0.0:80:80 \
	--publish 0.0.0.0:443:443 \
	--restart always \
	-v ${HERE}/Caddyfile:/etc/caddy/Caddyfile \
	-v ${HERE}/.caddy/:/data \
	--network host \
	caddy

jupyter_vol: 
	docker volume create jupyter

jupyter: jupyter_vol
	docker run --name jupyter \
	-detach \
	--pull always \
  --restart always \
	--network host \
	--volume jupyter_vol:/home/joyvan \
	--gpus all \
	--shm-size=20gb \
	--memory 48g \
	--device /dev/nvidiactl:/dev/nvidiactl --device /dev/nvidia-uvm:/dev/nvidia-uvm --device /dev/nvidia0:/dev/nvidia0 \
	pangeo/pytorch-notebook  jupyter lab --ip=0.0.0.0

# https://github.com/NVIDIA/nvidia-docker/issues/1671 NVML: Unknown error
rstudio:
	docker run --name rstudio \
	-detach \
	--pull always \
  --restart always \
	--env-file private_env.sh \
	-v ${HERE}/services.d/cron:/etc/services.d/cron \
	-v ${USER_HOME}:/home \
	--network host \
	--gpus all \
	--shm-size=18gb \
	--memory 52g \
	--security-opt seccomp=unconfined \
	--device /dev/nvidiactl:/dev/nvidiactl --device /dev/nvidia-uvm:/dev/nvidia-uvm --device /dev/nvidia0:/dev/nvidia0 \
	rocker/ml-verse 

# see docker run section on https://github.com/netdata/netdata/blob/132dbd5af4e150757ae6f32dc31f4d3933aedc91/collectors/python.d.plugin/nvidia_smi/README.md
monitor: 
	docker run --name monitor \
	--detach \
	--pull always \
	--gpus all \
	--restart always \
  -e NETDATA_EXTRA_APK_PACKAGES=gcompat \
  --cap-add SYS_PTRACE \
	-v /proc:/host/proc:ro \
	-v /sys:/host/sys:ro \
	-v /etc/os-release:/host/etc/os-release:ro \
	-v /var/run/docker.sock:/var/run/docker.sock:ro \
	-v ${HERE}/netdata.conf:/etc/netdata/netdata.conf \
	--network host \
	netdata/netdata

# NVME drive via MINIO connection
minio: 
	docker run --name minio \
	--pull always \
	--restart always \
	--detach \
	--env-file minio_env.sh \
	--network host \
	-v ${USER_HOME}/shared-data:/data \
	quay.io/minio/minio server /data --address ":9002" --console-address ":9001"		


hash-archive:
	docker run --name hash-archive \
	--detach \
	-v ${USER_HOME}/hash-archive.db:/hash-archive/hash-archive.db \
	--network host \
	-e URL=hash-archive.thelio.carlboettiger.info \
	cboettig/hash-archive


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
	-v urap:/home \
	-v ${HERE}/urap_users.sh:/etc/cont-init.d/addusers \
	--network host \
	-p 8787:8989 \
	--device /dev/nvidiactl:/dev/nvidiactl --device /dev/nvidia-uvm:/dev/nvidia-uvm --device /dev/nvidia0:/dev/nvidia0 \
	--gpus all \
	rocker/ml-verse

## configure prometheus.yml first!  see MINIO configuration
prometheus:
	docker run \
	--name prometheus \
	--detach \
	--restart always \
	--network host \
	-v ${HERE}/prometheus.yml:/etc/prometheus/prometheus.yml \
	prom/prometheus

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
		-e RUNNER_ORGANIZATION_URL=https://github.com/espm-288 \
		rocker/safe-runner

## occassional use, internal only
mysql: 
	docker run --name mariadb \
		-d -e MYSQL_ROOT_PASSWORD=password \
		--network host \
		--restart always \
		mariadb:latest

## container registry service
zot_vol:
	docker volume create zot_vol

zot: zot_vol
	docker run --name zot --network host \
	-v zot_vol:/var/lib/registry \
	-v ${HERE}/zot_config.json:/etc/zot/config.json \
	-v ${HERE}/zot.htpasswd:/etc/zot/htpasswd \
	--detach ghcr.io/project-zot/zot-linux-amd64:latest



#########################################################################
###### not currently active  ############################################
#########################################################################

vault: 
	docker run --name vault \
		--detach \
		--network host \
		--cap-add=IPC_LOCK \
		-v /opt/vault/data:/vault/data \
		-v ${HERE}/vault.hcl:/vault/config/config.hcl \
		-e VAULT_ADDR=https://vault.thelio.carlboettiger.info \
		vault server



shiny:
	docker run --name shiny \
	--detach \
	--pull always \
	--restart always \
	--network host \
	rocker/shiny-verse

gitlab:
	docker run --name gitlab \
	--restart always \
	--detach \
	--network host \
	--hostname gitlab.carlboettiger.info \
	-v /data/gitlab/config:/etc/gitlab \
	-v /data/gitlab/logs:/var/log/gitlab \
	-v /data/gitlab/data:/var/opt/gitlab \
	--shm-size 256m \
	gitlab/gitlab-ee

aqueduct:
	docker run --name aqueduct \
	--detach \
	--network host \
	aqueduct

