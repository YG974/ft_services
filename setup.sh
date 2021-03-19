#! /bin/bash

#--------------------------- Variables ----------------------------------------#

services=(				\
			nginx		\
			wordpress	\
			mysql		\
			phpmyadmin	\
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

# NETWORK
NETWORK_NAME="cluster";
MYSQL_IP="172.18.0.2";
WP_IP="172.18.0.3";
PMA_IP="172.18.0.4";
NGINX_IP="172.18.0.5";
DOCKER_SUBNET="172.18.0.0/16";

# DATABASE USERS INFO

DB_NAME="wp_db";
DB_USER="user";
DB_PASS="user";
WP_ADMIN="admin";
WP_ADMIN_PASS="admin";


srcs=./srcs

metallb_version="v0.9.3"
minikube_version="v1.9.0"

function launch_minikube ()
{
	echo "launch Minikube\n";
# deleting previous clusters
minikube delete > /dev/null 2>&1
minikube start --driver=docker --cpus=2
#minikube addons enable metallb
minikube addons enable metrics-server
minikube addons enable dashboard
## add minikube env variables
echo "adding minikube docker env\n"
eval $(minikube -p minikube docker-env)
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
		docker build -t ${USER}-${svc} \
		--build-arg ALPINE_VERSION=${ALPINE_VERSION} \
		--build-arg NGINX_VERSION=${NGINX_VERSION} \
		-f ${srcs}/${svc}/Dockerfile ${srcs}/${svc}
}

function build_mysql ()
{
	svc=mysql;
	docker build -t ${USER}-${svc} \
	--build-arg ALPINE_VERSION=${ALPINE_VERSION} \
	--build-arg MYSQL_VERSION=${MYSQL_VERSION} \
	--build-arg NGINX_VERSION=${NGINX_VERSION} \
	--build-arg OPENRC_VERSION=${OPENRC_VERSION} \
	-f ${srcs}/${svc}/Dockerfile ${srcs}/${svc}
}

function build_phpmyadmin ()
{
	svc=phpmyadmin;
	docker build -t ${USER}-${svc} \
	--build-arg ALPINE_VERSION=${ALPINE_VERSION} \
	--build-arg NGINX_VERSION=${NGINX_VERSION} \
	--build-arg PMA_VERSION=${PMA_VERSION} \
	-f ${srcs}/${svc}/Dockerfile ${srcs}/${svc}
}

function build_wordpress ()
{
	svc=wordpress;
	docker build -t ${USER}-${svc} \
	--build-arg ALPINE_VERSION=${ALPINE_VERSION} \
	--build-arg NGINX_VERSION=${NGINX_VERSION} \
	--build-arg WP_VERSION=${WP_VERSION} \
	--build-arg PHP_VERSION=${PHP_VERSION} \
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
		#docker build -t ${USER}-${service[@]} -f ${srcs}/${service[@]}/Dockerfile ${srcs}/${service[@]}
	#done
}

	#-e MYSQL_IP=$MYSQL_IP \

NETWORK_NAME="cluster";
NGINX_IP="172.18.0.5";
DOCKER_SUBNET="172.18.0.0/16";

# DATABASE USERS INFO

function run_mysql ()
{
	docker run --network ${NETWORK_NAME} --ip ${MYSQL_IP} -t -d \
	-e WP_IP=${WP_IP}			-e DB_NAME=${DB_NAME} \
	-e DB_USER=${DB_USER}		-e DB_PASS=${DB_PASS} \
	-e MYSQL_IP=${MYSQL_IP}		-e PMA_IP=${PMA_IP} \
	-e NGINX_IP=${NGINX_IP}		-e DOCKER_SUBNET=${DOCKER_SUBNET} \
	-e WP_ADMIN=${WP_ADMIN}		-e WP_ADMIN_PASS=${WP_ADMIN_PASS} \
	-p 3306:3306 \
	${USER}-mysql
}

function run_nginx ()
{
	docker run --network=${NETWORK_NAME} --ip=${NGINX_IP} -t -d \
	-e WP_IP=${WP_IP}			-e DB_NAME=${DB_NAME} \
	-e DB_USER=${DB_USER}		-e DB_PASS=${DB_PASS} \
	-e MYSQL_IP=${MYSQL_IP}		-e PMA_IP=${PMA_IP} \
	-e NGINX_IP=${NGINX_IP}		-e DOCKER_SUBNET=${DOCKER_SUBNET} \
	-p 80:80 -p 443:443 \
	${USER}-nginx
}

function run_wordpress ()
{
	docker run --network=${NETWORK_NAME} --ip=${WP_IP} -d -t \
	-e WP_IP=${WP_IP}			-e DB_NAME=${DB_NAME} \
	-e DB_USER=${DB_USER}		-e DB_PASS=${DB_PASS} \
	-e MYSQL_IP=${MYSQL_IP}		-e PMA_IP=${PMA_IP} \
	-e NGINX_IP=${NGINX_IP}		-e DOCKER_SUBNET=${DOCKER_SUBNET} \
	-p 5050:5050 \
	${USER}-wordpress
}

function run_phpmyadmin ()
{
	docker run --network=${NETWORK_NAME} --ip=${PMA_IP} -d -t \
	-e WP_IP=${WP_IP}			-e DB_NAME=${DB_NAME} \
	-e DB_USER=${DB_USER}		-e DB_PASS=${DB_PASS} \
	-e MYSQL_IP=${MYSQL_IP}		-e PMA_IP=${PMA_IP} \
	-e NGINX_IP=${NGINX_IP}		-e DOCKER_SUBNET=${DOCKER_SUBNET} \
	-p 5000:5000 \
	${USER}-phpmyadmin
}


function run_containers ()
{
	docker network rm ${NETWORK_NAME}
	docker network create ${NETWORK_NAME} --subnet ${DOCKER_SUBNET}
	run_mysql;
	run_wordpress;
	run_nginx;
	run_phpmyadmin;
	#docker run --network=${NETWORK_NAME} --ip ${MYSQL_IP} -p 3306:3306 -d -t ${USER}-mysql
	#docker run --network=${NETWORK_NAME} -p 3306:3306 -d -t ${USER}-mysql
	#docker network connect --alias db --alias mysql ${NETWORK_NAME} ${USER}-mysql:latest
	#docker run --network=${NETWORK_NAME} -p 5050:5050 -d -t  ${USER}-wordpress
	#docker run --network=${NETWORK_NAME} -p 5000:5000 -d -t  ${USER}-phpmyadmin
	#docker network connect ${NETWORK_NAME} ${USER}-nginx:latest
	#docker network connect cluster ${USER}-wordpress:latest
	#docker network connect cluster ${USER}-phpmyadmin:latest
}

apply_metal_LB ()
{
	kubectl apply -f "$srcs/config.yaml"
	kubectl apply -f "$srcs/metallb.yaml"
}

apply_kub ()
{
	kubectl apply -f "${srcs}/${services[@]}/${services[@]}\.yaml"

}

function main ()
{
	docker kill $(docker ps -q);
	#check_minikube;
	#launch_minikube;
	build_containers;
	#build_mysql;
	#build_wordpress;
	#build_nginx;
	#build_phpmyadmin;
	run_containers;
	#apply_metal_LB;
	#apply_kub;
	echo start
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
#kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"


#for service in services "${services[@]}"
#docker build -t "$USER-nginx" -f "$srcs/nginx/Dockerfile" srcs/nginx
#kubectl apply -f srcs/nginx/nginx.yaml
#kubectl apply -f srcs/nginx/nginx.yaml


