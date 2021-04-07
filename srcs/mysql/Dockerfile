# MYSQL

ARG		ALPINE_VERSION
FROM	alpine:$ALPINE_VERSION

LABEL	MAINTAINER="ygeslin <ygeslin@student.42.fr>"

#ARG		MYSQL_VERSION=10.4.17-r1
#ARG		OPENRC_VERSION=0.42.1-r2
#ARG		NGINX_VERSION=1.16.1-r6
ARG		MYSQL_VERSION
ARG		OPENRC_VERSION
ARG		NGINX_VERSION

WORKDIR	./

RUN		apk add --update --no-cache \
		openrc=${OPENRC_VERSION} \
		mysql=${MYSQL_VERSION} \
		mysql-client=${MYSQL_VERSION}
		# mariadb=${MYSQL_VERSION} \
		# mariadb-client=${MYSQL_VERSION}

#COPY --chown=$USER entrypoint.sh \
COPY	entrypoint.sh \
		wordpress_db.sql \
		./

EXPOSE	3306

# Adding right to scripts
RUN		chmod +x ./entrypoint.sh
# RUN		chmod +rwx ./wordpress_db.sql

#starting NGINX
# CMD		["ash", "-c", "./entrypoint.sh"]
ENTRYPOINT		["./entrypoint.sh"]
#ENTRYPOINT ["ash"]
# mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
