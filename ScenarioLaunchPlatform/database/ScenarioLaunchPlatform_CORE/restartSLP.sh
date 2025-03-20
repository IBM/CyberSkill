#!/bin/bash

BASE_PATH="/opt/slp"

cd $BASE_PATH
echo "Killing current running version of jar file at : $(date)" >> /var/log/slpapprun.log
pkill -9 -f slp-0.0.1-SNAPSHOT.jar
echo "Running new updated version of jar file at : $(date)" >> /var/log/slpapprun.log
nohup java -jar slp-0.0.1-SNAPSHOT.jar  > /dev/null 2>&1 &