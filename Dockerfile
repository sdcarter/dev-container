FROM debian:latest

ARG DEBIAN_FRONTEND=noninteractive

### Environment software configuration

# Installing required apt packages
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

# Installaing Docker Client and Docker Compose
RUN curl -Ssl https://get.docker.com | sh \
    && rm -rf /var/lib/apt

#### Installing Language/Interpreter packages

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
RUN go get -u github.com/spf13/cobra
RUN go get github.com/spf13/cobra/cobra

#### Installing devops/cloud tools

# installing tfenv and the lateest version of terraform
RUN export GIT_SSL_NO_VERIFY=1 && git clone https://github.com/tfutils/tfenv.git ~/.tfenv
RUN ln -s ~/.tfenv/bin/* /usr/local/bin/
RUN tfenv install
RUN tfenv use $(tfenv list | head -n 1)

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

#### Finalize Environment

# Setting WORKDIR and USER
USER root
WORKDIR /root

# enabling default shell
ADD .zshrc /root/.zshrc
CMD ["/bin/zsh", "-l"]
