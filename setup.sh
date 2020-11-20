#--------------------------- Variables ----------------------------------------#

services=(				\
			nginx		\
			#ftps		\
			#wordpress	\
			#mysql		\
			#phpmyadmin	\
			#grafana	\
			#influxdb	\
)

srcs=./srcs

metallb_version="v0.9.3"


#--------------------------- Building contenairs ------------------------------#

# cif minikube is no running, start minikube
if ! minikube status > /dev/null 2>&1
	then
		minikube start
		minikube addons enable metallb
		minikube addons enable metrics-server
		minikube addons enable dashboard
fi

# add minikube env variables
echo "adding minikube docker env\n"
eval $(minikube -p minikube docker-env)
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
kubectl apply -f "$srcs/config.yaml"
kubectl apply -f "$srcs/metallb.yaml"
# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"


#for service in services "${services[@]}"
docker build -t "$USER-nginx" -f "$srcs/nginx/Dockerfile" srcs/nginx
#kubectl apply -f srcs/nginx/nginx.yaml
kubectl apply -f srcs/nginx/nginx.yaml


