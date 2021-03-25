# FTPS

ARG		ALPINE_VERSION
FROM	alpine:$ALPINE_VERSION

LABEL	MAINTAINER="ygeslin <ygeslin@student.42.fr>"

ARG		VSFTPD_VERSION
ARG		OPENRC_VERSION
#ENV		NGINX_VERSION=${NGINX_VERSION}

WORKDIR	./

RUN		apk add vsftpd=${VSFTPD_VERSION} \
		openrc=${OPENRC_VERSION} \
		lftp \
		curl \
		openssl

# https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04
# ssl
RUN openssl req -x509 \
			-nodes \
			-days 365 \
			-newkey rsa:4096 \
			-keyout /etc/ssl/private/ftps-selfsigned.key \
			-out /etc/ssl/certs/ftps-selfsigned.crt \
			-subj "/C=FR/ST=Paris/L=Paris/O=42_School/OU=ygeslin/CN=localost"

COPY	entrypoint.sh \
		vsftpd.conf \
		./

#RUN		chmod +r ./vsftpd.conf

RUN		mv vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN		openrc && \
		touch /run/openrc/softlevel

EXPOSE	21 20 21000-21004

# Adding right to scripts
RUN		chmod +x ./entrypoint.sh


#CMD		["ash", "-c", "./entrypoint.sh"]
CMD		["ash"]
