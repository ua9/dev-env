FROM ubuntu:xenial
MAINTAINER Anton Marianov <anovmari@gmail.com>
ARG USER=ubuntu
ARG DEBIAN_FRONTEND=noninteractive
ADD ./home /home/${USER}
RUN  apt-get -y update && \
  apt-get -y upgrade && \
  apt-get -y install wget apt-utils && \
  locale-gen "en_US.UTF-8" && \
  dpkg-reconfigure locales && \
  wget -qO- https://get.docker.com/ | sh && \
  wget -qO- https://deb.nodesource.com/setup_6.x | sh && \
  apt-get -y install inetutils-ping openssh-server vim-nox screen python git-core \
    tmux sudo man less git curl openvpn iptables net-tools telnet bash-completion \
    build-essential cmake libelf-dev libelf1 python-dev nodejs dnsutils libpython2.7
    ftp traceroute && \
  curl -sSL https://github.com/docker/compose/releases/download/$(git ls-remote -t -q \
    https://github.com/docker/compose.git | awk '{print $2}' | \
    sed 's/refs\/tags\///' | grep -v 'rc' | sort -hr | \
    head -1)/docker-compose-$(uname -s)-$(uname -m) > /usr/local/bin/docker-compose && \
  chmod a+x /usr/local/bin/docker-compose && \
  mkdir /var/run/sshd && \
  useradd --shell=/bin/bash ${USER} && \
  echo "${USER}:1" | chpasswd && \
  adduser ${USER} sudo && \
  adduser ${USER} users && \
  adduser ${USER} docker && \
  adduser ${USER} staff && \
  echo "ubuntu ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ubuntu && \
  chmod a+rx /usr/local/bin/docker-compose && \
  npm install --global flow-bin && \
  chown -R ${USER}:${USER} /home/${USER} && \
  sudo -u ${USER} -i /bin/bash -c 'cd ~; \
    touch .sudo_as_admin_successful; \
    git clone --depth=1 --single-branch -b master https://github.com/VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim; \
    vim +PluginInstall +qall; \
    cd .vim/bundle/tern_for_vim && npm install && cd -; \
    cd .vim/bundle/vim-js-context-coloring && npm install && cd -; \
    cd .vim/bundle/YouCompleteMe && ./install.py --tern-completer && cd -; \
    curl -sL https://download.getcarina.com/dvm/latest/install.sh | sh; \
    npm cache clean; \
    find .vim -name .git -type d -prune -exec rm -rf {} +' && \
  apt-get remove -y --auto-remove build-essential cmake libelf-dev python-dev && \
  apt-get clean && \
  npm cache clean && \
  rm -rf /var/lib/apt/lists/* /tmp/*
USER ${USER}
CMD ["/usr/bin/vim"]
