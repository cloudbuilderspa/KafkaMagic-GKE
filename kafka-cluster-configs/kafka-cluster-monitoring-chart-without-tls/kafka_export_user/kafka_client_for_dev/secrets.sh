# script.sh
#!/bin/bash

# Descargar y decodificar los secretos
kubectl get secret strimzi-platform-cluster-my-cluster-dev-cluster-ca-cert -n strimzi-platform -o jsonpath='{.data.ca\.crt}' | base64 --decode > /etc/tls/ca.crt
kubectl get secret strimzi-platform-cluster-my-cluster-dev-cluster-ca-cert -n strimzi-platform -o jsonpath='{.data.ca\.password}' | base64 --decode > /etc/tls/ca.password

kubectl get secret strimzi-platform-cluster-my-cluster-dev-cluster-ca-cert -n strimzi-platform -o jsonpath='{.data.ca\.p12}' | base64 --decode > /etc/tls/ca.p12
kubectl get secret my-user -n strimzi-platform -o jsonpath='{.data.user\.crt}' | base64 --decode > /etc/tls/user.crt
kubectl get secret my-user -n strimzi-platform -o jsonpath='{.data.user\.key}' | base64 --decode > /etc/tls/user.key
kubectl get secret my-user -n strimzi-platform -o jsonpath='{.data.user\.p12}' | base64 --decode > /etc/tls/user.p12
kubectl get secret my-user -n strimzi-platform -o jsonpath='{.data.user\.password}' | base64 --decode > /etc/tls/user.password

# Convertir los archivos a formatos utilizables con keytool
keytool -keystore /etc/tls/user-truststore.jks -alias CARoot -import -file /etc/tls/ca.crt -storepass $(cat /etc/tls/ca.password) -noprompt
keytool -importkeystore -srckeystore /etc/tls/user.p12 -srcstoretype pkcs12 -destkeystore /etc/tls/user-keystore.jks -deststoretype jks -srcstorepass $(cat /etc/tls/user.password) -deststorepass $(cat /etc/tls/user.password)

# Verificar los archivos generados
ls -l /etc/tls/user-truststore.jks /etc/tls/user-keystore.jks
