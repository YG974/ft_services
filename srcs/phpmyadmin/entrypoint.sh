#!/bin/ash

# PhpMyAdmin

# standard command to start nginx with daemon off according to Nginx Docker doc :
# https://github.com/nginxinc/docker-nginx/blob/594ce7a8bc26c85af88495ac94d5cd0096b306f7/mainline/buster/Dockerfile?fbclid=IwAR2H33H4e4KI9s6eMevQm0UNwcJa3Uzh7jVysJgyhtjgMfFZO7G1O4z1Dcc
#service nginx start
php -S 0.0.0.0:5000 -t /usr/share/webapps/phpmyadmin

tail -F /dev/null

