FROM docker.io/library/ubuntu:22.04

# If default archive is too slow set a mirror
# ARG UBUNTU_MIRROR=http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/
ARG UBUNTU_MIRROR=
RUN if [ -n "$UBUNTU_MIRROR" ]; then sed -i.bak -re "s%^deb http://archive.ubuntu.com/ubuntu/%deb ${UBUNTU_MIRROR}%" /etc/apt/sources.list; fi

ARG DEBIAN_FRONTEND=noninteractive
# https://github.com/ome/omero-documentation/blob/v5.6.6/omero/sysadmins/unix/walkthrough/walkthrough_ubuntu2004.sh
RUN apt-get update -y && \
    apt-get install -y -q \
        curl \
        unzip \
        python3 \
        python3-pip \
        python3-venv \
        build-essential \
        db5.3-util \
        libbz2-dev \
        libdb5.3++-dev \
        libdb5.3-dev \
        libexpat-dev \
        libmcpp-dev \
        libssl-dev \
        mcpp \
        python3-dev \
        zlib1g-dev

ARG CXX_NO_ERRORS='-Wno-error=deprecated-declarations -Wno-error=sign-compare -Wno-error=unused-result -Wno-error=register'
ARG ICE_VERSION=3.6.5
WORKDIR /opt/setup
RUN curl -sfL https://github.com/zeroc-ice/ice/archive/refs/tags/v${ICE_VERSION}.tar.gz | tar -zx

RUN cd ice-${ICE_VERSION} && \
    sed -i.bak -e "s/-Wall -Werror/-Wall -Werror ${CXX_NO_ERRORS}/" cpp/config/Make.rules.Linux && \
    make -C cpp -j`nproc --ignore=2`
RUN cd ice-${ICE_VERSION} && \
    make -C cpp install

RUN pip3 download "zeroc-ice==${ICE_VERSION}" && \
    tar -zxf "zeroc-ice-${ICE_VERSION}.tar.gz" && \
    cd "zeroc-ice-${ICE_VERSION}" && \
    python3 setup.py bdist_wheel
