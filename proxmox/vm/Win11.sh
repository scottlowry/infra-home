#!/bin/bash

ID=$(pvesh get /cluster/nextid)
NAME="Win11"
ISO="Win11*.iso"

qm create $ID \
  --name $NAME \
  --memory 4096 \
  --cores 4 \
  --sockets 1 \
  --cpu host \
  --machine pc-q35-9.0 \
  --bios ovmf \
  --efidisk0 local-zfs:1G,efitype=4m,pre-enrolled-keys=1 \
  --scsihw virtio-scsi-single \
  --scsi0 local-zfs:64G,discard=on,iothread=1,ssd=1 \
  --tpmstate0 local-zfs:4G,version=v2.0 \
  --net0 virtio=BC:24:11:4D:8A:18,bridge=vmbr1,firewall=1,tag=192 \
  --ide2 RAID:iso/${ISO},media=cdrom \
  --ide3 local:iso/virtio-win.iso,media=cdrom \
  --boot order=ide3;scsi0

# qm start $ID