#!/bin/ash

# FTPS

# /bin/ash is bash equivalent on alphine


# create user, neceserary to login ftps
echo -e "$FTPS_PASS\n$FTPS_PASS" | adduser $FTPS_USER

# -- Start FTP server ---
printf "FTPS server is starting !\n"
exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf &

ash

#lftp -u useruser,useruser localhost:21
