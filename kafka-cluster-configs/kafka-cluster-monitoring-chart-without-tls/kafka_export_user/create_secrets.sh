kubectl create secret generic kafka-exporter-user-secrets \
  --from-file=ca.crt=ca.crt \
  --from-file=user.crt=user.crt \
  --from-file=user.key=user.key \
  --from-file=user-truststore.jks=user-truststore.jks \
  --from-file=user-keystore.jks=user-keystore.jks \
  --from-literal=user.password=MxrJTQHOCVzfZZbSkL6td07fW0xmPtcU \
  --from-literal=ca.password=SUwN7k9OcPvd \
  -n strimzi-platform