#!/bin/bash

cd /repo.git

subgit install .
if [ $? -ne 0 ]; then
    echo "Error while executing subgit install"
    exit 1
fi

tail -f /repo.git/subgit/logs/daemon.0.log &

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

    sleep 30
done

