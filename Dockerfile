FROM ubuntu:20.04
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -yq install unzip curl less groff jq && rm -rf /var/lib/apt/lists/*

ENV KUBECTL_VERSION='1.19.6/2021-01-05'
ENV AWSCLI_VERSION=2.1.30
ENV EKSCTL_VERSION=0.40.0

WORKDIR /root

RUN curl -sSf -o kubectl.sha256 https://amazon-eks.s3.us-west-2.amazonaws.com/${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256
RUN curl -sSf -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
RUN openssl sha1 -sha256 kubectl && chmod +x kubectl && mv kubectl /usr/local/bin/ && rm kubectl.sha256
RUN kubectl version --short --client

RUN curl -sSf "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip &&  ./aws/install -i /usr/local/aws-cli -b /usr/local/bin && rm awscliv2.zip && rm -r aws
RUN aws --version

RUN curl -sSfL "https://github.com/weaveworks/eksctl/releases/download/${EKSCTL_VERSION}/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp && mv /tmp/eksctl /usr/local/bin
RUN eksctl version

RUN aws --version
RUN kubectl version --short --client
RUN eksctl version
