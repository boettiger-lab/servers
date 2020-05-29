.PHONY: network caddy rstudio rstudio2 monitor gitlab
HERE=$(shell pwd)
ZPOOL=/scratch/user-home

network: 
	docker network create -d bridge jetstream-net

caddy: 
	docker run --name caddy \
	--detach \
	--publish 0.0.0.0:80:80 \
	--publish 0.0.0.0:443:443 \
	--restart always \
	-v ${HERE}/Caddyfile:/etc/caddy/Caddyfile \
	-v ${HERE}/.caddy/:/data \
	--network jetstream-net \
	caddy

rstudio:
	docker run --name rstudio \
	--detach \
	--env-file private_env.sh \
	-v ${HERE}/addusers.sh:/etc/cont-init.d/addusers \
	-v ${ZPOOL}:/home \
	--restart always \
	--network jetstream-net \
	rocker/geospatial:4.0.0

rstudio2:
	docker run --name rstudio2 \
	--detach \
	--env-file private_env.sh \
	-v ${HERE}/addusers.sh:/etc/cont-init.d/addusers \
	-v ${ZPOOL}:/home \
	--restart always \
	--network jetstream-net \
	rocker/geospatial:4.0.0


monitor: 
	docker run --name monitor \
	--detach \
	--restart always \
	--cap-add SYS_PTRACE \
	-v /proc:/host/proc:ro \
	-v /sys:/host/sys:ro \
	-v /var/run/docker.sock:/var/run/docker.sock:ro \
	--security-opt apparmor=unconfined \
	--network jetstream-net \
	netdata/netdata

minio: 
	docker run --name minio \
        --detach \
        --restart always \
        --env-file minio_env.sh \
        --network jetstream-net \
        -v ${ZPOOL}:/data \
        minio/minio server /data

minio-mc:
	docker run --name minio-mc \
        --rm -t -i \
        -v ${HERE}/minio-mc-config.json:/root/.mc/config.json \
        --network jetstream-net \
        --entrypoint /bin/sh \
        minio/mc


