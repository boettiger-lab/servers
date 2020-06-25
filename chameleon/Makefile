.PHONY: network caddy rstudio rstudio2 monitor gitlab
HERE=$(shell pwd)
ZPOOL=/zpool/user-home

network: 
	docker network create -d bridge chameleon-net

caddy: 
	docker run --name caddy \
	--detach \
	--publish 0.0.0.0:80:80 \
	--publish 0.0.0.0:443:443 \
	--restart always \
	-v ${HERE}/Caddyfile:/etc/caddy/Caddyfile \
	-v ${HERE}/.caddy/:/data \
	--network chameleon-net \
	caddy

rstudio:
	docker run --name rstudio \
	--detach \
	--env-file private_env.sh \
	-v ${HERE}/addusers.sh:/etc/cont-init.d/addusers \
	-v ${ZPOOL}:/home \
	--restart always \
	--network chameleon-net \
	rocker/geospatial:4.0.0

monitor: 
	docker run --name monitor \
	--detach \
	--restart always \
        --security-opt apparmor=unconfined \
	--cap-add SYS_PTRACE \
	-v /proc:/host/proc:ro \
	-v /sys:/host/sys:ro \
	-v /var/run/docker.sock:/var/run/docker.sock:ro \
	--network chameleon-net \
	netdata/netdata


hash-archive:
	docker run --name hash-archive \
	--detach \
	--restart always \
	-v ${ZPOOL}/hash-archive.db:/hash-archive/hash-archive.db \
	--network chameleon-net \
	-e URL=hash-archive.carlboettiger.info \
	cboettig/hash-archive

minio: 
	docker run --name minio \
	  --detach \
	  --restart always \
	  --env-file minio_env.sh \
	  --network chameleon-net \
	  -v ${ZPOOL}:/data \
	  minio/minio server /data




