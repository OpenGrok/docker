#!/bin/bash
#START METHOD FOR INDEXING OF OPENGROK
start_opengrok(){
    # wait for tomcat startup
    date +"%F %T Waiting for tomcat startup.."
    while ! ( grep -q "org.apache.catalina.startup.Catalina.start Server startup"  /usr/local/tomcat/logs/catalina.*.log ); do
        sleep 1;
    done
    date +"%F %T Startup finished.."
    /scripts/index.sh
}

#START ALL NECESSARY SERVICES.
start_opengrok &
catalina.sh run &
cron &
/usr/sbin/sshd -D
