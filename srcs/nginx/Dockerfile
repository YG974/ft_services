FROM alpine:3

WORKDIR	./

RUN apk add \
			nginx	\
			vim		\
			openssh \
			openssl

# creating required directory to run nginx
RUN mkdir -p /run/nginx

# Copy vimrc to be confortable when connecting with tty
RUN cp ./.vimrc ./root/

EXPOSE	80 443

# Adding right to scripts
RUN		chmod +x ./entrypoint.sh

#starting NGINX
ENTRYPOINT ["sh", "-c", "./entrypoint.sh"]
