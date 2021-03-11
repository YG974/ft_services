ARG		ALPINE_VERSION=3.11
FROM	alpine:$ALPINE_VERSION

LABEL	MAINTAINER="ygeslin <ygeslin@student.42.fr>"

ARG		WP_VERSION=5.7
ARG		PHP_VERSION=7.3.22-r0

WORKDIR	./

RUN		apk add --update --no-cache \
		php7=${PHP_VERSION} \
		php7-json=${PHP_VERSION} \
		php7-mysqli=${PHP_VERSION}

# Download wordpress
ADD		https://wordpress.org/wordpress-${WP_VERSION}.tar.gz .

# Install wordpress and remove tar file
RUN		tar xzf wordpress-${WP_VERSION}.tar.gz -C /srv/
RUN		rm wordpress-${WP_VERSION}.tar.gz

#COPY --chown=$USER entrypoint.sh \
COPY	entrypoint.sh \
		./

EXPOSE	5050

# Adding right to scripts
RUN		chmod +x ./entrypoint.sh

#starting NGINX
#CMD		["sh", "./entrypoint.sh"]
#CMD		["./entrypoint.sh"]
ENTRYPOINT ["ash"]
#ENTRYPOINT ["sh", "./entrypoint.sh"]
#ENTRYPOINT ["./entrypoint.sh"]
