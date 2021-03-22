# WORDPRESS

#ARG		ALPINE_VERSION=3.11
ARG		ALPINE_VERSION
FROM	alpine:$ALPINE_VERSION

LABEL	MAINTAINER="ygeslin <ygeslin@student.42.fr>"

#ARG		WP_VERSION=5.7
#ARG		PHP_VERSION=7.3.22-r0
#ARG		NGINX_VERSION=1.16.1-r6
ARG		WP_VERSION
ARG		PHP_VERSION
ARG		NGINX_VERSION
ARG		OPENRC_VERSION

#ENV MYSQL_IP=${MYSQL_IP}
ENV WP_CONF="/srv/wordpress/wp-config.php"

WORKDIR	./

RUN		apk add --update --no-cache \
		nginx=${NGINX_VERSION} \
		openrc=${OPENRC_VERSION} \
		php7=${PHP_VERSION} \
		php7-json=${PHP_VERSION} \
		php7-fpm=${PHP_VERSION} \
		php7-mysqli=${PHP_VERSION}

RUN		mkdir -p /run/nginx

#COPY --chown=$USER entrypoint.sh \
COPY	entrypoint.sh \
		./

#COPY 	localhost.conf \
		#./
#RUN		mv localhost.conf /etc/nginx/conf.d/localhost.conf
#RUN		rm /etc/nginx/conf.d/default.conf

# Download wordpress
ADD		https://wordpress.org/wordpress-${WP_VERSION}.tar.gz .

# Install wordpress and remove tar file
RUN		tar xzf wordpress-${WP_VERSION}.tar.gz -C /srv/
RUN		rm wordpress-${WP_VERSION}.tar.gz
RUN		mv /srv/wordpress/wp-config-sample.php /srv/wordpress/wp-config.php

#COPY --chown=$USER entrypoint.sh \
COPY	entrypoint.sh \
		./
# NGINX
COPY 	localhost.conf \
		./
RUN		mv localhost.conf /etc/nginx/conf.d/localhost.conf
RUN		rm /etc/nginx/conf.d/default.conf

EXPOSE	5050

# Adding right to scripts
RUN		chmod +x ./entrypoint.sh

#starting NGINX
#ENTRYPOINT ["bin/ash"]
CMD ["/bin/ash", "./entrypoint.sh"]
