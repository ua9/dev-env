FROM ubuntu:wily
ARG UBUNTU_VERSION=wily
MAINTAINER Anton Marianov <anovmari@gmail.com>
ARG USER=ubuntu
ARG COMPOSE_VERSION=1.6.2
ARG DEBIAN_FRONTEND=noninteractive
ADD "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-Linux-x86_64" /usr/local/bin/docker-compose
ADD ./home /home/${USER}
RUN apt-get update && \
	locale-gen "en_US.UTF-8" && \
	dpkg-reconfigure locales && \
	apt-get install -y apt-transport-https ca-certificates && \
	apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
	echo "deb https://apt.dockerproject.org/repo ubuntu-${UBUNTU_VERSION} main" >> /etc/apt/sources.list.d/docker.list && \
	apt-get update && \
	apt-get install -y openssh-server python-pip vim screen tmux sudo man less git curl docker-engine openvpn iptables telnet && \
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
VOLUME "/home/${USER}"
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
