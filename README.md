# A docker container for opengrok 1.0!

## Opengrok release 1.0 from oficial source:
Directly downloaded from oficial source:
https://github.com/OpenGrok/OpenGrok/releases/tag/1.0

## Additional info about the container:
* SSH with root access;
* Tomcat 9
* JRE 8(Required for Opengrok 1.0);
* Preconfigured cron task for reindexing(30 min);

## How to run:
docker run -d -v <path/to/your/src>:/src -p 8080:8080 nagui/opengrok:latest

## SSH:
* user:root
* pass:root

## Default URL:
localhost:8080/source

Enjoy.
