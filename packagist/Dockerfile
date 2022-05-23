FROM dockette/php:8.0-fpm

LABEL maintainer="sulcmil@gmail.com" authors="sulcmil@gmail.com,rakushinav@modeltech.ru"

ENV SSH_ENABLED=true
ENV USER_ID=82
ENV USER_NAME=www-data
ENV USER_WORKDIR=/var/www
ENV PACKAGIST_DIR=/srv
ENV NODE_VERSION=16.13.0
ENV CRON_LOG_FILE=/var/log/cron.log


RUN apt-get update -y && \
apt-get install supervisor nginx cron nodejs vim -y && \
mv /etc/php/8.0/mods-available/xmlrpc.ini  /etc/php/8.0/ && \
git clone -b solr_new https://github.com/ModelTech/packagist.git /srv



RUN composer install -d /srv --no-dev --no-interaction --no-scripts -v -o
# PHP
# WEB
ADD ./dist.env.local /srv/.env.local
ADD ./web/app_dev.php /srv/web/app_dev.php
ADD ./php/php-fpm.conf /usr/local/etc/php-fpm.conf

# NGINX
ADD ./nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./nginx/mime.types /etc/nginx/mime.types
ADD ./nginx/sites/dev.conf /etc/nginx/sites.d/dev.conf
ADD ./nginx/sites/stable.conf /etc/nginx/sites.d/stable.conf

# SSH
ADD ./ssh /tpl/ssh

# Cron
ADD ./cron/root /etc/crontab
ADD ./cron/packagist /etc/periodic/onemin/packagist
RUN crontab /etc/crontab && \
 chmod 600 /etc/crontab && \
 chmod 600 /etc/periodic/onemin/packagist && \
 chmod +x /etc/periodic/onemin/packagist

# Supervisor
ADD ./supervisor/supervisord.conf /etc/supervisord.conf

WORKDIR /srv

RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

RUN npm install && npm run-script build
EXPOSE 80

ADD ./entrypoint.sh /
CMD /entrypoint.sh
