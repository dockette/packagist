FROM dockette/alpine:3.7

MAINTAINER Milan Sulc <sulcmil@gmail.com>

ENV SSH_ENABLED=true
ENV USER_ID=82
ENV USER_NAME=www-data
ENV USER_WORKDIR=/var/www
ENV PACKAGIST_DIR=/srv
ENV CRON_LOG_FILE=/var/log/cron.log

RUN apk update && \
    echo '@testing http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    echo '@community http://nl.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories && \
    apk upgrade && \
    # USER #####################################################################
    addgroup -g ${USER_ID} -S ${USER_NAME} && \
    adduser -u ${USER_ID} -D -h ${USER_WORKDIR} -S -G ${USER_NAME} ${USER_NAME} && \
    # DEPENDENCIES #############################################################
    apk add --update \
    git \
    mercurial \
    curl \
    bash \
    supervisor \
    openssl \
    openssh \
    nginx \
    php7@testing \
    php7-bcmath@testing \
    php7-bz2@testing \
    php7-calendar@testing \
    php7-ctype@testing \
    php7-curl@testing \
    php7-dom@testing \
    php7-fileinfo@testing \
    php7-fpm@testing \
    php7-gd@testing \
    php7-iconv@testing \
    php7-imap@testing \
    php7-intl@testing \
    php7-json@testing \
    php7-mbstring@testing \
    php7-mcrypt@testing \
    php7-mysqli@testing \
    php7-mysqlnd@testing \
    php7-openssl@testing \
    php7-phar@testing \
    php7-pdo@testing \
    php7-pdo_mysql@testing \
    php7-session@testing \
    php7-simplexml@testing \
    php7-tokenizer@testing \
    php7-xmlwriter@testing \
    php7-zip@testing \
    php7-xml@testing \
    php7-xmlreader@testing && \
    # COMPOSER #################################################################
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    git clone https://github.com/composer/packagist.git /srv && \
    git -C /srv reset --hard 2d90743bec035e87928f4afa356ba28a1547608f && \
    composer install -d /srv --no-dev --no-interaction --no-scripts -v -o && \
    # SUPERVISOR ###############################################################
    mkdir -p /run/nginx && \
    # CLEAN UP #################################################################
    rm -rf /var/cache/apk/*

# WEB
ADD ./web/app_dev.php /srv/web/app_dev.php

# PHP
ADD ./php/php-fpm.conf /etc/php/7.1/fpm/php-fpm.conf

# NGINX
ADD ./nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./nginx/mime.types /etc/nginx/mime.types
ADD ./nginx/sites/dev.conf /etc/nginx/sites.d/dev.conf
ADD ./nginx/sites/stable.conf /etc/nginx/sites.d/stable.conf

# SSH
ADD ./ssh /tpl/ssh

# Cron
ADD ./cron/root /etc/crontabs/root
ADD ./cron/packagist /etc/periodic/1min/packagist

# Supervisor
ADD ./supervisor/supervisord.conf /etc/supervisord.conf

WORKDIR /srv

EXPOSE 80

ADD ./entrypoint.sh /
CMD /entrypoint.sh
