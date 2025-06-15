#!/bin/bash

ID=109
NAME="PSO"
IP="10.0.0.153"
MAC="BC:24:11:45:51:3F"

pct create $ID RAID:vztmpl/debian-12-standard_*.tar.zst \
  --arch amd64 \
  --hostname $NAME \
  --cores 4 \
  --memory 512 \
  --swap 0 \
  --unprivileged 1 \
  --features nesting=1 \
  --net0 name=eth0,bridge=vmbr1,firewall=1,gw=10.0.0.1,hwaddr=${MAC},ip=${IP}/24,tag=1,type=veth \
  --rootfs local-zfs:2G \
  --ostype debian \
  --onboot 0 \

pct start $ID

pct exec $ID -- apt update
pct exec $ID -- apt upgrade -y