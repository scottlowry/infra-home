#!/bin/bash

ID=100
NAME="pfSense"
ISO="pfsense*.iso"

qm create $ID \
  --name $NAME \
  --memory 4096 \
  --cores 4 \
  --sockets 1 \
  --net0 virtio=B2:E7:5A:0C:37:9A,bridge=vmbr0 \
  --net1 virtio=CE:52:32:A5:6D:47,bridge=vmbr1 \
  --scsihw virtio-scsi-single \
  --scsi0 local-zfs:32G,discard=on,iothread=1,ssd=1 \
  --bios seabios \
  --machine i440fx \
  --ostype other \
  --ide2 RAID:iso/${ISO},media=cdrom \
  --bootdisk scsi0 \
  --boot order=ide2;scsi0 \
  --onboot 1 \
  --startup order=1

# qm start $ID