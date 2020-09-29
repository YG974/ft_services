#!/bin/bash

# https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04
# ssl
openssl req -x509 \
			-nodes \
			-days 365 \
			-newkey rsa:4096 \
			-keyout /etc/ssl/private/nginx-selfsigned.key \
			-out /etc/ssl/certs/nginx-selfsigned.crt \
			-subj "/C=FR/ST=Paris/L=Paris/O=42_School/OU=ygeslin/CN=ft_services"


# standard command to start nginx with daemon off according to Nginx Docker doc :
# https://github.com/nginxinc/docker-nginx/blob/594ce7a8bc26c85af88495ac94d5cd0096b306f7/mainline/buster/Dockerfile?fbclid=IwAR2H33H4e4KI9s6eMevQm0UNwcJa3Uzh7jVysJgyhtjgMfFZO7G1O4z1Dcc
 nginx -g 'daemon off;'

