FROM ubuntu:16.04


# Use: 
# docker run -d --restart=always \
#   -e URL=hash-archive.carlboettiger.info \
#   -v hash-archive.db:/hash-archive/hash-archive.db \
#   -p 8000:8000 \
#   cboettig/hash-archive
#
# Use with reverse-proxy to provide https domain bound to hash-archive:8000


## Install dependencies
RUN apt-get -qq update && apt-get -y install build-essential automake autoconf libtool pkg-config cmake git

## Clone repo
RUN git clone https://github.com/btrask/hash-archive
## Or alternatively: 
# COPY . /hash-archive
# Can also modify web pages & config manually this way.


## Install
WORKDIR hash-archive
RUN git submodule init && git submodule update
RUN ./configure
RUN make

## Will run on localhost:8000
EXPOSE 8000

## Run `make install` at runtime so we can set URL on run instead of build
CMD sed -i "s/hash-archive.org/$URL/" src/config.h && \
  make install && \
 /usr/local/bin/hash-archive
 
