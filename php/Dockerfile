FROM dockette/php7-fpm

MAINTAINER Milan Sulc <sulcmil@gmail.com>

# CONFIGURATION
ENV SSH_ENABLED=true
ENV CRON_ENABLED=true
ENV CRON_STDOUT=true
ENV USER_NAME=www-data
ENV USER_WORKDIR=/var/www
ENV PACKAGIST_DIR=/srv
ENV CRON_LOG_FILE=/var/log/cron.log

# INSTALLATION
RUN apt-get update && apt-get dist-upgrade -y && \
    # DEPENDENCIES #############################################################
	apt-get install -y git cron && \
    # CLEAN UP #################################################################
    apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/*

# PHP configuration
ADD ./php/php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf

# SSH settings
ADD ./ssh /tpl/ssh

# Crontab
ADD ./cron/packagist /etc/cron.d/packagist

# Entrypoint
ADD ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
