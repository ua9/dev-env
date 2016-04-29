FROM ubuntu:wily
MAINTAINER Anton Marianov <anovmari@gmail.com>
ARG USER=ubuntu
ARG COMPOSE_VERSION=1.6.2
ARG DEBIAN_FRONTEND=noninteractive
ADD ./home /home/${USER}
ADD "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-Linux-x86_64" /usr/local/bin/docker-compose
RUN apt-get update && \
  apt-get install -y wget apt-utils && \
  locale-gen "en_US.UTF-8" && \
  dpkg-reconfigure locales && \
  wget -qO- https://get.docker.com/ | sh && \
  wget -qO- https://deb.nodesource.com/setup_5.x | sh && \
  apt-get install -y inetutils-ping openssh-server vim-nox screen python && \
  apt-get install -y tmux sudo man less git curl openvpn iptables net-tools telnet && \
  apt-get install -y build-essential cmake libelf-dev libelf1 python-dev python3-dev nodejs && \
  mkdir /var/run/sshd && \
  useradd --shell=/bin/bash ${USER} && \
  echo "${USER}:1" | chpasswd && \
  adduser ${USER} sudo && \
  adduser ${USER} users && \
  adduser ${USER} docker && \
  echo "ubuntu ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ubuntu && \
  chmod a+rx /usr/local/bin/docker-compose && \
  npm install --global flow-bin && \
  chown -R ${USER}:${USER} /home/${USER} && \
  su -c 'touch /home/${USER}/.sudo_as_admin_successful' - ubuntu && \
  su -c 'git clone --depth=1 --single-branch -b master https://github.com/VundleVim/Vundle.vim.git /home/${USER}/.vim/bundle/Vundle.vim' - ubuntu && \
  su -c 'vim +PluginInstall +qall' - ubuntu && \
  su -c 'cd /home/${USER}/.vim/bundle/tern_for_vim && npm install' - ubuntu && \
  su -c 'cd /home/${USER}/.vim/bundle/vim-js-context-coloring && npm install' - ubuntu && \
  su -c 'cd /home/${USER}/.vim/bundle/YouCompleteMe && ./install.py --tern-completer' - ubuntu && \
  su -c 'mkdir /home/${USER}/mnt' - ubuntu && \
  su -c 'npm cache clean' - ubuntu && \
  su -c 'find /home/${USER}/.vim -name .git -type d -prune -exec rm -rf {} +' - ubuntu && \
  apt-get remove -y --auto-remove build-essential cmake libelf-dev python-dev python3-dev && \
  apt-get clean && \
  npm cache clean && \
  rm -rf /var/lib/apt/lists/* /tmp/*
VOLUME "/home/${USER}"
WORKDIR "/home/${USER}/mnt"
USER ${USER}
CMD ["/usr/bin/vim"]
