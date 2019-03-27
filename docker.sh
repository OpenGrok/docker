#!/bin/bash

#
# Build and push new image to Docker hub.
#

set -e

# Get the latest OpenGrok version string.
VERSION=`curl -sS https://api.github.com/repos/oracle/opengrok/releases/latest | jq -er .tag_name`
echo "Latest OpenGrok tag: $VERSION"

docker build -t opengrok/docker:$VERSION .
docker run -d opengrok/docker
docker ps -a

# The DOCKER_* variables are setup via https://travis-ci.com/OpenGrok/docker/settings
if [ -n "$DOCKER_PASSWORD" -a -n "$DOCKER_USERNAME" -a -n "$VERSION" ]; then
	echo "Pushing image for version $VERSION"
	echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
	docker push opengrok/docker:$VERSION
fi
