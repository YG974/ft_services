#!/bin/ash

# WORDPRESS

#service nginx start

mv /srv/wordpress/wp-config-sample.php /srv/wordpress/wp-config.php

php -S 0.0.0.0:5050 -t /srv/wordpress

tail -F /dev/null
