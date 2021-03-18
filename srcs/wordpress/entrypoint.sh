#!/bin/ash

# WORDPRESS

#service nginx start

sed -i "s/database_name_here/$DB_NAME/g" ${WP_CONF};
sed -i "s/username_here/$DB_USER/g" ${WP_CONF};
sed -i "s/password_here/$DB_PASS/g" ${WP_CONF};
sed -i "s/localhost/$MYSQL_IP/g" ${WP_CONF};

php -S 0.0.0.0:5050 -t /srv/wordpress

tail -F /dev/null
