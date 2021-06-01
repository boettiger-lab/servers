.PHONY: network caddy rstudio rstudio2 monitor gitlab
HERE=$(shell pwd)
MINIO=/minio
USER_HOME=/minio/home
URAP_HOME=/minio/users
network: 
	docker network create -d bridge cirrus-net

caddy: 
	docker run --name caddy \
	--detach \
	--publish 0.0.0.0:80:80 \
	--publish 0.0.0.0:443:443 \
	--restart always \
	-v ${HERE}/Caddyfile:/etc/caddy/Caddyfile \
	-v ${HERE}/.caddy/:/data \
	--network cirrus-net \
	caddy

rstudio:
	docker run --name rstudio \
	--detach \
	--restart always \
	--env-file private_env.sh \
	-v ${HERE}/addusers.sh:/etc/cont-init.d/addusers \
	-v ${USER_HOME}:/home \
        -v ${MINIO}:/minio \
	-v /var/log/tensorboard:/var/log/tensorboard \
        --memory 200g \
	--gpus all \
	--network cirrus-net \
	rocker/ml-verse:4.0.3-cuda10.1

cuda:
	docker run --name cuda \
	--detach \
	--restart always \
	--env-file private_env.sh \
	-v ${HERE}/addusers.sh:/etc/cont-init.d/addusers \
	-v ${USER_HOME}:/home \
        -v ${MINIO}:/minio \
	-v /var/log/tensorboard:/var/log/tensorboard \
        --memory 100g \
	--gpus all \
	--network cirrus-net \
	rocker/ml-verse:4.1.0-cuda11.1


rstudio2:
	docker run --name rstudio2 \
	--restart always \
	--detach \
	--env-file private_env.sh \
	-v ${HERE}/urap.sh:/etc/cont-init.d/addusers \
	-v /var/log/tensorboard:/var/log/tensorboard \
	-v ${URAP_HOME}:/home \
        -v ${MINIO}:/minio \
        --memory 50g \
	--network cirrus-net \
	rocker/ml-verse:4.0.3-cuda10.1


## Get host PGID from: 
##     grep docker /etc/group | cut -d ':' -f 3 

monitor:
	docker run -d --name=monitor \
	--restart always \
	-p 19999:19999 \
	-v /proc:/host/proc:ro \
	-v /sys:/host/sys:ro \
	-v /var/run/docker.sock:/var/run/docker.sock:ro \
	-e PGID=131 \
	-e DO_NOT_TRACK= \
	--gpus all \
	--cap-add SYS_PTRACE \
	--security-opt apparmor=unconfined \
	--network cirrus-net \
	d34dc3n73r/netdata-glibc

minio: 
	docker run --name minio \
	  --restart always \
	  --detach \
	  --env-file minio_env.sh \
	  --network cirrus-net \
	  -v ${MINIO}:/data \
	  minio/minio server /data


