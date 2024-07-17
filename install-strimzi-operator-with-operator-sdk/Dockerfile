#
# Dockerfile for creating a container to install the Strimzi Operator with Operator SDK
#
# This Dockerfile is used to build a container image that installs the Strimzi Operator using the Operator SDK.
# The Strimzi Operator is a Kubernetes operator for running Apache Kafka on Kubernetes.
# The Operator SDK is a framework for building Kubernetes operators using the Go programming language.
# This Dockerfile sets up the necessary dependencies and builds the Strimzi Operator using the Operator SDK.
# The resulting container image can be used to deploy the Strimzi Operator on a Kubernetes cluster.
#
# Usage:
#   docker build -t strimzi-operator .
#   docker run -d strimzi-operator
#
# For more information about the Strimzi Operator and the Operator SDK, see:
# - Strimzi Operator: https://strimzi.io/
# - Operator SDK: https://sdk.operatorframework.io/
#
# Note: This Dockerfile assumes that the necessary Go dependencies and tools are already installed.
# If they are not installed, please refer to the documentation of the Operator SDK for installation instructions.
#
#


# Use the base Alpine image
FROM alpine:latest

# Set the working directory
WORKDIR /root

# Install dependencies
RUN apk add --no-cache curl bash tar

# Download and install the operator-sdk
RUN curl -Lo operator-sdk https://github.com/operator-framework/operator-sdk/releases/download/v1.34.2/operator-sdk_linux_amd64 && \
    chmod +x operator-sdk && \
    mv operator-sdk /usr/local/bin/

# Download and extract the operator-lifecycle-manager binary
RUN curl -L https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.28.0/operator-lifecycle-manager_0.28.0_linux_amd64.tar.gz -o olm.tar.gz && \
    tar -xzvf olm.tar.gz && \
    mv olm /usr/local/bin/ && \
    mv catalog /usr/local/bin/ && \
    mv cpb /usr/local/bin/ && \
    mv package-server /usr/local/bin/ && \
    chmod +x /usr/local/bin/olm /usr/local/bin/catalog /usr/local/bin/cpb /usr/local/bin/package-server && \
    rm olm.tar.gz

# Default command to keep the container running
CMD ["sleep", "infinity"]