# TELEGRAF

ARG		ALPINE_VERSION
FROM	alpine:$ALPINE_VERSION

LABEL	MAINTAINER="ygeslin <ygeslin@student.42.fr>"

ARG		TELEGRAF_VERSION
ARG		REPOS='/etc/apk/repositories'

WORKDIR	/

# updating apk repos to be able to find grafana
RUN		echo 'http://dl-cdn.alpinelinux.org/alpine/v3.13/main' >> ${REPOS}
RUN		echo 'http://dl-cdn.alpinelinux.org/alpine/v3.13/community' >> ${REPOS}

RUN		apk add --update --no-cache \
		telegraf=${TELEGRAF_VERSION} 

COPY	entrypoint.sh \
		livenessprobe.sh \
		telegraf.conf \
		./

RUN		mv telegraf.conf /etc/telegraf.conf

EXPOSE	8125

# Adding right to scripts
RUN		chmod +x ./entrypoint.sh
RUN		chmod +x ./livenessprobe.sh

ENTRYPOINT ["./entrypoint.sh"]