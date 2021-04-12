# MYSQL

ARG		ALPINE_VERSION
FROM	alpine:$ALPINE_VERSION

LABEL	MAINTAINER="ygeslin <ygeslin@student.42.fr>"

ARG		MYSQL_VERSION
ARG		OPENRC_VERSION

WORKDIR	/

RUN		apk add --update --no-cache \
		openrc=${OPENRC_VERSION} \
		mysql=${MYSQL_VERSION} \
		mysql-client=${MYSQL_VERSION}

COPY	entrypoint.sh \
		livenessprobe.sh \
		wordpress_db.sql \
		./

EXPOSE	3306

# Adding right to scripts
RUN		chmod +x ./entrypoint.sh
RUN		chmod +x ./livenessprobe.sh

ENTRYPOINT		["./entrypoint.sh"]
