FROM ubuntu:20.04
LABEL maintainer="Steve Carter <steve@sdcarter.com>"
LABEL version="1.0"
LABEL description="this is my base image with various dev tools that I use on a daily basis"

ARG DEBIAN_FRONTEND=noninteractive

# Installing required packages
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y \
    apt-transport-https \
    apt-utils \
    build-essential \
    curl \
    dnsutils \
    git \
    gnupg \
    iputils-ping \
    jq \
    locate \
    make \
    netcat \
    python3 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    rsync \
    ruby-dev \
    ruby \
    snapd \
    ssh \
    sudo \
    tree \
    unzip \
    vim \
    wget \
    zsh \
    && rm -rf /var/lib/apt/lists/*

# Installaing Docker Client and Docker Compose
RUN curl -Ssl https://get.docker.com | sh

# # Installing Additional PIP based libraries
# RUN pip3 install \
#     awscli

# Installing + Setting Up GO Environment
ENV GOLANG_VERSION 1.15.5
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz

RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
	&& sudo tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz

# Setting up GOPATH. For me, i'm using $HOME/code/go
ENV HOME /root
ENV GOPATH $HOME/code/go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

# Installing Terraform 
ENV TERRAFORM_VERSION 0.13.5
RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip
RUN unzip terraform.zip  -d /usr/local/bin  
RUN rm terraform.zip

# Installing go packages
RUN go get -u github.com/jingweno/ccat
RUN go get -u github.com/spf13/cobra

# # Installing gcloud
# RUN snap install google-cloud-sdk --classic

# # Kubernetes Tools 
# ENV KUBECTL_VER 1.19.2
# RUN wget https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx -O /usr/local/bin/kubectx && chmod +x /usr/local/bin/kubectx
# RUN wget https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens -O /usr/local/bin/kubens && chmod +x /usr/local/bin/kubens
# RUN wget https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VER/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

# # Installing Helm
# ENV HELM_VERSION 3.2.0
# RUN wget https://get.helm.sh/helm-v$HELM_VERSION-linux-amd64.tar.gz -O /tmp/helm-v$HELM_VERSION-linux-amd64.tar.gz && \
#     tar -zxvf /tmp/helm-v$HELM_VERSION-linux-amd64.tar.gz && \
#     mv linux-amd64/helm /usr/local/bin/helm && \
#     chmod +x /usr/local/bin/helm

# # Calico
# ENV CALICO_VERSION 3.16.1
# RUN wget https://github.com/projectcalico/calicoctl/releases/download/v$CALICO_VERSION/calicoctl -O /usr/local/bin/calicoctl && chmod +x /usr/local/bin/calicoctl

# # Node
# RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo bash -
# RUN apt-get install -y nodejs
# RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
#     && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
#     && apt-get update && sudo apt-get install yarn 	

# # Installing Krew
# RUN curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.{tar.gz,yaml}" && \
#   tar zxvf krew.tar.gz && \
#   KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" && \
#   "$KREW" install --manifest=krew.yaml --archive=krew.tar.gz && \
#   "$KREW" update 

# # Installing eksctl

# RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp && \
#     mv /tmp/eksctl /usr/local/bin

# Setting WORKDIR and USER
USER root
WORKDIR /root
# VOLUME ["/home/dev"]

ADD .zshrc /root/.zshrc
CMD ["/bin/zsh", "-l"]
