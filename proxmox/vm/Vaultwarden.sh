#!/bin/bash

ID=$(pvesh get /cluster/nextid)
NAME="Vaultwarden"
ISO="debian-12.x.x-amd64-netinst.iso"
MAC="B2:E7:5A:0C:37:9A"

qm create $ID \
  --name $NAME \
  --memory 1024 \
  --cores 4 \
  --sockets 1 \
  --net0 virtio=${MAC},bridge=vmbr1,firewall=1,tag=1 \
  --scsihw virtio-scsi-single \
  --scsi0 local-zfs:4G,discard=on,iothread=1,ssd=1 \
  --bios seabios \
  --machine i440fx \
  --ostype other \
  --ide2 RAID:iso/${ISO},media=cdrom \
  --bootdisk scsi0 \
  --boot order=ide2;scsi0 \
  --onboot 1 \

# qm start $ID