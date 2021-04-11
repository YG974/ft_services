#!/bin/ash

# WORDPRESS

#launching openrc
openrc
touch /run/openrc/softlevel

export MYSQL_IP=mysql;

sed -i "s/database_name_here/$DB_NAME/g" ${WP_CONF};
sed -i "s/username_here/$DB_USER/g" ${WP_CONF};
sed -i "s/password_here/$DB_PASS/g" ${WP_CONF};
sed -i "s/localhost/$MYSQL_IP/g" ${WP_CONF};

service nginx start
service php-fpm7 start
# to run php without php-fpm7 fast CGI
#php -S 172.18.0.3:5050 -t /srv/wordpress
#php -S 0.0.0.0:5050 -t /srv/wordpress

tail -F /dev/null
