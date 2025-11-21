FROM alpine:3.19

# Install base dependencies
RUN apk add --no-cache \
    bash \
    curl \
    git \
    ca-certificates \
    tar \
    bzip2

# Install kubectl
ARG KUBECTL_VERSION=1.28.4
RUN curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Install helm (version < 4.0, using 3.13.3)
ARG HELM_VERSION=3.13.3
RUN curl -LO "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" && \
    tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm -rf linux-amd64 helm-v${HELM_VERSION}-linux-amd64.tar.gz

# Install helm diff plugin
RUN helm plugin install https://github.com/databus23/helm-diff

# Install helmfile
ARG HELMFILE_VERSION=0.159.0
RUN curl -LO "https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz" && \
    tar -zxvf helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz && \
    mv helmfile /usr/local/bin/helmfile && \
    rm helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz

# Set default version for opendesk
ENV OPENDESK_VERSION=v1.9.0

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set working directory
WORKDIR /workspace

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
