kubectl create secret generic kafka-exporter-user-secrets \
  --from-file=ca.crt=ca.crt \
  --from-file=user.crt=user.crt \
  --from-file=user.key=user.key \
  --from-file=user-truststore.jks=user-truststore.jks \
  --from-file=user-keystore.jks=user-keystore.jks \
  --from-literal=user.password=UVrWJU6nhVgjp2euUj74iUMAepG95S2V \
  --from-literal=ca.password=U55nQYcabZzU \
  -n strimzi-platform-dev