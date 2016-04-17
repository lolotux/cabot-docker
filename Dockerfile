# Cabot Dockerfile
#
# https://github.com/shoonoise/cabot-docker
#
# VERSION 1.1

FROM debian:jessie

MAINTAINER Alexander Kushnarev <avkushnarev@gmail.com>
MAINTAINER Industrialisation Team <industrialisation@pmsipilot.com>

# Prepare
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && echo "deb http://debian.ens-cachan.fr/ftp/debian/ jessie main contrib non-free" > /etc/apt/sources.list \
&& apt-get update && apt-get install -y python-pip python-dev gunicorn nodejs npm curl libpq-dev libldap2-dev libsasl2-dev

RUN pip install --upgrade pip && pip install setuptools --upgrade

# Deploy cabot
ADD ./ /opt/cabot/

# Install dependencies
RUN pip install -e /opt/cabot/
RUN npm install --no-color -g coffee-script less@1.3 --registry http://registry.npmjs.org/


# Set env var
ENV PATH $PATH:/opt/cabot/
ENV PYTHONPATH $PYTHONPATH:/opt/cabot/

# Cabot settings
ENV DJANGO_SETTINGS_MODULE cabot.settings
ENV HIPCHAT_URL https://api.hipchat.com/v1/rooms/message
ENV LOG_FILE /dev/stdout
ENV PORT 5000
ENV ADMIN_EMAIL administrateur@pmsipilot.com
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

WORKDIR /opt/cabot/
CMD . /opt/cabot/provision/run.sh
