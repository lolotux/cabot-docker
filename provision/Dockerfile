# Cabot Dockerfile
#
# https://github.com/shoonoise/cabot-docker
#
# VERSION 1.1

FROM ubuntu:trusty
MAINTAINER laurent besson <lolotux@gmail.com>

# Prepare
RUN apt-get update
RUN apt-get install -y build-essential nodejs npm libpq-dev python-pip python-dev apt-utils nano
RUN apt-get install -y git curl libldap2-dev libsasl2-dev iputils-ping gunicorn m4 ruby texinfo libbz2-dev libcurl4-openssl-dev libexpat-dev libncurses-dev zlib1g-dev

# add lolo
RUN pip install setuptools
RUN pip install setuptools --upgrade

RUN curl -OL https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py

# Deploy cabot
#RUN git clone https://github.com/arachnys/cabot.git
ADD ./cabot/ /cabot/
ADD fixture.json /cabot/
ADD run.sh /cabot/
ADD gunicorn.conf /cabot/gunicorn.conf

# Install dependencies
RUN pip install -e /cabot/
RUN npm install --no-color -g coffee-script less@1.3 --registry http://registry.npmjs.org/

# Set env var
ENV PATH $PATH:/cabot/
ENV PYTHONPATH $PYTHONPATH:/cabot/

# Cabot settings
ENV DJANGO_SETTINGS_MODULE cabot.settings
ENV HIPCHAT_URL https://api.hipchat.com/v1/rooms/message
ENV LOG_FILE /var/log/cabot
ENV PORT 5000
ENV ADMIN_EMAIL laurent.besson@pmsipilot.com
ENV CABOT_FROM_EMAIL noreply@example.com
ENV DEBUG t
ENV DB_HOST db
ENV DB_PORT 5432
ENV DB_USER docker
ENV DB_PASS docker
ENV TERM xterm

ENV DJANGO_SECRET_KEY 2FL6ORhHwr5eX34pP9mMugnIOd3jzVuT45f7w430Mt5PnEwbcJgma0q8zUXNZ68A

# Used for pointing links back in alerts etc.
ENV WWW_HTTP_HOST localhost
ENV WWW_SCHEME http

RUN ["ln","-s","/usr/bin/nodejs","/usr/bin/node"]

EXPOSE 5000

WORKDIR /cabot/
CMD . /cabot/run.sh
