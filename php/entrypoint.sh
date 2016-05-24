#!/bin/bash

# Start rsyslogd
rsyslogd

# Start cron
cron
touch /var/log/cron.log

# Start PHP
php-fpm7.0 -F
