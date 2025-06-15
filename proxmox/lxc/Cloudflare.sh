#!/bin/bash

source .env

ID=$(pvesh get /cluster/nextid)
NAME="Cloudflare"

pct create $ID RAID:vztmpl/debian-12-standard_*.tar.zst \
  --arch amd64 \
  --hostname $NAME \
  --cores 4 \
  --memory 512 \
  --swap 0 \
  --unprivileged 1 \
  --features nesting=1 \
  --net0 name=eth0,bridge=vmbr1,firewall=1,tag=1,type=veth \
  --rootfs local-zfs:2G \
  --onboot 1 \
  --ostype debian

pct start $ID

pct exec $ID -- bash -c "curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null"
pct exec $ID -- bash -c "echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared bookworm main' | tee /etc/apt/sources.list.d/cloudflared.list"

pct exec $ID -- apt update
pct exec $ID -- apt upgrade -y

pct exec $ID -- apt install cloudflared -y
pct exec $ID -- cloudflared service install $TUNNEL_ID