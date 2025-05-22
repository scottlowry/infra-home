#!/bin/bash

# Run lsusb and capture the output
lsusb_output=$(lsusb)

# Search for the line containing "Silicon Labs CP210x UART Bridge"
device_line=$(echo "$lsusb_output" | grep "Silicon Labs CP210x UART Bridge")

# Extract the Bus and Device numbers
bus_number=$(echo "$device_line" | awk '{print $2}')
device_number=$(echo "$device_line" | awk '{print $4}' | tr -d ':')

# Make LXC root owner of the device
chown 100000:100000 /dev/bus/usb/$bus_number/$device_number

# Run ls -l to get the device info
device_info=$(ls -l /dev/bus/usb/$bus_number/$device_number)

# Extract the "Major, Minor" and convert to "Major:Minor"
major_minor=$(echo "$device_info" | grep -o "[0-9]\+,[ ]*[0-9]\+")
formatted_major_minor=$(echo "$major_minor" | sed 's/, */:/' | tr -d ' ')

# Output the extracted and formatted values
#echo "Bus Number: $bus_number"
#echo "Device Number: $device_number"
#echo "Formatted Major:Minor - $formatted_major_minor"

# Path to the LXC config file for container 107
lxc_config_path="/etc/pve/lxc/107.conf"

# Update the LXC configuration file
if [[ -f "$lxc_config_path" ]]; then
    # Update lxc.cgroup.devices.allow line
    sed -i "s|^lxc.cgroup.devices.allow: c [0-9]\+:[0-9]\+ rwm|lxc.cgroup.devices.allow: c $formatted_major_minor rwm|" "$lxc_config_path"

    # Update lxc.mount.entry line
    sed -i "s|^lxc.mount.entry: /dev/bus/usb/[0-9]\+/[0-9]\+ .*|lxc.mount.entry: /dev/bus/usb/$bus_number/$device_number dev/bus/usb/$bus_number/$device_number none bind,optional,create=file|" "$lxc_config_path"

#    echo "Updated LXC config:"
#    echo " - lxc.cgroup.devices.allow: c $formatted_major_minor rwm"
#    echo " - lxc.mount.entry: /dev/bus/usb/$bus_number/$device_number dev/bus/usb/$bus_number/$device_number none bind,optional,create=file"
else
#    echo "LXC config file not found at $lxc_config_path"
    exit 1
fi