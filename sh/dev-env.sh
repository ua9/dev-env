#!/bin/sh

docker_machine_name='default'
is_linux="$(uname | grep -i linux)"
ip=''
port=22
image="dev-env"
alias di='docker inspect --format '\''{{ .NetworkSettings.IPAddress }}'\'' '

if [ "x$is_linux" = "x" ]
then
	eval $(docker-machine env $docker_machine_name)
fi

running_id=$(docker ps -q --filter="ancestor=$image")

if [ "x$running_id" = 'x' ]
then
	running_id=$(docker run -P -d $image)
fi

if [ "x$is_linux" = "x" ]
then
	ip=$(docker-machine ip $docker_machine_name)
	port=$(docker port $running_id 22 | sed s/0.0.0.0://)
else
	ip=$(di $running_id)
fi

ssh -oStrictHostKeyChecking=no -t -p $port ubuntu@$ip screen -xR