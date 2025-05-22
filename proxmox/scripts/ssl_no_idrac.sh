#!/bin/bash

pfSHA=$(echo | openssl s_client -showcerts -connect pfsense.lan.scottlowry.net:443 -servername pfsense.lan.scottlowry.net 2>&1 | openssl x509 -fingerprint -noout)
miniSHA=$(openssl x509 -in /root/ssl/wildcard.crt -fingerprint -noout)

function update_ssl() {
scp root@10.0.0.1:/conf/acme/wildcard* /root/ssl/

cat /root/ssl/wildcard.crt /root/ssl/wildcard.key > /rpool/data/subvol-101-disk-0/root/ssl/wildcard.combined
cp /root/ssl/wildcard.fullchain /rpool/data/subvol-101-disk-0/root/ssl/
lxc-attach 101 -- service lighttpd restart
echo "updated Pi-hole SSL"

#openssl pkcs12 -export -out /NVMe/subvol-104-disk-0/var/lib/plexmediaserver/wildcard.p12 -in /root/ssl/wildcard.crt -inkey /root/ssl/wildcard.key -passout pass:""
#chown plex:plex /NVMe/subvol-104-disk-0/var/lib/plexmediaserver/wildcard.p12
#lxc-attach 104 -- service plexmediaserver restart
#echo "updated Plex SSL"

cp /root/ssl/wildcard.crt /etc/pve/nodes/mini/pveproxy-ssl.pem
cp /root/ssl/wildcard.key /etc/pve/nodes/mini/pveproxy-ssl.key
echo "updated MINI SSL"
systemctl restart pveproxy.service
}

if [[ "$miniSHA" != "$pfSHA" ]]; then
update_ssl
fi