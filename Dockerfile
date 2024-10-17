FROM ubuntu:oracular

LABEL maintainer="Moritz Heiber <hello@heiber.im>"
LABEL org.opencontainers.image.source="https://github.com/moritzheiber/docker-vagrant"

ARG DEBIAN_FRONTEND="noninteractive"
ARG INSECURE_PUBKEY="https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub"

SHELL ["/bin/bash","-o","pipefail","-c"]

# hadolint ignore=DL3005,DL4006,DL3008,DL3009
RUN apt-get update -qq && \
  apt-get dist-upgrade -y && \
  apt-get install -y --no-install-recommends ca-certificates locales openssh-server sudo && \
  locale-gen en_US.UTF-8 && \
  useradd -d /home/vagrant -m -s /bin/bash vagrant && \
  echo vagrant:vagrant | chpasswd && \
  echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
  install -d -o vagrant -g vagrant -m0700 /home/vagrant/.ssh && \
  install -d /run/sshd && \
  rm /etc/dpkg/dpkg.cfg.d/excludes

# hadolint doesn't understand the variable is a URL
# hadolint ignore=DL3020
ADD --chown=vagrant:vagrant ${INSECURE_PUBKEY} /home/vagrant/.ssh/authorized_keys

EXPOSE 22
CMD ["/usr/sbin/sshd","-D","-o","UseDNS=no","-o","UsePAM=no","-o","PasswordAuthentication=yes","-o","UsePrivilegeSeparation=no","-o","PidFile=/run/sshd/sshd.pid"]
