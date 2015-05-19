FROM ubuntu:14.04

ENV SUBGIT_VERSION  2.0.3

# Dependencies
RUN ( apt-get update && \
      apt-get install -y git subversion openjdk-7-jre-headless wget ) 

# Download from official website and install
RUN ( wget -O subgit.deb -q http://old.subgit.com/download/subgit_${SUBGIT_VERSION}_all.deb && \
      dpkg -i subgit.deb )

VOLUME /git

CMD [ "subgit", "install", "/git" ]

