#!/bin/bash

SUBGIT_USER=${SUBGIT_USER:-subgit}
SUBGIT_UID=${SUBGIT_UID:-1000}
SUBGIT_HOME=${SUBGIT_HOME:-/home/subgit}

CHECK_TIME=${CHECK_TIME:-30}

# Make sure user exist
if ! grep $SUBGIT_USER /etc/passwd; then
    useradd --no-create-home --home-dir $SUBGIT_HOME --system --uid $SUBGIT_UID --shell /bin/bash $SUBGIT_USER
fi

# Make sure user has access to it's home
mkdir -p $SUBGIT_HOME
chown $SUBGIT_USER $SUBGIT_HOME

cd /repo.git

export _JAVA_OPTIONS='-Djsse.enableSNIExtension=false'
sudo -u $SUBGIT_USER -E subgit install .
if [ $? -ne 0 ]; then
    echo "Error while executing subgit install"
    exit 1
fi

tail -f -F /repo.git/subgit/logs/daemon.0.log &

if [ -x "/repo.git/hooks/post-svn-update" ]; then

    if [ -z "$PREVENT_FIRST_RUN" ]; then
        echo "Test post-svn-update hook execution"
        sudo -u $SUBGIT_USER -E /repo.git/hooks/post-svn-update
    fi

    # Configure incron
    echo $SUBGIT_USER > /etc/incron.allow
    mkdir -p /var/spool/incron
    echo "/repo.git/refs/svn/map IN_MODIFY /run-hook.sh post-svn-update" >> /var/spool/incron/$SUBGIT_USER

    # Launch incron
    incrond
    if [ $? -ne 0 ]; then
        echo "unable to start incron"
        exit 1
    fi
fi

while true; do
    DAEMON_PID=$(head -1 /repo.git/subgit/daemon.pid)
    if [ -z "$DAEMON_PID" ]; then
        echo "Unable to get the PID of the subgit daemon"
        exit 1
    fi

    kill -0 $DAEMON_PID
    if [ $? -ne 0 ]; then
        echo "subgit daemon is dead"
        exit 1
    fi

    # Fallback if incron is not working (NFS for instance)
    if [ -x "/repo.git/hooks/post-svn-update" ]; then
        sudo -u $SUBGIT_USER -E /repo.git/hooks/post-svn-update
    fi

    sleep $CHECK_TIME
done

