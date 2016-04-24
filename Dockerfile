FROM ubuntu:wily
MAINTAINER Anton Marianov <anovmari@gmail.com>
ARG USER=ubuntu
ARG COMPOSE_VERSION=1.6.2
ARG DEBIAN_FRONTEND=noninteractive
ADD "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-Linux-x86_64" /usr/local/bin/docker-compose
ADD ./home /home/${USER}
RUN apt-get update && \
  apt-get install -y wget apt-utils && \
  locale-gen "en_US.UTF-8" && \
  dpkg-reconfigure locales && \
  wget -qO- https://get.docker.com/ | sh && \
  wget -qO- https://deb.nodesource.com/setup_5.x | sh && \
  apt-get install -y inetutils-ping openssh-server python-pip vim screen \
    tmux sudo man less git curl openvpn iptables net-tools telnet \
    build-essential cmake libelf-dev libelf1 python-dev python3-dev ruby nodejs && \
  pip install powerline-status && \
  mkdir /var/run/sshd && \
  useradd --shell=/bin/bash ${USER} && \
  touch /home/${USER}/.sudo_as_admin_successful && \
  chown -R ${USER}:${USER} /home/${USER} && \
  echo "${USER}:1" | chpasswd && \
  adduser ${USER} sudo && \
  adduser ${USER} users && \
  adduser ${USER} docker && \
  echo "ubuntu ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ubuntu && \
  chmod a+rx /usr/local/bin/docker-compose && \
  ln -s $(pip show powerline-status | grep Location | sed s/Location:\ //) /opt/powerline-repo && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* && \
  npm install --global flow-bin && \
  su -c 'git clone https://github.com/VundleVim/Vundle.vim.git /home/${USER}/.vim/bundle/Vundle.vim' - ubuntu && \
  su -c 'vim +PluginInstall +qall' - ubuntu && \
  su -c 'cd /home/${USER}/.vim/bundle/tern_for_vim && npm install' - ubuntu && \
  su -c 'cd /home/${USER}/.vim/bundle/YouCompleteMe && ./install.py --tern-completer' - ubuntu && \
  su -c 'npm cache clean' - ubuntu && \
  apt-get remove -y --auto-remove build-essential cmake libelf-dev python-dev python3-dev && \
  npm cache clean
VOLUME "/home/${USER}"
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
