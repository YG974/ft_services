#!/bin/ash

# TELEGRAF

openrc
touch /run/openrc/softlevel

telegraf -config /etc/telegraf.conf

#ash
#sed -i 's/skip-networking/# skip-networking/g' /etc/my.cnf.d/mariadb-server.cnf


tail -F /dev/null
