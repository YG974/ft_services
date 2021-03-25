#!/bin/ash
# --- Env variables
# FTPS_USER <- Username of the user you want to create
# FTPS_PASS <- The password of the user

FTPS_USER=user
FTPS_PASS=user


# --- FTPS setup ---
openssl req -x509 -nodes -subj '/CN=localhost' -days 365 -newkey rsa:1024 -keyout \
/etc/vsftpd/vsftpd.pem -out /etc/vsftpd/vsftpd.pem

#if [ ! -d "/ftp/$FTPS_USER" ]
#then
	#mkdir -p /ftp/$FTPS_USER &> /dev/null
#fi

echo -e "$FTPS_PASS\n$FTPS_PASS" | adduser $FTPS_USER
#chown $FTPS_USER:$FTPS_USER /ftp/$FTPS_USER

# -- Start FTP server ---
printf "FTPS server is starting !\n"
exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf &
#service vsftpd restart

ash
#tail -F /dev/null
