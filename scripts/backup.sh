#!/bin/sh

BACKUP_PATH="/RAID/Proxmox/"
KEEP_DAYS=3
BACKUP_SET="/etc/ /root/"

tar -vczf $BACKUP_PATH$(hostname)-$(date +%m_%d_%Y).tar.gz --absolute-names $BACKUP_SET >$BACKUP_PATH$(hostname)-$(date +%m_%d_%Y).log
find $BACKUP_PATH$(hostname)-* -mindepth 0 -maxdepth 0 -depth -mtime +$KEEP_DAYS -delete 2>/dev/null