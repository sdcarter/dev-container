FROM debian:latest

ARG DEBIAN_FRONTEND=noninteractive

# Installing required packages
RUN apt-get update -y \
    && apt-get install --no-install-recommends -y \
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
    snapd \
    ssh \
    sudo \
    tree \
    unzip \
    vim \
    wget \
    zsh \
    && rm -rf /var/lib/apt

#### Installing Language/Interpreter Packages outside apt

# Installing + Setting Up GO Environment
ENV GOLANG_VERSION 1.16.3
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
	&& sudo tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz
ENV HOME /root
ENV GOPATH $HOME/code/go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

# Installing node
RUN curl -sL https://deb.nodesource.com/setup_current.x | sudo -E bash -
RUN sudo apt-get install -y nodejs \
    && rm -rf /var/lib/apt

#### Installing development packages

# Go packages
RUN go get -u github.com/jingweno/ccat
RUN go get -u github.com/spf13/cobra
RUN go get github.com/spf13/cobra/cobra

#### Installing devops/cloud tools

# Installing latest Terraform version
RUN curl $(curl -sL https://releases.hashicorp.com/terraform/index.json | jq -r '.versions[].builds[].url | select(.|test("alpha|beta|rc")|not) | select(.|contains("linux_amd64"))' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | tail -n1) -o terraform.zip \
    && unzip terraform.zip -d /usr/local/bin \
    && rm terraform.zip

# Installaing Docker Client and Docker Compose
RUN curl -Ssl https://get.docker.com | sh

# Installing latest gcloud sdk
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN sudo apt-get update \
	&& sudo apt-get install -y google-cloud-sdk \
    && rm -rf /var/lib/apt

# Installing latest AWS client
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sudo aws/install \
    && rm -fr aws awscliv2.zip

#### Finalizing Environment

# Setting WORKDIR and USER
USER root
WORKDIR /root

ADD .zshrc /root/.zshrc
CMD ["/bin/zsh", "-l"]
