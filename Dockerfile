FROM node:9 AS base
RUN apt-get update
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
#RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list
RUN apt-get update
RUN apt-get -y install vim-tiny
#RUN vim /etc/apt/sources.list.d/mongodb-org-3.2.list
RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list
RUN apt-get update
RUN apt-get install -y mongodb-org=3.2.10 mongodb-org-server=3.2.10 mongodb-org-shell=3.2.10 mongodb-org-mongos=3.2.10 mongodb-org-tools=3.2.10



WORKDIR /usr/app
RUN npm set progress=false && \
    npm config set depth 0
COPY . .

FROM base as dependencies
RUN npm install && \
    npm run buildprod && \
    NODE_ENV=production npm prune

FROM base AS release
RUN npm install forever -g --silent
COPY --from=dependencies /usr/app .
EXPOSE 8081
CMD forever ./server.js
