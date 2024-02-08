FROM ubuntu:20.04
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -yq install unzip curl less groff jq && rm -rf /var/lib/apt/lists/*

ENV KUBECTL_VERSION='1.29.0/2024-01-04'
ENV AWSCLI_VERSION=2.14.5
ENV EKSCTL_VERSION=0.170.0
ENV HELM_VERSION=v3.14.0

WORKDIR /root

RUN curl -sSf -o kubectl.sha256 https://s3.us-west-2.amazonaws.com/amazon-eks/${KUBECTL_VERSION}/bin/linux/arm64/kubectl.sha256
RUN curl -sSf -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/${KUBECTL_VERSION}/bin/linux/arm64/kubectl
RUN openssl sha1 -sha256 kubectl && chmod +x kubectl && mv kubectl /usr/local/bin/ && rm kubectl.sha256
RUN kubectl version --client

RUN curl -sSf "https://awscli.amazonaws.com/awscli-exe-linux-aarch64-${AWSCLI_VERSION}.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip &&  ./aws/install -i /usr/local/aws-cli -b /usr/local/bin && rm awscliv2.zip && rm -r aws
RUN aws --version

RUN curl -sSfL "https://github.com/eksctl-io/eksctl/releases/download/v${EKSCTL_VERSION}/eksctl_Linux_arm64.tar.gz" | tar xz -C /tmp && mv /tmp/eksctl /usr/local/bin
RUN eksctl version

RUN curl -sSfL "https://github.com/helm/helm/releases/download/${HELM_VERSION}/helm-${HELM_VERSION}-linux-arm64.tar.gz.sha256.asc"
RUN curl -sSfL "https://get.helm.sh/helm-${HELM_VERSION}-linux-arm64.tar.gz" -O
RUN openssl sha1 -sha256 helm-${HELM_VERSION}-linux-arm64.tar.gz && tar xf helm-${HELM_VERSION}-linux-arm64.tar.gz -C /tmp && mv /tmp/linux-arm64/helm /usr/local/bin && rm helm-${HELM_VERSION}-linux-arm64.tar.gz
RUN helm version

RUN aws --version
RUN kubectl version --client
RUN eksctl version
RUN helm version
