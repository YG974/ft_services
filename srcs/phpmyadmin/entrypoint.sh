#!/bin/ash

# PhpMyAdmin

sed -i "s/\'localhost\'/\'$MYSQL_IP\'/g" /etc/phpmyadmin/config.inc.php

# standard command to start nginx with daemon off according to Nginx Docker doc :
# https://github.com/nginxinc/docker-nginx/blob/594ce7a8bc26c85af88495ac94d5cd0096b306f7/mainline/buster/Dockerfile?fbclid=IwAR2H33H4e4KI9s6eMevQm0UNwcJa3Uzh7jVysJgyhtjgMfFZO7G1O4z1Dcc
#service nginx start

#launching openrc
openrc
touch /run/openrc/softlevel

# change rights to be able to read from remote
chmod 555 /etc/phpmyadmin/config.inc.php

service nginx start
service php-fpm7 start
#php -S 0.0.0.0:5000 -t /usr/share/webapps/phpmyadmin

tail -F /dev/null

