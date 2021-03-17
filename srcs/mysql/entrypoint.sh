#!/bin/ash

# MYSQL

openrc
touch /run/openrc/softlevel

/etc/init.d/mariadb setup

service mariadb start
# https://wiki.alpinelinux.org/wiki/MariaDB
# to be able to communicate with other conteners
sed -i 's/skip-networking/# skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf

service mariadb restart

export WP_DB=wp_db;
export WP_USER=user;
export WP_USER_PASS=user
export WP_ADMIN=admin;
export WP_ADMIN_PASS=admin;

mysql --user=root << EOF
CREATE DATABASE IF NOT EXISTS $WP_DB;
CREATE USER '$WP_USER'@'%' IDENTIFIED BY '$WP_USER_PASS';
GRANT ALL PRIVILEGES ON $WP_DB.* TO '$WP_USER'@'%' WITH GRANT OPTION;
CREATE USER '$WP_ADMIN'@'%' IDENTIFIED BY '$WP_ADMIN_PASS';
GRANT ALL PRIVILEGES ON $WP_DB.* TO '$WP_ADMIN'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

mysql --user=root $WP_DB < wordpress_db.sql

tail -F /dev/null
