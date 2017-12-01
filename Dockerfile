FROM ubuntu:16.04 AS build

ARG no_proxy
ARG http_proxy

ENV http_proxy ${http_proxy}
ENV https_proxy ${http_proxy}
ENV no_proxy ${no_proxy}
ENV DEBIAN_FRONTEND noninteractive

# Install build dependencies
RUN apt-get update \
    && apt-get install -y \
        build-essential \
        curl \
        xz-utils \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Get golang
RUN curl -sSLO https://redirector.gvt1.com/edgedl/go/go1.9.2.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf /go1.9.2.linux-amd64.tar.gz
ENV PATH ${PATH}:/usr/local/go/bin

# Get quorum sources
RUN curl -sSLO https://github.com/jpmorganchase/quorum/archive/v2.0.0.tar.gz \
    && mkdir /quorum && tar -C /quorum --strip-components=1 -xzf v2.0.0.tar.gz

# Build quorum
RUN cd /quorum && make all

# Get constellation
RUN curl -sSLO https://github.com/jpmorganchase/constellation/releases/download/v0.2.0/constellation-0.2.0-ubuntu1604.tar.xz \
    && mkdir /constellation && tar -C /constellation --strip-components=1 -xJf /constellation-0.2.0-ubuntu1604.tar.xz

########################################################################################################################

# Final image
FROM ubuntu:16.04
RUN apt-get update \
    && apt-get install -y \
        libdb5.3 \
        libgmp10 \
        libleveldb1v5 \
        libsodium18 \
        libtinfo5 \
        zlib1g \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY --from=build /constellation/* /usr/local/bin/
COPY --from=build /quorum/build/bin/* /usr/local/bin/
