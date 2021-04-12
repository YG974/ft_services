# FTPS

ARG		ALPINE_VERSION
FROM	alpine:$ALPINE_VERSION

LABEL	MAINTAINER="ygeslin <ygeslin@student.42.fr>"

ARG		VSFTPD_VERSION
ARG		OPENRC_VERSION
ARG		FTPS_USER
ARG		FTPS_PASS

WORKDIR	/

RUN		apk add vsftpd=${VSFTPD_VERSION} \
		openrc=${OPENRC_VERSION} \
		openssl

# https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04
# ssl
RUN openssl req -x509 \
			-nodes \
			-days 365 \
			-newkey rsa:1024 \
			-keyout /etc/ssl/private/ftps-selfsigned.key \
			-out /etc/ssl/certs/ftps-selfsigned.crt \
			-subj "/C=FR/ST=Paris/L=Paris/O=42_School/OU=ygeslin/CN=localost"

COPY	entrypoint.sh \
		vsftpd.conf \
		livenessprobe.sh \
		success.txt \
		./

# copy vsftpd setting file in etc
RUN		mv vsftpd.conf /etc/vsftpd/vsftpd.conf

# create user, neceserary to login ftps
RUN		echo -e "$FTPS_PASS\n$FTPS_PASS" | adduser $FTPS_USER
RUN		mv success.txt /home/${FTPS_USER}/success.txt

# port 21 = command port
# port 20 = data transfer port for active mode
# 21 000 and more, data transfer for passive mode.
# Multiples ports purpose -> multiclients or multiple request without waiting.
EXPOSE	21 20 21000-21004

# Adding right to scripts
RUN		chmod +x ./entrypoint.sh
RUN		chmod +x ./livenessprobe.sh

CMD		["./entrypoint.sh"]
# ENTRYPOINT		["./entrypoint.sh"]
