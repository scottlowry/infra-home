# Infra Home

This repository contains automation scripts and configuration for managing my Proxmox-based home infrastructure setup.

## Contents

### Proxmox Scripts

Located in `proxmox/scripts/`, these scripts handle various automated tasks:

- `backup.sh` - Automated backup operations
- `btc_usb.sh` - Bitcoin USB device management (runs on reboot)
- `remove_banner.sh` - Removes Proxmox subscription banner
- `ssl_no_idrac.sh` - SSL certificate management
- `transmission.sh` - Transmission torrent client management
- `update.sh` - System update automation

### Automated Tasks

The `proxmox/crontab` file defines the following scheduled tasks:

- Bitcoin USB management runs on system reboot
- Transmission management runs every 15 minutes
- System updates run daily at 1:00 AM
- SSL certificate management runs daily at 2:00 AM
- Backup operations run daily at 3:00 AM 