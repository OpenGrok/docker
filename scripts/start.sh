#!/bin/bash

# Reindex default
if [ -z "$REINDEX" ]; then
    REINDEX=10
fi

#START METHOD FOR INDEXING OF OPENGROK
start_opengrok(){
    # wait for tomcat startup
    date +"%F %T Waiting for tomcat startup..."
    while [ "`curl --silent --write-out '%{response_code}' -o /dev/null 'http://localhost:8080/'`" == "000" ]; do
        sleep 1;
    done
    date +"%F %T Startup finished"

    # initial indexing
    /scripts/index.sh

    # continue to index every $REINDEX minutes
    if [ "$REINDEX" == "0" ]; then
        date +"%F %T Automatic reindexing disabled"
        return
    else
        date +"%F %T Automatic reindexing in $REINDEX minutes..."
    fi
    while true; do
        sleep `expr 60 \* $REINDEX`
        /scripts/index.sh
    done
}

#START ALL NECESSARY SERVICES.
start_opengrok &
catalina.sh run
