#!/bin/bash

ID=105
NAME="Transmission"
IP="172.16.0.6"
MAC="02:17:14:2A:D4:7F"

pct create $ID RAID:vztmpl/debian-12-standard_*.tar.zst \
  --arch amd64 \
  --hostname $NAME \
  --cores 4 \
  --memory 4096 \
  --swap 0 \
  --unprivileged 1 \
  --features nesting=1 \
  --net0 name=eth0,bridge=vmbr1,firewall=1,gw=172.16.0.1,hwaddr=${MAC},ip=${IP}/24,tag=172,type=veth \
  --nameserver 172.16.0.1 \
  --rootfs local-zfs:2G \
  --mp0 /RAID/Torrents,mp=/mnt/Torrents \
  --ostype debian \
  --onboot 1

pct start $ID

pct exec $ID -- apt update
pct exec $ID -- apt upgrade -y

pct exec $ID -- apt install transmission-daemon -y

useradd -u 100107 -g 100115 -M -s /usr/sbin/nologin debian-transmission
groupadd -g 100115 debian-transmission
chown -R debian-transmission:debian-transmission /RAID/Torrents

pct exec $ID -- reboot