#!/bin/bash

# Reindex default
if [ -z "$REINDEX" ]; then
	REINDEX=10
fi

#START METHOD FOR INDEXING OF OPENGROK
start_opengrok(){
	# Wait for Tomcat startup.
	date +"%F %T Waiting for tomcat startup..."
	while [ "`curl --silent --write-out '%{response_code}' -o /dev/null 'http://localhost:8080/'`" == "000" ]; do
		sleep 1;
	done
	date +"%F %T Startup finished"

	# Populate the webapp with bare configuration.
	BODY_INCLUDE_FILE="/data/body_include"
	if [[ -f $BODY_INCLUDE_FILE ]]; then
		mv "$BODY_INCLUDE_FILE" "$BODY_INCLUDE_FILE.orig"
	fi
	echo '<p><h1>Waiting on the initial reindex to finish.. Stay tuned !</h1></p>' > "$BODY_INCLUDE_FILE"
	/scripts/index.sh --noIndex
	rm -f "$BODY_INCLUDE_FILE"
	if [[ -f $BODY_INCLUDE_FILE.orig ]]; then
		mv "$BODY_INCLUDE_FILE.orig" "$BODY_INCLUDE_FILE"
	fi

	# Perform initial indexing.
	/scripts/index.sh
	date +"%F %T Initial reindex finished"

	# Continue to index every $REINDEX minutes.
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
