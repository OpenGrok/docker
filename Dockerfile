FROM debian:stable-slim as fetcher

RUN apt-get -y update && apt-get install -y curl jq wget
RUN ["/bin/bash", "-c", "set -o pipefail \
     && curl -sS https://api.github.com/repos/oracle/opengrok/releases \
     | jq -er '.[0].assets[]|select(.name|startswith(\"opengrok-1.1\"))|.browser_download_url' \
     | wget --no-verbose -i - -O opengrok.tar.gz"]

FROM tomcat:9-jre8
MAINTAINER OpenGrok developers "opengrok-dev@yahoogroups.com"

#PREPARING OPENGROK BINARIES AND FOLDERS
COPY --from=fetcher opengrok.tar.gz /opengrok.tar.gz
RUN tar -zxvf /opengrok.tar.gz && rm -f /opengrok.tar.gz && mv opengrok-* /opengrok && \
    mkdir /src && \
    mkdir /data && \
    mkdir -p /var/opengrok/etc/ && \
    ln -s /data /var/opengrok && \
    ln -s /src /var/opengrok/src

#INSTALLING DEPENDENCIES
RUN apt-get update && apt-get install -y git subversion mercurial unzip inotify-tools python3 python3-pip && \
    python3 -m pip install /opengrok/tools/opengrok-tools*
# compile and install universal-ctags
RUN apt-get install -y pkg-config autoconf build-essential && git clone https://github.com/universal-ctags/ctags /root/ctags && \
    cd /root/ctags && ./autogen.sh && ./configure && make && make install && \
    apt-get remove -y autoconf build-essential && apt-get -y autoremove && apt-get -y autoclean && \
    cd /root && rm -rf /root/ctags

#ENVIRONMENT VARIABLES CONFIGURATION
ENV SRC_ROOT /src
ENV DATA_ROOT /data
ENV OPENGROK_WEBAPP_CONTEXT /
ENV OPENGROK_TOMCAT_BASE /usr/local/tomcat
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV CATALINA_BASE /usr/local/tomcat
ENV CATALINA_HOME /usr/local/tomcat
ENV CATALINA_TMPDIR /usr/local/tomcat/temp
ENV JRE_HOME /usr
ENV CLASSPATH /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar


# custom deployment to / with redirect from /source
RUN rm -rf /usr/local/tomcat/webapps/* && \
    opengrok-deploy /opengrok/lib/source.war /usr/local/tomcat/webapps/ROOT.war && \
    mkdir "/usr/local/tomcat/webapps/source" && \
    echo '<% response.sendRedirect("/"); %>' > "/usr/local/tomcat/webapps/source/index.jsp"

# disable all file logging
ADD logging.properties /usr/local/tomcat/conf/logging.properties
RUN sed -i -e 's/Valve/Disabled/' /usr/local/tomcat/conf/server.xml

# add our scripts
ADD scripts /scripts
RUN chmod -R +x /scripts

# run
WORKDIR $CATALINA_HOME
EXPOSE 8080
CMD ["/scripts/start.sh"]
