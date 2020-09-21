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



#--------------------------- Building contenairs ------------------------------#

#minikube start
# add minikube env variables
echo "adding minikube docker env\n"
eval $(minikube docker-env)

#for service in services "${services[@]}"
docker build -t "$USER-nginx" -f "$srcs/nginx/Dockerfile" .

