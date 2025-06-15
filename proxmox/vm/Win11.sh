#!/bin/bash

ID=$(pvesh get /cluster/nextid)
NAME="Win11"
ISO="Win11.iso"

qm create $ID \
  --name $NAME \
  --memory 4096 \
  --cores 4 \
  --sockets 1 \
  --cpu host \
  --machine pc-q35-9.0 \
  --bios ovmf \
  --ostype win11 \
  --numa 0 \
  --efidisk0 local-zfs:1M,efitype=4m,pre-enrolled-keys=1 \
  --scsihw virtio-scsi-single \
  --scsi0 local-zfs:64G,discard=on,iothread=1,ssd=1 \
  --tpmstate0 local-zfs:4M,version=v2.0 \
  --net0 virtio,bridge=vmbr1,firewall=1,tag=192 \
  --ide2 RAID:iso/${ISO},media=cdrom \
  --ide3 RAID:iso/virtio-win.iso,media=cdrom \
  --boot order=ide2;scsi0 \
  --agent 1

# qm start $ID