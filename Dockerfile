FROM ubuntu:14.04

ENV SUBGIT_VERSION      3.0.0

# Dependencies
RUN ( apt-get update && \
      apt-get install -y git subversion openjdk-7-jre-headless wget \
                         vim incron ) 

# Download from official website and install
RUN ( wget -O subgit.deb -q http://old.subgit.com/download/subgit_${SUBGIT_VERSION}_all.deb && \
      dpkg -i subgit.deb )

# Fix SNI error with Java 7
RUN ( sed -i '/^EXTRA_JVM_ARGUMENTS.*/a EXTRA_JVM_ARGUMENTS="$EXTRA_JVM_ARGUMENTS -Djsse.enableSNIExtension=false"' /usr/bin/subgit )

VOLUME /repo.git
WORKDIR /repo.git

ADD entrypoint.sh /
ADD run-hook.sh /
ENTRYPOINT /entrypoint.sh

