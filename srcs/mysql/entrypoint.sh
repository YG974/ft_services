#!/bin/ash

openrc
touch /run/openrc/softlevel

/etc/init.d/mariadb setup

service mariadb restart
# sleep 1
# to be able to communicate with other conteners
sed -i 's/skip-networking/# skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf

service mariadb restart

# DB_NAME="wp_db";
# DB_USER="user";
# DB_PASS="user";
# WP_ADMIN="admin";
# WP_ADMIN_PASS="admin";

mysql --user=root << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER "$DB_USER"@"%" IDENTIFIED BY "$DB_PASS";
GRANT ALL PRIVILEGES ON $DB_NAME.* TO "$DB_USER"@"%" WITH GRANT OPTION;
CREATE USER "$WP_ADMIN"@"%" IDENTIFIED BY "$WP_ADMIN_PASS";
GRANT ALL PRIVILEGES ON $DB_NAME.* TO "$WP_ADMIN"@"%" WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# mysql --user=root $DB_NAME < wordpress_db.sql

tail -F /dev/null
