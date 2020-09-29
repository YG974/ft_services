test:
	sh ./setup.sh

clean:
	sh ./clean.sh

ti:
	kubectl exec service/nginx -ti -- sh
