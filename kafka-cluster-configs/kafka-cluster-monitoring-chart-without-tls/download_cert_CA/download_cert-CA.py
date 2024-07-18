kubectl get secret kafka-cluster-my-cluster-dev-cluster-ca-cert -n kafka -o jsonpath='{.data}'
kubectl get secret my-user -n kafka -o jsonpath='{.data}'
