#!/bin/ash

#launching openrc
openrc
touch /run/openrc/softlevel

# change rights to be able to read from remote
chmod 555 /etc/phpmyadmin/config.inc.php

service nginx start
service php-fpm7 start

tail -F /dev/null

