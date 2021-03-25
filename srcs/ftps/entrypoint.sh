##!/bin/ash

# FTPS

# /bin/ash is bash equivalent on alphine

# FTPS_USER <- Username of the user you want to create
# FTPS_PASS <- The password of the user

FTPS_USER=useruser
FTPS_PASS=useruser

CONF="/etc/conf.d/vsftpd"

#ehco "rsa_cert_file=/etc/vsftpd/vsftpd.pem
#rsa_private_key_file=/etc/vsftpd/vsftpd.pem" > $CONF
# replace IP in nginx.conf
echo "USER=\"$FTPS_USER\"" >> ${CONF}
echo "GROUP=\"$FTPS_USER\"" >> ${CONF}
echo "USER=\"root\"" >> ${CONF}
echo "GROUP=\"root\"" >> ${CONF}
#sed -i "s/GROUP=\"vsftpd\"/GROUP=\"$FTPS_USER\"/g" ${CONF}
if [ ! -d "/ftp/$FTPS_USER" ]
then
	mkdir -p /ftp/$FTPS_USER &> /dev/null
fi

echo -e "$FTPS_PASS\n$FTPS_PASS" | adduser -h /ftp/$FTPS_USER $FTPS_USER
chown $FTPS_USER:$FTPS_USER /ftp/$FTPS_USER

# -- Start FTP server ---
printf "FTPS server is starting !\n"
#exec /usr/sbin/vsftpd -opasv_min_port=21000 -opasv_max_port=21004
#-opasv_address=172.18.0.6 /etc/vsftpd/vsftpd.conf &
#exec /etc/init.d/vsftpd restart
#/etc/init.d/vsftpd restart
service vsftpd start
tail -F /dev/null

#tail -F /dev/null

#lftp -u useruser,useruser localhost:21
