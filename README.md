# A Docker container for OpenGrok 1.0!

## OpenGrok release 1.0 from oficial source:

Directly downloaded from official source:
https://github.com/OpenGrok/OpenGrok/releases/tag/1.0

You can learn more about OpenGrok at http://oracle.github.io/opengrok/

The container is available from DockerHub at https://hub.docker.com/r/opengrok/docker/

## Additional info about the container:

* SSH with root access
* Tomcat 9
* JRE 8 (Required for Opengrok 1.0);
* Preconfigured cron task for reindexing (every 10 min);

## How to run:

The container exports ports 8080 for OpenGrok and 22 for SSH.

    docker run -d -v <path/to/your/src>:/src -p 8080:8080 -p 2222:22 opengrok/docker:latest

The volume mounted to `/src` should contain the projects you want to make searchable (in sub directories). You can use common revision control checkouts (git, svn, etc...) and OpenGrok will make history and blame information available.

## OpenGrok Web-Interface

The container has OpenGrok as default web app installed (accessible directly from `/`). With the above container setup, you can find it running on

http://localhost:8080/

Please note: on first startup, the web interface will display an error until the indexing has been completed. Give it a few minutes and reload.

## SSH:

With the command above you can connect to localhost on port 2222 per SSH to inspect the container.

Use the following credentials to do so:

* user: `root`
* pass: `root`


Enjoy.
