alias dev='eval "$(curl -sSL http://bit.ly/dev-env | sh)"'
function forward_docker_port(){
  running_id=$(docker ps --filter="ancestor=anovmari/dev-env" --format="{{.ID}} {{.Command}} {{.Ports}}" | grep sshd | grep 22\/tcp | head -n 1 | awk '{print $1}')
  host_ip=$(docker inspect --format='{{(index (index .NetworkSettings.Ports "22/tcp") 0).HostIp}}' $running_id)
  host_port=$(docker inspect --format='{{(index (index .NetworkSettings.Ports "22/tcp") 0).HostPort}}' $running_id)
  docker_ip=$(docker inspect --format='{{.NetworkSettings.IPAddress}}' $running_id)
  
  ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile /dev/null" -l ubuntu $host_ip -p $host_port -N -f -L $2:$docker_ip:$1
}
