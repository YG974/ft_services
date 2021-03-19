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

kill:
	zsh ./clean.sh

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

build_wp:
	docker build -t "${USER}-wp" -f "${srcs}/wordpress/Dockerfile" srcs/wordpress

run_wp_tty: build_wp
	docker run -p 5050:5050 -ti --rm ygeslin-wp:latest

build_sql:
	docker build -t "${USER}-sql" -f "${srcs}/mysql/Dockerfile" srcs/mysql

run_sql_tty: build_sql
	docker run -p 3306:3306 -ti --rm ygeslin-sql:latest
