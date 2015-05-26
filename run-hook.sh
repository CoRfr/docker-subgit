#!/bin/bash

CURRENT_SVN=$(cat /repo.git/refs/svn/map)
LAST_SVN=$(cat /tmp/last-svn-map)

if [[ "$LAST_SVN" == $CURRENT_SVN ]]; then
    exit 0
fi

echo "Run hook: $CURRENT_SVN"
echo $CURRENT_SVN > /tmp/last-svn-map

/repo.git/hooks/$1

