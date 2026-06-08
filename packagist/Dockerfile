FROM dockette/alpine:3.7

LABEL maintainer="sulcmil@gmail.com"

ENV SSH_ENABLED=true
ENV USER_ID=82
ENV USER_NAME=www-data
ENV USER_WORKDIR=/var/www
ENV PACKAGIST_DIR=/srv
ENV CRON_LOG_FILE=/var/log/cron.log

RUN printf '%s\n' \
    'https://dl-cdn.alpinelinux.org/alpine/v3.7/main' \
    'https://dl-cdn.alpinelinux.org/alpine/v3.7/community' \
    > /etc/apk/repositories && \
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
    php7 \
    php7-bcmath \
    php7-bz2 \
    php7-calendar \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-fileinfo \
    php7-fpm \
    php7-gd \
    php7-iconv \
    php7-imap \
    php7-intl \
    php7-json \
    php7-mbstring \
    php7-mcrypt \
    php7-mysqli \
    php7-mysqlnd \
    php7-openssl \
    php7-phar \
    php7-pdo \
    php7-pdo_mysql \
    php7-session \
    php7-simplexml \
    php7-tokenizer \
    php7-xmlwriter \
    php7-zip \
    php7-xml \
    php7-xmlreader && \
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
