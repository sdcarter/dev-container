FROM debian:latest

RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y git zsh vim make

## Break this out into docker chains

# Python development capabilities
RUN apt-get install -y python

# Ruby development capabilities
RUN apt-get install -y ruby ruby-dev 
RUN gem install jekyll