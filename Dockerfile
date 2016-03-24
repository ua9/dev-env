FROM ubuntu:trusty
ENV UBUNTU_VERSION trusty
MAINTAINER Anton Marianov <anovmari@gmail.com>
ENV USER ubuntu
ENV COMPOSE_VERSION 1.6.2
ADD "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-Linux-x86_64" /usr/local/bin/docker-compose
RUN apt-get update && \
	apt-get install -y apt-transport-https ca-certificates && \
	apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
	echo "deb https://apt.dockerproject.org/repo ubuntu-${UBUNTU_VERSION} main" >> /etc/apt/sources.list.d/docker.list && \
	apt-get update && \
	apt-get install -y openssh-server vim screen tmux sudo man less git curl docker-engine && \
	mkdir /var/run/sshd && \
	useradd --create-home --shell=/bin/bash ${USER} && \
	echo "${USER}:1" | chpasswd && \
	adduser ${USER} sudo && \
	adduser ${USER} users && \
	usermod -aG docker ${USER} && \
	chmod a+x /usr/local/bin/docker-compose
VOLUME "/home/${USER}"
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]