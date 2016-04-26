#!/bin/sh

scriptdir=$(cd `dirname $0` && pwd && cd $OLDPWD)/
docker_machine_name='default'
is_linux="$(uname | grep -i linux)"
is_windows="$(echo $TERM | grep cygwin)"
ip=''
port=22
image="anovmari/dev-env"
alias di='docker inspect --format '\''{{ .NetworkSettings.IPAddress }}'\'' '
ports=''

if [ "x$is_linux" = "x" ]
then
  ports='-P'
  eval $(docker-machine env $docker_machine_name)
fi

running_id=$(docker ps --filter="ancestor=anovmari/dev-env" --format="{{.ID}} {{.Command}} {{.Ports}}" | grep sshd | grep 22\/tcp | head -n 1 | awk '{print $1}')

if [ "x$running_id" = 'x' ]
then
  docker pull $image 1>&2
  running_id=$(docker run $ports --dns=8.8.8.8 --dns=8.8.4.4 --hostname=DEV-ENV --cap-add=NET_ADMIN --device //dev/net/tun -e "TZ=Europe/Kiev" -v "//://host" -v "//etc/localtime://etc/localtime:ro" -v //var/run/docker.sock:/var/run/docker.sock --user root --expose 22 -d $image /usr/sbin/sshd -D)
fi

if [ "x$is_linux" = "x" ]
then
  ip=$(docker-machine ip $docker_machine_name)
  port=$(docker port $running_id 22 | sed s/0.0.0.0://)
else
  ip=$(di $running_id)
fi
if [ "x$is_windows" != "x" ]
then
  echo "IP: $ip"
  echo "port: $port"
  read -p "Press [Enter] to exit..."
else
  command='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile /dev/null" -t -p '$port' ubuntu@'$ip' "tmux -2 attach || tmux -2 new"'
  if [ -t 0 ]
  then
    eval "$command"
  else
    echo "$command"
  fi
fi
