#!/bin/bash

# Crear la estructura de directorios
mkdir -p base crds overlays/development overlays/staging overlays/production

# Crear archivos en la carpeta base
cat <<EOL > base/kustomization.yaml
resources:
EOL

# Crear archivos en la carpeta crds
for crd in kafkabridges kafkaconnectors kafkaconnects kafkamirrormaker2s kafkamirrormakers kafkanodepools kafkarebalances kafkas kafkatopics kafkausers; do
cat <<EOL > crds/${crd}.yaml
apiVersion: kafka.strimzi.io/v1beta2
kind: ${crd^}
metadata:
  name: my-${crd}
spec:
  ...
EOL
done

# Crear archivos en la carpeta overlays/development
cat <<EOL > overlays/development/dev_params.yaml
kafkaBridgesReplicas: 1
kafkaConnectorsReplicas: 1
kafkaConnectsReplicas: 1
kafkaMirrorMaker2sReplicas: 1
kafkaMirrorMakersReplicas: 1
kafkaNodePoolsReplicas: 1
kafkaRebalancesReplicas: 1
kafkasReplicas: 1
kafkaTopicsReplicas: 1
kafkaUsersReplicas: 1
EOL

cat <<EOL > overlays/development/kustomization.yaml
resources:
- ../../crds/kafkabridges.yaml
- ../../crds/kafkaconnectors.yaml
- ../../crds/kafkaconnects.yaml
- ../../crds/kafkamirrormaker2s.yaml
- ../../crds/kafkamirrormakers.yaml
- ../../crds/kafkanodepools.yaml
- ../../crds/kafkarebalances.yaml
- ../../crds/kafkas.yaml
- ../../crds/kafkatopics.yaml
- ../../crds/kafkausers.yaml

configMapGenerator:
- name: dev-config
  files:
    - dev_params.yaml

patchesStrategicMerge:
- patch_dev.yaml
EOL

cat <<EOL > overlays/development/patch_dev.yaml
apiVersion: kafka.strimzi.io/v1beta2
kind: Kafka
metadata:
  name: my-cluster
spec:
  kafka:
    replicas: \$(kafkasReplicas)
EOL

# Crear archivos en la carpeta overlays/staging
cat <<EOL > overlays/staging/staging_params.yaml
kafkaBridgesReplicas: 2
kafkaConnectorsReplicas: 2
kafkaConnectsReplicas: 2
kafkaMirrorMaker2sReplicas: 2
kafkaMirrorMakersReplicas: 2
kafkaNodePoolsReplicas: 2
kafkaRebalancesReplicas: 2
kafkasReplicas: 2
kafkaTopicsReplicas: 2
kafkaUsersReplicas: 2
EOL

cat <<EOL > overlays/staging/kustomization.yaml
resources:
- ../../crds/kafkabridges.yaml
- ../../crds/kafkaconnectors.yaml
- ../../crds/kafkaconnects.yaml
- ../../crds/kafkamirrormaker2s.yaml
- ../../crds/kafkamirrormakers.yaml
- ../../crds/kafkanodepools.yaml
- ../../crds/kafkarebalances.yaml
- ../../crds/kafkas.yaml
- ../../crds/kafkatopics.yaml
- ../../crds/kafkausers.yaml

configMapGenerator:
- name: staging-config
  files:
    - staging_params.yaml

patchesStrategicMerge:
- patch_staging.yaml
EOL

cat <<EOL > overlays/staging/patch_staging.yaml
apiVersion: kafka.strimzi.io/v1beta2
kind: Kafka
metadata:
  name: my-cluster
spec:
  kafka:
    replicas: \$(kafkasReplicas)
EOL

# Crear archivos en la carpeta overlays/production
cat <<EOL > overlays/production/prod_params.yaml
kafkaBridgesReplicas: 3
kafkaConnectorsReplicas: 3
kafkaConnectsReplicas: 3
kafkaMirrorMaker2sReplicas: 3
kafkaMirrorMakersReplicas: 3
kafkaNodePoolsReplicas: 3
kafkaRebalancesReplicas: 3
kafkasReplicas: 3
kafkaTopicsReplicas: 3
kafkaUsersReplicas: 3
EOL

cat <<EOL > overlays/production/kustomization.yaml
resources:
- ../../crds/kafkabridges.yaml
- ../../crds/kafkaconnectors.yaml
- ../../crds/kafkaconnects.yaml
- ../../crds/kafkamirrormaker2s.yaml
- ../../crds/kafkamirrormakers.yaml
- ../../crds/kafkanodepools.yaml
- ../../crds/kafkarebalances.yaml
- ../../crds/kafkas.yaml
- ../../crds/kafkatopics.yaml
- ../../crds/kafkausers.yaml

configMapGenerator:
- name: prod-config
  files:
    - prod_params.yaml

patchesStrategicMerge:
- patch_prod.yaml
EOL

cat <<EOL > overlays/production/patch_prod.yaml
apiVersion: kafka.strimzi.io/v1beta2
kind: Kafka
metadata:
  name: my-cluster
spec:
  kafka:
    replicas: \$(kafkasReplicas)
EOL

echo "Estructura de directorios y archivos creada exitosamente."
