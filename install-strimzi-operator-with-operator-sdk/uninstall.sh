#!/bin/bash

# Namespaces donde OLM y operadores están instalados
OLM_NAMESPACE="olm"
OPERATORS_NAMESPACE="operators"

# Eliminar todas las suscripciones y grupos de operadores
kubectl delete subscriptions --all -n $OLM_NAMESPACE
kubectl delete subscriptions --all -n $OPERATORS_NAMESPACE
kubectl delete operatorgroups --all -n $OLM_NAMESPACE
kubectl delete operatorgroups --all -n $OPERATORS_NAMESPACE

# Eliminar todos los CustomResourceDefinitions (CRDs)
kubectl delete crd --all

# Eliminar todos los InstallPlans, CatalogSources, y ClusterServiceVersions (CSVs)
kubectl delete installplans --all -n $OLM_NAMESPACE
kubectl delete installplans --all -n $OPERATORS_NAMESPACE
kubectl delete catalogsources --all -n $OLM_NAMESPACE
kubectl delete catalogsources --all -n $OPERATORS_NAMESPACE
kubectl delete clusterserviceversions --all -n $OLM_NAMESPACE
kubectl delete clusterserviceversions --all -n $OPERATORS_NAMESPACE

# Eliminar los namespaces de OLM y operadores
kubectl delete namespace $OLM_NAMESPACE
kubectl delete namespace $OPERATORS_NAMESPACE

# Verificar que todos los recursos relacionados con OLM se han eliminado
kubectl get all --all-namespaces

echo "Desinstalación completa de OLM y todos los operadores y objetos relacionados."
