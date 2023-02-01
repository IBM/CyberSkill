FROM ubuntu:latest

WORKDIR /app
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update
#Install CouchDB
#RUN apt-get update && apt-get -y install software-properties-common apt-transport-https

#Install cURL
RUN apt-get update && apt-get -y install curl gnupg
#Install CouchDB repo key
#RUN curl https://couchdb.apache.org/repo/keys.asc | gpg --dearmor | tee /usr/share/keyrings/couchdb-archive-keyring.gpg >/dev/null 2>&1
#RUN source /etc/os-release
#RUN echo "deb [signed-by=/usr/share/keyrings/couchdb-archive-keyring.gpg] https://apache.jfrog.io/artifactory/couchdb-deb/ focal main" | tee /etc/apt/sources.list.d/couchdb.list >/dev/null

#Update
#RUN apt-get update

#Install CouchDB
#RUN apt-get update && apt-get -y install couchdb

#Install NodeJS 0.12
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && apt-get -y install nodejs curl  gnupg apt-utils
RUN apt-get update && apt-get -y install gcc g++ make
#RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null
#RUN echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list
#RUN apt-get update &&  apt-get -y install yarn
#Install nodemon
COPY . ./ 
EXPOSE 8090
EXPOSE 3000
ENTRYPOINT ["sh", "deploy.sh"]