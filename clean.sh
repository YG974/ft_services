#!bin/sh

kubectl delete daemonsets,replicasets,services,deployments,pods,rc --all
minikube delete
minikube stop

