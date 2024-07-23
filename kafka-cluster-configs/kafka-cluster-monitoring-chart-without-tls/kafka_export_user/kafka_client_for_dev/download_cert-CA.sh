#Inspeccionar el contenido de los secretos
kubectl get secret strimzi-platform-my-cluster-dev-cluster-ca-cert -n strimzi-platform-dev -o jsonpath='{.data}'
kubectl get secret my-user -n strimzi-platform-dev -o jsonpath='{.data}'

#Descargar y decodificar los secretos
kubectl get secret strimzi-platform-my-cluster-dev-cluster-ca-cert -n strimzi-platform-dev -o jsonpath='{.data.ca\.crt}' | base64 --decode > ca.crt
kubectl get secret strimzi-platform-my-cluster-dev-cluster-ca-cert -n strimzi-platform-dev -o jsonpath='{.data.ca\.password}' | base64 --decode > ca.password

kubectl get secret strimzi-platform-my-cluster-dev-cluster-ca-cert -n strimzi-platform-dev -o jsonpath='{.data.ca\.p12}' | base64 --decode > ca.p12
kubectl get secret my-user -n strimzi-platform-dev -o jsonpath='{.data.user\.crt}' | base64 --decode > user.crt
kubectl get secret my-user -n strimzi-platform-dev -o jsonpath='{.data.user\.key}' | base64 --decode > user.key
kubectl get secret my-user -n strimzi-platform-dev -o jsonpath='{.data.user\.p12}' | base64 --decode > user.p12
kubectl get secret my-user -n strimzi-platform-dev -o jsonpath='{.data.user\.password}' | base64 --decode > user.password


#Convertir los archivos a formatos utilizables con keytool
keytool -keystore user-truststore.jks -alias CARoot -import -file ca.crt -storepass $(cat ca.password) -noprompt
keytool -importkeystore -srckeystore user.p12 -srcstoretype pkcs12 -destkeystore user-keystore.jks -deststoretype jks -srcstorepass $(cat user.password) -deststorepass $(cat user.password)

#Verificar los archivos generados
ls -l user-truststore.jks user-keystore.jks
