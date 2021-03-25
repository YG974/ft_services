#!/bin/ash

# FTPS

# /bin/ash is bash equivalent on alphine

# -- Start FTP server ---
printf "FTPS server is starting !\n"
exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf &

ash

#lftp -u useruser,useruser localhost:21
