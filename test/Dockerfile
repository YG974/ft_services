FROM	alpine

RUN		apk add vsftpd openssl openrc curl

ADD		srcs/vsftpd.conf /etc/vsftpd/
ADD		srcs/ /root

RUN		chmod +x /root/init.sh

EXPOSE	20 21 

CMD ["/root/init.sh" ]

