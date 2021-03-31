# GRAFANA

ARG		ALPINE_VERSION
FROM	alpine:$ALPINE_VERSION

LABEL	MAINTAINER="ygeslin <ygeslin@student.42.fr>"

#ARG		MYSQL_VERSION=10.4.17-r1
#ARG		OPENRC_VERSION=0.42.1-r2
#ARG		NGINX_VERSION=1.16.1-r6
ARG		OPENRC_VERSION
ARG		GRAFANA_VERSION
ARG		REPOS='/etc/apk/repositories'

WORKDIR	./


RUN		echo 'http://dl-cdn.alpinelinux.org/alpine/v3.13/main' >> ${REPOS}
RUN		echo 'http://dl-cdn.alpinelinux.org/alpine/v3.13/community' >> ${REPOS}

RUN		apk add --update --no-cache \
		openrc=${OPENRC_VERSION} \
		grafana=${GRAFANA_VERSION}
		#openrc=${OPENRC_VERSION} \

#COPY --chown=$USER entrypoint.sh \
COPY	entrypoint.sh \
		./

EXPOSE	3000

# Adding right to scripts
RUN		chmod +x ./entrypoint.sh

#starting NGINX
CMD		["./entrypoint.sh"]
#ENTRYPOINT ["ash"]
# mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql