FROM ubuntu:wily
ARG UBUNTU_VERSION=wily
MAINTAINER Anton Marianov <anovmari@gmail.com>
ARG USER=ubuntu
ARG COMPOSE_VERSION=1.6.2
ARG DEBIAN_FRONTEND=noninteractive
ADD "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-Linux-x86_64" /usr/local/bin/docker-compose
ADD ./home /home/${USER}
RUN locale-gen "en_US.UTF-8" && \
	dpkg-reconfigure locales && \
  wget -qO- https://get.docker.com/ | sh && \
  wget -qO- https://deb.nodesource.com/setup_5.x | sh && \
	apt-get install -y openssh-server python-pip vim screen tmux sudo man less git curl openvpn iptables telnet build-essential cmake libelf-dev python-dev python3-dev ruby nodejs && \
	pip install powerline-status && \
	mkdir /var/run/sshd && \
	useradd --shell=/bin/bash ${USER} && \
	touch /home/${USER}/.sudo_as_admin_successful && \
	chown -R ${USER}:${USER} /home/${USER} && \
	echo "${USER}:1" | chpasswd && \
	adduser ${USER} sudo && \
	adduser ${USER} users && \
	usermod -aG docker ${USER} && \
	chmod a+rx /usr/local/bin/docker-compose && \
	ln -s $(pip show powerline-status | grep Location | sed s/Location:\ //) /opt/powerline-repo && \
	apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*
USER ubuntu
RUN brew install flow && \
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
  vim +PluginInstall +qall &&
  cd ~/.vim/bundle/tern_for_vim &&
  npm install && \
  cd ~/.vim/bundle/YouCompleteMe && \
  ./install.py --tern-completer
VOLUME "/home/${USER}"
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
