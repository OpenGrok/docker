#!/bin/bash

#
# Build and push new image to Docker hub.
#
# Uses the following Travis secure variables:
#  - DOCKER_USERNAME
#  - DOCKER_PASSWORD
#  - GITHUB_TOKEN
#

set -x
set -e

# Get the latest OpenGrok version string.
curl -sS -o ver.out \
    -H "Authorization: token $GITHUB_TOKEN" \
    https://api.github.com/repos/oracle/opengrok/releases/latest
cat ver.out
VERSION=`jq -er .tag_name ver.out`
echo "Latest OpenGrok tag: $VERSION"

docker build -t opengrok/docker:$VERSION -t opengrok/docker:latest .
docker run -d opengrok/docker
docker ps -a

# The DOCKER_* variables are setup via https://travis-ci.com/OpenGrok/docker/settings
if [ -n "$DOCKER_PASSWORD" -a -n "$DOCKER_USERNAME" -a -n "$VERSION" ]; then
	echo "Pushing image for version $VERSION"
	echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
	docker push opengrok/docker:$VERSION
fi
