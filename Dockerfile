FROM ubuntu:bionic

LABEL maintainer="Moritz Heiber <hello@heiber.im>"

ARG VERSION="2.2.4"

RUN apt update -qq && \
  apt dist-upgrade -y && \
  apt install -y curl ca-certificates docker.io && \
  curl -o /tmp/vagrant.deb -L https://releases.hashicorp.com/vagrant/${VERSION}/vagrant_${VERSION}_x86_64.deb && \
  dpkg -i /tmp/vagrant.deb && \
  rm /tmp/vagrant.deb && \
  apt remove -y --purge curl ca-certificates && \
  apt-get autoremove -y

ENTRYPOINT ["/usr/bin/vagrant"]
