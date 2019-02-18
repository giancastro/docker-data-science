FROM ubuntu:16.04

# Update OS dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -yq dist-upgrade \
 && rm -rf /var/lib/apt/lists/*
