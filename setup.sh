#! /bin/bash

#--------------------------- Variables ----------------------------------------#

services=(				\
			ftps		\
			influxdb	\
			telegraf	\
			grafana		\
			mysql		\
			wordpress	\
			phpmyadmin	\
			nginx		\
)

# VERSION
MINIKUBE_VERSION="v1.9.0"
ALPINE_VERSION="3.11";
OPENRC_VERSION="0.42.1-r2";
NGINX_VERSION="1.16.1-r6";
MYSQL_VERSION="10.4.17-r1";
PMA_VERSION="4.9.5-r0";
WP_VERSION="5.7";
PHP_VERSION="7.3.22-r0";
VSFTPD_VERSION="3.0.3-r6";
GRAFANA_VERSION="7.3.6-r0";
TELEGRAF_VERSION="1.17.0-r0";
INFLUXDB_VERSION="1.7.7-r1";
OPENSSL_VERSION="";

# NETWORK
NETWORK_NAME="cluster";
MYSQL_IP="172.18.0.2";
# test kub metal lb ip
# MYSQL_IP="172.17.0.2";
WP_IP="172.18.0.3";
PMA_IP="172.18.0.4";
NGINX_IP="172.18.0.5";
FTPS_IP="172.18.0.6";
TELEGRAF_IP="172.18.0.7";
INFLUX_DB_IP="172.18.0.8";
GRAFANA_IP="172.18.0.9";
DOCKER_SUBNET="172.18.0.0/16";

# USERS INFO
DB_NAME="wp_db";
DB_USER="user";
DB_PASS="user";
WP_ADMIN="admin";
WP_ADMIN_PASS="admin";
FTPS_USER="user";
FTPS_PASS="user";	
INFLUXDB_DB="telegraf";
INFLUXDB_ADMIN_USER="admin";
INFLUXDB_ADMIN_PASS="admin";
INFLUXDB_USER="user";
INFLUXDB_PASS="user";

srcs=./srcs

function launch_minikube ()
{
	echo "launch Minikube\n";
# deleting previous clusters
minikube delete;
minikube start; 
minikube addons enable metrics-server;
minikube addons enable dashboard;
echo 'adding docker env';
eval $(minikube -p minikube docker-env);
}

function check_minikube ()
{
	# check the version of minikube
	# if version 1.9 is installed, go to next step
	# if version 1.9 is not installed, remove the existing version, and install 1.9
	echo 'checking minikube version'
	minikube version | grep "$MINIKUBE_VERSION"
	if [ "$?" == 0 ]
	then
		echo good version
	else
		echo 'bad version of minikube, please install version 1.9 by running :'
		echo 'curl -Lo minikube https://storage.googleapis.com/minikube/releases/1.9.0/minikube-linux-amd64   && chmod +x minikube'
		echo 'sudo mkdir -p /usr/local/bin/'
		echo 'sudo install minikube /usr/local/bin/'
		exit;
	fi
}

function build_nginx ()
{
	svc=nginx;
		docker build -t my-${svc} \
		--build-arg ALPINE_VERSION=${ALPINE_VERSION} \
		--build-arg NGINX_VERSION=${NGINX_VERSION} \
		-f ${srcs}/${svc}/Dockerfile ${srcs}/${svc}
}

function build_mysql ()
{
	svc=mysql;
	docker build -t my-${svc} \
	--build-arg ALPINE_VERSION=${ALPINE_VERSION} \
	--build-arg MYSQL_VERSION=${MYSQL_VERSION} \
	--build-arg OPENRC_VERSION=${OPENRC_VERSION} \
	-f ${srcs}/${svc}/Dockerfile ${srcs}/${svc}
}

function build_phpmyadmin ()
{
	svc=phpmyadmin;
	docker build -t my-${svc} \
	--build-arg ALPINE_VERSION=${ALPINE_VERSION} \
	--build-arg OPENRC_VERSION=${OPENRC_VERSION} \
	--build-arg NGINX_VERSION=${NGINX_VERSION} \
	--build-arg PMA_VERSION=${PMA_VERSION} \
	--build-arg PHP_VERSION=${PHP_VERSION} \
	-f ${srcs}/${svc}/Dockerfile ${srcs}/${svc}
}

function build_wordpress ()
{
	svc=wordpress;
	docker build -t my-${svc} \
	--build-arg ALPINE_VERSION=${ALPINE_VERSION} \
	--build-arg OPENRC_VERSION=${OPENRC_VERSION} \
	--build-arg NGINX_VERSION=${NGINX_VERSION} \
	--build-arg WP_VERSION=${WP_VERSION} \
	--build-arg PHP_VERSION=${PHP_VERSION} \
	-f ${srcs}/${svc}/Dockerfile ${srcs}/${svc}
}

function build_ftps ()
{
	svc=ftps;
	docker build -t my-${svc} \
	--build-arg ALPINE_VERSION=${ALPINE_VERSION} \
	--build-arg OPENRC_VERSION=${OPENRC_VERSION} \
	--build-arg VSFTPD_VERSION=${VSFTPD_VERSION} \
	--build-arg	FTPS_USER=${FTPS_USER} \
	--build-arg	FTPS_PASS=${FTPS_PASS} \
	-f ${srcs}/${svc}/Dockerfile ${srcs}/${svc}
}

function build_grafana ()
{
	svc=grafana;
	docker build -t my-${svc} \
	--build-arg ALPINE_VERSION=${ALPINE_VERSION} \
	--build-arg OPENRC_VERSION=${OPENRC_VERSION} \
	--build-arg GRAFANA_VERSION=${GRAFANA_VERSION} \
	-f ${srcs}/${svc}/Dockerfile ${srcs}/${svc}
}

function build_influxdb ()
{
	svc=influxdb;
	docker build -t my-${svc} \
	--build-arg ALPINE_VERSION=${ALPINE_VERSION} \
	--build-arg OPENRC_VERSION=${OPENRC_VERSION} \
	--build-arg INFLUXDB_VERSION=${INFLUXDB_VERSION} \
	-f ${srcs}/${svc}/Dockerfile ${srcs}/${svc}
}

function build_telegraf ()
{
	svc=telegraf;
	docker build -t my-${svc} \
	--build-arg ALPINE_VERSION=${ALPINE_VERSION} \
	--build-arg OPENRC_VERSION=${OPENRC_VERSION} \
	--build-arg TELEGRAF_VERSION=${TELEGRAF_VERSION} \
	-f ${srcs}/${svc}/Dockerfile ${srcs}/${svc}
}

function build_containers ()
{
	echo 'Building containers, building logs located in "build_log.log" file';
	echo 'Building MYSQL';
	echo 'MYSQL log' > build_log.log;
	build_mysql >> build_log.log;
	echo 'Building WORDPRESS';
	echo 'WORDPRESS log' >> build_log.log;
	build_wordpress >> build_log.log;
	echo 'Building PHPMYADMIN';
	echo 'PHPMYADMIN log' >> build_log.log;
	build_phpmyadmin >> build_log.log;
	echo 'Building NGINX';
	echo 'NGINX log' >> build_log.log;
	build_nginx >> build_log.log;
	echo 'Building FTPS';
	echo 'FTPS log' >> build_log.log;
	build_ftps >> build_log.log;
	echo 'Building INFLUXDB';
	echo 'INFLUXDB log' >> build_log.log;
	build_influxdb >> build_log.log;
	echo 'Building TELEGRAF';
	echo 'TELEGRAF log' >> build_log.log;
	build_telegraf >> build_log.log;
	echo 'Building GRAFANA';
	echo 'GRAFANA log' >> build_log.log;
	build_grafana >> build_log.log;
	echo 'All containers built';
	grep "Successfully tagged" build_log.log;
}

function run_mysql ()
{
	docker run --network=${NETWORK_NAME} --ip=${MYSQL_IP} -t -d \
	--name mysql \
	-e WP_IP=${WP_IP}			-e DB_NAME=${DB_NAME} \
	-e DB_USER=${DB_USER}		-e DB_PASS=${DB_PASS} \
	-e MYSQL_IP=${MYSQL_IP}		-e PMA_IP=${PMA_IP} \
	-e NGINX_IP=${NGINX_IP}		-e DOCKER_SUBNET=${DOCKER_SUBNET} \
	-e WP_ADMIN=${WP_ADMIN}		-e WP_ADMIN_PASS=${WP_ADMIN_PASS} \
	-p 3306:3306 \
	my-mysql
}

function run_nginx ()
{
	docker run --network=${NETWORK_NAME} --ip=${NGINX_IP} -t -d \
	--name nginx \
	-e WP_IP=${WP_IP}			-e DB_NAME=${DB_NAME} \
	-e DB_USER=${DB_USER}		-e DB_PASS=${DB_PASS} \
	-e MYSQL_IP=${MYSQL_IP}		-e PMA_IP=${PMA_IP} \
	-e NGINX_IP=${NGINX_IP}		-e DOCKER_SUBNET=${DOCKER_SUBNET} \
	-p 80:80 -p 443:443 \
	my-nginx
}

function run_wordpress ()
{
	docker run --network=${NETWORK_NAME} --ip=${WP_IP} -d -t \
	--name wordpress \
	-e WP_IP=${WP_IP}			-e DB_NAME=${DB_NAME} \
	-e DB_USER=${DB_USER}		-e DB_PASS=${DB_PASS} \
	-e MYSQL_IP=${MYSQL_IP}		-e PMA_IP=${PMA_IP} \
	-e NGINX_IP=${NGINX_IP}		-e DOCKER_SUBNET=${DOCKER_SUBNET} \
	-p 5050:5050 \
	my-wordpress
}

function run_phpmyadmin ()
{
	docker run --network=${NETWORK_NAME} --ip=${PMA_IP} -d -t \
	--name phpmyadmin \
	-e WP_IP=${WP_IP}			-e DB_NAME=${DB_NAME} \
	-e DB_USER=${DB_USER}		-e DB_PASS=${DB_PASS} \
	-e MYSQL_IP=${MYSQL_IP}		-e PMA_IP=${PMA_IP} \
	-e NGINX_IP=${NGINX_IP}		-e DOCKER_SUBNET=${DOCKER_SUBNET} \
	-p 5000:5000 \
	my-phpmyadmin
}

function run_ftps ()
{
	svc=ftps;
	docker run --network=${NETWORK_NAME} --ip=${FTPS_IP} -d -t \
	--name ${svc} \
	-e WP_IP=${WP_IP}			-e DB_NAME=${DB_NAME} \
	-e DB_USER=${DB_USER}		-e DB_PASS=${DB_PASS} \
	-e MYSQL_IP=${MYSQL_IP}		-e PMA_IP=${PMA_IP} \
	-e NGINX_IP=${NGINX_IP}		-e DOCKER_SUBNET=${DOCKER_SUBNET} \
	-p 21:21 -p 20:20 -p 21000-21004:21000-21004 \
	my-${svc}
}

function run_grafana ()
{
	svc=grafana;
	docker run --network=${NETWORK_NAME} --ip=${GRAFANA_IP} -d -t \
	--name ${svc} \
	-e WP_IP=${WP_IP}			-e DB_NAME=${DB_NAME} \
	-e DB_USER=${DB_USER}		-e DB_PASS=${DB_PASS} \
	-e MYSQL_IP=${MYSQL_IP}		-e PMA_IP=${PMA_IP} \
	-e NGINX_IP=${NGINX_IP}		-e DOCKER_SUBNET=${DOCKER_SUBNET} \
	-p 3000:3000 \
	my-${svc}
}

function run_influxdb ()
{
	svc=influxdb;
	docker run --network=${NETWORK_NAME} --ip=INFLUX_DB_IP${INFLUXDB_DB_IP} -d -t \
	--name ${svc} \
	-e WP_IP=${WP_IP}			-e DB_NAME=${DB_NAME} \
	-e DB_USER=${DB_USER}		-e DB_PASS=${DB_PASS} \
	-e INFLUXDB_USER=${INFLUXDB_USER}		-e INFLUXDB_ADMIN_USER=${INFLUXDB_ADMIN_USER} \
	-e INFLUXDB_PASS=${INFLUXDB_PASS}		-e INFLUXDB_ADMIN_PASS=${INFLUXDB_ADMIN_PASS} \
	-e MYSQL_IP=${MYSQL_IP}		-e PMA_IP=${PMA_IP} \
	-e NGINX_IP=${NGINX_IP}		-e DOCKER_SUBNET=${DOCKER_SUBNET} \
	-e INFLUXDB_DB=${INFLUXDB_DB}  -e INFLUXDB_DB_IP=${INFLUXDB_DB_IP} \
	-p 8086:8086 \
	my-${svc}
}

function run_telegraf ()
{
	svc=telegraf;
	docker run --network=${NETWORK_NAME} --ip=${TELEGRAF_IP} -d -t \
	--name ${svc} \
	-e WP_IP=${WP_IP}			-e DB_NAME=${DB_NAME} \
	-e DB_USER=${DB_USER}		-e DB_PASS=${DB_PASS} \
	-e INFLUXDB_USER=${INFLUXDB_USER}		-e INFLUXDB_ADMIN_USER=${INFLUXDB_ADMIN_USER} \
	-e INFLUXDB_PASS=${INFLUXDB_PASS}		-e INFLUXDB_ADMIN_PASS=${INFLUXDB_ADMIN_PASS} \
	-e MYSQL_IP=${MYSQL_IP}		-e PMA_IP=${PMA_IP} \
	-e NGINX_IP=${NGINX_IP}		-e DOCKER_SUBNET=${DOCKER_SUBNET} \
	-e INFLUXDB_DB=${INFLUXDB_DB}  -e INFLUXDB_DB_IP=${INFLUXDB_DB_IP} \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-p 8125:8125 \
	my-${svc}
}

function run_containers ()
{
	run_mysql;
	run_wordpress;
	run_nginx;
	run_phpmyadmin;
	# run_ftps;
	# run_influxdb;
	# run_telegraf;
	# run_grafana;
}

function apply_metal_LB ()
{
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/namespace.yaml
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/metallb.yaml
	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
	kubectl apply -f "$srcs/config.yaml"
}

function apply_kub ()
{
	kubectl apply -f "${srcs}/${services[0]}/${services[0]}.yaml"
	kubectl apply -f "${srcs}/${services[1]}/${services[1]}.yaml"
	kubectl apply -f "${srcs}/${services[2]}/${services[2]}.yaml"
	kubectl apply -f "${srcs}/${services[3]}/${services[3]}.yaml"
	kubectl apply -f "${srcs}/${services[4]}/${services[4]}.yaml"
	kubectl apply -f "${srcs}/${services[5]}/${services[5]}.yaml"
	kubectl apply -f "${srcs}/${services[6]}/${services[6]}.yaml"
	kubectl apply -f "${srcs}/${services[7]}/${services[7]}.yaml"
}

function print_user_info ()
{
	echo "WORDPRESS accounts:";
	echo "  - ${WP_ADMIN}:${WP_ADMIN_PASS}";
	echo "  - ${DB_USER}:${DB_PASS}";
	echo "PHPMYADMIN accounts:";
	echo "  - ${WP_ADMIN}:${WP_ADMIN_PASS}";
	echo "  - ${DB_USER}:${DB_PASS}";
	echo "FTPS account:";
	echo "  - ${FTPS_USER}:${FTPS_PASS}";
	echo "GRAFFNA accounts:";
	echo "  - ${INFLUXDB_USER}:${INFLUXDB_PASS}";
	echo "  - ${INFLUXDB_ADMIN_USER}:${INFLUXDB_ADMIN_PASS}";
}

function kill_docker ()
{
	docker kill $(docker ps -q);
	# docker rm wordpress mysql nginx phpmyadmin ftps grafana telegraf influxdb;
	# docker network rm ${NETWORK_NAME}
	# docker network create ${NETWORK_NAME} --subnet ${DOCKER_SUBNET}
}

function check_VM_settings ()
{
	echo "-----------------------------------------------------------------------\n"
	echo "			Welcome to Ft_Services\n"
	echo "-----------------------------------------------------------------------\n"
	echo "WARNING : you need to run this project on 42VM AND :"
	echo "-Your VM need at least 2 CPU's to run Minikube"
	echo "-Your VM need to give sudo rights to Docker to run it properly"
	echo "-Nginx service is not running"
	echo "if you don't fullfil theses 3 requierements :"
	echo "1- Select \"No\""
	echo "2- Give sudo rights to Docker: sudo usermod -aG docker $(whoami)"
	echo "3- Exit the VM"
	echo "4- Set 2 CPU for the VM"
	echo "5- Restart the VM to apply changes and then relaunch setup.sh"
	echo "6- Stop nginx service"
	echo "-----------------------------------------------------------------------"
	echo "Do you fulfil theses requierments ?"
}

function main ()
{
	check_VM_settings;
	select yn in "Yes" "No"; do
		case $yn in
			Yes ) ;;
			No ) exit;;
		esac
	check_minikube;
	launch_minikube;
	apply_metal_LB;
	kill_docker;
	build_containers;
	# run_containers;
	apply_kub;
	echo 'installing filezilla to test ftps server'
	sudo apt install filezilla;
	print_user_info;
	minikube dashboard;
	exit;
	done
}

main;
