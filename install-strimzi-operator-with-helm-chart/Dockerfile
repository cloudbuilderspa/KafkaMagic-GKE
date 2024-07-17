# Usar la imagen base de Alpine
FROM alpine:latest

# Establecer el directorio de trabajo
WORKDIR /root

# Instalar dependencias
RUN apk add --no-cache curl bash tar

# Descargar e instalar el operator-sdk
RUN curl -Lo operator-sdk https://github.com/operator-framework/operator-sdk/releases/download/v1.34.2/operator-sdk_linux_amd64 && \
    chmod +x operator-sdk && \
    mv operator-sdk /usr/local/bin/

# Descargar y descomprimir el binario de operator-lifecycle-manager
RUN curl -L https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.28.0/operator-lifecycle-manager_0.28.0_linux_amd64.tar.gz -o olm.tar.gz && \
    tar -xzvf olm.tar.gz && \
    mv olm /usr/local/bin/ && \
    mv catalog /usr/local/bin/ && \
    mv cpb /usr/local/bin/ && \
    mv package-server /usr/local/bin/ && \
    chmod +x /usr/local/bin/olm /usr/local/bin/catalog /usr/local/bin/cpb /usr/local/bin/package-server && \
    rm olm.tar.gz

# Comando por defecto para mantener el contenedor en ejecución
CMD ["sleep", "infinity"]