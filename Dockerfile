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
RUN go get github.com/spf13/cobra/cobra

# Installing gcloud
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN sudo apt-get update && \
	sudo apt-get install -y google-cloud-sdk

# # Node
# RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo bash -
# RUN apt-get install -y nodejs
# RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
#     && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
#     && apt-get update && sudo apt-get install yarn 	

# Setting WORKDIR and USER
USER root
WORKDIR /root

ADD .zshrc /root/.zshrc
CMD ["/bin/zsh", "-l"]
