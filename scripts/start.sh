#!/bin/bash 
#START METHOD FOR THE FIRST INDEXING OF OPENGROK
start_opengrok(){
    # wait for tomcat startup
    while ! ( ps aux|grep -q org.apache.catalina.startup.Bootstrap ); do
        sleep 1;
    done
    OpenGrok index /src
}

#START ALL NECESSARY SERVICES.
start_opengrok &
cron &
/usr/sbin/sshd -D &
catalina.sh run
