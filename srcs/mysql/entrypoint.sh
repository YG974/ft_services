#!/bin/ash

# MYSQL

openrc
touch /run/openrc/softlevel

# https://wiki.alpinelinux.org/wiki/MariaDB
# to be able to communicate with other conteners
sed -i "s|.*skip-networking.*|skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf

/etc/init.d/mariadb setup

#nginx -g 'daemon off;'
service nginx start
service mariadb start

mysql --user=root $WP_DB < create_db_and_users.sql

tail -F /dev/null
