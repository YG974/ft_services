#!/bin/ash

# INFLUXDB

#openrc
#touch /run/openrc/softlevel


ash
#service start
# https://wiki.alpinelinux.org/wiki/MariaDB
# to be able to communicate with other conteners
#sed -i 's/skip-networking/# skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf

#service mariadb restart

influx  << EOF
CREATE DATABASE IF NOT EXISTS $INFLUXDB_DB;
CREATE USER "$INFLUXDB_ADMIN_USER"@"%" IDENTIFIED BY "$INFLUXDB_ADMIN_PASS";
GRANT ALL PRIVILEGES ON $INFLUXDB_DB.* TO "$INFLUXDB_ADMIN_USER"@"%" WITH GRANT OPTION;
CREATE USER "$INFLUXDB_USER"@"%" IDENTIFIED BY "$INFLUXDB_PASS";
GRANT ALL PRIVILEGES ON $INFLUXDB_DB.* TO "$INFLUXDB_USER"@"%" WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

#tail -F /dev/null
