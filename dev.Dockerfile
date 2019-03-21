FROM node:8
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.0.list
RUN apt-get update
RUN apt-get install -y --force-yes mongodb-org=3.0.7 mongodb-org-server=3.0.7 mongodb-org-shell=3.0.7 mongodb-org-mongos=3.0.7 mongodb-org-tools=3.0.7 nasm
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

WORKDIR /usr/app

COPY . .
RUN npm ci

EXPOSE 9229 8080 3001

CMD npm run dev
