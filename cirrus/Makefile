.PHONY: network caddy rstudio rstudio2 monitor gitlab
HERE=$(shell pwd)
MINIO=/minio
USER_HOME=/minio/home


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
	docker run \
		--pull always \
		--name rstudio \
		--detach \
		-p 0.0.0.0:2220:22 \
		--restart always \
		--env-file private_env.sh \
		-v ${HERE}/addusers.sh:/etc/cont-init.d/addusers \
		-v ${USER_HOME}:/home \
		-v /var/log/tensorboard:/var/log/tensorboard \
		--memory 200g \
		--shm-size=65gb \
		--device /dev/nvidiactl:/dev/nvidiactl \
		--device /dev/nvidia-uvm:/dev/nvidia-uvm \
		--device /dev/nvidia0:/dev/nvidia0 \
		--device /dev/nvidia1:/dev/nvidia1 \
		--gpus all \
		--network cirrus-net \
		rocker/ml-verse:4.2.1-cuda11.1

rstudio3:
	docker run \
		--name rstudio3 \
		--detach \
		--restart always \
		--env-file private_env.sh \
		-v rstudio3-volume:/home \
		-v ${HERE}/addusers.sh:/etc/cont-init.d/addusers \
		-v /var/log/tensorboard:/var/log/tensorboard \
		--memory 200g \
		--shm-size=65gb \
		--device /dev/nvidiactl:/dev/nvidiactl --device /dev/nvidia-uvm:/dev/nvidia-uvm --device /dev/nvidia0:/dev/nvidia0 \
		--gpus all \
		--network cirrus-net \
		rocker/ml-verse


spatial:
	docker run \
		--name spatial \
		--detach \
		--pull always \
		--restart always \
		--env-file private_env.sh \
		-v ${HERE}/addusers.sh:/etc/cont-init.d/addusers \
		--memory 200g \
		--shm-size=65gb \
		--device /dev/nvidiactl:/dev/nvidiactl --device /dev/nvidia-uvm:/dev/nvidia-uvm --device /dev/nvidia0:/dev/nvidia0 \
		--gpus all \
		--network cirrus-net \
		rocker/geospatial:dev-osgeo

	##		rocker/geospatial:dev-osgeo


marcus:
	docker run \
		--pull always \
		--name marcus \
		--detach \
		-p 0.0.0.0:2222:22 \
		--restart always \
		--env-file private_env.sh \
		-v ${HERE}/addusers.sh:/etc/cont-init.d/addusers \
		-v ${USER_HOME}:/home \
		-v /var/log/tensorboard:/var/log/tensorboard \
		--memory 200g \
		--shm-size=65gb \
		--device /dev/nvidiactl:/dev/nvidiactl --device /dev/nvidia-uvm:/dev/nvidia-uvm --device /dev/nvidia0:/dev/nvidia0 \
		--device /dev/nvidia1:/dev/nvidia1 \
		--gpus all \
		--network cirrus-net \
		rocker/ml-verse:4.2.1-cuda11.1


urap: 
	docker volume create urap


rstudio3-volume: 
	docker volume create rstudio3-volume 




rstudio2:
	docker run --name rstudio2 \
		--pull always \
		--restart always \
		--detach \
		--device /dev/nvidiactl:/dev/nvidiactl --device /dev/nvidia-uvm:/dev/nvidia-uvm --device /dev/nvidia0:/dev/nvidia0 \
		--env-file private_env.sh \
		-v ${HERE}/urap.sh:/etc/cont-init.d/addusers \
		-v /var/log/tensorboard:/var/log/tensorboard \
		-v urap:/home \
		--memory 50g \
		--shm-size=20gb \
		--network cirrus-net \
		--gpus 1 \
		-p 0.0.0.0:2221:22 \
		rocker/ml-verse


millie_home:
	docker volume create millie_home

millie:
	docker run --name millie \
		--env-file millie_env.sh \
		--pull always \
		--restart always \
		--detach \
		-v /var/log/tensorboard:/var/log/tensorboard \
		-v millie_home:/home/mille \
		--memory 100g \
		--network cirrus-net \
		--device /dev/nvidiactl:/dev/nvidiactl --device /dev/nvidia-uvm:/dev/nvidia-uvm --device /dev/nvidia0:/dev/nvidia0 \
		--gpus 0 \
		-p 0.0.0.0:2223:22 \
		rocker/geospatial


## Get host PGID from: 
##     grep docker /etc/group | cut -d ':' -f 3 

monitor:
	docker run -d --name=monitor \
		--pull always \
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
		--pull always \
		--restart always \
		--detach \
		--env-file minio_env.sh \
		--network cirrus-net \
		-v /mnt/disk1:/data1 \
		-v /mnt/disk2:/data2 \
		-v /mnt/disk3:/data3 \
		-v /mnt/disk4:/data4 \
		-v /mnt/disk5:/data5 \
		-v /mnt/disk6:/data6 \
		-v /mnt/disk7:/data7 \
		-v /mnt/disk8:/data8 \
		quay.io/minio/minio server /data{1...8} --console-address ":9001"	  

nvme: 
	docker run --name nvme \
		--pull always \
		--restart always \
		--detach \
		--env-file minio_env_nvme.sh \
		--network cirrus-net \
		-v /mnt/nvme2:/data1 \
		-v /mnt/nvme3:/data2 \
		quay.io/minio/minio server /data{1...2} --console-address ":9001"	  


prometheus:
	docker run \
		--name prometheus \
		--detach \
		--restart always \
		--network cirrus-net \
		-v ${HERE}/prometheus.yml:/etc/prometheus/prometheus.yml \
		prom/prometheus

hash-archive:
	docker run --name hash-archive \
		--detach \
		--restart always \
		-v ${MINIO}/hash-archive/hash-archive.db:/hash-archive/hash-archive.db \
		--network cirrus-net \
		-e URL=hash-archive.carlboettiger.info \
		cboettig/hash-archive

# NOTE: after launching container, you will need to do: 
# docker exec -ti <container> bash
#  /entrypoint.sh XXXX
# where XXXX is your GITHUB_ACCESS_TOKEN

github-runner:
	docker run \
		--restart always \
		--memory 5g \
		--name github-runner \
		--detach \
		-e RUNNER_NAME=cirrus1 \
		-e RUNNER_ORGANIZATION_URL=https://github.com/espm-157 \
		rocker/safe-runner

github-runner2:
	docker run \
		--restart always \
		--memory 5g \
		--name github-runner2 \
		--detach \
		-e RUNNER_NAME=cirrus2 \
		-e RUNNER_ORGANIZATION_URL=https://github.com/espm-157 \
		rocker/safe-runner

github-runner3:
	docker run \
		--restart always \
		--memory 5g \
		--name github-runner3 \
		--detach \
		-e RUNNER_NAME=cirrus3 \
		-e RUNNER_ORGANIZATION_URL=https://github.com/espm-288 \
		rocker/safe-runner


