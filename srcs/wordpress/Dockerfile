ARG		ALPINE_VERSION=3.11
FROM	alpine:$ALPINE_VERSION

LABEL	MAINTAINER="ygeslin <ygeslin@student.42.fr>"

#ARG		WP_VERSION=1.16.1-r6
ARG			PHP_VERSION=7.3.22-r0
#ARG		USER=nginx

WORKDIR	./

RUN		apk add --update --no-cache \
		php7=$PHP_VERSION
ADD https://wordpress.org/latest.tar.gz .
		#wordpress=$WP_VERSION \
		#wordpress


#COPY --chown=$USER entrypoint.sh \
#COPY	entrypoint.sh \
		#./

EXPOSE	5050

# Adding right to scripts
#RUN		chmod +x ./entrypoint.sh

#starting NGINX
#CMD		["sh", "./entrypoint.sh"]
#CMD		["./entrypoint.sh"]
ENTRYPOINT ["ash"]
#ENTRYPOINT ["sh", "./entrypoint.sh"]
#ENTRYPOINT ["./entrypoint.sh"]
