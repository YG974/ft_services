FROM alpine:3.11

LABEL MAINTAINER="ygeslin <ygeslin@student.42.fr>"

ARG NGINX_VERSION=1.18.0-r0
ARG USER=nginx

WORKDIR	./

#RUN 
#RUN apk upgrade
RUN apk add --update --no-cache \
			#nginx=$NGINX_VERSION \
			nginx	\
			vim		\
			openssh \
			openssl

# creating required directory to run nginx
RUN mkdir -p /run/nginx

#COPY --chown=$USER entrypoint.sh \
COPY  entrypoint.sh \
			.vimrc \
			./

# Copy vimrc to be confortable when connecting with tty
RUN mv .vimrc ./root/
RUN mv localhost.conf /etc/nginx/conf.d/
RUN mv index.html /var/www/localhost/

EXPOSE	80 443 22

# Adding right to scripts
RUN		chmod +x ./entrypoint.sh

#starting NGINX
ENTRYPOINT ["sh", "./entrypoint.sh"]
