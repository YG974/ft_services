# PMA

ARG		ALPINE_VERSION
FROM	alpine:$ALPINE_VERSION

LABEL	MAINTAINER="ygeslin <ygeslin@student.42.fr>"

ARG		PHP_VERSION
ARG		PMA_VERSION
ARG		NGINX_VERSION
ARG		OPENRC_VERSION

WORKDIR	/

RUN		apk add --update --no-cache \
		openrc=${OPENRC_VERSION} \
		phpmyadmin=${PMA_VERSION} \
		php7-fpm=${PHP_VERSION} \
		nginx=${NGINX_VERSION}

# copy files from context/OS to container
COPY	entrypoint.sh \
		localhost.conf \
		livenessprobe.sh \
		config.inc.php \
		./

# creating required directory to run nginx
RUN		mkdir -p /run/nginx


# move settings files
RUN		mv localhost.conf /etc/nginx/conf.d/localhost.conf
RUN		rm /etc/nginx/conf.d/default.conf
RUN 	mv ./config.inc.php /etc/phpmyadmin/config.inc.php

EXPOSE	5000

# Adding right to scripts
RUN		chmod +x ./entrypoint.sh
RUN		chmod +x ./livenessprobe.sh

# CMD		["./entrypoint.sh"]
ENTRYPOINT ["./entrypoint.sh"]

