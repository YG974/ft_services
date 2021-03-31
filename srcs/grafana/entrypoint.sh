#!/bin/ash

# GRAFANA

openrc
touch /run/openrc/softlevel

cd /usr/share/grafana
/usr/sbin/grafana-server

#ash
#service start
# https://wiki.alpinelinux.org/wiki/MariaDB
# to be able to communicate with other conteners
#sed -i 's/skip-networking/# skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf

#service mariadb restart

#mysql --user=root << EOF
#CREATE DATABASE IF NOT EXISTS $DB_NAME;
#CREATE USER "$DB_USER"@"%" IDENTIFIED BY "$DB_PASS";
#GRANT ALL PRIVILEGES ON $DB_NAME.* TO "$DB_USER"@"%" WITH GRANT OPTION;
#CREATE USER "$WP_ADMIN"@"%" IDENTIFIED BY "$WP_ADMIN_PASS";
#GRANT ALL PRIVILEGES ON $DB_NAME.* TO "$WP_ADMIN"@"%" WITH GRANT OPTION;
#FLUSH PRIVILEGES;
#EOF

#mysql --user=root $DB_NAME < wordpress_db.sql

tail -F /dev/null
