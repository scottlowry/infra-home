#!/bin/bash

# Check the Transmission HTTP service from the host with a 5-second timeout
curl -s --max-time 5 -I "http://10.0.0.6:9091" > /dev/null

# If the service has crashed, restart it and reboot the container
if [ $? -ne 0 ]; then
  pct exec 105 -- bash -lc "service transmission-daemon restart"
  sleep 5
  pct reboot 105
fi