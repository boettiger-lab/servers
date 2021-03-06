.PHONY: network caddy rstudio rstudio2 monitor gitlab
HERE=$(shell pwd)
ZPOOL=/vol_c/user-home

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
	-v /home/cboettig/users:/home \
	--restart always \
	--network jetstream-net \
	rocker/geospatial



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

hash-archive:
	docker run --name hash-archive \
		--detach \
		--restart always \
		-v ${ZPOOL}/hash-archive.db:/hash-archive/hash-archive.db \
		--network jetstream-net \
		-e URL=hash-archive.jetstream.carlboettiger.info \
		cboettig/hash-archive

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


