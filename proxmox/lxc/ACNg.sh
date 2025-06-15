#!/bin/bash

ID=$(pvesh get /cluster/nextid)
NAME="ACNg"
IP="10.0.0.12"
MAC="BC:24:11:D5:5A:6A"

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
  --mp0 /RAID/Cache,mp=/var/cache/apt-cacher-ng \
  --onboot 1 \
  --ostype debian

pct start $ID

pct exec $ID -- apt update
pct exec $ID -- apt upgrade -y

pct exec $ID -- apt install apt-cacher-ng -y

useradd -u 100103 -g 100112 -M -s /usr/sbin/nologin apt-cacher-ng
groupadd -g 100112 apt-cacher-ng
chown -R apt-cacher-ng:apt-cacher-ng /RAID/Cache
