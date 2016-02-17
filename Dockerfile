FROM ubuntu:14.04

MAINTAINER Konstantin Shcherban version: 0.1

COPY script.sh /usr/bin/buildpydeb.sh

RUN chmod +x /usr/bin/buildpydeb.sh

RUN sed -i 's/archive/ru.archive/' /etc/apt/sources.list

RUN echo nameserver 8.8.8.8 > /etc/resolv.conf
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    debhelper \
    dh-python \
    python-all-dev \
    python-all-dbg \
    python3-all-dev \
    python3-all-dbg \
    python-setuptools \
    python3-setuptools \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

