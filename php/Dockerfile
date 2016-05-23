FROM dockette/php:7-fpm

MAINTAINER Milan Sulc <sulcmil@gmail.com>

# PHP configuration
ADD ./php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf

# SSH settings
ADD ./ssh /home/dfx/.ssh

RUN apt-get update && apt-get install -y git
    chown dfx:dfx /home/dfx/.ssh -R && \
    chmod 700 /home/dfx/.ssh && \
    chmod 600 /home/dfx/.ssh/id_rsa && \
    chmod 644 /home/dfx/.ssh/id_rsa.pub && \
    apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/*
