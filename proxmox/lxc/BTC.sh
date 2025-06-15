#!/bin/bash

ID=$(pvesh get /cluster/nextid)
NAME="BTC"

pct create $ID RAID:vztmpl/debian-12-standard_*.tar.zst \
  --arch amd64 \
  --hostname $NAME \
  --cores 4 \
  --memory 512 \
  --swap 0 \
  --unprivileged 1 \
  --features nesting=1 \
  --net0 name=eth0,bridge=vmbr1,firewall=1,tag=20,type=veth \
  --nameserver 10.20.0.1 \
  --rootfs local-zfs:2G \
  --onboot 1 \
  --ostype debian

pct start $ID

pct exec $ID -- apt update
pct exec $ID -- apt upgrade -y