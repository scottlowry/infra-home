#!/bin/bash

source .env

ID=$(pvesh get /cluster/nextid)
NAME="Ansible"

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

pct exec $ID -- apt update
pct exec $ID -- apt upgrade -y

pct exec $ID -- apt install ansible -y

pct exec $ID -- bash -c "echo '${ANSIBLE_SSH_PUB}' > /root/.ssh/id_ed25519.pub"
pct exec $ID -- bash -c "chmod 644 /root/.ssh/id_ed25519.pub"
pct exec $ID -- bash -c "echo '${ANSIBLE_SSH}' > /root/.ssh/id_ed25519"
pct exec $ID -- bash -c "chmod 600 /root/.ssh/id_ed25519"