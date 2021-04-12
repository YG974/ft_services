# WORDPRESS

ARG		ALPINE_VERSION
FROM	alpine:$ALPINE_VERSION

LABEL	MAINTAINER="ygeslin <ygeslin@student.42.fr>"

ARG		WP_VERSION
ARG		PHP_VERSION
ARG		NGINX_VERSION
ARG		OPENRC_VERSION

ENV WP_CONF="/srv/wordpress/wp-config.php"

WORKDIR	/

RUN		apk add --update --no-cache \
		nginx=${NGINX_VERSION} \
		openrc=${OPENRC_VERSION} \
		php7=${PHP_VERSION} \
		php7-json=${PHP_VERSION} \
		php7-fpm=${PHP_VERSION} \
		php7-mysqli=${PHP_VERSION}

COPY	entrypoint.sh \
		livenessprobe.sh \
		./

# Download wordpress
ADD		https://wordpress.org/wordpress-${WP_VERSION}.tar.gz .

# Install wordpress and remove tar file
RUN		tar xzf wordpress-${WP_VERSION}.tar.gz -C /srv/
RUN		rm wordpress-${WP_VERSION}.tar.gz
RUN		mv /srv/wordpress/wp-config-sample.php /srv/wordpress/wp-config.php

# NGINX
COPY 	localhost.conf \
		./
RUN		mkdir -p /run/nginx
RUN		mv localhost.conf /etc/nginx/conf.d/localhost.conf
RUN		rm /etc/nginx/conf.d/default.conf

EXPOSE	5050

# Adding right to scripts
RUN		chmod +x ./entrypoint.sh
RUN		chmod +x ./livenessprobe.sh

#starting NGINX
#ENTRYPOINT ["bin/ash"]
ENTRYPOINT ["./entrypoint.sh"]
# CMD ["/bin/ash", "./entrypoint.sh"]
