#!/bin/ash

# INFLUXDB

service influxdb restart
#influxd -config /etc/influxdb.conf
sleep 10;
influx  << EOF
CREATE USER admin WITH PASSWORD '$INFLUXDB_ADMIN_PASS' WITH ALL PRIVILEGES;
CREATE DATABASE telegraf;
EOF

tail -f /dev/null
