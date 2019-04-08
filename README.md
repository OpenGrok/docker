[![Travis status](https://travis-ci.com/OpenGrok/docker.svg?branch=master)](https://travis-ci.com/OpenGrok/docker)

# A Docker container for OpenGrok

## OpenGrok from official source:

Directly downloaded from official source:
https://github.com/oracle/opengrok/releases/

You can learn more about OpenGrok at http://oracle.github.io/opengrok/

The container is available from DockerHub at https://hub.docker.com/r/opengrok/docker/

## When not to use it

This image is simple wrapper around OpenGrok environment. The indexer and the web container are **not** tuned for large workloads. If you happen to have either large source data (e.g. [AOSP](https://en.wikipedia.org/wiki/Android_Open_Source_Project) or the like) or stable service or both, it is advisable to run the service standalone.

## Additional info about the container:

* Tomcat 9
* JRE 8 (Required for Opengrok 1.0+)
* Configurable mirroring/reindexing (default every 10 min)

The mirroring step works by going through all projects and attempting to
synchronize all its repositories (e.g. it will do `git pull` for Git
repositories).

The indexer/mirroring is set so that it does not log into files.

## How to run:

The container exports ports 8080 for OpenGrok.

    docker run -d -v <path/to/your/src>:/opengrok/src -p 8080:8080 opengrok/docker:latest

The volume mounted to `/opengrok/src` should contain the projects you want to make searchable (in sub directories). You can use common revision control checkouts (git, svn, etc...) and OpenGrok will make history and blame information available.

By default, the index will be rebuild every ten minutes. You can adjust this
time (in minutes) by passing the `REINDEX` environment variable:

    docker run -d -e REINDEX=30 -v <path/to/your/src>:/opengrok/src -p 8080:8080 opengrok/docker:latest

Setting `REINDEX` to `0` will disable automatic indexing. You can manually trigger an reindex using docker exec:

    docker exec <container> /scripts/index.sh

Setting `INDEXER_OPT` could pass extra options to opengrok-indexer. For example, you can run with:

    docker run -d -e INDEXER_OPT="-i d:vendor" -v <path/to/your/src>:/opengrok/src -p 8080:8080 opengrok/docker:latest

To remove all the `*/vendor/*` files from the index. You can check the indexer options on

https://github.com/oracle/opengrok/wiki/Python-scripts-transition-guide

To avoid the mirroring step, set the `NOMIRROR` variable to non-empty value.

## OpenGrok Web-Interface

The container has OpenGrok as default web app installed (accessible directly from `/`). With the above container setup, you can find it running on

http://localhost:8080/

The first reindex will take some time to finish. Subsequent reindex will be incremental so will take signigicantly less time.

## Inspecting the container

You can get inside a container using the [command below](https://docs.docker.com/engine/reference/commandline/exec/):

```
docker exec -it <container> bash
```

Enjoy.
