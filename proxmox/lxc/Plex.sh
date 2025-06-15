#!/bin/bash

ID=106
NAME="Plex"
IP="10.0.0.8"
MAC="D2:3B:E8:4E:F9:2B"

pct create $ID RAID:vztmpl/debian-12-standard_*.tar.zst \
  --arch amd64 \
  --hostname $NAME \
  --cores 4 \
  --memory 4096 \
  --swap 0 \
  --unprivileged 1 \
  --features nesting=1 \
  --net0 name=eth0,bridge=vmbr1,firewall=1,gw=10.0.0.1,hwaddr=${MAC},ip=${IP}/24,tag=1,type=veth \
  --rootfs local-zfs:12G \
  --mp0 /RAID/Media,mp=/mnt/Media \
  --ostype debian \
  --onboot 1

pct start $ID

pct exec $ID -- bash -c "echo 'deb https://downloads.plex.tv/repo/deb/ public main' | tee /etc/apt/sources.list.d/plexmediaserver.list"

pct exec $ID -- apt update
pct exec $ID -- apt upgrade -y

pct exec $ID -- apt install plexmediaserver -y

useradd -u 100998 -g 100998 -M -s /usr/sbin/nologin plex
groupadd -g 100998 plex
chown -R plex:plex /RAID/Media

pct exec $ID -- reboot