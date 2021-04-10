# GRAFANA

ARG		ALPINE_VERSION
FROM	alpine:$ALPINE_VERSION

LABEL	MAINTAINER="ygeslin <ygeslin@student.42.fr>"

ARG		OPENRC_VERSION
ARG		GRAFANA_VERSION
ARG		REPOS='/etc/apk/repositories'

WORKDIR	/

# updating apk repos to be able to find grafana
RUN		echo 'http://dl-cdn.alpinelinux.org/alpine/v3.13/main' >> ${REPOS}
RUN		echo 'http://dl-cdn.alpinelinux.org/alpine/v3.13/community' >> ${REPOS}

RUN		apk add --update --no-cache \
		openrc=${OPENRC_VERSION} \
		grafana=${GRAFANA_VERSION}

# copy files from context/OS to container
COPY	entrypoint.sh \
		livenessprobe.sh \
		datasources.yaml \
		dashboard_provider.yaml \
		dashboard.json \
		./

# move dashboards and datasource settings
RUN		mv ./datasources.yaml \
			/usr/share/grafana/conf/provisioning/datasources/.

RUN		mv ./dashboard_provider.yaml \
			/usr/share/grafana/conf/provisioning/dashboards/.

RUN		mv ./dashboard.json \
			/usr/share/grafana/conf/provisioning/dashboards/.

EXPOSE	3000

# Add right to scripts
RUN		chmod +x ./entrypoint.sh
RUN		chmod +x ./livenessprobe.sh

ENTRYPOINT		["./entrypoint.sh"]