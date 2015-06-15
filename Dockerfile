FROM ubuntu:14.04

ENV SUBGIT_VERSION      3.0.0
ENV SUBGIT_EAP_REV      18
ENV SUBGIT_EAP_BUILD    3262

# Dependencies
RUN ( apt-get update && \
      apt-get install -y git subversion openjdk-7-jre-headless wget \
                         vim incron ) 

# Download from official website and install
RUN ( wget -O subgit.deb -q http://old.subgit.com/interim/${SUBGIT_VERSION}-EAP${SUBGIT_EAP_REV}/subgit_${SUBGIT_VERSION}-EAP-${SUBGIT_EAP_BUILD}_all.deb && \
      dpkg -i subgit.deb )

VOLUME /repo.git
WORKDIR /repo.git

ADD entrypoint.sh /
ADD run-hook.sh /
ENTRYPOINT /entrypoint.sh

