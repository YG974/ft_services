# INFLUXDB

ARG		ALPINE_VERSION
FROM	alpine:$ALPINE_VERSION

LABEL	MAINTAINER="ygeslin <ygeslin@student.42.fr>"

ARG		OPENRC_VERSION
ARG		INFLUXDB_VERSION
ARG		REPOS='/etc/apk/repositories'

WORKDIR	/

# update apk repos to be able to find influxdb
RUN		echo 'http://dl-cdn.alpinelinux.org/alpine/v3.13/main' >> ${REPOS}
RUN		echo 'http://dl-cdn.alpinelinux.org/alpine/v3.13/community' >> ${REPOS}

# Install sofwares
RUN		apk add --update --no-cache \
		openrc=${OPENRC_VERSION} \
		influxdb=${INFLUXDB_VERSION}

# Set up openrc
RUN		openrc && \
		touch /run/openrc/softlevel

# copy files from context/OS to container
COPY	entrypoint.sh \
		livenessprobe.sh \
		./

EXPOSE	8086

# Adding right to scripts
RUN		chmod +x ./entrypoint.sh
RUN		chmod +x ./livenessprobe.sh

# CMD		["./entrypoint.sh"]
ENTRYPOINT ["./entrypoint.sh"]
