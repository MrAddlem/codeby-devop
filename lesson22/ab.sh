WORDPRESS_IP=$(kubectl get service wordpress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
WORDPRESS_URL="http://$WORDPRESS_IP/"

ab -n 10000 -c 100 $WORDPRESS_URL