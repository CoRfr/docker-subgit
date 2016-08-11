FROM java:8-jre

ENV SUBGIT_VERSION      3.2.1

# Dependencies
RUN ( apt-get update && \
      apt-get install -y git subversion wget incron sudo && \
      rm -rf /var/lib/apt/lists/* )

# Download from official website and install
RUN ( wget -O subgit.deb -q http://old.subgit.com/download/subgit_${SUBGIT_VERSION}_all.deb && \
      dpkg -i subgit.deb && \
      rm -f subgit.deb )

VOLUME /repo.git
WORKDIR /repo.git

ADD entrypoint.sh /
ADD run-hook.sh /
ENTRYPOINT /entrypoint.sh

