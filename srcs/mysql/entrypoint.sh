# MYSQL

#!/bin/ash

openrc
touch /run/openrc/softlevel

# https://wiki.alpinelinux.org/wiki/MariaDB
# to be able to communicate with other conteners
sed -i "s|.*skip-networking.*|skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf

/etc/init.d/mariadb setup

exec service mariadb start

