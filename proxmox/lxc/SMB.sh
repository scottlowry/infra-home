#!/bin/bash

ID=104
NAME="SMB"
IP="10.0.0.9"
MAC="E2:E2:AD:92:2B:04"

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
  --mp0 /RAID,mp=/mnt/RAID \
  --ostype debian \
  --onboot 1 \
  --startup order=4

pct start $ID

pct exec $ID -- apt update
pct exec $ID -- apt upgrade -y

pct exec $ID -- apt install samba -y

pct exec $ID -- useradd -u 1000 -g 1000 -M -s /usr/sbin/nologin raid
pct exec $ID -- groupadd -g 1000 raid

pct exec $ID -- useradd -u 107 -g 115 -M -s /usr/sbin/nologin debian-transmission
pct exec $ID -- groupadd -g 115 debian-transmission
pct exec $ID -- usermod -aG debian-transmission raid

pct exec $ID -- useradd -u 998 -g 998 -M -s /usr/sbin/nologin plex
pct exec $ID -- groupadd -g 998 plex
pct exec $ID -- usermod -aG plex raid

useradd -u 101000 -g 101000 -M -s /usr/sbin/nologin raid
groupadd -g 101000 raid
chown -R raid:raid /RAID

pct exec $ID -- reboot