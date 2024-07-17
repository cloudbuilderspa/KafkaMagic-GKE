#!/bin/bash

# Crear la estructura de directorios
mkdir -p kafka-cluster-chart/templates

# Crear el archivo .helmignore
cat <<EOF > kafka-cluster-chart/.helmignore
# Patterns to ignore when packaging Helm charts.
.DS_Store
*.swp
*.bak
*.tmp
*.orig
*.old
*.log
*.lock
*.gz
*.tgz
*.zip
*.zst
*.o
*.a
*.so
*.exe
*.out
*.obj
.idea/
.project
.settings/
*.iml
*.class
*.jar
*.war
*.ear
*.tar
*.gz
*.tgz
*.zip
*.zst
*.rpm
*.deb
*.npm
node_modules/
npm-debug.log
yarn.lock
yarn-error.log
package-lock.json
dist/
EOF

# Crear el archivo Chart.yaml
cat <<EOF > kafka-cluster-chart/Chart.yaml
apiVersion: v2
name: kafka-cluster-chart
description: A Helm chart for deploying a Kafka Cluster with Strimzi
version: 0.1.0
appVersion: 3.6.0
EOF

# Crear el archivo values.yaml
cat <<EOF > kafka-cluster-chart/values.yaml
global:
  clusterName: "my-cluster"
  kafkaVersion: "3.6.0"
  kafkaReplicas: 3
  kafkaMemoryRequest: "5Gi"
  kafkaCpuRequest: "1"
  kafkaMemoryLimit: "5Gi"
  kafkaCpuLimit: "2"
  kafkaJvmXms: "4096m"
  kafkaJvmXmx: "4096m"
  offsetsTopicReplicationFactor: 3
  transactionStateLogReplicationFactor: 3
  transactionStateLogMinIsr: 2
  defaultReplicationFactor: 3
  minInsyncReplicas: 2
  interBrokerProtocolVersion: "3.4"
  kafkaStorageSize: "100Gi"
  kafkaStorageClass: "premium-rwo"
  zookeeperReplicas: 3
  zookeeperMemoryRequest: "2560Mi"
  zookeeperCpuRequest: "1000m"
  zookeeperMemoryLimit: "2560Mi"
  zookeeperCpuLimit: "2000m"
  zookeeperJvmXms: "2048m"
  zookeeperJvmXmx: "2048m"
  zookeeperStorageSize: "100Gi"
  zookeeperStorageClass: "premium-rwo"
  tlsSidecarCpuRequest: "100m"
  tlsSidecarMemoryRequest: "128Mi"
  tlsSidecarCpuLimit: "500m"
  tlsSidecarMemoryLimit: "128Mi"
  topicOperatorCpuRequest: "100m"
  topicOperatorMemoryRequest: "512Mi"
  topicOperatorCpuLimit: "500m"
  topicOperatorMemoryLimit: "512Mi"
  userOperatorCpuRequest: "500m"
  userOperatorEphemeralStorageRequest: "1Gi"
  userOperatorMemoryRequest: "2Gi"
  userOperatorCpuLimit: "500m"
  userOperatorEphemeralStorageLimit: "1Gi"
  userOperatorMemoryLimit: "2Gi"
EOF

# Crear el archivo _helpers.tpl
cat <<EOF > kafka-cluster-chart/templates/_helpers.tpl
{{- define "kafka.fullname" -}}
{{- printf "%s-%s" .Release.Name .Values.global.clusterName | trunc 63 | trimSuffix "-" -}}
{{- end -}}
EOF

# Crear el archivo kafka-cluster.yaml
cat <<EOF > kafka-cluster-chart/templates/kafka-cluster.yaml
apiVersion: kafka.strimzi.io/v1beta2
kind: Kafka
metadata:
  name: {{ include "kafka.fullname" . }}
spec:
  kafka:
    version: {{ .Values.global.kafkaVersion }}
    replicas: {{ .Values.global.kafkaReplicas }}
    template:
      pod:
        tolerations:
          - key: "app.stateful/component"
            operator: "Equal"
            value: "kafka-broker"
            effect: NoSchedule
        affinity:
          nodeAffinity:
            preferredDuringSchedulingIgnoredDuringExecution:
              - weight: 1
                preference:
                  matchExpressions:
                    - key: "app.stateful/component"
                      operator: "In"
                      values: 
                        - "kafka-broker"
        topologySpreadConstraints:
          - maxSkew: 1
            topologyKey: "topology.kubernetes.io/zone"
            whenUnsatisfiable: DoNotSchedule
            labelSelector:
              matchLabels:
                app.kubernetes.io/name: kafka
                strimzi.io/cluster: {{ include "kafka.fullname" . }}
                strimzi.io/component-type: kafka
    resources:
      requests:
        memory: {{ .Values.global.kafkaMemoryRequest }}
        cpu: {{ .Values.global.kafkaCpuRequest }}
      limits:
        memory: {{ .Values.global.kafkaMemoryLimit }}
        cpu: {{ .Values.global.kafkaCpuLimit }}
    jvmOptions:
      -Xms: {{ .Values.global.kafkaJvmXms }}
      -Xmx: {{ .Values.global.kafkaJvmXmx }}
    listeners:
      - name: plain
        port: 9092
        type: internal
        tls: false
      - name: tls
        port: 9093
        type: internal
        tls: true
    config:
      offsets.topic.replication.factor: {{ .Values.global.offsetsTopicReplicationFactor }}
      transaction.state.log.replication.factor: {{ .Values.global.transactionStateLogReplicationFactor }}
      transaction.state.log.min.isr: {{ .Values.global.transactionStateLogMinIsr }}
      default.replication.factor: {{ .Values.global.defaultReplicationFactor }}
      min.insync.replicas: {{ .Values.global.minInsyncReplicas }}
      inter.broker.protocol.version: "{{ .Values.global.interBrokerProtocolVersion }}"
    storage:
      type: jbod
      volumes:
        - id: 0
          type: persistent-claim
          size: {{ .Values.global.kafkaStorageSize }}
          class: {{ .Values.global.kafkaStorageClass }}
          deleteClaim: false
  zookeeper:
    template:
      pod:
        affinity:
          nodeAffinity:
            preferredDuringSchedulingIgnoredDuringExecution:
              - weight: 1
                preference:
                  matchExpressions:
                    - key: "app.stateful/component"
                      operator: "In"
                      values: 
                        - "zookeeper"
        topologySpreadConstraints:
          - maxSkew: 1
            topologyKey: "topology.kubernetes.io/zone"
            whenUnsatisfiable: DoNotSchedule
            labelSelector:
              matchLabels:
                app.kubernetes.io/name: zookeeper
                strimzi.io/cluster: {{ include "kafka.fullname" . }}
                strimzi.io/component-type: zookeeper
    replicas: {{ .Values.global.zookeeperReplicas }}
    resources:
      requests:
        memory: {{ .Values.global.zookeeperMemoryRequest }}
        cpu: {{ .Values.global.zookeeperCpuRequest }}
      limits:
        memory: {{ .Values.global.zookeeperMemoryLimit }}
        cpu: {{ .Values.global.zookeeperCpuLimit }}
    jvmOptions:
      -Xms: {{ .Values.global.zookeeperJvmXms }}
      -Xmx: {{ .Values.global.zookeeperJvmXmx }}
    storage:
      type: persistent-claim
      size: {{ .Values.global.zookeeperStorageSize }}
      class: {{ .Values.global.zookeeperStorageClass }}
      deleteClaim: false
  entityOperator:
    tlsSidecar:
      resources:
        requests:
          cpu: {{ .Values.global.tlsSidecarCpuRequest }}
          memory: {{ .Values.global.tlsSidecarMemoryRequest }}
        limits:
          cpu: {{ .Values.global.tlsSidecarCpuLimit }}
          memory: {{ .Values.global.tlsSidecarMemoryLimit }}
    topicOperator:
      resources:
        requests:
          cpu: {{ .Values.global.topicOperatorCpuRequest }}
          memory: {{ .Values.global.topicOperatorMemoryRequest }}
        limits:
          cpu: {{ .Values.global.topicOperatorCpuLimit }}
          memory: {{ .Values.global.topicOperatorMemoryLimit }}
    userOperator:
      resources:
        requests:
          cpu: {{ .Values.global.userOperatorCpuRequest }}
          ephemeral-storage: {{ .Values.global.userOperatorEphemeralStorageRequest }}
          memory: {{ .Values.global.userOperatorMemoryRequest }}
        limits:
          cpu: {{ .Values.global.userOperatorCpuLimit }}
          ephemeral-storage: {{ .Values.global.userOperatorEphemeralStorageLimit }}
          memory: {{ .Values.global.userOperatorMemoryLimit }}
EOF

# Mensaje de finalización
echo "Helm chart structure created successfully."