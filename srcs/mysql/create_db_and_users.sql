-- create database if doesn't exist and 2 users : admin and wp_user

CREATE DATABASE IF NOT EXISTS '$WP_DB';
CREATE USER '$WP_USER'@'%' IDENTIFIED BY '$WP_USER_PASS'
GRANT ALL PRIVILEGES ON WP_DATABASE.* TO '$WP_USER'@'%' WITH GRANT OPTION;
CREATE USER 'WP_ADMIN'@'%' IDENTIFIED BY '$WP_ADMIN_PASS'
GRANT ALL PRIVILEGES ON WP_DATABASE.* TO '$WP_ADMIN'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;