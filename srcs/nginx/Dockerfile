# NGINX

ARG		ALPINE_VERSION=3.11
FROM	alpine:$ALPINE_VERSION

LABEL	MAINTAINER="ygeslin <ygeslin@student.42.fr>"

ARG		NGINX_VERSION=1.16.1-r6

WORKDIR	./

RUN		apk add --update --no-cache \
		nginx=${NGINX_VERSION} \
		openssh \
		openssl

# creating required directory to run nginx
RUN		mkdir -p /run/nginx

#COPY --chown=$USER entrypoint.sh \
COPY	entrypoint.sh \
		index.html \
		./

COPY 	localhost.conf \
		./
# Copy vimrc to be confortable when connecting with tty
RUN		mv localhost.conf /etc/nginx/conf.d/localhost.conf
RUN		rm /etc/nginx/conf.d/default.conf
RUN		mv index.html /var/www/localhost/

EXPOSE	80 443

# Adding right to scripts
RUN		chmod +x ./entrypoint.sh

#starting NGINX
CMD		["./entrypoint.sh"]
