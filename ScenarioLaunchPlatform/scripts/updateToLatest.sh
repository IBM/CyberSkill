#!/bin/bash
#Remove the previous latest
rm -f /opt/slp/latest.tar

cd /opt/slp
#Download the new latest
wget https://raw.githubusercontent.com/IBM/CyberSkill/refs/heads/main/ScenarioLaunchPlatform/latest/latest.tar

#extract and overwrite
tar -xvf latest.tar --overwrite

#kill the previous running job
pkill -f slp-0.0.1-SNAPSHOT.jar

#run the new jar
nohup java -jar slp-0.0.1-SNAPSHOT.jar &
