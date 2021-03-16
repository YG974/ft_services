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

ALPINE_VERSION=3.11
OPENRC_VERSION=0.42.1-r2
NGINX_VERSION=1.16.1-r6
MYSQL_VERSION=10.4.17-r1
PMA_VERSION=4.9.5-r0
WP_VERSION=5.7
PHP_VERSION=7.3.22-r0

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

function build_containers ()
{
	for service in services "${services[@]}"
	do
		docker build -t ${USER}-${service[@]} -f ${srcs}/${service}/Dockerfile ${srcs}/${service}
	done
}

function main ()
{
	#check_minikube;
	#launch_minikube;
	build_containers;
	echo start
}

main;

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


