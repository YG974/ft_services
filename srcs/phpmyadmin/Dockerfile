# PMA

#ARG		ALPINE_VERSION=3.11
ARG		ALPINE_VERSION
FROM	alpine:$ALPINE_VERSION

LABEL	MAINTAINER="ygeslin <ygeslin@student.42.fr>"

#ARG		PMA_VERSION=4.9.5-r0
#ARG		OPENRC_VERSION=0.42.1-r2
#ARG		NGINX_VERSION=1.16.1-r6
ARG		PMA_VERSION
ARG		NGINX_VERSION

ENV MYSQL_IP=${MYSQL_IP}

WORKDIR	./

RUN		apk add --update --no-cache \
		#openrc=${OPENRC_VERSION} \
		phpmyadmin=${PMA_VERSION} \
		nginx=${NGINX_VERSION}

#COPY --chown=$USER entrypoint.sh \
COPY	entrypoint.sh \
		./

EXPOSE	5000

# Adding right to scripts
RUN		chmod +x ./entrypoint.sh

#starting NGINX
CMD		["./entrypoint.sh"]
#ENTRYPOINT ["ash"]
#ENTRYPOINT ["sh", "./entrypoint.sh"]
#ENTRYPOINT ["./entrypoint.sh"]

