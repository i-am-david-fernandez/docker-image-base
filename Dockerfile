FROM ubuntu:xenial


MAINTAINER David Fernandez <i.am.david.fernandez@gmail.com>


## Specify build arguments (requires docker v1.9+)
## # An apt-cache proxy may be specified (especially useful for local builds),
## # such as --build-arg=APT_PROXY=Acquire::http::proxy \"http://my-proxy:3142\";
ARG APT_PROXY=""
ARG TIMEZONE=""
ARG RELEASE="xenial"


## Set timezone
## <DF> Note: setting via dpkg-reconfigure appears to be broken in Xenial, though the manual link creation works.
RUN echo "Configuring timezone [${TIMEZONE}]" \
    && echo "${TIMEZONE}" > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    #&& dpkg-reconfigure --frontend noninteractive tzdata \
    && date


## Setup apt proxy and base apt sources
RUN echo "Configuring apt [${APT_PROXY}]..." \
    && echo "${APT_PROXY}" > /etc/apt/apt.conf.d/00proxy \
    && echo "" > /etc/apt/sources.list \
    && echo "deb http://archive.ubuntu.com/ubuntu ${RELEASE} main restricted" >> /etc/apt/sources.list \
    && echo "deb http://archive.ubuntu.com/ubuntu ${RELEASE}-updates main restricted" >> /etc/apt/sources.list \
    && echo "deb http://archive.ubuntu.com/ubuntu ${RELEASE} universe" >> /etc/apt/sources.list \
    && echo "deb http://archive.ubuntu.com/ubuntu ${RELEASE}-updates universe" >> /etc/apt/sources.list \
    && echo "deb http://archive.ubuntu.com/ubuntu ${RELEASE} multiverse" >> /etc/apt/sources.list \
    && echo "deb http://archive.ubuntu.com/ubuntu ${RELEASE}-updates multiverse" >> /etc/apt/sources.list \
    && echo "deb http://archive.ubuntu.com/ubuntu ${RELEASE}-backports main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://security.ubuntu.com/ubuntu ${RELEASE}-security main" >> /etc/apt/sources.list \
    && echo "deb http://security.ubuntu.com/ubuntu ${RELEASE}-security universe" >> /etc/apt/sources.list \
    && echo "deb http://security.ubuntu.com/ubuntu ${RELEASE}-security multiverse" >> /etc/apt/sources.list \
    && echo "Complete"


## Install base packages
RUN echo "Installing..." \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
       ## Allow use of https repos
       apt-transport-https \
       ## Allow retrieval of things (such as gosu, below)
       curl \
       wget \
       ## Allow for elevated privileges where required
       sudo \
    && DEBIAN_FRONTEND=noninteractive apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Complete"


## Install gosu (see https://github.com/tianon/gosu)
RUN echo "Installing 'gosu'..." \
    && curl -o /sbin/gosu -fsSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture)" \
    && chmod +x /sbin/gosu


CMD ["/bin/bash"]
