srcs=./srcs

services=(				\
			nginx		\
			#ftps		\
			#wordpress	\
			#mysql		\
			#phpmyadmin	\
			#grafana	\
			#influxdb	\
)

test:
	sh ./setup.sh


clean:
	sh ./clean.sh


ti:
	kubectl exec service/nginx -ti -- sh


build_nginx:
	docker build -t "${USER}-nginx" -f "${srcs}/nginx/Dockerfile" srcs/nginx


run_nginx: build_nginx
	docker run -p 80:80 -p 443:443 -di --rm ygeslin-nginx:latest

run_nginx_tty: build_nginx
	docker run -p 80:80 -p 443:443 -ti --rm ygeslin-nginx:latest
