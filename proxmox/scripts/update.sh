#!/bin/bash

# Import environment variables
source .env

# Update LXC containers
containers=$(pct list | tail -n +2 | awk '{print $1}')

function update_container() {
  container=$1
  echo "Updating container: $container"
  pct exec $container -- bash -lc "apt-get -qq update && apt-get upgrade -y"
}

for container in $containers; do
  status=$(pct status $container | awk '{print $2}')
  if [ "$status" == "running" ]; then
    update_container $container
  else
    pct start $container
    sleep 5
    update_container $container
    pct stop $container
  fi
done

# Update Pi-hole
pct exec 101 -- bash -lc "pihole -up"

# Update host
apt-get -qq update && apt-get upgrade -y
