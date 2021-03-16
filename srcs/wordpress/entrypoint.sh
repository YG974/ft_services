#!/bin/ash

# WORDPRESS

service nginx start

php -S 0.0.0.0:5050 -t /srv/wordpress

tail -F /dev/null
