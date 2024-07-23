#!/bin/bash

# Crear el secreto para la CA
kubectl create secret generic strimzi-platform-cluster-ca-cert-for-user --from-file=ca.crt=ca.crt --from-file=ca.password=ca.password --from-file=ca.p12=ca.p12 -n strimzi-platform-dev

# Crear el secreto para el usuario
kubectl create secret generic my-user-secret --from-file=user.crt=user.crt --from-file=user.key=user.key --from-file=user.p12=user.p12 --from-file=user.password=user.password --from-file=user-keystore.jks=user-keystore.jks --from-file=user-truststore.jks=user-truststore.jks -n strimzi-platform-dev
