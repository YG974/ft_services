# NGINX

ARG		ALPINE_VERSION
FROM	alpine:$ALPINE_VERSION

LABEL	MAINTAINER="ygeslin <ygeslin@student.42.fr>"

ARG		NGINX_VERSION

WORKDIR	/

RUN		apk add --update --no-cache \
		nginx=${NGINX_VERSION} \
		openssl

# creating required directory to run nginx
RUN		mkdir -p /run/nginx

# https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04
# ssl
RUN openssl req -x509 \
			-nodes \
			-days 365 \
			-newkey rsa:4096 \
			-keyout /etc/ssl/private/nginx-selfsigned.key \
			-out /etc/ssl/certs/nginx-selfsigned.crt \
			-subj "/C=FR/ST=Paris/L=Paris/O=42_School/OU=ygeslin/CN=ft_services"

COPY	entrypoint.sh \
		livenessprobe.sh \
		localhost.conf \
		index.html \
		./

RUN		mv localhost.conf /etc/nginx/conf.d/localhost.conf
RUN		rm /etc/nginx/conf.d/default.conf
RUN		mv index.html /var/www/localhost/

EXPOSE	80 443

# Adding right to scripts
RUN		chmod +x ./entrypoint.sh
RUN		chmod +x ./livenessprobe.sh

#starting NGINX
CMD		["./entrypoint.sh"]
