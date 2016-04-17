#!/bin/bash

export DATABASE_URL="postgres://$DB_USER:$DB_PASS@$DB_HOST:$DB_PORT/docker"
export CELERY_BROKER_URL="redis://celerybroker:6379/1"

python manage.py collectstatic --noinput &&\
python manage.py compress --force &&\
python manage.py syncdb --noinput && \
python manage.py migrate && \
python manage.py loaddata provision/fixture.json

gunicorn cabot.wsgi:application --config conf/gunicorn.conf --log-level info --log-file /dev/stdout
#&\
#celery worker -B -A cabot --loglevel=INFO --concurrency=16 -Ofair
