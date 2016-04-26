FROM ubuntu:wily
MAINTAINER Anton Marianov <anovmari@gmail.com>
ARG USER=ubuntu
ARG COMPOSE_VERSION=1.6.2
ARG DEBIAN_FRONTEND=noninteractive
ADD "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-Linux-x86_64" /usr/local/bin/docker-compose
RUN apt-get update
RUN apt-get install -y wget apt-utils
RUN locale-gen "en_US.UTF-8"
RUN dpkg-reconfigure locales
RUN wget -qO- https://get.docker.com/ | sh
RUN wget -qO- https://deb.nodesource.com/setup_5.x | sh
RUN apt-get install -y inetutils-ping openssh-server python-pip vim screen
RUN apt-get install -y tmux sudo man less git curl openvpn iptables net-tools telnet
RUN apt-get install -y build-essential cmake libelf-dev libelf1 python-dev python3-dev ruby nodejs
RUN pip install powerline-status
RUN mkdir /var/run/sshd
RUN useradd --shell=/bin/bash ${USER}
RUN echo "${USER}:1" | chpasswd
RUN adduser ${USER} sudo
RUN adduser ${USER} users
RUN adduser ${USER} docker
RUN echo "ubuntu ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ubuntu
RUN chmod a+rx /usr/local/bin/docker-compose
RUN ln -s $(pip show powerline-status | grep Location | sed s/Location:\ //) /opt/powerline-repo
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/*
RUN npm install --global flow-bin
ADD ./home /home/${USER}
RUN chown -R ${USER}:${USER} /home/${USER}
RUN su -c 'touch /home/${USER}/.sudo_as_admin_successful' - ubuntu
RUN su -c 'git clone https://github.com/VundleVim/Vundle.vim.git /home/${USER}/.vim/bundle/Vundle.vim' - ubuntu
RUN su -c 'vim +PluginInstall +qall' - ubuntu
RUN su -c 'cd /home/${USER}/.vim/bundle/tern_for_vim && npm install' - ubuntu
RUN su -c 'cd /home/${USER}/.vim/bundle/YouCompleteMe && ./install.py --tern-completer' - ubuntu
RUN su -c 'npm cache clean' - ubuntu
RUN su -c 'mkdir /home/${USER}/mnt' - ubuntu
RUN apt-get remove -y --auto-remove build-essential cmake libelf-dev python-dev python3-dev
RUN npm cache clean
VOLUME "/home/${USER}"
WORKDIR "/home/${USER}/mnt"
USER ${USER}
CMD ["/usr/bin/vim"]
