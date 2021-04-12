#!/bin/ash

# NGINX

# /bin/ash is bash equivalent on alphine

# standard command to start nginx with daemon off according to Nginx Docker doc :
# https://github.com/nginxinc/docker-nginx/blob/594ce7a8bc26c85af88495ac94d5cd0096b306f7/mainline/buster/Dockerfile?fbclid=IwAR2H33H4e4KI9s6eMevQm0UNwcJa3Uzh7jVysJgyhtjgMfFZO7G1O4z1Dcc
nginx -g 'daemon off;'
# good practise to use exec, in order to have PID 1 on the service, to handle
# UNIX Signal
tail -F /dev/null
