#!/bin/zsh
docker kill $(`docker ps -q`)
docker network rm cluster
#kubectl delete daemonsets,replicasets,services,deployments,pods,rc --all
#minikube delete
#minikube stop

