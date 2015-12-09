FROM ubuntu:trusty


MAINTAINER David Fernandez <i.am.david.fernandez@gmail.com>


## Specify build arguments.
ARG APT_PROXY=""
ARG TIMEZONE=""


## Set timezone
RUN echo "Configuring timezone [${TIMEZONE}]" \
    && echo "${TIMEZONE}" > /etc/timezone \
    && dpkg-reconfigure --frontend noninteractive tzdata


## Setup apt proxy and base apt sources
RUN echo "Configuring apt [${APT_PROXY}]..." \
    && echo "${APT_PROXY}" >> /etc/apt/apt.conf.d/00proxy \
    && echo "" > /etc/apt/sources.list \
    && echo "deb http://archive.ubuntu.com/ubuntu trusty main restricted" >> /etc/apt/sources.list \
    && echo "deb http://archive.ubuntu.com/ubuntu trusty-updates main restricted" >> /etc/apt/sources.list \
    && echo "deb http://archive.ubuntu.com/ubuntu trusty universe" >> /etc/apt/sources.list \
    && echo "deb http://archive.ubuntu.com/ubuntu trusty-updates universe" >> /etc/apt/sources.list \
    && echo "deb http://archive.ubuntu.com/ubuntu trusty multiverse" >> /etc/apt/sources.list \
    && echo "deb http://archive.ubuntu.com/ubuntu trusty-updates multiverse" >> /etc/apt/sources.list \
    && echo "deb http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://security.ubuntu.com/ubuntu trusty-security main" >> /etc/apt/sources.list \
    && echo "deb http://security.ubuntu.com/ubuntu trusty-security universe" >> /etc/apt/sources.list \
    && echo "deb http://security.ubuntu.com/ubuntu trusty-security multiverse" >> /etc/apt/sources.list \
    && echo "Complete"


## <DF> This is mostly kept here for reference and as a template/guide for inheriting Dockerfiles.
## Install application
RUN echo "Installing..." \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y mc tree \
    && DEBIAN_FRONTEND=noninteractive apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Complete"


CMD ["/bin/bash"]
