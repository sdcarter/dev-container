FROM debian:latest

RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y git zsh vim make
