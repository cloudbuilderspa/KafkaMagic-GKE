#!/bin/bash

# Function to check for errors
check_error() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Apply operator-sdk-install-pod.yaml
kubectl apply -f operator-sdk-install-pod.yaml
check_error "Failed to apply operator-sdk-install-pod.yaml"

# Sleep for 60 seconds
sleep 60

# Apply strimzi-kafka-operator.yaml
kubectl apply -f strimzi-kafka-operator.yaml
check_error "Failed to apply strimzi-kafka-operator.yaml"

echo "Installation completed successfully."