FROM ubuntu:16.04
MAINTAINER Anton Marianov <anovmari@gmail.com>

RUN apt-get update && apt-get install -y openssh-server vim screen tmux sudo man less git
RUN mkdir /var/run/sshd
RUN useradd --create-home --shell=/bin/bash ubuntu
RUN echo 'ubuntu:1' | chpasswd
RUN hostname DEV-ENV
VOLUME "/home/ubuntu"
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]