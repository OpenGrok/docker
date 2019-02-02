# A Docker container for OpenGrok

## OpenGrok from official source:

Directly downloaded from official source:
https://github.com/oracle/opengrok/releases/

You can learn more about OpenGrok at http://oracle.github.io/opengrok/

The container is available from DockerHub at https://hub.docker.com/r/opengrok/docker/

## When not to use it

This image is simple wrapper around OpenGrok environment. The indexer and the web container are **not** tuned for large workloads. If you happen to have either large source data (e.g. [AOSP](https://en.wikipedia.org/wiki/Android_Open_Source_Project) or the like) or stable service or both, it is advisable to run the service standalone.

Also, the image is not capable of source data synchronization. This means the inconsistency time window when index is not consistent with source data can be quite large. This can lead to problems. It is recommended to run the indexer (see below on how to do that) immediately after source data is changed.

## Additional info about the container:

* Tomcat 9
* JRE 8 (Required for Opengrok 1.0+)
* Configurable reindexing (default every 10 min)

The indexer is set so that it does not log into files.

## How to run:

The container exports ports 8080 for OpenGrok.

    docker run -d -v <path/to/your/src>:/opengrok/src -p 8080:8080 opengrok/docker:latest

The volume mounted to `/opengrok/src` should contain the projects you want to make searchable (in sub directories). You can use common revision control checkouts (git, svn, etc...) and OpenGrok will make history and blame information available.

By default, the index will be rebuild every ten minutes. You can adjust this time (in Minutes) by passing the `REINDEX` environment variable:

    docker run -d -e REINDEX=30 -v <path/to/your/src>:/opengrok/src -p 8080:8080 opengrok/docker:latest

Setting `REINDEX` to `0` will disable automatic indexing. You can manually trigger an reindex using docker exec:

    docker exec <container> /scripts/index.sh

Setting `INDEXER_OPT` could pass extra options to opengrok-indexer. For example, you can run with:

    docker run -d -e INDEXER_OPT="-i d:vendor" -v <path/to/your/src>:/src -p 8080:8080 opengrok/docker:latest

To remove all the `*/vendor/*` files from the index. You can check the indexer options on

https://github.com/oracle/opengrok/wiki/Python-scripts-transition-guide

## OpenGrok Web-Interface

The container has OpenGrok as default web app installed (accessible directly from `/`). With the above container setup, you can find it running on

http://localhost:8080/

Please note: on first startup, the web interface will display empty content
until the indexing has been completed. Give it some time (depending on the
amount of data indexed - might take many hours for large code bases !) and reload.

The subsequent reindex will be incremental so will take signigicantly less time.

## Inspecting the container

You can get inside a container using the [command below](https://docs.docker.com/engine/reference/commandline/exec/):

```
docker exec -it <container> bash
```

Enjoy.
