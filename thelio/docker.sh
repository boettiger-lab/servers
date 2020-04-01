#!/bin/bash

HERE=$(pwd)

docker network create -d bridge thelio-net

docker run --name caddy \
	-d -p 0.0.0.0:80:80 \
	-d -p 0.0.0.0:443:443 \
	--restart always \
	-e ACME_AGREE=true \
	-v $HERE/site/Caddyfile:/etc/Caddyfile \
	-v $HERE/.caddy/:/root/caddy \
    -v /zpool/content-store:/www/data.carlboettiger.info \
	--network thelio-net \
	abiosoft/caddy

docker run --name rstudio \
	-d \
	--env-file private_env.sh \
	-v $HERE/addusers.sh:/etc/cont-init.d/addusers \
	-v /var/rstudio/data:/home \
	--restart always \
	--gpus all \
	--network thelio-net \
	rocker/ml:3.6.2-gpu

docker run --name monitor \
    -d \
    --restart always \
    --cap-add SYS_PTRACE \
    -v /proc:/host/proc:ro \
    -v /sys:/host/sys:ro \
    -v $HERE/netdata.conf:/etc/netdata/netdata.conf \
    --network thelio-net \
    titpetric/netdata


docker run --name rstudio2 \
	-d \
	--env-file private_env.sh \
	-v $HERE/addusers.sh:/etc/cont-init.d/addusers \
	-v /var/rstudio/data:/home \
    -v /zpool:/zpool \
	--restart always \
	--gpus all \
	--network thelio-net \
	rocker/ml:3.6.3-gpu



