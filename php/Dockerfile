FROM dockette/php:7-fpm

MAINTAINER Milan Sulc <sulcmil@gmail.com>

ENV USER_HOME=/home/dfx

# PHP configuration
ADD ./php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf

# SSH settings
ADD ./ssh $USER_HOME/.ssh

RUN apt-get update && apt-get install -y git rsyslog && \
    chown dfx:dfx $USER_HOME/.ssh -R && \
    chmod 700 $USER_HOME/.ssh && \
    chmod 600 $USER_HOME/.ssh/id_rsa && \
    chmod 644 $USER_HOME/.ssh/id_rsa.pub && \
    apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/lib/log/* /tmp/* /var/tmp/*

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
