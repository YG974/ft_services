#!/bin/ash

# PhpMyAdmin
# sed -i "s/\'localhost\'/\'$MYSQL_IP\'/g" /etc/phpmyadmin/config.inc.php

#launching openrc
openrc
touch /run/openrc/softlevel

# change rights to be able to read from remote
chmod 555 /etc/phpmyadmin/config.inc.php

service nginx start
service php-fpm7 start

# to run without fhp-fpm;
#php -S 0.0.0.0:5000 -t /usr/share/webapps/phpmyadmin

tail -F /dev/null

