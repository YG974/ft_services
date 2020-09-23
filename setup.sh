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

#minikube start
# add minikube env variables
echo "adding minikube docker env\n"
eval $(minikube -p minikube docker-env)
#minikube addons configure metallb eval $(minikube docker-env)
minikube addons enable metallb
minikube addons enable dashboard

# How to install metallb
# https://metallb.universe.tf/installation/
kubectl apply -f
https://raw.githubusercontent.com/metallb/metallb/$metallb_version/manifests/namespace.yaml
kubectl apply -f
https://raw.githubusercontent.com/metallb/metallb/$metall_version/manifests/metallb.yaml
# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"


#for service in services "${services[@]}"
docker build -t "$USER-nginx" -f "$srcs/nginx/Dockerfile" srcs/nginx/.


