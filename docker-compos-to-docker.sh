#!/bin/bash

docker rm -f $(docker ps -a -q) && docker rmi -f $(docker images -a -q)

docker run -d --name celerybroker redis:3.0.7
docker run -d --name smtp tianon/exim4
docker run -d -v /var/lib/cabotdb:/var/lib/postgresql --name db -e "POSTGRES_USER=docker" -e "POSTGRES_PASSWORD=docker" postgres:9.5.2

#docker run -d --link celerybroker:celerybroker -e CELERY_BROKER_URL=redis://celerybroker:6379/1 --name celery_app celery

docker build --no-cache -t app --file=Dockerfile .

docker run -d --name app --link db:db --link celerybroker:celerybroker --link smtp:smtp --env-file=`pwd`/conf/production.env.example -p 5000:5000 app

#docker run    --link celerybroker:celerybroker -e CELERY_BROKER_URL=redis://celerybroker:6379/1 --rm celery celery status
