FROM debian:jessie

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    debhelper \
    dh-python \
    ca-certificates \
    build-essential \
    python-all-dev \
    python-all-dbg \
    python3-all-dev \
    python3-all-dbg \
    python-setuptools \
    python3-setuptools \
    python-pip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

COPY script.sh /usr/bin/buildpydeb.sh
RUN chmod +x /usr/bin/buildpydeb.sh

ENTRYPOINT ["/usr/bin/buildpydeb.sh"]
