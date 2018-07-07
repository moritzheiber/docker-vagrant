FROM ubuntu:bionic

LABEL maintainer="Moritz Heiber <hello@heiber.im>"
ARG DEBIAN_FRONTEND="noninteractive"
ARG INSECURE_PUBKEY="https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub"

RUN apt update -qq && \
  apt dist-upgrade -y && \
  apt install -y ca-certificates locales openssh-server sudo && \
  locale-gen en_US.UTF-8 && \
  useradd -d /home/vagrant -m -s /bin/bash vagrant && \
  echo vagrant:vagrant | chpasswd && \
  echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
  install -d -o vagrant -g vagrant -m0700 /home/vagrant/.ssh && \
  install -d /run/sshd && \
  rm /etc/dpkg/dpkg.cfg.d/excludes

ADD --chown=vagrant:vagrant ${INSECURE_PUBKEY} /home/vagrant/.ssh/authorized_keys

EXPOSE 22
CMD ["/usr/sbin/sshd","-D","-o","UseDNS=no","-o","UsePAM=no","-o","PasswordAuthentication=yes","-o","UsePrivilegeSeparation=no","-o","PidFile=/tmp/sshd.pid"]
