#!/bin/sh

#start postgreSQL
echo "starting postgreSQL ... "

service postgresql start
echo "started postgreSQL"

echo "sleep 45 seconds to give DB the time to start"

sleep 45

echo "running create tables command"
PGPASSWORD=password psql CAP capuser -f  /opt/tomcat/webapps/TradCTF/dbSQL/runFirstcreateTables.sql 
echo "running create tables complete"

echo "running store procedures command"
PGPASSWORD=password psql CAP capuser -f  /opt/tomcat/webapps/TradCTF/dbSQL/runSecondstoredProcedures.sql 
echo "running store procedures complete"


echo "running level Inserts command"
PGPASSWORD=password psql CAP capuser -f  /opt/tomcat/webapps/TradCTF/dbSQL/runThirdLevelInserts.sql 
echo "running level Inserts complete"
