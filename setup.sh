#! /bin/bash

#--------------------------- Variables ----------------------------------------#

services=(				\
			mysql		\
			wordpress	\
			phpmyadmin	\
			nginx		\
			#ftps		\
			#grafana	\
			#influxdb	\
)

# VERSION
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

# NETWORK
NETWORK_NAME="cluster";
MYSQL_IP="172.18.0.2";
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

# FTPS settings
FTPS_USER="ftp_user";
FTPS_PASS="ftp_pass";	

# INFLUXDB settings
INFLUXDB_DB="telegraf";
INFLUXDB_ADMIN_USER="admin";
INFLUXDB_ADMIN_PASS="admin";
INFLUXDB_USER="user";
INFLUXDB_PASS="user";


srcs=./srcs

metallb_version="v0.9.3"
minikube_version="v1.9.0"

function launch_minikube ()
{
	echo "launch Minikube\n";
# deleting previous clusters
minikube delete > /dev/null 2>&1
# minikube start 
minikube start --cpus=12
#minikube addons enable metallb
minikube addons enable metrics-server
minikube addons enable dashboard
## add minikube env variables
}

# check the version of minikube
# if version 1.9 is installed, go to next step
# if version 1.9 is not installed, remove the existing version, and install 1.9

function check_minikube ()
{
	minikube version | grep "$minikube_version"
	if [ "$?" == 0 ]
	then
		echo good version
	else
		echo bad
		#sudo apt install minikube=1.9.0
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
	--build-arg NGINX_VERSION=${NGINX_VERSION} \
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
	--build-arg	FTPS_USER=${FTPS_USER} \
	--build-arg	FTPS_PASS=${FTPS_PASS} \
	-f ${srcs}/${svc}/Dockerfile ${srcs}/${svc}
}

function build_influxdb ()
{
	svc=influxdb;
	docker build -t my-${svc} \
	--build-arg ALPINE_VERSION=${ALPINE_VERSION} \
	--build-arg OPENRC_VERSION=${OPENRC_VERSION} \
	--build-arg INFLUXDB_VERSION=${INFLUXDB_VERSION} \
	--build-arg INFLUXDB_ADMIN_USER=${INFLUXDB_ADMIN_USER} \
	--build-arg INFLUXDB_ADMIN_PASS=${INFLUXDB_ADMIN_PASS} \
	--build-arg INFLUXDB_USER=${INFLUXDB_USER} \
	--build-arg INFLUXDB_PASS=${INFLUXDB_PASS} \
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
	build_mysql;
	build_wordpress;
	build_phpmyadmin;
	build_nginx;
	#for service in services "${services[@]}"
	#do
		#echo "building ${services[@]}\n"
		#docker build -t ${service[@]} -f ${srcs}/${service[@]}/Dockerfile ${srcs}/${service[@]}
	#done
}


# DATABASE USERS INFO

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
	#docker run --network=${NETWORK_NAME} --ip ${MYSQL_IP} -p 3306:3306 -d -t mysql
	#docker run --network=${NETWORK_NAME} -p 3306:3306 -d -t mysql
	#docker network connect --alias db --alias mysql ${NETWORK_NAME} mysql:latest
	#docker run --network=${NETWORK_NAME} -p 5050:5050 -d -t  wordpress
	#docker run --network=${NETWORK_NAME} -p 5000:5000 -d -t  phpmyadmin
	#docker network connect ${NETWORK_NAME} nginx:latest
	#docker network connect cluster wordpress:latest
	#docker network connect cluster phpmyadmin:latest
}

apply_metal_LB ()
{
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/namespace.yaml
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/metallb.yaml
	# On first install only
	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
	kubectl apply -f "$srcs/config.yaml"
	# kubectl apply -f "$srcs/metallb.yaml"
	# kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
}

apply_kub ()
{
	# kubectl apply -f "${srcs}/${services[0]}/${services[0]}.yaml"
	# kubectl apply -f "${srcs}/${services[1]}/${services[1]}.yaml"
	kubectl apply -f "${srcs}/${services[2]}/${services[2]}.yaml"
	# kubectl apply -f "${srcs}/${services[3]}/${services[3]}.yaml"
}

function main ()
{
	# docker kill $(docker ps -q);
	# docker rm wordpress mysql nginx phpmyadmin ftps grafana telegraf influxdb;
	# docker network rm ${NETWORK_NAME}
	# docker network create ${NETWORK_NAME} --subnet ${DOCKER_SUBNET}
	# check_minikube;
	# launch_minikube;
	# apply_metal_LB;
	# echo "adding minikube docker env\n"
	# eval $(minikube -p minikube docker-env)
	
	# build_containers;
	# build_mysql;
	# build_wordpress;
	build_phpmyadmin;
	# build_nginx;
	# build_ftps;
	# build_grafana;
	# build_influxdb;
	# build_telegraf;
	# run_influxdb;
	# run_telegraf;
	# run_grafana;
	# run_ftps;
	# run_mysql;
	# run_nginx;
	# run_phpmyadmin;
	# run_wordpress;
	#run_containers;
	apply_kub;
	# echo start
}

main;
exit;

#--------------------------- Checking dependences------------------------------#

function VM_settings ()
{
echo "-----------------------------------------------------------------------\n"
echo "			Welcome to Ft_Services\n"
echo "-----------------------------------------------------------------------\n"
echo "WARNING : you need to run this project on 42VM AND :\n"
echo "-Your VM need at least 2 CPU's to run Minikube\n"
echo "-Your VM need to give sudo rights to Docker to run it properly\n"
echo "if you don't fullfil theses 2 requierements :"
echo "1- Select \"No\""
echo "2- Give sudo rights to Docker: sudo usermod -aG docker \$(whoami)"
echo "3- Exit the VM"
echo "4- Set 2 CPU for the VM"
echo "5- Restart the VM to apply changes and then relaunch setup.sh\n"
echo "-----------------------------------------------------------------------\n"
echo "Do you fulfil theses requierments ?\n"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) main;;
        No ) exit;;
    esac
done
}


#--------------------------- Building contenairs ------------------------------#
# if minikube is no running, start minikube
#if ! minikube status > /dev/null 2>&1
	#then
		#minikube start --driver=docker --cpus=2
		#minikube addons enable metallb
		#minikube addons enable metrics-server
		#minikube addons enable dashboard
#fi

## add minikube env variables
#echo "adding minikube docker env\n"
#eval $(minikube -p minikube docker-env)
#minikube addons configure metallb eval $(minikube docker-env)

# How to install metallb => https://metallb.universe.tf/installation/
# enable strict ARP mode to use kube-proxy
# 1- see what changes would be made, returns nonzero returncode if different
#kubectl get configmap kube-proxy -n kube-system -o yaml | \
#sed -e "s/strictARP: false/strictARP: true/" | \
#kubectl diff -f - -n kube-system
# 2- actually apply the changes, returns nonzero returncode on errors only
#kubectl get configmap kube-proxy -n kube-system -o yaml | \
#sed -e "s/strictARP: false/strictARP: true/" | \
#kubectl apply -f - -n kube-system

# templates for metallb v0.9.3 download at :
# https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
# https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
#kubectl apply -f "$srcs/config.yaml"
#kubectl apply -f "$srcs/metallb.yaml"
# On first install only


#for service in services "${services[@]}"
#docker build -t "$USER-nginx" -f "$srcs/nginx/Dockerfile" srcs/nginx
#kubectl apply -f srcs/nginx/nginx.yaml
#kubectl apply -f srcs/nginx/nginx.yaml


