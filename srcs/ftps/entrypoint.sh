#!/bin/ash

# FTPS

# /bin/ash is bash equivalent on alphine

exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf &

# ash

tail -F /dev/null