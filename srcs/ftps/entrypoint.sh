#!/bin/ash

# FTPS

# /bin/ash is bash equivalent on alphine

exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf &

tail -F /dev/null